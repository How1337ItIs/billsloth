#!/usr/bin/env python3
"""
Bill Sloth Revenue Analytics Service
Advanced business intelligence for VRBO and partnership revenue optimization
"""

import sqlite3
import json
import logging
import asyncio
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, asdict
from pathlib import Path
import pandas as pd
import numpy as np
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.responses import JSONResponse, FileResponse
import uvicorn
from pydantic import BaseModel
import io
import base64
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend
import matplotlib.pyplot as plt
import seaborn as sns

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# FastAPI app
app = FastAPI(title="Bill Sloth Revenue Analytics", version="1.0.0")

# Data models
@dataclass
class RevenueRecord:
    date: str
    source: str  # 'vrbo', 'partnership', 'other'
    amount: float
    property_id: Optional[str] = None
    partner_name: Optional[str] = None
    description: Optional[str] = None
    commission_rate: Optional[float] = None

@dataclass
class PropertyMetrics:
    property_id: str
    property_name: str
    total_revenue: float
    total_bookings: int
    occupancy_rate: float
    average_daily_rate: float
    average_length_of_stay: float
    guest_rating: float
    cleaning_fee_revenue: float

@dataclass
class PartnershipMetrics:
    partner_name: str
    partnership_type: str
    total_revenue: float
    commission_earned: float
    campaigns_completed: int
    average_campaign_value: float
    roi_percentage: float
    last_activity: str

class RevenueAnalytics:
    def __init__(self, db_path: str = "/app/data/revenue_analytics.db"):
        self.db_path = db_path
        Path(db_path).parent.mkdir(parents=True, exist_ok=True)
        self.init_database()
    
    def init_database(self):
        """Initialize the revenue analytics database"""
        with sqlite3.connect(self.db_path) as conn:
            conn.executescript("""
                CREATE TABLE IF NOT EXISTS revenue_records (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    date DATE NOT NULL,
                    source TEXT NOT NULL,
                    amount REAL NOT NULL,
                    property_id TEXT,
                    partner_name TEXT,
                    description TEXT,
                    commission_rate REAL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS property_performance (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    property_id TEXT NOT NULL,
                    property_name TEXT NOT NULL,
                    date DATE NOT NULL,
                    bookings_count INTEGER DEFAULT 0,
                    revenue REAL DEFAULT 0,
                    nights_booked INTEGER DEFAULT 0,
                    total_nights_available INTEGER DEFAULT 0,
                    average_daily_rate REAL DEFAULT 0,
                    cleaning_fees REAL DEFAULT 0,
                    guest_rating REAL DEFAULT 0,
                    reviews_count INTEGER DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS partnership_performance (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    partner_name TEXT NOT NULL,
                    partnership_type TEXT NOT NULL,
                    date DATE NOT NULL,
                    campaign_name TEXT,
                    revenue REAL DEFAULT 0,
                    commission_rate REAL DEFAULT 0,
                    commission_earned REAL DEFAULT 0,
                    performance_metrics TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS financial_goals (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    goal_type TEXT NOT NULL,
                    goal_name TEXT NOT NULL,
                    target_amount REAL NOT NULL,
                    target_date DATE NOT NULL,
                    current_amount REAL DEFAULT 0,
                    status TEXT DEFAULT 'active',
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                CREATE TABLE IF NOT EXISTS expense_categories (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    date DATE NOT NULL,
                    category TEXT NOT NULL,
                    amount REAL NOT NULL,
                    description TEXT,
                    property_id TEXT,
                    is_tax_deductible BOOLEAN DEFAULT 0,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
                
                -- Create indexes for performance
                CREATE INDEX IF NOT EXISTS idx_revenue_date ON revenue_records(date);
                CREATE INDEX IF NOT EXISTS idx_revenue_source ON revenue_records(source);
                CREATE INDEX IF NOT EXISTS idx_property_date ON property_performance(date);
                CREATE INDEX IF NOT EXISTS idx_partnership_date ON partnership_performance(date);
            """)
        logger.info("Revenue analytics database initialized")
    
    def add_revenue_record(self, record: RevenueRecord) -> bool:
        """Add a new revenue record"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                conn.execute("""
                    INSERT INTO revenue_records 
                    (date, source, amount, property_id, partner_name, description, commission_rate)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    record.date, record.source, record.amount, record.property_id,
                    record.partner_name, record.description, record.commission_rate
                ))
            logger.info(f"Added revenue record: {record.source} ${record.amount}")
            return True
        except Exception as e:
            logger.error(f"Error adding revenue record: {e}")
            return False
    
    def get_revenue_summary(self, start_date: str, end_date: str) -> Dict:
        """Get comprehensive revenue summary for date range"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                # Total revenue by source
                revenue_by_source = pd.read_sql_query("""
                    SELECT 
                        source,
                        SUM(amount) as total_revenue,
                        COUNT(*) as transaction_count,
                        AVG(amount) as average_transaction
                    FROM revenue_records 
                    WHERE date BETWEEN ? AND ?
                    GROUP BY source
                """, conn, params=[start_date, end_date])
                
                # Daily revenue trend
                daily_revenue = pd.read_sql_query("""
                    SELECT 
                        date,
                        SUM(amount) as daily_revenue,
                        COUNT(*) as daily_transactions
                    FROM revenue_records 
                    WHERE date BETWEEN ? AND ?
                    GROUP BY date
                    ORDER BY date
                """, conn, params=[start_date, end_date])
                
                # Property performance
                property_performance = pd.read_sql_query("""
                    SELECT 
                        property_id,
                        SUM(revenue) as total_revenue,
                        SUM(bookings_count) as total_bookings,
                        AVG(average_daily_rate) as avg_daily_rate,
                        AVG(guest_rating) as avg_rating
                    FROM property_performance 
                    WHERE date BETWEEN ? AND ?
                    GROUP BY property_id
                """, conn, params=[start_date, end_date])
                
                # Partnership performance
                partnership_performance = pd.read_sql_query("""
                    SELECT 
                        partner_name,
                        partnership_type,
                        SUM(revenue) as total_revenue,
                        SUM(commission_earned) as total_commission,
                        COUNT(*) as campaigns_count
                    FROM partnership_performance 
                    WHERE date BETWEEN ? AND ?
                    GROUP BY partner_name, partnership_type
                """, conn, params=[start_date, end_date])
                
                return {
                    "revenue_by_source": revenue_by_source.to_dict('records'),
                    "daily_revenue": daily_revenue.to_dict('records'),
                    "property_performance": property_performance.to_dict('records'),
                    "partnership_performance": partnership_performance.to_dict('records'),
                    "total_revenue": revenue_by_source['total_revenue'].sum() if not revenue_by_source.empty else 0,
                    "total_transactions": revenue_by_source['transaction_count'].sum() if not revenue_by_source.empty else 0
                }
        except Exception as e:
            logger.error(f"Error getting revenue summary: {e}")
            return {}
    
    def calculate_property_metrics(self, property_id: str, start_date: str, end_date: str) -> Dict:
        """Calculate detailed metrics for a specific property"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                metrics = pd.read_sql_query("""
                    SELECT 
                        property_name,
                        SUM(revenue) as total_revenue,
                        SUM(bookings_count) as total_bookings,
                        SUM(nights_booked) as total_nights_booked,
                        SUM(total_nights_available) as total_nights_available,
                        AVG(average_daily_rate) as avg_daily_rate,
                        SUM(cleaning_fees) as total_cleaning_fees,
                        AVG(guest_rating) as avg_guest_rating,
                        SUM(reviews_count) as total_reviews
                    FROM property_performance 
                    WHERE property_id = ? AND date BETWEEN ? AND ?
                    GROUP BY property_id, property_name
                """, conn, params=[property_id, start_date, end_date])
                
                if metrics.empty:
                    return {}
                
                row = metrics.iloc[0]
                
                # Calculate derived metrics
                occupancy_rate = (row['total_nights_booked'] / row['total_nights_available'] * 100) if row['total_nights_available'] > 0 else 0
                avg_length_of_stay = row['total_nights_booked'] / row['total_bookings'] if row['total_bookings'] > 0 else 0
                revenue_per_available_night = row['total_revenue'] / row['total_nights_available'] if row['total_nights_available'] > 0 else 0
                
                return {
                    "property_name": row['property_name'],
                    "total_revenue": float(row['total_revenue']),
                    "total_bookings": int(row['total_bookings']),
                    "occupancy_rate": round(occupancy_rate, 2),
                    "average_daily_rate": round(row['avg_daily_rate'], 2),
                    "average_length_of_stay": round(avg_length_of_stay, 1),
                    "guest_rating": round(row['avg_guest_rating'], 2),
                    "total_cleaning_fees": float(row['total_cleaning_fees']),
                    "revenue_per_available_night": round(revenue_per_available_night, 2),
                    "total_reviews": int(row['total_reviews'])
                }
        except Exception as e:
            logger.error(f"Error calculating property metrics: {e}")
            return {}
    
    def generate_revenue_forecast(self, days_ahead: int = 30) -> Dict:
        """Generate revenue forecast using historical data"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                # Get historical daily revenue for the last 90 days
                historical_data = pd.read_sql_query("""
                    SELECT 
                        date,
                        SUM(amount) as daily_revenue
                    FROM revenue_records 
                    WHERE date >= date('now', '-90 days')
                    GROUP BY date
                    ORDER BY date
                """, conn)
                
                if historical_data.empty or len(historical_data) < 7:
                    return {"error": "Insufficient historical data for forecasting"}
                
                # Simple moving average forecast
                historical_data['date'] = pd.to_datetime(historical_data['date'])
                historical_data = historical_data.set_index('date')
                
                # Calculate trend
                window_size = min(14, len(historical_data))
                moving_avg = historical_data['daily_revenue'].rolling(window=window_size).mean()
                
                # Simple linear trend
                recent_avg = moving_avg.tail(7).mean()
                previous_avg = moving_avg.tail(14).head(7).mean() if len(moving_avg) >= 14 else recent_avg
                
                daily_trend = (recent_avg - previous_avg) / 7 if previous_avg > 0 else 0
                
                # Generate forecast
                forecast_dates = pd.date_range(
                    start=historical_data.index.max() + timedelta(days=1),
                    periods=days_ahead,
                    freq='D'
                )
                
                forecasted_revenue = []
                base_revenue = recent_avg
                
                for i, date in enumerate(forecast_dates):
                    # Add seasonality (simple day-of-week pattern)
                    day_of_week_multiplier = {
                        0: 0.9,  # Monday
                        1: 0.9,  # Tuesday
                        2: 0.9,  # Wednesday
                        3: 0.95, # Thursday
                        4: 1.1,  # Friday
                        5: 1.2,  # Saturday
                        6: 1.1   # Sunday
                    }
                    
                    predicted_revenue = base_revenue + (daily_trend * i)
                    predicted_revenue *= day_of_week_multiplier.get(date.weekday(), 1.0)
                    predicted_revenue = max(0, predicted_revenue)  # Ensure non-negative
                    
                    forecasted_revenue.append({
                        "date": date.strftime('%Y-%m-%d'),
                        "predicted_revenue": round(predicted_revenue, 2)
                    })
                
                total_forecast = sum(item['predicted_revenue'] for item in forecasted_revenue)
                
                return {
                    "forecast_period_days": days_ahead,
                    "total_predicted_revenue": round(total_forecast, 2),
                    "average_daily_revenue": round(total_forecast / days_ahead, 2),
                    "confidence_level": "medium",  # Simple classification
                    "daily_forecast": forecasted_revenue,
                    "historical_average": round(recent_avg, 2),
                    "trend_direction": "increasing" if daily_trend > 0 else "decreasing" if daily_trend < 0 else "stable"
                }
        except Exception as e:
            logger.error(f"Error generating revenue forecast: {e}")
            return {"error": str(e)}
    
    def analyze_partnership_roi(self, partner_name: str = None) -> Dict:
        """Analyze ROI for partnerships"""
        try:
            with sqlite3.connect(self.db_path) as conn:
                query = """
                    SELECT 
                        partner_name,
                        partnership_type,
                        SUM(revenue) as total_revenue,
                        SUM(commission_earned) as total_commission,
                        COUNT(*) as campaigns_count,
                        AVG(commission_rate) as avg_commission_rate,
                        MIN(date) as first_campaign,
                        MAX(date) as last_campaign
                    FROM partnership_performance 
                """
                params = []
                
                if partner_name:
                    query += " WHERE partner_name = ?"
                    params.append(partner_name)
                
                query += " GROUP BY partner_name, partnership_type ORDER BY total_revenue DESC"
                
                partnerships = pd.read_sql_query(query, conn, params=params)
                
                if partnerships.empty:
                    return {"error": "No partnership data found"}
                
                # Calculate ROI metrics for each partnership
                roi_analysis = []
                for _, partnership in partnerships.iterrows():
                    # Estimate costs (simplified - could be enhanced with actual cost tracking)
                    estimated_cost = partnership['total_commission'] * 0.3  # Assume 30% of commission as cost
                    roi_percentage = ((partnership['total_revenue'] - estimated_cost) / estimated_cost * 100) if estimated_cost > 0 else 0
                    
                    roi_analysis.append({
                        "partner_name": partnership['partner_name'],
                        "partnership_type": partnership['partnership_type'],
                        "total_revenue": float(partnership['total_revenue']),
                        "total_commission": float(partnership['total_commission']),
                        "campaigns_count": int(partnership['campaigns_count']),
                        "average_commission_rate": round(partnership['avg_commission_rate'] * 100, 2) if partnership['avg_commission_rate'] else 0,
                        "estimated_roi_percentage": round(roi_percentage, 2),
                        "first_campaign": partnership['first_campaign'],
                        "last_campaign": partnership['last_campaign'],
                        "revenue_per_campaign": round(partnership['total_revenue'] / partnership['campaigns_count'], 2) if partnership['campaigns_count'] > 0 else 0
                    })
                
                # Overall partnership performance
                total_partnership_revenue = partnerships['total_revenue'].sum()
                total_partnership_commission = partnerships['total_commission'].sum()
                total_campaigns = partnerships['campaigns_count'].sum()
                
                return {
                    "individual_partnerships": roi_analysis,
                    "overall_metrics": {
                        "total_revenue": float(total_partnership_revenue),
                        "total_commission": float(total_partnership_commission),
                        "total_campaigns": int(total_campaigns),
                        "average_revenue_per_campaign": round(total_partnership_revenue / total_campaigns, 2) if total_campaigns > 0 else 0,
                        "overall_commission_rate": round(total_partnership_commission / total_partnership_revenue * 100, 2) if total_partnership_revenue > 0 else 0
                    }
                }
        except Exception as e:
            logger.error(f"Error analyzing partnership ROI: {e}")
            return {"error": str(e)}
    
    def generate_monthly_report(self, year: int, month: int) -> Dict:
        """Generate comprehensive monthly business report"""
        start_date = f"{year}-{month:02d}-01"
        if month == 12:
            end_date = f"{year + 1}-01-01"
        else:
            end_date = f"{year}-{month + 1:02d}-01"
        
        # Get all metrics
        revenue_summary = self.get_revenue_summary(start_date, end_date)
        partnership_roi = self.analyze_partnership_roi()
        
        # Previous month comparison
        prev_month = month - 1 if month > 1 else 12
        prev_year = year if month > 1 else year - 1
        prev_start_date = f"{prev_year}-{prev_month:02d}-01"
        if prev_month == 12:
            prev_end_date = f"{prev_year + 1}-01-01"
        else:
            prev_end_date = f"{prev_year}-{prev_month + 1:02d}-01"
        
        prev_revenue_summary = self.get_revenue_summary(prev_start_date, prev_end_date)
        
        # Calculate growth
        current_total = revenue_summary.get('total_revenue', 0)
        previous_total = prev_revenue_summary.get('total_revenue', 0)
        growth_percentage = ((current_total - previous_total) / previous_total * 100) if previous_total > 0 else 0
        
        return {
            "report_period": f"{year}-{month:02d}",
            "revenue_summary": revenue_summary,
            "partnership_analysis": partnership_roi,
            "month_over_month_growth": {
                "current_month_revenue": current_total,
                "previous_month_revenue": previous_total,
                "growth_percentage": round(growth_percentage, 2),
                "growth_amount": round(current_total - previous_total, 2)
            },
            "generated_at": datetime.now().isoformat()
        }

# Global analytics instance
analytics = RevenueAnalytics()

# API Models
class RevenueRecordRequest(BaseModel):
    date: str
    source: str
    amount: float
    property_id: Optional[str] = None
    partner_name: Optional[str] = None
    description: Optional[str] = None
    commission_rate: Optional[float] = None

class PropertyPerformanceRequest(BaseModel):
    property_id: str
    property_name: str
    date: str
    bookings_count: int = 0
    revenue: float = 0
    nights_booked: int = 0
    total_nights_available: int = 0
    average_daily_rate: float = 0
    cleaning_fees: float = 0
    guest_rating: float = 0
    reviews_count: int = 0

# API Endpoints
@app.get("/")
async def root():
    return {"message": "Bill Sloth Revenue Analytics API", "version": "1.0.0"}

@app.post("/revenue/add")
async def add_revenue(record: RevenueRecordRequest):
    """Add a new revenue record"""
    revenue_record = RevenueRecord(**record.dict())
    success = analytics.add_revenue_record(revenue_record)
    if success:
        return {"message": "Revenue record added successfully"}
    else:
        raise HTTPException(status_code=500, detail="Failed to add revenue record")

@app.get("/revenue/summary")
async def get_revenue_summary(start_date: str, end_date: str):
    """Get revenue summary for date range"""
    summary = analytics.get_revenue_summary(start_date, end_date)
    if not summary:
        raise HTTPException(status_code=404, detail="No revenue data found for the specified period")
    return summary

@app.get("/property/{property_id}/metrics")
async def get_property_metrics(property_id: str, start_date: str, end_date: str):
    """Get detailed metrics for a specific property"""
    metrics = analytics.calculate_property_metrics(property_id, start_date, end_date)
    if not metrics:
        raise HTTPException(status_code=404, detail="No data found for the specified property")
    return metrics

@app.get("/forecast")
async def get_revenue_forecast(days_ahead: int = 30):
    """Get revenue forecast"""
    forecast = analytics.generate_revenue_forecast(days_ahead)
    if "error" in forecast:
        raise HTTPException(status_code=400, detail=forecast["error"])
    return forecast

@app.get("/partnerships/roi")
async def get_partnership_roi(partner_name: Optional[str] = None):
    """Get partnership ROI analysis"""
    roi_analysis = analytics.analyze_partnership_roi(partner_name)
    if "error" in roi_analysis:
        raise HTTPException(status_code=404, detail=roi_analysis["error"])
    return roi_analysis

@app.get("/reports/monthly/{year}/{month}")
async def get_monthly_report(year: int, month: int):
    """Generate comprehensive monthly report"""
    if not (1 <= month <= 12):
        raise HTTPException(status_code=400, detail="Month must be between 1 and 12")
    
    report = analytics.generate_monthly_report(year, month)
    return report

@app.get("/analytics/charts/revenue-trend")
async def get_revenue_trend_chart(start_date: str, end_date: str):
    """Generate revenue trend chart"""
    try:
        summary = analytics.get_revenue_summary(start_date, end_date)
        daily_revenue = summary.get('daily_revenue', [])
        
        if not daily_revenue:
            raise HTTPException(status_code=404, detail="No data available for chart")
        
        # Create chart
        plt.figure(figsize=(12, 6))
        dates = [item['date'] for item in daily_revenue]
        revenues = [item['daily_revenue'] for item in daily_revenue]
        
        plt.plot(dates, revenues, marker='o', linewidth=2, markersize=4)
        plt.title('Daily Revenue Trend', fontsize=16, fontweight='bold')
        plt.xlabel('Date', fontsize=12)
        plt.ylabel('Revenue ($)', fontsize=12)
        plt.xticks(rotation=45)
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        
        # Save to bytes
        img_buffer = io.BytesIO()
        plt.savefig(img_buffer, format='png', dpi=300, bbox_inches='tight')
        img_buffer.seek(0)
        plt.close()
        
        # Encode to base64
        img_base64 = base64.b64encode(img_buffer.read()).decode('utf-8')
        
        return {"chart_data": f"data:image/png;base64,{img_base64}"}
    except Exception as e:
        logger.error(f"Error generating chart: {e}")
        raise HTTPException(status_code=500, detail="Failed to generate chart")

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)