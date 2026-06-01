: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpa_acctinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpa_acctinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t.acctno_name,chr(13),''),chr(10),'') as acctno_name
,replace(replace(t.rel_custnum,chr(13),''),chr(10),'') as rel_custnum
,replace(replace(t.acct_curr,chr(13),''),chr(10),'') as acct_curr
,replace(replace(t.acct_chfx_flg,chr(13),''),chr(10),'') as acct_chfx_flg
,replace(replace(t.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t.acct_due_date,chr(13),''),chr(10),'') as acct_due_date
,replace(replace(t.acc_bizcod,chr(13),''),chr(10),'') as acc_bizcod
,replace(replace(t.acct_opec_opun,chr(13),''),chr(10),'') as acct_opec_opun
,replace(replace(t.acct_opec_date,chr(13),''),chr(10),'') as acct_opec_date
,replace(replace(t.acct_opec_opr,chr(13),''),chr(10),'') as acct_opec_opr
,replace(replace(t.acctno_clsd_unit,chr(13),''),chr(10),'') as acctno_clsd_unit
,replace(replace(t.acctno_clsd_date,chr(13),''),chr(10),'') as acctno_clsd_date
,replace(replace(t.acctno_clsd_opr,chr(13),''),chr(10),'') as acctno_clsd_opr
,replace(replace(t.acct_adat,chr(13),''),chr(10),'') as acct_adat
,replace(replace(t.calendar_name,chr(13),''),chr(10),'') as calendar_name
,t.cur_unused_seqno as cur_unused_seqno
,replace(replace(t.oppo_trns_in_acctno,chr(13),''),chr(10),'') as oppo_trns_in_acctno
,replace(replace(t.oppo_actno,chr(13),''),chr(10),'') as oppo_actno
,t.cur_bal as cur_bal
,t.yesterday_bal as yesterday_bal
,replace(replace(t.last_upddate,chr(13),''),chr(10),'') as last_upddate
,replace(replace(t.acct_flg_dscrp,chr(13),''),chr(10),'') as acct_flg_dscrp
,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t.dpprod_type,chr(13),''),chr(10),'') as dpprod_type
,replace(replace(t.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t.prod_typ2,chr(13),''),chr(10),'') as prod_typ2
,replace(replace(t.prod_typ3,chr(13),''),chr(10),'') as prod_typ3
,replace(replace(t.prod_typ4,chr(13),''),chr(10),'') as prod_typ4
,replace(replace(t.prod_typ5,chr(13),''),chr(10),'') as prod_typ5
,replace(replace(t.gl_check_cod,chr(13),''),chr(10),'') as gl_check_cod
,replace(replace(t.acct_kind,chr(13),''),chr(10),'') as acct_kind
,replace(replace(t.class_nature,chr(13),''),chr(10),'') as class_nature
,replace(replace(t.acct_kd3,chr(13),''),chr(10),'') as acct_kd3
,replace(replace(t.acct_kd4,chr(13),''),chr(10),'') as acct_kd4
,replace(replace(t.acct_kd5,chr(13),''),chr(10),'') as acct_kd5
,replace(replace(t.ctl_curr,chr(13),''),chr(10),'') as ctl_curr
,t.bal_start as bal_start
,replace(replace(t.txn_lmt,chr(13),''),chr(10),'') as txn_lmt
,t.rsv_max_lmt as rsv_max_lmt
,t.rsv_lower_lmt as rsv_lower_lmt
,replace(replace(t.dpctl_mode,chr(13),''),chr(10),'') as dpctl_mode
,replace(replace(t.drw_ctl_mode,chr(13),''),chr(10),'') as drw_ctl_mode
,replace(replace(t.clr_prd_int_flg,chr(13),''),chr(10),'') as clr_prd_int_flg
,replace(replace(t.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t.channel_cod,chr(13),''),chr(10),'') as channel_cod
,replace(replace(t.tfr_dpflg,chr(13),''),chr(10),'') as tfr_dpflg
,t.resv_amt as resv_amt
,replace(replace(t.last_biz_date,chr(13),''),chr(10),'') as last_biz_date
,replace(replace(t.last_agt_date,chr(13),''),chr(10),'') as last_agt_date
,t.drw_term as drw_term
,t.opec_amt as opec_amt
,replace(replace(t.org_intc_date,chr(13),''),chr(10),'') as org_intc_date
,replace(replace(t.org_end_date,chr(13),''),chr(10),'') as org_end_date
,replace(replace(t.dep_kind,chr(13),''),chr(10),'') as dep_kind
,replace(replace(t.dpa_asts,chr(13),''),chr(10),'') as dpa_asts
,replace(replace(t.acc_chkflg,chr(13),''),chr(10),'') as acc_chkflg
,replace(replace(t.cact_term,chr(13),''),chr(10),'') as cact_term
,replace(replace(t.cact_scp,chr(13),''),chr(10),'') as cact_scp
,replace(replace(t.cact_record_date,chr(13),''),chr(10),'') as cact_record_date
,replace(replace(t.last_chkdate,chr(13),''),chr(10),'') as last_chkdate
,replace(replace(t.acct_check_flg,chr(13),''),chr(10),'') as acct_check_flg
,replace(replace(t.last_achkdat,chr(13),''),chr(10),'') as last_achkdat
,replace(replace(t.bal_cmp_flg,chr(13),''),chr(10),'') as bal_cmp_flg
,replace(replace(t.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t.opec_money_from,chr(13),''),chr(10),'') as opec_money_from
,replace(replace(t.clsd_lmt_flg,chr(13),''),chr(10),'') as clsd_lmt_flg
,replace(replace(t.appt_trno_acct,chr(13),''),chr(10),'') as appt_trno_acct
,replace(replace(t.fund_payer_acct,chr(13),''),chr(10),'') as fund_payer_acct
,replace(replace(t.appt_trni_acct,chr(13),''),chr(10),'') as appt_trni_acct
,replace(replace(t.fund_incom_act,chr(13),''),chr(10),'') as fund_incom_act
,replace(replace(t.limit_acct_flg,chr(13),''),chr(10),'') as limit_acct_flg
,replace(replace(t.acct_frz_flg,chr(13),''),chr(10),'') as acct_frz_flg
,replace(replace(t.frz_all_flg,chr(13),''),chr(10),'') as frz_all_flg
,replace(replace(t.only_out_flag,chr(13),''),chr(10),'') as only_out_flag
,replace(replace(t.only_in_flag,chr(13),''),chr(10),'') as only_in_flag
,replace(replace(t.rlvc_loop_ln_flg,chr(13),''),chr(10),'') as rlvc_loop_ln_flg
,replace(replace(t.acct_protect_flg,chr(13),''),chr(10),'') as acct_protect_flg
,replace(replace(t.chang_sts_flg,chr(13),''),chr(10),'') as chang_sts_flg
,replace(replace(t.corp_base_flg,chr(13),''),chr(10),'') as corp_base_flg
,replace(replace(t.monitor_acct_flg,chr(13),''),chr(10),'') as monitor_acct_flg
,replace(replace(t.corp_nor_flg,chr(13),''),chr(10),'') as corp_nor_flg
,replace(replace(t.corp_sl_pswd_flg,chr(13),''),chr(10),'') as corp_sl_pswd_flg
,replace(replace(t.chqu_acct_flg,chr(13),''),chr(10),'') as chqu_acct_flg
,replace(replace(t.ovdt_aflg,chr(13),''),chr(10),'') as ovdt_aflg
,replace(replace(t.tb_affrim_flg,chr(13),''),chr(10),'') as tb_affrim_flg
,replace(replace(t.fx_supervise_flg,chr(13),''),chr(10),'') as fx_supervise_flg
,replace(replace(t.fx_check_flg,chr(13),''),chr(10),'') as fx_check_flg
,replace(replace(t.fee_flg,chr(13),''),chr(10),'') as fee_flg
,replace(replace(t.slep_chg_flg,chr(13),''),chr(10),'') as slep_chg_flg
,replace(replace(t.clr_acct_flg,chr(13),''),chr(10),'') as clr_acct_flg
,replace(replace(t.gurt_dep_flg,chr(13),''),chr(10),'') as gurt_dep_flg
,replace(replace(t.mof_dep_flg,chr(13),''),chr(10),'') as mof_dep_flg
,replace(replace(t.fs_sign_flg,chr(13),''),chr(10),'') as fs_sign_flg
,replace(replace(t.resv_lfield,chr(13),''),chr(10),'') as resv_lfield
,replace(replace(t.resv_fld2,chr(13),''),chr(10),'') as resv_fld2
,replace(replace(t.resv_fld3,chr(13),''),chr(10),'') as resv_fld3
,t.resv_bal01 as resv_bal01
,replace(replace(t.resv_date1,chr(13),''),chr(10),'') as resv_date1
,replace(replace(t.dr_intc_date,chr(13),''),chr(10),'') as dr_intc_date
,replace(replace(t.rltm_trns_flg,chr(13),''),chr(10),'') as rltm_trns_flg
,replace(replace(t.rlvc_od_flg,chr(13),''),chr(10),'') as rlvc_od_flg
,replace(replace(t.bal_focus_flg,chr(13),''),chr(10),'') as bal_focus_flg
,replace(replace(t.ol_chg_bataftflg,chr(13),''),chr(10),'') as ol_chg_bataftflg
,replace(replace(t.bat_aft_chgcycl,chr(13),''),chr(10),'') as bat_aft_chgcycl
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,t.mod_time as mod_time
,t.time_sign as time_sign
,t.ser_num as ser_num
,replace(replace(t.rec_sts,chr(13),''),chr(10),'') as rec_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpa_acctinf t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpa_acctinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes