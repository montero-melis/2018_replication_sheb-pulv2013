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


A good explanation of rebase vs merge
https://www.atlassian.com/git/tutorials/merging-vs-rebasing

Step by step (for Petrus)
------------

(see https://forum.freecodecamp.org/t/push-a-new-local-branch-to-a-remote-git-repository-and-track-it-too/13222)


AS A GENERAL RULE, WE WILL ALWAYS WORK (AND PUSH) FROM OUR OWN BRANCHES!

git branch
--> see branches in your local repo

git branch -r
--> see remote branches

git checkout -b petrus
--> create local branch called petrus and checkout (switch to) that branch

Now depending on whether work has been committed to master or not, Petrus will need to either commit from his own branch or merge from master

git push -u origin petrus
--> Push your branch to the remote repository

Now from Github you can initiate a "pull request"
