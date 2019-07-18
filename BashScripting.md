# Bash scripting

# Working with processes

Check if a process is running:

```bash
ps -p $PID >&-
```

... returns 0 if the process id exists, and 1 otherwise

* `$!` the PID of the last background job run
* `$?` the return code of the last job that finished
* `wait $PID` blocks until the task completes

## Echo multiline string

```bash
IFS='' read -r -d '' SCRIPT <<"EOF"
#!/bin/bash
ls -lA /
EOF

echo "$SCRIPT" > listroot.sh
chmod +x listroot.sh
```

[gimmick:Disqus](swissarmyronin-github-io)