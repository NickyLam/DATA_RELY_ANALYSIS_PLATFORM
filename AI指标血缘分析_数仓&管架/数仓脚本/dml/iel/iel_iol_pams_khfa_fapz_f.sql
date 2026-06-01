: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_fapz_f
CreateDate: 20251127
FileName:   ${iel_data_path}/pams_khfa_fapz.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,fabh
,replace(replace(t1.famc,chr(13),''),chr(10),'') as famc
,khnf
,replace(replace(t1.khdx,chr(13),''),chr(10),'') as khdx
,replace(replace(t1.pzms,chr(13),''),chr(10),'') as pzms
,replace(replace(t1.jglb,chr(13),''),chr(10),'') as jglb
,replace(replace(t1.hylb,chr(13),''),chr(10),'') as hylb
,khzq
,replace(replace(t1.khqs,chr(13),''),chr(10),'') as khqs
,yyzlbh
,yybzz
,yysx
,yyxx
,replace(replace(t1.zt,chr(13),''),chr(10),'') as zt
,replace(replace(t1.czr,chr(13),''),chr(10),'') as czr
,czsj

from ${iol_schema}.pams_khfa_fapz t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_fapz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
