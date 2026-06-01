: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_salary_plat_payoff_corp_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pty_salary_plat_payoff_corp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.corp_abbr,chr(13),''),chr(10),'') as corp_abbr
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.local_prov,chr(13),''),chr(10),'') as local_prov
,replace(replace(t1.local_city,chr(13),''),chr(10),'') as local_city
,replace(replace(t1.local_rg,chr(13),''),chr(10),'') as local_rg
,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'') as dtl_addr
,replace(replace(t1.imp_cust_flg,chr(13),''),chr(10),'') as imp_cust_flg
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.bank_org_id,chr(13),''),chr(10),'') as bank_org_id
,replace(replace(t1.bank_mgmt_id,chr(13),''),chr(10),'') as bank_mgmt_id
,replace(replace(t1.bank_cust_mgr_id,chr(13),''),chr(10),'') as bank_cust_mgr_id
,replace(replace(t1.corp_hibchy,chr(13),''),chr(10),'') as corp_hibchy
,replace(replace(t1.super_corp_id,chr(13),''),chr(10),'') as super_corp_id
,replace(replace(t1.lp_name,chr(13),''),chr(10),'') as lp_name
,replace(replace(t1.lp_cert_type_cd,chr(13),''),chr(10),'') as lp_cert_type_cd
,replace(replace(t1.lp_cert_no,chr(13),''),chr(10),'') as lp_cert_no
,replace(replace(t1.chc_cert_type_cd,chr(13),''),chr(10),'') as chc_cert_type_cd
,cert_submit_dt
,replace(replace(t1.start_use_flg,chr(13),''),chr(10),'') as start_use_flg
,replace(replace(t1.cert_submit_emply_id,chr(13),''),chr(10),'') as cert_submit_emply_id
,fir_cert_sucs_dt
,replace(replace(t1.corp_cert_status_cd,chr(13),''),chr(10),'') as corp_cert_status_cd
,replace(replace(t1.cert_fail_rs,chr(13),''),chr(10),'') as cert_fail_rs
,replace(replace(t1.corp_dsmis_status_cd,chr(13),''),chr(10),'') as corp_dsmis_status_cd
,replace(replace(t1.corp_dsmis_flow_num,chr(13),''),chr(10),'') as corp_dsmis_flow_num
,replace(replace(t1.allow_emply_srch_reach_corp_flg,chr(13),''),chr(10),'') as allow_emply_srch_reach_corp_flg
,replace(replace(t1.allow_other_corp_rela_flg,chr(13),''),chr(10),'') as allow_other_corp_rela_flg
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,batch_create_dt
,batch_update_dt

from ${iml_schema}.pty_salary_plat_payoff_corp_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_salary_plat_payoff_corp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
