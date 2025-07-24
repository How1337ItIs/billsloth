FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create directories
RUN mkdir -p /app/data /app/logs

# Copy application
COPY main.py .

# Create non-root user
RUN useradd -r -u 1001 monitor
RUN chown -R monitor:monitor /app
USER monitor

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8004/health', timeout=5)"

EXPOSE 8004

CMD ["python", "main.py"]