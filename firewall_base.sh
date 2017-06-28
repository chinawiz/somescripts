#!/bin/bash

iptables -F
iptables -X
iptables -P INPUT DROP
#打开这条，sstap测试udp转发会失败
#iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#iptables的基本设置，允许ping和已经建立的连接的通讯
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp 8 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#基本服务 允许ssh和出去的dns查询和http访问，主要是给系统升级这类使用
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22222 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp -m state --state NEW --dport 80 -j ACCEPT
#连接远程shadowsocks的数据库，提交用户数据
iptables -A OUTPUT -p tcp -d 1.2.3.4 --dport 3306 -j ACCEPT
#貌似不加这条，sstap启动连接会提示失败！！！
iptables -A INPUT -p udp --dport 53 -j ACCEPT

#shadowsocks服务
iptables -A INPUT -p tcp --dport 20000:21000 -j ACCEPT
iptables -A INPUT -p udp --dport 20000:21000 -j ACCEPT

#iptables -t nat -m owner --uid-owner shadowsocks -A OUTPUT -p udp --dport 53 -j REDIRECT --to-port 5353
#劫持shadowsocks中的dns请求到本地dnsmasq，根据gfwlist.conf屏蔽相关域名
iptables -t nat -A OUTPUT -m owner --uid-owner shadowsocks -p udp --dport 53 -j DNAT --to 127.0.0.1
