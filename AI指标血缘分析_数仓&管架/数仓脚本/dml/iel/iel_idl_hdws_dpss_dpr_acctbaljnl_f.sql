: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpr_acctbaljnl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpr_acctbaljnl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ledge_cod
,t1.dpact_no
,t1.acctno_name
,t1.bal_field_name
,t1.ser_num
,t1.dc_flg
,t1.tx_curr
,t1.acct_chfx_flg
,t1.txn_xamt
,t1.bal
,t1.cust_acctno
,t1.comb_asno
,t1.prod_cd
,t1.belong_obj
,t1.acct_dep_term
,t1.vchr_type
,t1.vchr_batnum
,t1.vchr_onum
,t1.brief_cod
,t1.brief_desc
,t1.channel_cod
,t1.outside_txn_cod
,t1.in_txn_cod
,t1.ctdc_flg
,t1.txn_obj_acctno
,t1.oppo_actno
,t1.oppo_name
,t1.oppo_custtype
,t1.oppo_instnam
,t1.oppo_bank_typ
,t1.oppo_bank_inst_no
,t1.agt_opr
,t1.agt_ctfc_kind
,t1.agt_ctfc_cod
,t1.agt_nation
,t1.combprod_cod
,t1.comb_acno
,t1.bank_biz_cod
,t1.rel_abizcod
,t1.tl_seqno
,t1.busi_inst
,t1.txn_acct_inst
,t1.acct_opec_opun
,t1.acct_inst
,t1.handle_opr
,t1.aprv_opr
,t1.approval_opr
,t1.txn_date
,t1.txn_ctime
,t1.mach_date
,t1.rsvl_flg
,t1.rvs_flag
,t1.error_acct_org_date
,t1.org_opr_seqno
,t1.rmk_info
,t1.tx_deal_chrct
,t1.mod_opr
,t1.mod_unit
,t1.mod_date
,t1.mod_time
,t1.time_sign
,t1.rec_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpr_acctbaljnl t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpr_acctbaljnl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes