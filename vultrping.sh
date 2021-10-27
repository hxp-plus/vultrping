# Inspired by https://www.jianshu.com/p/513803527d91
ips=(ga-us-ping.vultr.com il-us-ping.vultr.com tx-us-ping.vultr.com lax-ca-us-ping.vultr.com mex-mx-ping.vultr.com fl-us-ping.vultr.com nj-us-ping.vultr.com wa-us-ping.vultr.com sjo-ca-us-ping.vultr.com tor-ca-ping.vultr.com ams-nl-ping.vultr.com fra-de-ping.vultr.com lon-gb-ping.vultr.com par-fr-ping.vultr.com sto-se-ping.vultr.com sel-kor-ping.vultr.com sgp-ping.vultr.com hnd-jp-ping.vultr.com syd-au-ping.vultr.com)

times=$1
if [ "$times" -gt 0 ] 2>/dev/null; then
    echo "执行 ${times} 次ping"
else
    echo "请在脚本后输入需要ping的次数，大于0"
    exit 0
fi

DoPing(){
    res=$( ping -c $times $1 | grep "min/avg/max/stddev" -B 2 )
    echo $res >> ./result.log
}

for ip in ${ips[*]}
do
    DoPing $ip &
done
echo "命令执行完毕，等待结果.."

num=0
for pid in $(jobs -p)
do
    wait $pid
    let "num=num+1"
    if [ $num == 19 ]
    then
        printf "\n    %-36s %4s %28s\n" "address" "loss" "min/avg/max/stddev"
        cat ./result.log | awk '{printf "%-30s %10s %40s\n",$2,$12,$18}' | sort -n -k 3 | nl -w3 -s ' '
        rm ./result.log
    fi
done
