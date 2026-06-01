: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_hqd_pre_loan_appl_info_f
CreateDate: 20251106
FileName:   ${iel_data_path}/agt_hqd_pre_loan_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr
,replace(replace(t1.access_chn_id,chr(13),''),chr(10),'') as access_chn_id
,apv_lmt
,apv_appl_dt
,apv_end_dt
,replace(replace(t1.task_status_cd,chr(13),''),chr(10),'') as task_status_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.warn_info,chr(13),''),chr(10),'') as warn_info
,replace(replace(t1.refuse_rs_descb,chr(13),''),chr(10),'') as refuse_rs_descb
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.belong_brch_org_id,chr(13),''),chr(10),'') as belong_brch_org_id
,replace(replace(t1.lp_cust_id,chr(13),''),chr(10),'') as lp_cust_id
,issue_dt
,brwer_cert_exp_dt
,replace(replace(t1.resd_local_prov,chr(13),''),chr(10),'') as resd_local_prov
,replace(replace(t1.resd_city,chr(13),''),chr(10),'') as resd_city
,replace(replace(t1.resd_local_rg,chr(13),''),chr(10),'') as resd_local_rg
,replace(replace(t1.resd_dtl_addr,chr(13),''),chr(10),'') as resd_dtl_addr
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.unify_soci_crdt_cd,chr(13),''),chr(10),'') as unify_soci_crdt_cd
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t1.tax_type_cd,chr(13),''),chr(10),'') as tax_type_cd
,replace(replace(t1.tax_que_auth_flow_num,chr(13),''),chr(10),'') as tax_que_auth_flow_num
,replace(replace(t1.que_appl_type_cd,chr(13),''),chr(10),'') as que_appl_type_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.auth_flg,chr(13),''),chr(10),'') as auth_flg
,replace(replace(t1.auth_way_cd,chr(13),''),chr(10),'') as auth_way_cd
,replace(replace(t1.biome_trics,chr(13),''),chr(10),'') as biome_trics
,auth_dt
,auth_effect_dt
,auth_invalid_dt
,corp_rgst_dt
,replace(replace(t1.mang_range,chr(13),''),chr(10),'') as mang_range
,bus_lics_vp
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
,replace(replace(t1.sm_corp_flg,chr(13),''),chr(10),'') as sm_corp_flg
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,asset_sum
,mang_inco
,pre_scd_year_sell_inco
,other_chn_provi_oper_cap
,mon_rent_lmt
,corp_in_mons
,replace(replace(t1.score_val,chr(13),''),chr(10),'') as score_val
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd
,replace(replace(t1.crdtc_rest_cd,chr(13),''),chr(10),'') as crdtc_rest_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.advise_flg,chr(13),''),chr(10),'') as advise_flg

from ${iml_schema}.agt_hqd_pre_loan_appl_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_hqd_pre_loan_appl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
