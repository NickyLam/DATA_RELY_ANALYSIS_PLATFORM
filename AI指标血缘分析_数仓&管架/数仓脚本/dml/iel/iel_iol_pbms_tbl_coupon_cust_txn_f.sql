: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbms_tbl_coupon_cust_txn_f
CreateDate: 20260408
FileName:   ${iel_data_path}/pbms_tbl_coupon_cust_txn.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_coupon_used
,replace(replace(t1.coupon_id,chr(13),''),chr(10),'') as coupon_id
,replace(replace(t1.deal_type,chr(13),''),chr(10),'') as deal_type
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,deal_num
,replace(replace(t1.overdue_date,chr(13),''),chr(10),'') as overdue_date
,replace(replace(t1.used_time,chr(13),''),chr(10),'') as used_time
,replace(replace(t1.exchange_code,chr(13),''),chr(10),'') as exchange_code
,replace(replace(t1.channel_no,chr(13),''),chr(10),'') as channel_no
,replace(replace(t1.check_id,chr(13),''),chr(10),'') as check_id
,replace(replace(t1.txn_code,chr(13),''),chr(10),'') as txn_code
,replace(replace(t1.deal_explain,chr(13),''),chr(10),'') as deal_explain
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.roll_int_cust_id,chr(13),''),chr(10),'') as roll_int_cust_id
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t1.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,del_flag
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.deal_dir,chr(13),''),chr(10),'') as deal_dir
,replace(replace(t1.draw_src,chr(13),''),chr(10),'') as draw_src
,replace(replace(t1.glob_seq,chr(13),''),chr(10),'') as glob_seq
,replace(replace(t1.coop_order_seq,chr(13),''),chr(10),'') as coop_order_seq

from ${iol_schema}.pbms_tbl_coupon_cust_txn t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_coupon_cust_txn.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
