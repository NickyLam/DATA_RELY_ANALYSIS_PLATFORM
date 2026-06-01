: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_business_sort_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_business_sort_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(typeno,chr(10),''),chr(13),'') as typeno
,replace(replace(isliquidity,chr(10),''),chr(13),'') as isliquidity
,replace(replace(isfixed,chr(10),''),chr(13),'') as isfixed
,replace(replace(isproject,chr(10),''),chr(13),'') as isproject
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updateuserid,chr(10),''),chr(13),'') as updateuserid
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_business_sort 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_business_sort_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes