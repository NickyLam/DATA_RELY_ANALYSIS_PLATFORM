: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_customer_personal_info_f
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_customer_personal_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.tran_net_member_code,chr(13),''),chr(10),'') as tran_net_member_code
,replace(replace(t1.cust_role,chr(13),''),chr(10),'') as cust_role
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.member_type,chr(13),''),chr(10),'') as member_type
,replace(replace(t1.member_name,chr(13),''),chr(10),'') as member_name
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.id_address,chr(13),''),chr(10),'') as id_address
,replace(replace(t1.work_corp_loc,chr(13),''),chr(10),'') as work_corp_loc
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.care_typ_cd,chr(13),''),chr(10),'') as care_typ_cd
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t1.id_no,chr(13),''),chr(10),'') as id_no
,replace(replace(t1.cert_start_dt,chr(13),''),chr(10),'') as cert_start_dt
,replace(replace(t1.cert_due_dt,chr(13),''),chr(10),'') as cert_due_dt
,replace(replace(t1.ocr_status,chr(13),''),chr(10),'') as ocr_status
,replace(replace(t1.content_type,chr(13),''),chr(10),'') as content_type
,replace(replace(t1.conent_id,chr(13),''),chr(10),'') as conent_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_timestamp
,update_timestamp

from ${iol_schema}.fzss_mod_fzs_customer_personal_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_customer_personal_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
