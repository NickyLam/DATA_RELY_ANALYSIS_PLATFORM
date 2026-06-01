: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_bill_discnt_info_f
CreateDate: 20250113
FileName:   ${iel_data_path}/cmm_bill_discnt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'') as bill_kind_cd
,replace(replace(t1.buy_prod_cd,chr(13),''),chr(10),'') as buy_prod_cd
,replace(replace(t1.discnt_bus_type_cd,chr(13),''),chr(10),'') as discnt_bus_type_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg
,replace(replace(t1.city_wide_flg,chr(13),''),chr(10),'') as city_wide_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.adj_days,chr(13),''),chr(10),'') as adj_days
,replace(replace(t1.provi_type_cd,chr(13),''),chr(10),'') as provi_type_cd
,replace(replace(t1.buy_way_cd,chr(13),''),chr(10),'') as buy_way_cd
,replace(replace(t1.bill_bus_type_cd,chr(13),''),chr(10),'') as bill_bus_type_cd
,replace(replace(t1.bf_cntpty_type_cd,chr(13),''),chr(10),'') as bf_cntpty_type_cd
,replace(replace(t1.bf_cntpty_name,chr(13),''),chr(10),'') as bf_cntpty_name
,replace(replace(t1.bf_cntpty_flg,chr(13),''),chr(10),'') as bf_cntpty_flg
,appl_dt
,recv_dt
,value_dt
,revo_dt
,draw_dt
,exp_dt
,replace(replace(t1.dir_rher_name,chr(13),''),chr(10),'') as dir_rher_name
,replace(replace(t1.discnt_applit_acct_num,chr(13),''),chr(10),'') as discnt_applit_acct_num
,replace(replace(t1.discnt_applit_bank_no,chr(13),''),chr(10),'') as discnt_applit_bank_no
,replace(replace(t1.dscnt_props_cate_cd,chr(13),''),chr(10),'') as dscnt_props_cate_cd
,replace(replace(t1.dscnt_props_name,chr(13),''),chr(10),'') as dscnt_props_name
,replace(replace(t1.dscnt_props_orgnz_cd,chr(13),''),chr(10),'') as dscnt_props_orgnz_cd
,replace(replace(t1.dscnt_props_acct_num,chr(13),''),chr(10),'') as dscnt_props_acct_num
,replace(replace(t1.dscnt_props_open_bank_no,chr(13),''),chr(10),'') as dscnt_props_open_bank_no
,replace(replace(t1.dscnt_name,chr(13),''),chr(10),'') as dscnt_name
,replace(replace(t1.dscnt_bank_no,chr(13),''),chr(10),'') as dscnt_bank_no
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'') as drawer_cate_cd
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.agent_discnt_flg,chr(13),''),chr(10),'') as agent_discnt_flg
,replace(replace(t1.onl_discnt_flg,chr(13),''),chr(10),'') as onl_discnt_flg
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,entry_dt
,int_accr_exp_dt
,discnt_int_rat
,replace(replace(t1.defer_days,chr(13),''),chr(10),'') as defer_days
,int_accr_days
,replace(replace(t1.not_ngbl_flg,chr(13),''),chr(10),'') as not_ngbl_flg
,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'') as hxb_acpt_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.receipt_flg,chr(13),''),chr(10),'') as receipt_flg
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,replace(replace(t1.discnt_status_cd,chr(13),''),chr(10),'') as discnt_status_cd
,replace(replace(t1.redcst_flg,chr(13),''),chr(10),'') as redcst_flg
,currt_bal
,int_adj_bal
,td_acru_int
,currt_acru_int
,int_amt
,buyer_pay_int_amt
,actl_amt
,risk_bear_fee
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.drawer_crdt_level_cd,chr(13),''),chr(10),'') as drawer_crdt_level_cd
,replace(replace(t1.drawer_rating_org_name,chr(13),''),chr(10),'') as drawer_rating_org_name
,drawer_rating_exp_dt
,replace(replace(t1.bill_entry_id,chr(13),''),chr(10),'') as bill_entry_id
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,replace(replace(t1.flash_discnt_flg,chr(13),''),chr(10),'') as flash_discnt_flg
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
,replace(replace(t1.bus_subclass_id,chr(13),''),chr(10),'') as bus_subclass_id
,stl_dt
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.clear_type_cd,chr(13),''),chr(10),'') as clear_type_cd
,replace(replace(t1.bus_belong_org_id,chr(13),''),chr(10),'') as bus_belong_org_id
,replace(replace(t1.discnt_type_cd,chr(13),''),chr(10),'') as discnt_type_cd
,replace(replace(t1.discnt_agt_no,chr(13),''),chr(10),'') as discnt_agt_no
,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'') as pay_bank_bank_no
,replace(replace(t1.pay_bank_bank_name,chr(13),''),chr(10),'') as pay_bank_bank_name
,replace(replace(t1.accept_ps_acct_num,chr(13),''),chr(10),'') as accept_ps_acct_num
,replace(replace(t1.accept_ps_name,chr(13),''),chr(10),'') as accept_ps_name
,replace(replace(t1.accept_ps_open_bank_num,chr(13),''),chr(10),'') as accept_ps_open_bank_num
,replace(replace(t1.accept_ps_open_bank_name,chr(13),''),chr(10),'') as accept_ps_open_bank_name
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.pay_int_way_cd,chr(13),''),chr(10),'') as pay_int_way_cd
,pay_int_ratio
,linkg_int_rat

from ${icl_schema}.cmm_bill_discnt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bill_discnt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
