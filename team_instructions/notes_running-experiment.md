Notes when running the experiments in PsychoPy
================================

Most of this applies to the experiment "sheb_replic.psyexp", but for the pilot sessions, we use other experiments (see folder `exp-scripts_psychopy/pilot/`)

## Assigning ID's to participants: use ID's in the range 100-499, for pilot 900-989 

With the following additional conventions:
- Use 100-199 for native speakers (starts with 1 as in L1)
- Use 200-299 for L2 speakers (starts with 2 as in L2)
- Use 400-499 for participants recruited for power analyses
- Use 900-989 for participants in the pilot sessions (to determine stimuli presentation rate and verb norming)


## Use "participant number = 990-999" for testing

Use this range whenever we are testing amoung ourselves, running the experiment to check the output, looking for bugs, etc. Data files for participants in the range "990-999" will be ignored from the git repository, i.e. they will not be saved in the repo (see file `.gitignore`).


## Use "session number = 9" (in startup dialogue) to speed through the task

This will set all the timing variables to very short durations, which allows us to run through the experiment waiting for the full 6 seconds of memory period and so on. Any other session number will have the default durations, which follow Shebani & Pulvermüller (2013).

