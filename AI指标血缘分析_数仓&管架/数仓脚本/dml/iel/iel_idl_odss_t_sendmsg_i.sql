: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_t_sendmsg_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_t_sendmsg_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serialno
,dateint
,msgtype
,dirflag
,srctype
,srcid
,srcsubid
,srcdate
,busitype
,busicode
,subport
,priority
,destype
,desid
,srcidflag
,objnon
,objno
,contenttype
,filetype
,commentno
,content
,spid
,parttotals
,partno
,senddeptid
,senduserid
,checkuserid
,approuserid
,sendserialno
,sendtime
,sendflag
,retid
,retidn
,begintime
,endtime
,retcode
,retmsg
,customerid
,feeflag
,fee1
,fee2
,serialno2
,dateint2
,retryflag
,flag1
,flag2
,remark
,title
from ${idl_schema}.odss_t_sendmsg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_t_sendmsg_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes