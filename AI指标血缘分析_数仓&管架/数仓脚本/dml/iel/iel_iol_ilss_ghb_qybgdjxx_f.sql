: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_qybgdjxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_qybgdjxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.bgrq,chr(13),''),chr(10),'') as bgrq
,replace(replace(t.bgxm,chr(13),''),chr(10),'') as bgxm
,replace(replace(t.bgqnr,chr(13),''),chr(10),'') as bgqnr
,replace(replace(t.bghnr,chr(13),''),chr(10),'') as bghnr
from iol.ilss_ghb_qybgdjxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_qybgdjxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes