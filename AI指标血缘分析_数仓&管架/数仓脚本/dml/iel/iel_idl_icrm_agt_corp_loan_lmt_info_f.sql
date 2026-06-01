: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_corp_loan_lmt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_corp_loan_lmt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select agt_id
,lp_id
,up_level_lmt_flow_num
,lmt_bus_breed_id
,rela_obj_type_cd
,rela_obj_id
,cust_id
,cust_name
,curr_cd
,lmt_amt
,lmt_open
,exlus_flg
,circl_flg
,margin_ratio
,perds
,tenor_val
,begin_dt
,exp_dt
,rgst_teller_id
,rgst_org_id
,rgst_dt
,lmt_update_dt
,invest_way_cd
,onl_lmt
,ts_appl_amt
,ts_open_amt
,ts_onl_amt
,group_corp_cust_crdt_lmt
,group_corp_cust_crdt_open
,group_ibank_cust_crdt_lmt
,group_ibank_cust_crdt_open
,ts_group_corp_cust_crdt_lmt
,ts_group_corp_cust_crdt_open
,ts_group_ibank_cust_crdt_lmt
,ts_group_ibank_cust_crdt_open
,etl_dt
,job_cd from idl.icrm_agt_corp_loan_lmt_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_corp_loan_lmt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes