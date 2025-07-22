#!/bin/bash
# LLM_CAPABILITY: local_ok
# Performance Analysis and Optimization Script
# Automated analysis of Bill Sloth system performance with recommendations

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
source "$BASE_DIR/lib/error_handling.sh" 2>/dev/null || true
source "$BASE_DIR/lib/notification_system.sh" 2>/dev/null || true
source "$BASE_DIR/lib/performance_monitoring.sh" 2>/dev/null || true

# Analysis configuration
ANALYSIS_OUTPUT_DIR="$HOME/.bill-sloth/performance/analysis"
ANALYSIS_PERIOD_HOURS=24
PERFORMANCE_THRESHOLD_CPU=70
PERFORMANCE_THRESHOLD_MEMORY=80
SLOW_OPERATION_THRESHOLD_MS=5000

# Initialize analysis system
init_performance_analysis() {
    mkdir -p "$ANALYSIS_OUTPUT_DIR"
    
    # Ensure performance monitoring is initialized
    if ! command -v capture_performance_snapshot &>/dev/null; then
        log_error "Performance monitoring not available - please initialize first"
        return 1
    fi
    
    log_info "Performance analysis system ready"
}

# Analyze current system performance
analyze_current_performance() {
    log_info "Analyzing current system performance..."
    
    local analysis_file="$ANALYSIS_OUTPUT_DIR/current_analysis_$(date +%Y%m%d_%H%M%S).json"
    
    # Capture current snapshot
    local current_snapshot=$(capture_performance_snapshot "system" "analysis" 0)
    
    # Get system information
    local cpu_count=$(nproc 2>/dev/null || echo "1")
    local memory_total=$(free -m | awk '/^Mem:/ {print $2}')
    local disk_usage=$(df -h . | awk 'NR==2 {print $5}' | sed 's/%//')
    local uptime_info=$(uptime)
    
    # Create analysis report
    cat > "$analysis_file" << EOF
{
  "analysis_timestamp": "$(date -Iseconds)",
  "system_info": {
    "cpu_count": $cpu_count,
    "memory_total_mb": $memory_total,
    "disk_usage_percent": $disk_usage,
    "uptime": "$uptime_info"
  },
  "current_metrics": $current_snapshot,
  "analysis_results": {}
}
EOF
    
    echo "$analysis_file"
}

# Analyze historical performance trends
analyze_performance_trends() {
    local period_hours="${1:-$ANALYSIS_PERIOD_HOURS}"
    
    log_info "Analyzing performance trends over last $period_hours hours..."
    
    local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
    
    if ! command -v sqlite3 &>/dev/null || [ "$DATABASE_ENGINE" != "sqlite3" ]; then
        log_error "Database not available for trend analysis"
        return 1
    fi
    
    local trends_file="$ANALYSIS_OUTPUT_DIR/trends_analysis_$(date +%Y%m%d_%H%M%S).json"
    
    # Get performance statistics
    local cpu_stats=$(sqlite3 "$db_file" "SELECT AVG(cpu_usage), MIN(cpu_usage), MAX(cpu_usage), COUNT(*) FROM performance_metrics WHERE timestamp > datetime('now', '-$period_hours hours') AND cpu_usage > 0;")
    local memory_stats=$(sqlite3 "$db_file" "SELECT AVG(memory_usage_mb), MIN(memory_usage_mb), MAX(memory_usage_mb), COUNT(*) FROM performance_metrics WHERE timestamp > datetime('now', '-$period_hours hours') AND memory_usage_mb > 0;")
    
    IFS='|' read -r cpu_avg cpu_min cpu_max cpu_count <<< "$cpu_stats"
    IFS='|' read -r mem_avg mem_min mem_max mem_count <<< "$memory_stats"
    
    # Identify problematic modules
    local high_cpu_modules=$(sqlite3 "$db_file" "SELECT module_name, AVG(cpu_usage) as avg_cpu FROM performance_metrics WHERE timestamp > datetime('now', '-$period_hours hours') AND cpu_usage > $PERFORMANCE_THRESHOLD_CPU GROUP BY module_name ORDER BY avg_cpu DESC;")
    local high_memory_modules=$(sqlite3 "$db_file" "SELECT module_name, AVG(memory_usage_mb) as avg_memory FROM performance_metrics WHERE timestamp > datetime('now', '-$period_hours hours') AND memory_usage_mb > 0 GROUP BY module_name ORDER BY avg_memory DESC;")
    
    # Identify slow operations
    local slow_operations=$(sqlite3 "$db_file" "SELECT module_name, operation_name, AVG(operation_duration_ms) as avg_duration, COUNT(*) as count FROM performance_metrics WHERE timestamp > datetime('now', '-$period_hours hours') AND operation_duration_ms > $SLOW_OPERATION_THRESHOLD_MS GROUP BY module_name, operation_name ORDER BY avg_duration DESC LIMIT 10;")
    
    # Create trend analysis report
    cat > "$trends_file" << EOF
{
  "analysis_timestamp": "$(date -Iseconds)",
  "period_hours": $period_hours,
  "cpu_statistics": {
    "average": ${cpu_avg:-0},
    "minimum": ${cpu_min:-0},
    "maximum": ${cpu_max:-0},
    "measurement_count": ${cpu_count:-0}
  },
  "memory_statistics": {
    "average_mb": ${mem_avg:-0},
    "minimum_mb": ${mem_min:-0},
    "maximum_mb": ${mem_max:-0},
    "measurement_count": ${mem_count:-0}
  },
  "high_cpu_modules": [
EOF
    
    # Add high CPU modules
    local first_cpu=true
    echo "$high_cpu_modules" | while IFS='|' read -r module_name avg_cpu; do
        if [ -n "$module_name" ]; then
            if [ "$first_cpu" = false ]; then
                echo "," >> "$trends_file"
            fi
            echo "    {\"module\": \"$module_name\", \"avg_cpu\": $avg_cpu}" >> "$trends_file"
            first_cpu=false
        fi
    done
    
    cat >> "$trends_file" << EOF
  ],
  "high_memory_modules": [
EOF
    
    # Add high memory modules
    local first_memory=true
    echo "$high_memory_modules" | while IFS='|' read -r module_name avg_memory; do
        if [ -n "$module_name" ]; then
            if [ "$first_memory" = false ]; then
                echo "," >> "$trends_file"
            fi
            echo "    {\"module\": \"$module_name\", \"avg_memory_mb\": $avg_memory}" >> "$trends_file"
            first_memory=false
        fi
    done
    
    cat >> "$trends_file" << EOF
  ],
  "slow_operations": [
EOF
    
    # Add slow operations
    local first_slow=true
    echo "$slow_operations" | while IFS='|' read -r module_name operation_name avg_duration count; do
        if [ -n "$module_name" ] && [ -n "$operation_name" ]; then
            if [ "$first_slow" = false ]; then
                echo "," >> "$trends_file"
            fi
            echo "    {\"module\": \"$module_name\", \"operation\": \"$operation_name\", \"avg_duration_ms\": $avg_duration, \"count\": $count}" >> "$trends_file"
            first_slow=false
        fi
    done
    
    echo "  ]" >> "$trends_file"
    echo "}" >> "$trends_file"
    
    echo "$trends_file"
}

# Generate optimization recommendations
generate_optimization_recommendations() {
    local trends_file="$1"
    
    if [ ! -f "$trends_file" ]; then
        log_error "Trends file not found: $trends_file"
        return 1
    fi
    
    log_info "Generating optimization recommendations..."
    
    local recommendations_file="$ANALYSIS_OUTPUT_DIR/recommendations_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$recommendations_file" << 'EOF'
# Bill Sloth Performance Optimization Recommendations

Generated: $(date)

## Executive Summary

Based on performance analysis of the Bill Sloth system, the following recommendations will improve system efficiency and user experience.

## High Priority Recommendations

### CPU Usage Optimization
EOF
    
    # Analyze CPU usage and add specific recommendations
    local avg_cpu=$(jq -r '.cpu_statistics.average // 0' "$trends_file")
    local max_cpu=$(jq -r '.cpu_statistics.maximum // 0' "$trends_file")
    
    if (( $(echo "$avg_cpu > $PERFORMANCE_THRESHOLD_CPU" | bc -l 2>/dev/null || echo "0") )); then
        cat >> "$recommendations_file" << EOF

🚨 **CRITICAL**: Average CPU usage is ${avg_cpu}% (threshold: ${PERFORMANCE_THRESHOLD_CPU}%)

**Immediate Actions:**
- Enable CPU-intensive operation scheduling during off-peak hours
- Implement operation queuing to prevent CPU spikes
- Review and optimize high-CPU modules listed below

EOF
    else
        cat >> "$recommendations_file" << EOF

✅ CPU usage is within acceptable limits (${avg_cpu}% average)

EOF
    fi
    
    # Add module-specific recommendations
    cat >> "$recommendations_file" << 'EOF'

### Memory Usage Optimization
EOF
    
    local avg_memory=$(jq -r '.memory_statistics.average_mb // 0' "$trends_file")
    local max_memory=$(jq -r '.memory_statistics.maximum_mb // 0' "$trends_file")
    
    cat >> "$recommendations_file" << EOF

**Current Memory Usage**: ${avg_memory}MB average, ${max_memory}MB peak

**Recommendations:**
- Implement memory cleanup routines for long-running operations
- Enable data compression for large datasets
- Consider memory pooling for frequent allocations

EOF
    
    # Add operation-specific recommendations
    cat >> "$recommendations_file" << 'EOF'

### Performance Bottlenecks

#### Slow Operations
EOF
    
    # Extract slow operations and provide specific recommendations
    local slow_ops_count=$(jq '.slow_operations | length' "$trends_file")
    
    if [ "$slow_ops_count" -gt 0 ]; then
        cat >> "$recommendations_file" << EOF

Found $slow_ops_count operations taking longer than ${SLOW_OPERATION_THRESHOLD_MS}ms:

EOF
        
        # Add each slow operation with recommendations
        for ((i=0; i<slow_ops_count; i++)); do
            local module=$(jq -r ".slow_operations[$i].module" "$trends_file")
            local operation=$(jq -r ".slow_operations[$i].operation" "$trends_file")
            local avg_duration=$(jq -r ".slow_operations[$i].avg_duration_ms" "$trends_file")
            local count=$(jq -r ".slow_operations[$i].count" "$trends_file")
            
            cat >> "$recommendations_file" << EOF
- **$module.$operation**: ${avg_duration}ms average ($count executions)
  - Consider caching results if operation is frequently repeated
  - Implement progress indicators for operations >3 seconds
  - Review algorithm efficiency
  
EOF
        done
    else
        cat >> "$recommendations_file" << EOF

✅ No operations detected taking longer than ${SLOW_OPERATION_THRESHOLD_MS}ms

EOF
    fi
    
    # Add configuration recommendations
    cat >> "$recommendations_file" << 'EOF'

## System Configuration Recommendations

### Database Optimization
- Enable WAL mode for SQLite (reduces lock contention)
- Implement connection pooling for concurrent operations
- Regular VACUUM operations for database maintenance
- Consider partitioning large tables by date

### File System Optimization
- Enable compression for backup archives
- Implement file rotation for large log files
- Use tmpfs for temporary operation files
- Regular cleanup of cache directories

### Process Management
- Implement process monitoring with automatic restart
- Use systemd services for better resource management
- Configure memory limits for resource-intensive operations
- Enable swap accounting for memory pressure detection

## Implementation Priority

### Phase 1 (Immediate - This Week)
1. Enable performance monitoring for all critical operations
2. Implement CPU and memory thresholds with alerts
3. Optimize database configuration (WAL mode, cache size)
4. Add progress indicators to slow operations

### Phase 2 (Short Term - Next 2 Weeks)  
1. Implement caching for frequently accessed data
2. Add batch processing for bulk operations
3. Create automated performance reports
4. Optimize backup operations with incremental changes

### Phase 3 (Medium Term - Next Month)
1. Migrate to systemd services for process management
2. Implement resource-aware operation scheduling
3. Add predictive scaling based on usage patterns
4. Create performance baseline testing

## Monitoring and Maintenance

- Run performance analysis weekly
- Review and update optimization rules monthly
- Monitor alerts for performance regressions
- Document performance improvements for knowledge sharing

---

*This report was generated automatically by the Bill Sloth Performance Analysis System*
EOF
    
    echo "$recommendations_file"
}

# Apply automatic optimizations
apply_automatic_optimizations() {
    local recommendations_file="$1"
    
    log_info "Applying automatic optimizations..."
    
    local optimizations_applied=0
    
    # Database optimizations
    if [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        
        log_info "Applying database optimizations..."
        
        sqlite3 "$db_file" << 'SQL'
-- Enable WAL mode for better concurrency
PRAGMA journal_mode = WAL;

-- Optimize synchronous mode for performance vs safety balance
PRAGMA synchronous = NORMAL;

-- Increase cache size for better performance
PRAGMA cache_size = 20000;

-- Store temporary data in memory
PRAGMA temp_store = memory;

-- Enable memory-mapped I/O for large databases
PRAGMA mmap_size = 268435456; -- 256MB

-- Analyze tables for query optimization
ANALYZE;
SQL
        
        log_success "Database optimizations applied"
        ((optimizations_applied++))
    fi
    
    # File system optimizations
    log_info "Applying file system optimizations..."
    
    # Clean up old temporary files
    find /tmp -name "bill_sloth_*" -mtime +1 -delete 2>/dev/null || true
    
    # Clean up old log files
    find "$HOME/.bill-sloth" -name "*.log" -size +10M -exec truncate -s 5M {} \; 2>/dev/null || true
    
    # Clean up old cache files
    find "$HOME/.bill-sloth/cache" -mtime +7 -delete 2>/dev/null || true
    
    log_success "File system cleanup completed"
    ((optimizations_applied++))
    
    # Performance monitoring optimizations
    log_info "Optimizing performance monitoring..."
    
    # Cleanup old performance data
    if command -v cleanup_performance_data &>/dev/null; then
        cleanup_performance_data 7  # Keep 7 days of data
        log_success "Performance data cleanup completed"
        ((optimizations_applied++))
    fi
    
    # System resource optimizations
    log_info "Applying system resource optimizations..."
    
    # Adjust system swappiness for better memory management
    if [ -w /proc/sys/vm/swappiness ]; then
        echo 10 > /proc/sys/vm/swappiness 2>/dev/null || true
        log_info "Adjusted system swappiness for better performance"
        ((optimizations_applied++))
    fi
    
    log_success "Applied $optimizations_applied automatic optimizations"
    
    # Record optimization in history
    if command -v sqlite3 &>/dev/null && [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        sqlite3 "$db_file" << EOF
INSERT INTO optimization_history 
(optimization_type, module_name, description, status)
VALUES ('automatic', 'system', 'Applied $optimizations_applied automatic optimizations', 'applied');
EOF
    fi
    
    return 0
}

# Full performance analysis workflow
run_full_performance_analysis() {
    log_info "Starting comprehensive performance analysis..."
    
    local analysis_start_time=$(date +%s)
    
    # Initialize analysis
    init_performance_analysis
    
    # Current performance analysis
    local current_analysis=$(analyze_current_performance)
    log_info "Current performance analysis: $current_analysis"
    
    # Historical trend analysis
    local trends_analysis=$(analyze_performance_trends)
    log_info "Trends analysis: $trends_analysis"
    
    # Generate recommendations
    local recommendations=$(generate_optimization_recommendations "$trends_analysis")
    log_info "Recommendations generated: $recommendations"
    
    # Apply automatic optimizations
    apply_automatic_optimizations "$recommendations"
    
    # Generate summary report
    local analysis_end_time=$(date +%s)
    local analysis_duration=$((analysis_end_time - analysis_start_time))
    
    local summary_file="$ANALYSIS_OUTPUT_DIR/analysis_summary_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$summary_file" << EOF
Bill Sloth Performance Analysis Summary
======================================
Analysis Date: $(date)
Analysis Duration: ${analysis_duration}s

Files Generated:
- Current Analysis: $current_analysis
- Trends Analysis: $trends_analysis  
- Recommendations: $recommendations
- Summary: $summary_file

Next Steps:
1. Review recommendations file for manual optimizations
2. Monitor performance metrics for improvement
3. Schedule next analysis in 1 week

EOF
    
    log_success "Performance analysis completed - see: $summary_file"
    
    # Send notification
    notify_success "Performance Analysis" "Comprehensive analysis completed in ${analysis_duration}s"
    
    echo "$summary_file"
}

# Quick performance check
quick_performance_check() {
    log_info "Running quick performance check..."
    
    local current_snapshot=$(capture_performance_snapshot "system" "quick_check" 0)
    
    # Parse key metrics
    local cpu_usage=$(echo "$current_snapshot" | jq -r '.cpu_usage // 0')
    local memory_mb=$(echo "$current_snapshot" | jq -r '.memory_usage_mb // 0')
    local load_average=$(echo "$current_snapshot" | jq -r '.load_average // 0')
    
    echo "🖥️  Quick Performance Status:"
    echo "   CPU Usage: ${cpu_usage}%"
    echo "   Memory Usage: ${memory_mb}MB"
    echo "   Load Average: ${load_average}"
    
    # Check thresholds
    local issues=0
    
    if (( $(echo "$cpu_usage > $PERFORMANCE_THRESHOLD_CPU" | bc -l 2>/dev/null || echo "0") )); then
        echo "   ⚠️  CPU usage is high (>${PERFORMANCE_THRESHOLD_CPU}%)"
        ((issues++))
    fi
    
    if (( $(echo "$load_average > 4.0" | bc -l 2>/dev/null || echo "0") )); then
        echo "   ⚠️  System load is high (>4.0)"
        ((issues++))
    fi
    
    if [ $issues -eq 0 ]; then
        echo "   ✅ Performance is within normal parameters"
    else
        echo "   🚨 $issues performance issue(s) detected - consider running full analysis"
    fi
    
    return $issues
}

# Main execution function
main() {
    case "${1:-quick}" in
        "full"|"analyze")
            run_full_performance_analysis
            ;;
        "trends")
            analyze_performance_trends "${2:-24}"
            ;;
        "current")
            analyze_current_performance
            ;;
        "optimize")
            apply_automatic_optimizations ""
            ;;
        "quick"|"check")
            quick_performance_check
            ;;
        *)
            echo "Bill Sloth Performance Analysis Tool"
            echo "Usage: $0 {full|trends|current|optimize|quick}"
            echo ""
            echo "Commands:"
            echo "  full     - Run comprehensive performance analysis"
            echo "  trends   - Analyze performance trends"
            echo "  current  - Analyze current system performance"
            echo "  optimize - Apply automatic optimizations"
            echo "  quick    - Quick performance status check"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi