Rationale of pilot study
========================

Goals and tasks
---------------

The pilot study had the following goals:

1. Find trial settings for word presentation that leave L2 speakers approximately at 30% error rates in the control condition (which is the error rate of native English speakers reported in Shebani & Pulvermüller, 2013; henceforth S&P)
2. Norm all potential target verbs so we can find at least 40 per category (arm/leg) that have a clear arm/leg bias and are reasonably well known for Swedish L2 speakers of English.

To achieve goal 1, we created an experiment that has four blocks in the control condition (see S&P), with four different PresentationTime: words presented for either 100, 200, 300 or 400 ms. Stimulus Onset Asynchrony (time between stimulus offset and onset of next word) is 400 ms as in the original.
We fully randomize the words to form different items (i.e. groups of 4 words) in each block for each participant. This makes it possible to code for accuracy in remembering individual verbs (as well as 4-word items), which allows us to see which individual verbs are harder/easier to memorize. 

To achieve goal 2, we gave participants a norming task very similar to our previous google-forms:
All 112 verbs are shown in random order. For each verb, participants provide
- hand- and foot-relatedness ratings (which ratings comes first is counterbalanced across participants)
- translation task OR multiple choice task (between participants)


Participants
------------

- We collected data for 16 participants
- Participants were L2+ speakers of English (i.e., they were NOT native English speakers)
- Because of the way we recruited them, they were all speakers of Swedish -- probably most of them were native speakers, but we did not record that information.


Data
----

There is data from three tasks:

a. *sheb_replic_pilot_control*: The memory task reported in S&P under the control condition with three different settings for presentation rate (see Goals and tasks)
b. *verb_rating*: participants rated each verb for its leg- and arm-relatedness on a 1-7 scale
c. *verb_translation_multiple-choice* OR *verb_translation_oral-input*: to test whether participant knew the meaning of the verbs, either tested in a multiple choice format or as oral input (they gave their responses orally and these were subsequently hand-coded as right or wrong)

The 3 digit-number in a file is the participant ID.
When a file is preceded by "CODED" it means that it has been manually coded by one of the RAs.


Analysis
--------

The analysis of the pilot data is reported in the knitr document "pilot_analysis/pilot_analysis.Rmd"
