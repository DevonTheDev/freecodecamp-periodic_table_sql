PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
 echo "Please provide an element as an argument."
else
  USER_INPUT=""
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    USER_INPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
  
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    USER_INPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1'")

  elif [[ $1 =~ ^[A-Z][a-z]*$ ]]
  then
    USER_INPUT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE name='$1'")

  fi
  

  if [[ ! -z $USER_INPUT ]]
  then
    echo $USER_INPUT | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME
    do
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")")
      echo $($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER") | while IFS="|" read delete ATOMIC_MASS MELTING_POINT BOILING_POINT delete2
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    done
  else
    echo "I could not find that element in the database."
  fi
fi
