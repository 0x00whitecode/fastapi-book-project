# Use an official Python runtime as a parent image
FROM python:3.9-slim as builder

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Use an official Python runtime for the final stage
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy dependencies and application from the builder stage
COPY --from=builder /app /app

# Install Nginx
RUN apt update && apt install -y nginx && rm -rf /var/lib/apt/lists/*

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose necessary ports
EXPOSE 80 8000

# Start Nginx and FastAPI
CMD service nginx start && python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
