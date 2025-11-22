#!/bin/bash
echo "--- STARTING RAILWAY HYBRID SERVER ---"

# Setup Backend
cd /app/server
if [ ! -f eula.txt ]; then
    echo "eula=true" > eula.txt
fi

# Start Paper 1.16.5 (Backend)
# Limiting RAM to fit in Free Tier
java -Xms1G -Xmx2G -jar paper.jar nogui &
PAPER_PID=$!

echo "Waiting for backend to initialize..."
sleep 30

# Start Waterfall (Proxy)
cd /app/proxy
java -Xms256M -Xmx512M -jar waterfall.jar &
WATERFALL_PID=$!

wait $PAPER_PID $WATERFALL_PID
