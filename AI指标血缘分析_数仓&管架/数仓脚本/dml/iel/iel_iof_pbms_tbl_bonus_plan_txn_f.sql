: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pbms_tbl_bonus_plan_txn_f
CreateDate: 20251014
FileName:   ${iel_data_path}/pbms_tbl_bonus_plan_txn.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_bonus_plan_txn
,replace(replace(t1.ssn,chr(13),''),chr(10),'') as ssn
,replace(replace(t1.ori_order_id,chr(13),''),chr(10),'') as ori_order_id
,replace(replace(t1.glob_seq,chr(13),''),chr(10),'') as glob_seq
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t1.txn_chn,chr(13),''),chr(10),'') as txn_chn
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t1.txn_time,chr(13),''),chr(10),'') as txn_time
,replace(replace(t1.posting_date,chr(13),''),chr(10),'') as posting_date
,replace(replace(t1.posting_time,chr(13),''),chr(10),'') as posting_time
,replace(replace(t1.txn_type,chr(13),''),chr(10),'') as txn_type
,replace(replace(t1.biz_typ,chr(13),''),chr(10),'') as biz_typ
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t1.memo_info,chr(13),''),chr(10),'') as memo_info
,replace(replace(t1.txn_code,chr(13),''),chr(10),'') as txn_code
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,replace(replace(t1.cnsn_arti_id,chr(13),''),chr(10),'') as cnsn_arti_id
,replace(replace(t1.usage_key,chr(13),''),chr(10),'') as usage_key
,replace(replace(t1.ext_coulmn3,chr(13),''),chr(10),'') as ext_coulmn3
,replace(replace(t1.ext_coulmn2,chr(13),''),chr(10),'') as ext_coulmn2
,replace(replace(t1.ext_coulmn1,chr(13),''),chr(10),'') as ext_coulmn1
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bonus_plan_type,chr(13),''),chr(10),'') as bonus_plan_type
,txn_bonus
,replace(replace(t1.bonus_cd_flag,chr(13),''),chr(10),'') as bonus_cd_flag
,replace(replace(t1.return_flag,chr(13),''),chr(10),'') as return_flag
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,del_flag
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,rema_useb_bonus

from ${iol_schema}.pbms_tbl_bonus_plan_txn t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_bonus_plan_txn.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
