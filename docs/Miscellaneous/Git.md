# Git

<!-- toc -->

## Move files from one repository to another, preserving git history

_Based on Ayushya Jaiswal's excellent article on [Move files from one repository to another, preserving git
history](https://medium.com/@XanderGrzy/how-to-move-files-from-one-git-repo-to-another-preserving-history-2e81e3e3c8b7)._

In the example below, we want to extract a folder (`code/src/utils`) from a mono-repo (`repo1`) into its own repo (`repo2`), 
preserving the git history.

```shell
git clone git@github.com:example/test.git repo1
git clone git@github.com:example/test.git repo2
cd repo2
git remote rm origin
git filter-branch --subdirectory-filter code/src/utils -- --all
git reset --hard
git gc --aggressive 
git prune
git clean -xfd
```

Now only the filtered folder is left, and it's at the root of repo2. If it's going into another repo with existing
files, we can move the things to a sub-folder and commit them before proceeding, but in this case we want them in the
root.

Next, we push them to the new remote repo (which was created ahead of time and left empty):

```shell
git remote add origin git@github.com:example/test-extrusion.git
git branch -M main
git push -u origin main
```

Finally, we should clean up the old repo:

```shell
cd ../repo1
rm -rf code/src/utils
git add -A
git commit
```

Obviously, there might be more refactoring needed, but this is the basic idea.

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

Src: <https://stackoverflow.com/a/42544963/511976>

Delete them with `git-filter-repo` (src: <https://stackoverflow.com/a/61602985/511976>).

## Git helpers

UI: [github.com/mhvelplund/git-bash](https://github.com/mhvelplund/git-bash).

Credentials: [Storing Git Credentials with Git Credential Helper](https://techexpertise.medium.com/storing-git-credentials-with-git-credential-helper-33d22a6b5ce7)

## Move a feature branch from one product to another

If, by accident, one has created a feature ``foo`` from the wrong product
version branch (eg.: ``tmtand-3.1/develop``) and it really should have started
from another product version branch (eg.: ``tmtand-3.2/develop``)), then it's
easy to rebase the feature on the proper product version with:

```shell
git rebase --onto target-branch source-branch
```

So in the case above, that would be:

```shell
git checkout tmtand-3.1/feature/foo
git rebase --onto tmtand-3.2/develop tmtand-3.1/develop
```

## Working with multiple git repositories

If your product consists of specific versions across multiple repositories,
there are multiple options for managing that. I prefer
[Gitslave](http://gitslave.sourceforge.net) or ``gits``.

## Temp. Git ignore

So, to temporarily ignore changes in a certain file, run:

```shell
git update-index --assume-unchanged <file>
```

Then when you want to track changes again:

```shell
git update-index --no-assume-unchanged <file>
```
