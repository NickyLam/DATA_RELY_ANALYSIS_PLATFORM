: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_finc_prod_imp_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_finc_prod_imp_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cfm_dt as cfm_dt
,t1.prod_id as prod_id
,t1.ta_cd as ta_cd
,t1.prod_tot_size as prod_tot_size
,t1.lot_tot as lot_tot
,t1.td_add_shares as td_add_shares
,t1.td_decrs_shares as td_decrs_shares
,t1.prod_nv as prod_nv
,t1.prod_fac_val as prod_fac_val
,t1.prft_cust_ratio as prft_cust_ratio
,t1.prft_assign_flg as prft_assign_flg
,t1.tran_flg as tran_flg
,t1.status_cd as status_cd
,t1.ld_status_cd as ld_status_cd
,t1.prod_acm_nv as prod_acm_nv
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.issue_dt as issue_dt
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_finc_prod_imp_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_finc_prod_imp_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
