: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zfldspd_zjb_f
CreateDate: 20250513
FileName:   ${iel_data_path}/pams_jxbb_zfldspd_zjb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,hykhdxdh
,jgkhdxdh
,replace(replace(t1.ldpz,chr(13),''),chr(10),'') as ldpz
,replace(replace(t1.zqdm,chr(13),''),chr(10),'') as zqdm
,replace(replace(t1.zqmc,chr(13),''),chr(10),'') as zqmc
,zqpmll
,tzsyl
,tzje
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.tzfs,chr(13),''),chr(10),'') as tzfs
,replace(replace(t1.dyckzh,chr(13),''),chr(10),'') as dyckzh
,replace(replace(t1.xnh,chr(13),''),chr(10),'') as xnh
,tjrq
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,zyr
,dqr
,ckje
,replace(replace(t1.zyzqlx,chr(13),''),chr(10),'') as zyzqlx
,zyzqje
,replace(replace(t1.spzt,chr(13),''),chr(10),'') as spzt
,replace(replace(t1.spdh,chr(13),''),chr(10),'') as spdh
,tzsj
,replace(replace(t1.ldywlx,chr(13),''),chr(10),'') as ldywlx
,replace(replace(t1.fsfs,chr(13),''),chr(10),'') as fsfs
,tzrq
,sxrq
,replace(replace(t1.sjzt,chr(13),''),chr(10),'') as sjzt
,replace(replace(t1.taskid,chr(13),''),chr(10),'') as taskid
,auditid
,jsrq
,replace(replace(t1.hth,chr(13),''),chr(10),'') as hth

from ${iol_schema}.pams_jxbb_zfldspd_zjb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zfldspd_zjb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
