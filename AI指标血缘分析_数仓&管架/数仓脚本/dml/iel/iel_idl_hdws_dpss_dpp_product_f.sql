: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dpss_dpp_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dpss_dpp_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ledge_cod
,t1.prod_cd
,t1.prdct_explain
,t1.prod_snam
,t1.prod_effdate
,t1.prod_avldate
,t1.dpprod_type
,t1.belong_obj
,t1.prod_typ2
,t1.prod_typ3
,t1.prod_typ4
,t1.prod_typ5
,t1.dep_kind
,t1.gl_check_cod
,t1.chang_sts_flg
,t1.acc_chkflg
,t1.cact_term
,t1.acct_check_flg
,t1.acct_check_term
,t1.bal_cmp_flg
,t1.apredraw_flag
,t1.time_lmt
,t1.oa_ctrlflg
,t1.opec_defualt_lmttyp
,t1.rlvc_vchr_flg
,t1.odd_opec_flg
,t1.atrdp_flag
,t1.gurt_dep_flg
,t1.mof_dep_flg
,t1.ovdt_aflg
,t1.inst_ctl_flg
,t1.emply_prod
,t1.derive_prod_flg
,t1.opr_cod
,t1.txn_date
,t1.dpfee_emod
,t1.dpprod_sts
,t1.dpprod_curr
,t1.allow_deal_flg
,t1.acctno_make_cod
,t1.rechk_opr
,t1.aprv_date
,t1.mod_opr
,t1.mod_unit
,t1.mod_date
,t1.mod_time
,t1.time_sign
,t1.rec_sts
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_dpss_dpp_product t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dpss_dpp_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes