FROM steamcmd/steamcmd:latest

SHELL ["/bin/bash", "-lc"]

# Create non-root user
RUN useradd -m -s /bin/bash oncehuman

# Install server files
RUN mkdir -p /opt/oncehuman && \
    steamcmd +login anonymous \
      +force_install_dir /opt/oncehuman \
      +app_update 2139460 validate \
      +quit && \
    chown -R oncehuman:oncehuman /opt/oncehuman

USER oncehuman
WORKDIR /opt/oncehuman

EXPOSE 27015/tcp 27015/udp 27016/tcp 27016/udp 27017/tcp 27017/udp

CMD ["./OnceHumanServer.sh", "-log", "-port=27015", "-queryport=27016", "-rconport=27017"]
