: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_adjust_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_adjust_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(type,chr(10),''),chr(13),'') as type
,replace(replace(relativeserialno,chr(10),''),chr(13),'') as relativeserialno
,replace(replace(reason,chr(10),''),chr(13),'') as reason
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(adjustlevel,chr(10),''),chr(13),'') as adjustlevel
,replace(replace(coverage,chr(10),''),chr(13),'') as coverage
,replace(replace(adjusttype,chr(10),''),chr(13),'') as adjusttype
,replace(replace(signname,chr(10),''),chr(13),'') as signname
,replace(replace(signid,chr(10),''),chr(13),'') as signid
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.crss_adjust_info where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_adjust_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes