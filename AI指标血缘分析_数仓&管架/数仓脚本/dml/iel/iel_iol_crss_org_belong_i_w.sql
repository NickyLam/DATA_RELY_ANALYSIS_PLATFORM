: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_org_belong_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_org_belong_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(belongorgid,chr(10),''),chr(13),'') as belongorgid
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_org_belong 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_org_belong_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes