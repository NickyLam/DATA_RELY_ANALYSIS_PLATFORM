: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_account_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_account_log_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,traceno
,subno
,txdate
,txnto
,txno
,branch_no
,operator_id
,trmid
,bsseq
,trmtype
,svcnm
,hcode
,seqno
,origtxno
,isagnstat
,sndstat
,sndcnt
,errcd
,errrsn
,biz_type
,detail_id
,act_dtl_id
,draft_id
,contract_id
,prodprop
,misc
,auth_id
,account_mode
,last_upd_oper_id
,last_upd_time
,data_id
,orda_id
from ${idl_schema}.odss_account_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_account_log_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes