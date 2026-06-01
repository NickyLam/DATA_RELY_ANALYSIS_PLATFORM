: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_wl_appl_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_wl_appl_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,appl_id
,lp_id
,init_appl_id
,cust_id
,open_acct_bank_name
,bank_card_num
,cust_name
,open_acct_bind_mobile_no
,co_org_id
,prod_id
,prod_cls_id
,appl_chn_id
,crdt_appl_id
,repay_num
,curr_cd
,appl_lmt
,appl_int_rat
,appl_tm
,appl_tenor
,repay_day
,grace_days
,loan_dir_cd
,repay_way_cd
,appl_status_cd
,check_status_cd
,coprator_acct_id
,taxpayer_idtfy_num
,tran_flow_num
,user_group_id
,co_proj_id
,org_co_id
,create_dt
,update_dt
,id_mark
from idl.aml_agt_wl_appl_basic_info
where create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_wl_appl_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes