: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_pjjzkhmx_f
CreateDate: 20250307
FileName:   ${iel_data_path}/pams_jxbb_pjjzkhmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.fhdh,chr(13),''),chr(10),'') as fhdh
,replace(replace(t1.fhmc,chr(13),''),chr(10),'') as fhmc
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,cknrj
,ckljsy
,sxfljsy
,dktxljsy
,fhfpsy
,pjjcsy
,nljsy
,replace(replace(t1.sfjzkh,chr(13),''),chr(10),'') as sfjzkh

from ${iol_schema}.pams_jxbb_pjjzkhmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_pjjzkhmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
