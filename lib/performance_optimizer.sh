#!/bin/bash
# LLM_CAPABILITY: local_ok
# Performance Optimization Library for Bill Sloth
# System-wide performance improvements and resource efficiency

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Source required libraries
source "$(dirname "${BASH_SOURCE[0]}")/error_handling.sh"
source "$(dirname "${BASH_SOURCE[0]}")/notification.sh"
source "$(dirname "${BASH_SOURCE[0]}")/data_persistence.sh"

# Configuration
PERF_CONFIG_DIR="$HOME/.local/share/bill-sloth/performance"
PERF_LOG_FILE="$PERF_CONFIG_DIR/optimization.log"
SYSTEM_INFO_FILE="$PERF_CONFIG_DIR/system_info.json"
OPTIMIZATION_REPORT="$PERF_CONFIG_DIR/optimization_report.txt"

create_performance_directories() {
    log_info "Creating performance optimization directories"
    
    mkdir -p "$PERF_CONFIG_DIR"
    mkdir -p "$PERF_CONFIG_DIR/profiles"
    mkdir -p "$PERF_CONFIG_DIR/monitoring"
    mkdir -p "$PERF_CONFIG_DIR/scripts"
    
    log_success "Performance directories created"
}

analyze_system_resources() {
    log_info "Analyzing system resources and capabilities"
    
    # Gather comprehensive system information
    cat > "$SYSTEM_INFO_FILE" << EOF
{
  "system_analysis": {
    "timestamp": "$(date -Iseconds)",
    "cpu": {
      "model": "$(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)",
      "cores": $(nproc),
      "threads": $(nproc --all),
      "architecture": "$(uname -m)",
      "frequency": "$(lscpu | grep 'CPU MHz' | awk '{print $3}' | head -1)"
    },
    "memory": {
      "total_gb": $(free -g | awk 'NR==2{printf "%.1f", $2}'),
      "available_gb": $(free -g | awk 'NR==2{printf "%.1f", $7}'),
      "swap_gb": $(free -g | awk 'NR==3{printf "%.1f", $2}'),
      "usage_percent": $(free | awk 'NR==2{printf "%.1f", $3*100/$2}')
    },
    "storage": {
      "root_total_gb": $(df -BG / | awk 'NR==2{print $2}' | tr -d 'G'),
      "root_available_gb": $(df -BG / | awk 'NR==2{print $4}' | tr -d 'G'),
      "home_available_gb": $(df -BG "$HOME" | awk 'NR==2{print $4}' | tr -d 'G'),
      "usage_percent": $(df / | awk 'NR==2{print $5}' | tr -d '%')
    },
    "gpu": {
      "nvidia_available": $(command -v nvidia-smi >/dev/null && echo "true" || echo "false"),
      "gpu_info": "$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null | head -1 || echo 'None')"
    },
    "network": {
      "interfaces": $(ip link show | grep -E '^[0-9]+:' | wc -l),
      "active_connections": $(ss -tun | wc -l)
    }
  }
}
EOF
    
    log_success "System analysis completed"
}

optimize_system_settings() {
    log_info "Applying system-wide performance optimizations"
    
    # CPU governor optimization
    if [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ]; then
        log_info "Optimizing CPU governor settings"
        
        # Set performance governor for better responsiveness
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            if [ -w "$cpu" ]; then
                echo "performance" | sudo tee "$cpu" >/dev/null 2>&1
            fi
        done
        
        log_success "CPU governor optimized"
    fi
    
    # Memory optimization
    log_info "Optimizing memory settings"
    
    # Reduce swappiness for better performance with sufficient RAM
    local total_ram_gb=$(free -g | awk 'NR==2{print $2}')
    if [ "$total_ram_gb" -gt 8 ]; then
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    fi
    
    # Optimize for desktop workload
    echo 'vm.dirty_ratio=15' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    echo 'vm.dirty_background_ratio=5' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    
    # Network optimization
    echo 'net.core.rmem_max=16777216' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    echo 'net.core.wmem_max=16777216' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    
    log_success "System settings optimized"
}

optimize_bill_sloth_performance() {
    log_info "Optimizing Bill Sloth specific performance"
    
    # Create optimized startup script
    cat > "$PERF_CONFIG_DIR/scripts/fast_startup.sh" << 'EOF'
#!/bin/bash
# Fast startup optimization for Bill Sloth

# Pre-load essential libraries
export BILL_SLOTH_PRELOAD=true

# Optimize Python startup
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# Pre-compile frequently used scripts
BILL_SLOTH_ROOT="$(dirname "$(dirname "$(dirname "$0")")")"

# Pre-load core modules
source "$BILL_SLOTH_ROOT/lib/core.sh" >/dev/null 2>&1 &
source "$BILL_SLOTH_ROOT/lib/notification.sh" >/dev/null 2>&1 &
source "$BILL_SLOTH_ROOT/lib/data_persistence.sh" >/dev/null 2>&1 &

# Pre-warm commonly used commands
command -v docker >/dev/null 2>&1 &
command -v ollama >/dev/null 2>&1 &
command -v python3 >/dev/null 2>&1 &

# Cache system information
nproc >/dev/null 2>&1 &
free -m >/dev/null 2>&1 &

wait  # Wait for background tasks to complete
EOF
    
    chmod +x "$PERF_CONFIG_DIR/scripts/fast_startup.sh"
    
    # Create memory-efficient module loader
    cat > "$PERF_CONFIG_DIR/scripts/efficient_module_loader.sh" << 'EOF'
#!/bin/bash
# Memory-efficient module loading

load_module_on_demand() {
    local module_path="$1"
    local module_name="$(basename "$module_path" .sh)"
    
    # Check if module is already loaded
    if declare -f "${module_name}_main" >/dev/null 2>&1; then
        return 0
    fi
    
    # Load module only when needed
    if [ -f "$module_path" ]; then
        source "$module_path"
        log_info "Loaded module: $module_name"
    fi
}

# Function to preload critical modules
preload_critical_modules() {
    local bill_sloth_root="${1:-$(dirname "$(dirname "$(dirname "$0")")")}"
    
    # Critical modules that should always be loaded
    local critical_modules=(
        "$bill_sloth_root/lib/error_handling.sh"
        "$bill_sloth_root/lib/notification.sh"
        "$bill_sloth_root/lib/data_persistence.sh"
    )
    
    for module in "${critical_modules[@]}"; do
        load_module_on_demand "$module"
    done
}

# Export functions
export -f load_module_on_demand
export -f preload_critical_modules
EOF
    
    log_success "Bill Sloth performance optimizations configured"
}

optimize_docker_performance() {
    log_info "Optimizing Docker performance"
    
    # Create Docker daemon optimization config
    cat > "$PERF_CONFIG_DIR/docker-daemon-optimized.json" << 'EOF'
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "memlock": {
      "hard": -1,
      "soft": -1
    },
    "nofile": {
      "hard": 65536,
      "soft": 65536
    }
  },
  "live-restore": true,
  "max-concurrent-downloads": 6,
  "max-concurrent-uploads": 5,
  "dns": ["8.8.8.8", "8.8.4.4"]
}
EOF
    
    # Create Docker Compose performance profile
    cat > "$PERF_CONFIG_DIR/docker-compose-performance.yml" << 'EOF'
# Docker Compose performance optimizations
# Use with: docker-compose -f docker-compose.yml -f docker-compose-performance.yml up

version: '3.8'

services:
  vrbo-automation:
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
    environment:
      - PYTHONUNBUFFERED=1
      - PYTHONDONTWRITEBYTECODE=1
    volumes:
      - type: tmpfs
        target: /tmp
        tmpfs:
          size: 100M

  guest-communication:
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M
    environment:
      - PYTHONUNBUFFERED=1
      - PYTHONDONTWRITEBYTECODE=1

  analytics:
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
    environment:
      - PYTHONUNBUFFERED=1
      - PYTHONDONTWRITEBYTECODE=1

  service-health-monitor:
    deploy:
      resources:
        limits:
          memory: 256M
        reservations:
          memory: 128M
EOF
    
    log_success "Docker performance optimizations configured"
}

optimize_database_performance() {
    log_info "Optimizing database performance"
    
    # SQLite optimization settings
    cat > "$PERF_CONFIG_DIR/sqlite_optimizations.sql" << 'EOF'
-- SQLite Performance Optimizations for Bill Sloth

-- Journal mode for better concurrency
PRAGMA journal_mode = WAL;

-- Synchronous mode for balance of safety and speed
PRAGMA synchronous = NORMAL;

-- Cache size (negative value means KB)
PRAGMA cache_size = -64000;  -- 64MB cache

-- Memory-mapped I/O size (bytes)
PRAGMA mmap_size = 268435456;  -- 256MB

-- Temporary storage in memory
PRAGMA temp_store = MEMORY;

-- Auto vacuum for maintenance
PRAGMA auto_vacuum = INCREMENTAL;

-- Optimize for bulk operations
PRAGMA optimize;

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_bookings_date_range ON bookings(check_in_date, check_out_date);
CREATE INDEX IF NOT EXISTS idx_revenue_date_source ON revenue_records(transaction_date, revenue_source);
CREATE INDEX IF NOT EXISTS idx_partnerships_status_type ON partnerships(partnership_status, partnership_type);
EOF
    
    # PostgreSQL optimization (if used)
    cat > "$PERF_CONFIG_DIR/postgresql_optimizations.conf" << 'EOF'
# PostgreSQL Performance Optimizations for Bill Sloth
# Add to postgresql.conf

# Memory settings (adjust based on available RAM)
shared_buffers = 256MB
effective_cache_size = 1GB
work_mem = 16MB
maintenance_work_mem = 64MB

# Checkpoint settings
checkpoint_completion_target = 0.9
wal_buffers = 16MB

# Query planner settings
random_page_cost = 1.1
effective_io_concurrency = 200

# Logging (reduce for performance)
log_statement = 'none'
log_min_duration_statement = 1000
EOF
    
    log_success "Database performance optimizations configured"
}

create_performance_monitoring() {
    log_info "Creating performance monitoring system"
    
    cat > "$PERF_CONFIG_DIR/monitoring/performance_monitor.py" << 'EOF'
#!/usr/bin/env python3
"""
Bill Sloth Performance Monitor
Real-time system and application performance monitoring
"""

import psutil
import time
import json
import subprocess
from datetime import datetime
from pathlib import Path

class PerformanceMonitor:
    def __init__(self):
        self.config_dir = Path.home() / ".local/share/bill-sloth/performance"
        self.monitoring_dir = self.config_dir / "monitoring"
        self.monitoring_dir.mkdir(parents=True, exist_ok=True)
        
    def get_system_metrics(self):
        """Get current system performance metrics"""
        # CPU metrics
        cpu_percent = psutil.cpu_percent(interval=1)
        cpu_freq = psutil.cpu_freq()
        
        # Memory metrics
        memory = psutil.virtual_memory()
        swap = psutil.swap_memory()
        
        # Disk metrics
        disk = psutil.disk_usage('/')
        disk_io = psutil.disk_io_counters()
        
        # Network metrics
        network_io = psutil.net_io_counters()
        
        return {
            "timestamp": datetime.now().isoformat(),
            "cpu": {
                "percent": cpu_percent,
                "frequency_mhz": cpu_freq.current if cpu_freq else None,
                "count": psutil.cpu_count()
            },
            "memory": {
                "percent": memory.percent,
                "available_gb": round(memory.available / (1024**3), 2),
                "used_gb": round(memory.used / (1024**3), 2),
                "total_gb": round(memory.total / (1024**3), 2)
            },
            "swap": {
                "percent": swap.percent,
                "used_gb": round(swap.used / (1024**3), 2),
                "total_gb": round(swap.total / (1024**3), 2)
            },
            "disk": {
                "percent": round((disk.used / disk.total) * 100, 1),
                "available_gb": round(disk.free / (1024**3), 2),
                "total_gb": round(disk.total / (1024**3), 2),
                "io_read_mb": round(disk_io.read_bytes / (1024**2), 2) if disk_io else 0,
                "io_write_mb": round(disk_io.write_bytes / (1024**2), 2) if disk_io else 0
            },
            "network": {
                "bytes_sent_mb": round(network_io.bytes_sent / (1024**2), 2),
                "bytes_recv_mb": round(network_io.bytes_recv / (1024**2), 2)
            }
        }
    
    def get_bill_sloth_metrics(self):
        """Get Bill Sloth specific performance metrics"""
        metrics = {
            "processes": [],
            "docker_containers": [],
            "services_status": {}
        }
        
        # Check for Bill Sloth processes
        for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent']):
            try:
                if any(keyword in proc.info['name'].lower() 
                      for keyword in ['bill', 'sloth', 'ollama', 'whisper']):
                    metrics["processes"].append({
                        "name": proc.info['name'],
                        "pid": proc.info['pid'],
                        "cpu_percent": proc.info['cpu_percent'],
                        "memory_percent": round(proc.info['memory_percent'], 2)
                    })
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                continue
        
        # Check Docker containers
        try:
            result = subprocess.run(['docker', 'ps', '--format', 'json'], 
                                  capture_output=True, text=True, timeout=5)
            if result.returncode == 0:
                for line in result.stdout.strip().split('\n'):
                    if line:
                        container = json.loads(line)
                        metrics["docker_containers"].append({
                            "name": container.get("Names", "unknown"),
                            "status": container.get("Status", "unknown"),
                            "image": container.get("Image", "unknown")
                        })
        except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError):
            pass
        
        # Check service status
        services = ["ollama", "docker"]
        for service in services:
            try:
                result = subprocess.run(['systemctl', 'is-active', service], 
                                      capture_output=True, text=True, timeout=2)
                metrics["services_status"][service] = result.stdout.strip()
            except (subprocess.TimeoutExpired, FileNotFoundError):
                metrics["services_status"][service] = "unknown"
        
        return metrics
    
    def generate_performance_report(self):
        """Generate comprehensive performance report"""
        system_metrics = self.get_system_metrics()
        bill_sloth_metrics = self.get_bill_sloth_metrics()
        
        report = {
            "report_timestamp": datetime.now().isoformat(),
            "system": system_metrics,
            "bill_sloth": bill_sloth_metrics
        }
        
        # Performance analysis
        analysis = {
            "performance_score": self.calculate_performance_score(system_metrics),
            "recommendations": self.generate_recommendations(system_metrics, bill_sloth_metrics),
            "alerts": self.check_for_alerts(system_metrics)
        }
        
        report["analysis"] = analysis
        
        return report
    
    def calculate_performance_score(self, metrics):
        """Calculate overall performance score (0-100)"""
        score = 100
        
        # CPU penalty
        if metrics["cpu"]["percent"] > 80:
            score -= 20
        elif metrics["cpu"]["percent"] > 60:
            score -= 10
        
        # Memory penalty
        if metrics["memory"]["percent"] > 90:
            score -= 25
        elif metrics["memory"]["percent"] > 75:
            score -= 15
        
        # Disk penalty
        if metrics["disk"]["percent"] > 95:
            score -= 30
        elif metrics["disk"]["percent"] > 85:
            score -= 20
        
        # Swap penalty
        if metrics["swap"]["percent"] > 50:
            score -= 15
        
        return max(0, score)
    
    def generate_recommendations(self, system_metrics, bill_sloth_metrics):
        """Generate performance recommendations"""
        recommendations = []
        
        # Memory recommendations
        if system_metrics["memory"]["percent"] > 85:
            recommendations.append("High memory usage detected. Consider closing unused applications.")
        
        # Disk recommendations
        if system_metrics["disk"]["percent"] > 90:
            recommendations.append("Low disk space. Run cleanup or free up storage.")
        
        # CPU recommendations
        if system_metrics["cpu"]["percent"] > 75:
            recommendations.append("High CPU usage. Check for resource-intensive processes.")
        
        # Bill Sloth specific recommendations
        process_count = len(bill_sloth_metrics["processes"])
        if process_count > 10:
            recommendations.append(f"Many Bill Sloth processes running ({process_count}). Consider optimization.")
        
        return recommendations
    
    def check_for_alerts(self, metrics):
        """Check for performance alerts"""
        alerts = []
        
        if metrics["memory"]["percent"] > 95:
            alerts.append("CRITICAL: Memory usage extremely high")
        
        if metrics["disk"]["percent"] > 98:
            alerts.append("CRITICAL: Disk space critically low")
        
        if metrics["cpu"]["percent"] > 90:
            alerts.append("WARNING: CPU usage very high")
        
        return alerts
    
    def save_report(self, report):
        """Save performance report to file"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = self.monitoring_dir / f"performance_report_{timestamp}.json"
        
        with open(report_file, 'w') as f:
            json.dump(report, f, indent=2)
        
        return report_file
    
    def continuous_monitoring(self, interval=60):
        """Run continuous performance monitoring"""
        print("🔍 Starting Bill Sloth performance monitoring...")
        print(f"📊 Monitoring interval: {interval} seconds")
        print("Press Ctrl+C to stop")
        
        try:
            while True:
                report = self.generate_performance_report()
                
                # Print summary
                system = report["system"]
                analysis = report["analysis"]
                
                print(f"\n⏰ {datetime.now().strftime('%H:%M:%S')}")
                print(f"🧠 CPU: {system['cpu']['percent']:.1f}% | "
                      f"💾 RAM: {system['memory']['percent']:.1f}% | "
                      f"💽 Disk: {system['disk']['percent']:.1f}%")
                print(f"📊 Performance Score: {analysis['performance_score']}/100")
                
                # Show alerts
                if analysis["alerts"]:
                    for alert in analysis["alerts"]:
                        print(f"🚨 {alert}")
                
                # Show recommendations
                if analysis["recommendations"]:
                    print("💡 Recommendations:")
                    for rec in analysis["recommendations"][:2]:  # Show top 2
                        print(f"   • {rec}")
                
                # Save detailed report every 10 minutes
                if int(time.time()) % 600 == 0:
                    self.save_report(report)
                
                time.sleep(interval)
                
        except KeyboardInterrupt:
            print("\n👋 Performance monitoring stopped")

def main():
    import sys
    
    monitor = PerformanceMonitor()
    
    if len(sys.argv) > 1 and sys.argv[1] == "report":
        # Generate single report
        report = monitor.generate_performance_report()
        print(json.dumps(report, indent=2))
        
        # Save report
        report_file = monitor.save_report(report)
        print(f"\n📁 Report saved to: {report_file}")
        
    elif len(sys.argv) > 1 and sys.argv[1] == "monitor":
        # Continuous monitoring
        interval = int(sys.argv[2]) if len(sys.argv) > 2 else 60
        monitor.continuous_monitoring(interval)
        
    else:
        print("Usage:")
        print(f"  {sys.argv[0]} report    # Generate single performance report")
        print(f"  {sys.argv[0]} monitor [interval]  # Continuous monitoring")

if __name__ == "__main__":
    main()
EOF
    
    chmod +x "$PERF_CONFIG_DIR/monitoring/performance_monitor.py"
    
    log_success "Performance monitoring system created"
}

create_optimization_profiles() {
    log_info "Creating performance optimization profiles"
    
    # High-performance profile
    cat > "$PERF_CONFIG_DIR/profiles/high_performance.sh" << 'EOF'
#!/bin/bash
# High Performance Profile for Bill Sloth
# Optimizes for maximum performance, higher resource usage

echo "🚀 Activating High Performance Profile"

# CPU optimization
sudo cpupower frequency-set -g performance 2>/dev/null || echo "cpupower not available"

# Memory optimization  
echo 5 | sudo tee /proc/sys/vm/dirty_background_ratio >/dev/null
echo 15 | sudo tee /proc/sys/vm/dirty_ratio >/dev/null
echo 10 | sudo tee /proc/sys/vm/swappiness >/dev/null

# I/O optimization
echo deadline | sudo tee /sys/block/*/queue/scheduler >/dev/null 2>&1

# Network optimization
echo 1 | sudo tee /proc/sys/net/core/netdev_max_backlog >/dev/null
echo 16777216 | sudo tee /proc/sys/net/core/rmem_max >/dev/null
echo 16777216 | sudo tee /proc/sys/net/core/wmem_max >/dev/null

# Docker optimization
export DOCKER_OPTS="--storage-driver=overlay2 --log-opt max-size=10m"

# Python optimization
export PYTHONUNBUFFERED=1
export PYTHONDONTWRITEBYTECODE=1

echo "✅ High Performance Profile Activated"
EOF
    
    # Battery-saving profile
    cat > "$PERF_CONFIG_DIR/profiles/battery_saver.sh" << 'EOF'
#!/bin/bash
# Battery Saver Profile for Bill Sloth
# Optimizes for power efficiency, reduced performance

echo "🔋 Activating Battery Saver Profile"

# CPU optimization for power saving
sudo cpupower frequency-set -g powersave 2>/dev/null || echo "cpupower not available"

# Memory optimization for power saving
echo 10 | sudo tee /proc/sys/vm/dirty_background_ratio >/dev/null
echo 20 | sudo tee /proc/sys/vm/dirty_ratio >/dev/null
echo 60 | sudo tee /proc/sys/vm/swappiness >/dev/null

# Reduce I/O activity
echo cfq | sudo tee /sys/block/*/queue/scheduler >/dev/null 2>&1

# Network power saving
echo 1000 | sudo tee /proc/sys/net/core/netdev_max_backlog >/dev/null

# Reduce Docker resource usage
export DOCKER_OPTS="--log-opt max-size=5m --log-opt max-file=2"

echo "✅ Battery Saver Profile Activated"
EOF
    
    # Balanced profile (default)
    cat > "$PERF_CONFIG_DIR/profiles/balanced.sh" << 'EOF'
#!/bin/bash
# Balanced Profile for Bill Sloth
# Good balance between performance and resource usage

echo "⚖️  Activating Balanced Profile"

# CPU balanced mode
sudo cpupower frequency-set -g ondemand 2>/dev/null || echo "cpupower not available"

# Memory balanced settings
echo 10 | sudo tee /proc/sys/vm/dirty_background_ratio >/dev/null
echo 20 | sudo tee /proc/sys/vm/dirty_ratio >/dev/null
echo 20 | sudo tee /proc/sys/vm/swappiness >/dev/null

# I/O balanced
echo mq-deadline | sudo tee /sys/block/*/queue/scheduler >/dev/null 2>&1

# Network balanced
echo 5000 | sudo tee /proc/sys/net/core/netdev_max_backlog >/dev/null

echo "✅ Balanced Profile Activated"
EOF
    
    chmod +x "$PERF_CONFIG_DIR/profiles"/*.sh
    
    log_success "Performance profiles created"
}

create_performance_tools() {
    log_info "Creating performance analysis tools"
    
    # System performance checker
    cat > "$PERF_CONFIG_DIR/scripts/perf_check.sh" << 'EOF'
#!/bin/bash
# Quick performance check for Bill Sloth

echo "🔍 Bill Sloth Performance Check"
echo "==============================="

# CPU Check
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "🧠 CPU Usage: ${cpu_usage}%"

# Memory Check  
memory_info=$(free -h | awk 'NR==2{printf "Used: %s/%s (%.1f%%)", $3, $2, $3*100/$2}')
echo "💾 Memory: $memory_info"

# Disk Check
disk_info=$(df -h / | awk 'NR==2{printf "Used: %s/%s (%s)", $3, $2, $5}')
echo "💽 Disk Space: $disk_info"

# Load Average
load_avg=$(uptime | awk -F'load average:' '{print $2}')
echo "⚖️  Load Average:$load_avg"

# Bill Sloth Processes
echo ""
echo "🤖 Bill Sloth Processes:"
ps aux | grep -E "(bill|sloth|ollama)" | grep -v grep | head -5 | awk '{printf "  %-20s %s%% CPU  %s%% MEM\n", $11, $3, $4}'

# Docker Status
echo ""
echo "🐳 Docker Status:"
if command -v docker >/dev/null 2>&1; then
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" | head -5
else
    echo "  Docker not available"
fi

# Quick recommendations
echo ""
echo "💡 Quick Recommendations:"
if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo 0) )); then
    echo "  • High CPU usage - consider closing unused applications"
fi

memory_percent=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ "$memory_percent" -gt 85 ]; then
    echo "  • High memory usage - consider restarting services"
fi

disk_percent=$(df / | awk 'NR==2{print $5}' | tr -d '%')
if [ "$disk_percent" -gt 90 ]; then
    echo "  • Low disk space - run cleanup utilities"
fi
EOF
    
    # Performance benchmark
    cat > "$PERF_CONFIG_DIR/scripts/benchmark.sh" << 'EOF'
#!/bin/bash
# Simple performance benchmark for Bill Sloth

echo "🏁 Bill Sloth Performance Benchmark"
echo "==================================="

# CPU benchmark (simple)
echo "🧠 CPU Test..."
start_time=$(date +%s.%N)
dd if=/dev/zero bs=1M count=100 2>/dev/null | md5sum >/dev/null
end_time=$(date +%s.%N)
cpu_time=$(echo "$end_time - $start_time" | bc)
echo "   CPU Score: $(echo "scale=2; 100 / $cpu_time" | bc) (higher is better)"

# Memory test
echo "💾 Memory Test..."
start_time=$(date +%s.%N)
python3 -c "
import time
data = []
for i in range(10000):
    data.append('x' * 1000)
del data
"
end_time=$(date +%s.%N)
mem_time=$(echo "$end_time - $start_time" | bc)
echo "   Memory Score: $(echo "scale=2; 10 / $mem_time" | bc) (higher is better)"

# Disk I/O test
echo "💽 Disk I/O Test..."
start_time=$(date +%s.%N)
dd if=/dev/zero of=/tmp/benchmark_test bs=1M count=50 2>/dev/null
sync
rm -f /tmp/benchmark_test
end_time=$(date +%s.%N)
io_time=$(echo "$end_time - $start_time" | bc)
echo "   Disk Score: $(echo "scale=2; 50 / $io_time" | bc) MB/s"

# Overall score
overall=$(echo "scale=1; (100 / $cpu_time + 10 / $mem_time + 50 / $io_time) / 3" | bc)
echo ""
echo "🏆 Overall Performance Score: $overall"

if (( $(echo "$overall > 20" | bc -l) )); then
    echo "✅ Excellent performance"
elif (( $(echo "$overall > 10" | bc -l) )); then
    echo "✅ Good performance"  
else
    echo "⚠️  Performance could be improved"
fi
EOF
    
    chmod +x "$PERF_CONFIG_DIR/scripts"/*.sh
    
    log_success "Performance tools created"
}

setup_performance_optimization_complete() {
    log_info "Setting up complete performance optimization for Bill Sloth"
    
    create_performance_directories
    analyze_system_resources
    optimize_system_settings
    optimize_bill_sloth_performance
    optimize_docker_performance  
    optimize_database_performance
    create_performance_monitoring
    create_optimization_profiles
    create_performance_tools
    
    # Create main performance optimization script
    cat > "$HOME/.local/bin/bill-performance" << 'EOF'
#!/bin/bash
# Bill Sloth Performance Management

PERF_DIR="$HOME/.local/share/bill-sloth/performance"

case "${1:-help}" in
    "check"|"status")
        bash "$PERF_DIR/scripts/perf_check.sh"
        ;;
    "benchmark")
        bash "$PERF_DIR/scripts/benchmark.sh"
        ;;
    "monitor")
        python3 "$PERF_DIR/monitoring/performance_monitor.py" monitor "${2:-60}"
        ;;
    "report")
        python3 "$PERF_DIR/monitoring/performance_monitor.py" report
        ;;
    "profile")
        case "${2:-balanced}" in
            "high"|"performance")
                bash "$PERF_DIR/profiles/high_performance.sh"
                ;;
            "battery"|"saver")
                bash "$PERF_DIR/profiles/battery_saver.sh"
                ;;
            "balanced"|"default")
                bash "$PERF_DIR/profiles/balanced.sh"
                ;;
            *)
                echo "Available profiles: high, battery, balanced"
                ;;
        esac
        ;;
    "optimize")
        echo "🚀 Running full system optimization..."
        source "$PERF_DIR/../lib/performance_optimizer.sh"
        optimize_system_settings
        optimize_bill_sloth_performance
        echo "✅ Optimization completed"
        ;;
    *)
        echo "Bill Sloth Performance Management"
        echo "================================"
        echo "Usage: $0 {check|benchmark|monitor|report|profile|optimize}"
        echo ""
        echo "Commands:"
        echo "  check       - Quick performance status"
        echo "  benchmark   - Run performance benchmark"
        echo "  monitor     - Start continuous monitoring"
        echo "  report      - Generate detailed report"
        echo "  profile     - Switch performance profile (high/battery/balanced)"
        echo "  optimize    - Run full system optimization"
        ;;
esac
EOF
    
    chmod +x "$HOME/.local/bin/bill-performance"
    
    # Add to PATH if needed
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    # Save optimization status
    save_state "performance_optimization_enabled" "true"
    save_state "performance_optimization_date" "$(date)"
    
    log_success "Performance optimization setup completed successfully!"
    log_info "Available commands:"
    log_info "  - bill-performance check     # Quick status check"
    log_info "  - bill-performance benchmark # Performance test"
    log_info "  - bill-performance monitor   # Real-time monitoring"
    log_info "  - bill-performance profile high # High performance mode"
    
    # Generate initial report
    echo "📊 Generating initial performance report..."
    bash "$PERF_CONFIG_DIR/scripts/perf_check.sh" > "$OPTIMIZATION_REPORT"
    
    log_success "Initial performance report saved to: $OPTIMIZATION_REPORT"
}

# Export functions
export -f analyze_system_resources
export -f optimize_system_settings  
export -f optimize_bill_sloth_performance