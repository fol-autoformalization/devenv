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



RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY pyproject.toml uv.lock ./
ENV PATH="/root/.local/bin:${PATH}"
RUN uv sync

# Set up entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]

# TODO: copy? a project, use its pinned python version, etc

