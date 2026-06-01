: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxdx_lxtk_f
CreateDate: 20251107
FileName:   ${iel_data_path}/pams_jxdx_lxtk.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,tjrq
,qdrq
,replace(replace(t1.sjh,chr(13),''),chr(10),'') as sjh
,replace(replace(t1.xnkhh,chr(13),''),chr(10),'') as xnkhh
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.ylkhjylsh,chr(13),''),chr(10),'') as ylkhjylsh
,khrq
,replace(replace(t1.ywlb,chr(13),''),chr(10),'') as ywlb
,replace(replace(t1.khysms,chr(13),''),chr(10),'') as khysms
,replace(replace(t1.zjlx,chr(13),''),chr(10),'') as zjlx
,replace(replace(t1.zjh1,chr(13),''),chr(10),'') as zjh1
,replace(replace(t1.zjh2,chr(13),''),chr(10),'') as zjh2
,replace(replace(t1.xing,chr(13),''),chr(10),'') as xing
,replace(replace(t1.ming,chr(13),''),chr(10),'') as ming
,replace(replace(t1.xm,chr(13),''),chr(10),'') as xm
,replace(replace(t1.xb,chr(13),''),chr(10),'') as xb
,csrq
,replace(replace(t1.gj,chr(13),''),chr(10),'') as gj
,replace(replace(t1.zy,chr(13),''),chr(10),'') as zy
,replace(replace(t1.zyms,chr(13),''),chr(10),'') as zyms
,replace(replace(t1.ssjmsf,chr(13),''),chr(10),'') as ssjmsf
,replace(replace(t1.lxdz,chr(13),''),chr(10),'') as lxdz
,sfzjfzrq
,sfzjyxq
,replace(replace(t1.yyjcjlsh,chr(13),''),chr(10),'') as yyjcjlsh
,replace(replace(t1.pdm,chr(13),''),chr(10),'') as pdm
,replace(replace(t1.cdm,chr(13),''),chr(10),'') as cdm
,replace(replace(t1.ddm,chr(13),''),chr(10),'') as ddm
,replace(replace(t1.ssn,chr(13),''),chr(10),'') as ssn
,replace(replace(t1.ssid,chr(13),''),chr(10),'') as ssid
,replace(replace(t1.jjtgyy,chr(13),''),chr(10),'') as jjtgyy
,replace(replace(t1.jtyy,chr(13),''),chr(10),'') as jtyy
,replace(replace(t1.rjqd,chr(13),''),chr(10),'') as rjqd
,replace(replace(t1.xyhyjg,chr(13),''),chr(10),'') as xyhyjg
,replace(replace(t1.skqdid,chr(13),''),chr(10),'') as skqdid
,replace(replace(t1.skqdmc,chr(13),''),chr(10),'') as skqdmc
,replace(replace(t1.khqjlsh,chr(13),''),chr(10),'') as khqjlsh
,replace(replace(t1.zt,chr(13),''),chr(10),'') as zt
,replace(replace(t1.zhdj,chr(13),''),chr(10),'') as zhdj
,replace(replace(t1.yxq,chr(13),''),chr(10),'') as yxq
,xe
,ljczje
,tkzhye
,zxwhrq
,jyrq

from ${iol_schema}.pams_jxdx_lxtk t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_lxtk.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
