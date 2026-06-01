: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpp_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpp_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ledge_cod,chr(13),''),chr(10),'') as ledge_cod
,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t.prdct_explain,chr(13),''),chr(10),'') as prdct_explain
,replace(replace(t.prod_snam,chr(13),''),chr(10),'') as prod_snam
,replace(replace(t.prod_effdate,chr(13),''),chr(10),'') as prod_effdate
,replace(replace(t.prod_avldate,chr(13),''),chr(10),'') as prod_avldate
,replace(replace(t.dpprod_type,chr(13),''),chr(10),'') as dpprod_type
,replace(replace(t.belong_obj,chr(13),''),chr(10),'') as belong_obj
,replace(replace(t.prod_typ2,chr(13),''),chr(10),'') as prod_typ2
,replace(replace(t.prod_typ3,chr(13),''),chr(10),'') as prod_typ3
,replace(replace(t.prod_typ4,chr(13),''),chr(10),'') as prod_typ4
,replace(replace(t.prod_typ5,chr(13),''),chr(10),'') as prod_typ5
,replace(replace(t.dep_kind,chr(13),''),chr(10),'') as dep_kind
,replace(replace(t.gl_check_cod,chr(13),''),chr(10),'') as gl_check_cod
,replace(replace(t.chang_sts_flg,chr(13),''),chr(10),'') as chang_sts_flg
,replace(replace(t.acc_chkflg,chr(13),''),chr(10),'') as acc_chkflg
,replace(replace(t.cact_term,chr(13),''),chr(10),'') as cact_term
,replace(replace(t.acct_check_flg,chr(13),''),chr(10),'') as acct_check_flg
,replace(replace(t.acct_check_term,chr(13),''),chr(10),'') as acct_check_term
,replace(replace(t.bal_cmp_flg,chr(13),''),chr(10),'') as bal_cmp_flg
,replace(replace(t.apredraw_flag,chr(13),''),chr(10),'') as apredraw_flag
,replace(replace(t.time_lmt,chr(13),''),chr(10),'') as time_lmt
,replace(replace(t.oa_ctrlflg,chr(13),''),chr(10),'') as oa_ctrlflg
,replace(replace(t.opec_defualt_lmttyp,chr(13),''),chr(10),'') as opec_defualt_lmttyp
,replace(replace(t.rlvc_vchr_flg,chr(13),''),chr(10),'') as rlvc_vchr_flg
,replace(replace(t.odd_opec_flg,chr(13),''),chr(10),'') as odd_opec_flg
,replace(replace(t.atrdp_flag,chr(13),''),chr(10),'') as atrdp_flag
,replace(replace(t.gurt_dep_flg,chr(13),''),chr(10),'') as gurt_dep_flg
,replace(replace(t.mof_dep_flg,chr(13),''),chr(10),'') as mof_dep_flg
,replace(replace(t.ovdt_aflg,chr(13),''),chr(10),'') as ovdt_aflg
,replace(replace(t.inst_ctl_flg,chr(13),''),chr(10),'') as inst_ctl_flg
,replace(replace(t.emply_prod,chr(13),''),chr(10),'') as emply_prod
,replace(replace(t.derive_prod_flg,chr(13),''),chr(10),'') as derive_prod_flg
,replace(replace(t.opr_cod,chr(13),''),chr(10),'') as opr_cod
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t.dpfee_emod,chr(13),''),chr(10),'') as dpfee_emod
,replace(replace(t.dpprod_sts,chr(13),''),chr(10),'') as dpprod_sts
,replace(replace(t.dpprod_curr,chr(13),''),chr(10),'') as dpprod_curr
,replace(replace(t.allow_deal_flg,chr(13),''),chr(10),'') as allow_deal_flg
,replace(replace(t.acctno_make_cod,chr(13),''),chr(10),'') as acctno_make_cod
,replace(replace(t.rechk_opr,chr(13),''),chr(10),'') as rechk_opr
,replace(replace(t.aprv_date,chr(13),''),chr(10),'') as aprv_date
,replace(replace(t.mod_opr,chr(13),''),chr(10),'') as mod_opr
,replace(replace(t.mod_unit,chr(13),''),chr(10),'') as mod_unit
,replace(replace(t.mod_date,chr(13),''),chr(10),'') as mod_date
,t.mod_time as mod_time
,t.time_sign as time_sign
,replace(replace(t.rec_sts,chr(13),''),chr(10),'') as rec_sts
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.dpss_dpp_product t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpp_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes