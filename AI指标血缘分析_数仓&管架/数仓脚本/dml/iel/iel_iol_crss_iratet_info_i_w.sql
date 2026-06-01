: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_iratet_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_iratet_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(interestno,chr(10),''),chr(13),'') as interestno
,replace(replace(efficientdate,chr(10),''),chr(13),'') as efficientdate
,replace(replace(price,chr(10),''),chr(13),'') as price
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_iratet_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_iratet_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes