: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_sbxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_sbxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.sbrq,chr(13),''),chr(10),'') as sbrq
,replace(replace(t.sbqx,chr(13),''),chr(10),'') as sbqx
,replace(replace(t.sssqq,chr(13),''),chr(10),'') as sssqq
,replace(replace(t.sssqz,chr(13),''),chr(10),'') as sssqz
,replace(replace(t.zsxmmc,chr(13),''),chr(10),'') as zsxmmc
,t.ysx as ysx
,t.jsyj as jsyj
,t.ynse as ynse
,t.yjse as yjse
,t.ybtse as ybtse
,t.jmse as jmse
,replace(replace(t.zfbz_1,chr(13),''),chr(10),'') as zfbz_1
,t.sl_1 as sl_1
,replace(replace(t.sbsxmc,chr(13),''),chr(10),'') as sbsxmc
,replace(replace(t.sbfsmc,chr(13),''),chr(10),'') as sbfsmc
,replace(replace(t.zsfsmc,chr(13),''),chr(10),'') as zsfsmc
,replace(replace(t.zsdlfsmc,chr(13),''),chr(10),'') as zsdlfsmc
,replace(replace(t.zspmmc,chr(13),''),chr(10),'') as zspmmc
,replace(replace(t.jzjtskbz,chr(13),''),chr(10),'') as jzjtskbz
,replace(replace(t.gzlx_mc,chr(13),''),chr(10),'') as gzlx_mc
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_sbxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_sbxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes