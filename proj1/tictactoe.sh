#!/bin/bash

TOP="      a       b       c "
HORIZONTAL_BORDER="--|-------|-------|-------|-"
EMPTY_TOP_BOT="  |       |       |       |"
TO_FILL_LEFT="|   "
TO_FILL_RIGHT="   "

WIDTH=3
HEIGHT=3
FIELDS=(" " " " " " " " " " " " " " " " " ")

# FIELDS=("O" "O" " " "X" "X" " " " " " " " ")
# FIELDS=("O" "X" " " "O" "X" " " " " " " " ")
# FIELDS=(" " "X" " " "O" "O" " " " " "X" " ")

print_board () {
    printf "%s\n" "$TOP"
    for i in $(seq 1 $HEIGHT); do
        printf "%s\n" "$HORIZONTAL_BORDER"
        printf "%s\n" "$EMPTY_TOP_BOT"
        printf "%d " $i
        for j in $(seq 1 $WIDTH); do
            printf "%s%s%s" "$TO_FILL_LEFT" "${FIELDS[((i-1)*$HEIGHT+j-1)]}" "$TO_FILL_RIGHT"
        done
        printf "|\n"
        printf "%s\n" "$EMPTY_TOP_BOT"
    done
    printf "%s\n" "$HORIZONTAL_BORDER"
}

get_coords () {
    regex="^([abcABC])([123])"
    ready=0
    while [ $ready -eq 0 ]; do
        read -p "Podaj wspolrzedne: " coords
        if [[ $coords =~ $regex ]]; then
            letter="${BASH_REMATCH[1]}"
            number="${BASH_REMATCH[2]}"
            if [ $letter = "a" ] || [ $letter = "A" ]; then
                letter=1
            fi
            if [ $letter = "b" ] || [ $letter = "B" ]; then
                letter=2
            fi
            if [ $letter = "c" ] || [ $letter = "C" ]; then
                letter=3
            fi
            if [ "${FIELDS[(($number-1)*$HEIGHT+$letter-1)]}" = " " ]; then
                ready=1
                FIELDS[(($number-1)*$HEIGHT+$letter-1)]=$1
            else
                echo "Podano niepoprawne wspolrzedne"    
            fi
        else
            echo "Podano niepoprawne wspolrzedne"
        fi
    done
}

checkWinner() {
    # horizontal check
    for row in {0..2}; do
        same=1
        startId=$((row*WIDTH))
        startVal="${FIELDS[$startId]}"
        if [ "$startVal" != " " ]; then
            for column in {1..2}; do
                nextVal=${FIELDS[(($startId+$column))]}
                if [ "$nextVal" = $startVal ]; then
                    ((same = 1 + same))
                fi
            done
        fi
        if [ $same -eq 3 ]; then
            return 0
        fi
    done

    # vertical check
    for col in {0..2}; do
        same=1
        startId=$col
        startVal="${FIELDS[$startId]}"
        if [ "$startVal" != " " ]; then
            for row in {1..2}; do
                nextVal=${FIELDS[(($startId+$row*$WIDTH))]}
                if [ "$nextVal" = $startVal ]; then
                    ((same = 1 + same))
                fi
            done
        fi
        if [ $same -eq 3 ]; then
            return 0
        fi
    done

    # diagonal check
    if [ "${FIELDS[0]}" != " " ] && [ "${FIELDS[0]}" = "${FIELDS[4]}" ] && [ "${FIELDS[4]}" = "${FIELDS[8]}" ]; then
        return 0
    fi
    if [ "${FIELDS[2]}" != " " ] && [ "${FIELDS[2]}" = "${FIELDS[4]}" ] && [ "${FIELDS[4]}" = "${FIELDS[6]}" ]; then
        return 0
    fi

    return 1
}

play() {
    round=$(shuf -i 0-1 -n 1)
    rounds=( "O" "X" )

    print_board

    currRound=0
    MAX_ROUND=9
    while [ $currRound -ne $MAX_ROUND ]; do
        echo "Runda ${rounds[$round]}"
        get_coords ${rounds[$round]}
        clear
        print_board
        checkWinner

        if [ $? -eq 0 ]; then
            echo "Wygrywa ${rounds[$round]}"
            break
        fi
        ((round = 1 - round))
        ((currRound = 1 + currRound))
    done
    if [ $currRound = $MAX_ROUND ]; then
        echo "Remis!"
    fi
}

clear
play
