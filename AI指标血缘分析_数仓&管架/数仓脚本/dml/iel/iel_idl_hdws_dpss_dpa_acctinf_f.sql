: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpa_acctinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpa_acctinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ledge_cod
,t1.dpact_no
,t1.acctno_name
,t1.rel_custnum
,t1.acct_curr
,t1.acct_chfx_flg
,t1.acct_dep_term
,t1.acct_due_date
,t1.acc_bizcod
,t1.acct_opec_opun
,t1.acct_opec_date
,t1.acct_opec_opr
,t1.acctno_clsd_unit
,t1.acctno_clsd_date
,t1.acctno_clsd_opr
,t1.acct_adat
,t1.calendar_name
,t1.cur_unused_seqno
,t1.oppo_trns_in_acctno
,t1.oppo_actno
,t1.cur_bal
,t1.yesterday_bal
,t1.last_upddate
,t1.acct_flg_dscrp
,t1.prod_cd
,t1.dpprod_type
,t1.belong_obj
,t1.prod_typ2
,t1.prod_typ3
,t1.prod_typ4
,t1.prod_typ5
,t1.gl_check_cod
,t1.acct_kind
,t1.class_nature
,t1.acct_kd3
,t1.acct_kd4
,t1.acct_kd5
,t1.ctl_curr
,t1.bal_start
,t1.txn_lmt
,t1.rsv_max_lmt
,t1.rsv_lower_lmt
,t1.dpctl_mode
,t1.drw_ctl_mode
,t1.clr_prd_int_flg
,t1.cust_acctno
,t1.channel_cod
,t1.tfr_dpflg
,t1.resv_amt
,t1.last_biz_date
,t1.last_agt_date
,t1.drw_term
,t1.opec_amt
,t1.org_intc_date
,t1.org_end_date
,t1.dep_kind
,t1.dpa_asts
,t1.acc_chkflg
,t1.cact_term
,t1.cact_scp
,t1.cact_record_date
,t1.last_chkdate
,t1.acct_check_flg
,t1.last_achkdat
,t1.bal_cmp_flg
,t1.combprod_cod
,t1.comb_asno
,t1.comb_acno
,t1.opec_money_from
,t1.clsd_lmt_flg
,t1.appt_trno_acct
,t1.fund_payer_acct
,t1.appt_trni_acct
,t1.fund_incom_act
,t1.limit_acct_flg
,t1.acct_frz_flg
,t1.frz_all_flg
,t1.only_out_flag
,t1.only_in_flag
,t1.rlvc_loop_ln_flg
,t1.acct_protect_flg
,t1.chang_sts_flg
,t1.corp_base_flg
,t1.monitor_acct_flg
,t1.corp_nor_flg
,t1.corp_sl_pswd_flg
,t1.chqu_acct_flg
,t1.ovdt_aflg
,t1.tb_affrim_flg
,t1.fx_supervise_flg
,t1.fx_check_flg
,t1.fee_flg
,t1.slep_chg_flg
,t1.clr_acct_flg
,t1.gurt_dep_flg
,t1.mof_dep_flg
,t1.fs_sign_flg
,t1.resv_lfield
,t1.resv_fld2
,t1.resv_fld3
,t1.resv_bal01
,t1.resv_date1
,t1.dr_intc_date
,t1.rltm_trns_flg
,t1.rlvc_od_flg
,t1.bal_focus_flg
,t1.ol_chg_bataftflg
,t1.bat_aft_chgcycl
,t1.mod_opr
,t1.mod_unit
,t1.mod_date
,t1.mod_time
,t1.time_sign
,t1.ser_num
,t1.rec_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpa_acctinf t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpa_acctinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes