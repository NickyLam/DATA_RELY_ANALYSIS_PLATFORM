: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_loan_cont_info_f
CreateDate: 20231008
FileName:   ${iel_data_path}/cmm_unite_wl_loan_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.crdt_type_cd,chr(13),''),chr(10),'') as crdt_type_cd
,replace(replace(t1.appl_type_cd,chr(13),''),chr(10),'') as appl_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.loan_usage_type_cd,chr(13),''),chr(10),'') as loan_usage_type_cd
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_open_org_id,chr(13),''),chr(10),'') as recvbl_acct_open_org_id
,exec_int_rat
,cont_bal
,cont_amt
,distr_amt
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,begin_dt
,exp_dt
,sign_dt
,distr_dt
,termnt_dt
,spec_repay_day
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,oper_dt
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_id,chr(13),''),chr(10),'') as update_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,update_dt

from ${icl_schema}.cmm_unite_wl_loan_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_loan_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
