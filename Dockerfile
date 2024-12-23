# Base image with Python for FastAPI
FROM python:3.11-slim as fastapi_builder

# Set the working directory for FastAPI
WORKDIR /app/fastapi

# Install FastAPI dependencies
COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy FastAPI source code
COPY backend /app/fastapi

# Base image with Node.js for Next.js
FROM node:18-alpine as nextjs_builder

# Set the working directory for Next.js
WORKDIR /app/nextjs

# Install Next.js dependencies
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy Next.js source code
COPY frontend /app/nextjs

# Final stage: Combine both FastAPI and Next.js in one image
FROM python:3.11-slim

# Install necessary tools (e.g., curl, supervisor)
RUN apt-get update && apt-get install -y \
    curl \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for both services
WORKDIR /app

# Copy FastAPI and Next.js files from previous build stages
COPY --from=fastapi_builder /app/fastapi /app/fastapi
COPY --from=nextjs_builder /app/nextjs /app/nextjs

# Expose necessary ports
EXPOSE 8000 3000

# Create supervisor config to manage both FastAPI and Next.js processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set environment variables
ENV NEXT_PUBLIC_API_URL=http://localhost:8000

# Start supervisor to manage both FastAPI and Next.js processes
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
