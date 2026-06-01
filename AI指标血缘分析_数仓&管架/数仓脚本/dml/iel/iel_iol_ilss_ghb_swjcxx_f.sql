: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_swjcxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_swjcxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.aydjrq,chr(13),''),chr(10),'') as aydjrq
,replace(replace(t.ajlxmc,chr(13),''),chr(10),'') as ajlxmc
,replace(replace(t.wgwzlxdm,chr(13),''),chr(10),'') as wgwzlxdm
,replace(replace(t.wgwzlxmc,chr(13),''),chr(10),'') as wgwzlxmc
,replace(replace(t.jclxmc,chr(13),''),chr(10),'') as jclxmc
,replace(replace(t.jcztmc,chr(13),''),chr(10),'') as jcztmc
,replace(replace(t.ajclyjmc,chr(13),''),chr(10),'') as ajclyjmc
from iol.ilss_ghb_swjcxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_swjcxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes