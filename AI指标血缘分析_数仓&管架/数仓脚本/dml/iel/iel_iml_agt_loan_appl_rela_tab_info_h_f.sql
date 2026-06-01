: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_appl_rela_tab_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_appl_rela_tab_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,rela_amt

from ${iml_schema}.agt_loan_appl_rela_tab_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_rela_tab_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
