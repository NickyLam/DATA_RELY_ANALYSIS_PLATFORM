: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ncrs_cmm_retl_loan_crdt_lmt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncrs_cmm_retl_loan_crdt_lmt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,lmt_cont_id
,lmt_appl_flow_num
,cust_id
,tax_num
,bus_breed_id
,actv_flg
,circl_flg
,low_risk_bus_flg
,cust_type_cd
,prod_type_cd
,tenor_type_cd
,curr_cd
,main_guar_way_cd
,sub_guar_way_cd
,status_cd
,bus_breed_name
,tenor
,begin_dt
,exp_dt
,belong_org_id
,belong_brch_id
,acct_instit_id
,mgmt_org_id
,crdt_lmt
,occu_crdt_lmt
,surp_crdt_lmt
,crdt_open_amt
from ${idl_schema}.ncrs_cmm_retl_loan_crdt_lmt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncrs_cmm_retl_loan_crdt_lmt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes