FROM scratch
COPY openexchange-webservice-go /
ENTRYPOINT ["/openexchange-webservice-go"]