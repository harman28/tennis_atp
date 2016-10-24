#!/bin/bash

#Set database name
if [ $# -eq 2 ]; then
   MYDATABASE="atpdatabase"
else
   MYDATABASE=$3
fi

#Get MySQL username and password from the arguments
USERNAME=$1
PASSWORD=$2

#Get PWD
PWD=`pwd`

echo "Creating $MYDATABASE"

mysql -u $USERNAME -p$PASSWORD << EOF

#Create database from scratch
create database $MYDATABASE;

#Create players table
CREATE TABLE $MYDATABASE.players (
    id int,
    firstname varchar(255),
    lastname varchar(255),
    hand varchar(255),
    birth varchar(255),
    country varchar(255)
);

#Create matches table
CREATE TABLE $MYDATABASE.matches (
	  tourney_id varchar(255),
    tourney_name varchar(255),
    surface varchar(255),
    draw_size varchar(255),
    tourney_level varchar(255),
    tourney_date varchar(255),
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
);

#Create rankings table.
CREATE TABLE $MYDATABASE.rankings (
    date varchar(255),
    pos int,
    player_id int,
    pts int
);

load data infile '$PWD/../../atp_players.csv' into table $MYDATABASE.players FIELDS TERMINATED BY ',';

EOF

for x in $(ls $PWD/../../atp_rankings_*s.csv);
	do mysql -u $USERNAME -p$PASSWORD -e "load data infile '$x' into table $MYDATABASE.rankings FIELDS TERMINATED BY ','";
done;

for x in $(ls $PWD/../../atp_matches_*.csv);
	do mysql -u $USERNAME -p$PASSWORD -e "load data infile '$x' into table $MYDATABASE.matches FIELDS TERMINATED BY ',' IGNORE 1 LINES";
done;

echo "Done!"
