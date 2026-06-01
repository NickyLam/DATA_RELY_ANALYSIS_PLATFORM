: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_cms_device_info_f
CreateDate: 20250506
FileName:   ${iel_data_path}/amss_cms_device_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.sn_id,chr(13),''),chr(10),'') as sn_id
,replace(replace(t1.sn_name,chr(13),''),chr(10),'') as sn_name
,replace(replace(t1.vn_info,chr(13),''),chr(10),'') as vn_info
,replace(replace(t1.vn_name,chr(13),''),chr(10),'') as vn_name
,replace(replace(t1.device_type,chr(13),''),chr(10),'') as device_type
,replace(replace(t1.device_type_name,chr(13),''),chr(10),'') as device_type_name
,replace(replace(t1.device_model,chr(13),''),chr(10),'') as device_model
,replace(replace(t1.device_busi_type,chr(13),''),chr(10),'') as device_busi_type
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,replace(replace(t1.channel_nm,chr(13),''),chr(10),'') as channel_nm
,replace(replace(t1.pay_accept_org_id,chr(13),''),chr(10),'') as pay_accept_org_id
,replace(replace(t1.sn_bind_opr_id,chr(13),''),chr(10),'') as sn_bind_opr_id
,sn_bind_time
,replace(replace(t1.sn_unbind_opr_id,chr(13),''),chr(10),'') as sn_unbind_opr_id
,sn_unbind_time
,init_type
,replace(replace(t1.init_batch_no,chr(13),''),chr(10),'') as init_batch_no
,sn_bind_status
,replace(replace(t1.term_no,chr(13),''),chr(10),'') as term_no
,replace(replace(t1.mch_id,chr(13),''),chr(10),'') as mch_id
,replace(replace(t1.mch_name,chr(13),''),chr(10),'') as mch_name
,replace(replace(t1.term_status,chr(13),''),chr(10),'') as term_status
,audit_status
,replace(replace(t1.create_user_id,chr(13),''),chr(10),'') as create_user_id
,create_time
,update_time
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.county,chr(13),''),chr(10),'') as county
,replace(replace(t1.term_addr,chr(13),''),chr(10),'') as term_addr
,replace(replace(t1.term_redius,chr(13),''),chr(10),'') as term_redius
,longitude
,latitude
,is_address_bind
,replace(replace(t1.term_busi_info,chr(13),''),chr(10),'') as term_busi_info
,term_init_time
,pos_sign_status
,pos_signin_time
,pos_signout_time
,pos_batch_no
,pos_batch_time
,replace(replace(t1.tmk,chr(13),''),chr(10),'') as tmk
,replace(replace(t1.tmk_cv,chr(13),''),chr(10),'') as tmk_cv
,replace(replace(t1.tpk_lmk,chr(13),''),chr(10),'') as tpk_lmk
,replace(replace(t1.tpk_zmk,chr(13),''),chr(10),'') as tpk_zmk
,replace(replace(t1.tpk_kcv,chr(13),''),chr(10),'') as tpk_kcv
,replace(replace(t1.trk_lmk,chr(13),''),chr(10),'') as trk_lmk
,replace(replace(t1.trk_zmk,chr(13),''),chr(10),'') as trk_zmk
,replace(replace(t1.trk_kcv,chr(13),''),chr(10),'') as trk_kcv
,replace(replace(t1.tak_lmk,chr(13),''),chr(10),'') as tak_lmk
,replace(replace(t1.tak_zmk,chr(13),''),chr(10),'') as tak_zmk
,replace(replace(t1.tak_kcv,chr(13),''),chr(10),'') as tak_kcv
,replace(replace(t1.old_tak_lmk,chr(13),''),chr(10),'') as old_tak_lmk
,replace(replace(t1.old_tak_zmk,chr(13),''),chr(10),'') as old_tak_zmk
,replace(replace(t1.old_tak_kcv,chr(13),''),chr(10),'') as old_tak_kcv
,replace(replace(t1.sign_type,chr(13),''),chr(10),'') as sign_type
,replace(replace(t1.device_pub_key,chr(13),''),chr(10),'') as device_pub_key
,replace(replace(t1.sn_sign_key,chr(13),''),chr(10),'') as sn_sign_key
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.merchant_qr_url,chr(13),''),chr(10),'') as merchant_qr_url
,replace(replace(t1.notify_url,chr(13),''),chr(10),'') as notify_url
,is_support_nfc
,replace(replace(t1.cert_id,chr(13),''),chr(10),'') as cert_id
,bind_type
,replace(replace(t1.mch_short_name,chr(13),''),chr(10),'') as mch_short_name
,replace(replace(t1.active_code,chr(13),''),chr(10),'') as active_code
,replace(replace(t1.third_client_id,chr(13),''),chr(10),'') as third_client_id
,replace(replace(t1.partner,chr(13),''),chr(10),'') as partner
,replace(replace(t1.mch_terminal_id,chr(13),''),chr(10),'') as mch_terminal_id
,origin
,replace(replace(t1.union_device_info,chr(13),''),chr(10),'') as union_device_info
,replace(replace(t1.thi_device_info,chr(13),''),chr(10),'') as thi_device_info
,physics_flag
,replace(replace(t1.tusn,chr(13),''),chr(10),'') as tusn

from ${iol_schema}.amss_cms_device_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cms_device_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
