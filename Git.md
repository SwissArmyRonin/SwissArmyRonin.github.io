# Git

## Summarize changes

```shell
git diff @{2023-09-10}.. -- docs/src
git whatchanged --since="last Sunday" -p -- docs/src
```

## Find big files

Find out if large binary files are lurking in the history. Lists all blobs with commit by ascending size:

```shell
git rev-list --objects --all |
  git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
  sed -n 's/^blob //p' |
  sort --numeric-sort --key=2 |
  cut -c 1-12,41- |
  $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 -- \
  round=nearest
```
Src: https://stackoverflow.com/a/42544963/511976

Delete them with `git-filter-repo` (src: https://stackoverflow.com/a/61602985/511976).

## Git helpers

UI: [github.com/mhvelplund/git-bash](https://github.com/mhvelplund/git-bash).

Credentials: [Storing Git Credentials with Git Credential Helper](https://techexpertise.medium.com/storing-git-credentials-with-git-credential-helper-33d22a6b5ce7)


## Move files from one repository to another, preserving git history

Excellent article [here](https://medium.com/@ayushya/move-directory-from-one-repository-to-another-preserving-git-history-d210fa049d4b).

## Move a feature branch from one product to another

If, by accident, one has created a feature ``foo`` from the wrong product 
version branch (eg.: ``tmtand-3.1/develop``) and it really should have started
from another product version branch (eg.: ``tmtand-3.2/develop``)), then it's
easy to rebase the feature on the proper product version with:

    git rebase --onto target-branch source-branch

So in the case above, that would be:

    git checkout tmtand-3.1/feature/foo
    git rebase --onto tmtand-3.2/develop tmtand-3.1/develop

## Working with multiple git repositories

If your product consists of specific versions across multiple repositories, 
there are multiple options for managing that. I prefer 
[Gitslave](http://gitslave.sourceforge.net) or ``gits``.

## Temp. Git ignore

So, to temporarily ignore changes in a certain file, run:

    git update-index --assume-unchanged <file>

Then when you want to track changes again:

    git update-index --no-assume-unchanged <file>

[gimmick:Disqus](swissarmyronin-github-io)