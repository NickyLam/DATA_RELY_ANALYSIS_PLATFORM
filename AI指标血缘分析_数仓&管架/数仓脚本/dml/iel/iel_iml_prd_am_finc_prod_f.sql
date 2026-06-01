: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_finc_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_am_finc_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id 
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id 
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd 
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr 
,replace(replace(t1.prod_fname,chr(13),''),chr(10),'') as prod_fname 
,replace(replace(t1.prft_mode_cd,chr(13),''),chr(10),'') as prft_mode_cd 
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id 
,replace(replace(t1.issue_curr_cd,chr(13),''),chr(10),'') as issue_curr_cd 
,replace(replace(t1.tran_caln_cd,chr(13),''),chr(10),'') as tran_caln_cd 
,replace(replace(t1.coll_way_cd,chr(13),''),chr(10),'') as coll_way_cd 
,replace(replace(t1.oper_mode_cd,chr(13),''),chr(10),'') as oper_mode_cd 
,replace(replace(t1.entr_way_cd,chr(13),''),chr(10),'') as entr_way_cd 
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id 
,replace(replace(t1.trustee_id,chr(13),''),chr(10),'') as trustee_id 
,t1.value_dt as value_dt 
,t1.exp_dt as exp_dt 
,t1.prod_tenor as prod_tenor 
,t1.actl_exp_dt as actl_exp_dt 
,t1.liqd_dt as liqd_dt 
,replace(replace(t1.subtn_flg,chr(13),''),chr(10),'') as subtn_flg 
,replace(replace(t1.subtn_claus,chr(13),''),chr(10),'') as subtn_claus 
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id 
,replace(replace(t1.sell_dept_id,chr(13),''),chr(10),'') as sell_dept_id 
,t1.purch_cfm_tenor as purch_cfm_tenor 
,t1.redem_cfm_tenor as redem_cfm_tenor 
,replace(replace(t1.inv_port_id,chr(13),''),chr(10),'') as inv_port_id 
,replace(replace(t1.prod_rgst_code,chr(13),''),chr(10),'') as prod_rgst_code 
,replace(replace(t1.ped_prod_flg,chr(13),''),chr(10),'') as ped_prod_flg 
,replace(replace(t1.layered_flg,chr(13),''),chr(10),'') as layered_flg 
,replace(replace(t1.layered_type_cd,chr(13),''),chr(10),'') as layered_type_cd 
,replace(replace(t1.invest_char_type_cd,chr(13),''),chr(10),'') as invest_char_type_cd 
,replace(replace(t1.prft_type_cd,chr(13),''),chr(10),'') as prft_type_cd 
,replace(replace(t1.issue_status_cd,chr(13),''),chr(10),'') as issue_status_cd 
,replace(replace(t1.cash_mgmt_flg,chr(13),''),chr(10),'') as cash_mgmt_flg 
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd 
,replace(replace(t1.proc_mode_cd,chr(13),''),chr(10),'') as proc_mode_cd 
,replace(replace(t1.exlus_prod_flg,chr(13),''),chr(10),'') as exlus_prod_flg 
,replace(replace(t1.ped_days,chr(13),''),chr(10),'') as ped_days 
,replace(replace(t1.prod_mgr_name,chr(13),''),chr(10),'') as prod_mgr_name 
,t1.init_create_tm as init_create_tm 
,t1.init_update_tm as init_update_tm 
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_am_finc_prod t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_finc_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes