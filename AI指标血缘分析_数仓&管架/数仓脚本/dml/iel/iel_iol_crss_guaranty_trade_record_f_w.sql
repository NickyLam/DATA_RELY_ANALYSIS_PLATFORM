: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_guaranty_trade_record_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_guaranty_trade_record_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(guarantyid,chr(10),''),chr(13),'') as guarantyid
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(finishdate,chr(10),''),chr(13),'') as finishdate
,replace(replace(coretradeserialno,chr(10),''),chr(13),'') as coretradeserialno
,replace(replace(coretradedate,chr(10),''),chr(13),'') as coretradedate
,etl_dt
,etl_timestamp
from iol.crss_guaranty_trade_record 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');  " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_guaranty_trade_record_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes