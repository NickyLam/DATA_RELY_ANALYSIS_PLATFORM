: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpr_acctbaljnl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpr_acctbaljnl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t1.acctno_name,chr(13),''),chr(10),'') as acctno_name
,replace(replace(t1.bal_field_name,chr(13),''),chr(10),'') as bal_field_name
,t1.ser_num as ser_num
,replace(replace(t1.dc_flg,chr(13),''),chr(10),'') as dc_flg
,replace(replace(t1.tx_curr,chr(13),''),chr(10),'') as tx_curr
,replace(replace(t1.acct_chfx_flg,chr(13),''),chr(10),'') as acct_chfx_flg
,t1.txn_xamt as txn_xamt
,t1.bal as bal
,replace(replace(t1.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t1.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t1.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t1.vchr_type,chr(13),''),chr(10),'') as vchr_type
,replace(replace(t1.vchr_batnum,chr(13),''),chr(10),'') as vchr_batnum
,replace(replace(t1.vchr_onum,chr(13),''),chr(10),'') as vchr_onum
,replace(replace(t1.brief_cod,chr(13),''),chr(10),'') as brief_cod
,replace(replace(t1.brief_desc,chr(13),''),chr(10),'') as brief_desc
,replace(replace(t1.channel_cod,chr(13),''),chr(10),'') as channel_cod
,replace(replace(t1.outside_txn_cod,chr(13),''),chr(10),'') as outside_txn_cod
,replace(replace(t1.in_txn_cod,chr(13),''),chr(10),'') as in_txn_cod
,replace(replace(t1.ctdc_flg,chr(13),''),chr(10),'') as ctdc_flg
,replace(replace(t1.txn_obj_acctno,chr(13),''),chr(10),'') as txn_obj_acctno
,replace(replace(t1.oppo_actno,chr(13),''),chr(10),'') as oppo_actno
,replace(replace(t1.oppo_name,chr(13),''),chr(10),'') as oppo_name
,replace(replace(t1.oppo_custtype,chr(13),''),chr(10),'') as oppo_custtype
,replace(replace(t1.oppo_instnam,chr(13),''),chr(10),'') as oppo_instnam
,replace(replace(t1.oppo_bank_typ,chr(13),''),chr(10),'') as oppo_bank_typ
,replace(replace(t1.oppo_bank_inst_no,chr(13),''),chr(10),'') as oppo_bank_inst_no
,replace(replace(t1.agt_opr,chr(13),''),chr(10),'') as agt_opr
,replace(replace(t1.agt_ctfc_kind,chr(13),''),chr(10),'') as agt_ctfc_kind
,replace(replace(t1.agt_ctfc_cod,chr(13),''),chr(10),'') as agt_ctfc_cod
,replace(replace(t1.agt_nation,chr(13),''),chr(10),'') as agt_nation
,replace(replace(t1.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t1.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t1.bank_biz_cod,chr(13),''),chr(10),'') as bank_biz_cod
,replace(replace(t1.rel_abizcod,chr(13),''),chr(10),'') as rel_abizcod
,replace(replace(t1.tl_seqno,chr(13),''),chr(10),'') as tl_seqno
,replace(replace(t1.busi_inst,chr(13),''),chr(10),'') as busi_inst
,replace(replace(t1.txn_acct_inst,chr(13),''),chr(10),'') as txn_acct_inst
,replace(replace(t1.acct_opec_opun,chr(13),''),chr(10),'') as acct_opec_opun
,replace(replace(t1.acct_inst,chr(13),''),chr(10),'') as acct_inst
,replace(replace(t1.handle_opr,chr(13),''),chr(10),'') as handle_opr
,replace(replace(t1.aprv_opr,chr(13),''),chr(10),'') as aprv_opr
,replace(replace(t1.approval_opr,chr(13),''),chr(10),'') as approval_opr
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date
,t1.txn_ctime as txn_ctime
,replace(replace(t1.mach_date,chr(13),''),chr(10),'') as mach_date
,replace(replace(t1.rsvl_flg,chr(13),''),chr(10),'') as rsvl_flg
,replace(replace(t1.rvs_flag,chr(13),''),chr(10),'') as rvs_flag
,replace(replace(t1.error_acct_org_date,chr(13),''),chr(10),'') as error_acct_org_date
,replace(replace(t1.org_opr_seqno,chr(13),''),chr(10),'') as org_opr_seqno
,replace(replace(t1.rmk_info,chr(13),''),chr(10),'') as rmk_info
,replace(replace(t1.tx_deal_chrct,chr(13),''),chr(10),'') as tx_deal_chrct
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,replace(replace(t1.rec_sts,chr(13),''),chr(10),'') as rec_sts
 from iol.dpss_dpr_acctbaljnl T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpr_acctbaljnl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes