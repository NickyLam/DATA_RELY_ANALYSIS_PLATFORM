: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_xydj_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_xydj.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.xydj,chr(13),''),chr(10),'') as xydj
,replace(replace(t.pjjg,chr(13),''),chr(10),'') as pjjg
,replace(replace(t.pdnd,chr(13),''),chr(10),'') as pdnd
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_xydj t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_xydj.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes