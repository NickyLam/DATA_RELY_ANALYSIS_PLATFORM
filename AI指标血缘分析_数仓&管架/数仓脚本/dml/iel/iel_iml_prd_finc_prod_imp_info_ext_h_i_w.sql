: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_finc_prod_imp_info_ext_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_finc_prod_imp_info_ext_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.issue_dt as issue_dt 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.cfm_dt as cfm_dt 
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd 
,replace(replace(t1.nv_type_cd,chr(13),''),chr(10),'') as nv_type_cd 
,replace(replace(t1.reg_quota_status_cd,chr(13),''),chr(10),'') as reg_quota_status_cd 
,replace(replace(t1.turn_trust_status_cd,chr(13),''),chr(10),'') as turn_trust_status_cd 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.affi_flg,chr(13),''),chr(10),'') as affi_flg 
,replace(replace(t1.indv_issue_way_cd,chr(13),''),chr(10),'') as indv_issue_way_cd 
,replace(replace(t1.org_issue_way_cd,chr(13),''),chr(10),'') as org_issue_way_cd 
,t1.divd_dt as divd_dt 
,t1.eqty_rgst_dt as eqty_rgst_dt 
,t1.ex_righ_dt as ex_righ_dt 
,replace(replace(t1.subscr_way_cd,chr(13),''),chr(10),'') as subscr_way_cd 
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd 
,t1.curr_fund_year_yld_rat as curr_fund_year_yld_rat 
,replace(replace(t1.allow_deflt_redem_flg,chr(13),''),chr(10),'') as allow_deflt_redem_flg 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,t1.quar_aual_yld as quar_aual_yld 
,replace(replace(t1.quar_aual_yld_pm_cd,chr(13),''),chr(10),'') as quar_aual_yld_pm_cd 
,t1.ped_yld_rat as ped_yld_rat 
,replace(replace(t1.ped_yld_rat_pm_cd,chr(13),''),chr(10),'') as ped_yld_rat_pm_cd 
,t1.am_nv_dt as am_nv_dt 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_finc_prod_imp_info_ext_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_prod_imp_info_ext_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes