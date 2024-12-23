#!/bin/bash

# Set the working directory for FastAPI
cd /app/fastapi

# Start the FastAPI application in the background
uvicorn app:app --host 0.0.0.0 --port 8000 &

# Start the Next.js application in the background
cd /app/nextjs
npm run dev  &

# Wait for both background processes to finish
wait -n

# Exit with the status of the first process that exits
exit $?
