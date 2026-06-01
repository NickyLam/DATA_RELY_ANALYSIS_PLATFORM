: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_bus_stl_info_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_bus_stl_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.mem_org_cd as mem_org_cd
,t1.stl_req_id as stl_req_id
,t1.stl_tm as stl_tm
,t1.bus_type_cd as bus_type_cd
,t1.stl_way_cd as stl_way_cd
,t1.stl_bus_type_cd as stl_bus_type_cd
,t1.clear_type_cd as clear_type_cd
,t1.bag_dir_cd as bag_dir_cd
,t1.stl_amt as stl_amt
,t1.int_paybl as int_paybl
,t1.bill_cnt as bill_cnt
,t1.ctr_nt_id as ctr_nt_id
,t1.lg_pay_sys_msg_ind_no as lg_pay_sys_msg_ind_no
,t1.bill_num as bill_num
,t1.recver_org_cd as recver_org_cd
,t1.recver_trust_acct_num as recver_trust_acct_num
,t1.recver_trust_acct_name as recver_trust_acct_name
,t1.recver_cap_acct_num as recver_cap_acct_num
,t1.recver_cap_acct_name as recver_cap_acct_name
,t1.payer_org_cd as payer_org_cd
,t1.payer_trust_acct_num as payer_trust_acct_num
,t1.payer_trust_acct_name as payer_trust_acct_name
,t1.payer_cap_acct_num as payer_cap_acct_num
,t1.payer_cap_acct_name as payer_cap_acct_name
,t1.stl_status_cd as stl_status_cd
,t1.stl_rest_code as stl_rest_code
,t1.stl_fail_rs as stl_fail_rs
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.bill_sub_intrv_id as bill_sub_intrv_id
,t1.bus_stl_id as bus_stl_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bill_bus_stl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_bus_stl_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
