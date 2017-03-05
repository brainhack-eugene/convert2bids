### LIBRARIES
# functionality to handle command line arguments
import argparse

# functionality to output JSON format
import json


### SETUP
# Set up the parser for command line arguments
scriptDescription  = "A simple parser to translate DICOM header information, "
scriptDescription += "as output from MRIConvert, into a JSON format that "
scriptDescription += "satisfies the BIDS standard format."
scriptEpilog  = "This project was launched at Eugene Brainhack 2017 "
scriptEpilog += "(https://brainhack-eugene.github.io/)."
parser = argparse.ArgumentParser(
	description = scriptDescription,
	epilog = scriptEpilog
)

inHelp  = "filename of the input DICOM header file with either an absolute "
inHelp += "or a relative path" 
parser.add_argument("-i","--infile",required=True,help=inHelp)

outHelp  = "(optoinal) filename of the output json file with either an absolute "
outHelp += "or a relative path; if no output filename is provided, one will be "
outHelp += "created from the input filename." 
parser.add_argument("-o","--outfile",help=outHelp)

verboseHelp = "Flag (no value) used to set the verbosity of script execution."
parser.add_argument("-v","--verbose", help=verboseHelp, action="store_true")

# Check out the parser details...
#parser.print_help()

# Parse command line arguments
args = parser.parse_args()
if args.verbose: print 'Command line arguments: \n  ',args

if not args.outfile: 
	args.outfile = args.infile.replace('.txt','.json')
	print "Output filename:",args.outfile

### DATA MUNGING
# Rename: replace DICOM field labels with BIDS compatible labels
replaceNames = {
	'Repetition time (ms)':'RepetitionTime'
}

# Filter: include only the fields in the following list
fieldShortlist = ['Series UID','Series description','RepetitionTime']

# Conversions: modify values as needed, e.g., unit conversions
def milliToSec(ms):
	return 1.0*ms/1000

conversions = {}
conversions['RepetitionTime']=milliToSec


### PROCESSING
# Read the input file
with open(args.infile, 'rb') as hdrFile:
	acc = {}
	# process each line
	for line in hdrFile:
		key,value = line.strip().split(':')
		# rename any fields in the lookup table
		if key in replaceNames: key = replaceNames[key]
		# only record the desired fields
		if key in fieldShortlist:
			# ensure numbers are numbers
			try:
				temp = int(value.strip())
			except:
				temp = value.strip()
			if args.verbose: print key,temp
			# apply conversion, as needed
			if key in conversions:
				if args.verbose: print 'Performing conversion',conversions[key]
				acc[key] = conversions[key](temp)
			else:
				acc[key] = temp	

with open(args.outfile, 'wb') as jsonFile:
	json.dump(acc,jsonFile,indent=1)
	