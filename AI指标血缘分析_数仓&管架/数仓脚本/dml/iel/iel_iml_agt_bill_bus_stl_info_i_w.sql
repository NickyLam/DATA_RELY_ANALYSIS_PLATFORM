: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_bus_stl_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_bus_stl_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.bus_stl_id,chr(13),''),chr(10),'') as bus_stl_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.mem_org_cd,chr(13),''),chr(10),'') as mem_org_cd
,replace(replace(t.stl_req_id,chr(13),''),chr(10),'') as stl_req_id
,t.stl_tm as stl_tm
,replace(replace(t.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t.stl_bus_type_cd,chr(13),''),chr(10),'') as stl_bus_type_cd
,replace(replace(t.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t.bag_dir_cd,chr(13),''),chr(10),'') as bag_dir_cd
,t.stl_amt as stl_amt
,t.int_paybl as int_paybl
,t.bill_cnt as bill_cnt
,replace(replace(t.ctr_nt_id,chr(13),''),chr(10),'') as ctr_nt_id
,replace(replace(t.lg_pay_sys_msg_ind_no,chr(13),''),chr(10),'') as lg_pay_sys_msg_ind_no
,replace(replace(t.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t.recver_org_cd,chr(13),''),chr(10),'') as recver_org_cd
,replace(replace(t.recver_trust_acct_num,chr(13),''),chr(10),'') as recver_trust_acct_num
,replace(replace(t.recver_trust_acct_name,chr(13),''),chr(10),'') as recver_trust_acct_name
,replace(replace(t.recver_cap_acct_num,chr(13),''),chr(10),'') as recver_cap_acct_num
,replace(replace(t.recver_cap_acct_name,chr(13),''),chr(10),'') as recver_cap_acct_name
,replace(replace(t.payer_org_cd,chr(13),''),chr(10),'') as payer_org_cd
,replace(replace(t.payer_trust_acct_num,chr(13),''),chr(10),'') as payer_trust_acct_num
,replace(replace(t.payer_trust_acct_name,chr(13),''),chr(10),'') as payer_trust_acct_name
,replace(replace(t.payer_cap_acct_num,chr(13),''),chr(10),'') as payer_cap_acct_num
,replace(replace(t.payer_cap_acct_name,chr(13),''),chr(10),'') as payer_cap_acct_name
,replace(replace(t.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd
,replace(replace(t.stl_rest_code,chr(13),''),chr(10),'') as stl_rest_code
,replace(replace(t.stl_fail_rs,chr(13),''),chr(10),'') as stl_fail_rs
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_bill_bus_stl_info t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_bus_stl_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes