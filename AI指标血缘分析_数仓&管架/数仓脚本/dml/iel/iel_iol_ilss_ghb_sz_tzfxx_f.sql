: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_tzfxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_tzfxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.tzfmc,chr(13),''),chr(10),'') as tzfmc
,replace(replace(t.tzfjjxzmc,chr(13),''),chr(10),'') as tzfjjxzmc
,replace(replace(t.tzbl,chr(13),''),chr(10),'') as tzbl
,replace(replace(t.tzje,chr(13),''),chr(10),'') as tzje
,t.fpbl as fpbl
,replace(replace(t.tzfzjzlmc,chr(13),''),chr(10),'') as tzfzjzlmc
,replace(replace(t.tzfzjhm,chr(13),''),chr(10),'') as tzfzjhm
,replace(replace(t.dz,chr(13),''),chr(10),'') as dz
,replace(replace(t.yxqq,chr(13),''),chr(10),'') as yxqq
,replace(replace(t.yxqz,chr(13),''),chr(10),'') as yxqz
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_tzfxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_tzfxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes