: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_am_finc_prod_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_am_finc_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.std_prod_id as std_prod_id
,t1.src_prod_id as src_prod_id
,t1.prod_cate_cd as prod_cate_cd
,t1.prod_abbr as prod_abbr
,t1.prod_fname as prod_fname
,t1.prft_mode_cd as prft_mode_cd
,t1.finc_prod_id as finc_prod_id
,t1.issue_curr_cd as issue_curr_cd
,t1.tran_caln_cd as tran_caln_cd
,t1.coll_way_cd as coll_way_cd
,t1.oper_mode_cd as oper_mode_cd
,t1.entr_way_cd as entr_way_cd
,t1.csner_id as csner_id
,t1.trustee_id as trustee_id
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.prod_tenor as prod_tenor
,t1.actl_exp_dt as actl_exp_dt
,t1.liqd_dt as liqd_dt
,t1.subtn_flg as subtn_flg
,t1.subtn_claus as subtn_claus
,t1.super_prod_id as super_prod_id
,t1.sell_dept_id as sell_dept_id
,t1.purch_cfm_tenor as purch_cfm_tenor
,t1.redem_cfm_tenor as redem_cfm_tenor
,t1.inv_port_id as inv_port_id
,t1.prod_rgst_code as prod_rgst_code
,t1.ped_prod_flg as ped_prod_flg
,t1.layered_flg as layered_flg
,t1.layered_type_cd as layered_type_cd
,t1.invest_char_type_cd as invest_char_type_cd
,t1.prft_type_cd as prft_type_cd
,t1.issue_status_cd as issue_status_cd
,t1.cash_mgmt_flg as cash_mgmt_flg
,t1.risk_level_cd as risk_level_cd
,t1.proc_mode_cd as proc_mode_cd
,t1.exlus_prod_flg as exlus_prod_flg
,t1.ped_days as ped_days
,t1.prod_mgr_name as prod_mgr_name
,t1.init_create_tm as init_create_tm
,t1.init_update_tm as init_update_tm
,t1.tenor_type_cd as tenor_type_cd
,t1.prod_seri_cd as prod_seri_cd
,t1.prod_cls_cd as prod_cls_cd
,t1.exlus_ibank_org_id as exlus_ibank_org_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.prod_id as prod_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_am_finc_prod t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_am_finc_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
