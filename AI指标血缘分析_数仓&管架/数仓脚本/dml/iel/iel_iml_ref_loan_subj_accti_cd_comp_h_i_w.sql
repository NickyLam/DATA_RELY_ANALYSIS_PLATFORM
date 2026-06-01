: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_loan_subj_accti_cd_comp_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_loan_subj_accti_cd_comp_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t.accti_code,chr(13),''),chr(10),'') as accti_code
,replace(replace(t.provi_flg,chr(13),''),chr(10),'') as provi_flg
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_loan_subj_accti_cd_comp_h t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_loan_subj_accti_cd_comp_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes