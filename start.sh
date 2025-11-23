#!/bin/bash
echo "--- STARTING RAILWAY HYBRID SERVER (FINAL OPTIMIZATION) ---"

# --- 1. START WATERFALL PROXY FIRST (Answers Render Health Check) ---
cd /app/proxy
# ALLOCATING 128MB MAX RAM FOR THE PROXY
echo "--> Launching Waterfall Proxy (Max 128M RAM) to prevent timeout..."
java -Xms64M -Xmx128M -jar waterfall.jar &
WATERFALL_PID=$!

# --- 2. SETUP AND START PAPER BACKEND (Runs in Background) ---
cd /app/server
if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
fi

# ALLOCATING 256MB MAX RAM FOR THE GAME SERVER
echo "--> Launching Paper 1.16.5 (Max 256M RAM) in background..."
java -Xms128M -Xmx256M -jar paper.jar nogui &
PAPER_PID=$!

# Wait for both processes to finish (i.e., keep the container running)
wait $PAPER_PID $WATERFALL_PID
