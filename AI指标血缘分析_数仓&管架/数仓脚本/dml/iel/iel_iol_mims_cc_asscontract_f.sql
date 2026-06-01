: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_cc_asscontract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_cc_asscontract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.asscontno,chr(13),''),chr(10),'') as asscontno
,replace(replace(t.assconttype,chr(13),''),chr(10),'') as assconttype
,replace(replace(t.asscustid,chr(13),''),chr(10),'') as asscustid
,replace(replace(t.assregioncode,chr(13),''),chr(10),'') as assregioncode
,replace(replace(t.asscusttype,chr(13),''),chr(10),'') as asscusttype
,replace(replace(t.custlevel,chr(13),''),chr(10),'') as custlevel
,t.assamt as assamt
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,t.assamtrmb as assamtrmb
,replace(replace(t.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t.effectedstate,chr(13),''),chr(10),'') as effectedstate
,replace(replace(t.endstate,chr(13),''),chr(10),'') as endstate
,replace(replace(t.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t.creater,chr(13),''),chr(10),'') as creater
,replace(replace(t.modifydate,chr(13),''),chr(10),'') as modifydate
,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t.ishighestbondedcontract,chr(13),''),chr(10),'') as ishighestbondedcontract
,replace(replace(t.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t.barsign,chr(13),''),chr(10),'') as barsign
,replace(replace(t.contype,chr(13),''),chr(10),'') as contype
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_cc_asscontract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_cc_asscontract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes