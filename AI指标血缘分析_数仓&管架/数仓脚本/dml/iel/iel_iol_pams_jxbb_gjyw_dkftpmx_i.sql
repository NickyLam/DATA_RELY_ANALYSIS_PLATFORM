: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_gjyw_dkftpmx_i
CreateDate: 20260311
FileName:   ${iel_data_path}/pams_jxbb_gjyw_dkftpmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.fhjgdh,chr(13),''),chr(10),'') as fhjgdh
,replace(replace(t1.fhjgmc,chr(13),''),chr(10),'') as fhjgmc
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,fpbl
,zxll
,jzll
,fdbl
,replace(replace(t1.fdfs,chr(13),''),chr(10),'') as fdfs
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.lxkmh,chr(13),''),chr(10),'') as lxkmh
,replace(replace(t1.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,replace(replace(t1.sfxw,chr(13),''),chr(10),'') as sfxw
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,fkrq
,dqrq
,replace(replace(t1.bzmc,chr(13),''),chr(10),'') as bzmc
,dkje_yb
,dkje
,zhye_yb
,zhye
,yrj
,jrj
,nrj
,ylx
,nlx
,ftpjg
,dyftpzycb
,ljftpzycb
,dyftpjsy
,djftpjsy
,dnftpjsy
,lsljftpjsy
,replace(replace(t1.bwbs,chr(13),''),chr(10),'') as bwbs

from ${iol_schema}.pams_jxbb_gjyw_dkftpmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_gjyw_dkftpmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
