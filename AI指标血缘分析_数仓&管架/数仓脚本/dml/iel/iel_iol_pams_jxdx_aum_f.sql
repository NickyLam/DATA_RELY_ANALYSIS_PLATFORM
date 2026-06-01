: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_aum_f
CreateDate: 20260330
FileName:   ${iel_data_path}/pams_jxdx_aum.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khzt,chr(13),''),chr(10),'') as khzt
,xhrq
,aumye
,aumyrj
,aumjrj
,aumnrj
,tjrq
,replace(replace(t1.lskhbz1,chr(13),''),chr(10),'') as lskhbz1

from ${iol_schema}.pams_jxdx_aum t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_aum.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
