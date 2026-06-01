: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_loan_guar_cont_rela_f
CreateDate: 20231113
FileName:   ${iel_data_path}/crps_cmm_unite_wl_loan_guar_cont_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
etl_dt
,t1.lp_id as lp_id
,t1.loan_cont_id as loan_cont_id
,t1.guar_cont_id as guar_cont_id
,t1.col_id as col_id
,t1.guar_way_cd as guar_way_cd
,t1.guar_curr_cd as guar_curr_cd
,t1.guar_cont_status_cd as guar_cont_status_cd
,t1.guartor_cust_id as guartor_cust_id
,t1.guartor_name as guartor_name
,t1.guar_effect_dt as guar_effect_dt
,t1.guar_exp_dt as guar_exp_dt

from ${idl_schema}.crps_cmm_unite_wl_loan_guar_cont_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_loan_guar_cont_rela.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
