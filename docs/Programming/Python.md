
# Python

## Start an ad-hoc web server

Run:

```shell
python -m http.server --directory <directory>
```

## List the loggers and make some of them shut up

```python
# List loggers
loggers = [logging.getLogger(name) for name in logging.root.manager.loggerDict]
print(loggers)

# STFU Py4J
logging.getLogger("py4j.clientserver").setLevel(logging.ERROR)  
```

## Decorative Python

Primer on Python Decorators: <https://realpython.com/primer-on-python-decorators/>

## Sync/Async

A simple walk-through of the interaction between sync and async: <https://www.aeracode.org/2018/02/19/python-async-simplified>

## Installing pyenv in Windows

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
```

Add `<HOME_DIR>\.pyenv\pyenv-win\bin` to PATH

1. `pyenv --version` to check if the installation was successful.    
2. Run `pyenv install -l` to check a list of Python versions supported by pyenv-win
3. Run `pyenv install <version>` to install the supported version    
4. Run `pyenv global <version>` to set a Python version as the global version
5. Check which Python version you are using and its path
    
    ```
    > pyenv version
    <version> (set by \path\to\.pyenv\pyenv-win\.python-version)
    ```
    
6. Check that Python is working
    
    ```
    > python -c "import sys; print(sys.executable)"
    \path\to\.pyenv\pyenv-win\versions\<version>\python.exe
    ```
