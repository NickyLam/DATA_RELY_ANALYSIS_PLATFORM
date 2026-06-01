: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_core_ova_flow_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_core_ova_flow_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.prpery_tran_flow_num,chr(13),''),chr(10),'') as prpery_tran_flow_num
from iml.evt_core_ova_flow_rela t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_core_ova_flow_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes