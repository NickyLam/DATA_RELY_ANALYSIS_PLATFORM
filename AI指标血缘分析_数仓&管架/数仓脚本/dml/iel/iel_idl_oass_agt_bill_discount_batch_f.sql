: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_discount_batch_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_discount_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.hq_org_id as hq_org_id
,t1.cont_id as cont_id
,t1.appl_dt as appl_dt
,t1.prod_id as prod_id
,t1.std_prod_id as std_prod_id
,t1.bus_dt as bus_dt
,t1.quot_bill_id as quot_bill_id
,t1.bus_type_cd as bus_type_cd
,t1.sys_in_flg as sys_in_flg
,t1.send_msg_flg as send_msg_flg
,t1.ctr_nt_id as ctr_nt_id
,t1.tran_dir_cd as tran_dir_cd
,t1.bus_org_id as bus_org_id
,t1.acct_instit_id as acct_instit_id
,t1.tran_teller_id as tran_teller_id
,t1.cust_mgr_id as cust_mgr_id
,t1.dept_id as dept_id
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.cust_belong_bank_no as cust_belong_bank_no
,t1.cust_belong_org_id as cust_belong_org_id
,t1.bill_type_cd as bill_type_cd
,t1.bill_med_cd as bill_med_cd
,t1.bill_cnt as bill_cnt
,t1.bill_tot as bill_tot
,t1.repo_amt as repo_amt
,t1.hold_tenor as hold_tenor
,t1.part_bag_option_flg as part_bag_option_flg
,t1.quot_valid_tm as quot_valid_tm
,t1.clear_speed_cd as clear_speed_cd
,t1.clear_type_cd as clear_type_cd
,t1.latest_stl_tm as latest_stl_tm
,t1.stl_way_cd as stl_way_cd
,t1.stl_amt as stl_amt
,t1.exp_stl_amt as exp_stl_amt
,t1.stl_dt as stl_dt
,t1.exp_stl_dt as exp_stl_dt
,t1.int_rat as int_rat
,t1.exp_int_rat as exp_int_rat
,t1.int_paybl as int_paybl
,t1.exp_int_paybl as exp_int_paybl
,t1.yld_rat as yld_rat
,t1.select_type_cd as select_type_cd
,t1.bill_pkg_id as bill_pkg_id
,t1.crdt_check_status_cd as crdt_check_status_cd
,t1.entry_status_cd as entry_status_cd
,t1.msg_status_cd as msg_status_cd
,t1.clear_status_cd as clear_status_cd
,t1.final_modif_tm as final_modif_tm
,t1.apv_status_cd as apv_status_cd
,t1.modif_flg as modif_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.remark_1 as remark_1
,t1.batch_id as batch_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bill_discount_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_discount_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
