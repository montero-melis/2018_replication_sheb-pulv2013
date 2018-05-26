TO DO's and questions regarding implementation of the Shebani & Pulvermüller paradigm
================================================================================


## Choice of words

- Target verbs -> Can we get 10 items per category?
- Training verbs -> At least 5 items?


## Create pseudo random presentation lists

Is working now, but needs to be adjusted once we have final item lists (training + target)


## Python crashes after each experiment run

Right now Python seems to crash at the end of every complete run of an experiment. The data file is still stored (apparently), but this is still not optimal.


## Instructions

Update based on suggestions by Rita+Pia


## Save data after every trial 

If Python crashes in the middle of the experiment, all data seems to be lost. This hurts if it happens at the end of the experiment. See suggestion by Chuck Theobald in the following link to prevent losing all data:
https://groups.google.com/forum/#!topic/psychopy-users/t-5X-vyh6vg
Or is the data actually retrievable from the .log file???
Check with Gunnar...


## Simplify output data file

Right now there are many unnecessary (completely uninformative) columns in data files. Remove them! (ask Gunnar?)


## Best way to call the experiment?

There are different options for the same PsychoPy script: from builder, directly call ".py" executable, etc. What's the best option?


## Sound recording

- Check it works on project cpu
- Think of how it will work if we have to rely on Zoom recording


## Training phase

- "Train now" and "Ready - press space bar" as 2 separate slides
- Increase to 5-6 items (20-24 words)
- Before starting: "remember the memory phase starts after the 4th word is presented"


## During pilot, reconsider the following

- Length of presentation: 100 ms enough? Seemed very short when I piloted with my wife (and with myself)... maybe 200 ms?
- Length of beep (current 250 ms)
- "fixation point": is this an actual point or perhaps a crosshair? What size? --> careful how size is defined if it's relative to the current monitor!
- Font size okay? Change font so there is difference between instructions and presented words?


## Other

- Set a maximum speed for drumming, e.g. 200 bpm? (Minimum = 100 bpm)
