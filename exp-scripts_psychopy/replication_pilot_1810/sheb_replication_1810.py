#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy2 Experiment Builder (v1.90.1),
    on september 27, 2018, at 09:45
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
from psychopy import locale_setup, sound, gui, visual, core, data, event, logging, clock, microphone
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle
import os  # handy system and path functions
import sys  # to get file system encoding

# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__)).decode(sys.getfilesystemencoding())
os.chdir(_thisDir)

# Store info about the experiment session
expName = u'sheb_replication_1810'  # from the Builder filename that created this script
expInfo = {u'session': u'specify!', u'participant': u''}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath=None,
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# Start Code - component code to be run before the window creation
wavDirName = filename + '_wav'
if not os.path.isdir(wavDirName):
    os.makedirs(wavDirName)  # to hold .wav files
wavDirName = filename + '_wav'
if not os.path.isdir(wavDirName):
    os.makedirs(wavDirName)  # to hold .wav files

# Setup the Window
win = visual.Window(
    size=[1920, 1200], fullscr=True, screen=0,
    allowGUI=False, allowStencil=False,
    monitor=u'testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True)

# Enable sound input/output:
microphone.switchOn()
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "instr_welcome"
instr_welcomeClock = core.Clock()
## Set global (experiment-level) variables

pptID = int(expInfo['participant'])  # participant ID
print("participant ID is " + `pptID`)

sess = int(expInfo['session'])  # session converted to int

myBlockCount = 0  # count blocks to use in text displays

path2stimuli = u'stimuli\\presentation_lists\\'
print(path2stimuli)

## Duration-related variables (set here rather than in individ elements)

# If session = 9, then speed through the screens
if sess == 9: 
    fix_point_duration = .05  # orig = 3
    word_duration = .1  # how long is each word shown for (orig = .1)
    SOA = .15  # stimulus onset asynchrony (orig = .5)
    mem_per = .05 # time during which words have to be kept in memory (orig = 6)
else:  # otherwise use the standard duration
    fix_point_duration = 3  # orig = 3
    word_duration = .2  # how long is each word shown for (orig = .1)
    SOA = .5  # stimulus onset asynchrony (orig = .5)
    mem_per = 6 # time during which words have to be kept in memory (orig = 6)

max_response_time = 120  # max time to repeat words before moving to next trial
min_response_time = 0  # minimum time before participants can press SPACE to move on


## Other

cont = "\n\nPress space bar to continue"  # At the end of instructions slides
text_7 = visual.TextStim(win=win, name='text_7',
    text="Welcome to this experiment!\n\nIn this task you will see four words in a sequence and you will have to remember them. Shortly after, you will be asked to repeat the words in the exact same sequence." + cont,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "instr_exp1"
instr_exp1Clock = core.Clock()
text_8 = visual.TextStim(win=win, name='text_8',
    text="It works like this:\n\nYou see four words presented on the screen one after another, followed by a pause during which you have to keep the four words in memory in the exact order they were presented. You will then hear a beep. At the beep, you have to repeat the four words out loud. Your voice will be recorded as you repeat the words." + cont,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instr_exp2"
instr_exp2Clock = core.Clock()
text_9 = visual.TextStim(win=win, name='text_9',
    text="The experiment consists of four parts. In each part, you will be asked to memorize the words while doing different exercises. You will either have to wait silently, perform a rhythmic pattern with your hands or with your feet, or repeat the syllable 'bla'. At the beginning of each part you will receive detailed instructions from the experimenter and you will have plenty of time to practice." + cont,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instr_exp3"
instr_exp3Clock = core.Clock()
text_10 = visual.TextStim(win=win, name='text_10',
    text="You will be able to take a break at the end of each part. You can also take a break between trials if needed.\n\nIf you have questions so far, you may ask the experimenter now." + cont
,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "block_instr"
block_instrClock = core.Clock()

block_intro = visual.TextStim(win=win, name='block_intro',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "block_instr2"
block_instr2Clock = core.Clock()
text_2 = visual.TextStim(win=win, name='text_2',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "block_instr3"
block_instr3Clock = core.Clock()
text_11 = visual.TextStim(win=win, name='text_11',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "train"
trainClock = core.Clock()
text_4 = visual.TextStim(win=win, name='text_4',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "fixation"
fixationClock = core.Clock()
point = visual.Polygon(
    win=win, name='point',
    edges=999, size=(0.035, 0.05),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[1,1,1], lineColorSpace='rgb',
    fillColor=[1,1,1], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)

# Initialize components for Routine "display_words"
display_wordsClock = core.Clock()
w1 = visual.TextStim(win=win, name='w1',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
w2 = visual.TextStim(win=win, name='w2',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);
w3 = visual.TextStim(win=win, name='w3',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-2.0);
w4 = visual.TextStim(win=win, name='w4',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);
memory_period = visual.TextStim(win=win, name='memory_period',
    text=None,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-4.0);

# Initialize components for Routine "repeat_words"
repeat_wordsClock = core.Clock()
sound_2 = sound.Sound('880', secs=0.25)
sound_2.setVolume(1)

# Initialize components for Routine "repeat_training"
repeat_trainingClock = core.Clock()
text_5 = visual.TextStim(win=win, name='text_5',
    text="If you need more practice, press 'p'; if you are ready to start the actual experiment, press 's'.",
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);


# Initialize components for Routine "instr_start_real_thing"
instr_start_real_thingClock = core.Clock()
text_3 = visual.TextStim(win=win, name='text_3',
    text="Ready?" + cont,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "fixation"
fixationClock = core.Clock()
point = visual.Polygon(
    win=win, name='point',
    edges=999, size=(0.035, 0.05),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[1,1,1], lineColorSpace='rgb',
    fillColor=[1,1,1], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)

# Initialize components for Routine "display_words"
display_wordsClock = core.Clock()
w1 = visual.TextStim(win=win, name='w1',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);
w2 = visual.TextStim(win=win, name='w2',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);
w3 = visual.TextStim(win=win, name='w3',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-2.0);
w4 = visual.TextStim(win=win, name='w4',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-3.0);
memory_period = visual.TextStim(win=win, name='memory_period',
    text=None,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-4.0);

# Initialize components for Routine "repeat_words"
repeat_wordsClock = core.Clock()
sound_2 = sound.Sound('880', secs=0.25)
sound_2.setVolume(1)

# Initialize components for Routine "end_block"
end_blockClock = core.Clock()
text_6 = visual.TextStim(win=win, name='text_6',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "thanks"
thanksClock = core.Clock()
text = visual.TextStim(win=win, name='text',
    text='The experiment is over.\n\nThank you for participating!',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "instr_welcome"-------
t = 0
instr_welcomeClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat

key_resp_10 = event.BuilderKeyResponse()
# keep track of which components have finished
instr_welcomeComponents = [text_7, key_resp_10]
for thisComponent in instr_welcomeComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instr_welcome"-------
while continueRoutine:
    # get current time
    t = instr_welcomeClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    
    # *text_7* updates
    if t >= 0.0 and text_7.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_7.tStart = t
        text_7.frameNStart = frameN  # exact frame index
        text_7.setAutoDraw(True)
    
    # *key_resp_10* updates
    if t >= 0.0 and key_resp_10.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_10.tStart = t
        key_resp_10.frameNStart = frameN  # exact frame index
        key_resp_10.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_10.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instr_welcomeComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instr_welcome"-------
for thisComponent in instr_welcomeComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# the Routine "instr_welcome" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instr_exp1"-------
t = 0
instr_exp1Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_11 = event.BuilderKeyResponse()
# keep track of which components have finished
instr_exp1Components = [text_8, key_resp_11]
for thisComponent in instr_exp1Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instr_exp1"-------
while continueRoutine:
    # get current time
    t = instr_exp1Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_8* updates
    if t >= 0.0 and text_8.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_8.tStart = t
        text_8.frameNStart = frameN  # exact frame index
        text_8.setAutoDraw(True)
    
    # *key_resp_11* updates
    if t >= 0.0 and key_resp_11.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_11.tStart = t
        key_resp_11.frameNStart = frameN  # exact frame index
        key_resp_11.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_11.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instr_exp1Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instr_exp1"-------
for thisComponent in instr_exp1Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instr_exp1" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instr_exp2"-------
t = 0
instr_exp2Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_12 = event.BuilderKeyResponse()
# keep track of which components have finished
instr_exp2Components = [text_9, key_resp_12]
for thisComponent in instr_exp2Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instr_exp2"-------
while continueRoutine:
    # get current time
    t = instr_exp2Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_9* updates
    if t >= 0.0 and text_9.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_9.tStart = t
        text_9.frameNStart = frameN  # exact frame index
        text_9.setAutoDraw(True)
    
    # *key_resp_12* updates
    if t >= 0.0 and key_resp_12.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_12.tStart = t
        key_resp_12.frameNStart = frameN  # exact frame index
        key_resp_12.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_12.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instr_exp2Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instr_exp2"-------
for thisComponent in instr_exp2Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instr_exp2" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "instr_exp3"-------
t = 0
instr_exp3Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_13 = event.BuilderKeyResponse()
# keep track of which components have finished
instr_exp3Components = [text_10, key_resp_13]
for thisComponent in instr_exp3Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instr_exp3"-------
while continueRoutine:
    # get current time
    t = instr_exp3Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_10* updates
    if t >= 0.0 and text_10.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_10.tStart = t
        text_10.frameNStart = frameN  # exact frame index
        text_10.setAutoDraw(True)
    
    # *key_resp_13* updates
    if t >= 0.0 and key_resp_13.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_13.tStart = t
        key_resp_13.frameNStart = frameN  # exact frame index
        key_resp_13.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_13.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instr_exp3Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instr_exp3"-------
for thisComponent in instr_exp3Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instr_exp3" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
block = data.TrialHandler(nReps=1, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('conditions_block.csv'),
    seed=None, name='block')
thisExp.addLoop(block)  # add the loop to the experiment
thisBlock = block.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlock.rgb)
if thisBlock != None:
    for paramName in thisBlock:
        exec('{} = thisBlock[paramName]'.format(paramName))

for thisBlock in block:
    currentLoop = block
    # abbreviate parameter names if possible (e.g. rgb = thisBlock.rgb)
    if thisBlock != None:
        for paramName in thisBlock:
            exec('{} = thisBlock[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "block_instr"-------
    t = 0
    block_instrClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    myBlockCount += 1
    
    curr_ppt_block = "p" + `pptID` + "_b" + `myBlockCount`
    print(curr_ppt_block)
    
    curr_list_training = path2stimuli + curr_ppt_block + '_training.csv'
    print(curr_list_training)
    
    curr_list_targets = path2stimuli + curr_ppt_block + '_targets.csv'
    print(curr_list_targets)
    
    block_intro.setText("Part " + `myBlockCount` + ": Memorizing " + BlockLabel + cont)
    key_resp_4 = event.BuilderKeyResponse()
    # keep track of which components have finished
    block_instrComponents = [block_intro, key_resp_4]
    for thisComponent in block_instrComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "block_instr"-------
    while continueRoutine:
        # get current time
        t = block_instrClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        # *block_intro* updates
        if t >= 0.0 and block_intro.status == NOT_STARTED:
            # keep track of start time/frame for later
            block_intro.tStart = t
            block_intro.frameNStart = frameN  # exact frame index
            block_intro.setAutoDraw(True)
        
        # *key_resp_4* updates
        if t >= 0.0 and key_resp_4.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_4.tStart = t
            key_resp_4.frameNStart = frameN  # exact frame index
            key_resp_4.status = STARTED
            # keyboard checking is just starting
            event.clearEvents(eventType='keyboard')
        if key_resp_4.status == STARTED:
            theseKeys = event.getKeys(keyList=['space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in block_instrComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "block_instr"-------
    for thisComponent in block_instrComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # the Routine "block_instr" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "block_instr2"-------
    t = 0
    block_instr2Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_2.setText("In each trial, you will see four words flashed one after the other, and your task is to memorize them in the order they were presented. Immediately after the fourth word, you will have to " + BlockInstructions + " until you hear a beep. At the beep, you will have to repeat the four words." + cont)
    key_resp_5 = event.BuilderKeyResponse()
    # keep track of which components have finished
    block_instr2Components = [text_2, key_resp_5]
    for thisComponent in block_instr2Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "block_instr2"-------
    while continueRoutine:
        # get current time
        t = block_instr2Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_2* updates
        if t >= 0.0 and text_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_2.tStart = t
            text_2.frameNStart = frameN  # exact frame index
            text_2.setAutoDraw(True)
        
        # *key_resp_5* updates
        if t >= 0.0 and key_resp_5.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_5.tStart = t
            key_resp_5.frameNStart = frameN  # exact frame index
            key_resp_5.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_5.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_5.status == STARTED:
            theseKeys = event.getKeys(keyList=['space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_5.keys = theseKeys[-1]  # just the last key pressed
                key_resp_5.rt = key_resp_5.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in block_instr2Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "block_instr2"-------
    for thisComponent in block_instr2Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_5.keys in ['', [], None]:  # No response was made
        key_resp_5.keys=None
    block.addData('key_resp_5.keys',key_resp_5.keys)
    if key_resp_5.keys != None:  # we had a response
        block.addData('key_resp_5.rt', key_resp_5.rt)
    # the Routine "block_instr2" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "block_instr3"-------
    t = 0
    block_instr3Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_11.setText("You will now receive detailed instructions from the experimenter and you will get some practice before starting with the actual task.\n(" + BlockType + ")")
    key_resp_15 = event.BuilderKeyResponse()
    # keep track of which components have finished
    block_instr3Components = [text_11, key_resp_15]
    for thisComponent in block_instr3Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "block_instr3"-------
    while continueRoutine:
        # get current time
        t = block_instr3Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_11* updates
        if t >= 0.0 and text_11.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_11.tStart = t
            text_11.frameNStart = frameN  # exact frame index
            text_11.setAutoDraw(True)
        
        # *key_resp_15* updates
        if t >= 0.0 and key_resp_15.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_15.tStart = t
            key_resp_15.frameNStart = frameN  # exact frame index
            key_resp_15.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_15.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_15.status == STARTED:
            theseKeys = event.getKeys(keyList=['return'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_15.keys = theseKeys[-1]  # just the last key pressed
                key_resp_15.rt = key_resp_15.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in block_instr3Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "block_instr3"-------
    for thisComponent in block_instr3Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_15.keys in ['', [], None]:  # No response was made
        key_resp_15.keys=None
    block.addData('key_resp_15.keys',key_resp_15.keys)
    if key_resp_15.keys != None:  # we had a response
        block.addData('key_resp_15.rt', key_resp_15.rt)
    # the Routine "block_instr3" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "train"-------
    t = 0
    trainClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_4.setText("Now you will first do some practice trials before starting the real task." + cont)
    key_resp_6 = event.BuilderKeyResponse()
    # keep track of which components have finished
    trainComponents = [text_4, key_resp_6]
    for thisComponent in trainComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "train"-------
    while continueRoutine:
        # get current time
        t = trainClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_4* updates
        if t >= 0.0 and text_4.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_4.tStart = t
            text_4.frameNStart = frameN  # exact frame index
            text_4.setAutoDraw(True)
        
        # *key_resp_6* updates
        if t >= 0.0 and key_resp_6.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_6.tStart = t
            key_resp_6.frameNStart = frameN  # exact frame index
            key_resp_6.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_6.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_6.status == STARTED:
            theseKeys = event.getKeys(keyList=['space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_6.keys = theseKeys[-1]  # just the last key pressed
                key_resp_6.rt = key_resp_6.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trainComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "train"-------
    for thisComponent in trainComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_6.keys in ['', [], None]:  # No response was made
        key_resp_6.keys=None
    block.addData('key_resp_6.keys',key_resp_6.keys)
    if key_resp_6.keys != None:  # we had a response
        block.addData('key_resp_6.rt', key_resp_6.rt)
    # the Routine "train" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    training_block = data.TrialHandler(nReps=20, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=[None],
        seed=None, name='training_block')
    thisExp.addLoop(training_block)  # add the loop to the experiment
    thisTraining_block = training_block.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisTraining_block.rgb)
    if thisTraining_block != None:
        for paramName in thisTraining_block:
            exec('{} = thisTraining_block[paramName]'.format(paramName))
    
    for thisTraining_block in training_block:
        currentLoop = training_block
        # abbreviate parameter names if possible (e.g. rgb = thisTraining_block.rgb)
        if thisTraining_block != None:
            for paramName in thisTraining_block:
                exec('{} = thisTraining_block[paramName]'.format(paramName))
        
        # set up handler to look after randomisation of conditions etc
        word_presentation_training = data.TrialHandler(nReps=1, method='random', 
            extraInfo=expInfo, originPath=-1,
            trialList=data.importConditions(curr_list_training),
            seed=None, name='word_presentation_training')
        thisExp.addLoop(word_presentation_training)  # add the loop to the experiment
        thisWord_presentation_training = word_presentation_training.trialList[0]  # so we can initialise stimuli with some values
        # abbreviate parameter names if possible (e.g. rgb = thisWord_presentation_training.rgb)
        if thisWord_presentation_training != None:
            for paramName in thisWord_presentation_training:
                exec('{} = thisWord_presentation_training[paramName]'.format(paramName))
        
        for thisWord_presentation_training in word_presentation_training:
            currentLoop = word_presentation_training
            # abbreviate parameter names if possible (e.g. rgb = thisWord_presentation_training.rgb)
            if thisWord_presentation_training != None:
                for paramName in thisWord_presentation_training:
                    exec('{} = thisWord_presentation_training[paramName]'.format(paramName))
            
            # ------Prepare to start Routine "fixation"-------
            t = 0
            fixationClock.reset()  # clock
            frameN = -1
            continueRoutine = True
            # update component parameters for each repeat
            # keep track of which components have finished
            fixationComponents = [point]
            for thisComponent in fixationComponents:
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            
            # -------Start Routine "fixation"-------
            while continueRoutine:
                # get current time
                t = fixationClock.getTime()
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *point* updates
                if t >= 0.0 and point.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    point.tStart = t
                    point.frameNStart = frameN  # exact frame index
                    point.setAutoDraw(True)
                frameRemains = 0.0 + fix_point_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
                if point.status == STARTED and t >= frameRemains:
                    point.setAutoDraw(False)
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in fixationComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # check for quit (the Esc key)
                if endExpNow or event.getKeys(keyList=["escape"]):
                    core.quit()
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # -------Ending Routine "fixation"-------
            for thisComponent in fixationComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            # the Routine "fixation" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # ------Prepare to start Routine "display_words"-------
            t = 0
            display_wordsClock.reset()  # clock
            frameN = -1
            continueRoutine = True
            # update component parameters for each repeat
            w1.setText(word1)
            w2.setText(word2)
            w3.setText(word3)
            w4.setText(word4)
            # keep track of which components have finished
            display_wordsComponents = [w1, w2, w3, w4, memory_period]
            for thisComponent in display_wordsComponents:
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            
            # -------Start Routine "display_words"-------
            while continueRoutine:
                # get current time
                t = display_wordsClock.getTime()
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *w1* updates
                if t >= 0.0 and w1.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    w1.tStart = t
                    w1.frameNStart = frameN  # exact frame index
                    w1.setAutoDraw(True)
                frameRemains = 0.0 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
                if w1.status == STARTED and t >= frameRemains:
                    w1.setAutoDraw(False)
                
                # *w2* updates
                if t >= SOA and w2.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    w2.tStart = t
                    w2.frameNStart = frameN  # exact frame index
                    w2.setAutoDraw(True)
                frameRemains = SOA + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
                if w2.status == STARTED and t >= frameRemains:
                    w2.setAutoDraw(False)
                
                # *w3* updates
                if t >= SOA*2 and w3.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    w3.tStart = t
                    w3.frameNStart = frameN  # exact frame index
                    w3.setAutoDraw(True)
                frameRemains = SOA*2 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
                if w3.status == STARTED and t >= frameRemains:
                    w3.setAutoDraw(False)
                
                # *w4* updates
                if t >= SOA*3 and w4.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    w4.tStart = t
                    w4.frameNStart = frameN  # exact frame index
                    w4.setAutoDraw(True)
                frameRemains = SOA*3 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
                if w4.status == STARTED and t >= frameRemains:
                    w4.setAutoDraw(False)
                
                # *memory_period* updates
                if t >= SOA*3 + word_duration and memory_period.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    memory_period.tStart = t
                    memory_period.frameNStart = frameN  # exact frame index
                    memory_period.setAutoDraw(True)
                frameRemains = SOA*3 + word_duration + mem_per- win.monitorFramePeriod * 0.75  # most of one frame period left
                if memory_period.status == STARTED and t >= frameRemains:
                    memory_period.setAutoDraw(False)
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in display_wordsComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # check for quit (the Esc key)
                if endExpNow or event.getKeys(keyList=["escape"]):
                    core.quit()
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # -------Ending Routine "display_words"-------
            for thisComponent in display_wordsComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            # the Routine "display_words" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            
            # ------Prepare to start Routine "repeat_words"-------
            t = 0
            repeat_wordsClock.reset()  # clock
            frameN = -1
            continueRoutine = True
            # update component parameters for each repeat
            mic_1 = microphone.AdvAudioCapture(name='mic_1', saveDir=wavDirName, stereo=False)
            key_resp_2 = event.BuilderKeyResponse()
            # keep track of which components have finished
            repeat_wordsComponents = [mic_1, key_resp_2, sound_2]
            for thisComponent in repeat_wordsComponents:
                if hasattr(thisComponent, 'status'):
                    thisComponent.status = NOT_STARTED
            
            # -------Start Routine "repeat_words"-------
            while continueRoutine:
                # get current time
                t = repeat_wordsClock.getTime()
                frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
                # update/draw components on each frame
                
                # *mic_1* updates
                if t >= 0.0 and mic_1.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    mic_1.tStart = t
                    mic_1.frameNStart = frameN  # exact frame index
                    mic_1.status = STARTED
                    mic_1.record(sec=max_response_time, block=False)  # start the recording thread
                
                if mic_1.status == STARTED and not mic_1.recorder.running:
                    mic_1.status = FINISHED
                
                # *key_resp_2* updates
                if t >= min_response_time and key_resp_2.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    key_resp_2.tStart = t
                    key_resp_2.frameNStart = frameN  # exact frame index
                    key_resp_2.status = STARTED
                    # keyboard checking is just starting
                    win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
                    event.clearEvents(eventType='keyboard')
                if key_resp_2.status == STARTED:
                    theseKeys = event.getKeys(keyList=['space'])
                    
                    # check for quit:
                    if "escape" in theseKeys:
                        endExpNow = True
                    if len(theseKeys) > 0:  # at least one key was pressed
                        key_resp_2.keys = theseKeys[-1]  # just the last key pressed
                        key_resp_2.rt = key_resp_2.clock.getTime()
                        # a response ends the routine
                        continueRoutine = False
                # start/stop sound_2
                if t >= 0 and sound_2.status == NOT_STARTED:
                    # keep track of start time/frame for later
                    sound_2.tStart = t
                    sound_2.frameNStart = frameN  # exact frame index
                    sound_2.play()  # start the sound (it finishes automatically)
                
                # check if all components have finished
                if not continueRoutine:  # a component has requested a forced-end of Routine
                    break
                continueRoutine = False  # will revert to True if at least one component still running
                for thisComponent in repeat_wordsComponents:
                    if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                        continueRoutine = True
                        break  # at least one component has not yet finished
                
                # check for quit (the Esc key)
                if endExpNow or event.getKeys(keyList=["escape"]):
                    core.quit()
                
                # refresh the screen
                if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                    win.flip()
            
            # -------Ending Routine "repeat_words"-------
            for thisComponent in repeat_wordsComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)
            # mic_1 stop & responses
            mic_1.stop()  # sometimes helpful
            if not mic_1.savedFile:
                mic_1.savedFile = None
            # store data for word_presentation_training (TrialHandler)
            word_presentation_training.addData('mic_1.filename', mic_1.savedFile)
            # check responses
            if key_resp_2.keys in ['', [], None]:  # No response was made
                key_resp_2.keys=None
            word_presentation_training.addData('key_resp_2.keys',key_resp_2.keys)
            if key_resp_2.keys != None:  # we had a response
                word_presentation_training.addData('key_resp_2.rt', key_resp_2.rt)
            sound_2.stop()  # ensure sound has stopped at end of routine
            # the Routine "repeat_words" was not non-slip safe, so reset the non-slip timer
            routineTimer.reset()
            thisExp.nextEntry()
            
        # completed 1 repeats of 'word_presentation_training'
        
        
        # ------Prepare to start Routine "repeat_training"-------
        t = 0
        repeat_trainingClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        key_resp_8 = event.BuilderKeyResponse()
        
        # keep track of which components have finished
        repeat_trainingComponents = [text_5, key_resp_8]
        for thisComponent in repeat_trainingComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "repeat_training"-------
        while continueRoutine:
            # get current time
            t = repeat_trainingClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *text_5* updates
            if t >= 0.0 and text_5.status == NOT_STARTED:
                # keep track of start time/frame for later
                text_5.tStart = t
                text_5.frameNStart = frameN  # exact frame index
                text_5.setAutoDraw(True)
            
            # *key_resp_8* updates
            if t >= 0.0 and key_resp_8.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_8.tStart = t
                key_resp_8.frameNStart = frameN  # exact frame index
                key_resp_8.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_8.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            if key_resp_8.status == STARTED:
                theseKeys = event.getKeys(keyList=['p', 's'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_8.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_8.rt = key_resp_8.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
            
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in repeat_trainingComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "repeat_training"-------
        for thisComponent in repeat_trainingComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # check responses
        if key_resp_8.keys in ['', [], None]:  # No response was made
            key_resp_8.keys=None
        training_block.addData('key_resp_8.keys',key_resp_8.keys)
        if key_resp_8.keys != None:  # we had a response
            training_block.addData('key_resp_8.rt', key_resp_8.rt)
        if key_resp_8.keys == "s": break  # allow to repeat training until ready (max 20, see loop)
        # the Routine "repeat_training" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 20 repeats of 'training_block'
    
    
    # ------Prepare to start Routine "instr_start_real_thing"-------
    t = 0
    instr_start_real_thingClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    key_resp_7 = event.BuilderKeyResponse()
    # keep track of which components have finished
    instr_start_real_thingComponents = [text_3, key_resp_7]
    for thisComponent in instr_start_real_thingComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "instr_start_real_thing"-------
    while continueRoutine:
        # get current time
        t = instr_start_real_thingClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_3* updates
        if t >= 0.0 and text_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_3.tStart = t
            text_3.frameNStart = frameN  # exact frame index
            text_3.setAutoDraw(True)
        
        # *key_resp_7* updates
        if t >= 0.0 and key_resp_7.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_7.tStart = t
            key_resp_7.frameNStart = frameN  # exact frame index
            key_resp_7.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(key_resp_7.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        if key_resp_7.status == STARTED:
            theseKeys = event.getKeys(keyList=['space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                key_resp_7.keys = theseKeys[-1]  # just the last key pressed
                key_resp_7.rt = key_resp_7.clock.getTime()
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in instr_start_real_thingComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "instr_start_real_thing"-------
    for thisComponent in instr_start_real_thingComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if key_resp_7.keys in ['', [], None]:  # No response was made
        key_resp_7.keys=None
    block.addData('key_resp_7.keys',key_resp_7.keys)
    if key_resp_7.keys != None:  # we had a response
        block.addData('key_resp_7.rt', key_resp_7.rt)
    # the Routine "instr_start_real_thing" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # set up handler to look after randomisation of conditions etc
    word_presentation = data.TrialHandler(nReps=1, method='sequential', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(curr_list_targets),
        seed=None, name='word_presentation')
    thisExp.addLoop(word_presentation)  # add the loop to the experiment
    thisWord_presentation = word_presentation.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisWord_presentation.rgb)
    if thisWord_presentation != None:
        for paramName in thisWord_presentation:
            exec('{} = thisWord_presentation[paramName]'.format(paramName))
    
    for thisWord_presentation in word_presentation:
        currentLoop = word_presentation
        # abbreviate parameter names if possible (e.g. rgb = thisWord_presentation.rgb)
        if thisWord_presentation != None:
            for paramName in thisWord_presentation:
                exec('{} = thisWord_presentation[paramName]'.format(paramName))
        
        # ------Prepare to start Routine "fixation"-------
        t = 0
        fixationClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        # keep track of which components have finished
        fixationComponents = [point]
        for thisComponent in fixationComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "fixation"-------
        while continueRoutine:
            # get current time
            t = fixationClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *point* updates
            if t >= 0.0 and point.status == NOT_STARTED:
                # keep track of start time/frame for later
                point.tStart = t
                point.frameNStart = frameN  # exact frame index
                point.setAutoDraw(True)
            frameRemains = 0.0 + fix_point_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if point.status == STARTED and t >= frameRemains:
                point.setAutoDraw(False)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in fixationComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "fixation"-------
        for thisComponent in fixationComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "fixation" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # ------Prepare to start Routine "display_words"-------
        t = 0
        display_wordsClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        w1.setText(word1)
        w2.setText(word2)
        w3.setText(word3)
        w4.setText(word4)
        # keep track of which components have finished
        display_wordsComponents = [w1, w2, w3, w4, memory_period]
        for thisComponent in display_wordsComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "display_words"-------
        while continueRoutine:
            # get current time
            t = display_wordsClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *w1* updates
            if t >= 0.0 and w1.status == NOT_STARTED:
                # keep track of start time/frame for later
                w1.tStart = t
                w1.frameNStart = frameN  # exact frame index
                w1.setAutoDraw(True)
            frameRemains = 0.0 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w1.status == STARTED and t >= frameRemains:
                w1.setAutoDraw(False)
            
            # *w2* updates
            if t >= SOA and w2.status == NOT_STARTED:
                # keep track of start time/frame for later
                w2.tStart = t
                w2.frameNStart = frameN  # exact frame index
                w2.setAutoDraw(True)
            frameRemains = SOA + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w2.status == STARTED and t >= frameRemains:
                w2.setAutoDraw(False)
            
            # *w3* updates
            if t >= SOA*2 and w3.status == NOT_STARTED:
                # keep track of start time/frame for later
                w3.tStart = t
                w3.frameNStart = frameN  # exact frame index
                w3.setAutoDraw(True)
            frameRemains = SOA*2 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w3.status == STARTED and t >= frameRemains:
                w3.setAutoDraw(False)
            
            # *w4* updates
            if t >= SOA*3 and w4.status == NOT_STARTED:
                # keep track of start time/frame for later
                w4.tStart = t
                w4.frameNStart = frameN  # exact frame index
                w4.setAutoDraw(True)
            frameRemains = SOA*3 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w4.status == STARTED and t >= frameRemains:
                w4.setAutoDraw(False)
            
            # *memory_period* updates
            if t >= SOA*3 + word_duration and memory_period.status == NOT_STARTED:
                # keep track of start time/frame for later
                memory_period.tStart = t
                memory_period.frameNStart = frameN  # exact frame index
                memory_period.setAutoDraw(True)
            frameRemains = SOA*3 + word_duration + mem_per- win.monitorFramePeriod * 0.75  # most of one frame period left
            if memory_period.status == STARTED and t >= frameRemains:
                memory_period.setAutoDraw(False)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in display_wordsComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "display_words"-------
        for thisComponent in display_wordsComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "display_words" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # ------Prepare to start Routine "repeat_words"-------
        t = 0
        repeat_wordsClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        mic_1 = microphone.AdvAudioCapture(name='mic_1', saveDir=wavDirName, stereo=False)
        key_resp_2 = event.BuilderKeyResponse()
        # keep track of which components have finished
        repeat_wordsComponents = [mic_1, key_resp_2, sound_2]
        for thisComponent in repeat_wordsComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "repeat_words"-------
        while continueRoutine:
            # get current time
            t = repeat_wordsClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *mic_1* updates
            if t >= 0.0 and mic_1.status == NOT_STARTED:
                # keep track of start time/frame for later
                mic_1.tStart = t
                mic_1.frameNStart = frameN  # exact frame index
                mic_1.status = STARTED
                mic_1.record(sec=max_response_time, block=False)  # start the recording thread
            
            if mic_1.status == STARTED and not mic_1.recorder.running:
                mic_1.status = FINISHED
            
            # *key_resp_2* updates
            if t >= min_response_time and key_resp_2.status == NOT_STARTED:
                # keep track of start time/frame for later
                key_resp_2.tStart = t
                key_resp_2.frameNStart = frameN  # exact frame index
                key_resp_2.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            if key_resp_2.status == STARTED:
                theseKeys = event.getKeys(keyList=['space'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    key_resp_2.keys = theseKeys[-1]  # just the last key pressed
                    key_resp_2.rt = key_resp_2.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
            # start/stop sound_2
            if t >= 0 and sound_2.status == NOT_STARTED:
                # keep track of start time/frame for later
                sound_2.tStart = t
                sound_2.frameNStart = frameN  # exact frame index
                sound_2.play()  # start the sound (it finishes automatically)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in repeat_wordsComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "repeat_words"-------
        for thisComponent in repeat_wordsComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # mic_1 stop & responses
        mic_1.stop()  # sometimes helpful
        if not mic_1.savedFile:
            mic_1.savedFile = None
        # store data for word_presentation (TrialHandler)
        word_presentation.addData('mic_1.filename', mic_1.savedFile)
        # check responses
        if key_resp_2.keys in ['', [], None]:  # No response was made
            key_resp_2.keys=None
        word_presentation.addData('key_resp_2.keys',key_resp_2.keys)
        if key_resp_2.keys != None:  # we had a response
            word_presentation.addData('key_resp_2.rt', key_resp_2.rt)
        sound_2.stop()  # ensure sound has stopped at end of routine
        # the Routine "repeat_words" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        thisExp.nextEntry()
        
    # completed 1 repeats of 'word_presentation'
    
    
    # ------Prepare to start Routine "end_block"-------
    t = 0
    end_blockClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_6.setText("End of part " + `myBlockCount` + ".\nYou may take a short break now." + cont)
    key_resp_9 = event.BuilderKeyResponse()
    # keep track of which components have finished
    end_blockComponents = [text_6, key_resp_9]
    for thisComponent in end_blockComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "end_block"-------
    while continueRoutine:
        # get current time
        t = end_blockClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_6* updates
        if t >= 0.0 and text_6.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_6.tStart = t
            text_6.frameNStart = frameN  # exact frame index
            text_6.setAutoDraw(True)
        
        # *key_resp_9* updates
        if t >= 0.0 and key_resp_9.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_9.tStart = t
            key_resp_9.frameNStart = frameN  # exact frame index
            key_resp_9.status = STARTED
            # keyboard checking is just starting
            event.clearEvents(eventType='keyboard')
        if key_resp_9.status == STARTED:
            theseKeys = event.getKeys(keyList=['space'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                # a response ends the routine
                continueRoutine = False
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in end_blockComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # check for quit (the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "end_block"-------
    for thisComponent in end_blockComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "end_block" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'block'


# ------Prepare to start Routine "thanks"-------
t = 0
thanksClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(5.000000)
# update component parameters for each repeat
key_resp_3 = event.BuilderKeyResponse()
# keep track of which components have finished
thanksComponents = [text, key_resp_3]
for thisComponent in thanksComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "thanks"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = thanksClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text* updates
    if t >= 0.0 and text.status == NOT_STARTED:
        # keep track of start time/frame for later
        text.tStart = t
        text.frameNStart = frameN  # exact frame index
        text.setAutoDraw(True)
    frameRemains = 0.0 + 5- win.monitorFramePeriod * 0.75  # most of one frame period left
    if text.status == STARTED and t >= frameRemains:
        text.setAutoDraw(False)
    
    # *key_resp_3* updates
    if t >= 0.0 and key_resp_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_3.tStart = t
        key_resp_3.frameNStart = frameN  # exact frame index
        key_resp_3.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_3.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    frameRemains = 0.0 + 5- win.monitorFramePeriod * 0.75  # most of one frame period left
    if key_resp_3.status == STARTED and t >= frameRemains:
        key_resp_3.status = STOPPED
    if key_resp_3.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_3.keys = theseKeys[-1]  # just the last key pressed
            key_resp_3.rt = key_resp_3.clock.getTime()
            # a response ends the routine
            continueRoutine = False
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in thanksComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # check for quit (the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "thanks"-------
for thisComponent in thanksComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_3.keys in ['', [], None]:  # No response was made
    key_resp_3.keys=None
thisExp.addData('key_resp_3.keys',key_resp_3.keys)
if key_resp_3.keys != None:  # we had a response
    thisExp.addData('key_resp_3.rt', key_resp_3.rt)
thisExp.nextEntry()



# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
