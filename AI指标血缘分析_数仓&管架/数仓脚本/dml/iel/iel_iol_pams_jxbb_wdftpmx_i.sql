: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_wdftpmx_i
CreateDate: 20231226
FileName:   ${iel_data_path}/pams_jxbb_wdftpmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.khjgh,chr(13),''),chr(10),'') as khjgh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.cpejfl,chr(13),''),chr(10),'') as cpejfl
,replace(replace(t1.cpsjfl,chr(13),''),chr(10),'') as cpsjfl
,replace(replace(t1.cpsijfl,chr(13),''),chr(10),'') as cpsijfl
,replace(replace(t1.cpzwmc,chr(13),''),chr(10),'') as cpzwmc
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
,jgkhdxdh
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,replace(replace(t1.khm,chr(13),''),chr(10),'') as khm
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.bzdm,chr(13),''),chr(10),'') as bzdm
,replace(replace(t1.khjldh,chr(13),''),chr(10),'') as khjldh
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,fpbl
,jrj
,jlx
,djftpzycb
,djftpjsy

from ${iol_schema}.pams_jxbb_wdftpmx t1
where t1.tjrq = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_wdftpmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
