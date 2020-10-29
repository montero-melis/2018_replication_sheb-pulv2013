Work with branches in git (quick notes)
===============

Petrus and I should work on different branches

- Each of us makes whatever changes on their branch, pushes to github from and to their branch
- We use pull request to bring the changes to master

If I make a change that I want Petrus to test:
- I make the change on my local branch and push to the origin of that branch on github
- I initiate a pull request
- Petrus checks out my branch and pulls from origin
- He tests it's working fine. If yes, he notifies me
- I approve the pull request on github and merge changes into main
- Petrus now needs to integrate those changes into his repo, in one of 2 ways:
	- check out master locally, pulling, checkout his branch, merge master petrus_b
	- alternatively: use git rebase --> This is the cleaner option according to jaime,
		but it presupposes he hasn't yet pushed his changes to github (otherwise he'll
		need to "rewrite" history [I])


Step by step (for Petrus)
------------

(see https://forum.freecodecamp.org/t/push-a-new-local-branch-to-a-remote-git-repository-and-track-it-too/13222)

AS A GENERAL RULE, WE WILL ALWAYS WORK (AND PUSH) FROM OUR OWN BRANCHES!

Workflow:

1. git checkout master
2. git pull
3. git branch -D petrus
4. git checkout -b petrus
5. do your work and commit and when ready to push:
6. git push --force -u origin petrus (this will overwrite the petrus branch in origin)
7. do more work locally and commit as needed
8. git push
9. repeat if necessary
10. when ready to merge to master, initiate a pull request from github 
11. once the pull request is accepted, start again from 1. ...


Here is a bit of an explanation of te different steps involved:

git pull
--> fetch and merge from origin/master (this assumes you are on branch master locally)

git branch
--> see branches in your local repo

git branch -r
--> see remote branches

Now, the firs time, depending on whether work has already been committed to master or not, Petrus might need to first do a git push from master

git checkout -b petrus
--> create local branch called petrus and checkout (switch to) that branch

do your work here, commit what there is to commit

git remote show origin
--> Take a look at which local branches track which remote branches

git push -u origin petrus
--> Push your branch to the remote repository; this will work the first time, but after deleting the branch locally and if there is such a branch in the remote, you will need to use the --force argument (see step 6 above)

git remote show origin
--> Take a look at which local branches track which remote branches. Now petrus should track remote petrus

Now from Github you can initiate a "pull request", which Guillermo will have to approve.

Once your branch is merged with master on Github, you start all over again.


Potentially useful stuff
------------------------

A good explanation of rebase vs merge
https://www.atlassian.com/git/tutorials/merging-vs-rebasing

Use of git fetch
https://www.atlassian.com/git/tutorials/syncing/git-fetch
See "git fetch a remote branch" to see how to check out a remote branch and see what's in it.
