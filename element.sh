#!/bin/bash

ARG=$1
ARG_SIZE=${#ARG}
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -t -A -c"

# If there is no argument
if [[ -z $ARG ]]; then
  echo "Please provide an element as an argument."
else
  # Check if argument might be an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]; then
     QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ARG")
  
  # Check if argument might be an element symbol
  elif [[ ! $1 =~ ^[0-9]+$ ]] && [[ $ARG_SIZE -le 2 ]]; then
     QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ARG'")
  
  # Argument might be an element name
  else
    QUERY_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ARG'")
  fi

  # If element doesn't exist in database
  if [[ -z $QUERY_RESULT ]]; then
    echo "I could not find that element in the database."
  
  # If it does exist
  else
    # Querying for every property
    ATOMIC_NUMBER=$QUERY_RESULT
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$QUERY_RESULT")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$QUERY_RESULT")
    TYPE=$($PSQL "SELECT type FROM properties WHERE atomic_number=$QUERY_RESULT")
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$QUERY_RESULT")
    MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$QUERY_RESULT")
    BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$QUERY_RESULT")

    # Printing the full info
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi

