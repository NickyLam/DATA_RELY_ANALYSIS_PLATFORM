: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tsafebox_swi_dtl_i
CreateDate: 20240330
FileName:   ${iel_data_path}/evt_tsafebox_swi_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.doc_name,chr(13),''),chr(10),'') as doc_name
,replace(replace(t1.insure_id,chr(13),''),chr(10),'') as insure_id
,rgst_dt
,oper_dt
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.open_box_way_cd,chr(13),''),chr(10),'') as open_box_way_cd
,open_box_dt
,replace(replace(t1.unpacker_pub_priv_idf_cd,chr(13),''),chr(10),'') as unpacker_pub_priv_idf_cd
,replace(replace(t1.unpacker_name,chr(13),''),chr(10),'') as unpacker_name
,replace(replace(t1.unpacker_id_card_proof,chr(13),''),chr(10),'') as unpacker_id_card_proof
,replace(replace(t1.unpacker_cert_no,chr(13),''),chr(10),'') as unpacker_cert_no
,unpacker_cert_valid_dt
,replace(replace(t1.unpacker_idti_type_cd,chr(13),''),chr(10),'') as unpacker_idti_type_cd
,replace(replace(t1.brac_org_id,chr(13),''),chr(10),'') as brac_org_id
,replace(replace(t1.actl_user_pub_priv_idf_cd,chr(13),''),chr(10),'') as actl_user_pub_priv_idf_cd
,replace(replace(t1.actl_user_name,chr(13),''),chr(10),'') as actl_user_name
,replace(replace(t1.actl_user_id_card_proof,chr(13),''),chr(10),'') as actl_user_id_card_proof
,replace(replace(t1.actl_user_cert_id,chr(13),''),chr(10),'') as actl_user_cert_id
,actl_user_cert_valid_dt
,replace(replace(t1.actl_use_cust_id,chr(13),''),chr(10),'') as actl_use_cust_id

from ${iml_schema}.evt_tsafebox_swi_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tsafebox_swi_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
