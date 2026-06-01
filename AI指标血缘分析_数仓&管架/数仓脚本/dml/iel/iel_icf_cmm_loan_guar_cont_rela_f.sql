: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_loan_guar_cont_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_loan_guar_cont_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_cont_status_cd,chr(13),''),chr(10),'') as guar_cont_status_cd
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,t1.guar_start_dt as guar_start_dt
,t1.guar_exp_dt as guar_exp_dt
,replace(replace(t1.pri_contr_type_cd,chr(13),''),chr(10),'') as pri_contr_type_cd
,t1.guar_amt as guar_amt
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
from ${icl_schema}.cmm_loan_guar_cont_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_guar_cont_rela.f.${batch_date}.dat" \
        charset=utf8
        safe=yes