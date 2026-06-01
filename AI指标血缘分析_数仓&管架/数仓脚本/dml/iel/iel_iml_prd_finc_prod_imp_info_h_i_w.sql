: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_finc_prod_imp_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_finc_prod_imp_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.issue_dt as issue_dt 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,t1.cfm_dt as cfm_dt 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,t1.prod_tot_size as prod_tot_size 
,t1.lot_tot as lot_tot 
,t1.td_add_shares as td_add_shares 
,t1.td_decrs_shares as td_decrs_shares 
,t1.prod_nv as prod_nv 
,t1.prod_fac_val as prod_fac_val 
,t1.prft_cust_ratio as prft_cust_ratio 
,replace(replace(t1.prft_assign_flg,chr(13),''),chr(10),'') as prft_assign_flg 
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg 
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd 
,replace(replace(t1.ld_status_cd,chr(13),''),chr(10),'') as ld_status_cd 
,t1.prod_acm_nv as prod_acm_nv 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_finc_prod_imp_info_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_prod_imp_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes