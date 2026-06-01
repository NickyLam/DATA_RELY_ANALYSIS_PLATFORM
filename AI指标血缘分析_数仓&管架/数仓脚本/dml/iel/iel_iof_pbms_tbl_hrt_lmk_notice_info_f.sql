: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pbms_tbl_hrt_lmk_notice_info_f
CreateDate: 20251113
FileName:   ${iel_data_path}/pbms_tbl_hrt_lmk_notice_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_hrt_lmk_vip_notice
,replace(replace(t1.operate_type,chr(13),''),chr(10),'') as operate_type
,replace(replace(t1.merch_code,chr(13),''),chr(10),'') as merch_code
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t1.shop_id,chr(13),''),chr(10),'') as shop_id
,replace(replace(t1.refer_no,chr(13),''),chr(10),'') as refer_no
,replace(replace(t1.uuid,chr(13),''),chr(10),'') as uuid
,replace(replace(t1.member_name,chr(13),''),chr(10),'') as member_name
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.national,chr(13),''),chr(10),'') as national
,replace(replace(t1.certi_type,chr(13),''),chr(10),'') as certi_type
,replace(replace(t1.certi_no,chr(13),''),chr(10),'') as certi_no
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.vip_card_no,chr(13),''),chr(10),'') as vip_card_no
,replace(replace(t1.bank_card_no,chr(13),''),chr(10),'') as bank_card_no
,replace(replace(t1.lmk_card_no,chr(13),''),chr(10),'') as lmk_card_no
,replace(replace(t1.organization,chr(13),''),chr(10),'') as organization
,replace(replace(t1.card_level,chr(13),''),chr(10),'') as card_level
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,del_flag
,replace(replace(t1.register_time,chr(13),''),chr(10),'') as register_time
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.task_date,chr(13),''),chr(10),'') as task_date
,replace(replace(t1.bank_card_no_new,chr(13),''),chr(10),'') as bank_card_no_new
,replace(replace(t1.lmk_card_no_new,chr(13),''),chr(10),'') as lmk_card_no_new
,replace(replace(t1.notice_flag,chr(13),''),chr(10),'') as notice_flag
,replace(replace(t1.acti_no,chr(13),''),chr(10),'') as acti_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.biz_time,chr(13),''),chr(10),'') as biz_time

from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_hrt_lmk_notice_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
