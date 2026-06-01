: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dpp_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dpp_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.prdct_explain,chr(13),''),chr(10),'') as prdct_explain
,replace(replace(t1.prod_snam,chr(13),''),chr(10),'') as prod_snam
,replace(replace(t1.prod_effdate,chr(13),''),chr(10),'') as prod_effdate
,replace(replace(t1.prod_avldate,chr(13),''),chr(10),'') as prod_avldate
,replace(replace(t1.dpprod_type,chr(13),''),chr(10),'') as dpprod_type
,replace(replace(t1.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t1.prod_typ2,chr(13),''),chr(10),'') as prod_typ2
,replace(replace(t1.prod_typ3,chr(13),''),chr(10),'') as prod_typ3
,replace(replace(t1.prod_typ4,chr(13),''),chr(10),'') as prod_typ4
,replace(replace(t1.prod_typ5,chr(13),''),chr(10),'') as prod_typ5
,replace(replace(t1.dep_kind,chr(13),''),chr(10),'') as dep_kind
,replace(replace(t1.gl_check_cod,chr(13),''),chr(10),'') as gl_check_cod
,replace(replace(t1.chang_sts_flg,chr(13),''),chr(10),'') as chang_sts_flg
,replace(replace(t1.acc_chkflg,chr(13),''),chr(10),'') as acc_chkflg
,replace(replace(t1.cact_term,chr(13),''),chr(10),'') as cact_term
,replace(replace(t1.acct_check_flg,chr(13),''),chr(10),'') as acct_check_flg
,replace(replace(t1.acct_check_term,chr(13),''),chr(10),'') as acct_check_term
,replace(replace(t1.bal_cmp_flg,chr(13),''),chr(10),'') as bal_cmp_flg
,replace(replace(t1.apredraw_flag,chr(13),''),chr(10),'') as apredraw_flag
,replace(replace(t1.time_lmt,chr(13),''),chr(10),'') as time_lmt
,replace(replace(t1.oa_ctrlflg,chr(13),''),chr(10),'') as oa_ctrlflg
,replace(replace(t1.opec_defualt_lmttyp,chr(13),''),chr(10),'') as opec_defualt_lmttyp
,replace(replace(t1.rlvc_vchr_flg,chr(13),''),chr(10),'') as rlvc_vchr_flg
,replace(replace(t1.odd_opec_flg,chr(13),''),chr(10),'') as odd_opec_flg
,replace(replace(t1.atrdp_flag,chr(13),''),chr(10),'') as atrdp_flag
,replace(replace(t1.gurt_dep_flg,chr(13),''),chr(10),'') as gurt_dep_flg
,replace(replace(t1.mof_dep_flg,chr(13),''),chr(10),'') as mof_dep_flg
,replace(replace(t1.ovdt_aflg,chr(13),''),chr(10),'') as ovdt_aflg
,replace(replace(t1.inst_ctl_flg,chr(13),''),chr(10),'') as inst_ctl_flg
,replace(replace(t1.emply_prod,chr(13),''),chr(10),'') as emply_prod
,replace(replace(t1.derive_prod_flg,chr(13),''),chr(10),'') as derive_prod_flg
,replace(replace(t1.opr_cod,chr(13),''),chr(10),'') as opr_cod
,replace(replace(t1.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t1.dpfee_emod,chr(13),''),chr(10),'') as dpfee_emod
,replace(replace(t1.dpprod_sts,chr(13),''),chr(10),'') as dpprod_sts
,replace(replace(t1.dpprod_curr,chr(13),''),chr(10),'') as dpprod_curr
,replace(replace(t1.allow_deal_flg,chr(13),''),chr(10),'') as allow_deal_flg
,replace(replace(t1.acctno_make_cod,chr(13),''),chr(10),'') as acctno_make_cod
,replace(replace(t1.rechk_opr,chr(13),''),chr(10),'') as rechk_opr
,replace(replace(t1.aprv_date,chr(13),''),chr(10),'') as aprv_date
,replace(replace(t1.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t1.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t1.mod_date,chr(13),''),chr(10),'') as mod_date
,t1.mod_time as mod_time
,t1.time_sign as time_sign
,replace(replace(t1.rec_sts,chr(13),''),chr(10),'') as rec_sts
 from iol.dpss_dpp_product T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dpp_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes