: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_crdt_lmt_info_f
CreateDate: 20250102
FileName:   ${iel_data_path}/cmm_retl_loan_crdt_lmt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.lmt_appl_flow_num,chr(13),''),chr(10),'') as lmt_appl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.actv_flg,chr(13),''),chr(10),'') as actv_flg
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.bus_breed_name,chr(13),''),chr(10),'') as bus_breed_name
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,begin_dt
,exp_dt
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,crdt_lmt
,occu_crdt_lmt
,surp_crdt_lmt
,crdt_open_amt
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.lmt_cont_cn_name,chr(13),''),chr(10),'') as lmt_cont_cn_name
,lower_ocup_up_level_crdt_open_amt
,lower_ocup_up_level_crdt_nmal_amt
,replace(replace(t1.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
,replace(replace(t1.borw_usage_type_cd,chr(13),''),chr(10),'') as borw_usage_type_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,termnt_dt

from ${icl_schema}.cmm_retl_loan_crdt_lmt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_crdt_lmt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
