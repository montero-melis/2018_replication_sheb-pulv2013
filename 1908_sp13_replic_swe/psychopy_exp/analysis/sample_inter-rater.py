# Select a random sample of 5% of trials (60 participant data) to determine inter-rater agreement in transcriptions

import pandas
import re
import os
import random
import shutil

# participant metadata with RA comments
df_ppts = pandas.read_csv("../participant_data_210526.csv")
valid_id = df_ppts.iloc[:, 1] <= 2  # values of 1 and 2 denote valid participants
df_ppts = df_ppts[valid_id]

# extract valid participants' IDs
ids_valid = []
for id in df_ppts["pptID"].tolist():
    m = re.search("^(\d+),.*", id)
    ids_valid.append(m.group(1))
print(ids_valid)

# all participant files generated from psychopy; this include invalid participants, either because they are from pilot
# or bc participant has to be excluded, in which case it's marked with "_excl" at the end of the filename)
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
            for valid in ids_valid:
                m3 = re.match("^" + valid + "_", mymatch)  # check filename corresponds to a valid ID
                if m3:
                    target_files.append(mymatch)

print("\ntarget files:")
print(target_files)
print("how many:")
print(len(target_files))

print("\nexcluded files:")
print(excluded_files)
print("how many:")
print(len(excluded_files))

# Now get all sound files from target participants
sound_files = []
for f in os.listdir("../sound_files"):
    for target in target_files:
        m = re.match(target, f)
        if m:
            m2 = re.search("(practice|training)", f)  # exclude practice/training trials
            if not m2:
                sound_files.append(f)

# Select a random sample of 5% of all trials
intended_length = round(.05 * len(sound_files))
print('There are %s target sound files in total; we select %s (5%%) of them.' % (len(sound_files), intended_length))
random.seed(64478536)
sound_files_sample = random.sample(sound_files, k=intended_length)

# copy them to a separate directory for coding
path_source = "../sound_files/"
path_target = "../sound_files_interrater_agreement/"
if not os.path.exists(path_target):
    os.mkdir(path_target)
for f in sound_files_sample:
    src_path = path_source + f
    shutil.copy(src_path, path_target)
