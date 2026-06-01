: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifrs_val_cfg_pro_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifrs_val_cfg_pro_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.v_proid,chr(13),''),chr(10),'') as v_proid
,replace(replace(t1.is_account,chr(13),''),chr(10),'') as is_account
from ${iol_schema}.ifrs_val_cfg_pro_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifrs_val_cfg_pro_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes