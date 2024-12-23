# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies including Python, Node.js, and build tools
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    python3.8 \
    python3-pip \
    python3-dev \
    nodejs \
    npm \
    git \
    cmake \
    g++ \
    libomp-dev \
    libopenblas-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# Install specific Node.js version (e.g., 18.x) if not already installed
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash \
    && apt-get install -y nodejs

# Set the working directory for FastAPI app
WORKDIR /app/fastapi

# Copy requirements and install FastAPI dependencies
COPY backend/requirements.txt .
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install uvicorn  # Explicitly install uvicorn if not in requirements

# Set the working directory for Next.js app
WORKDIR /app/nextjs

# Copy Next.js package.json and install dependencies
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

# Copy the FastAPI and Next.js source code
COPY frontend /app/nextjs
COPY backend /app/fastapi

# Expose the necessary ports for FastAPI (8000) and Next.js (3000)
EXPOSE 8000 3000

# Copy the custom start script to run both apps concurrently
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh  # Make sure the script is executable

# Set the working directory to /app
WORKDIR /app

# Command to run both FastAPI and Next.js in parallel using the custom script
CMD ["/bin/bash", "/app/start.sh"]
