#!/bin/bash
#
# Copyright © 2019 ExinPool <robin@exin.one>
#
# Distributed under terms of the MIT license.
#
# Desc: Akash process monitor script.
# User: Robin@ExinPool
# Date: 2022-05-02
# Time: 10:56:03

# load the config library functions
source config.shlib

# load configuration
service="$(config_get SERVICE)"
process="$(config_get PROCESS)"
process_num="$(config_get PROCESS_NUM)"
process_num_var=`sudo netstat -langput | grep LISTEN | grep $process | wc -l`
log_file="$(config_get LOG_FILE)"
lark_webhook_url="$(config_get LARK_WEBHOOK_URL)"

if [ ${process_num} -eq ${process_num_var} ]
then
    log="`date '+%Y-%m-%d %H:%M:%S'` UTC `hostname` `whoami` INFO ${service} node process is normal."
    echo $log >> $log_file
else
    log="时间: `date '+%Y-%m-%d %H:%M:%S'` UTC \n节点: `hostname` \n状态: 进程不存在，请立即检查。"
    echo -e $log >> $log_file
    curl -X POST -H "Content-Type: application/json" -d '{"msg_type":"text","content":{"text":"'"$log"'"}}' ${lark_webhook_url}
fi