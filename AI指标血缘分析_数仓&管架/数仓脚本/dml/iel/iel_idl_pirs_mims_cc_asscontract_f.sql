: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_cc_asscontract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_cc_asscontract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.asscontno,chr(13),''),chr(10),'') as asscontno
,replace(replace(t1.assconttype,chr(13),''),chr(10),'') as assconttype
,replace(replace(t1.asscustid,chr(13),''),chr(10),'') as asscustid
,replace(replace(t1.assregioncode,chr(13),''),chr(10),'') as assregioncode
,replace(replace(t1.asscusttype,chr(13),''),chr(10),'') as asscusttype
,replace(replace(t1.custlevel,chr(13),''),chr(10),'') as custlevel
,t1.assamt as assamt
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.assamtrmb as assamtrmb
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.effectedstate,chr(13),''),chr(10),'') as effectedstate
,replace(replace(t1.endstate,chr(13),''),chr(10),'') as endstate
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.creater,chr(13),''),chr(10),'') as creater
,replace(replace(t1.modifydate,chr(13),''),chr(10),'') as modifydate
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.ishighestbondedcontract,chr(13),''),chr(10),'') as ishighestbondedcontract
,replace(replace(t1.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t1.barsign,chr(13),''),chr(10),'') as barsign
,replace(replace(t1.contype,chr(13),''),chr(10),'') as contype
,txtasscontno as txtasscontno
,'' as data_date
from ${iol_schema}.mims_cc_asscontract t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_cc_asscontract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes