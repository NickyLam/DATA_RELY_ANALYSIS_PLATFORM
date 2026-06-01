: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_bill_bus_code_subj_rela_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_bill_bus_code_subj_rela_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,case when trim(t1.bus_code) is null then '-' else t1.bus_code end
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
from ${iml_schema}.ref_bill_bus_code_subj_rela t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bill_bus_code_subj_rela_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes