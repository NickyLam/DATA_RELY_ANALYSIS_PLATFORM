: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpa_acctinf_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpa_acctinf_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t.comp_opec_bankno,chr(13),''),chr(10),'') as comp_opec_bankno
,replace(replace(t.fund_from,chr(13),''),chr(10),'') as fund_from
,replace(replace(t.txn_obj_acctno,chr(13),''),chr(10),'') as txn_obj_acctno
,replace(replace(t.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t.receipt_name,chr(13),''),chr(10),'') as receipt_name
,replace(replace(t.people_bank_no,chr(13),''),chr(10),'') as people_bank_no
,replace(replace(t.oppo_bank_name,chr(13),''),chr(10),'') as oppo_bank_name
,replace(replace(t.inst_cod,chr(13),''),chr(10),'') as inst_cod
,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t.curr_code,chr(13),''),chr(10),'') as curr_code
,replace(replace(t.rmt_cash_flg,chr(13),''),chr(10),'') as rmt_cash_flg
,replace(replace(t.oa_bankno,chr(13),''),chr(10),'') as oa_bankno
,replace(replace(t.opec_bank_name,chr(13),''),chr(10),'') as opec_bank_name
,replace(replace(t.cust_actno,chr(13),''),chr(10),'') as cust_actno
,replace(replace(t.temp_acctno_ctfc,chr(13),''),chr(10),'') as temp_acctno_ctfc
,replace(replace(t.basic_acctno_license,chr(13),''),chr(10),'') as basic_acctno_license
,replace(replace(t.trans_chgpflg,chr(13),''),chr(10),'') as trans_chgpflg
,replace(replace(t.org_intc_date,chr(13),''),chr(10),'') as org_intc_date
,replace(replace(t.org_end_date,chr(13),''),chr(10),'') as org_end_date
,replace(replace(t.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t.acct_acno,chr(13),''),chr(10),'') as acct_acno
,replace(replace(t.sys_acctno,chr(13),''),chr(10),'') as sys_acctno
,replace(replace(t.sign_contract_fs_prod_cod,chr(13),''),chr(10),'') as sign_contract_fs_prod_cod
,replace(replace(t.safe_acctno_char,chr(13),''),chr(10),'') as safe_acctno_char
,replace(replace(t.cnrt_code,chr(13),''),chr(10),'') as cnrt_code
,replace(replace(t.approve_cod,chr(13),''),chr(10),'') as approve_cod
,replace(replace(t.openup_flg,chr(13),''),chr(10),'') as openup_flg
,replace(replace(t.openup_opr_name,chr(13),''),chr(10),'') as openup_opr_name
,replace(replace(t.resv_lfield,chr(13),''),chr(10),'') as resv_lfield
,replace(replace(t.rsv_fld,chr(13),''),chr(10),'') as rsv_fld
,replace(replace(t.resv_fld2,chr(13),''),chr(10),'') as resv_fld2
,replace(replace(t.resv_fld3,chr(13),''),chr(10),'') as resv_fld3
,t.resv_bal01 as resv_bal01
,t.resv_bal02 as resv_bal02
,t.appt_amt as appt_amt
,t.succ_cnt as succ_cnt
,replace(replace(t.if_flag,chr(13),''),chr(10),'') as if_flag
,t.acct_fbal as acct_fbal
,replace(replace(t.rsv_acfld,chr(13),''),chr(10),'') as rsv_acfld
,replace(replace(t.rsv_adfld,chr(13),''),chr(10),'') as rsv_adfld
,replace(replace(t.rsv_aefld,chr(13),''),chr(10),'') as rsv_aefld
,replace(replace(t.rsv_affld,chr(13),''),chr(10),'') as rsv_affld
,t.resv_number as resv_number
,replace(replace(t.resv_date1,chr(13),''),chr(10),'') as resv_date1
,replace(replace(t.resv_date2,chr(13),''),chr(10),'') as resv_date2
,replace(replace(t.rmk_info,chr(13),''),chr(10),'') as rmk_info
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,t.mod_time as mod_time
,t.time_sign as time_sign
,replace(replace(t.rec_sts,chr(13),''),chr(10),'') as rec_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpa_acctinf_add t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpa_acctinf_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes