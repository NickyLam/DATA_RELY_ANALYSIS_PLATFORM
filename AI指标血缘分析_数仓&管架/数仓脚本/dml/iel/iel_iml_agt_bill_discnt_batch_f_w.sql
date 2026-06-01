: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_discnt_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discnt_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_d
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.buy_prod_cd,chr(13),''),chr(10),'') as buy_prod_cd
,replace(replace(t1.buy_type_cd,chr(13),''),chr(10),'') as buy_type_cd
,replace(replace(t1.discnt_bus_type_cd,chr(13),''),chr(10),'') as discnt_bus_type_cd
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_open_bank_no,chr(13),''),chr(10),'') as cust_open_bank_no
,replace(replace(t1.cust_open_acct_num,chr(13),''),chr(10),'') as cust_open_acct_num
,t1.int_rat as int_rat
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,t1.redem_int_rat as redem_int_rat
,replace(replace(t1.redem_int_rat_type_cd,chr(13),''),chr(10),'') as redem_int_rat_type_cd
,t1.buy_dt as buy_dt
,replace(replace(t1.onl_clear_flg,chr(13),''),chr(10),'') as onl_clear_flg
,t1.redem_open_dt as redem_open_dt
,t1.redem_closing_dt as redem_closing_dt
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
,replace(replace(t1.pay_int_way_cd,chr(13),''),chr(10),'') as pay_int_way_cd
,replace(replace(t1.int_payer_name,chr(13),''),chr(10),'') as int_payer_name
,replace(replace(t1.int_payer_acct_num,chr(13),''),chr(10),'') as int_payer_acct_num
,t1.pay_int_ratio as pay_int_ratio
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.discnt_bf_revw_flg,chr(13),''),chr(10),'') as discnt_bf_revw_flg
,replace(replace(t1.cont_matrl_backup_flg,chr(13),''),chr(10),'') as cont_matrl_backup_flg
,t1.backup_closing_dt as backup_closing_dt
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,t1.tran_dt as tran_dt
,replace(replace(t1.bus_logic_check_status_cd,chr(13),''),chr(10),'') as bus_logic_check_status_cd
,replace(replace(t1.crdt_check_status_cd,chr(13),''),chr(10),'') as crdt_check_status_cd
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
,replace(replace(t1.int_accr_check_status_cd,chr(13),''),chr(10),'') as int_accr_check_status_cd
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.intnal_stl_flg,chr(13),''),chr(10),'') as intnal_stl_flg
,replace(replace(t1.intnal_stl_acct,chr(13),''),chr(10),'') as intnal_stl_acct
,t1.agt_exp_dt as agt_exp_dt
,t1.crdt_valid_amt as crdt_valid_amt
,t1.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt
,t1.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd
,t1.crdt_cont_used_amt as crdt_cont_used_amt
,t1.crdt_cont_tot_amt as crdt_cont_tot_amt
,t1.lmt_cont_used_tot_amt as lmt_cont_used_tot_amt
,replace(replace(t1.midgrod_bus_flow_num,chr(13),''),chr(10),'') as midgrod_bus_flow_num
,replace(replace(t1.int_calc_defer_way_cd,chr(13),''),chr(10),'') as int_calc_defer_way_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_discnt_batch t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes