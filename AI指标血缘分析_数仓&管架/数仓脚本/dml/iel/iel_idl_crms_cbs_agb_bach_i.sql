: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_agb_bach_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_agb_bach_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
btdate
,bachno
,agentp
,btprcd
,brchno
,acctno
,rcrddt
,rcrdus
,tranam
,tranan
,comtam
,comtan
,trandt
,bachst
,remktx
,dcmttp
,dctpid
,csbxno
,smrycd
,crcycd
,csextg
,paystp
,filena
,dltrdt
,dltrsq
,filetp
,dcmtno
,smry01
,smry02
,smry03
,smry04
from ${idl_schema}.crms_cbs_agb_bach
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_agb_bach_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes