: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_gsjzkhmx_f
CreateDate: 20250812
FileName:   ${iel_data_path}/pams_jxbb_gsjzkhmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,hyljrj
,hyftpsynlj
,khljrj
,khftpsynlj
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,zjywsr
,khzjywsr
,jzkhs
,fhjzkhs
,ckye
,ckzb
,yszb
,replace(replace(t1.ld,chr(13),''),chr(10),'') as ld

from ${iol_schema}.pams_jxbb_gsjzkhmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_gsjzkhmx.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
