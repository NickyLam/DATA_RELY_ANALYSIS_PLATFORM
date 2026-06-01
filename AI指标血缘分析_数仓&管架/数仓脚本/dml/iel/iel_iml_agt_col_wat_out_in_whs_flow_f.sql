: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_col_wat_out_in_whs_flow_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_col_wat_out_in_whs_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.flow_status_cd,chr(13),''),chr(10),'') as flow_status_cd
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.subor_org_id,chr(13),''),chr(10),'') as subor_org_id

from ${iml_schema}.agt_col_wat_out_in_whs_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_wat_out_in_whs_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
