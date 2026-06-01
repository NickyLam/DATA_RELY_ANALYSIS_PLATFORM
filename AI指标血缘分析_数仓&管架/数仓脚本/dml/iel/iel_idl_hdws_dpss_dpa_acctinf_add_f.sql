: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpa_acctinf_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpa_acctinf_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ledge_cod
,t1.cust_acctno
,t1.dpact_no
,t1.comp_opec_bankno
,t1.fund_from
,t1.txn_obj_acctno
,t1.comb_asno
,t1.receipt_name
,t1.people_bank_no
,t1.oppo_bank_name
,t1.inst_cod
,t1.prod_cd
,t1.curr_code
,t1.rmt_cash_flg
,t1.oa_bankno
,t1.opec_bank_name
,t1.cust_actno
,t1.temp_acctno_ctfc
,t1.basic_acctno_license
,t1.trans_chgpflg
,t1.org_intc_date
,t1.org_end_date
,t1.combprod_cod
,t1.comb_acno
,t1.acct_acno
,t1.sys_acctno
,t1.sign_contract_fs_prod_cod
,t1.safe_acctno_char
,t1.cnrt_code
,t1.approve_cod
,t1.openup_flg
,t1.openup_opr_name
,t1.resv_lfield
,t1.rsv_fld
,t1.resv_fld2
,t1.resv_fld3
,t1.resv_bal01
,t1.resv_bal02
,t1.appt_amt
,t1.succ_cnt
,t1.if_flag
,t1.acct_fbal
,t1.rsv_acfld
,t1.rsv_adfld
,t1.rsv_aefld
,t1.rsv_affld
,t1.resv_number
,t1.resv_date1
,t1.resv_date2
,t1.rmk_info
,t1.mod_opr
,t1.mod_unit
,t1.mod_date
,t1.mod_time
,t1.time_sign
,t1.rec_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpa_acctinf_add t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpa_acctinf_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes