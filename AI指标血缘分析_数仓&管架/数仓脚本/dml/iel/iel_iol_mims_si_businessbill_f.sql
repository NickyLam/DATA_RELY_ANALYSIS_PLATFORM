: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_si_businessbill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_si_businessbill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t.notecode,chr(13),''),chr(10),'') as notecode
,replace(replace(t.notetype,chr(13),''),chr(10),'') as notetype
,replace(replace(t.remitter,chr(13),''),chr(10),'') as remitter
,replace(replace(t.remittercode,chr(13),''),chr(10),'') as remittercode
,replace(replace(t.remittertype,chr(13),''),chr(10),'') as remittertype
,replace(replace(t.remitteropenacount,chr(13),''),chr(10),'') as remitteropenacount
,replace(replace(t.remitteraccount,chr(13),''),chr(10),'') as remitteraccount
,replace(replace(t.acceptor,chr(13),''),chr(10),'') as acceptor
,replace(replace(t.acceptortype,chr(13),''),chr(10),'') as acceptortype
,replace(replace(t.payee,chr(13),''),chr(10),'') as payee
,replace(replace(t.payeetype,chr(13),''),chr(10),'') as payeetype
,replace(replace(t.isbillbhand,chr(13),''),chr(10),'') as isbillbhand
,replace(replace(t.billbhandname,chr(13),''),chr(10),'') as billbhandname
,replace(replace(t.billbhandtype,chr(13),''),chr(10),'') as billbhandtype
,t.faceamount as faceamount
,replace(replace(t.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t.remittercountry,chr(13),''),chr(10),'') as remittercountry
,replace(replace(t.remitterrating,chr(13),''),chr(10),'') as remitterrating
,replace(replace(t.acceptorcountry,chr(13),''),chr(10),'') as acceptorcountry
,replace(replace(t.acceptorrating,chr(13),''),chr(10),'') as acceptorrating
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.ischecks,chr(13),''),chr(10),'') as ischecks
,replace(replace(t.ishavecheck,chr(13),''),chr(10),'') as ishavecheck
,replace(replace(t.isbankpaste,chr(13),''),chr(10),'') as isbankpaste
,replace(replace(t.bankpastename,chr(13),''),chr(10),'') as bankpastename
,replace(replace(t.tdcurrency,chr(13),''),chr(10),'') as tdcurrency
,replace(replace(t.acceptordepositno,chr(13),''),chr(10),'') as acceptordepositno
,replace(replace(t.acceptordepositname,chr(13),''),chr(10),'') as acceptordepositname
,replace(replace(t.sponsoraccount,chr(13),''),chr(10),'') as sponsoraccount
,replace(replace(t.sponsordepositno,chr(13),''),chr(10),'') as sponsordepositno
,replace(replace(t.sponsordepositname,chr(13),''),chr(10),'') as sponsordepositname
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_si_businessbill t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_si_businessbill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes