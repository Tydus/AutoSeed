#!/bin/bash

username=admin
password=123456
serverurl=192.168.1.102

tnum=0
num=0
for((;;)); do           #循环
	if [ -e ghptcookie ]; then rm ghptcookie;fi                 #曲奇AFK
	curl -d username=$username -d password=$password -c ghptcookie http://$serverurl/takelogin.php;      #曲奇来了！

	for torrent in *.torrent; do    #查找目录下所有的torrent
		
		if [ "$torrent" == "*.torrent" ]; then break; fi #当目录中不存在任何匹配内容时，i会被赋值为*.torrent，此时应跳出循环
		
		let "tnum += 1"       #种子计数  
		echo "Found a torrent $torrent,count $tnum"
		
		#txt="${torrent%.torrent}".txt         #查找匹配的TXT文件，‘%’为去掉结尾，‘#’为去掉开头
		#替换还可以用sed实现,如下 
		txt=`echo $torrent | sed 's@.torrent@.txt@'`  #看不懂
		if [ ! -e "$txt" ]; then
			echo "$txt file not found"
			break  #查找对应的TXT，如果没有则跳出循环
		fi
		

		for j in title subtitle type subtype des; do
			let "$j=`awk -F= 'flag{print $1}/=/{flag=0}/^$j=/{print $2;flag=1}' $txt`"
		done

		#################在这里加发布程序
		curl -F type=$type -F source_sel=$type -F "file=@"$torrent";type=application/octet-stream" -F name="${title}" -F small_descr="${subtitle}" -F "url=""" -F "dburl=""" -F "color=0" -F "font=0" -F "size=0" -F descr="${des}" -b ghptcookie http://$serverurl/takeupload.php

		#################发布程序完
		rm "$torrent"                 #处理完成，删除种子
		rm "$txt"
	done
	let "num += 1"
	echo "$num loop count"
	sleep 20
done
exit 0
