#!/bin/bash
#科雷服务器
host1="login.kleientertainment.com"
host2="d26ly0au0tyuy.cloudfront.net"
host3="d21wmy1ql1e52r.cloudfront.net"
#获取ip传入变量（变量不够自己添加）
ip1=`ping $host1 -c1 | grep from | cut -d '(' -f2 | cut -d ')' -f1`
ip2=`ping $host2 -c1 | grep from | cut -d '(' -f2 | cut -d ')' -f1`
ip3=`ping $host3 -c1 | grep from | cut -d '(' -f2 | cut -d ')' -f1`
#赋予权限
sudo chmod 777 /etc/hosts
#获取源文件行数
oldcount=$(wc -l /etc/hosts| awk '{print $1}')
#删除hosts文件内科雷IP解析
sed  "/$host1/d" -i  /etc/hosts
sed  "/$host2/d" -i  /etc/hosts
sed  "/$host3/d" -i  /etc/hosts
delcount=$(wc -l /etc/hosts| awk '{print $1}')
#写入新的ip解析
echo "$ip1 $host1" >> /etc/hosts
echo "$ip2 $host2" >> /etc/hosts
echo "$ip3 $host3" >> /etc/hosts
#计算行数
allcount=$(wc -l /etc/hosts| awk '{print $1}')
#输出行数变换
echo "源文件行数：$oldcount 删除行数：$(($oldcount-$delcount)) 总行数：$allcount"
#查看hosts文件
sudo echo "-------------------------------------------执行开始-------------------------------------------" >> ./dns.log
echo /etc/hosts
#创建log文件
sudo touch dns.log
sudo chmod 777 dns.log
#hosts文件输入到定时log（log文件目录，按照自己的更换）
sudo cat /etc/hosts >> ./dns.log
sudo echo "定时执行结束" >> ./dns.log
#刷新DNS
sudo /etc/init.d/nscd restart
sudo echo "刷新DNS" >> ./dns.log
sudo echo "-------------------------------------------执行结束-------------------------------------------" >> ./dns.log
#输出结果
sudo tail -17 dns.log