: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mpcs_a50ubcardbin_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mpcs_a50ubcardbin.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pinblock,chr(13),''),chr(10),'') as pinblock
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.cardlen,chr(13),''),chr(10),'') as cardlen
,replace(replace(t1.binlen,chr(13),''),chr(10),'') as binlen
,replace(replace(t1.bintype,chr(13),''),chr(10),'') as bintype
,replace(replace(t1.updtime,chr(13),''),chr(10),'') as updtime
,'' as data_date
from ${iol_schema}.mpcs_a50ubcardbin t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mpcs_a50ubcardbin.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes