: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_rgst_cter_bill_ccution_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_rgst_cter_bill_ccution.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id 
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id 
,replace(replace(t1.agt_dtl_id,chr(13),''),chr(10),'') as agt_dtl_id 
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id 
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd 
,replace(replace(t1.bus_attr_cd,chr(13),''),chr(10),'') as bus_attr_cd 
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,t1.tran_dt as tran_dt
,replace(replace(t1.reqer_type_cd,chr(13),''),chr(10),'') as reqer_type_cd
,replace(replace(t1.reqer_name,chr(13),''),chr(10),'') as reqer_name
,replace(replace(t1.reqer_soci_crdt_cd,chr(13),''),chr(10),'') as reqer_soci_crdt_cd
,replace(replace(t1.reqer_acct_num,chr(13),''),chr(10),'') as reqer_acct_num
,replace(replace(t1.reqer_mem_id,chr(13),''),chr(10),'') as reqer_mem_id
,replace(replace(t1.reqer_org_id,chr(13),''),chr(10),'') as reqer_org_id 
,replace(replace(t1.reqer_pay_sys_bank_no,chr(13),''),chr(10),'') as reqer_pay_sys_bank_no 
,replace(replace(t1.recver_type_cd,chr(13),''),chr(10),'') as recver_type_cd 
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name 
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd 
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num 
,replace(replace(t1.recver_mem_code,chr(13),''),chr(10),'') as recver_mem_code 
,replace(replace(t1.recver_org_id,chr(13),''),chr(10),'') as recver_org_id 
,replace(replace(t1.recver_pay_sys_bank_no,chr(13),''),chr(10),'') as recver_pay_sys_bank_no 
,t1.actl_amt as actl_amt 
,t1.actl_int as actl_int 
,t1.int_rat as int_rat
,replace(replace(t1.stop_pay_type_cd,chr(13),''),chr(10),'') as stop_pay_type_cd
,replace(replace(t1.remit_stop_pay_type_cd,chr(13),''),chr(10),'') as remit_stop_pay_type_cd
,t1.surp_tenor as surp_tenor
,t1.stl_amt as stl_amt
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.payoff_type_cd,chr(13),''),chr(10),'') as payoff_type_cd
,replace(replace(t1.invtry_org_id,chr(13),''),chr(10),'') as invtry_org_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.evt_rgst_cter_bill_ccution t1 
where  t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_rgst_cter_bill_ccution.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes