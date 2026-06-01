: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_lcmx_i
CreateDate: 20251013
FileName:   ${iel_data_path}/pams_nbzz_lcmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zhye
,zlbl
,hyye
,hyylj
,hyjlj
,hybnlj
,hynlj
,hyymlj
,zlblylj
,zlbljlj
,zlblnlj
,zlblymlj
,gxsj
,zhnrjye
,zhjrjye
,zhyrjye
,replace(replace(t1.kzhlcbz,chr(13),''),chr(10),'') as kzhlcbz
,replace(replace(t1.ztbz,chr(13),''),chr(10),'') as ztbz

from ${iol_schema}.pams_nbzz_lcmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_lcmx.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
