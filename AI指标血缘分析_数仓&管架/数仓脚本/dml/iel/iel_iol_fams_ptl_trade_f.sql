: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ptl_trade_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_ptl_trade.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.busi_no,chr(13),''),chr(10),'') as busi_no
,replace(replace(t1.busi_table,chr(13),''),chr(10),'') as busi_table
,replace(replace(t1.busi_id,chr(13),''),chr(10),'') as busi_id
,replace(replace(t1.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t1.inv_aim,chr(13),''),chr(10),'') as inv_aim
,replace(replace(t1.sec_manage_acct_id,chr(13),''),chr(10),'') as sec_manage_acct_id
,settle_date
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_ptl_trade t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ptl_trade.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
