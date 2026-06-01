: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_rgst_cter_bill_info_para_f
CreateDate: 20230602
FileName:   ${iel_data_path}/ref_rgst_cter_bill_info_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.init_bill_sys_bill_id,chr(13),''),chr(10),'') as init_bill_sys_bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,draw_dt
,exp_dt
,bill_amt
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
,replace(replace(t1.drawer_soci_crdt_cd,chr(13),''),chr(10),'') as drawer_soci_crdt_cd
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.accptor_soci_crdt_cd,chr(13),''),chr(10),'') as accptor_soci_crdt_cd
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd
,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
,replace(replace(t1.pay_bank_org_cd,chr(13),''),chr(10),'') as pay_bank_org_cd
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t1.pay_cfm_org_cd,chr(13),''),chr(10),'') as pay_cfm_org_cd
,replace(replace(t1.acpt_guar_bank_no,chr(13),''),chr(10),'') as acpt_guar_bank_no
,replace(replace(t1.coll_bank_no,chr(13),''),chr(10),'') as coll_bank_no
,replace(replace(t1.holder_name,chr(13),''),chr(10),'') as holder_name
,replace(replace(t1.holder_soci_crdt_cd,chr(13),''),chr(10),'') as holder_soci_crdt_cd
,replace(replace(t1.holder_acct_num,chr(13),''),chr(10),'') as holder_acct_num
,replace(replace(t1.holder_org_cd,chr(13),''),chr(10),'') as holder_org_cd
,replace(replace(t1.holder_org_name,chr(13),''),chr(10),'') as holder_org_name
,replace(replace(t1.risk_bill_status_cd,chr(13),''),chr(10),'') as risk_bill_status_cd
,replace(replace(t1.bill_invtry_status_cd,chr(13),''),chr(10),'') as bill_invtry_status_cd
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd
,replace(replace(t1.bill_ccution_status_cd,chr(13),''),chr(10),'') as bill_ccution_status_cd
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,replace(replace(t1.comb_status_cd,chr(13),''),chr(10),'') as comb_status_cd
,replace(replace(t1.discnt_bk_org_cd,chr(13),''),chr(10),'') as discnt_bk_org_cd
,replace(replace(t1.discnt_bank_name,chr(13),''),chr(10),'') as discnt_bank_name
,replace(replace(t1.invtry_org_cd,chr(13),''),chr(10),'') as invtry_org_cd
,replace(replace(t1.init_belong_rgst_org_cd,chr(13),''),chr(10),'') as init_belong_rgst_org_cd
,replace(replace(t1.bill_belong_org_id,chr(13),''),chr(10),'') as bill_belong_org_id
,replace(replace(t1.hq_org_id,chr(13),''),chr(10),'') as hq_org_id
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
,replace(replace(t1.pay_cfm_flg,chr(13),''),chr(10),'') as pay_cfm_flg
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.recs_flg,chr(13),''),chr(10),'') as recs_flg
,discnt_dt
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.receipt_flg,chr(13),''),chr(10),'') as receipt_flg
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,bill_intrv_std_amt
,replace(replace(t1.init_bill_id,chr(13),''),chr(10),'') as init_bill_id
,replace(replace(t1.select_id,chr(13),''),chr(10),'') as select_id
,replace(replace(t1.actl_bf_split_bill_id,chr(13),''),chr(10),'') as actl_bf_split_bill_id
,replace(replace(t1.actl_bf_split_intrv_id,chr(13),''),chr(10),'') as actl_bf_split_intrv_id

from ${iml_schema}.ref_rgst_cter_bill_info_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_rgst_cter_bill_info_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
