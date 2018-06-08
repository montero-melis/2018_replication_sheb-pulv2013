TO DO's and questions regarding implementation of the Shebani & Pulvermüller paradigm
================================================================================

# Higher prio

## Add training in control condition at the beginning of experiment

In addition to the block-specific training, all participants could start out with a few trials of training in the basic working memory task (control condition). This will allow them to focus on condition-specific instructions.


## Do we need the articulation condition?

We are interested in the interaction effect arising in the hand vs feet condition. Do we really need the Articulation condition?


## Choice of words/stimuli

- Target verbs -> Can we get 10 items per category?
- Training verbs -> At least 5 items?


## Create presentation lists with final set of target verbs

Is working now, but needs to be adjusted once we have final item lists (training + target); this choice will be based on our norming tasks in the pilot.


## Instructions

Edit as necessary based on pilot. Make sure that the actual study integrates the changes made in the pilot.


## Sound recording

Agree on convention for file naming and where to put backups of sound files


## Max speed for drumming?

Set a maximum speed for drumming, e.g. 200 bpm? (Minimum = 100 bpm)


# Lower prio

## Best way to call the experiment?

There are different options for the same PsychoPy script: from builder, directly call ".py" executable, etc. What's the best option?


## Simplify output data file

Remove unnecessary (uninformative) columns in generated data files?


## During pilot, reconsider the following

- Length of beep (current 250 ms)
- "fixation point": is this an actual point or perhaps a crosshair? What size? --> careful how size is defined if it's relative to the current monitor!
- Font size okay? Change font so there is difference between instructions and presented words?



# SOLVED

## Problems with PsychoPy crashing

We avoid this by not recording audio through PsychoPy. We use an external recorder. This is perfect low-tech solution.


## Save data after every trial

This seems to be working now. PsychoPy hasn't crashed, but when we interrupt the experiment, there is a data csv file for the experiment up to that point.
