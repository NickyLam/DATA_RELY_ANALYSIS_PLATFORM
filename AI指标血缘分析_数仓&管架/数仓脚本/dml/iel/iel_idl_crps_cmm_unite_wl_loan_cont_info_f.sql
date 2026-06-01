: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_cmm_unite_wl_loan_cont_info_f
CreateDate: 20231113
FileName:   ${iel_data_path}/crps_cmm_unite_wl_loan_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
etl_dt
,lp_id
,cont_id
,crdt_appl_flow_num
,cust_id
,cust_name
,std_prod_id
,crdt_type_cd
,appl_type_cd
,curr_cd
,base_rat_type_cd
,int_rat_adj_way_cd
,cont_status_cd
,apv_status_cd
,guar_way_cd
,repay_way_cd
,loan_usage_type_cd
,recvbl_acct_name
,recvbl_acct_open_org_id
,exec_int_rat
,cont_bal
,cont_amt
,distr_amt
,tenor
,begin_dt
,exp_dt
,sign_dt
,distr_dt
,termnt_dt
,spec_repay_day
,operr_id
,oper_org_id
,oper_dt
,rgstrat_id
,rgst_org_id
,rgst_dt
,update_id
,update_org_id
,update_dt

from ${idl_schema}.crps_cmm_unite_wl_loan_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_loan_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
