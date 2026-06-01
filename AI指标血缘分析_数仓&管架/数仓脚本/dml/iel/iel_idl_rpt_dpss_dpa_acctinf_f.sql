: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpa_acctinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpa_acctinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t1.acctno_name,chr(13),''),chr(10),'') as acctno_name
,replace(replace(t1.rel_custnum,chr(13),''),chr(10),'') as rel_custnum
,replace(replace(t1.acct_curr,chr(13),''),chr(10),'') as acct_curr
,replace(replace(t1.acct_chfx_flg,chr(13),''),chr(10),'') as acct_chfx_flg
,replace(replace(t1.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t1.acct_due_date,chr(13),''),chr(10),'') as acct_due_date
,replace(replace(t1.acc_bizcod,chr(13),''),chr(10),'') as acc_bizcod
,replace(replace(t1.acct_opec_opun,chr(13),''),chr(10),'') as acct_opec_opun
,replace(replace(t1.acct_opec_date,chr(13),''),chr(10),'') as acct_opec_date
,replace(replace(t1.acct_opec_opr,chr(13),''),chr(10),'') as acct_opec_opr
,replace(replace(t1.acctno_clsd_unit,chr(13),''),chr(10),'') as acctno_clsd_unit
,replace(replace(t1.acctno_clsd_date,chr(13),''),chr(10),'') as acctno_clsd_date
,replace(replace(t1.acctno_clsd_opr,chr(13),''),chr(10),'') as acctno_clsd_opr
,replace(replace(t1.acct_adat,chr(13),''),chr(10),'') as acct_adat
,replace(replace(t1.calendar_name,chr(13),''),chr(10),'') as calendar_name
,t1.cur_unused_seqno as cur_unused_seqno
,replace(replace(t1.oppo_trns_in_acctno,chr(13),''),chr(10),'') as oppo_trns_in_acctno
,replace(replace(t1.oppo_actno,chr(13),''),chr(10),'') as oppo_actno
,t1.cur_bal as cur_bal
,t1.yesterday_bal as yesterday_bal
,replace(replace(t1.last_upddate,chr(13),''),chr(10),'') as last_upddate
,replace(replace(t1.acct_flg_dscrp,chr(13),''),chr(10),'') as acct_flg_dscrp
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.dpprod_type,chr(13),''),chr(10),'') as dpprod_type
,replace(replace(t1.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t1.prod_typ2,chr(13),''),chr(10),'') as prod_typ2
,replace(replace(t1.prod_typ3,chr(13),''),chr(10),'') as prod_typ3
,replace(replace(t1.prod_typ4,chr(13),''),chr(10),'') as prod_typ4
,replace(replace(t1.prod_typ5,chr(13),''),chr(10),'') as prod_typ5
,replace(replace(t1.gl_check_cod,chr(13),''),chr(10),'') as gl_check_cod
,replace(replace(t1.acct_kind,chr(13),''),chr(10),'') as acct_kind
,replace(replace(t1.class_nature,chr(13),''),chr(10),'') as class_nature
,replace(replace(t1.acct_kd3,chr(13),''),chr(10),'') as acct_kd3
,replace(replace(t1.acct_kd4,chr(13),''),chr(10),'') as acct_kd4
,replace(replace(t1.acct_kd5,chr(13),''),chr(10),'') as acct_kd5
,replace(replace(t1.ctl_curr,chr(13),''),chr(10),'') as ctl_curr
,t1.bal_start as bal_start
,replace(replace(t1.txn_lmt,chr(13),''),chr(10),'') as txn_lmt
,t1.rsv_max_lmt as rsv_max_lmt
,t1.rsv_lower_lmt as rsv_lower_lmt
,replace(replace(t1.dpctl_mode,chr(13),''),chr(10),'') as dpctl_mode
,replace(replace(t1.drw_ctl_mode,chr(13),''),chr(10),'') as drw_ctl_mode
,replace(replace(t1.clr_prd_int_flg,chr(13),''),chr(10),'') as clr_prd_int_flg
,replace(replace(t1.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t1.channel_cod,chr(13),''),chr(10),'') as channel_cod
,replace(replace(t1.tfr_dpflg,chr(13),''),chr(10),'') as tfr_dpflg
,t1.resv_amt as resv_amt
,replace(replace(t1.last_biz_date,chr(13),''),chr(10),'') as last_biz_date
,replace(replace(t1.last_agt_date,chr(13),''),chr(10),'') as last_agt_date
,t1.drw_term as drw_term
,t1.opec_amt as opec_amt
,replace(replace(t1.org_intc_date,chr(13),''),chr(10),'') as org_intc_date
,replace(replace(t1.org_end_date,chr(13),''),chr(10),'') as org_end_date
,replace(replace(t1.dep_kind,chr(13),''),chr(10),'') as dep_kind
,replace(replace(t1.dpa_asts,chr(13),''),chr(10),'') as dpa_asts
,replace(replace(t1.acc_chkflg,chr(13),''),chr(10),'') as acc_chkflg
,replace(replace(t1.cact_term,chr(13),''),chr(10),'') as cact_term
,replace(replace(t1.cact_scp,chr(13),''),chr(10),'') as cact_scp
,replace(replace(t1.cact_record_date,chr(13),''),chr(10),'') as cact_record_date
,replace(replace(t1.last_chkdate,chr(13),''),chr(10),'') as last_chkdate
,replace(replace(t1.acct_check_flg,chr(13),''),chr(10),'') as acct_check_flg
,replace(replace(t1.last_achkdat,chr(13),''),chr(10),'') as last_achkdat
,replace(replace(t1.bal_cmp_flg,chr(13),''),chr(10),'') as bal_cmp_flg
,replace(replace(t1.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t1.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t1.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t1.opec_money_from,chr(13),''),chr(10),'') as opec_money_from
,replace(replace(t1.clsd_lmt_flg,chr(13),''),chr(10),'') as clsd_lmt_flg
,replace(replace(t1.appt_trno_acct,chr(13),''),chr(10),'') as appt_trno_acct
,replace(replace(t1.fund_payer_acct,chr(13),''),chr(10),'') as fund_payer_acct
,replace(replace(t1.appt_trni_acct,chr(13),''),chr(10),'') as appt_trni_acct
,replace(replace(t1.fund_incom_act,chr(13),''),chr(10),'') as fund_incom_act
,replace(replace(t1.limit_acct_flg,chr(13),''),chr(10),'') as limit_acct_flg
,replace(replace(t1.acct_frz_flg,chr(13),''),chr(10),'') as acct_frz_flg
,replace(replace(t1.frz_all_flg,chr(13),''),chr(10),'') as frz_all_flg
,replace(replace(t1.only_out_flag,chr(13),''),chr(10),'') as only_out_flag
,replace(replace(t1.only_in_flag,chr(13),''),chr(10),'') as only_in_flag
,replace(replace(t1.rlvc_loop_ln_flg,chr(13),''),chr(10),'') as rlvc_loop_ln_flg
,replace(replace(t1.acct_protect_flg,chr(13),''),chr(10),'') as acct_protect_flg
,replace(replace(t1.chang_sts_flg,chr(13),''),chr(10),'') as chang_sts_flg
,replace(replace(t1.corp_base_flg,chr(13),''),chr(10),'') as corp_base_flg
,replace(replace(t1.monitor_acct_flg,chr(13),''),chr(10),'') as monitor_acct_flg
,replace(replace(t1.corp_nor_flg,chr(13),''),chr(10),'') as corp_nor_flg
,replace(replace(t1.corp_sl_pswd_flg,chr(13),''),chr(10),'') as corp_sl_pswd_flg
,replace(replace(t1.chqu_acct_flg,chr(13),''),chr(10),'') as chqu_acct_flg
,replace(replace(t1.ovdt_aflg,chr(13),''),chr(10),'') as ovdt_aflg
,replace(replace(t1.tb_affrim_flg,chr(13),''),chr(10),'') as tb_affrim_flg
,replace(replace(t1.fx_supervise_flg,chr(13),''),chr(10),'') as fx_supervise_flg
,replace(replace(t1.fx_check_flg,chr(13),''),chr(10),'') as fx_check_flg
,replace(replace(t1.fee_flg,chr(13),''),chr(10),'') as fee_flg
,replace(replace(t1.slep_chg_flg,chr(13),''),chr(10),'') as slep_chg_flg
,replace(replace(t1.clr_acct_flg,chr(13),''),chr(10),'') as clr_acct_flg
,replace(replace(t1.gurt_dep_flg,chr(13),''),chr(10),'') as gurt_dep_flg
,replace(replace(t1.mof_dep_flg,chr(13),''),chr(10),'') as mof_dep_flg
,replace(replace(t1.fs_sign_flg,chr(13),''),chr(10),'') as fs_sign_flg
,replace(replace(t1.resv_lfield,chr(13),''),chr(10),'') as resv_lfield
,replace(replace(t1.resv_fld2,chr(13),''),chr(10),'') as resv_fld2
,replace(replace(t1.resv_fld3,chr(13),''),chr(10),'') as resv_fld3
,t1.resv_bal01 as resv_bal01
,replace(replace(t1.resv_date1,chr(13),''),chr(10),'') as resv_date1
,replace(replace(t1.dr_intc_date,chr(13),''),chr(10),'') as dr_intc_date
,replace(replace(t1.rltm_trns_flg,chr(13),''),chr(10),'') as rltm_trns_flg
,replace(replace(t1.rlvc_od_flg,chr(13),''),chr(10),'') as rlvc_od_flg
,replace(replace(t1.bal_focus_flg,chr(13),''),chr(10),'') as bal_focus_flg
,replace(replace(t1.ol_chg_bataftflg,chr(13),''),chr(10),'') as ol_chg_bataftflg
,replace(replace(t1.bat_aft_chgcycl,chr(13),''),chr(10),'') as bat_aft_chgcycl
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,t1.ser_num as ser_num
,replace(replace(t1.rec_sts,chr(13),''),chr(10),'') as rec_sts
 from iol.dpss_dpa_acctinf T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpa_acctinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes