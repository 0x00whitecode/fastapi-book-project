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

# Use an official Nginx image as the base image for the final stage
FROM nginx:alpine

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the FastAPI app from the builder stage
COPY --from=builder /app /app

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx and FastAPI
CMD nginx -g "daemon off;" & uvicorn app.main:app --host 0.0.0.0 --port 8000