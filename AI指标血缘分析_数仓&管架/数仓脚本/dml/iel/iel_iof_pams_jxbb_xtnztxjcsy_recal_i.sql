: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_xtnztxjcsy_recal_i
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxbb_xtnztxjcsy_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,recal_dt
,tjrq
,replace(replace(t1.pjhm,chr(13),''),chr(10),'') as pjhm
,replace(replace(t1.zpqj,chr(13),''),chr(10),'') as zpqj
,replace(replace(t1.gsjg,chr(13),''),chr(10),'') as gsjg
,replace(replace(t1.fhmc,chr(13),''),chr(10),'') as fhmc
,jgkhdxdh
,pmje
,pjjxdqr
,xtrmcr
,txll
,mclv
,jcsr
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc

from ${iol_schema}.pams_jxbb_xtnztxjcsy_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_xtnztxjcsy_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
