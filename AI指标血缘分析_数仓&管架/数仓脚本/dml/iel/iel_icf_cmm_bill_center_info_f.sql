: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_bill_center_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_bill_center_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,draw_dt
,exp_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t1.pay_org_id,chr(13),''),chr(10),'') as pay_org_id
,replace(replace(t1.pay_cfm_org_id,chr(13),''),chr(10),'') as pay_cfm_org_id
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.holder_org_id,chr(13),''),chr(10),'') as holder_org_id
,replace(replace(t1.holder_org_name,chr(13),''),chr(10),'') as holder_org_name
,endors_cnt
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,replace(replace(t1.loss_flg,chr(13),''),chr(10),'') as loss_flg
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
,replace(replace(t1.pay_cfm_flg,chr(13),''),chr(10),'') as pay_cfm_flg
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.recs_flg,chr(13),''),chr(10),'') as recs_flg
,replace(replace(t1.risk_status_cd,chr(13),''),chr(10),'') as risk_status_cd
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.bill_pay_int_way_cd,chr(13),''),chr(10),'') as bill_pay_int_way_cd
,distr_dt
,acpt_dt
,cash_dt
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.drawer_cust_id,chr(13),''),chr(10),'') as drawer_cust_id
,replace(replace(t1.drawer_operr_id,chr(13),''),chr(10),'') as drawer_operr_id
,replace(replace(t1.drawer_type_cd,chr(13),''),chr(10),'') as drawer_type_cd
,replace(replace(t1.accptor_type_cd,chr(13),''),chr(10),'') as accptor_type_cd
,replace(replace(t1.acpt_org_id,chr(13),''),chr(10),'') as acpt_org_id
,replace(replace(t1.ccution_status_cd,chr(13),''),chr(10),'') as ccution_status_cd
,replace(replace(t1.invtry_status_cd,chr(13),''),chr(10),'') as invtry_status_cd
,replace(replace(t1.ele_bill_status_cd,chr(13),''),chr(10),'') as ele_bill_status_cd
,replace(replace(t1.bill_proc_mdl_status_cd,chr(13),''),chr(10),'') as bill_proc_mdl_status_cd
,replace(replace(t1.receipt_flg,chr(13),''),chr(10),'') as receipt_flg
,replace(replace(t1.redcst_flg,chr(13),''),chr(10),'') as redcst_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.valet_coll_flg,chr(13),''),chr(10),'') as valet_coll_flg
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.discnt_bank_name,chr(13),''),chr(10),'') as discnt_bank_name
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd
,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd
,replace(replace(t1.drawer_soci_crdt_cd,chr(13),''),chr(10),'') as drawer_soci_crdt_cd
,replace(replace(t1.accptor_soci_crdt_cd,chr(13),''),chr(10),'') as accptor_soci_crdt_cd
,replace(replace(t1.discnt_bank_org_id,chr(13),''),chr(10),'') as discnt_bank_org_id
,replace(replace(t1.discnt_ibank_no,chr(13),''),chr(10),'') as discnt_ibank_no

from ${icl_schema}.cmm_bill_center_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_center_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
