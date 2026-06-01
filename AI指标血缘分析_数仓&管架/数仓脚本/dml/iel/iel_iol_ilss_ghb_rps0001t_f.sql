: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_rps0001t_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_rps0001t.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.queryname,chr(13),''),chr(10),'') as queryname
,replace(replace(t.querycertificateno,chr(13),''),chr(10),'') as querycertificateno
,replace(replace(t.ywlx,chr(13),''),chr(10),'') as ywlx
,replace(replace(t.isrelated,chr(13),''),chr(10),'') as isrelated
from iol.ilss_ghb_rps0001t t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_rps0001t.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes