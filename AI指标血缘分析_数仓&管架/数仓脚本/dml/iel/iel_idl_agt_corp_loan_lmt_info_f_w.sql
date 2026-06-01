: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_corp_loan_lmt_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_loan_lmt_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.up_level_lmt_flow_num as up_level_lmt_flow_num
,t.lmt_bus_breed_id as lmt_bus_breed_id
,t.rela_obj_type_cd as rela_obj_type_cd
,t.rela_obj_id as rela_obj_id
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.curr_cd as curr_cd
,t.lmt_amt as lmt_amt
,t.lmt_open as lmt_open
,t.exlus_flg as exlus_flg
,t.circl_flg as circl_flg
,t.margin_ratio as margin_ratio
,t.perds as perds
,t.tenor_val as tenor_val
,t.begin_dt as begin_dt
,t.exp_dt as exp_dt
,t.rgst_teller_id as rgst_teller_id
,t.rgst_org_id as rgst_org_id
,t.rgst_dt as rgst_dt
,t.lmt_update_dt as lmt_update_dt
,t.invest_way_cd as invest_way_cd
,t.onl_lmt as onl_lmt
,t.ts_appl_amt as ts_appl_amt
,t.ts_open_amt as ts_open_amt
,t.ts_onl_amt as ts_onl_amt
,t.group_corp_cust_crdt_lmt as group_corp_cust_crdt_lmt
,t.group_corp_cust_crdt_open as group_corp_cust_crdt_open
,t.group_ibank_cust_crdt_lmt as group_ibank_cust_crdt_lmt
,t.group_ibank_cust_crdt_open as group_ibank_cust_crdt_open
,t.ts_group_corp_cust_crdt_lmt as ts_group_corp_cust_crdt_lmt
,t.ts_group_corp_cust_crdt_open as ts_group_corp_cust_crdt_open
,t.ts_group_ibank_cust_crdt_lmt as ts_group_ibank_cust_crdt_lmt
,t.ts_group_ibank_cust_crdt_open as ts_group_ibank_cust_crdt_open
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_corp_loan_lmt_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_loan_lmt_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes