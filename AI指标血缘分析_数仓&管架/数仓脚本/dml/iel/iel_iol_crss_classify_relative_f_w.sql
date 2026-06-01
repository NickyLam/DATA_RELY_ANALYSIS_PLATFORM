: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_classify_relative_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_classify_relative_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(balance,chr(10),''),chr(13),'') as balance
,replace(replace(interestbalance,chr(10),''),chr(13),'') as interestbalance
,replace(replace(relativedate,chr(10),''),chr(13),'') as relativedate
,replace(replace(channel,chr(10),''),chr(13),'') as channel
,replace(replace(status,chr(10),''),chr(13),'') as status
,etl_dt
,etl_timestamp
from iol.crss_classify_relative 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd'); " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_classify_relative_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes