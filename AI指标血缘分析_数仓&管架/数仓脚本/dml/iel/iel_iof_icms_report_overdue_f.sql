: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_report_overdue_f
CreateDate: 20240906
FileName:   ${iel_data_path}/icms_report_overdue.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.xh,chr(13),''),chr(10),'') as xh
,replace(replace(t1.pcrq,chr(13),''),chr(10),'') as pcrq
,replace(replace(t1.lb,chr(13),''),chr(10),'') as lb
,replace(replace(t1.bjylxzdyqts,chr(13),''),chr(10),'') as bjylxzdyqts
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.jbjg,chr(13),''),chr(10),'') as jbjg
,replace(replace(t1.ssjt,chr(13),''),chr(10),'') as ssjt
,replace(replace(t1.ywpz,chr(13),''),chr(10),'') as ywpz
,replace(replace(t1.zhye,chr(13),''),chr(10),'') as zhye
,replace(replace(t1.zhckye,chr(13),''),chr(10),'') as zhckye
,replace(replace(t1.yqywye,chr(13),''),chr(10),'') as yqywye
,replace(replace(t1.wjfl,chr(13),''),chr(10),'') as wjfl
,replace(replace(t1.yqqsr,chr(13),''),chr(10),'') as yqqsr
,replace(replace(t1.bjzdyqts,chr(13),''),chr(10),'') as bjzdyqts
,replace(replace(t1.lxzdyqts,chr(13),''),chr(10),'') as lxzdyqts
,replace(replace(t1.yqbjje,chr(13),''),chr(10),'') as yqbjje
,replace(replace(t1.yqlxje,chr(13),''),chr(10),'') as yqlxje
,replace(replace(t1.yswslx,chr(13),''),chr(10),'') as yswslx
,replace(replace(t1.faxje,chr(13),''),chr(10),'') as faxje
,replace(replace(t1.fuxje,chr(13),''),chr(10),'') as fuxje
,replace(replace(t1.hj,chr(13),''),chr(10),'') as hj
,replace(replace(t1.yqdqtrq,chr(13),''),chr(10),'') as yqdqtrq
,replace(replace(t1.yqdsltrq,chr(13),''),chr(10),'') as yqdsltrq
,replace(replace(t1.yqdjltrq,chr(13),''),chr(10),'') as yqdjltrq
,replace(replace(t1.yqdeqltrq,chr(13),''),chr(10),'') as yqdeqltrq
,replace(replace(t1.yqdslltrq,chr(13),''),chr(10),'') as yqdslltrq
,replace(replace(t1.sjrq,chr(13),''),chr(10),'') as sjrq
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.ylcs1,chr(13),''),chr(10),'') as ylcs1
,replace(replace(t1.ylcs2,chr(13),''),chr(10),'') as ylcs2
,replace(replace(t1.ylcs3,chr(13),''),chr(10),'') as ylcs3
,replace(replace(t1.ylcs4,chr(13),''),chr(10),'') as ylcs4
,replace(replace(t1.ylcs5,chr(13),''),chr(10),'') as ylcs5
,replace(replace(t1.ylcs6,chr(13),''),chr(10),'') as ylcs6
,replace(replace(t1.ylcs7,chr(13),''),chr(10),'') as ylcs7
,replace(replace(t1.ylcs8,chr(13),''),chr(10),'') as ylcs8
,replace(replace(t1.ylcs9,chr(13),''),chr(10),'') as ylcs9
,replace(replace(t1.ylcs10,chr(13),''),chr(10),'') as ylcs10
,replace(replace(t1.ylcs11,chr(13),''),chr(10),'') as ylcs11
,replace(replace(t1.ylcs12,chr(13),''),chr(10),'') as ylcs12
,replace(replace(t1.ylcs13,chr(13),''),chr(10),'') as ylcs13
,replace(replace(t1.ylcs14,chr(13),''),chr(10),'') as ylcs14
,replace(replace(t1.ylcs15,chr(13),''),chr(10),'') as ylcs15
,replace(replace(t1.ylcs16,chr(13),''),chr(10),'') as ylcs16
,replace(replace(t1.ylcs17,chr(13),''),chr(10),'') as ylcs17
,replace(replace(t1.ylcs18,chr(13),''),chr(10),'') as ylcs18
,replace(replace(t1.ylcs19,chr(13),''),chr(10),'') as ylcs19
,replace(replace(t1.ylcs20,chr(13),''),chr(10),'') as ylcs20

from ${iol_schema}.icms_report_overdue t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_report_overdue.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
