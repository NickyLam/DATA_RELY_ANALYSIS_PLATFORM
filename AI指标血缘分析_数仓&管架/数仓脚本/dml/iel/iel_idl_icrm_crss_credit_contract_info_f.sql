: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_crss_credit_contract_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_crss_credit_contract_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,crdt_lmt_agt_id
,cust_id
,cust_type_cd
,manu_cont_id
,crdt_apv_id
,crdt_appl_id
,crdt_kind_cd
,crdt_bus_kind_cd
,open_dt
,apv_dt
,crdt_start_dt
,crdt_exp_dt
,crdt_termnt_dt
,crdt_cont_status_cd
,crdt_lmt_wrtoff_effect_dt
,crdt_lmt_wrtoff_reason
,crdt_lmt_froz_flg
,circl_flg
,crdt_valid_flg
,com_group_crdt_lmt_flg
,happ_type_cd
,curr_cd
,crdt_lmt
,used_crdt_lmt
,crdt_bal
,aval_crdt_lmt
,open_lmt
,open_bal
,aval_open_lmt
,onl_lmt
,onl_bal
,apv_crdt_lmt
,apv_open_lmt
,group_corp_crdt_lmt
,group_corp_open_lmt
,group_ibank_crdt_lmt
,group_ibank_open_lmt
,guar_val
,guar_ratio
,guar_way_cd
,open_org_id
,crdt_mgmt_org_id
,crdt_acct_instit_id
,crdt_user_id
,init_crdt_lmt_agt_id
,data_src_cd
,apv_path
from idl.icrm_crss_credit_contract_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_crss_credit_contract_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes