Workflow for data coding 1810_replication-natives
=================================================

## Files in 1810_replication-natives_analysis/data_coding

The folder 1810_replication-natives_analysis/data_coding contains files that either:

- need to be coded (filename starts with "TOCODE"),
- are coded (filename starts with "CODED"), or
- are being coded (filename starts with "CODING").

The format of any filename is thus `<coding-status>_<participantID>_<experiment-name>.csv`.


## Software for coding

We will code in any program that supports spreadsheets, such as Excel or its equivalent open/free version (henceforth SP for spreadsheet program). How you execute some of the steps below might be specific to the very program you are using, but they are all supported.


## Steps to start coding

When you start coding the data from a new participant

1. Open a new file in your SP;
2. Select the "Import data from text" (or equivalent) option from your SP;
3. Choose the data file you are going to start coding; it should be of the form `TOCODE_<participantID>_<experiment-name>.csv`
4. In the menu that shows up, select for file origin encoding (or equivalent) the option "Unicode (UTF-8)"; for original data type choose "Delimited"; as delimiters, choose "Comma"
5. Check the spreadsheet looks as it should (data divided in columns with sensible names, no strange-looking characters).
6. Fill in your initials in the first row of the last column coder (e.g., GMM)
7. Directly save this spreadsheet into the same folder pilot_analysis/data_coding/, but changing its name to `CODING_<participantID>_<experiment-name>.csv` (participantID and experiment-name are the same as in the "TOCODE" version of the file). Use the "Save As" option and be sure to save the file as a CSV (comma-separated values) file; if your software allows choosing the file encoding, choose "Unicode (UTF-8)"
8. Do a git push -- this will prevent someone else in the team from starting to code the same data as you!
9. Now you are ready to start coding!


## Error types

- `O` = *omission*: The participant omits a word, either by silence or saying "something", "I can't remember" or something similar that indicates that they don't know.
- `R` = *replacement*: The participant replaces the target word with another word. This is the code `R=...`
- `S` = *shift/transposition*: The participant says a target word but in the wrong place/slot. This error is why it is important to code the response words in the exact same order as the participant says them. 
- `A` = *addition*: The participant adds a fifth (or more) word, which is clearly just an addition and *not* a replacement. This is the code `A=...`


## Coding the data

NB:

- Make sure you open the sound file for the right participant.
- A program like [Audacity](https://www.audacityteam.org/) (which can be downloaded for free) shows where there is sound in the file (shows up as waves), so it will be easier to navigate the sound file.
- Save frequently while coding to avoid losing work!


## Columns that need to be coded

For `1810_replication-natives_analysis` there are the following columns:

**response**: this is where most of the coding will happen. For each trial write the participant's responses following these guidelines: 

1. Write the correctly remembered target words (i.e., those words that actually appeared in the corresponding trial) in the exact order the participant says them. Think as each word occupying a slot, and there are four slots per trial.
2. Separate each word with a comma, and do not use any spaces.
3. If the participant omits one word, or says "I don't know, I can't remember, something" or something similar that clearly indicates they cannot remember one of the target words, write `O` (for omission) instead, in the same slot where you would otherwise write the target word. Also separate the `O` from the other target words with commas.
4. If the participant replaces a target word with another word, e.g. says "pluck" instead of the target word "pat", annotate this by writing `R=pluck` ("R" for replacement) in the slot that would otherwise correspond to the word "pat". Also separate `R=pluck` with commas and do not use any spaces. If the participant says more than one replacement word for the same target word, e.g. "pluck, clutch" rather than just "pluck", separate the different replacement words with `/` like this: 
`R=pluck/clutch`.
5. If the participant says five words, and it is clear that there are not two replacement words for the same target word (see example 3 below), then we code it as an addition, which is alway put at the end of the responses, after the 4th slot. We code it like this: `A=<added_word>`
and also separate it from the other responses with a comma, and use no spaces. If there is more than one addition, we separate them the same way we do with replacements, i.e., `A=strike/trot` (see example 5 below)

Here are some examples to clarify:

Ex.1: 

- Trial 1 target words: rub pat poke clean
- Participant's response: "rub pluck something clean"
- Code like this: `rub,R=pluck,O,clean`

Ex.2: 

- Trial 2 target words: trudge glide wander skate
- Participant's response: "trudge something something skate"
- Code like this: `trudge,O,O,skate`

Ex.3: 

- Trial 3 target words: wipe pull snatch scoop
- Participant's response: "wipe something snatch... scuffle? scratch?"
- Code like this: `wipe,O,snatch,R=scuffle/scratch`

Ex.4: 

- Trial 4 target words: wash clap brush catch
- Participant's response: wash brush clean clap
- Code like this: `wash,brush,R=clean,clap`
- NB: Remember to put the "R=..." In the same position as it appeared.

Ex.5:

- Trial 5 target words: hop stomp hike kick
- Participant's response: jog kick step jump strike trot
- Code like this: `R=jog,kick,R=step,R=jump,A=strike/trot`

**comment**: Write any comment that might seem relevant here. For example, if the participants hesitates a lot. Take note of any coding difficulty you notice, so we can discuss it later. Here you can also note the exact time if you have to stop coding a file half-way through and will continue at a later stage. 

**coder**: write your initials in the first row. 


## After coding

Look through the transcript and make sure there are no typos, as typos will mess up the script that we'll run on the coded data to count the errors. Double check that you correctly coded all the replacements as `R=...`, etc.
