#!/bin/bash

#Set database name
if [ $# -eq 0 ]; then
   MYDATABASE="atpdatabase"
elif [ $# -eq 1 ]; then
   MYDATABASE=$1
else
  echo "Invalid parameters!";
  exit 1
fi

#Get MySQL username and password
echo -n "MySQL Username: "
read USERNAME
echo -n "Password: "
read -s PASSWORD
echo

#Get PWD
PWD=`pwd`

echo "Creating $MYDATABASE"
#Create database from scratch; Drop if already exists
mysql -u $USERNAME -p$PASSWORD -e "drop database if exists $MYDATABASE;" 2>/dev/null
mysql -u $USERNAME -p$PASSWORD -e "create database $MYDATABASE;" 2>/dev/null


echo "Creating players table"
#Create players table
mysql -u $USERNAME -p$PASSWORD -e "CREATE TABLE $MYDATABASE.players (
    id int,
    firstname varchar(255),
    lastname varchar(255),
    hand varchar(255),
    birth varchar(255) default null,
    country varchar(255)
);" 2>/dev/null


echo "Creating matches table"
#Create matches table
mysql -u $USERNAME -p$PASSWORD -e "CREATE TABLE $MYDATABASE.matches (
	  tourney_id varchar(255),
    tourney_name varchar(255),
    surface varchar(255),
    draw_size varchar(255),
    tourney_level varchar(255),
    tourney_date date,
    match_num varchar(255),
    winner_id varchar(255),
    winner_seed varchar(255),
    winner_entry varchar(255),
    winner_name varchar(255),
    winner_hand varchar(255),
    winner_ht varchar(255),
    winner_ioc varchar(255),
    winner_age varchar(255),
    winner_rank varchar(255),
    winner_rank_points varchar(255),
    loser_id varchar(255),
    loser_seed varchar(255),
    loser_entry varchar(255),
    loser_name varchar(255),
    loser_hand varchar(255),
    loser_ht varchar(255),
    loser_ioc varchar(255),
    loser_age varchar(255),
    loser_rank varchar(255),
    loser_rank_points varchar(255),
    score varchar(255),
    best_of varchar(255),
    round varchar(255),
    minutes varchar(255),
    w_ace varchar(255),
    w_df varchar(255),
    w_svpt varchar(255),
    w_1stin varchar(255),
    w_1stwon varchar(255),
    w_2ndwon varchar(255),
    w_svgms varchar(255),
    w_bpsaved varchar(255),
    w_bpfaced varchar(255),
    l_ace varchar(255),
    l_df varchar(255),
    l_svpt varchar(255),
    l_1stin varchar(255),
    l_1stwon varchar(255),
    l_2ndwon varchar(255),
    l_svgms varchar(255),
    l_bpsaved varchar(255),
    l_bpfaced varchar(255)
);" 2>/dev/null


echo "Creating rankings table"
#Create rankings table.
mysql -u $USERNAME -p$PASSWORD -e "CREATE TABLE $MYDATABASE.rankings (
    date date,
    pos int,
    player_id int,
    pts int
);" 2>/dev/null


mysql -u $USERNAME -p$PASSWORD -e "load data infile '$PWD/atp_players.csv' into table $MYDATABASE.players FIELDS TERMINATED BY ','" 2>/dev/null
echo "Players Imported."


for x in $(ls $PWD/atp_rankings_*s.csv);
	do mysql -u $USERNAME -p$PASSWORD -e "load data infile '$x' into table $MYDATABASE.rankings FIELDS TERMINATED BY ','" 2>/dev/null
done;
echo "Rankings Imported."


for x in $(ls $PWD/atp_matches_*.csv);
	do mysql -u $USERNAME -p$PASSWORD -e "load data infile '$x' into table $MYDATABASE.matches FIELDS TERMINATED BY ',' IGNORE 1 LINES" 2>/dev/null
done;
echo "Matches Imported."

echo "Done!"
