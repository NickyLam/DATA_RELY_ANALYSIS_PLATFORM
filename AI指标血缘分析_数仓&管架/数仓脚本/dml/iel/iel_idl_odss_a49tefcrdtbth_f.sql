: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a49tefcrdtbth_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a49tefcrdtbth_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
bachdt
,bachsq
,entrustdate
,msgid
,iotype
,cntrno
,filena
,rspfile
,bachtp
,totlan
,totlam
,succnt
,sucamt
,failct
,failam
,acctno
,acctna
,colldate
,hostdt
,hostsq
,userid
,brchno
,ckbrus
,ckbrno
,txnid
,txndate
,txnround
,status
,msgcode
,msgtext
,obthdt
,obthsq
,tolfile
,sendct
,recvct
,hzflag
from ${idl_schema}.odss_a49tefcrdtbth
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a49tefcrdtbth_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes