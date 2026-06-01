: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_finc_prod_imp_info_h_a
CreateDate: 20220525
FileName:   ${iel_data_path}/prd_finc_prod_imp_info_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.issue_dt as issue_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.cfm_dt as cfm_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t.prod_tot_size as prod_tot_size
,t.lot_tot as lot_tot
,t.td_add_shares as td_add_shares
,t.td_decrs_shares as td_decrs_shares
,t.prod_nv as prod_nv
,t.prod_fac_val as prod_fac_val
,t.prft_cust_ratio as prft_cust_ratio
,replace(replace(t.prft_assign_flg,chr(13),''),chr(10),'') as prft_assign_flg
,replace(replace(t.tran_flg,chr(13),''),chr(10),'') as tran_flg
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.ld_status_cd,chr(13),''),chr(10),'') as ld_status_cd
,t.prod_acm_nv as prod_acm_nv
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_finc_prod_imp_info_h t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_prod_imp_info_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes