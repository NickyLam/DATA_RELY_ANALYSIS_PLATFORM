: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_discount_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discount_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.batch_id as batch_id
,t.lp_id as lp_id
,t.hq_org_id as hq_org_id
,t.cont_id as cont_id
,t.appl_dt as appl_dt
,t.prod_id as prod_id
,t.std_prod_id as std_prod_id
,t.bus_dt as bus_dt
,t.quot_bill_id as quot_bill_id
,t.bus_type_cd as bus_type_cd
,t.sys_in_flg as sys_in_flg
,t.send_msg_flg as send_msg_flg
,t.ctr_nt_id as ctr_nt_id
,t.tran_dir_cd as tran_dir_cd
,t.bus_org_id as bus_org_id
,t.acct_instit_id as acct_instit_id
,t.tran_teller_id as tran_teller_id
,t.cust_mgr_id as cust_mgr_id
,t.dept_id as dept_id
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.cust_belong_bank_no as cust_belong_bank_no
,t.cust_belong_org_id as cust_belong_org_id
,t.bill_type_cd as bill_type_cd
,t.bill_med_cd as bill_med_cd
,t.bill_cnt as bill_cnt
,t.bill_tot as bill_tot
,t.repo_amt as repo_amt
,t.hold_tenor as hold_tenor
,t.part_bag_option_flg as part_bag_option_flg
,t.quot_valid_tm as quot_valid_tm
,t.clear_speed_cd as clear_speed_cd
,t.clear_type_cd as clear_type_cd
,t.latest_stl_tm as latest_stl_tm
,t.stl_way_cd as stl_way_cd
,t.stl_amt as stl_amt
,t.exp_stl_amt as exp_stl_amt
,t.stl_dt as stl_dt
,t.exp_stl_dt as exp_stl_dt
,t.int_rat as int_rat
,t.exp_int_rat as exp_int_rat
,t.int_paybl as int_paybl
,t.exp_int_paybl as exp_int_paybl
,t.yld_rat as yld_rat
,t.select_type_cd as select_type_cd
,t.bill_pkg_id as bill_pkg_id
,t.crdt_check_status_cd as crdt_check_status_cd
,t.entry_status_cd as entry_status_cd
,t.msg_status_cd as msg_status_cd
,t.clear_status_cd as clear_status_cd
,t.final_modif_tm as final_modif_tm
,t.apv_status_cd as apv_status_cd
,t.modif_flg as modif_flg
,t.asset_thd_cls_cd as asset_thd_cls_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_discount_batch t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discount_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes