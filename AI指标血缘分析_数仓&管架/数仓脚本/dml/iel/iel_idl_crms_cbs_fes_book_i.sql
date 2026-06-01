: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cbs_fes_book_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cbs_fes_book_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
feesdt
,feessq
,brchno
,userid
,crcycd
,trantp
,custno
,acctno
,recdtp
,trannm
,trandt
,transq
,remark
,stauts
,strktg
from ${idl_schema}.crms_cbs_fes_book
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cbs_fes_book_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes