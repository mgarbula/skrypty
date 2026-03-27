#!/bin/bash

TOP="      a       b       c "
HORIZONTAL_BORDER="--|-------|-------|-------|-"
EMPTY_TOP_BOT="  |       |       |       |"
TO_FILL_LEFT="|   "
TO_FILL_RIGHT="   "

WIDTH=3
HEIGHT=3
FIELDS=(" " " " " " " " " " " " " " " " " ")

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
            ready=1
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
            FIELDS[(($number-1)*$HEIGHT+$letter-1)]=$1
        else
            echo "Podano niepoprawne wsplrzedne"
        fi
    done
}

print_board
get_coords "X"
print_board