#!/usr/bin/env python3
"""
Bill Sloth Service Health Monitor
Comprehensive monitoring and validation of Docker services and API endpoints
"""

import asyncio
import aiohttp
import psutil
import docker
import sqlite3
import logging
import json
import time
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, asdict
from pathlib import Path
import smtplib
from email.mime.text import MimeText
from email.mime.multipart import MimeMultipart
import requests

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/app/logs/health_monitor.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

@dataclass
class ServiceHealth:
    service_name: str
    status: str  # 'healthy', 'degraded', 'unhealthy', 'unknown'
    response_time_ms: Optional[float]
    error_message: Optional[str]
    last_check: str
    uptime_seconds: Optional[float]
    memory_usage_mb: Optional[float]
    cpu_usage_percent: Optional[float]

@dataclass
class SystemMetrics:
    timestamp: str
    cpu_percent: float
    memory_percent: float
    disk_percent: float
    docker_containers_running: int
    docker_containers_total: int
    active_connections: int

class HealthMonitor:
    def __init__(self):
        self.docker_client = docker.from_env()
        self.db_path = "/app/data/health_monitor.db"
        Path(self.db_path).parent.mkdir(parents=True, exist_ok=True)
        self.init_database()
        
        # Service endpoints to monitor
        self.service_endpoints = {
            "vrbo-automation": "http://localhost:8001/health",
            "revenue-analytics": "http://localhost:8002/health", 
            "guest-communication": "http://localhost:8003/health",
            "grafana": "http://localhost:3000/api/health",
            "postgres": "postgresql://bill:sloth_secure_2025@localhost:5432/bill_business",
            "redis": "redis://localhost:6379"
        }
        
        # Alert thresholds
        self.alert_config = {
            "response_time_threshold_ms": 5000,
            "cpu_threshold_percent": 80,
            "memory_threshold_percent": 85,
            "disk_threshold_percent": 90,
            "service_downtime_threshold_minutes": 5
        }
        
        # Notification settings
        self.notification_config = {
            "email_enabled": False,  # Set to True when configured
            "slack_enabled": False,  # Set to True when configured
            "email_recipients": ["admin@billsloth.local"],
            "slack_webhook": None
        }
    
    def init_database(self):
        """Initialize health monitoring database"""
        with sqlite3.connect(self.db_path) as conn:
            conn.executescript("""
                CREATE TABLE IF NOT EXISTS service_health_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    service_name TEXT NOT NULL,
                    status TEXT NOT NULL,
                    response_time_ms REAL,
                    error_message TEXT,
                    uptime_seconds REAL,
                    memory_usage_mb REAL,
                    cpu_usage_percent REAL,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS system_metrics_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    cpu_percent REAL NOT NULL,
                    memory_percent REAL NOT NULL,
                    disk_percent REAL NOT NULL,
                    docker_containers_running INTEGER,
                    docker_containers_total INTEGER,
                    active_connections INTEGER,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS alerts_history (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    alert_type TEXT NOT NULL,
                    service_name TEXT,
                    severity TEXT NOT NULL,
                    message TEXT NOT NULL,
                    resolved BOOLEAN DEFAULT FALSE,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    resolved_timestamp TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS monitoring_config (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    config_key TEXT UNIQUE NOT NULL,
                    config_value TEXT NOT NULL,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                -- Create indexes
                CREATE INDEX IF NOT EXISTS idx_service_health_timestamp 
                ON service_health_history(timestamp);
                CREATE INDEX IF NOT EXISTS idx_service_health_service 
                ON service_health_history(service_name);
                CREATE INDEX IF NOT EXISTS idx_system_metrics_timestamp 
                ON system_metrics_history(timestamp);
                CREATE INDEX IF NOT EXISTS idx_alerts_timestamp 
                ON alerts_history(timestamp);
            """)
        logger.info("Health monitor database initialized")
    
    async def check_http_endpoint(self, service_name: str, url: str) -> ServiceHealth:
        """Check HTTP/HTTPS endpoint health"""
        start_time = time.time()
        
        try:
            timeout = aiohttp.ClientTimeout(total=10)
            async with aiohttp.ClientSession(timeout=timeout) as session:
                async with session.get(url) as response:
                    response_time = (time.time() - start_time) * 1000
                    
                    if response.status == 200:
                        status = "healthy"
                        error_message = None
                    elif response.status < 500:
                        status = "degraded"
                        error_message = f"HTTP {response.status}"
                    else:
                        status = "unhealthy"
                        error_message = f"HTTP {response.status}"
                    
                    return ServiceHealth(
                        service_name=service_name,
                        status=status,
                        response_time_ms=response_time,
                        error_message=error_message,
                        last_check=datetime.now().isoformat(),
                        uptime_seconds=None,
                        memory_usage_mb=None,
                        cpu_usage_percent=None
                    )
        
        except asyncio.TimeoutError:
            return ServiceHealth(
                service_name=service_name,
                status="unhealthy",
                response_time_ms=None,
                error_message="Connection timeout",
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
        except Exception as e:
            return ServiceHealth(
                service_name=service_name,
                status="unhealthy",
                response_time_ms=None,
                error_message=str(e),
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
    
    def check_database_connection(self, service_name: str, connection_string: str) -> ServiceHealth:
        """Check database connection health"""
        start_time = time.time()
        
        try:
            if connection_string.startswith("postgresql://"):
                import psycopg2
                conn = psycopg2.connect(connection_string)
                cursor = conn.cursor()
                cursor.execute("SELECT 1")
                cursor.fetchone()
                conn.close()
                
            elif connection_string.startswith("redis://"):
                import redis
                r = redis.from_url(connection_string)
                r.ping()
            
            response_time = (time.time() - start_time) * 1000
            
            return ServiceHealth(
                service_name=service_name,
                status="healthy",
                response_time_ms=response_time,
                error_message=None,
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
        
        except Exception as e:
            return ServiceHealth(
                service_name=service_name,
                status="unhealthy",
                response_time_ms=None,
                error_message=str(e),
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
    
    def check_docker_container(self, container_name: str) -> ServiceHealth:
        """Check Docker container health"""
        try:
            container = self.docker_client.containers.get(container_name)
            
            # Get container stats
            stats = container.stats(stream=False)
            
            # Calculate CPU usage
            cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                       stats['precpu_stats']['cpu_usage']['total_usage']
            system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                          stats['precpu_stats']['system_cpu_usage']
            cpu_usage = (cpu_delta / system_delta) * 100.0 if system_delta > 0 else 0
            
            # Calculate memory usage
            memory_usage = stats['memory_stats']['usage'] / (1024 * 1024)  # MB
            
            # Get uptime
            created = datetime.fromisoformat(container.attrs['Created'].replace('Z', '+00:00'))
            uptime = (datetime.now(created.tzinfo) - created).total_seconds()
            
            status = "healthy" if container.status == "running" else "unhealthy"
            
            return ServiceHealth(
                service_name=container_name,
                status=status,
                response_time_ms=None,
                error_message=None if status == "healthy" else f"Container status: {container.status}",
                last_check=datetime.now().isoformat(),
                uptime_seconds=uptime,
                memory_usage_mb=memory_usage,
                cpu_usage_percent=cpu_usage
            )
        
        except docker.errors.NotFound:
            return ServiceHealth(
                service_name=container_name,
                status="unhealthy",
                response_time_ms=None,
                error_message="Container not found",
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
        except Exception as e:
            return ServiceHealth(
                service_name=container_name,
                status="unknown",
                response_time_ms=None,
                error_message=str(e),
                last_check=datetime.now().isoformat(),
                uptime_seconds=None,
                memory_usage_mb=None,
                cpu_usage_percent=None
            )
    
    def collect_system_metrics(self) -> SystemMetrics:
        """Collect system-wide metrics"""
        try:
            # System metrics
            cpu_percent = psutil.cpu_percent(interval=1)
            memory = psutil.virtual_memory()
            disk = psutil.disk_usage('/')
            
            # Docker metrics
            containers = self.docker_client.containers.list(all=True)
            running_containers = len([c for c in containers if c.status == 'running'])
            total_containers = len(containers)
            
            # Network connections
            connections = len(psutil.net_connections())
            
            return SystemMetrics(
                timestamp=datetime.now().isoformat(),
                cpu_percent=cpu_percent,
                memory_percent=memory.percent,
                disk_percent=disk.percent,
                docker_containers_running=running_containers,
                docker_containers_total=total_containers,
                active_connections=connections
            )
        
        except Exception as e:
            logger.error(f"Error collecting system metrics: {e}")
            return SystemMetrics(
                timestamp=datetime.now().isoformat(),
                cpu_percent=0,
                memory_percent=0,
                disk_percent=0,
                docker_containers_running=0,
                docker_containers_total=0,
                active_connections=0
            )
    
    async def check_all_services(self) -> List[ServiceHealth]:
        """Check health of all monitored services"""
        health_results = []
        
        # Check HTTP endpoints
        for service_name, url in self.service_endpoints.items():
            if url.startswith(("http://", "https://")):
                health = await self.check_http_endpoint(service_name, url)
                health_results.append(health)
            elif url.startswith(("postgresql://", "redis://")):
                health = self.check_database_connection(service_name, url)
                health_results.append(health)
        
        # Check Docker containers
        try:
            containers = self.docker_client.containers.list(all=True)
            for container in containers:
                if container.name.startswith("bill-"):
                    health = self.check_docker_container(container.name)
                    health_results.append(health)
        except Exception as e:
            logger.error(f"Error checking Docker containers: {e}")
        
        return health_results
    
    def save_health_data(self, health_results: List[ServiceHealth], system_metrics: SystemMetrics):
        """Save health and metrics data to database"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                # Save service health
                for health in health_results:
                    conn.execute("""
                        INSERT INTO service_health_history 
                        (service_name, status, response_time_ms, error_message, 
                         uptime_seconds, memory_usage_mb, cpu_usage_percent)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    """, (
                        health.service_name, health.status, health.response_time_ms,
                        health.error_message, health.uptime_seconds,
                        health.memory_usage_mb, health.cpu_usage_percent
                    ))
                
                # Save system metrics
                conn.execute("""
                    INSERT INTO system_metrics_history 
                    (cpu_percent, memory_percent, disk_percent, 
                     docker_containers_running, docker_containers_total, active_connections)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (
                    system_metrics.cpu_percent, system_metrics.memory_percent,
                    system_metrics.disk_percent, system_metrics.docker_containers_running,
                    system_metrics.docker_containers_total, system_metrics.active_connections
                ))
        
        except Exception as e:
            logger.error(f"Error saving health data: {e}")
    
    def check_alerts(self, health_results: List[ServiceHealth], system_metrics: SystemMetrics):
        """Check for alert conditions and trigger notifications"""
        alerts = []
        
        # Service health alerts
        for health in health_results:
            if health.status == "unhealthy":
                alerts.append({
                    "type": "service_down",
                    "service": health.service_name,
                    "severity": "critical",
                    "message": f"Service {health.service_name} is unhealthy: {health.error_message}"
                })
            elif health.response_time_ms and health.response_time_ms > self.alert_config["response_time_threshold_ms"]:
                alerts.append({
                    "type": "slow_response",
                    "service": health.service_name,
                    "severity": "warning",
                    "message": f"Service {health.service_name} response time is {health.response_time_ms:.0f}ms"
                })
        
        # System resource alerts
        if system_metrics.cpu_percent > self.alert_config["cpu_threshold_percent"]:
            alerts.append({
                "type": "high_cpu",
                "service": "system",
                "severity": "warning",
                "message": f"High CPU usage: {system_metrics.cpu_percent:.1f}%"
            })
        
        if system_metrics.memory_percent > self.alert_config["memory_threshold_percent"]:
            alerts.append({
                "type": "high_memory",
                "service": "system",
                "severity": "warning",
                "message": f"High memory usage: {system_metrics.memory_percent:.1f}%"
            })
        
        if system_metrics.disk_percent > self.alert_config["disk_threshold_percent"]:
            alerts.append({
                "type": "high_disk",
                "service": "system",
                "severity": "critical",
                "message": f"High disk usage: {system_metrics.disk_percent:.1f}%"
            })
        
        # Process alerts
        for alert in alerts:
            self.save_alert(alert)
            self.send_notification(alert)
    
    def save_alert(self, alert: Dict):
        """Save alert to database"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                conn.execute("""
                    INSERT INTO alerts_history 
                    (alert_type, service_name, severity, message)
                    VALUES (?, ?, ?, ?)
                """, (
                    alert["type"], alert["service"], 
                    alert["severity"], alert["message"]
                ))
        except Exception as e:
            logger.error(f"Error saving alert: {e}")
    
    def send_notification(self, alert: Dict):
        """Send alert notification"""
        logger.warning(f"ALERT: {alert['severity'].upper()} - {alert['message']}")
        
        # Email notification (if configured)
        if self.notification_config["email_enabled"]:
            try:
                self.send_email_alert(alert)
            except Exception as e:
                logger.error(f"Failed to send email alert: {e}")
        
        # Slack notification (if configured)
        if self.notification_config["slack_enabled"]:
            try:
                self.send_slack_alert(alert)
            except Exception as e:
                logger.error(f"Failed to send Slack alert: {e}")
    
    def send_email_alert(self, alert: Dict):
        """Send email alert (placeholder implementation)"""
        # This would be implemented with actual SMTP settings
        logger.info(f"Would send email alert: {alert['message']}")
    
    def send_slack_alert(self, alert: Dict):
        """Send Slack alert (placeholder implementation)"""
        # This would be implemented with actual Slack webhook
        logger.info(f"Would send Slack alert: {alert['message']}")
    
    def generate_health_report(self) -> Dict:
        """Generate comprehensive health report"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                # Current service status
                current_status = conn.execute("""
                    SELECT service_name, status, response_time_ms, error_message, timestamp
                    FROM service_health_history 
                    WHERE timestamp >= datetime('now', '-5 minutes')
                    ORDER BY timestamp DESC
                """).fetchall()
                
                # System metrics summary (last hour)
                system_summary = conn.execute("""
                    SELECT 
                        AVG(cpu_percent) as avg_cpu,
                        AVG(memory_percent) as avg_memory,
                        AVG(disk_percent) as avg_disk,
                        MAX(docker_containers_running) as max_containers
                    FROM system_metrics_history 
                    WHERE timestamp >= datetime('now', '-1 hour')
                """).fetchone()
                
                # Recent alerts
                recent_alerts = conn.execute("""
                    SELECT alert_type, service_name, severity, message, timestamp
                    FROM alerts_history 
                    WHERE timestamp >= datetime('now', '-24 hours')
                    ORDER BY timestamp DESC
                    LIMIT 10
                """).fetchall()
                
                # Service uptime (last 24 hours)
                uptime_stats = conn.execute("""
                    SELECT 
                        service_name,
                        SUM(CASE WHEN status = 'healthy' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) as uptime_percent
                    FROM service_health_history 
                    WHERE timestamp >= datetime('now', '-24 hours')
                    GROUP BY service_name
                """).fetchall()
                
                return {
                    "report_timestamp": datetime.now().isoformat(),
                    "current_service_status": [
                        {
                            "service": row[0],
                            "status": row[1],
                            "response_time_ms": row[2],
                            "error": row[3],
                            "last_check": row[4]
                        } for row in current_status
                    ],
                    "system_summary": {
                        "avg_cpu_percent": round(system_summary[0] or 0, 2),
                        "avg_memory_percent": round(system_summary[1] or 0, 2),
                        "avg_disk_percent": round(system_summary[2] or 0, 2),
                        "max_containers_running": system_summary[3] or 0
                    } if system_summary else {},
                    "recent_alerts": [
                        {
                            "type": row[0],
                            "service": row[1],
                            "severity": row[2],
                            "message": row[3],
                            "timestamp": row[4]
                        } for row in recent_alerts
                    ],
                    "service_uptime_24h": [
                        {
                            "service": row[0],
                            "uptime_percent": round(row[1], 2)
                        } for row in uptime_stats
                    ]
                }
        
        except Exception as e:
            logger.error(f"Error generating health report: {e}")
            return {"error": str(e)}
    
    async def monitoring_loop(self):
        """Main monitoring loop"""
        logger.info("Starting health monitoring loop")
        
        while True:
            try:
                # Check all services
                health_results = await self.check_all_services()
                
                # Collect system metrics
                system_metrics = self.collect_system_metrics()
                
                # Save data
                self.save_health_data(health_results, system_metrics)
                
                # Check for alerts
                self.check_alerts(health_results, system_metrics)
                
                # Log summary
                healthy_count = len([h for h in health_results if h.status == "healthy"])
                total_count = len(health_results)
                
                logger.info(f"Health check complete: {healthy_count}/{total_count} services healthy")
                logger.info(f"System: CPU {system_metrics.cpu_percent:.1f}%, "
                           f"Memory {system_metrics.memory_percent:.1f}%, "
                           f"Disk {system_metrics.disk_percent:.1f}%")
                
                # Wait before next check
                await asyncio.sleep(60)  # Check every minute
                
            except Exception as e:
                logger.error(f"Error in monitoring loop: {e}")
                await asyncio.sleep(60)

async def main():
    """Main entry point"""
    monitor = HealthMonitor()
    
    # Run monitoring loop
    await monitor.monitoring_loop()

if __name__ == "__main__":
    asyncio.run(main())