#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
  echo -e "\n$1" 
  fi
  SERVICE_RESULT=$($PSQL "select service_id, name from services;")
  echo "$SERVICE_RESULT" | while IFS="|" read SERVICE_ID SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  SERVICE_ID_FOUND=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
}
APPOINTMENT(){
  echo -e "\nWhat time would you like your $SERVICE_ID_FOUND, $CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")
  APPOINTMENT_ENTRY_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")
  echo -e "\nI have put you down for a $SERVICE_ID_FOUND at $SERVICE_TIME, $CUSTOMER_NAME."
}
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU
while [[ -z $SERVICE_ID_FOUND ]]
do
  MAIN_MENU "I could not find that service. What would you like today?"
done
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  CUSTOMER_ENTRY_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  APPOINTMENT
else
  APPOINTMENT
fi
