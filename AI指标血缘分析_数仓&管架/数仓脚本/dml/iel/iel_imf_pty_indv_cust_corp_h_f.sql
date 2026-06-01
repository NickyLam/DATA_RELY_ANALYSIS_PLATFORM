: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_indv_cust_corp_h_f
CreateDate: 20250804
FileName:   ${iel_data_path}/pty_indv_cust_corp_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.cust_corp_rela_cd,chr(13),''),chr(10),'') as cust_corp_rela_cd
,replace(replace(t1.corp_cust_id,chr(13),''),chr(10),'') as corp_cust_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.corp_cert_type_cd,chr(13),''),chr(10),'') as corp_cert_type_cd
,replace(replace(t1.corp_cert_no,chr(13),''),chr(10),'') as corp_cert_no
,corp_cert_exp_dt
,replace(replace(t1.corp_mang_addr,chr(13),''),chr(10),'') as corp_mang_addr
,corp_found_dt
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,emply_number
,bus_anl_inco
,tot_asset
,replace(replace(t1.bl_induty_type_cd,chr(13),''),chr(10),'') as bl_induty_type_cd
,replace(replace(t1.bl_induty_name,chr(13),''),chr(10),'') as bl_induty_name
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,replace(replace(t1.create_org_id,chr(13),''),chr(10),'') as create_org_id
,init_create_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.update_chn_id,chr(13),''),chr(10),'') as update_chn_id
,replace(replace(t1.update_sys_name,chr(13),''),chr(10),'') as update_sys_name
,latest_update_dt
,replace(replace(t1.sorc_sys_name,chr(13),''),chr(10),'') as sorc_sys_name
,replace(replace(t1.sorc_sys_chn_id,chr(13),''),chr(10),'') as sorc_sys_chn_id
,sorc_sys_create_dt

from ${iml_schema}.pty_indv_cust_corp_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_indv_cust_corp_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
