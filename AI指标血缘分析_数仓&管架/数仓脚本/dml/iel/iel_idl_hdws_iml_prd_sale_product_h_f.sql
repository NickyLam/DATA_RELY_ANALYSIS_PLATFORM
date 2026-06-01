: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_prd_sale_product_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_prd_sale_product_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sale_prd_id,chr(13),''),chr(10),'') as sale_prd_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.sale_prd_name,chr(13),''),chr(10),'') as sale_prd_name
,replace(replace(t1.sale_prd_typ_cd,chr(13),''),chr(10),'') as sale_prd_typ_cd
,replace(replace(t1.prd_appl_ccy_cd,chr(13),''),chr(10),'') as prd_appl_ccy_cd
,replace(replace(t1.appl_pty_typ_cd,chr(13),''),chr(10),'') as appl_pty_typ_cd
,replace(replace(t1.sale_prd_desc,chr(13),''),chr(10),'') as sale_prd_desc
,replace(replace(t1.director_org_id,chr(13),''),chr(10),'') as director_org_id
,replace(replace(t1.sale_org_id,chr(13),''),chr(10),'') as sale_org_id
,replace(replace(t1.design_org_id,chr(13),''),chr(10),'') as design_org_id
,replace(replace(t1.prd_mgr_id,chr(13),''),chr(10),'') as prd_mgr_id
,replace(replace(t1.princp_coa_id,chr(13),''),chr(10),'') as princp_coa_id
,replace(replace(t1.profit_loss_coa_id,chr(13),''),chr(10),'') as profit_loss_coa_id
,replace(replace(t1.prd_brand_name,chr(13),''),chr(10),'') as prd_brand_name
,replace(replace(t1.off_flg,chr(13),''),chr(10),'') as off_flg
,replace(replace(t1.branch_feature_prd_flg,chr(13),''),chr(10),'') as branch_feature_prd_flg
,t1.prd_start_dt as prd_start_dt
,t1.prd_pause_sale_dt as prd_pause_sale_dt
,t1.prd_terminate_dt as prd_terminate_dt
,replace(replace(t1.comb_prd_flg,chr(13),''),chr(10),'') as comb_prd_flg
,replace(replace(t1.required_prd_id,chr(13),''),chr(10),'') as required_prd_id
,replace(replace(t1.allow_prd_id,chr(13),''),chr(10),'') as allow_prd_id
,replace(replace(t1.prd_comb_rule,chr(13),''),chr(10),'') as prd_comb_rule
,replace(replace(t1.oper_typ_cd,chr(13),''),chr(10),'') as oper_typ_cd
,replace(replace(t1.allow_adv_redeem_flg,chr(13),''),chr(10),'') as allow_adv_redeem_flg
,replace(replace(t1.blng_prd_line_id,chr(13),''),chr(10),'') as blng_prd_line_id
,replace(replace(t1.blng_prd_grp_id,chr(13),''),chr(10),'') as blng_prd_grp_id
,replace(replace(t1.blng_base_prd_id,chr(13),''),chr(10),'') as blng_base_prd_id
,replace(replace(t1.sale_prd_status_cd,chr(13),''),chr(10),'') as sale_prd_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'PRD_SALE_PRODUCT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PRD_SALE_PRODUCT_H') as etl_task_name 
from ${idl_schema}.hdws_iml_prd_sale_product t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_prd_sale_product_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes