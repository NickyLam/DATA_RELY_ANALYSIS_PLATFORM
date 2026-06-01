: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ref_bill_bus_code_subj_rela_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ref_bill_bus_code_subj_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.bus_code as bus_code
,t1.amt_type_cd as amt_type_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.subj_id as subj_id
,t1.subj_name as subj_name

from ${idl_schema}.oass_ref_bill_bus_code_subj_rela t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ref_bill_bus_code_subj_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
