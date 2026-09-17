#!/bin/bash

# Find the key interview
while read -r person; do
    line=$(echo "$person" | sed -n 's/.*line \([0-9]*\).*/\1/p')
    street=$(echo "$person" | sed -n 's/.*      \([^,]*\), line.*/\1/p' | tr ' ' '_')

    [ -z "$line" ] && continue
    [ ! -f "mystery/streets/$street" ] && continue

    result=$(head -n "$line" "mystery/streets/$street" | tail -n 1)

    if echo "$result" | grep -q "SEE INTERVIEW"; then
        number=$(echo "$result" | grep -o '[0-9]\+')
        if [ -f "mystery/interviews/interview-$number" ]; then
            content=$(cat "mystery/interviews/interview-$number")

            if echo "$content" | grep -qi "witness from the cafe"; then
                KEY_INTERVIEW="$number"
                break
            fi
        fi
    fi
done < <(grep "Annabel" mystery/people)

export KEY_INTERVIEW

echo "$KEY_INTERVIEW"
cat "mystery/interviews/interview-$KEY_INTERVIEW"
echo "$MAIN_SUSPECT"
