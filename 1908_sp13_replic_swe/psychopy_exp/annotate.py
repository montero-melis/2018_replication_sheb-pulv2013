"""Simple script for annotating/transcribing participant recordings."""
# Jeroen van Paridon, vanparidon@wisc.edu
import pandas as pd
import sounddevice as sd
import soundfile as sf
import argparse
import os


def annotate(folder):
    # check if an tsv with annotations already exists and if so, load it into a df
    if os.path.exists('data.tsv'):
        df = pd.read_csv('data.tsv', sep='\t')
    else:
        df = pd.DataFrame(columns=['filename', 'transcription', 'comment'])

    # read files from folder and select only .wav audio files
    fnames = sorted(os.listdir(folder))
    fnames = [fname for fname in os.listdir(folder) if fname.endswith('.wav')]

    # loop over audio files and check if each file is not already annotated in df
    for fname in fnames:
        if fname not in df['filename'].values:

            # read metadata from filename and set up data for df entry
            fname_parts = fname.replace('.wav', '').split('_')
            entry = {
                'filename': fname,
                'participant': fname_parts[0],
                'date_time': '/'.join(fname_parts[4:8]),
                'block': fname_parts[9],
                'block_type': fname_parts[12],
                'trial': fname_parts[13],
            }

            # read audio from .wav file and play on a loop
            wav, hz = sf.read(os.path.join(folder, fname))
            sd.play(wav, hz, loop=True)

            # get inputs for transcription and comment
            print(f'\nannotating file: {fname}')
            entry['transcription'] = input('transcription: ')
            entry['comment'] = input('comment: ')

            # write new entry to df and tsv
            df = df.append(entry, ignore_index=True)
            df.to_csv('data.tsv', sep='\t', index=False)

    # end annotation routine and display df
    print('\n###\n')
    print(df)
    print(f'\n###\n\nfinished annotating {len(df)} files')


if __name__ == '__main__':
    argparser = argparse.ArgumentParser('simple script for annotating/transcribing participant recordings')
    argparser.add_argument('folder', help='folder containing audio files of participant recordings')
    args = argparser.parse_args()
    annotate(args.folder)
