#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
INPUT=$1
if [[ -z $INPUT ]]
  then
    echo 'Please provide an element as an argument.'
  else
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    LENGTH=$(expr length "$INPUT")
    if [[ $LENGTH -gt 2 ]]
      then
        NAME=$INPUT
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'")
        if [[ -z $SYMBOL ]]
        then
          echo 'I could not find that element in the database.'
        else
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
          DATA=$($PSQL "select * from properties inner join types using(type_id) inner join elements using(atomic_number) where atomic_number=$ATOMIC_NUMBER")
          echo -e "$DATA" | while read ATOMIC_NUMBER BAR TYPE_ID BAR MASS BAR MELTING BAR BOILING BAR TYPE BAR SYMBOL BAR NAME
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
          done  
        fi
    else
      SYMBOL=$INPUT
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
        if [[ -z $NAME ]]
        then
          echo 'I could not find that element in the database.'
        else
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
          DATA=$($PSQL "select * from properties inner join types using(type_id) inner join elements using(atomic_number) where atomic_number=$ATOMIC_NUMBER")
          echo -e "$DATA" | while read ATOMIC_NUMBER BAR TYPE_ID BAR MASS BAR MELTING BAR BOILING BAR TYPE BAR SYMBOL BAR NAME
          do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
          done  
        fi
    fi
  else
    ATOMIC_NUMBER=$INPUT
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    if [[ -z $NAME ]]
    then
      echo 'I could not find that element in the database.'
    else
      DATA=$($PSQL "select * from properties inner join types using(type_id) inner join elements using(atomic_number) where atomic_number=$ATOMIC_NUMBER")
      echo -e "$DATA" | while read ATOMIC_NUMBER BAR TYPE_ID BAR MASS BAR MELTING BAR BOILING BAR TYPE BAR SYMBOL BAR NAME
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
fi
