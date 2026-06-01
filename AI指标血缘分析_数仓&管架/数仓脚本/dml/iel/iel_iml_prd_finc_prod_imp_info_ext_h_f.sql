: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_finc_prod_imp_info_ext_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_finc_prod_imp_info_ext_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,issue_dt
,replace(replace(lp_id,chr(13),''),chr(10),'')
,cfm_dt
,replace(replace(prod_cd,chr(13),''),chr(10),'')
,replace(replace(nv_type_cd,chr(13),''),chr(10),'')
,replace(replace(reg_quota_status_cd,chr(13),''),chr(10),'')
,replace(replace(turn_trust_status_cd,chr(13),''),chr(10),'')
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,replace(replace(affi_flg,chr(13),''),chr(10),'')
,replace(replace(indv_issue_way_cd,chr(13),''),chr(10),'')
,replace(replace(org_issue_way_cd,chr(13),''),chr(10),'')
,divd_dt
,eqty_rgst_dt
,ex_righ_dt
,replace(replace(subscr_way_cd,chr(13),''),chr(10),'')
,replace(replace(charge_way_cd,chr(13),''),chr(10),'')
,curr_fund_year_yld_rat
,replace(replace(allow_deflt_redem_flg,chr(13),''),chr(10),'')
,replace(replace(ta_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,quar_aual_yld
,replace(replace(quar_aual_yld_pm_cd,chr(13),''),chr(10),'')
,ped_yld_rat
,replace(replace(ped_yld_rat_pm_cd,chr(13),''),chr(10),'')
,am_nv_dt

from ${iml_schema}.prd_finc_prod_imp_info_ext_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_prod_imp_info_ext_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
