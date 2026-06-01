: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a49tefrepsign_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a49tefrepsign_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
signdt
,signsq
,signtm
,iotype
,deptcd
,deptnm
,protocolno
,userno
,username
,contactusername
,contactuseraddr
,postcode
,contactusertel
,trantype
,openbrch
,payerbank
,openbrno
,payeracc
,payername
,payeridtype
,payerid
,payermobile
,payeremail
,payeename
,msgid
,ormsgid
,remark
,brchno
,userid
,ckbkus
,frsgdt
,frsgsq
,upsgdt
,upsgsq
,upbrch
,upurid
,upckus
,signst
,updttm
,prtnum
,retcd
,errmsg
from ${idl_schema}.odss_a49tefrepsign
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a49tefrepsign_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes