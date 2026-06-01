: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_qywfwzxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_qywfwzxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.djrq,chr(13),''),chr(10),'') as djrq
,replace(replace(t.zywfwzss,chr(13),''),chr(10),'') as zywfwzss
,replace(replace(t.zywfwzsddm,chr(13),''),chr(10),'') as zywfwzsddm
,replace(replace(t.zywfwzsdmc,chr(13),''),chr(10),'') as zywfwzsdmc
,replace(replace(t.wfwzlxdm,chr(13),''),chr(10),'') as wfwzlxdm
,replace(replace(t.wfwzlxmc,chr(13),''),chr(10),'') as wfwzlxmc
,replace(replace(t.wfwzztmc,chr(13),''),chr(10),'') as wfwzztmc
,replace(replace(t.clcfjdrq,chr(13),''),chr(10),'') as clcfjdrq
,replace(replace(t.clbf,chr(13),''),chr(10),'') as clbf
,replace(replace(t.larq,chr(13),''),chr(10),'') as larq
,replace(replace(t.xgzt,chr(13),''),chr(10),'') as xgzt
from iol.ilss_ghb_qywfwzxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_qywfwzxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes