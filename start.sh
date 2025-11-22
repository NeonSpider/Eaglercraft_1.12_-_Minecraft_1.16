#!/bin/bash
echo "--- STARTING RAILWAY HYBRID SERVER (MEMORY OPTIMIZED) ---"

# Set EULA for Paper
cd /app/server
if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
fi

# Start Paper 1.16.5 (Backend)
# *** CRITICAL FIX: REDUCED MAX RAM TO 256MB ***
echo "--> Launching Paper 1.16.5 (Max 256M RAM)..."
java -Xms128M -Xmx256M -jar paper.jar nogui &
PAPER_PID=$!

echo "Waiting 30s for backend to initialize..."
sleep 30

# Start Waterfall (Proxy)
cd /app/proxy
# *** CRITICAL FIX: REDUCED MAX RAM TO 128MB ***
echo "--> Launching Waterfall Proxy (Max 128M RAM)..."
java -Xms64M -Xmx128M -jar waterfall.jar &
WATERFALL_PID=$!

wait $PAPER_PID $WATERFALL_PID
