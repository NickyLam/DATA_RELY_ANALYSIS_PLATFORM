: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_tx_day_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_tx_day_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tx_dt
,replace(replace(t1.rela_id,chr(13),''),chr(10),'') as rela_id
,replace(replace(t1.dt_type_cd,chr(13),''),chr(10),'') as dt_type_cd

from ${iml_schema}.ref_tx_day_para t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_tx_day_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
