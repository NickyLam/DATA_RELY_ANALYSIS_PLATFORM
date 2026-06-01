: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_jjksqdfymx_f
CreateDate: 20241017
FileName:   ${iel_data_path}/pams_jxbb_jjksqdfymx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jyrq
,replace(replace(t1.jjgsbh,chr(13),''),chr(10),'') as jjgsbh
,replace(replace(t1.jjgsmc,chr(13),''),chr(10),'') as jjgsmc
,replace(replace(t1.khjgdh,chr(13),''),chr(10),'') as khjgdh
,replace(replace(t1.khjgmc,chr(13),''),chr(10),'') as khjgmc
,ssjgkhdxdh
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.lxszkmh,chr(13),''),chr(10),'') as lxszkmh
,replace(replace(t1.lxszkmmc,chr(13),''),chr(10),'') as lxszkmmc
,zlbl
,jyje
,zhye
,zhyeylj
,zhyrj
,zhyenlj
,zhnrj
,ftpjg
,ftpsrylj
,ftpsrnlj
,tzhftpjg
,tzhftpsrylj
,tzhftpsrnlj
,qdfyylj
,qdfynlj
,ylfyylj
,ylfynlj
,ftpsyylj
,ftpsynlj

from ${iol_schema}.pams_jxbb_jjksqdfymx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_jjksqdfymx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
