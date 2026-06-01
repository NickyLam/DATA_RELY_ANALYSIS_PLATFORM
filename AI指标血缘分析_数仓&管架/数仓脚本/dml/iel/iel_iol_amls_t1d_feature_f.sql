: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t1d_feature_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t1d_feature.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.fetr_id,chr(13),''),chr(10),'') as fetr_id
    ,replace(replace(t.fetr_name,chr(13),''),chr(10),'') as fetr_name
    ,replace(replace(t.fetr_type,chr(13),''),chr(10),'') as fetr_type
    ,replace(replace(t.pbc_tcr,chr(13),''),chr(10),'') as pbc_tcr
    ,replace(replace(t.fetr_catg,chr(13),''),chr(10),'') as fetr_catg
    ,replace(replace(t.exec_mode,chr(13),''),chr(10),'') as exec_mode
    ,replace(replace(t.is_prop,chr(13),''),chr(10),'') as is_prop
    ,replace(replace(t.is_net,chr(13),''),chr(10),'') as is_net
    ,replace(replace(t.is_case,chr(13),''),chr(10),'') as is_case
    ,replace(replace(t.crime_type,chr(13),''),chr(10),'') as crime_type
    ,replace(replace(t.fetr_desc,chr(13),''),chr(10),'') as fetr_desc
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.is_valid,chr(13),''),chr(10),'') as is_valid
    ,replace(replace(t.fetr_s_type,chr(13),''),chr(10),'') as fetr_s_type
from iol.amls_t1d_feature t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1d_feature.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes