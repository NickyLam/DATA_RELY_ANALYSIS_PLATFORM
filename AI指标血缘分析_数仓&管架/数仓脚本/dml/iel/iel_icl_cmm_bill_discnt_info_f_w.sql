: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_bill_discnt_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_bill_discnt_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.bus_id,chr(13),''),chr(10),'') as bus_id
    ,replace(replace(t.batch_id,chr(13),''),chr(10),'') as batch_id
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
    ,replace(replace(t.bill_id,chr(13),''),chr(10),'') as bill_id
    ,replace(replace(t.bill_num,chr(13),''),chr(10),'') as bill_num
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
    ,replace(replace(t.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
    ,replace(replace(t.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
    ,replace(replace(t.buy_prod_cd,chr(13),''),chr(10),'') as buy_prod_cd
    ,replace(replace(t.discnt_bus_type_cd,chr(13),''),chr(10),'') as discnt_bus_type_cd
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
    ,replace(replace(t.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
    ,replace(replace(t.city_wide_flg,chr(13),''),chr(10),'') as city_wide_flg
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
    ,replace(replace(t.adj_days,chr(13),''),chr(10),'') as adj_days
    ,replace(replace(t.provi_type_cd,chr(13),''),chr(10),'') as provi_type_cd
    ,replace(replace(t.buy_way_cd,chr(13),''),chr(10),'') as buy_way_cd
    ,replace(replace(t.bill_bus_type_cd,chr(13),''),chr(10),'') as bill_bus_type_cd
    ,replace(replace(t.bf_cntpty_type_cd,chr(13),''),chr(10),'') as bf_cntpty_type_cd
    ,replace(replace(t.bf_cntpty_name,chr(13),''),chr(10),'') as bf_cntpty_name
    ,replace(replace(t.bf_cntpty_flg,chr(13),''),chr(10),'') as bf_cntpty_flg
    ,t.appl_dt as appl_dt
    ,t.recv_dt as recv_dt
    ,t.value_dt as value_dt
    ,t.revo_dt as revo_dt
    ,t.draw_dt as draw_dt
    ,t.exp_dt as exp_dt
    ,replace(replace(t.dir_rher_name,chr(13),''),chr(10),'') as dir_rher_name
    ,replace(replace(t.discnt_applit_acct_num,chr(13),''),chr(10),'') as discnt_applit_acct_num
    ,replace(replace(t.discnt_applit_bank_no,chr(13),''),chr(10),'') as discnt_applit_bank_no
    ,replace(replace(t.dscnt_props_cate_cd,chr(13),''),chr(10),'') as dscnt_props_cate_cd
    ,replace(replace(t.dscnt_props_name,chr(13),''),chr(10),'') as dscnt_props_name
    ,replace(replace(t.dscnt_props_orgnz_cd,chr(13),''),chr(10),'') as dscnt_props_orgnz_cd
    ,replace(replace(t.dscnt_props_acct_num,chr(13),''),chr(10),'') as dscnt_props_acct_num
    ,replace(replace(t.dscnt_props_open_bank_no,chr(13),''),chr(10),'') as dscnt_props_open_bank_no
    ,replace(replace(t.dscnt_name,chr(13),''),chr(10),'') as dscnt_name
    ,replace(replace(t.dscnt_bank_no,chr(13),''),chr(10),'') as dscnt_bank_no
    ,replace(replace(t.drawer_name,chr(13),''),chr(10),'') as drawer_name
    ,replace(replace(t.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd
    ,replace(replace(t.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
    ,replace(replace(t.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
    ,replace(replace(t.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
    ,replace(replace(t.accptor_name,chr(13),''),chr(10),'') as accptor_name
    ,replace(replace(t.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
    ,replace(replace(t.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
    ,replace(replace(t.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
    ,replace(replace(t.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
    ,replace(replace(t.agent_discnt_flg,chr(13),''),chr(10),'') as agent_discnt_flg
    ,replace(replace(t.onl_discnt_flg,chr(13),''),chr(10),'') as onl_discnt_flg
    ,replace(replace(t.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
    ,t.entry_dt as entry_dt
    ,t.int_accr_exp_dt as int_accr_exp_dt
    ,t.discnt_int_rat as discnt_int_rat
    ,replace(replace(t.defer_days,chr(13),''),chr(10),'') as defer_days
    ,t.int_accr_days as int_accr_days
    ,replace(replace(t.not_ngbl_flg,chr(13),''),chr(10),'') as not_ngbl_flg
    ,replace(replace(t.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.fac_val_amt as fac_val_amt
    ,replace(replace(t.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
    ,replace(replace(t.receipt_flg,chr(13),''),chr(10),'') as receipt_flg
    ,replace(replace(t.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
    ,replace(replace(t.discnt_status_cd,chr(13),''),chr(10),'') as discnt_status_cd
    ,replace(replace(t.redcst_flg,chr(13),''),chr(10),'') as redcst_flg
    ,t.currt_bal as currt_bal
    ,t.int_adj_bal as int_adj_bal
    ,t.td_acru_int as td_acru_int
    ,t.currt_acru_int as currt_acru_int
    ,t.int_amt as int_amt
    ,t.buyer_pay_int_amt as buyer_pay_int_amt
    ,t.actl_amt as actl_amt
    ,t.risk_bear_fee as risk_bear_fee
    ,replace(replace(t.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
    ,replace(replace(t.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.dept_id,chr(13),''),chr(10),'') as dept_id
    ,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
    ,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
    ,replace(replace(t.drawer_crdt_level_cd,chr(13),''),chr(10),'') as drawer_crdt_level_cd
    ,replace(replace(t.drawer_rating_org_name,chr(13),''),chr(10),'') as drawer_rating_org_name
    ,t.drawer_rating_exp_dt as drawer_rating_exp_dt
    ,replace(replace(t.bill_entry_id,chr(13),''),chr(10),'') as bill_entry_id
    ,replace(replace(t.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
    ,replace(replace(t.flash_discnt_flg,chr(13),''),chr(10),'') as flash_discnt_flg
    ,replace(replace(t.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd
    ,replace(replace(t.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd

from icl.cmm_bill_discnt_info t
  where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_discnt_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes