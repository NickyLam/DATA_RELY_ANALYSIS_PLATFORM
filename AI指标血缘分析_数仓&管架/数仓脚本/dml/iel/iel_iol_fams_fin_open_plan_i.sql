: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_open_plan_i
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_fin_open_plan.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cash_id,chr(13),''),chr(10),'') as cash_id
,replace(replace(t1.open_type,chr(13),''),chr(10),'') as open_type
,open_date_str_un
,open_date_end_un
,open_vdate_un
,open_mdate_un
,open_date_str
,open_date_end
,open_vdate
,open_mdate
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,branch
,replace(replace(t1.open_status,chr(13),''),chr(10),'') as open_status
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,open_ndate
,start_dt
,end_dt

from ${iol_schema}.fams_fin_open_plan t1
where start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_open_plan.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
