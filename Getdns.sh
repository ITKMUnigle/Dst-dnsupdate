#!/bin/bash
#判断hostlist
if [ ! -f "hostlist.txt" ];then
  #写入默认的hostlist
	echo "如果host过多或者dns服务器过多请耐心等待一会，不是卡了！不是卡了！不是卡了！"
	sudo touch hostlist.txt 
	sudo chmod 777 hostlist.txt 
	#请在这里添加/修改需要解析的主机
	#格式：echo "xxxx.com" >> hostlist.txt
	#例子：echo "baidu.com" >> hostlist.txt
	echo "dst.metrics.klei.com" >> hostlist.txt
  else
  #删除原来的
	sudo rm -rf hostlist.txt 
  #写入默认的hostlist
	echo "如果host过多或者dns服务器过多请耐心等待一会，不是卡了！不是卡了！不是卡了！"
	sudo touch hostlist.txt 
	sudo chmod 777 hostlist.txt 
	#请在这里添加/修改需要解析的主机
	#格式：echo "xxxx.com" >> hostlist.txt
	#例子：echo "baidu.com" >> hostlist.txt
	#echo "baidu.com" >> hostlist.txt
	echo "dst.metrics.klei.com" >> hostlist.txt
fi

#判断dnsserver
if [ ! -f "dnsserver.txt" ];then
	#写入默认的dnsserver
	sudo touch dnsserver.txt 
	sudo chmod 777 dnsserver.txt 
	#请在这里添加/修改需要dns服务器
	#格式：echo "xxx.xxx.xxx.xxx" >> dnsserver.txt 
	#例子：echo "223.5.5.5" >> dnsserver.txt
	echo "223.5.5.5" >> dnsserver.txt 
	echo "223.6.6.6" >> dnsserver.txt
	echo "114.114.114.114" >> dnsserver.txt
	echo "8.8.8.8" >> dnsserver.txt
	echo "180.76.76.76" >> dnsserver.txt
  else
  #删除原来的
	sudo rm -rf dnsserver.txt 
	#写入默认的dnsserver
	sudo touch dnsserver.txt 
	sudo chmod 777 dnsserver.txt 
	#请在这里添加/修改需要dns服务器
	#格式：echo "xxx.xxx.xxx.xxx" >> dnsserver.txt 
	#例子：echo "223.5.5.5" >> dnsserver.txt
	echo "223.5.5.5" >> dnsserver.txt 
	echo "223.6.6.6" >> dnsserver.txt
	echo "114.114.114.114" >> dnsserver.txt
	echo "8.8.8.8" >> dnsserver.txt
	echo "180.76.76.76" >> dnsserver.txt
fi


sudo chmod 777 /etc/hosts
#获取源文件行数
oldcount=$(wc -l /etc/hosts| awk '{print $1}')

#删除hosts文件内过期克雷IP
for oldhost in  $(cat hostlist.txt )
do
	sudo sed  "/$oldhost/d" -i  /etc/hosts
done

#删除后的行数
delcount=$(wc -l /etc/hosts| awk '{print $1}')

#写入新的dns解析
for host in $(cat hostlist.txt)
do
	for dnsserver in $(cat dnsserver.txt)
	do
		for ip in $(nslookup -qt=A $host $dnsserver |grep Address |awk -F "[: ]+" '{print $2}' |awk '!/127.0.0/'|awk '!/8.8.8/' |awk '!/#/')
		do
			echo "$ip $host" >> /etc/hosts
		done
	done
done

#计算写入后总行数
allcount=$(wc -l /etc/hosts| awk '{print $1}')

cat /etc/hosts
echo "-----------------------公共DNS查询网址：https://www.ip.cn/dns.html------------------------------"
echo "--------------------- 如果需要自行在 dnsserver.txt 文件中添加公共DNS-----------------------------"
echo "------------------------ 需要解析的地址添加在 hostlist.txt 文件中 -------------------------------"

#输出行数变换
echo "源文件行数：$oldcount 删除行数：$(($oldcount-$delcount)) 总行数：$allcount"
#刷新dns
echo "刷新dns"
sudo /etc/init.d/nscd restart
