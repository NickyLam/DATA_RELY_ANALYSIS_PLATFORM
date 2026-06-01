: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cifs_cifs_cfb_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cifs_cifs_cfb_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.custcn,chr(13),''),chr(10),'') as custcn
,replace(replace(t.custen,chr(13),''),chr(10),'') as custen
,replace(replace(t.custlc,chr(13),''),chr(10),'') as custlc
,replace(replace(t.custle,chr(13),''),chr(10),'') as custle
,replace(replace(t.custtp,chr(13),''),chr(10),'') as custtp
,replace(replace(t.custlv,chr(13),''),chr(10),'') as custlv
,replace(replace(t.statlv,chr(13),''),chr(10),'') as statlv
,replace(replace(t.jonttg,chr(13),''),chr(10),'') as jonttg
,replace(replace(t.isblak,chr(13),''),chr(10),'') as isblak
,replace(replace(t.doubtp,chr(13),''),chr(10),'') as doubtp
,t.tttrib as tttrib
,t.ttrema as ttrema
,replace(replace(t.risklv,chr(13),''),chr(10),'') as risklv
,replace(replace(t.custst,chr(13),''),chr(10),'') as custst
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.openbr,chr(13),''),chr(10),'') as openbr
,replace(replace(t.openus,chr(13),''),chr(10),'') as openus
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.closbr,chr(13),''),chr(10),'') as closbr
,replace(replace(t.closus,chr(13),''),chr(10),'') as closus
,replace(replace(t.datatp,chr(13),''),chr(10),'') as datatp
,t.crecdt as crecdt
,replace(replace(t.roletp,chr(13),''),chr(10),'') as roletp
,replace(replace(t.isincu,chr(13),''),chr(10),'') as isincu
,replace(replace(t.iscred,chr(13),''),chr(10),'') as iscred
,replace(replace(t.credid,chr(13),''),chr(10),'') as credid
,t.credln as credln
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cifs_cifs_cfb_cust t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cifs_cifs_cfb_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes