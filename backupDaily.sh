#!/bin/bash
source /bin/,backup/.env

#data para nomear arquivo.tar.gz
DATE=`date "+%d-%m-%Y-%H:%M"`

#Arquivos a fazer backup
echo "backing up these dirs: ${BKPDIRS[@]}"

#Número de arquivos no Drive
NBKPSDRIVE=`gdrive sync content --order createdTime ${DRIVEFILE} | wc -l`
echo "Number of files on Drive dir: ${NBKPSDRIVE}"

#Se a quantidade de arquivos salvos no Drive for maior que 5
if [ ${NBKPSDRIVE} -ge 5 ]
then

	#Usado para excluir corretamente o arquivo mais antigo do drive
	LINE=$((NBKPSDRIVE - 4))

	#Encontra o arquivo.tar.gz mais antigo no Drive
	OLDESTBKPDRIVE=`gdrive sync content --order createdTime ${DRIVEFILE} | sed "${LINE}q;d" | awk '{print $1}'`

	NBKPSPC=`ls ${BKPPATH} | wc -l`
	echo "Number of backups on local: ${NBKPSPC}"
	#Se a quantidade de backups for >= 5
	if [ ${NBKPSPC} -ge 5 ]
	then
		#remove esse mesmo arquivo mais antigo da máquina
		echo "removing $(ls -t /var/backups/daily | tail -1) from local"
		rm ${BKPPATH}"$(ls -t /var/backups/daily | tail -1)"
	fi
	#remove o arquivo mais antigo do Drive
	gdrive delete ${OLDESTBKPDRIVE}
	echo "Removing ${OLDESTBKPDRIVE} from drive"
fi

sleep 1
#faz o backup dos diretórios escolhidos
if [ tar -czf ${BKPPATH}${DATE}.tar.gz ${BKPDIRS[@]} -eq 2] then
	exit 1
fi
#envia o backup feito para o Drive
gdrive sync upload ${BKPPATH} ${DRIVEFILE}

