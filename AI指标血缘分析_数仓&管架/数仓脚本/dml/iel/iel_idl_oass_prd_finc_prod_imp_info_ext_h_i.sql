: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_finc_prod_imp_info_ext_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_finc_prod_imp_info_ext_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cfm_dt as cfm_dt
,t1.prod_cd as prod_cd
,t1.nv_type_cd as nv_type_cd
,t1.reg_quota_status_cd as reg_quota_status_cd
,t1.turn_trust_status_cd as turn_trust_status_cd
,t1.curr_cd as curr_cd
,t1.affi_flg as affi_flg
,t1.indv_issue_way_cd as indv_issue_way_cd
,t1.org_issue_way_cd as org_issue_way_cd
,t1.divd_dt as divd_dt
,t1.eqty_rgst_dt as eqty_rgst_dt
,t1.ex_righ_dt as ex_righ_dt
,t1.subscr_way_cd as subscr_way_cd
,t1.charge_way_cd as charge_way_cd
,t1.curr_fund_year_yld_rat as curr_fund_year_yld_rat
,t1.allow_deflt_redem_flg as allow_deflt_redem_flg
,t1.ta_cd as ta_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.quar_aual_yld as quar_aual_yld
,t1.quar_aual_yld_pm_cd as quar_aual_yld_pm_cd
,t1.ped_yld_rat as ped_yld_rat
,t1.ped_yld_rat_pm_cd as ped_yld_rat_pm_cd
,t1.am_nv_dt as am_nv_dt
,t1.issue_dt as issue_dt
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_finc_prod_imp_info_ext_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_finc_prod_imp_info_ext_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
