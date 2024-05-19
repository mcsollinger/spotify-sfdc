sf org create scratch -f ./config/project-scratch-def.json -a $1 -y $2 --set-default
sf project deploy start --wait 30