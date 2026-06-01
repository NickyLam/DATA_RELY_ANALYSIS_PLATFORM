: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_ckftpmx_a1
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxbb_ckftpmx.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,t1.tjrq as tjrq
,t1.jxdxdh as jxdxdh
,t1.khdxdh as khdxdh
,replace(replace(t1.zhhm,chr(13),''),chr(10),'') as zhhm
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.kh,chr(13),''),chr(10),'') as kh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.gsjgdh,chr(13),''),chr(10),'') as gsjgdh
,replace(replace(t1.gsjgmc,chr(13),''),chr(10),'') as gsjgmc
,replace(replace(t1.khjlgh,chr(13),''),chr(10),'') as khjlgh
,replace(replace(t1.khjlxm,chr(13),''),chr(10),'') as khjlxm
,t1.fpbl as fpbl
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.qxmc,chr(13),''),chr(10),'') as qxmc
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,t1.zxll as zxll
,t1.sjll as sjll
,t1.qxrq as qxrq
,t1.dqrq as dqrq
,t1.xhrq as xhrq
,replace(replace(t1.zzkzqr,chr(13),''),chr(10),'') as zzkzqr
,replace(replace(t1.sfzy,chr(13),''),chr(10),'') as sfzy
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,t1.zhye as zhye
,t1.zhyrjye as zhyrjye
,t1.zhnrjye as zhnrjye
,t1.ftplxzcylj as ftplxzcylj
,t1.ftplxzcnlj as ftplxzcnlj
,t1.zyjg as zyjg
,t1.ftpsrylj as ftpsrylj
,t1.ftpsrnlj as ftpsrnlj
,t1.ftpsyylj as ftpsyylj
,t1.ftpsynlj as ftpsynlj
,t1.zjywsr as zjywsr
,t1.ftplxzc as ftplxzc
,t1.ftpsr as ftpsr
,t1.ftpsy as ftpsy
,replace(replace(t1.lxkm,chr(13),''),chr(10),'') as lxkm
,replace(replace(t1.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
,replace(replace(t1.bzdm,chr(13),''),chr(10),'') as bzdm
from ${iol_schema}.pams_jxbb_ckftpmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('20231201','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_ckftpmx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes