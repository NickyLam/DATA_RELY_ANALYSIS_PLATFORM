: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_dkftpmx_a1
CreateDate: 20231226
FileName:   ${iel_data_path}/pams_jxbb_dkftpmx.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.tjrq as etl_dt
    ,t.tjrq as tjrq
    ,replace(replace(t.khm,chr(13),''),chr(10),'') as khm
    ,replace(replace(t.khh,chr(13),''),chr(10),'') as khh
    ,t.khjgkhdxdh as khjgkhdxdh
    ,replace(replace(t.khjgh,chr(13),''),chr(10),'') as khjgh
    ,replace(replace(t.khjgmc,chr(13),''),chr(10),'') as khjgmc
    ,t.ssjgkhdxdh as ssjgkhdxdh
    ,replace(replace(t.ssjgh,chr(13),''),chr(10),'') as ssjgh
    ,replace(replace(t.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
    ,replace(replace(t.khjlgh,chr(13),''),chr(10),'') as khjlgh
    ,replace(replace(t.khjlxm,chr(13),''),chr(10),'') as khjlxm
    ,t.fpbl as fpbl
    ,replace(replace(t.zhbs,chr(13),''),chr(10),'') as zhbs
    ,replace(replace(t.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
    ,replace(replace(t.jjh,chr(13),''),chr(10),'') as jjh
    ,replace(replace(t.jjzt,chr(13),''),chr(10),'') as jjzt
    ,t.dqzxll as dqzxll
    ,t.jzll as jzll
    ,t.fdbl as fdbl
    ,replace(replace(t.fdfs,chr(13),''),chr(10),'') as fdfs
    ,replace(replace(t.kmh,chr(13),''),chr(10),'') as kmh
    ,replace(replace(t.kmmc,chr(13),''),chr(10),'') as kmmc
    ,replace(replace(t.cpbh,chr(13),''),chr(10),'') as cpbh
    ,replace(replace(t.cpejfl,chr(13),''),chr(10),'') as cpejfl
    ,replace(replace(t.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
    ,replace(replace(t.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
    ,replace(replace(t.cpzwmc,chr(13),''),chr(10),'') as cpzwmc
    ,replace(replace(t.sfxw,chr(13),''),chr(10),'') as sfxw
    ,replace(replace(t.qx,chr(13),''),chr(10),'') as qx
    ,t.fkr as fkr
    ,t.dqr as dqr
    ,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
    ,t.ye as ye
    ,t.yrj as yrj
    ,t.nrj as nrj
    ,t.ylx as ylx
    ,t.nlx as nlx
    ,t.ftpjg as ftpjg
    ,t.dyftpzycb as dyftpzycb
    ,t.ljftpzycb as ljftpzycb
    ,t.dyftpjsy as dyftpjsy
    ,t.ljftpjsy as ljftpjsy
    ,t.ftplxsr as ftplxsr
    ,t.ftpzycb as ftpzycb
    ,t.ftpsy as ftpsy
    ,replace(replace(t.lxkm,chr(13),''),chr(10),'') as lxkm
    ,replace(replace(t.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
    ,replace(replace(t.pjh,chr(13),''),chr(10),'') as pjh
    ,replace(replace(t.wjfl,chr(13),''),chr(10),'') as wjfl
    ,t.yqxyss as yqxyss
    ,t.jrj as jrj
    ,t.jlx as jlx
    ,t.djftpzycb as djftpzycb
    ,t.djftpjsy as djftpjsy
    ,replace(replace(t1.bwbs,chr(13),''),chr(10),'') as bwbs
    ,replace(replace(t1.gyljrywbz,chr(13),''),chr(10),'') as gyljrywbz
    ,fxjqzcje
    ,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
    ,replace(replace(t1.zcpbh,chr(13),''),chr(10),'') as zcpbh
    ,replace(replace(t1.zcpmc,chr(13),''),chr(10),'') as zcpmc
from iol.pams_jxbb_dkftpmx t
  where t.tjrq <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_dkftpmx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes