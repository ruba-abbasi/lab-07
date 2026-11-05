#!/bin/bash

# Remove old outputs (for all the directories)
rm -rf Testcase1Diff Testcase2Diff Testcase3Diff Testcase4Diff

#loop thru all the testcases
for testcase in Testcase1 Testcase2 Testcase3 Testcase4
do 
    diffdir="${testcase}Diff" #store the output as (wtvrtestcase)Diff

    for file1 in "$testcase"/*.1.txt #loop thru all the files w sumn.1
    do
        file2="${file1/.1.txt/.2.txt}" #find the matching .2 file

        if ! diff -u "$file1" "$file2" > /tmp/diff_output #if there r differences the then will run
        then # Create output directory only when first difference is found
            if [ ! -d "$diffdir" ]
            then
                mkdir "$diffdir"
            fi

            base=$(basename "$file1" .1.txt) #get the name of the version

            cp /tmp/diff_output "$diffdir/${base}Diff.txt" #save the temporary diff output into one named how the assignment wants 
        fi
    done
done
   