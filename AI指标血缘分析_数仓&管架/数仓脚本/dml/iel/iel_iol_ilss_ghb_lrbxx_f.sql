: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_lrbxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_lrbxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.sbrq,chr(13),''),chr(10),'') as sbrq
,replace(replace(t.sssqq,chr(13),''),chr(10),'') as sssqq
,replace(replace(t.sssqz,chr(13),''),chr(10),'') as sssqz
,replace(replace(t.xm,chr(13),''),chr(10),'') as xm
,replace(replace(t.mc,chr(13),''),chr(10),'') as mc
,t.bqje as bqje
,t.bys as bys
,t.sqje as sqje
,replace(replace(t.bblx,chr(13),''),chr(10),'') as bblx
from iol.ilss_ghb_lrbxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_lrbxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes