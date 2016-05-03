## Rules of Benware

1. If you modify Benware files on a shared machine (not including your own grid_, stimgen_ or expt.mat files), you MUST do this in a named folder, e.g. ‘benware.ben'. Someone else who comes to the computer will reasonably expect the version of benware in c:\benware to be a standard, unmodified version. If this is not the case, it may mess up their experiment. In the future, I will consider it reasonable to update unnamed benware directories to the newest version, potentially erasing your changes.

2. Any changes that you make to Benware files (not including your own grid_, stimgen_ or expt.mat files) MUST be communicated back to me. The best way to do this is to use git/github to “fork” the benware repository, check out your forked version, make changes, and then make a “pull request” to alert me to the changes See:

* [https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/) and 
* [https://help.github.com/articles/using-pull-requests/](https://help.github.com/articles/using-pull-requests/)

If this is too painful for you, I’m probably willing to accept emailed copies of the changed files, but it’s not ideal.

3. If you need help with Benware, you MUST update to the newest version and try again with that version before asking for help. It’s not worth fixing bugs in ancient versions of Benware — this results in repeatedly fixing the same problems, and it’s impossible to keep track of.

4. Every version of benware on our shared machines would be under version control, so it is easy to see what has changed. This can easily be achieved by downloading git from https://git-scm.com/download/win and using the “Git Bash” prompt to get the code from github:.

E.G. Start git bash by double-clicking
```
cd /c/
git clone https://github.com/beniamino38/benware.git
```
—> this will produce a copy of benware in c:\benware (note that git bash uses unix-style /c/ to refer to the c: drive)
