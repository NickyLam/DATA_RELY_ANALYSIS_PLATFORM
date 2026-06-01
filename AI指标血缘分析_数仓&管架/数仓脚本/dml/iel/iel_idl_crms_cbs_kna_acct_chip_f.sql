: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_kna_acct_chip_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_kna_acct_chip_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acctno
,custna
,idtftp
,idtfno
,efctdt
,inefdt
,mxblam
,mxlimt
,attrpt
,attram
,saveam
,drawam
,lstoff
,ofline
,openbr
,opensq
,onlnbl
,lstrdt
,lstrsq
,closdt
,clossq
,acctst
,cardsq
from ${idl_schema}.crms_cbs_kna_acct_chip
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_kna_acct_chip_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes