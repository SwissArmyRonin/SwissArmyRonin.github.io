# Shell scripting

<!-- toc -->

## Shell utilities

* [fzf](https://github.com/junegunn/fzf): Fuzzy find.
* [fd](https://github.com/sharkdp/fd): User-friendly `find`.
* [rg](https://github.com/BurntSushi/ripgrep): RipGrep.
* [bat](https://github.com/sharkdp/bat): Syntax highlight `cat`.

### FZF & friends

* [4 Useful fzf Tricks for Your Terminal](https://pragmaticpineapple.com/four-useful-fzf-tricks-for-your-terminal/)
* [Find anything you need with fzf, the Linux fuzzy finder tool](https://www.redhat.com/sysadmin/fzf-linux-fuzzy-finder)

```shell title="Example config"
sudo apt install bat fd-find
export FZF_DEFAULT_OPTS="--preview 'batcat -f {}'"
export FZF_DEFAULT_COMMAND="fdfind --type f"
```

## Fancy Fish-like Bash

Install [`ble.sh`](https://github.com/akinomyoga/ble.sh):
```shell
git clone --recursive https://github.com/akinomyoga/ble.sh.git
make -C ble.sh
source ble.sh/out/ble.sh
```

## What's hogging the port?

ss  -lptn 'sport = :9080'

## Parse parameters

Source: [Using getopts to process long and short command line options](https://stackoverflow.com/a/7948533/511976)

```shell
# NOTE: This requires GNU getopt.  On Mac OS X and FreeBSD, you have to install this
# separately; see below.
TEMP=$(getopt -o vdm: --long verbose,debug,memory:,debugfile:,minheap:,maxheap: \
              -n 'javawrap' -- "$@")

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"

VERBOSE=false
DEBUG=false
MEMORY=
DEBUGFILE=
JAVA_MISC_OPT=
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -d | --debug ) DEBUG=true; shift ;;
    -m | --memory ) MEMORY="$2"; shift 2 ;;
    --debugfile ) DEBUGFILE="$2"; shift 2 ;;
    --minheap )
      JAVA_MISC_OPT="$JAVA_MISC_OPT -XX:MinHeapFreeRatio=$2"; shift 2 ;;
    --maxheap )
      JAVA_MISC_OPT="$JAVA_MISC_OPT -XX:MaxHeapFreeRatio=$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
```

## Beep when done

```shell
./run_long.sh; echo -e "\a"
```

## Bash Strict Mode

[Unofficial Strict Mode](http://redsymbol.net/articles/unofficial-bash-strict-mode/)

## Working with processes

Check if a process is running:

```shell
ps -p $PID >&-
```

... returns 0 if the process id exists, and 1 otherwise

* `$!` the PID of the last background job run
* `$?` the return code of the last job that finished
* `wait $PID` blocks until the task completes

## Echo multiline string

The example creates a small executable script that dumps the contents of the root dir.

<!--
```shell
IFS='' read -r -d '' SCRIPT <<"EOF"
#!/bin/bash
ls -lA /
EOF

echo "$SCRIPT" > listroot.sh
chmod +x listroot.sh
```

or ..
-->
```shell
cat <<EOL > listroot.sh
#!/bin/bash
ls -lA /
EOL
chmod +x listroot.sh
```
