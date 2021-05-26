# Select a random sample of 5% of trials (60 participant data) to determine inter-rater agreement in transcriptions

import pandas
import re
import os
import random

df_ppts = pandas.read_csv("../participant_data_210526.csv")
valid_id = df_ppts.iloc[:, 1] <= 2  # values of 1 and 2 denote valid participants
df_ppts = df_ppts[valid_id]

ids_valid = []
for id in df_ppts["pptID"].tolist():
    m = re.search("^(\d+),.*", id)
    ids_valid.append(m.group(1))
print(ids_valid)

all_files = os.listdir("../data")

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
                m3 = re.match("^" + valid + "_", mymatch)
                if m3:
                    target_files.append(mymatch)

print(target_files)
print(excluded_files)
print(len(target_files))
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
random.seed(644785366)
sound_files_sample = random.sample(sound_files, k=intended_length)
print(sound_files_sample)
