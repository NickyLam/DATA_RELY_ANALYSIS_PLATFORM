: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kns_tran_glob_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kns_tran_glob.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.globsq,chr(13),''),chr(10),'') as globsq
,replace(replace(t.trsqno,chr(13),''),chr(10),'') as trsqno
from ${iol_schema}.cbss_kns_tran_glob t
where trandt = '${batch_date}'
and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kns_tran_glob.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes