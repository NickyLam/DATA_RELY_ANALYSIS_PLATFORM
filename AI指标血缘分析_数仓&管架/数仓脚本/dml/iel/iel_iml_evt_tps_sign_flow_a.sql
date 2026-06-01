: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tps_sign_flow_a
CreateDate: 20250207
FileName:   ${iel_data_path}/evt_tps_sign_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.broker_secu_cap_acct_id,chr(13),''),chr(10),'') as broker_secu_cap_acct_id
,replace(replace(t1.broker_cd,chr(13),''),chr(10),'') as broker_cd
,replace(replace(t1.broker_name,chr(13),''),chr(10),'') as broker_name
,replace(replace(t1.tps_bank_cd,chr(13),''),chr(10),'') as tps_bank_cd
,replace(replace(t1.tps_sign_src_cd,chr(13),''),chr(10),'') as tps_sign_src_cd
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,sign_dt
,replace(replace(t1.sign_attach_info,chr(13),''),chr(10),'') as sign_attach_info
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_cert_type_cd,chr(13),''),chr(10),'') as cust_cert_type_cd
,replace(replace(t1.cust_cert_no,chr(13),''),chr(10),'') as cust_cert_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.operr_cert_type_cd,chr(13),''),chr(10),'') as operr_cert_type_cd
,replace(replace(t1.operr_cert_no,chr(13),''),chr(10),'') as operr_cert_no
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.this_sign_flg,chr(13),''),chr(10),'') as this_sign_flg
,this_sign_dt
,replace(replace(t1.this_sign_flow_num,chr(13),''),chr(10),'') as this_sign_flow_num
,replace(replace(t1.this_sign_agt_edit_num,chr(13),''),chr(10),'') as this_sign_agt_edit_num
,replace(replace(t1.this_sign_agt_src_cd,chr(13),''),chr(10),'') as this_sign_agt_src_cd
,replace(replace(t1.this_sign_ip,chr(13),''),chr(10),'') as this_sign_ip
,replace(replace(t1.this_sign_mac_addr,chr(13),''),chr(10),'') as this_sign_mac_addr
,replace(replace(t1.this_sign_equip_model,chr(13),''),chr(10),'') as this_sign_equip_model
,replace(replace(t1.argue_way_cd,chr(13),''),chr(10),'') as argue_way_cd

from ${iml_schema}.evt_tps_sign_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tps_sign_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
