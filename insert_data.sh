#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games RESTART IDENTITY")
tail -n +2 games.csv | while IFS="," read YEAR ROUND WINNER OP WINNER_GOALS OP_GOALS
do
#winners
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  if [[ -z $WINNER_ID ]]
  then
    INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
    if [[ $INSERT_TEAM == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $WINNER
    fi
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  fi
#losers
  OP_ID=$($PSQL "select team_id from teams where name = '$OP'")
  if [[ -z $OP_ID ]]
  then
    INSERT_TEAM=$($PSQL "insert into teams(name) values('$OP')")
    if [[ $INSERT_TEAM == "INSERT 0 1" ]]
    then 
      echo Inserted into teams, $OP
    fi
  OP_ID=$($PSQL "select team_id from teams where name = '$OP'")
  fi
#games
  INSERT_GAME=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
  values('$YEAR', '$ROUND', '$WINNER_ID', '$OP_ID', '$WINNER_GOALS', '$OP_GOALS')")
  if [[ $INSERT_GAME == "INSERT 0 1" ]]
  then
    echo Inserted into games, $YEAR : $ROUND : $WINNER_ID : $OP_ID : $WINNER_GOALS : $OP_GOALS
  fi
done