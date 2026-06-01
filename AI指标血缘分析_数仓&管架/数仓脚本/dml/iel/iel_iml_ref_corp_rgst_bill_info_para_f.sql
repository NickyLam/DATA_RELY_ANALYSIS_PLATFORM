: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_corp_rgst_bill_info_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_corp_rgst_bill_info_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num 
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id 
,t1.bill_amt as bill_amt 
,t1.bill_intrv_std_amt as bill_intrv_std_amt 
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd 
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd 
,replace(replace(t1.bill_src_plat_cd,chr(13),''),chr(10),'') as bill_src_plat_cd 
,t1.draw_dt as draw_dt 
,t1.exp_dt as exp_dt 
,replace(replace(t1.allow_split_pkg_ccution_flg,chr(13),''),chr(10),'') as allow_split_pkg_ccution_flg 
,replace(replace(t1.init_bill_id,chr(13),''),chr(10),'') as init_bill_id 
,replace(replace(t1.actl_bf_split_bill_id,chr(13),''),chr(10),'') as actl_bf_split_bill_id 
,replace(replace(t1.actl_bf_split_intrv_id,chr(13),''),chr(10),'') as actl_bf_split_intrv_id 
,replace(replace(t1.drawer_mem_cd,chr(13),''),chr(10),'') as drawer_mem_cd 
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name 
,replace(replace(t1.drawer_soci_crdt_cd,chr(13),''),chr(10),'') as drawer_soci_crdt_cd 
,replace(replace(t1.drawer_acct_type_cd,chr(13),''),chr(10),'') as drawer_acct_type_cd 
,replace(replace(t1.drawer_acct_id,chr(13),''),chr(10),'') as drawer_acct_id 
,replace(replace(t1.drawer_acct_name,chr(13),''),chr(10),'') as drawer_acct_name 
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no 
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name 
,replace(replace(t1.drawer_open_bank_org_cd,chr(13),''),chr(10),'') as drawer_open_bank_org_cd 
,replace(replace(t1.drawer_open_bank_org_name,chr(13),''),chr(10),'') as drawer_open_bank_org_name 
,replace(replace(t1.accptor_mem_cd,chr(13),''),chr(10),'') as accptor_mem_cd 
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name 
,replace(replace(t1.accptor_soci_crdt_cd,chr(13),''),chr(10),'') as accptor_soci_crdt_cd 
,replace(replace(t1.accptor_acct_type_cd,chr(13),''),chr(10),'') as accptor_acct_type_cd 
,replace(replace(t1.accptor_acct_id,chr(13),''),chr(10),'') as accptor_acct_id 
,replace(replace(t1.accptor_acct_name,chr(13),''),chr(10),'') as accptor_acct_name 
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no 
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name 
,replace(replace(t1.accptor_open_bank_org_cd,chr(13),''),chr(10),'') as accptor_open_bank_org_cd 
,replace(replace(t1.accptor_open_bank_org_name,chr(13),''),chr(10),'') as accptor_open_bank_org_name 
,replace(replace(t1.recver_mem_cd,chr(13),''),chr(10),'') as recver_mem_cd 
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name 
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd 
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd 
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id 
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name 
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no 
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name 
,replace(replace(t1.recver_open_bank_org_cd,chr(13),''),chr(10),'') as recver_open_bank_org_cd 
,replace(replace(t1.recver_open_bank_org_name,chr(13),''),chr(10),'') as recver_open_bank_org_name 
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no 
,replace(replace(t1.pay_bank_org_cd,chr(13),''),chr(10),'') as pay_bank_org_cd 
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name 
,replace(replace(t1.acpt_guar_bk_bank_no,chr(13),''),chr(10),'') as acpt_guar_bk_bank_no 
,replace(replace(t1.acpt_guar_bk_org_cd,chr(13),''),chr(10),'') as acpt_guar_bk_org_cd 
,replace(replace(t1.coll_bank_bank_no,chr(13),''),chr(10),'') as coll_bank_bank_no 
,t1.discnt_dt as discnt_dt 
,replace(replace(t1.discnt_bk_org_cd,chr(13),''),chr(10),'') as discnt_bk_org_cd 
,replace(replace(t1.discnt_bank_name,chr(13),''),chr(10),'') as discnt_bank_name 
,replace(replace(t1.init_belong_rgst_org_cd,chr(13),''),chr(10),'') as init_belong_rgst_org_cd 
,replace(replace(t1.risk_bill_status_cd,chr(13),''),chr(10),'') as risk_bill_status_cd 
,replace(replace(t1.not_ngbl_cd,chr(13),''),chr(10),'') as not_ngbl_cd 
,replace(replace(t1.exp_uncond_pay_entr_cd,chr(13),''),chr(10),'') as exp_uncond_pay_entr_cd 
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg 
,t1.payoff_dt as payoff_dt 
,replace(replace(t1.recs_type_cd,chr(13),''),chr(10),'') as recs_type_cd 
,replace(replace(t1.bf_discnt_manual_recs_cd,chr(13),''),chr(10),'') as bf_discnt_manual_recs_cd 
,replace(replace(t1.manual_recs_lock_flg_cd,chr(13),''),chr(10),'') as manual_recs_lock_flg_cd 
,t1.endors_cnt as endors_cnt 
,replace(replace(t1.bill_obg_mem_cd,chr(13),''),chr(10),'') as bill_obg_mem_cd 
,replace(replace(t1.bill_obg_name,chr(13),''),chr(10),'') as bill_obg_name 
,replace(replace(t1.bill_obg_soci_crdt_cd,chr(13),''),chr(10),'') as bill_obg_soci_crdt_cd 
,replace(replace(t1.bill_obg_acct_type_cd,chr(13),''),chr(10),'') as bill_obg_acct_type_cd 
,replace(replace(t1.bill_obg_acct_id,chr(13),''),chr(10),'') as bill_obg_acct_id 
,replace(replace(t1.bill_obg_open_bank_no,chr(13),''),chr(10),'') as bill_obg_open_bank_no 
,replace(replace(t1.bill_obg_open_bank_name,chr(13),''),chr(10),'') as bill_obg_open_bank_name 
,replace(replace(t1.bill_obg_open_bank_org_cd,chr(13),''),chr(10),'') as bill_obg_open_bank_org_cd 
,replace(replace(t1.bill_obg_open_bank_org_name,chr(13),''),chr(10),'') as bill_obg_open_bank_org_name 
,replace(replace(t1.bill_src_tran_cd,chr(13),''),chr(10),'') as bill_src_tran_cd 
,replace(replace(t1.bill_ccution_status_cd,chr(13),''),chr(10),'') as bill_ccution_status_cd 
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd 
,replace(replace(t1.bill_belong_name,chr(13),''),chr(10),'') as bill_belong_name 
,replace(replace(t1.bill_belong_soci_crdt_cd,chr(13),''),chr(10),'') as bill_belong_soci_crdt_cd 
,replace(replace(t1.bill_belong_acct_id,chr(13),''),chr(10),'') as bill_belong_acct_id 
,replace(replace(t1.bill_belong_open_bank_no,chr(13),''),chr(10),'') as bill_belong_open_bank_no 
,replace(replace(t1.bill_belong_open_bank_name,chr(13),''),chr(10),'') as bill_belong_open_bank_name 
,replace(replace(t1.bill_belong_open_bank_org_cd,chr(13),''),chr(10),'') as bill_belong_open_bank_org_cd 
,replace(replace(t1.bill_belong_open_bank_org_name,chr(13),''),chr(10),'') as bill_belong_open_bank_org_name 
,replace(replace(t1.fir_rgst_id,chr(13),''),chr(10),'') as fir_rgst_id 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name 
from ${iml_schema}.ref_corp_rgst_bill_info_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_corp_rgst_bill_info_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes