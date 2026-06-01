: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_gsdkftpmx_f
CreateDate: 20260318
FileName:   ${iel_data_path}/pams_jxbb_gsdkftpmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khm,chr(13),''),chr(10),'') as khm
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,khjgkhdxdh
,replace(replace(t1.khjgh,chr(13),''),chr(10),'') as khjgh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,ssjgkhdxdh
,replace(replace(t1.ssjgh,chr(13),''),chr(10),'') as ssjgh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh
,replace(replace(t1.khjlxm,chr(13),''),chr(10),'') as khjlxm
,fpbl
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.jjzt,chr(13),''),chr(10),'') as jjzt
,dqzxll
,jzll
,fdbl
,replace(replace(t1.fdfs,chr(13),''),chr(10),'') as fdfs
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpzwmc,chr(13),''),chr(10),'') as cpzwmc
,replace(replace(t1.sfxw,chr(13),''),chr(10),'') as sfxw
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,fkr
,dqr
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,ye
,yrj
,nrj
,ylx
,nlx
,ftpjg
,dyftpzycb
,ljftpzycb
,dyftpjsy
,ljftpjsy
,ftplxsr
,ftpzycb
,ftpsy
,replace(replace(t1.lxkm,chr(13),''),chr(10),'') as lxkm
,replace(replace(t1.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
,replace(replace(t1.pjh,chr(13),''),chr(10),'') as pjh
,replace(replace(t1.wjfl,chr(13),''),chr(10),'') as wjfl
,yqxyss
,fxjqzcje
,replace(replace(t1.bzdm,chr(13),''),chr(10),'') as bzdm
,replace(replace(t1.bwbs,chr(13),''),chr(10),'') as bwbs
,replace(replace(t1.cdd,chr(13),''),chr(10),'') as cdd
,xgfxjqzcje
,replace(replace(t1.gyljrywbz,chr(13),''),chr(10),'') as gyljrywbz
,replace(replace(t1.yhycbz,chr(13),''),chr(10),'') as yhycbz
,replace(replace(t1.tjpdkbz,chr(13),''),chr(10),'') as tjpdkbz
,djftpjsy
,replace(replace(t1.kjds,chr(13),''),chr(10),'') as kjds
,replace(replace(t1.dgtx,chr(13),''),chr(10),'') as dgtx
,jrj

from ${iol_schema}.pams_jxbb_gsdkftpmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_gsdkftpmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
