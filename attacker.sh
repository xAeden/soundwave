#/bin/bash
clear
echo initialisation de la connexion
minute=$(date +%M)
let "fenetre_de_tire=$minute % 4"
# echo $minute
# echo $fenetre_de_tire


# Définie la fenetre de tire durant laquelle la machine distante est en écoute
while [ $fenetre_de_tire -ge 2 ] ; do
  sleep 2
  minute=$(date +%M)
  let "fenetre_de_tire=$minute % 4"
  echo $fenetre_de_tire
done

# Check si la machine distante répond
sleep 20
# echo "SYN"
echo "SYN" | minimodem --tx 20
echo "SYN send"
sleep 90

echo "Attente ACK"
timeout 100s minimodem --rx 20 > tmp.txt
# ACK=$(<tmp)
# echo $ACK
sleep 1
if [ $(grep -c "ACK" tmp.txt) != 0 ]; then
  clear
  echo connexion etablie
  sleep 20
else
  clear
  echo connexion impossible
  sleep 5 
  exit
fi
rm tmp.txt

# Transmission de la commande a la machine distante
clear
echo Entrez la commande à transmettre
read "remote_commande"
# echo $remote_commande > cmd.tmp


minute=$(date +%M)
let "fenetre_de_tire=$minute % 4"


# Définie la fenetre de tire durant laquelle la machine locale doit écouter
while [ $fenetre_de_tire -ge 2 ] ; do
  sleep 2
  minute=$(date +%M)
  let "fenetre_de_tire=$minute % 4"
  echo $fenetre_de_tire
done
# echo "dodo 10s"
sleep 10

echo -e "$remote_commande\n$remote_commande\n$remote_commande\n$remote_commande\n"| timeout 1m minimodem --tx 20


sleep 90
date >> data.txt
echo "CMD : $remote_commande" >> data.txt
echo -e "_______________________________________\n" >> data.txt
# cat cmd.tmp >> data.txt
timeout 1m minimodem --rx 100 >> data.txt
echo -e "\n\n\n" >> data.txt
