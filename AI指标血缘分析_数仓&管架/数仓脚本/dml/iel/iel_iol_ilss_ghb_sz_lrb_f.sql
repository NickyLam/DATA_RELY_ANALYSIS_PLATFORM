: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_lrb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_lrb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.nsrmc,chr(13),''),chr(10),'') as nsrmc
,replace(replace(t.cwbblxmc,chr(13),''),chr(10),'') as cwbblxmc
,replace(replace(t.lrrq,chr(13),''),chr(10),'') as lrrq
,replace(replace(t.ssqq,chr(13),''),chr(10),'') as ssqq
,replace(replace(t.ssqz,chr(13),''),chr(10),'') as ssqz
,replace(replace(t.hmc,chr(13),''),chr(10),'') as hmc
,t.ewbhxh as ewbhxh
,t.bqje as bqje
,t.sqje as sqje
,t.bys as bys
,replace(replace(t.xgrq,chr(13),''),chr(10),'') as xgrq
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_lrb t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_lrb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes