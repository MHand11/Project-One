awk '{print $1, $2, $3, $4, $5, $6, $7, $8}' $1_Dealer_schedule | grep $2:00:00 | grep $3

echo 'Time Blackjack_Dealer Roulette_Dealer Texas_holdem_Dealer'
