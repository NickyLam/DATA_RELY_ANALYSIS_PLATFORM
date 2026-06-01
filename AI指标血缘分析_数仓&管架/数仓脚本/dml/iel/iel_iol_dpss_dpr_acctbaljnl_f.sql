: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpr_acctbaljnl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpr_acctbaljnl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.dpact_no,chr(13),''),chr(10),'') as dpact_no
,replace(replace(t.acctno_name,chr(13),''),chr(10),'') as acctno_name
,replace(replace(t.bal_field_name,chr(13),''),chr(10),'') as bal_field_name
,t.ser_num as ser_num
,replace(replace(t.dc_flg,chr(13),''),chr(10),'') as dc_flg
,replace(replace(t.tx_curr,chr(13),''),chr(10),'') as tx_curr
,replace(replace(t.acct_chfx_flg,chr(13),''),chr(10),'') as acct_chfx_flg
,t.txn_xamt as txn_xamt
,t.bal as bal
,replace(replace(t.cust_acctno,chr(13),''),chr(10),'') as cust_acctno
,replace(replace(t.comb_asno,chr(13),''),chr(10),'') as comb_asno
,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t.acct_dep_term,chr(13),''),chr(10),'') as acct_dep_term
,replace(replace(t.vchr_type,chr(13),''),chr(10),'') as vchr_type
,replace(replace(t.vchr_batnum,chr(13),''),chr(10),'') as vchr_batnum
,replace(replace(t.vchr_onum,chr(13),''),chr(10),'') as vchr_onum
,replace(replace(t.brief_cod,chr(13),''),chr(10),'') as brief_cod
,replace(replace(t.brief_desc,chr(13),''),chr(10),'') as brief_desc
,replace(replace(t.channel_cod,chr(13),''),chr(10),'') as channel_cod
,replace(replace(t.outside_txn_cod,chr(13),''),chr(10),'') as outside_txn_cod
,replace(replace(t.in_txn_cod,chr(13),''),chr(10),'') as in_txn_cod
,replace(replace(t.ctdc_flg,chr(13),''),chr(10),'') as ctdc_flg
,replace(replace(t.txn_obj_acctno,chr(13),''),chr(10),'') as txn_obj_acctno
,replace(replace(t.oppo_actno,chr(13),''),chr(10),'') as oppo_actno
,replace(replace(t.oppo_name,chr(13),''),chr(10),'') as oppo_name
,replace(replace(t.oppo_custtype,chr(13),''),chr(10),'') as oppo_custtype
,replace(replace(t.oppo_instnam,chr(13),''),chr(10),'') as oppo_instnam
,replace(replace(t.oppo_bank_typ,chr(13),''),chr(10),'') as oppo_bank_typ
,replace(replace(t.oppo_bank_inst_no,chr(13),''),chr(10),'') as oppo_bank_inst_no
,replace(replace(t.agt_opr,chr(13),''),chr(10),'') as agt_opr
,replace(replace(t.agt_ctfc_kind,chr(13),''),chr(10),'') as agt_ctfc_kind
,replace(replace(t.agt_ctfc_cod,chr(13),''),chr(10),'') as agt_ctfc_cod
,replace(replace(t.agt_nation,chr(13),''),chr(10),'') as agt_nation
,replace(replace(t.combprod_cod,chr(13),''),chr(10),'') as combprod_cod
,replace(replace(t.comb_acno,chr(13),''),chr(10),'') as comb_acno
,replace(replace(t.bank_biz_cod,chr(13),''),chr(10),'') as bank_biz_cod
,replace(replace(t.rel_abizcod,chr(13),''),chr(10),'') as rel_abizcod
,replace(replace(t.tl_seqno,chr(13),''),chr(10),'') as tl_seqno
,replace(replace(t.busi_inst,chr(13),''),chr(10),'') as busi_inst
,replace(replace(t.txn_acct_inst,chr(13),''),chr(10),'') as txn_acct_inst
,replace(replace(t.acct_opec_opun,chr(13),''),chr(10),'') as acct_opec_opun
,replace(replace(t.acct_inst,chr(13),''),chr(10),'') as acct_inst
,replace(replace(t.handle_opr,chr(13),''),chr(10),'') as handle_opr
,replace(replace(t.aprv_opr,chr(13),''),chr(10),'') as aprv_opr
,replace(replace(t.approval_opr,chr(13),''),chr(10),'') as approval_opr
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,t.txn_ctime as txn_ctime
,replace(replace(t.mach_date,chr(13),''),chr(10),'') as mach_date
,replace(replace(t.rsvl_flg,chr(13),''),chr(10),'') as rsvl_flg
,replace(replace(t.rvs_flag,chr(13),''),chr(10),'') as rvs_flag
,replace(replace(t.error_acct_org_date,chr(13),''),chr(10),'') as error_acct_org_date
,replace(replace(t.org_opr_seqno,chr(13),''),chr(10),'') as org_opr_seqno
,replace(replace(t.rmk_info,chr(13),''),chr(10),'') as rmk_info
,replace(replace(t.tx_deal_chrct,chr(13),''),chr(10),'') as tx_deal_chrct
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,t.mod_time as mod_time
,t.time_sign as time_sign
,replace(replace(t.rec_sts,chr(13),''),chr(10),'') as rec_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpr_acctbaljnl t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpr_acctbaljnl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes