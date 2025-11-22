# Use Java 16 (Best for 1.16.5)
FROM eclipse-temurin:17-jdk-alpine

# Install dependencies
RUN apk add --no-cache bash curl wget

WORKDIR /app
RUN mkdir -p /app/proxy/plugins
RUN mkdir -p /app/server/plugins

# --- 1. DOWNLOAD SERVER JARS ---
# Paper 1.16.5
RUN curl -o /app/server/paper.jar https://api.papermc.io/v2/projects/paper/versions/1.16.5/builds/794/downloads/paper-1.16.5-794.jar
# Waterfall Proxy
RUN curl -o /app/proxy/waterfall.jar https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/527/downloads/waterfall-1.19-527.jar

# --- 2. DOWNLOAD PLUGINS ---
# EaglerXBungee (Websocket Bridge)
RUN curl -L -o /app/proxy/plugins/EaglerXBungee.jar https://github.com/lax1dude/eagl3rxbungee/releases/download/1.0.0/EaglerXBungee-1.0.0.jar
# ViaVersion (Allows 1.12 Eagler to join 1.16 Server)
RUN curl -L -o /app/server/plugins/ViaVersion.jar https://github.com/ViaVersion/ViaVersion/releases/download/4.0.0/ViaVersion-4.0.0.jar
RUN curl -L -o /app/server/plugins/ViaBackwards.jar https://github.com/ViaVersion/ViaBackwards/releases/download/4.0.0/ViaBackwards-4.0.0.jar
RUN curl -L -o /app/server/plugins/ViaRewind.jar https://github.com/ViaVersion/ViaRewind/releases/download/2.0.0/ViaRewind-2.0.0.jar

# Copy Configs
COPY start.sh /app/start.sh
COPY bungee_config.yml /app/proxy/config.yml
COPY server.properties /app/server/server.properties
COPY spigot.yml /app/server/spigot.yml

RUN chmod +x /app/start.sh

# Expose Ports (8080 for Web/Eagler, 25565 for Java)
EXPOSE 8080 25565

CMD ["/app/start.sh"]
