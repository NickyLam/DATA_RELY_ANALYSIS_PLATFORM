: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_tyckzzhmx_a
CreateDate: 20240507
FileName:   ${iel_data_path}/pams_jxbb_tyckzzhmx.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,tjrq
,jxdxdh
,khdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.jrjglb,chr(13),''),chr(10),'') as jrjglb
,replace(replace(t1.zhdh,chr(13),''),chr(10),'') as zhdh
,replace(replace(t1.zhid,chr(13),''),chr(10),'') as zhid
,replace(replace(t1.zzh,chr(13),''),chr(10),'') as zzh
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.cz,chr(13),''),chr(10),'') as cz
,khrq
,nll
,qxrq
,dqrq
,replace(replace(t1.fxpl,chr(13),''),chr(10),'') as fxpl
,zhye
,yrj
,nrj
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,ftpll
,byftpjsr
,bnftpjsr
,ljftpjsr
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,fpbl
,lxzcylj
,lxzcnlj
,lxsrylj
,lxsrnlj
,lxzcrlj
,lxsrrlj
,brftpjsr
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl

from ${iol_schema}.pams_jxbb_tyckzzhmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_tyckzzhmx.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
