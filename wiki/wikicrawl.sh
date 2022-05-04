#! /bin/bash

clear
echo "Wikipedia Crawler"
printf "Seed link? (i.e. Article_name): "
read link
echo ""

# Assign a default url if it's none is passed as a parameter
url=${1:-'https://en.wikipedia.org/wiki/'"$link"}
echo "Processing url: $url"

echo "How many pages?"

# Configuration Variables
read MAXADDRESS
filename="index.html"
DIRECTORY="./wiki"
echo "Max number of links: $MAXADDRESS"
echo
START_TIME=$(date +%s)
echo "Process started at $(date)"
echo
echo
echo "Step 1 - BFS Algorithm - Web Crawler"
echo "Start Executing..."
echo ""

# Assign a default url if it's none is passed as a parameter
url=${1:-'https://en.wikipedia.org/wiki/Occult'}
echo "Processing url: $url"

# Check if the download diectory exist
if [ ! -d "$DIRECTORY" ]; then
	echo "Creating DIRECTORY: $DIRECTORY"
	mkdir "$DIRECTORY"
fi

# get the start file
wget $url -O "wiki/${filename}"

ARRAY_TEMP=($(grep -i "\(href=\"\/wiki\/\w*\"\)" "wiki/${filename}" -o))

# ARRAY_TEMP=(Banana Maca Limao Banana Maca Kiwi)

# echo "ARRAY_MAIN"
# echo ${ARRAY_MAIN[*]}

#star counter
COUNT_LINKS=0
COUNT_ARRAY_MAIN=0
COUNT_ARRAY_TEMP=0
COUNT_CONTROL=0
ARRAY_MAIN_LEN=0
ARRAY_TEMP_LEN=${#ARRAY_TEMP[@]}
TOINSERT=1

# echo "INITIAL LENGTH: ${#ARRAY_TEMP[@]}"

while [ "$COUNT_ARRAY_TEMP" -lt "$ARRAY_TEMP_LEN" ] && [ "$COUNT_LINKS" -lt "$MAXADDRESS" ]
do
	# echo "COUNT_ARRAY_MAIN: $COUNT_ARRAY_MAIN  ARRAY_MAIN_LEN: $ARRAY_MAIN_LEN"
	# echo "COUNT_ARRAY_TEMP: $COUNT_ARRAY_TEMP  ARRAY_TEMP_LEN: $ARRAY_TEMP_LEN"
	# echo ""
	while [ "$COUNT_ARRAY_MAIN" -lt "$ARRAY_MAIN_LEN" ] && [ "$TOINSERT" -eq 1 ]
	do
		if [ "${ARRAY_TEMP[$COUNT_ARRAY_TEMP]}" == "${ARRAY_MAIN[$COUNT_ARRAY_MAIN]}" ]; then
			# Flags that item found in main array and is not to be inserted
			TOINSERT=0
		else
			# Flags that item not found in main array
			TOINSERT=1
			# restart count for main array list
			# COUNT_ARRAY_MAIN=0
		fi
		# move to next array item
		COUNT_ARRAY_MAIN=$(( $COUNT_ARRAY_MAIN + 1 ))
		# echo "COUNT_ARRAY_MAIN: $COUNT_ARRAY_MAIN  ARRAY_MAIN_LEN: $ARRAY_MAIN_LEN"
	done

	if [ "$TOINSERT" -eq 1 ]; then
		# insert TEMP item into main array list
		ARRAY_MAIN=(${ARRAY_MAIN[*]} ${ARRAY_TEMP[$COUNT_ARRAY_TEMP]})
		# updates array length
		ARRAY_MAIN_LEN=${#ARRAY_MAIN[@]}
		# insert TEMP item into control array list
		CONTROL=(${CONTROL[*]} ${ARRAY_TEMP[$COUNT_ARRAY_TEMP]})
		# updates the link counter
		COUNT_LINKS=$(( $COUNT_LINKS + 1 ))
		# echo "COUNT_LINKS: $COUNT_LINKS"
	else
		# resets flag for item not found
		TOINSERT=1
	fi

	# restart count for main array list
	COUNT_ARRAY_MAIN=0

	# move to next array item in TEMP
	COUNT_ARRAY_TEMP=$(( $COUNT_ARRAY_TEMP + 1 ))

	# echo "size: $COUNT_ARRAY_TEMP max_size: $ARRAY_TEMP_LEN"
	if [ "$COUNT_ARRAY_TEMP" -ge "$ARRAY_TEMP_LEN" ]; then
		# Get next array to process
		# get the start file
		# removes href="
		echo -n "."
		filename=$(echo ${CONTROL[$COUNT_CONTROL]} | cut -d '"' -f 2)
		# removes /wiki/
		filename=${filename:6}
		url="https://en.wikipedia.org/wiki/${filename}"
		# wget $url -O "wiki/${filename}.html"
		# wget $url -q -O "wiki/${filename}.html"
		# In server use curl instead of wget
		curl -s "https://en.wikipedia.org/wiki/${filename}" > "wiki/${filename}.html"

		ARRAY_TEMP=($(grep -i "\(href=\"\/wiki\/\w*\"\)" "wiki/${filename}.html" -o))
		# echo ${CONTROL[$COUNT_CONTROL]}
		# Moves to next item in control list
		COUNT_CONTROL=$(( $COUNT_CONTROL + 1 ))
		# ARRAY_TEMP=(Uva Maca Jaca Banana Kiwi Kaki)
		# Resets length of temp array
		ARRAY_TEMP_LEN=${#ARRAY_TEMP[@]}
		# Resets index for temp array
		COUNT_ARRAY_TEMP=0
		# echo "new size: $COUNT_ARRAY_TEMP new max_size: $ARRAY_TEMP_LEN"
	fi

done

# After reaching the processing cap keep downloading the rest of the pages
while [ "$COUNT_CONTROL" -lt "$ARRAY_MAIN_LEN" ]
do
	# Get next array to process
	# get the start file
	# removes href="
	echo -n "."
	filename=$(echo ${CONTROL[$COUNT_CONTROL]} | cut -d '"' -f 2)
	# removes /wiki/
	filename=${filename:6}
	url="https://en.wikipedia.org/wiki/${filename}"
	# wget $url -O "wiki/${filename}.html"
	# wget $url -q -O "wiki/${filename}.html"

	# In server use curl instead of wget
	curl -s "https://en.wikipedia.org/wiki/${filename}" > "wiki/${filename}.html"

	# echo ${CONTROL[$COUNT_CONTROL]}
	# Moves to next item in control list
	COUNT_CONTROL=$(( $COUNT_CONTROL + 1 ))
	lynx -dump wiki/"$filename".html > wiki/"$filename".txt
	#rm -f wiki/*.html
done

echo
END_TIME_1=$(date +%s)
echo "Step 1 finished at $(date) - $(($END_TIME_1 - $START_TIME)) seconds"
echo "Process finished!!! $(($END_TIME_2 - $START_TIME)) seconds"
