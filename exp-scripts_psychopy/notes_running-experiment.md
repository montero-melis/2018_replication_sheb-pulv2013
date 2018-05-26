Notes when running the experiment "sheb_replic.psyexp"
================================

## Assigning ID's to participants: use ID's in the range 100-499

With the following additional conventions:
- Use 100-199 for native speakers (starts with 1 as in L1)
- Use 200-299 for L2 speakers (starts with 2 as in L2)
- Use 400-499 for participants recruited for power analyses


## Use "participant number = 900-999" for testing

Use this range whenever we are piloting or running the experiment to check the output, look for bugs, etc. In particular, data files for participant "999" will be ignored from the git repository, i.e. they will not be saved in the repo (see file ".gitignore").


## Use "session number = 9" (in startup dialogue) to speed through the task

This will set all the timing variables to very short durations, which allows us to run through the experiment waiting for the full 6 seconds of memory period and so on. Any other session number will have the default durations, which follow Shebani & Pulvermüller (2013).

