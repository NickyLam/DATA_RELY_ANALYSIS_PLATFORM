: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_xyxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_xyxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.jcxx_id as jcxx_id
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,t.jyje as jyje
,t.jyjezb as jyjezb
,replace(replace(t.sssq,chr(13),''),chr(10),'') as sssq
,t.pm as pm
,replace(replace(t.sxybz,chr(13),''),chr(10),'') as sxybz
from iol.ilss_ghb_xyxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_xyxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes