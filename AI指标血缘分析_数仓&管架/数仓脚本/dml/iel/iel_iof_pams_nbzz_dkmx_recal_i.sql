: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_nbzz_dkmx_recal_i
CreateDate: 20250711
FileName:   ${iel_data_path}/pams_nbzz_dkmx_recal.i.${batch_date}.dat
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
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,zhye
,zlbl
,hyye
,hyylj
,hyjlj
,hybnlj
,hynlj
,hyymlj
,hydkje
,zhzlbl
,zlblylj
,zlbljlj
,zlblnlj
,zlblymlj
,khdkje
,khdkye
,replace(replace(t1.khkhbs,chr(13),''),chr(10),'') as khkhbs
,nll
,gxsj
,replace(replace(t1.hxbz,chr(13),''),chr(10),'') as hxbz
,replace(replace(t1.lsdkbs,chr(13),''),chr(10),'') as lsdkbs
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.sfzydk,chr(13),''),chr(10),'') as sfzydk
,replace(replace(t1.fdbptdk,chr(13),''),chr(10),'') as fdbptdk
,recal_dt

from ${iol_schema}.pams_nbzz_dkmx_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_dkmx_recal.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
