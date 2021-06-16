#!/bin/bash

while getopts ":t:" opt; do
  case ${opt} in
    t )
      target=$OPTARG
      curl -H "X-Auth-Token: e1eb666d612943eeab32270b0cf5669a" https://api.football-data.org/v2/competitions/SA/matches?matchday=$target > file.json
      while [[ csapat != end ]]
do
echo "Melyik csapat legyen?"
read csapat

szo=`cat file.json|jq | grep -B3 "$csapat" | grep "homeTeam" | cut -c 8-15`

if [[ "$szo" == "homeTeam" ]]
then
        tput reset
        HomeTeam="$csapat"
        AwayTeam=`cat file.json | jq | grep -A4 "$csapat" | grep -A2 "awayTeam" | grep "name" | cut -c 18-`
        HomeScore=`cat file.json|jq | grep -B19 "$csapat" | grep -A3 "fullTime" | grep "homeTeam" | cut -c 23`
        AwayScore=`cat file.json|jq | grep -B19 "$csapat" | grep -A3 "fullTime" | grep "awayTeam" | cut -c 23`
        echo "$HomeTeam -  ${AwayTeam::-1}  $HomeScore-$AwayScore"

elif [[ "$csapat" == "end" ]]
then
	echo "Vége"
	exit
else
        tput reset
        AwayTeam="$csapat"
        HomeTeam=`cat file.json|jq | grep -B6 -A4 "$csapat" | grep -A4 "homeTeam" | grep "name" | cut -c 18- `
        HomeScore=`cat file.json|jq | grep -B26 "$csapat" | grep -A3 "fullTime" | grep "homeTeam" | cut -c 23`
        AwayScore=`cat file.json|jq | grep -B26 "$csapat" | grep -A3 "fullTime" | grep "awayTeam" | cut -c 23`
        echo "${HomeTeam::-1} - $AwayTeam $HomeScore-$AwayScore"
         
fi
done
	

      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      ;;
  esac
done
shift $((OPTIND -1))

