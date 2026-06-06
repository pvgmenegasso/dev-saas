FROM localhost/code-container-base


ENV DIRS="/app/code-server/bin /home/dev"
ARG USER_ID
ARG USER_GROUP
# Create a non-root user
# Create non-root user
RUN useradd -m -u ${USER_ID} -s /bin/bash dev && passwd -d dev
# Create a workspace folder owned by dev
RUN mkdir -p /home/dev/themes && mkdir -p /home/dev/workspace && \
    curl --output-dir "/home/dev/themes" -L --output "dark-violet-theme-vscode-2.1.0.vsix" "https://github.com/pvgmenegasso/dark-violet-theme-vscode/releases/download/v2.1.0/dark-violet-theme-vscode-2.1.0.vsix" && \
    for dir in $DIRS; do setfacl -m -R u:${USER_ID}:rwx $dir; chown -R ${USER_ID}:${USER_GROUP} $dir; done
RUN echo "Cleanup" && \
   rm -rf \
    /config/* \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

USER dev
WORKDIR /home/dev/workspace
EXPOSE 8080
# INSTALL EXTENSION
RUN /app/code-server/bin/code-server --install-extension /home/dev/themes/dark-violet-theme-vscode-2.1.0.vsix
RUN /app/code-server/bin/code-server -v --install-extension /home/dev/workspace/extension_list.txt
CMD ["/app/code-server/bin/code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/home/dev/workspace"]

