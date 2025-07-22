# Bill Sloth Systemd Services

This directory contains systemd service definitions for running Bill Sloth components as system services, ensuring reliable background operation and automatic startup.

## Available Services

### Core Services
- `bill-sloth-core.service` - Main Bill Sloth system coordinator
- `bill-sloth-monitoring.service` - Performance and health monitoring
- `bill-sloth-backup.service` - Automated backup management

### Timer Services
- `bill-sloth-daily.timer` - Daily maintenance tasks
- `bill-sloth-hourly.timer` - Hourly performance monitoring
- `bill-sloth-backup.timer` - Automated backup schedule

### User Services
- `bill-sloth-user.service` - User-space Bill Sloth daemon

## Installation

Run the setup script to install all services:
```bash
sudo bash setup_systemd_services.sh
```

Or install individual services:
```bash
sudo cp bill-sloth-core.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable bill-sloth-core.service
sudo systemctl start bill-sloth-core.service
```

## Service Management

### Start services
```bash
sudo systemctl start bill-sloth-core
```

### Enable auto-start on boot
```bash
sudo systemctl enable bill-sloth-core
```

### Check service status
```bash
sudo systemctl status bill-sloth-core
```

### View logs
```bash
journalctl -u bill-sloth-core -f
```

### Stop services
```bash
sudo systemctl stop bill-sloth-core
```

## Configuration

Service configuration files are located in:
- `/etc/bill-sloth/` - System-wide configuration
- `~/.config/bill-sloth/` - User-specific configuration

## Monitoring

All services include:
- Health check endpoints
- Resource limit monitoring
- Automatic restart on failure
- Comprehensive logging to journald

## Troubleshooting

### Service fails to start
```bash
journalctl -u bill-sloth-core --no-pager
```

### Performance issues
```bash
systemctl show bill-sloth-core --property=CPUUsage
systemctl show bill-sloth-core --property=MemoryUsage
```

### Reset failed state
```bash
sudo systemctl reset-failed bill-sloth-core
```