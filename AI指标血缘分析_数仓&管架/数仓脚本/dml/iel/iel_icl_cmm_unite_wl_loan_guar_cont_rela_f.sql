: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_unite_wl_loan_guar_cont_rela_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cmm_unite_wl_loan_guar_cont_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t1.guar_cont_status_cd,chr(13),''),chr(10),'') as guar_cont_status_cd
,replace(replace(t1.guartor_cust_id,chr(13),''),chr(10),'') as guartor_cust_id
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,guar_effect_dt
,guar_exp_dt

from ${icl_schema}.cmm_unite_wl_loan_guar_cont_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_unite_wl_loan_guar_cont_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
