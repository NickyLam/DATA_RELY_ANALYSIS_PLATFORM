: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_tb_tailbox_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_tailbox.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.eod_voucher_equal,chr(13),''),chr(10),'') as eod_voucher_equal
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.tailbox_id,chr(13),''),chr(10),'') as tailbox_id
,replace(replace(t1.tailbox_property,chr(13),''),chr(10),'') as tailbox_property
,replace(replace(t1.tailbox_status,chr(13),''),chr(10),'') as tailbox_status
,replace(replace(t1.tailbox_type,chr(13),''),chr(10),'') as tailbox_type
,t1.create_date as create_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.update_date as update_date
,replace(replace(t1.assign_user_id,chr(13),''),chr(10),'') as assign_user_id
,replace(replace(t1.last_user_id,chr(13),''),chr(10),'') as last_user_id
,replace(replace(t1.sod_cash_equal,chr(13),''),chr(10),'') as sod_cash_equal
,replace(replace(t1.sod_voucher_equal,chr(13),''),chr(10),'') as sod_voucher_equal
,replace(replace(t1.eod_cash_equal,chr(13),''),chr(10),'') as eod_cash_equal
,replace(replace(t1.teller_bind_type,chr(13),''),chr(10),'') as teller_bind_type
,replace(replace(t1.voucher_equal_timestamp,chr(13),''),chr(10),'') as voucher_equal_timestamp
,replace(replace(t1.cash_equal_timestamp,chr(13),''),chr(10),'') as cash_equal_timestamp
,replace(replace(t1.tailbox_sub_type,chr(13),''),chr(10),'') as tailbox_sub_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_tb_tailbox t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_tailbox.f.${batch_date}.dat" \
        charset=utf8
        safe=yes