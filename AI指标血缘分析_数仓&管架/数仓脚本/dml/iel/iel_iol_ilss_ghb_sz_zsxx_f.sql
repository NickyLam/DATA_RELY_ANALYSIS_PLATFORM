: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_zsxx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_zsxx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.ssqq,chr(13),''),chr(10),'') as ssqq
,replace(replace(t.ssqz,chr(13),''),chr(10),'') as ssqz
,replace(replace(t.jkqx,chr(13),''),chr(10),'') as jkqx
,replace(replace(t.yjkqx,chr(13),''),chr(10),'') as yjkqx
,t.ybtse as ybtse
,t.jsyj as jsyj
,t.kssl as kssl
,t.ynse as ynse
,t.jmse as jmse
,t.yjse as yjse
,t.sl_1 as sl_1
,replace(replace(t.zsfsmc,chr(13),''),chr(10),'') as zsfsmc
,replace(replace(t.sksxmc,chr(13),''),chr(10),'') as sksxmc
,replace(replace(t.sbfsmc,chr(13),''),chr(10),'') as sbfsmc
,replace(replace(t.zsdlfsmc,chr(13),''),chr(10),'') as zsdlfsmc
,replace(replace(t.sbsxmc_1,chr(13),''),chr(10),'') as sbsxmc_1
,replace(replace(t.zsxmmc,chr(13),''),chr(10),'') as zsxmmc
,replace(replace(t.zspmmc,chr(13),''),chr(10),'') as zspmmc
,replace(replace(t.zszmmc,chr(13),''),chr(10),'') as zszmmc
,replace(replace(t.cbsxmc,chr(13),''),chr(10),'') as cbsxmc
,replace(replace(t.skcllxmc,chr(13),''),chr(10),'') as skcllxmc
,replace(replace(t.czlxmc,chr(13),''),chr(10),'') as czlxmc
,replace(replace(t.tzlxmc,chr(13),''),chr(10),'') as tzlxmc
,replace(replace(t.skzlmc,chr(13),''),chr(10),'') as skzlmc
,replace(replace(t.yjskztmc,chr(13),''),chr(10),'') as yjskztmc
,replace(replace(t.yzpzzlmc,chr(13),''),chr(10),'') as yzpzzlmc
,replace(replace(t.nssbrq,chr(13),''),chr(10),'') as nssbrq
,replace(replace(t.yzfsrq,chr(13),''),chr(10),'') as yzfsrq
,replace(replace(t.yzgsrq,chr(13),''),chr(10),'') as yzgsrq
,replace(replace(t.kjjzrq,chr(13),''),chr(10),'') as kjjzrq
,replace(replace(t.yzclrq,chr(13),''),chr(10),'') as yzclrq
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_zsxx t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_zsxx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes