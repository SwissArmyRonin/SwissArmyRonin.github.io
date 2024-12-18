# Jupyter

## Poetry

Create a kernel from a directory:

```shell
poetry run python -m ipykernel install --user --name "my-kernel"
```


## Rust

```shell
pip install jupyterlab
cargo install evcxr_jupyter
evcxr_jupyter --install
rustup component add rust-src
jupyter lab
```
