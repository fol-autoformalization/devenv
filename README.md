# Multi-User Development Container with Shared Python Cache

> [!IMPORTANT]
> Use `uv run --active` to use the active venv instead of project-local:
> ```bash
> uv run --active python script.py
> ```

Given that multiple users will be working on this from different devices,
and the installation of python packages takes a while, have developed this
example container that:

- _At lauch time_ creates a user that matches the host user and group
- Mounts a directory from the host to the container
- _At build time_ caches the python packages, and makes them editable by a group
  which includes newly created user

> [!NOTE]
> We source the cached venv on ~/.bashrc, so it activates even if you open tmux
> or a new terminal. you can remove that if needed.

## Usage

```bash
# Build
docker build -t devenv .

# Launch with GPU (default)
./launch-container.sh

# Launch without GPU
./launch-container.sh --no-gpu
```
