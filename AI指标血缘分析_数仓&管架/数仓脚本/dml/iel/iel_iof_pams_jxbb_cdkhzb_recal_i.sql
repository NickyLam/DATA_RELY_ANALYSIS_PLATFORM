: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_cdkhzb_recal_i
CreateDate: 20250711
FileName:   ${iel_data_path}/pams_jxbb_cdkhzb_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,recal_dt
,khdxdh
,pm
,replace(replace(t1.xm,chr(13),''),chr(10),'') as xm
,ye
,yrj
,nrj
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz

from ${iol_schema}.pams_jxbb_cdkhzb_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_cdkhzb_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
