### Coder_9000 developed by Jason Foster, jf727@nau.edu ###

# Use pythons built in GUI and Excel stuff
import tkinter as tk
from tkinter import *
import csv
import os
from os import system
import platform
import subprocess as sp

# r is the main window the UI will rest on
r = tk.Tk()
r.title('Coder_9000')

# Please place all functions in this box otherwise you risk calling a function before
# it got defined

################################################################################
################################################################################

# This sheet opens the text file with all the codes and displays the
# first coding window. Also preform checks for special cases (calibrating). 
def sheet3():
    global subjectID
    global excelProcess
    global programName
    global calibrated
    global previousCodes
    if subjectID == '':
        subjectID = subEntry.get()
    clearScreen()
    excelProcess = sp.Popen([programName,subjectID + '.csv'])
    endEntry.grid_forget()
    startEntry.grid_forget()
    startTimeLabel.grid(row=0,column=0)
    startEntry.grid(row=0, column=1)
    endTimeLabel.grid(row=1, column=0)
    commentsEntry.grid(row=2,column=1)
    endEntry.grid(row=1, column=1)
    buildCodeButton.grid(row=0, column = 3)
    buildCodeButton.configure(state='active')
    finishedButton.configure(state='active')
    finishedButton.grid(row=2, column = 3)
    invalidMessage.grid(row=0, column = 2)
    enterCodeButton.grid(row=4, column=3)
    enterCodeButton.configure(state='disabled')
    resetCodeButton.grid(row=1, column = 3)
    resetCodeButton.configure(state='disabled')
    previousCodesButton.grid(row=5, column = 3)
    if len(previousCodes) == 0:
        previousCodesButton.configure(state='disabled')
    code.grid(row=4)
    if not calibrated:
        calibrationRadioButton.grid()
        calibrationRadioButton.select()
    else:
        firstRadioButton.grid()
        firstRadioButton.select()
    commentsMessage.grid(row=2, column = 0)
    backToStart.grid(row=5, column=3)
    helpButton.grid(row=3, column=4)
    #print(subjectID)

# this function triggers when the coder selects New Code Sheet from the start screen
# First clear the start screen and create a new screen that will alow the coder to enter
# relevant information. Prevent a new open if the name is used somewhere else.

def NewCodeSheet():
    global resuming
    resuming = False
    clearScreen()
    subjectLabel.grid(row=0)
    subEntry.grid(row=0, column=1)
    buttonToSheet3.grid()
    backToStart.grid()
    helpButton.grid(row=4, column=4)

# displays a help message, so the coder can remember what i told them.

def showHelp():
    clearScreen()
    helpMessage.grid()
    badCodeMessage.grid()
    anotherOne.grid()

# Get an already existing filename from the user and then try to open
# the (hopefully) text file.

def UpdateExistingSheet():
    clearScreen()
    fileToFindLabel.grid(row=0,column=0)
    fileToFindEntry.grid(row=0,column=1)
    backToStart.grid(row=2,column = 0)
    helpButton.grid(row=4, column=4)
    resumeCodingButton.grid(row=1,column=0)

# This function will create the start screen when needed

def loadStartScreen():
    global radioButtonList
    radioButtonList = []
    global codeBeingBuilt
    codeBeingBuilt = ''
    global finishedCodesList
    finishedCodesList = []
    global finishedStartTimesList
    global finishedEndTimesList
    finishedStartTimesList = []
    finishedEndTimesList = []
    global subjectID
    subjectID = ''
    global resuming
    resuming = False
    global commentsList
    global excelProcess
    global programName
    global calibrated
    global back
    global previous
    previous = False
    back = False
    calibrated = False
    commentsList = []
    
    clearScreen()
    helpButton.grid(row=4, column=4)
    button1.grid(row=0, column=1)
    button2.grid(row=1, column=1)

    if platform.system() == 'Windows':
        programName = 'notepad.exe'
    elif platform.system() == 'Darwin':
        programName = 'TextEdit.app'
    else:
        print('OS not supported')
        r.destroy()

# This function resets the code being built by 1 and calls build()
# also check to make sure we should be going back.
        
def reset():
    global codeBeingBuilt
    global back
    if len(codeBeingBuilt) == 1:
        codeBeingBuilt = ''
        code.configure(text='code: ' + codeBeingBuilt)
        excelProcess.kill()
        sheet3()
    else:
        back = True
        codeBeingBuilt = codeBeingBuilt[0:-1]
        code.configure(text='code: ' + codeBeingBuilt)
        build()
    return

# take a given filename and try to open it, if its wrong the coder lives and
# and error appears in console. If the filename exists open it and load the contents
# display them and go to the start of the coding sheet. Also try to regenerate the
# previous code list

def loadResume():
    global subjectID
    global calibrated
    calibrated = True
    subjectID = fileToFindEntry.get()
    global resuming
    resuming = True
    global previousCodes
    global previousComments

    file = open(subjectID + '.csv', 'r')
    data = file.readlines()
    for i in range(2,len(data),2):
        line = data[i].split(',')
        code = line[2]
        comment = line[3]
        if code != '0':
            if code[1:] not in previousCodes:
                previousCodes.append(code[1:])
                globals()[previousCodes[-1]] = tk.Radiobutton(r, text=code, variable=buttonValue, value=code)
                cleanedComment = comment.replace(' ', '_')
                cleanerComment = cleanedComment[0:-1]
                previousComments.append(cleanerComment)
                globals()[previousComments[-1]] = tk.Message(r, text=comment)
    file.close()    
    sheet3()

# clear the code being built and go back to the start frame

def clear():
    global codeBeingBuilt
    codeBeingBuilt = ''
    code.configure(text='code: ')
    sheet3()

# When the enter code button is pushed we need to add the code to the csv file
# Wipe the entryboxes for the next code and close and reopen the csv file.
# Then reset back to the first button. Also, we should check to make sure that data
# is being entered the way I want

def invalidEnter():
    global previous
    clearScreen()
    if previous:
        startTimeLabel.grid(row=0,column=0)
        startEntry.grid(row=0, column=1)
        endTimeLabel.grid(row=1, column=0)
        endEntry.grid(row=1, column=1)
        helpButton.grid(row=2,column=3)
        commentsEntry.grid(row=0,column=3)
        commentsMessage.grid(row=0, column = 2)
        backToSheet3.grid(row=2,column=2)
        enterPrevious.grid(row=2,column=1)
        for i in range(0,len(previousCodes)):       
            previousRadioButton = eval(previousCodes[i])
            previousRadioButton.grid(row=3+i,column=1)
            previousCommentsMessage = eval(previousComments[i])
            previousCommentsMessage.grid(row=3+i,column=2)
    else:
        startTimeLabel.grid(row=0,column=0)
        startEntry.grid(row=0, column=1)
        endTimeLabel.grid(row=1, column=0)
        commentsEntry.grid(row=2,column=1)
        commentsMessage.grid(row=2, column = 0)
        endEntry.grid(row=1, column=1)
        buildCodeButton.grid(row=0, column = 3)
        finishedButton.grid(row=2, column = 3)
        invalidMessage.grid(row=0, column = 2)
        enterCodeButton.grid(row=4, column=3)
        resetCodeButton.grid(row=1, column = 3)
        helpButton.grid(row=3, column=4)
        code.grid(row=4, column = 0)


def enter():
    global codeBeingBuilt
    global finishedCodesList
    global finishedStartTimesList
    global finishedEndTimesList
    global commentsList
    global excelProcess
    global programName
    global resuming
    global calibrated
    global previous
    global previousCodes
    global previousComments
    global index
    uncleanedComment = commentsEntry.get()
    uncleanedStartTime = startEntry.get()
    splitStartTime = uncleanedStartTime.replace('.', '')
    uncleanedEndTime = endEntry.get()
    splitEndTime = uncleanedEndTime.replace('.', '')
    if uncleanedComment == '' and not previous:
        print('first instance of a code must be commented')
        excelProcess.kill()
        invalidEnter()
    if uncleanedComment == '':
        curCom = eval(previousComments[index])
        uncleanedComment = curCom.cget('text')
        commentsList.append(uncleanedComment.replace('\n',''))
    else:
        commentsList.append(uncleanedComment)
    if 7 > len(splitStartTime) | 7 > len(splitEndTime):
        print('Invalid time entered: Length of time incorrect. Enter time as mm.ss.fff')
        excelProcess.kill()
        invalidEnter()
    elif str.isdigit(splitStartTime) is False or str.isdigit(splitEndTime) is False:
        print('Invalid time entered: Use numbers only please. Enter time as mm.ss.fff')
        excelProcess.kill()
        invalidEnter()
    elif len(uncleanedStartTime) != 9:
        print('Invalid Start time entered: Length of time incorrect. Enter start time as mm.ss.fff')
        excelProcess.kill()
        invalidEnter()
    elif len(uncleanedEndTime) != 9:
        print('Invalid End time entered: Length of time incorrect. Enter end time as mm.ss.fff')
        excelProcess.kill()
        invalidEnter()
    elif uncleanedStartTime[2] != '.' or uncleanedStartTime[5] != '.' or uncleanedEndTime[2] != '.' or uncleanedEndTime[5] != '.':
        print('please only use . to seperate times. Enter Times as mm.ss.fff')
        excelProcess.kill()
        invalidEnter()
    elif not str.isalpha(uncleanedComment[0]):
        print('Comments must start with a letter only')
        excelProcess.kill()
        invalidEnter()
    else:        
        previousCodesButton.configure(state='active')
        finishedCodesList.append(codeBeingBuilt)
        finishedStartTimesList.append(startEntry.get())
        finishedEndTimesList.append(endEntry.get())
        startEntry.delete(0, 'end')
        endEntry.delete(0, 'end')
        commentsEntry.delete(0, 'end')
        excelProcess.kill()
        if resuming:
            subject = [None]
                    
            with open(subjectID+'.csv', mode='a') as csvFile:
                subjectWriter = csv.writer(csvFile)
                for i in range(0,len(finishedCodesList)):
                    starttime = finishedStartTimesList[i]
                    endtime = finishedEndTimesList[i]
                    videocode = finishedCodesList[i]
                    comments = commentsList[i]
                    newrow = [starttime, endtime, videocode, comments]
                    subjectWriter.writerow(newrow)
            csvFile.close()
            if finishedCodesList[-1] != '0':
                cleanedFinishedCode = finishedCodesList[-1]
                if cleanedFinishedCode[1:] not in previousCodes:
                    badPreviousCode = finishedCodesList[-1]
                    goodPreviousCode = badPreviousCode[1:]
                    previousCodes.append(goodPreviousCode)
                    globals()[previousCodes[-1]] = tk.Radiobutton(r, text=finishedCodesList[-1], variable=buttonValue, value=finishedCodesList[-1])
                    unCleanedComment = commentsList[-1]
                    cleanedComment = unCleanedComment.replace(' ', '_')
                    previousComments.append(cleanedComment)
                    globals()[previousComments[-1]] = tk.Message(r, text=commentsList[-1])
            finishedCodesList = []
            finishedEndTimesList = []
            finishedStartTimesList = []
            commentsList = []
        
        else:

            subject = [['Start_Time mm:ss:fff', 'End_Time mm:ss:fff', 'Code', 'Comments']]

            for i in range(0,len(finishedCodesList)):
                starttime = finishedStartTimesList[i]
                endtime = finishedEndTimesList[i]
                videocode = finishedCodesList[i]
                comments = commentsList[i]
                newrow = [starttime, endtime, videocode, comments]
                subject.append(newrow)

            filename = subjectID+'.csv'
            with open(filename, 'w') as csvFile:
                writer = csv.writer(csvFile)
                writer.writerows(subject)

            csvFile.close()
            if finishedCodesList[-1] != '0':
                cleanedFinishedCode = finishedCodesList[-1]
                if cleanedFinishedCode[1:] not in previousCodes:
                    badPreviousCode = finishedCodesList[-1]
                    goodPreviousCode = badPreviousCode[1:]
                    previousCodes.append(goodPreviousCode)
                    globals()[previousCodes[-1]] = tk.Radiobutton(r, text=finishedCodesList[-1], variable=buttonValue, value=finishedCodesList[-1])
                    unCleanedComment = commentsList[-1]
                    cleanedComment = unCleanedComment.replace(' ', '_')
                    previousComments.append(cleanedComment)
                    globals()[previousComments[-1]] = tk.Message(r, text=commentsList[-1])
        calibrated = True
        previous = False
        clear()
    return

# Export out all of entered data to a csv file, close the csv file
# and close the coder

def finish():
    global finishedCodesList
    global finishedStartTimesList
    global finishedEndTimesList
    global subjectID
    global commentsList
    global excelProcess
    global programName
    global resuming
    excelProcess.kill()
    r.destroy()
    return

# Code shamelessly stolen from StackOverflow, I need this for
# clearScreen() to clear the screen

def all_children (window) :
    _list = window.winfo_children()

    for item in _list :
        if item.winfo_children() :
            _list.extend(item.winfo_children())

    return _list

def clearScreen():
    widget_list = all_children(r)
    for item in widget_list:
        item.grid_forget()

# display all the previously entered codes 

def previous():
    global previousCodes
    global previousComments
    global previous
    clearScreen()
    startTimeLabel.grid(row=0,column=0)
    startEntry.grid(row=0, column=1)
    endTimeLabel.grid(row=1, column=0)
    endEntry.grid(row=1, column=1)
    commentsEntry.grid(row=0,column=3)
    commentsMessage.grid(row=0, column = 2)
    helpButton.grid(row=2,column=3)
    backToSheet3.grid(row=2,column=2)
    enterPrevious.grid(row=2,column=1)
    for i in range(0,len(previousCodes)):       
        previousRadioButton = eval(previousCodes[i])
        previousRadioButton.grid(row=3+i,column=1)
        previousCommentsMessage = eval(previousComments[i])
        previousCommentsMessage.grid(row=3+i,column=2)

# This function takes the information from the past and passes it to enter()
    
def enterPreviousCode():
    global codeBeingBuilt
    global previous
    global index
    previous = True
    returnedString = buttonValue.get()
    if returnedString == '1':
        print('you need to select a previous code')
        invalidEnter()
    else:        
        for i in range(0,len(previousCodes)):
            curBut = eval(previousCodes[i])
            if curBut.cget('value') == returnedString:
                index = i;
                break
        if returnedString[0] != '1':
            codeBeingBuilt = '1' + returnedString
        else:
            codeBeingBuilt = returnedString
        enter()

# if we open a new sheet, it doesnt already exist, r-right?

def toSheet3():
    global excelProcess
    global previous
    global resuming
    if not resuming:
        exists = os.path.isfile(subEntry.get()+'.csv')
        if exists:
            print('ERROR: Cannot create new sheet. A sheet with that name already exists')
            NewCodeSheet()
        else:
            sheet3()
    else:
        excelProcess.kill()
        previous = False
        sheet3()

# This function pulls the button value and adds it to the code being built. Then we need to prep
# our next button list while checking to see if we need to activate the enter button.
# If no button is pressed we will press reset behind the scenes so no more code: 1111111

def build():
    global codeBeingBuilt
    global calibrated
    global back
    repeat = False
    clearScreen()
    startTimeLabel.grid(row=0,column=0)
    startEntry.grid(row=0, column=1)
    endTimeLabel.grid(row=1, column=0)
    endEntry.grid(row=1, column=1)
    buildCodeButton.grid(row=0, column = 3)
    finishedButton.configure(state='disabled')
    resetCodeButton.configure(state='active')
    finishedButton.grid(row=2, column = 3)
    invalidMessage.grid(row=0, column = 2)
    enterCodeButton.grid(row=1, column=3)
    resetCodeButton.grid(row=4, column = 3)
    commentsMessage.grid(row=2,column=0)
    commentsEntry.grid(row=2,column=1)
    helpButton.grid(row=3, column=4)

    if len(codeBeingBuilt) != 0:
        if buttonValue.get() == codeBeingBuilt[-1]:
            repeat = True

    if back:
        back = False
        lastEnteredCode = codeBeingBuilt[-1]
        code.configure(text='code: ' + codeBeingBuilt)
        code.grid(row=4)
        enterCodeButton.configure(state='disabled')
        buildCodeButton.configure(state='active')
        with open('codes.txt') as f:
            lines = f.readlines()

    # If im at Grasp, check whether im a drink, utensil or hand so my 7th window
    # isn't rediculesly big.

        if len(codeBeingBuilt) == 6:
            if codeBeingBuilt[-2] == '7':
                nextButtons = ['Mug','Mason','Stein','Espresso','Teacup','Pitcher','Red_Wine','White_Wine','Champagne','Cognac','Shot','Can','Bottle','Glass','Cup','Carton']
            elif codeBeingBuilt[-2] == '8':
                nextButtons = ['Fork','Spoon','Knife','Spork','Chopsticks']
            else:
                nextButtons = ['Thumb_Under','Thumb_Over','Thumb_Sideways']
            for j in range(0,len(nextButtons)):
                    curbut = eval(nextButtons[j])
                    curbut.grid()

        else:
            for i in range(0,len(lines)):
                currentList = lines[i].split(':')
                if currentList[0] == lastEnteredCode:
                    nextButtons = currentList[-1]
                    nextButtons = nextButtons.split('\n')
                    del nextButtons[-1]
                    nextButtons = str(nextButtons)
                    nextButtons = nextButtons[2:-2]
                    nextButtons = nextButtons.split(',')
                    if nextButtons[0] == 'END':
                        enterCodeButton.configure(state='active')
                        buildCodeButton.configure(state='disabled')
                        invalidMessage.grid_forget()
                        validMessage.grid(row=0, column = 2)
                        return
                    for j in range(0,len(nextButtons)):
                        curbut = eval(nextButtons[j])
                        curbut.grid()
        
            return

        
    else:
        if not repeat:
            codeBeingBuilt = codeBeingBuilt + buttonValue.get()
        code.configure(text='code: ' + codeBeingBuilt)
        code.grid(row=4)

        if not calibrated:
            lastEnteredCode = '0'
            codeBeingBuilt = '0'
            code.configure(text='code: ' + codeBeingBuilt)
        else:
            lastEnteredCode = codeBeingBuilt[-1]

        with open('codes.txt') as f:
            lines = f.readlines()

    # If im at Grasp, check whether im a drink, utensil or hand so my 7th window
    # isn't rediculesly big.

        if len(codeBeingBuilt) == 6:
            if codeBeingBuilt[-2] == '7':
                nextButtons = ['Mug','Mason','Stein','Espresso','Teacup','Pitcher','Red_Wine','White_Wine','Champagne','Cognac','Shot','Can','Bottle','Glass','Cup','Carton']
            elif codeBeingBuilt[-2] == '8':
                nextButtons = ['Fork','Spoon','Knife','Spork','Chopsticks']
            else:
                nextButtons = ['Thumb_Under','Thumb_Over','Thumb_Sideways']
            for j in range(0,len(nextButtons)):
                    curbut = eval(nextButtons[j])
                    curbut.grid()

        else:
            for i in range(0,len(lines)):
                currentList = lines[i].split(':')
                if currentList[0] == lastEnteredCode:
                    nextButtons = currentList[-1]
                    nextButtons = nextButtons.split('\n')
                    del nextButtons[-1]
                    nextButtons = str(nextButtons)
                    nextButtons = nextButtons[2:-2]
                    nextButtons = nextButtons.split(',')
                    if nextButtons[0] == 'END':
                        enterCodeButton.configure(state='active')
                        buildCodeButton.configure(state='disabled')
                        invalidMessage.grid_forget()
                        validMessage.grid(row=0, column = 2)
                        return
                    for j in range(0,len(nextButtons)):
                        curbut = eval(nextButtons[j])
                        curbut.grid()
        
            return
    


########################################################################################
########################################################################################

# all the widgets are declared here, declaring them in the functions make them
# unaccesiible to anything outside their respective function.

button1 = tk.Button(r, text='Create new code sheet', width=25, command=NewCodeSheet)
button2 = tk.Button(r, text='Update existing code sheet', width=25, command=UpdateExistingSheet)
helpButton = tk.Button(r, text='I NEED HELP!', width=25, command=showHelp)
buttonToSheet3 = tk.Button(r, text='Ready?', width=25, command=toSheet3)
backToStart = tk.Button(r, text='Back to Home', width=25, command=loadStartScreen)
resetCodeButton = tk.Button(r, text='Reset Code', width=25, command=reset)
enterCodeButton = tk.Button(r, text='Enter Code', width=25, command=enter)
finishedButton = tk.Button(r, text='Finished Coding', width=25, command=finish)
buildCodeButton = tk.Button(r, text='Build Code', width=25, command=build)
anotherOne = tk.Button(r, text='Return to main Menu', width=25, command=loadStartScreen)
timeToQuit = tk.Button(r, text='All done?(this exits the program)', width=25, command=r.destroy)
resumeCodingButton = tk.Button(r, text='Load and Resume', width=25, command = loadResume)
calibrationRadioButton = tk.Radiobutton(r, text='Calibration', variable=StringVar(), value='0')
previousCodesButton = tk.Button(r, text='Previous Codes', width=25, command=previous)
backToSheet3 = tk.Button(r, text='Enter Code by Hand', width=25, command=toSheet3)
enterPrevious = tk.Button(r, text='Enter Previous Code', width=25, command=enterPreviousCode)

### This section reads in a taxonmy and creates all the widgets to be used in code building

global buttonValue
buttonValue = StringVar()
global radioButtonList
radioButtonList = []
global firstRadioButton
global codeBeingBuilt
codeBeingBuilt = ''
global finishedCodesList
finishedCodesList = []
global finishedStartTimesList
global finishedEndTimesList
finishedStartTimesList = []
finishedEndTimesList = []

buttonValue = StringVar()
global codeInProgress
codeInProgress = ''
global lastNumericCode
lastNumericCode = '1'
global subjectID
subjectID = ''

with open('codes.txt') as f:
    lines = f.readlines()

for i in range(0,len(lines)):
    currentList = lines[i].split(':')
    globals()[currentList[1]] = tk.Radiobutton(r, text=currentList[1], variable=buttonValue, value=currentList[0])
    radioButtonList.append(currentList)
    if i == 0:
        firstRadioButton = eval(currentList[1])


###

global previousCodes
previousCodes = []
global previousComments
previousComments = []

subjectLabel = Label(r, text='SubjectID')
startTimeLabel = Label(r, text='Start Time (mm.ss.fff):  ')
endTimeLabel = Label(r, text='End Time (mm.ss.fff):  ')
code = Label(r, text='Code:')
fileToFindLabel = Label(r, text='Enter the file name of the file you want without the .ext')

subEntry = Entry(r)
endEntry = Entry(r)
commentsEntry = Entry(r)
startEntry = Entry(r, highlightcolor='gray')
fileToFindEntry = Entry(r)

commentsMessage = Message(r, text='Enter comments if you need to')
helpMessage = Message(r, text='Seems something is wrong, please try to make a list of steps to recreate this problem. Take a video of it even and then send the bug report to jf727@nau.edu')
invalidMessage = Message(r, text='Invalid Entry', bg='red')
validMessage = Message(r, text='Enter Start and End Times and Press Enter Code', bg='green')
badCodeMessage = Message(r, text='If you inputted a code wrong hit the finish button if possible, then locate the .csv file and open in it notepad. find the wrong code in the file and correct it.')

loadStartScreen()

all_children(r)

r.mainloop()
