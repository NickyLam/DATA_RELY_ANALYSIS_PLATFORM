: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_cci_i
CreateDate: 20180529
FileName:   ${iel_data_path}/isbs_cci.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.objtyp,chr(13),''),chr(10),'') as objtyp
,replace(replace(t1.objinr,chr(13),''),chr(10),'') as objinr
,replace(replace(t1.ownref,chr(13),''),chr(10),'') as ownref
,replace(replace(t1.nam,chr(13),''),chr(10),'') as nam
,replace(replace(t1.ownusr,chr(13),''),chr(10),'') as ownusr
,t1.credat as credat
,t1.opndat as opndat
,t1.clsdat as clsdat
,t1.amedat as amedat
,t1.expdat as expdat
,replace(replace(t1.ccibanrol,chr(13),''),chr(10),'') as ccibanrol
,replace(replace(t1.ccibanptainr,chr(13),''),chr(10),'') as ccibanptainr
,replace(replace(t1.ccicusrol,chr(13),''),chr(10),'') as ccicusrol
,replace(replace(t1.ccicusptainr,chr(13),''),chr(10),'') as ccicusptainr
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.etyextkey,chr(13),''),chr(10),'') as etyextkey
from ${iol_schema}.isbs_cci t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_cci.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes