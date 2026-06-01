: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpa_acctinf_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpa_acctinf_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t1.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t1.comp_opec_bankno,chr(13),''),chr(10),'') as comp_opec_bankno
,replace(replace(t1.fund_from,chr(13),''),chr(10),'') as fund_from
,replace(replace(t1.txn_obj_acctno,chr(13),''),chr(10),'') as txn_obj_acctno
,replace(replace(t1.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t1.receipt_name,chr(13),''),chr(10),'') as receipt_name
,replace(replace(t1.people_bank_no,chr(13),''),chr(10),'') as people_bank_no
,replace(replace(t1.oppo_bank_name,chr(13),''),chr(10),'') as oppo_bank_name
,replace(replace(t1.inst_cod,chr(13),''),chr(10),'') as inst_cod
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.curr_code,chr(13),''),chr(10),'') as curr_code
,replace(replace(t1.rmt_cash_flg,chr(13),''),chr(10),'') as rmt_cash_flg
,replace(replace(t1.oa_bankno,chr(13),''),chr(10),'') as oa_bankno
,replace(replace(t1.opec_bank_name,chr(13),''),chr(10),'') as opec_bank_name
,replace(replace(t1.cust_actno,chr(13),''),chr(10),'') as cust_actno
,replace(replace(t1.temp_acctno_ctfc,chr(13),''),chr(10),'') as temp_acctno_ctfc
,replace(replace(t1.basic_acctno_license,chr(13),''),chr(10),'') as basic_acctno_license
,replace(replace(t1.trans_chgpflg,chr(13),''),chr(10),'') as trans_chgpflg
,replace(replace(t1.org_intc_date,chr(13),''),chr(10),'') as org_intc_date
,replace(replace(t1.org_end_date,chr(13),''),chr(10),'') as org_end_date
,replace(replace(t1.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t1.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t1.acct_acno,chr(13),''),chr(10),'') as acct_acno
,replace(replace(t1.sys_acctno,chr(13),''),chr(10),'') as sys_acctno
,replace(replace(t1.sign_contract_fs_prod_cod,chr(13),''),chr(10),'') as sign_contract_fs_prod_cod
,replace(replace(t1.safe_acctno_char,chr(13),''),chr(10),'') as safe_acctno_char
,replace(replace(t1.cnrt_code,chr(13),''),chr(10),'') as cnrt_code
,replace(replace(t1.approve_cod,chr(13),''),chr(10),'') as approve_cod
,replace(replace(t1.openup_flg,chr(13),''),chr(10),'') as openup_flg
,replace(replace(t1.openup_opr_name,chr(13),''),chr(10),'') as openup_opr_name
,replace(replace(t1.resv_lfield,chr(13),''),chr(10),'') as resv_lfield
,replace(replace(t1.rsv_fld,chr(13),''),chr(10),'') as rsv_fld
,replace(replace(t1.resv_fld2,chr(13),''),chr(10),'') as resv_fld2
,replace(replace(t1.resv_fld3,chr(13),''),chr(10),'') as resv_fld3
,t1.resv_bal01 as resv_bal01
,t1.resv_bal02 as resv_bal02
,t1.appt_amt as appt_amt
,t1.succ_cnt as succ_cnt
,replace(replace(t1.if_flag,chr(13),''),chr(10),'') as if_flag
,t1.acct_fbal as acct_fbal
,replace(replace(t1.rsv_acfld,chr(13),''),chr(10),'') as rsv_acfld
,replace(replace(t1.rsv_adfld,chr(13),''),chr(10),'') as rsv_adfld
,replace(replace(t1.rsv_aefld,chr(13),''),chr(10),'') as rsv_aefld
,replace(replace(t1.rsv_affld,chr(13),''),chr(10),'') as rsv_affld
,t1.resv_number as resv_number
,replace(replace(t1.resv_date1,chr(13),''),chr(10),'') as resv_date1
,replace(replace(t1.resv_date2,chr(13),''),chr(10),'') as resv_date2
,replace(replace(t1.rmk_info,chr(13),''),chr(10),'') as rmk_info
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,replace(replace(t1.rec_sts,chr(13),''),chr(10),'') as rec_sts
 from iol.dpss_dpa_acctinf_add T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpa_acctinf_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes