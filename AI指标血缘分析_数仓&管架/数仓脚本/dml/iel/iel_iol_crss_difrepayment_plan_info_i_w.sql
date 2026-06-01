: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_difrepayment_plan_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_difrepayment_plan_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(duebillserialno,chr(10),''),chr(13),'') as duebillserialno
,replace(replace(startdate,chr(10),''),chr(13),'') as startdate
,replace(replace(executiondate,chr(10),''),chr(13),'') as executiondate
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(normalsum,chr(10),''),chr(13),'') as normalsum
,replace(replace(periodsum,chr(10),''),chr(13),'') as periodsum
,replace(replace(periodinterestsum,chr(10),''),chr(13),'') as periodinterestsum
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_difrepayment_plan_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_difrepayment_plan_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes