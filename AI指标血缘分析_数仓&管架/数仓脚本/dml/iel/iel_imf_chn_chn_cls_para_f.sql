: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_chn_chn_cls_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/chn_chn_cls_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.chn_cls_cd,chr(13),''),chr(10),'') as chn_cls_cd
,replace(replace(t1.chn_cls_descb,chr(13),''),chr(10),'') as chn_cls_descb
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.chn_chn_cls_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/chn_chn_cls_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes