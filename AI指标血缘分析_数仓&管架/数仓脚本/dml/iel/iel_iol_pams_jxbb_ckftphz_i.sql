: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_ckftphz_i
CreateDate: 20250516
FileName:   ${iel_data_path}/pams_jxbb_ckftphz.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,zhye
,zhyrjye
,zhnrjye
,jqll
,ftplxzcylj
,ftplxzcnlj
,jqftpjg
,ftpsrylj
,ftpsrnlj
,ftpsyylj
,ftpsynlj
,replace(replace(t1.lxkm,chr(13),''),chr(10),'') as lxkm
,replace(replace(t1.lxkmmc,chr(13),''),chr(10),'') as lxkmmc
,replace(replace(t1.khjgh,chr(13),''),chr(10),'') as khjgh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,replace(replace(t1.ssjgh,chr(13),''),chr(10),'') as ssjgh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz

from ${iol_schema}.pams_jxbb_ckftphz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_ckftphz.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
