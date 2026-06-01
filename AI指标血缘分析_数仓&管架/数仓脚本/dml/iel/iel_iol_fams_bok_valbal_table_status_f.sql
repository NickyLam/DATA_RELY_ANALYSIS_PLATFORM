: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_valbal_table_status_f
CreateDate: 20240621
FileName:   ${iel_data_path}/fams_bok_valbal_table_status.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_name,chr(13),''),chr(10),'') as finprod_name
,val_date
,replace(replace(t1.val_bal_flag,chr(13),''),chr(10),'') as val_bal_flag
,capital
,asset_value
,total_net_value
,seven_day_rate
,pay_profit
,replace(replace(t1.file_id,chr(13),''),chr(10),'') as file_id
,net_unit_value
,replace(replace(t1.check_status,chr(13),''),chr(10),'') as check_status
,replace(replace(t1.check_result,chr(13),''),chr(10),'') as check_result
,replace(replace(t1.confirm_status,chr(13),''),chr(10),'') as confirm_status
,replace(replace(t1.notice_status,chr(13),''),chr(10),'') as notice_status
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,tdy_yield
,replace(replace(t1.redeem_notice_status,chr(13),''),chr(10),'') as redeem_notice_status

from ${iol_schema}.fams_bok_valbal_table_status t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_valbal_table_status.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
