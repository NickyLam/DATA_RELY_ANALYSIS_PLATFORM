: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_loan_guar_cont_rela_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_loan_guar_cont_rela_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
,replace(replace(t.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t.guar_cont_status_cd,chr(13),''),chr(10),'') as guar_cont_status_cd
,replace(replace(t.guartor_name,chr(13),''),chr(10),'') as guartor_name
,t.guar_start_dt as guar_start_dt
,t.guar_exp_dt as guar_exp_dt
from ${icl_schema}.cmm_loan_guar_cont_rela t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_guar_cont_rela_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes