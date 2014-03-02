#
# Geneate Docset via Doxygen and optionally load it into Xcode
#
# Usage: 
#   tool-docset.sh -h
#
# Created by Fred McCann on 03/16/2010.
# Modified by http://www.duckrowing.com on 10/26/2010 
# Modified by David Andreoletti (http://davidandreoletti.com) on 05/26/2012
#
# Based on the build script provided by Apple:
# http://developer.apple.com/tools/creatingdocsetswithdoxygen.html
#

######################################################################
#
#                           DO NOT MODIFY
DEFAULT_DOXYGEN_PATH="/Applications/Doxygen.app/Contents/Resources/doxygen"
DEFAULT_DOXYFILE_NAME="Doxyfile"
DEFAULT_DOXYFILE_SRC_PATH="./$DEFAULT_DOXYFILE_NAME"
DEFAULT_OUTPUT_PATH="./doc"
DEFAULT_LOAD_DOCSET_FLAG="false"
DEFAULT_SOURCE_PATH="./src"
DEFAULT_PROJECT_SUBNAME=""
DEFAULT_COMPANY_REVERSE_DOMAIN_PREFIX="com.example.company"
DOXYFILE_TMP_PATH=$TEMP_DIR/$DEFAULT_DOXYFILE_NAME
LOAD_DOCSET_SCRIPT_PATH="$TEMP_DIR/loadDocSet.scpt"

#
######################################################################


######################################################################
# FUNCTIONS
######################################################################

######################################################################
#   usage()
######################################################################
function usage
{
cat << EOF
  Builds documentation for an Xcode project.

  Usage: `basename "$0"` [OPTIONS]

  OPTIONS:
  -f  "<value>"   Absolute path to Doxygen configuration file. Default: $DEFAULT_DOXYFILE_SRC_PATH

  -s  "<value>"   Absolute paths to directory containing sources to take documentation from. Default: $DEFAULT_SOURCE_PATH.
                  Note: If there is more than one directory to add, please use the following syntax: "<value> <value2> <value3>"
                  where each whitespace equal: <a whitespace character><a backslash character><a carriage return character>
  -d  "<value>"   Absolute path to Doxygen binary. Default: $DEFAULT_DOXYGEN_PATH

  -o  "<value>"   Absolute path to directory where to output generated documentation to. Default: $DEFAULT_OUTPUT_PATH

  -n  "<value>"   Project sub name (value $PROJECT_NAME will be prefixed to it). Default: $DEFAULT_PROJECT_SUBNAME

  -r  "<value>"   Reverse Domain prefix. Default: $DEFAULT_COMPANY_REVERSE_DOMAIN_PREFIX

  -l              Flag to load Docset into Xcode. Allowed value: true|false. Default: $DEFAULT_LOAD_DOCSET_FLAG

  -h              This help.

  CAVEATS:
    This script MUST be executed as part of a Xcode Build Phase since it 
    requires access Xcode environement viaraibles such as $TMP_DIR and 
    $PROJECT environment

  ENVIRONEMENT:
    Successfully tested on Mac OS X 10.6.8 + Xcode 4.0.2.

  AUTHORS:
    David Andreoletti (http://davidandreoletti.com)
EOF
}

######################################################################
#   generateDocumentation()
######################################################################
function generateDocumentation
{
    if ! [ -f "$DOXYFILE_SRC_PATH" ] 
    then 
        echo "Doxygen config file does not exist at $DOXYFILE_SRC_PATH. It will be generated."
        $DOXYGEN_PATH -g "$DOXYFILE_SRC_PATH"
    fi

    #  Append the proper input/output directories and docset info to the config file.
    #  This works even though values are assigned higher up in the file. Easier than sed.

    cp -v "$DOXYFILE_SRC_PATH" "$DOXYFILE_TMP_PATH"

    echo "INPUT = $SOURCE_PATH" >> "$DOXYFILE_TMP_PATH"
    echo "OUTPUT_DIRECTORY = \"$OUTPUT_PATH\"" >> "$DOXYFILE_TMP_PATH"
    echo "RECURSIVE = YES" >> "$DOXYFILE_TMP_PATH"
    echo "EXTRACT_ALL        = YES" >> "$DOXYFILE_TMP_PATH"
    echo "JAVADOC_AUTOBRIEF        = YES" >> "$DOXYFILE_TMP_PATH"
    echo "GENERATE_LATEX        = NO" >> "$DOXYFILE_TMP_PATH"
    echo "GENERATE_DOCSET        = YES" >> "$DOXYFILE_TMP_PATH"
    echo "DOCSET_FEEDNAME = $PROJECT_NAME $PROJECT_SUBNAME" >> "$DOXYFILE_TMP_PATH"
    echo "DOCSET_BUNDLE_ID       = $DOCSET_BUNDLE_ID" >> "$DOXYFILE_TMP_PATH"

    #  Run doxygen on the updated config file.
    #  Note: doxygen creates a Makefile that does most of the heavy lifting.

    $DOXYGEN_PATH "$DOXYFILE_TMP_PATH"
}

######################################################################
#   generateDocset()
######################################################################
function generateDocset
{
    #  make will invoke docsetutil. Take a look at the Makefile to see how this is done.

    make -C "$OUTPUT_PATH/html" install

    #  Construct a temporary applescript file to tell Xcode to load a docset.

    rm -f "$LOAD_DOCSET_SCRIPT_PATH"

    echo "tell application \"Xcode\"" >> "$LOAD_DOCSET_SCRIPT_PATH"
    echo "load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/$DOCSET_BUNDLE_ID.docset\"" >> "$LOAD_DOCSET_SCRIPT_PATH"
    echo "end tell" >> "$LOAD_DOCSET_SCRIPT_PATH"
}

######################################################################
#   loadDocsetIntoXcode()
######################################################################
function loadDocsetIntoXcode
{
    #  Run the load-docset applescript command.
    osascript "$LOAD_DOCSET_SCRIPT_PATH"
}

################################################################################
# MAIN
################################################################################

# Parse positional parameters
# NOTE: getopts supports 1 char per argument. getopt supports multiple char but
# is not instaled by default on MAc OS X.
OPTIND=1
while getopts o:d:f:s:l:n:r:h LOOP0_OPTION
do
case $LOOP0_OPTION in
  o)
    OUTPUT_PATH=${OPTARG:-$DEFAULT_OUTPUT_PATH}
  ;;
  d)
    DOXYGEN_PATH=${OPTARG:-DEFAULT_DOXYGEN_PATH}
  ;;
  f)
    DOXYFILE_SRC_PATH=${OPTARG:-$DEFAULT_DOXYFILE_SRC_PATH}
  ;;
  s)
    SOURCE_PATH=${OPTARG:-$DEFAULT_SOURCE_PATH}
  ;;
  l)
    LOAD_DOCSET_FLAG=${OPTARG:-$DEFAULT_LOAD_DOCSET_FLAG}
  ;;
  n)
    PROJECT_SUBNAME=${OPTARG:-$DEFAULT_PROJECT_SUBNAME}
  ;;
  r)
    COMPANY_REVERSE_DOMAIN_PREFIX=${OPTARG:-$DEFAULT_COMPANY_REVERSE_DOMAIN_PREFIX}
  ;;
  h)
    usage
    exit 0;
  ;;
  ?)
    echo "error: [Invalid arguments(s)]: $LOOP0_OPTION $OPTARG"
    usage
    exit 0;
  ;;
esac
done

# Set default values for parameters not specified in command line
OUTPUT_PATH=${OUTPUT_PATH:-$DEFAULT_OUTPUT_PATH}
DOXYGEN_PATH=${DOXYGEN_PATH:-$DEFAULT_DOXYGEN_PATH}
DOXYFILE_SRC_PATH=${DOXYFILE_SRC_PATH:-$DEFAULT_DOXYFILE_SRC_PATH}
SOURCE_PATH=${SOURCE_PATH:-$DEFAULT_SOURCE_PATH}
LOAD_DOCSET_FLAG=${LOAD_DOCSET_FLAG:-$DEFAULT_LOAD_DOCSET_FLAG}
PROJECT_SUBNAME=${PROJECT_SUBNAME:-$DEFAULT_PROJECT_SUBNAME}
COMPANY_REVERSE_DOMAIN_PREFIX=${COMPANY_REVERSE_DOMAIN_PREFIX:-$DEFAULT_COMPANY_REVERSE_DOMAIN_PREFIX}
DOCSET_BUNDLE_ID=$COMPANY_REVERSE_DOMAIN_PREFIX.$PROJECT

generateDocumentation
generateDocset
loadDocsetIntoXcode

exit 0
