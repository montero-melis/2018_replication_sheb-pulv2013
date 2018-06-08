#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy2 Experiment Builder (v1.90.1),
    on juni 08, 2018, at 18:20
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
from psychopy import locale_setup, sound, gui, visual, core, data, event, logging, clock
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
expName = 'sheb_replic_pilot_control'  # from the Builder filename that created this script
expInfo = {u'session': u'001', u'participant': u''}
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

# Setup the Window
win = visual.Window(
    size=[1920, 1200], fullscr=True, screen=0,
    allowGUI=False, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True)
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

# define path to stimuli list; block info is specified in block loop
path2stimuli = u'..\\stimuli\\presentation_lists_pilot\\p' + `pptID` + '_b'

## Duration-related variables (set here rather than in individ elements)

# If session = 9, then speed through the screens
if sess != 9: 
    fix_point_duration = 3  # orig = 3
    mem_per = 6 # time during which words have to be kept in memory (orig = 6)
else:  # otherwise use the standard duration
    fix_point_duration = .75  # orig = 3
    mem_per = 1.0 # time during which words have to be kept in memory (orig = 6)

min_response_time = 0

## Other
cont = "\n\nPress space bar to continue"  # At the end of instructions slides
text_7 = visual.TextStim(win=win, name='text_7',
    text="Welcome to this experiment!\n\nIn this task you will see four words in a sequence and you will have to remember them. Shortly after, you will be asked to repeat the words in the exact same order you saw them." + cont,
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=-1.0);

# Initialize components for Routine "instr_exp1"
instr_exp1Clock = core.Clock()
text_8 = visual.TextStim(win=win, name='text_8',
    text="It works like this:\n\nYou see four words presented on the screen one after another, followed by a pause. In this pause, you have to keep the four words in your memory in the exact order they were presented. You will then hear a beep. At the beep, you have to repeat the four words out loud. Your voice will be recorded as you repeat the words." + cont,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=0.0);

# Initialize components for Routine "instr_exp2"
instr_exp2Clock = core.Clock()
text_9 = visual.TextStim(win=win, name='text_9',
    text="The experiment consists of four parts, and there will be a break at the end of each part. You can also take a break between trials if needed.\n\nIf you have questions so far, you may ask the experimenter now." + cont,
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
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

# Initialize components for Routine "display_words_training"
display_words_trainingClock = core.Clock()
wt1 = visual.TextStim(win=win, name='wt1',
    text='default text',
    font=u'Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color=u'white', colorSpace='rgb', opacity=1,
    depth=0.0);
wt2 = visual.TextStim(win=win, name='wt2',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);
wt3 = visual.TextStim(win=win, name='wt3',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-2.0);
wt4 = visual.TextStim(win=win, name='wt4',
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

# Initialize components for Routine "block_instr"
block_instrClock = core.Clock()

block_intro = visual.TextStim(win=win, name='block_intro',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1,
    depth=-1.0);

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
memory_period2 = visual.TextStim(win=win, name='memory_period2',
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

# ------Prepare to start Routine "train"-------
t = 0
trainClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
text_4.setText("You will first do some practice trials before starting the real task." + cont)
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
thisExp.addData('key_resp_6.keys',key_resp_6.keys)
if key_resp_6.keys != None:  # we had a response
    thisExp.addData('key_resp_6.rt', key_resp_6.rt)
thisExp.nextEntry()
# the Routine "train" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
training_block = data.TrialHandler(nReps=5, method='random', 
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
        trialList=data.importConditions('..\\conditions_training.csv'),
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
        
        # ------Prepare to start Routine "display_words_training"-------
        t = 0
        display_words_trainingClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        wt1.setText(word1)
        wt2.setText(word2)
        wt3.setText(word3)
        wt4.setText(word4)
        # keep track of which components have finished
        display_words_trainingComponents = [wt1, wt2, wt3, wt4, memory_period]
        for thisComponent in display_words_trainingComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "display_words_training"-------
        while continueRoutine:
            # get current time
            t = display_words_trainingClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *wt1* updates
            if t >= 0.0 and wt1.status == NOT_STARTED:
                # keep track of start time/frame for later
                wt1.tStart = t
                wt1.frameNStart = frameN  # exact frame index
                wt1.setAutoDraw(True)
            frameRemains = 0.0 + 0.200- win.monitorFramePeriod * 0.75  # most of one frame period left
            if wt1.status == STARTED and t >= frameRemains:
                wt1.setAutoDraw(False)
            
            # *wt2* updates
            if t >= 0.5 and wt2.status == NOT_STARTED:
                # keep track of start time/frame for later
                wt2.tStart = t
                wt2.frameNStart = frameN  # exact frame index
                wt2.setAutoDraw(True)
            frameRemains = 0.5 + 0.2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if wt2.status == STARTED and t >= frameRemains:
                wt2.setAutoDraw(False)
            
            # *wt3* updates
            if t >= 1 and wt3.status == NOT_STARTED:
                # keep track of start time/frame for later
                wt3.tStart = t
                wt3.frameNStart = frameN  # exact frame index
                wt3.setAutoDraw(True)
            frameRemains = 1 + 0.2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if wt3.status == STARTED and t >= frameRemains:
                wt3.setAutoDraw(False)
            
            # *wt4* updates
            if t >= 1.5 and wt4.status == NOT_STARTED:
                # keep track of start time/frame for later
                wt4.tStart = t
                wt4.frameNStart = frameN  # exact frame index
                wt4.setAutoDraw(True)
            frameRemains = 1.5 + 0.2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if wt4.status == STARTED and t >= frameRemains:
                wt4.setAutoDraw(False)
            
            # *memory_period* updates
            if t >= 1.7 and memory_period.status == NOT_STARTED:
                # keep track of start time/frame for later
                memory_period.tStart = t
                memory_period.frameNStart = frameN  # exact frame index
                memory_period.setAutoDraw(True)
            frameRemains = 1.7 + mem_per- win.monitorFramePeriod * 0.75  # most of one frame period left
            if memory_period.status == STARTED and t >= frameRemains:
                memory_period.setAutoDraw(False)
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in display_words_trainingComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "display_words_training"-------
        for thisComponent in display_words_trainingComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        # the Routine "display_words_training" was not non-slip safe, so reset the non-slip timer
        routineTimer.reset()
        
        # ------Prepare to start Routine "repeat_words"-------
        t = 0
        repeat_wordsClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        # update component parameters for each repeat
        key_resp_2 = event.BuilderKeyResponse()
        # keep track of which components have finished
        repeat_wordsComponents = [key_resp_2, sound_2]
        for thisComponent in repeat_wordsComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "repeat_words"-------
        while continueRoutine:
            # get current time
            t = repeat_wordsClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *key_resp_2* updates
            if t >= 0 and key_resp_2.status == NOT_STARTED:
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
    
# completed 5 repeats of 'training_block'


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
thisExp.addData('key_resp_7.keys',key_resp_7.keys)
if key_resp_7.keys != None:  # we had a response
    thisExp.addData('key_resp_7.rt', key_resp_7.rt)
thisExp.nextEntry()
# the Routine "instr_start_real_thing" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
experimental_blocks = data.TrialHandler(nReps=1, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('conditions_block_pilot.csv'),
    seed=None, name='experimental_blocks')
thisExp.addLoop(experimental_blocks)  # add the loop to the experiment
thisExperimental_block = experimental_blocks.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisExperimental_block.rgb)
if thisExperimental_block != None:
    for paramName in thisExperimental_block:
        exec('{} = thisExperimental_block[paramName]'.format(paramName))

for thisExperimental_block in experimental_blocks:
    currentLoop = experimental_blocks
    # abbreviate parameter names if possible (e.g. rgb = thisExperimental_block.rgb)
    if thisExperimental_block != None:
        for paramName in thisExperimental_block:
            exec('{} = thisExperimental_block[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "block_instr"-------
    t = 0
    block_instrClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    myBlockCount += 1
    
    
    # If session != 9, load a randomized list (normal case)
    if sess != 9: 
        curr_list_targets = path2stimuli + `myBlockCount` + '_pilot_targets.csv'
    else:  # otherwise (if sess==9) use a minimal list
        curr_list_targets = 'minilist_4test.csv'
    
    #curr_list_targets = path2stimuli + `myBlockCount` + '_pilot_targets.csv'
    print(curr_list_targets)
    
    block_intro.setText("Part " + `myBlockCount` + cont)
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
        display_wordsComponents = [w1, w2, w3, w4, memory_period2]
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
            if t >= 0 and w1.status == NOT_STARTED:
                # keep track of start time/frame for later
                w1.tStart = t
                w1.frameNStart = frameN  # exact frame index
                w1.setAutoDraw(True)
            frameRemains = 0 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
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
            if t >= SOA * 2 and w3.status == NOT_STARTED:
                # keep track of start time/frame for later
                w3.tStart = t
                w3.frameNStart = frameN  # exact frame index
                w3.setAutoDraw(True)
            frameRemains = SOA * 2 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w3.status == STARTED and t >= frameRemains:
                w3.setAutoDraw(False)
            
            # *w4* updates
            if t >= SOA * 3 and w4.status == NOT_STARTED:
                # keep track of start time/frame for later
                w4.tStart = t
                w4.frameNStart = frameN  # exact frame index
                w4.setAutoDraw(True)
            frameRemains = SOA * 3 + word_duration- win.monitorFramePeriod * 0.75  # most of one frame period left
            if w4.status == STARTED and t >= frameRemains:
                w4.setAutoDraw(False)
            
            # *memory_period2* updates
            if t >= SOA * 3 + word_duration and memory_period2.status == NOT_STARTED:
                # keep track of start time/frame for later
                memory_period2.tStart = t
                memory_period2.frameNStart = frameN  # exact frame index
                memory_period2.setAutoDraw(True)
            frameRemains = SOA * 3 + word_duration + mem_per- win.monitorFramePeriod * 0.75  # most of one frame period left
            if memory_period2.status == STARTED and t >= frameRemains:
                memory_period2.setAutoDraw(False)
            
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
        key_resp_2 = event.BuilderKeyResponse()
        # keep track of which components have finished
        repeat_wordsComponents = [key_resp_2, sound_2]
        for thisComponent in repeat_wordsComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "repeat_words"-------
        while continueRoutine:
            # get current time
            t = repeat_wordsClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *key_resp_2* updates
            if t >= 0 and key_resp_2.status == NOT_STARTED:
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
    text_6.setText("End of part " + `myBlockCount` + ".\nTake a short break." + cont)
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
    
# completed 1 repeats of 'experimental_blocks'


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
