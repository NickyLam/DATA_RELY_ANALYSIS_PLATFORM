: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_sz_zcfzb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_sz_zcfzb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.shxydm,chr(13),''),chr(10),'') as shxydm
,replace(replace(t.nsrsbh,chr(13),''),chr(10),'') as nsrsbh
,replace(replace(t.cwbblxmc,chr(13),''),chr(10),'') as cwbblxmc
,replace(replace(t.lrrq,chr(13),''),chr(10),'') as lrrq
,replace(replace(t.skssqq,chr(13),''),chr(10),'') as skssqq
,replace(replace(t.skssqz,chr(13),''),chr(10),'') as skssqz
,replace(replace(t.zcxmmc,chr(13),''),chr(10),'') as zcxmmc
,replace(replace(t.ewbhxh,chr(13),''),chr(10),'') as ewbhxh
,t.qmye_zc as qmye_zc
,t.ncye_zc as ncye_zc
,replace(replace(t.xgrq,chr(13),''),chr(10),'') as xgrq
,t.ncye_qy as ncye_qy
,t.qmye_qy as qmye_qy
,replace(replace(t.qyxmmc,chr(13),''),chr(10),'') as qyxmmc
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_sz_zcfzb t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_sz_zcfzb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes