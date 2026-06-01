: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_dep_main_acct_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_dep_main_acct_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.cust_id as cust_id
,t1.card_no as card_no
,t1.open_acct_chn_id as open_acct_chn_id
,t1.cust_acct_num as cust_acct_num
,t1.acct_prod_id as acct_prod_id
,t1.acct_sub_acct_num as acct_sub_acct_num
,t1.acct_curr_cd as acct_curr_cd
,t1.open_acct_org_id as open_acct_org_id
,t1.cust_acct_open_acct_dt as cust_acct_open_acct_dt
,t1.core_acct_type_cd as core_acct_type_cd
,t1.acct_name as acct_name
,t1.acct_status_cd as acct_status_cd
,t1.last_acct_status_cd as last_acct_status_cd
,t1.acct_status_modif_dt as acct_status_modif_dt
,t1.clos_acct_rs as clos_acct_rs
,t1.clos_acct_teller_id as clos_acct_teller_id
,t1.acct_lmt_flg as acct_lmt_flg
,t1.reg_acct_type_cd as reg_acct_type_cd
,t1.dep_vouch_cate_cd as dep_vouch_cate_cd
,t1.vouch_no as vouch_no
,t1.vouch_status_cd as vouch_status_cd
,t1.init_prod_id as init_prod_id
,t1.cust_mgr_id as cust_mgr_id
,t1.general_storage_flg as general_storage_flg
,t1.general_exch_flg as general_exch_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.acct_id as acct_id

from ${idl_schema}.oass_agt_dep_main_acct_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_dep_main_acct_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
