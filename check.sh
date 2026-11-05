#!/bin/bash

allpass=1 #assuming everything is all good and passes (set to 0 if theres a diff ever)

for num in 1 2 3 4 #loop thru all testcases
do
    testcase="Testcase$num"
    diffdir="${testcase}Diff" #everything is named this way in script.sh, refer to that

    #track this testcase
    pass=1 #this testcase passes
    needdir=0 #testcase contains at least one differing pair

    for file1 in "$testcase"/*.1.txt #loop the same way as script.sh
    do
        file2="${file1/.1.txt/.2.txt}"
        base=$(basename "$file1" .1.txt)
        outfile="$diffdir/${base}Diff.txt"

        tmp=$(mktemp) #temporary file to store the differences

        if ! diff -u "$file1" "$file2" > "$tmp" #if files differ save in temp file
        then
            needdir=1 #needa create a diff directory 

            if [ ! -f "$outfile" ] #checks if the output file exists
            then
                echo "Missing $outfile" >&2 #if its missing display this
                pass=0
            else
                if ! diff <(tail -n +3 "$tmp") <(tail -n +3 "$outfile") > /dev/null #tells it to ignore first two lines and start at line 3 so we can ignore the timestamps since we r only comparing outputs.
                then
                    echo "Incorrect contents in $outfile" >&2 #if we dont get the expected output print this
                    pass=0
                fi
            fi
        else #if there r no differences...
            if [ -f "$outfile" ] 
            then
                echo "Unexpected file $outfile" >&2 #no outfile shld exist, if it does display this
                pass=0 
            fi
        fi

        rm -f "$tmp" #remove the temporary
    done

    if [ $needdir -eq 1 ] #if u need a diff file, make sure it exists
    then
        if [ ! -d "$diffdir" ]
        then
            echo "Missing directory $diffdir" >&2 #if it doesnt display this
            pass=0
        fi
    else
        if [ -d "$diffdir" ] #if no pairs differ then we dont want a directory 
        then
            echo "Unexpected directory $diffdir" >&2 #if we have one display this
            pass=0
        fi
    fi

#print everything how lab wants 0 means pass and not 0 means sumn failed
    if [ $pass -eq 1 ]
    then
        echo "Testcase$num: PASS"
    else
        echo "Testcase$num: FAIL"
        allpass=0
    fi
done

if [ $allpass -eq 1 ]
then
    exit 0
else
    exit 1
fi