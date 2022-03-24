#!/bin/bash
array=(- - - - - - - - -)
playing=true
ai=false
reg='^[0-9]{8}$'
printBoard(){
    echo "-------------------------------------------"
    echo " ${array[0]} | ${array[1]} | ${array[2]}" 
    echo ""
    echo " ${array[3]} | ${array[4]} | ${array[5]}" 
    echo ""
    echo " ${array[6]} | ${array[7]} | ${array[8]}" 
    echo "-------------------------------------------"
}
playerXinput(){
    echo "Gdzie postawić X"
    read xVariable
    while ! [[ "$xVariable" =~ ^[0-9]+$ ]] || ! [[ "${array[$xVariable - 1]}" = "-" ]];
    do
    if [[ "$xVariable" == "S" ]]; then
    echo ${array[@]} > save.txt
    echo "X" >> save.txt
    echo "Zapisano"
    echo "Gdzie postawić X"
    read xVariable
    else
    echo "Błędna wartość"
    read xVariable; fi
    done
    array[($xVariable - 1)]='X'
    
}
playerOinput(){
    if $ai = true ; then
    index=$((1 + $RANDOM % 9))
    while [[ "${array[$index - 1]}" != "-" ]];
    do
    index=$((1 + $RANDOM % 9))
    echo $index
    done
    array[($index - 1)]='Y'
    else
    echo "Gdzie postawić Y"
    read xVariable
    while ! [[ "$xVariable" =~ ^[0-9]+$ ]] || ! [[ "${array[$xVariable - 1]}" = "-" ]];
    do
    if [[ "$xVariable" == "S" ]]; then
    echo "Y" > save.txt
    echo ${array[@]} >> save.txt
    echo "Zapisano"
    echo "Gdzie postawić Y"
    read xVariable
    else
    echo "Błędna wartość"
    read xVariable; fi
    done
    array[($xVariable - 1)]='Y'
    fi
}
checkVictory(){
    if [[ ${array[$1]} == '-' ]]; then return; fi
    if [[ ${array[$1]} == ${array[$2]} ]] && [[ ${array[$2]} == ${array[$3]} ]]; 
    then 
    echo "Wygrywa ${array[$1]}"; 
    playing=false
    fi  
}
checkIfWin(){
  checkVictory 0 1 2
  checkVictory 3 4 5
  checkVictory 6 7 8
  checkVictory 0 4 8
  checkVictory 2 4 6
  checkVictory 0 3 6
  checkVictory 1 4 7
  checkVictory 2 5 8
  if [[ ! " ${array[*]} " =~ "-" ]]; then
    if $playing ; then
    echo "Remis"; 
    playing=false
    fi
  fi
}
menu(){
    echo "1 - Nowa gra"
    echo "2 - Wczytaj grę"
    echo "3 - Graj z AI"
    read choosenMenu
    if [[ $choosenMenu == "1" ]]; then return; fi
    if [[ $choosenMenu == "2" ]]; then 
        FILE=save.txt
        if test -f "$FILE"; then
            echo "Ładowanie"
            IFS=$'\n' array=( $(xargs -n1 <save.txt) )
            tag=$( tail -n 1 save.txt )
            if [[ $tag = "X" ]] ;  then return; fi
            if [[ $tag = "Y" ]] ;  then 
            printBoard
            playerOinput
            printBoard
            checkIfWin
            return;
        fi
        else
        echo "Brak gry do załadowania"
        menu
    fi
    return; fi
    if [[ $choosenMenu == "3" ]]; then
     ai=true
     return; fi
    exit 1
}

menu
echo "Aby zapisać grę wciśnij S"
while  $playing
do
    printBoard
    playerXinput
    printBoard
    checkIfWin
    if $playing; then
    playerOinput
    printBoard
    checkIfWin;
    fi
done
