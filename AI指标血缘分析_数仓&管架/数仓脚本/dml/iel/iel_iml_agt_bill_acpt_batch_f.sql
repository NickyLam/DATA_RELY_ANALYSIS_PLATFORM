: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_acpt_batch_f
CreateDate: 20230423
FileName:   ${iel_data_path}/agt_bill_acpt_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.acpt_agt_id,chr(13),''),chr(10),'') as acpt_agt_id
,replace(replace(t1.task_type_cd,chr(13),''),chr(10),'') as task_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.drawer_cust_id,chr(13),''),chr(10),'') as drawer_cust_id
,appl_acpt_amt
,appl_draw_dt
,exp_dt
,margin_ratio
,comm_fee_ratio
,tran_amt
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,tran_dt
,replace(replace(t1.bus_logic_check_status_cd,chr(13),''),chr(10),'') as bus_logic_check_status_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
,replace(replace(t1.crdt_check_status_cd,chr(13),''),chr(10),'') as crdt_check_status_cd
,final_modif_tm
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_bank_name,chr(13),''),chr(10),'') as drawer_bank_name
,replace(replace(t1.actl_dir_indus_name,chr(13),''),chr(10),'') as actl_dir_indus_name
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,acpt_fee
,mgmt_fee
,agt_exp_dt
,acct_amt
,apprved_use_crdt_open_amt
,distr_post_acm_use_open_amt
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.onl_bank_batch_id,chr(13),''),chr(10),'') as onl_bank_batch_id
,replace(replace(t1.fst_repay_acct_id,chr(13),''),chr(10),'') as fst_repay_acct_id
,replace(replace(t1.margin_tenor_type_cd,chr(13),''),chr(10),'') as margin_tenor_type_cd
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.margin_type_cd,chr(13),''),chr(10),'') as margin_type_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.margin_int_rat_float_type_cd,chr(13),''),chr(10),'') as margin_int_rat_float_type_cd
,replace(replace(t1.margin_int_rat_float_way_cd,chr(13),''),chr(10),'') as margin_int_rat_float_way_cd
,margin_flo_val
,h_data_flg
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.agt_bill_acpt_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
