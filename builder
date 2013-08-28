#!/usr/bin/python

import os
import subprocess
import shutil
import re

# specify where things are located
buildDir = os.path.join('buildDir')
srcDir = os.path.join('src')
workflowDir = os.path.join(srcDir, 'workflow')
scriptsDir = os.path.join(srcDir, 'scripts')
inputPlist = os.path.join(workflowDir, 'info.plist')
outputPlist = os.path.join(buildDir, 'info.plist')

# copy the base workflow to the new location
subprocess.call(['rm', '-rf', buildDir])
shutil.copytree(workflowDir, buildDir)

# find the scripts that exist
scriptFiles = [f for f in os.listdir(scriptsDir) if os.path.isfile(os.path.join(scriptsDir, f))]

# read the input file
if os.path.isfile(inputPlist):
    with open(inputPlist) as openedFile:
        lines = openedFile.readlines()

# go through the file, inserting scripts at the desired locations
output = []
for line in lines:
    # see if match
    if re.match('###.+###', line):
        # if there's a match, sub in the required script
        splitLine = line.split(' ')
        scriptName = splitLine[1]
        scriptLines = []
        
        # read the script
        scriptPath = os.path.join(scriptsDir, scriptName + '.script')
        if os.path.isfile(scriptPath):
            with open(scriptPath) as openedFile:
                scriptLines = openedFile.readlines()

        # replace placeholders with the new values
        for cmdNum in range(1, len(splitLine) - 2):
            scriptLines = [line.replace('##' + str(cmdNum), splitLine[cmdNum + 1].replace('&nbsp;', ' ')) for line in scriptLines]

        # insert the script into the output
        output.extend(scriptLines)

    else:
        # if no match, just add the line to the output
        output.append(line)

# output the data
outputFile = open(outputPlist, 'w')
for item in output:
  outputFile.write('%s' % item)
