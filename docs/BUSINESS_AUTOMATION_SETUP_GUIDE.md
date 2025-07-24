# Bill Sloth Business Automation Setup Guide

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [VRBO API Setup](#vrbo-api-setup)
4. [Docker Services Configuration](#docker-services-configuration)
5. [Database Setup](#database-setup)
6. [Guest Communication Setup](#guest-communication-setup)
7. [Analytics Configuration](#analytics-configuration)
8. [Backup System Setup](#backup-system-setup)
9. [Monitoring and Alerts](#monitoring-and-alerts)
10. [Troubleshooting](#troubleshooting)

## Overview

The Bill Sloth Business Automation system provides comprehensive automation for:
- VRBO property management with built-in messaging
- Business partnership tracking and commission management
- Guest communication automation
- Business analytics and reporting
- Automated backups and monitoring

## Prerequisites

### System Requirements
- Linux (Ubuntu 20.04+ recommended)
- Docker and Docker Compose installed
- PostgreSQL 15+
- Redis 7+
- Python 3.10+
- At least 4GB RAM
- 20GB free disk space

### Required Accounts
- VRBO/Expedia Partner Central account with API access
- Email account for notifications (Gmail recommended)
- Cloud storage account for backups (optional)

## VRBO API Setup

### 1. Obtain API Credentials

1. Log into [Expedia Partner Central](https://partners.expediagroup.com)
2. Navigate to **API Access** → **Credentials**
3. Create new API credentials for "Property Management API"
4. Save your `client_id` and `client_secret`

### 2. Configure VRBO Integration

```bash
# Initialize VRBO integration
cd ~/bill-sloth
source lib/vrbo_api_enhanced.sh

# Edit credentials file
nano ~/.bill-sloth/vrbo/credentials.json
```

Update the credentials file:
```json
{
  "api_type": "expedia_partner",
  "client_id": "YOUR_CLIENT_ID_HERE",
  "client_secret": "YOUR_CLIENT_SECRET_HERE",
  "username": "your_vrbo_username",
  "password": "your_vrbo_password",
  "property_ids": ["VRBO123456", "VRBO789012"],
  "webhook_url": "https://yourdomain.com/webhooks/vrbo",
  "test_mode": false,
  "rate_limit": {
    "requests_per_minute": 60,
    "requests_per_hour": 1000
  },
  "retry_config": {
    "max_retries": 3,
    "retry_delay": 5,
    "backoff_multiplier": 2,
    "retry_on_status": [429, 500, 502, 503, 504]
  },
  "notification_settings": {
    "email_on_error": true,
    "email_on_new_booking": true,
    "webhook_on_update": false
  }
}
```

### 3. Test API Connection

```bash
# Test authentication
./lib/vrbo_api_enhanced.sh auth

# Sync properties
./lib/vrbo_api_enhanced.sh sync-properties

# Check API health
./lib/vrbo_api_enhanced.sh health
```

## Docker Services Configuration

### 1. Environment Configuration

Create `.env` file in project root:
```bash
cat > .env << 'EOF'
# Database Configuration
POSTGRES_DB=bill_business
POSTGRES_USER=bill
POSTGRES_PASSWORD=sloth_secure_2025
DATABASE_URL=postgresql://bill:sloth_secure_2025@postgres:5432/bill_business

# Redis Configuration
REDIS_URL=redis://redis:6379

# VRBO API Configuration
VRBO_CLIENT_ID=your_client_id_here
VRBO_CLIENT_SECRET=your_client_secret_here

# Email Configuration (for guest communication)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM=Bill Sloth <your_email@gmail.com>

# Grafana Configuration
GF_SECURITY_ADMIN_PASSWORD=bill_sloth_2025
GF_USERS_ALLOW_SIGN_UP=false

# Timezone
TZ=America/New_York
EOF
```

### 2. Docker Compose Configuration

The main `docker-compose.yml` is already configured. Additional service-specific configs:

```bash
# Create Grafana datasources configuration
mkdir -p config/grafana/datasources
cat > config/grafana/datasources/postgres.yml << 'EOF'
apiVersion: 1

datasources:
  - name: PostgreSQL
    type: postgres
    url: postgres:5432
    database: bill_business
    user: bill
    secureJsonData:
      password: sloth_secure_2025
    jsonData:
      sslmode: disable
      maxOpenConns: 0
      maxIdleConns: 2
      connMaxLifetime: 14400
      postgresVersion: 1500
EOF
```

### 3. Start Services

```bash
# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f vrbo-automation
docker-compose logs -f guest-comms
docker-compose logs -f analytics
```

## Database Setup

### 1. Initialize Database Schema

```bash
# Connect to database
docker exec -it bill-postgres psql -U bill -d bill_business

# Or use local psql
psql postgresql://bill:sloth_secure_2025@localhost:5432/bill_business
```

Run initialization script:
```sql
-- Create schema for business data
CREATE SCHEMA IF NOT EXISTS business;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Grant permissions
GRANT ALL ON SCHEMA business TO bill;
GRANT ALL ON SCHEMA analytics TO bill;

-- Create performance indexes
CREATE INDEX CONCURRENTLY idx_bookings_date_range 
ON bookings(check_in, check_out) 
WHERE booking_status = 'confirmed';

CREATE INDEX CONCURRENTLY idx_properties_active 
ON properties(vrbo_property_id) 
WHERE sync_status = 'active';

-- Create materialized views for analytics
CREATE MATERIALIZED VIEW analytics.daily_revenue AS
SELECT 
    DATE(check_in) as booking_date,
    property_id,
    COUNT(*) as bookings,
    SUM(total_amount) as revenue,
    AVG(nights) as avg_nights
FROM bookings
WHERE booking_status = 'confirmed'
GROUP BY DATE(check_in), property_id;

-- Create refresh function
CREATE OR REPLACE FUNCTION refresh_analytics_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY analytics.daily_revenue;
END;
$$ LANGUAGE plpgsql;
```

### 2. Import Existing Data

If you have existing VRBO data:
```bash
# Export from old system
pg_dump old_database > vrbo_backup.sql

# Import relevant tables
psql postgresql://bill:sloth_secure_2025@localhost:5432/bill_business < vrbo_backup.sql
```

## Guest Communication Setup

### 1. Configure Message Templates

Access the guest communication service:
```bash
# Check service is running
curl http://localhost:8001/health

# View available templates
curl http://localhost:8001/templates
```

### 2. Customize Templates

Create custom templates via API:
```bash
# Create welcome message template
curl -X POST http://localhost:8001/templates \
  -H "Content-Type: application/json" \
  -d '{
    "name": "custom_welcome",
    "type": "welcome",
    "subject": "Welcome to {{property_name}} - Important Information",
    "body": "Your custom welcome message here...",
    "variables": ["property_name", "guest_name", "check_in_date"],
    "active": true
  }'
```

### 3. Set Up Automated Messaging Schedule

Configure when messages are sent:
```json
{
  "welcome_message": {
    "timing": "immediate",
    "condition": "booking_confirmed"
  },
  "checkin_instructions": {
    "timing": "-24 hours",
    "condition": "before_checkin"
  },
  "checkout_reminder": {
    "timing": "0 hours",
    "condition": "checkout_day"
  },
  "review_request": {
    "timing": "+24 hours",
    "condition": "after_checkout"
  }
}
```

## Analytics Configuration

### 1. Set Up Grafana Dashboards

1. Access Grafana: http://localhost:3000
2. Login: admin / bill_sloth_2025
3. Import dashboard configurations:

```bash
# Download pre-configured dashboards
mkdir -p config/grafana/dashboards

# VRBO Property Performance Dashboard
cat > config/grafana/dashboards/property_performance.json << 'EOF'
{
  "dashboard": {
    "title": "VRBO Property Performance",
    "panels": [
      {
        "title": "Revenue Trend",
        "targets": [{
          "rawSql": "SELECT check_in::date as time, SUM(total_amount) as revenue FROM bookings WHERE $__timeFilter(check_in) GROUP BY 1 ORDER BY 1"
        }]
      },
      {
        "title": "Occupancy Rate",
        "targets": [{
          "rawSql": "SELECT date::date as time, (COUNT(*)::float / COUNT(DISTINCT property_id)) * 100 as occupancy FROM bookings WHERE $__timeFilter(date) GROUP BY 1"
        }]
      }
    ]
  }
}
EOF
```

### 2. Configure Analytics Alerts

Set up alerts for key metrics:
```yaml
# config/alerts/business_alerts.yml
alerts:
  - name: "Low Occupancy Alert"
    condition: "occupancy_rate < 50"
    window: "7 days"
    action: "email"
    
  - name: "Revenue Drop Alert"
    condition: "revenue_change < -20%"
    window: "30 days"
    action: "email,slack"
    
  - name: "New Booking Alert"
    condition: "new_booking"
    action: "notification"
```

## Backup System Setup

### 1. Configure Automated Backups

```bash
# Edit backup configuration
nano ~/.bill-sloth/backups/config/backup_config.json
```

Add your business-specific backup sets:
```json
{
  "backup_sets": {
    "vrbo_critical": {
      "description": "Critical VRBO data and configurations",
      "sources": [
        "~/.bill-sloth/vrbo/",
        "~/VacationRental/",
        "/var/lib/docker/volumes/postgres-data/"
      ],
      "exclude_patterns": ["*.log", "*.tmp", "*cache*"],
      "retention_days": 90,
      "compression": true,
      "encryption": true
    },
    "business_documents": {
      "description": "Business partnerships and documents",
      "sources": [
        "~/edboigames_business/",
        "~/.bill-sloth/partnerships/"
      ],
      "retention_days": 365,
      "compression": true,
      "encryption": false
    }
  },
  "schedules": {
    "daily_vrbo": {
      "backup_set": "vrbo_critical",
      "type": "incremental",
      "time": "02:00",
      "enabled": true
    },
    "weekly_full": {
      "backup_set": "vrbo_critical",
      "type": "full",
      "day": "sunday",
      "time": "01:00",
      "enabled": true
    }
  }
}
```

### 2. Set Up Cloud Sync (Optional)

For offsite backups:
```bash
# Install rclone
curl https://rclone.org/install.sh | sudo bash

# Configure cloud provider
rclone config

# Test sync
rclone sync ~/.bill-sloth/backups/local/full/ dropbox:BillSlothBackups/
```

## Monitoring and Alerts

### 1. System Health Monitoring

Create monitoring script:
```bash
cat > ~/bill-sloth/scripts/monitor_services.sh << 'EOF'
#!/bin/bash
# Health check for all services

services=("vrbo-automation" "guest-comms" "analytics" "postgres" "redis")

for service in "${services[@]}"; do
    if docker-compose ps | grep -q "$service.*Up"; then
        echo "✅ $service is running"
    else
        echo "❌ $service is down!"
        # Send alert
        ./lib/notification_system.sh send_alert "Service $service is down"
    fi
done

# Check API health
curl -s http://localhost:8000/health || echo "❌ VRBO API service not responding"
curl -s http://localhost:8001/health || echo "❌ Guest communication service not responding"
curl -s http://localhost:8002/health || echo "❌ Analytics service not responding"
EOF

chmod +x ~/bill-sloth/scripts/monitor_services.sh
```

### 2. Set Up Cron Jobs

```bash
# Edit crontab
crontab -e

# Add monitoring and maintenance tasks
# Health check every 5 minutes
*/5 * * * * /home/bill/bill-sloth/scripts/monitor_services.sh

# Daily VRBO sync at 3 AM
0 3 * * * cd /home/bill/bill-sloth && ./lib/vrbo_api_enhanced.sh sync-properties
30 3 * * * cd /home/bill/bill-sloth && ./lib/vrbo_api_enhanced.sh sync-bookings

# Weekly analytics aggregation
0 2 * * 0 docker exec bill-postgres psql -U bill -d bill_business -c "SELECT refresh_analytics_views();"

# Daily backup
0 2 * * * /home/bill/bill-sloth/lib/backup_management.sh create_backup vrbo_critical incremental
```

## Troubleshooting

### Common Issues and Solutions

#### 1. VRBO API Authentication Fails
```bash
# Check credentials
cat ~/.bill-sloth/vrbo/credentials.json | jq .

# Test with curl
curl -X POST https://api.expediapartnercentral.com/authentication/v1/token \
  -d "grant_type=client_credentials&client_id=YOUR_ID&client_secret=YOUR_SECRET"

# Check logs
tail -f ~/.bill-sloth/vrbo/logs/vrbo_api.log
```

#### 2. Database Connection Issues
```bash
# Test connection
docker exec bill-postgres pg_isready

# Check PostgreSQL logs
docker logs bill-postgres

# Restart database
docker-compose restart postgres
```

#### 3. Guest Messages Not Sending
```bash
# Check message queue
docker exec bill-redis redis-cli ZCARD message_queue

# View failed messages
docker exec bill-redis redis-cli LRANGE failed_messages 0 -1

# Check communication service logs
docker logs bill-guest-comms --tail 100
```

#### 4. Analytics Not Updating
```bash
# Refresh materialized views manually
docker exec bill-postgres psql -U bill -d bill_business \
  -c "REFRESH MATERIALIZED VIEW CONCURRENTLY analytics.daily_revenue;"

# Check cache
docker exec bill-redis redis-cli KEYS "dashboard:*"

# Clear cache if needed
docker exec bill-redis redis-cli FLUSHDB
```

### Performance Optimization

#### 1. Database Optimization
```sql
-- Analyze tables for query optimization
ANALYZE bookings;
ANALYZE properties;

-- Check slow queries
SELECT query, calls, mean_exec_time
FROM pg_stat_statements
WHERE mean_exec_time > 1000
ORDER BY mean_exec_time DESC
LIMIT 10;
```

#### 2. Redis Memory Management
```bash
# Check memory usage
docker exec bill-redis redis-cli INFO memory

# Set memory limit
docker exec bill-redis redis-cli CONFIG SET maxmemory 1gb
docker exec bill-redis redis-cli CONFIG SET maxmemory-policy allkeys-lru
```

### Backup Recovery

#### Restore from Backup
```bash
# List available backups
ls -la ~/.bill-sloth/backups/local/full/

# Restore specific backup
./lib/backup_management.sh restore_backup backup_20250124_020000_vrbo_critical

# Restore database
docker exec -i bill-postgres psql -U bill -d bill_business < backup.sql
```

## Support and Resources

- Project Documentation: `/docs/BILL_SLOTH_GIGA_DOC.md`
- API Reference: `/docs/api/`
- Community Forum: [Coming Soon]
- Emergency Support: Check `~/.bill-sloth/emergency_contacts.txt`

Remember: The system is designed to be self-healing and will attempt to recover from most errors automatically. Check logs and monitoring dashboards regularly to ensure smooth operation.