: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nrrs_ci_cusbasinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nrrs_ci_cusbasinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.custcname,chr(13),''),chr(10),'') as custcname
,replace(replace(t1.custtype,chr(13),''),chr(10),'') as custtype
,replace(replace(t1.orgcertcode,chr(13),''),chr(10),'') as orgcertcode
,replace(replace(t1.interindustry,chr(13),''),chr(10),'') as interindustry
,replace(replace(t1.interindustryname,chr(13),''),chr(10),'') as interindustryname
,replace(replace(t1.createyear,chr(13),''),chr(10),'') as createyear
,replace(replace(t1.custscale,chr(13),''),chr(10),'') as custscale
,replace(replace(t1.custscalenmae,chr(13),''),chr(10),'') as custscalenmae
,t1.emplquantity as emplquantity
,replace(replace(t1.custmgr,chr(13),''),chr(10),'') as custmgr
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.bloccustid,chr(13),''),chr(10),'') as bloccustid
,replace(replace(t1.blocname,chr(13),''),chr(10),'') as blocname
,replace(replace(t1.pcustid,chr(13),''),chr(10),'') as pcustid
,replace(replace(t1.modifydate,chr(13),''),chr(10),'') as modifydate
,t1.balance as balance
,t1.sales as sales
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,t1.lntoat as lntoat
,t1.amt as amt
,t1.accbal as accbal
,replace(replace(t1.riskclass,chr(13),''),chr(10),'') as riskclass
,t1.maxovdue as maxovdue
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.countycode,chr(13),''),chr(10),'') as countycode
,replace(replace(t1.areas,chr(13),''),chr(10),'') as areas
,replace(replace(t1.finantype,chr(13),''),chr(10),'') as finantype
,replace(replace(t1.business1,chr(13),''),chr(10),'') as business1
,replace(replace(t1.business2,chr(13),''),chr(10),'') as business2
,replace(replace(t1.business3,chr(13),''),chr(10),'') as business3
,t1.busimgrsum as busimgrsum
,replace(replace(t1.comcorptype,chr(13),''),chr(10),'') as comcorptype
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.calscale,chr(13),''),chr(10),'') as calscale
,replace(replace(t1.isbloc,chr(13),''),chr(10),'') as isbloc
,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'') as mfcustomerid
,replace(replace(t1.risktype,chr(13),''),chr(10),'') as risktype
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.nrrs_ci_cusbasinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nrrs_ci_cusbasinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes