: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_finance_item_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_finance_item_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(itemno,chr(10),''),chr(13),'') as itemno
,replace(replace(itemname,chr(10),''),chr(13),'') as itemname
,replace(replace(itemattribute,chr(10),''),chr(13),'') as itemattribute
,replace(replace(itemdescribe,chr(10),''),chr(13),'') as itemdescribe
,replace(replace(deleteflag,chr(10),''),chr(13),'') as deleteflag
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_finance_item 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_finance_item_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes