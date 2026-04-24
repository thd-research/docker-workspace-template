# ==============================================================================
# Docker Template for Student Projects
# ==============================================================================
# Default base image: Ubuntu 22.04
# Override at build time:
#   BASE_IMAGE=ubuntu:20.04 docker compose up --build
# ==============================================================================

ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

# Metadata
LABEL maintainer="your-email@example.com"
LABEL description="Student project workspace"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Set working directory inside the container
WORKDIR /workspace

# ── System dependencies ───────────────────────────────────────────────────────
# Runs the shared system-install script so all package setup lives in one place
COPY scripts/install_system.sh /tmp/install_system.sh
RUN chmod +x /tmp/install_system.sh && /tmp/install_system.sh && rm /tmp/install_system.sh

# ── Clone repos & entrypoint (run at container start, not at build time) ──────
# clone_repos.sh runs AFTER the volume is mounted so repos land in the
# host-backed /workspace, not in a hidden image layer.
COPY scripts/clone_repos.sh /usr/local/bin/clone_repos.sh
COPY scripts/entrypoint.sh  /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/clone_repos.sh /usr/local/bin/entrypoint.sh

# ── Entrypoint: clone repos into the live volume, then hand off to CMD ────────
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]