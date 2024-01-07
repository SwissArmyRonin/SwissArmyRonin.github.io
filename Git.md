# Git

## Git helpers

Install [github.com/mhvelplund/git-bash](https://github.com/mhvelplund/git-bash).

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