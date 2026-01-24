FROM nvidia/cuda:12.4.1-base-ubuntu22.04


# Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    neovim                                                       \
    sudo                                                         \
    git                                                          \
    curl                                                         \
    ca-certificates                                              \
  && rm -rf /var/lib/apt/lists/*



RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY pyproject.toml uv.lock ./
ENV PATH="/root/.local/bin:${PATH}"
RUN uv sync



# TODO: copy? a project, use its pinned python version, etc

