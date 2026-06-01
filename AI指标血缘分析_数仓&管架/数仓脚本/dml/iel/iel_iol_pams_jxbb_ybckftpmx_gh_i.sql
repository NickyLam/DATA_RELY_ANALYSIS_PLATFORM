: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_ybckftpmx_gh_i
CreateDate: 20240730
FileName:   ${iel_data_path}/pams_jxbb_ybckftpmx_gh.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
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
,fpbl
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.qxmc,chr(13),''),chr(10),'') as qxmc
,replace(replace(t1.cph,chr(13),''),chr(10),'') as cph
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,zxll
,sjll
,qxrq
,dqrq
,xhrq
,replace(replace(t1.zzkzqr,chr(13),''),chr(10),'') as zzkzqr
,replace(replace(t1.sfzy,chr(13),''),chr(10),'') as sfzy
,replace(replace(t1.sfhx,chr(13),''),chr(10),'') as sfhx
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,zhye
,zhyrjye
,zhnrjye
,ftplxzcylj
,ftplxzcnlj
,zyjg
,ftpsrylj
,ftpsrnlj
,ftpsyylj
,ftpsynlj
,zjywsr
,ftplxzc
,ftpsr
,ftpsy
,replace(replace(t1.lxkm,chr(13),''),chr(10),'') as lxkm
,replace(replace(t1.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
,replace(replace(t1.bzdm,chr(13),''),chr(10),'') as bzdm
,txfpbl
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx

from ${iol_schema}.pams_jxbb_ybckftpmx_gh t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_ybckftpmx_gh.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
