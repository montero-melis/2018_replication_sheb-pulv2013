# Select a random sample of 5% of trials (60 participant data) to determine inter-rater agreement in transcriptions

import pandas
import re
import os
import random
import shutil

# participant metadata with RA comments
df_ppts = pandas.read_csv("../participant_data_210526.csv")
df_ppts = df_ppts.iloc[:, [0, 1]]  # only 1st two columns needed
df_ppts = df_ppts[df_ppts.iloc[:, 1] <= 2]  # values of 1 and 2 on col2 denote valid participants
print(df_ppts)

# for each participant, obtain a list containing the two arm/leg blocks
def find_blocks(str):
    m = re.match("\d+,(\w+)-(\w+)-(\w+),.*", str)
    conds = [m.group(1), m.group(2), m.group(3)]
    blocks = []
    i = 0
    for cond in conds:
        i += 1
        if cond in ["arm", "leg"]:
            blocks.append(i)
    return blocks

# append as a column to dataframe
armleg_blocks = []
for ppt in df_ppts["pptID"]:
    armleg_blocks.append(find_blocks(ppt))
df_ppts["armleg_blocks"] = armleg_blocks
print(df_ppts)

# IDs of valid participants
IDs = []
for id in df_ppts["pptID"].tolist():
    m = re.search("^(\d+),.*", id)
    IDs.append(m.group(1))
# append as col to df
df_ppts["IDs"] = IDs
print(df_ppts)

# now simplify dataframe to just contain unique combinations of valid IDs and their arm/leg blocks as a list
df_valid = df_ppts[["IDs", "armleg_blocks"]].drop_duplicates(subset="IDs")
print(df_valid)
print(df_valid.shape[0])

print("\nThese are the %s valid IDs:" % df_valid.shape[0])
print(df_valid["IDs"].tolist())

# Read all participant files generated from psychopy; this includes invalid participants, either because they are from
# pilot or bc participant has to be excluded, in which case it's marked with "_excl" at the end of the filename)
all_files = os.listdir("../data")

# make the selection of valid files
target_files = []
excluded_files = []  # to verify what we're excluding

for f in all_files:
    m = re.match("(.*)\.csv", f)  # csv only
    if m:
        mymatch = m.group(1)  # file name without extension
        m2 = re.search("excl", mymatch)  # exclude 'excl' files
        if m2:
            excluded_files.append(mymatch)
        else:
            id_match = re.match("^(\d+)_.*", mymatch)  # extract ID
            if id_match.group(1) in df_ppts["IDs"].tolist():
                target_files.append(mymatch)

# we only want to keep the first 60 participants for the first analysis:
target_files = target_files[:60]

print("\nThere are %s target participants:" % len(target_files))
print(target_files)

# Now get all sound files from arm/leg blocks from target participants
path_source = "../sound_recording/"
sound_files = []

for f in os.listdir(path_source):
    m = re.match("^(\d+)_.*_block_([0-3]).*", f)
    ppt_id = m.group(1)
    block = int(m.group(2))  # convert from string to int for later pattern matching
    for target in target_files:
        match_target = re.match(target, f)  # does f match a target file?
        if match_target:
            match_training = re.search("(practice|training)", f)  # exclude practice/training trials
            if not match_training:
                # check the valid blocks for that participant ID (depends on block order, see Ls 15-31)
                valid_blocks = df_valid.loc[df_valid["IDs"] == ppt_id]["armleg_blocks"]
                valid_blocks = valid_blocks.tolist()[0]  # extract list within list
                if block in valid_blocks:
                    sound_files.append(f)  # append only if it passes all the tests

# Select a random sample of 5% of all trials
intended_length = round(.05 * len(sound_files))
print('\nThere are %s target sound files in total; we select %s (5%%) of them.' % (len(sound_files), intended_length))
random.seed(64478536)
sound_files_sample = random.sample(sound_files, k=intended_length)

# copy them to a separate directory for coding
path_target = "../sound_recording_interrater_agreement/"
if not os.path.exists(path_target):
    os.mkdir(path_target)
for f in sound_files_sample:
    src_path = path_source + f
    shutil.copy(src_path, path_target)
