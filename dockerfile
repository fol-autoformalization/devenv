FROM nvidia/cuda:12.4.1-base-ubuntu22.04


# Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    neovim                                                       \
    sudo                                                         \
    git                                                          \
    curl                                                         \
    ca-certificates                                              \
    gosu                                                         \
    locales                                                      \
    tmux                                                         \
  && rm -rf /var/lib/apt/lists/*

# Generate UTF-8 locale for proper character support in tmux
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ENV UV_INSTALL_DIR=/usr/local/bin
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV UV_CACHE_DIR=/opt/uv/cache \
    UV_PYTHON_INSTALL_DIR=/opt/uv/python

# Create shared groups for uv cache and workspace
RUN groupadd uvcache \
    && groupadd workspace \
    && usermod -aG uvcache root \
    && usermod -aG workspace root \
    && mkdir -p /opt/uv/cache /opt/uv/python \
    && chown -R root:uvcache /opt/uv \
    && chmod -R 0775 /opt/uv

WORKDIR /workspace

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY pyproject.toml uv.lock ./
ENV PATH="/root/.local/bin:${PATH}"
RUN uv sync \
    && chown -R root:uvcache /opt/uv \
    && chmod -R g+w /opt/uv \
    && chown -R root:workspace /workspace \
    && chmod -R g+w /workspace

# Set up entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]

# TODO: copy? a project, use its pinned python version, etc

