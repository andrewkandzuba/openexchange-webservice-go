FROM scratch
COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY main /bin/main
ENTRYPOINT ["/entrypoint.sh"]
