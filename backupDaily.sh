#!/bin/bash

USER=nickste

#data para nomear arquivo.tar.gz
DATE=`date "+%d-%m-%Y-%H:%M"`

#ID do arquivo no Drive
DRIVEFILE="1VHnDVXeG31F6RQP_ew_tIWEmJlFQg3-8"
#Arquivos a fazer backup
BKPDIRS=(/home/${USER}/.ssh/ /home/${USER}/backupDir/ /home/${USER}/.local/share/Trash)
#Número de arquivos no Drive
NBKPSDRIVE=`/home/${USER}/Desktop/./gdrive sync content --order createdTime ${DRIVEFILE} | wc -l`
#Se a quantidade de arquivos salvos no Drive for maior que 5
if [ ${NBKPSDRIVE} -ge 5 ]
then

	#Usado para excluir corretamente o arquivo mais antigo do drive
	LINE=$((NBKPSDRIVE - 4))

	#Encontra o arquivo.tar.gz mais antigo no Drive
	OLDESTBKPDRIVE=`/home/$USER/Desktop/./gdrive sync content --order createdTime ${DRIVEFILE} | sed "${LINE}q;d" | awk '{print $1}'`
	NBKPSPC=`ls /var/backups/daily/ | wc -l`
	#Se a quantidade de backups for >= 5
	if [ ${NBKPSPC} -ge 5 ]
	then
		#remove esse mesmo arquivo mais antigo da máquina
		sudo rm /var/backups/daily/"$(ls -t /var/backups/daily | tail -1)"
	fi
	#remove o arquivo mais antigo do Drive
	/home/${USER}/Desktop/./gdrive delete ${OLDESTBKPDRIVE}
fi

sleep 1
#faz o backup dos diretórios escolhidos
sudo tar -czf /var/backups/daily/${DATE}.tar.gz ${BKPDIRS[@]}
#envia o backup feito para o Drive
/home/${USER}/Desktop/./gdrive sync upload /var/backups/daily/ ${DRIVEFILE}

