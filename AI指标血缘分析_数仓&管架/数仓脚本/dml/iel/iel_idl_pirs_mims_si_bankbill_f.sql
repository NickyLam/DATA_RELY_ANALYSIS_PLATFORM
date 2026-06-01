: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_si_bankbill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_si_bankbill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.notecode,chr(13),''),chr(10),'') as notecode
,replace(replace(t1.notetype,chr(13),''),chr(10),'') as notetype
,replace(replace(t1.remitter,chr(13),''),chr(10),'') as remitter
,replace(replace(t1.remittercode,chr(13),''),chr(10),'') as remittercode
,replace(replace(t1.remittertype,chr(13),''),chr(10),'') as remittertype
,replace(replace(t1.remitteropenacount,chr(13),''),chr(10),'') as remitteropenacount
,replace(replace(t1.remitteraccount,chr(13),''),chr(10),'') as remitteraccount
,replace(replace(t1.acceptor,chr(13),''),chr(10),'') as acceptor
,replace(replace(t1.acceptortype,chr(13),''),chr(10),'') as acceptortype
,replace(replace(t1.payee,chr(13),''),chr(10),'') as payee
,replace(replace(t1.payeetype,chr(13),''),chr(10),'') as payeetype
,replace(replace(t1.isbillbhand,chr(13),''),chr(10),'') as isbillbhand
,replace(replace(t1.billbhandname,chr(13),''),chr(10),'') as billbhandname
,replace(replace(t1.billbhandtype,chr(13),''),chr(10),'') as billbhandtype
,t1.faceamount as faceamount
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.remittercountry,chr(13),''),chr(10),'') as remittercountry
,replace(replace(t1.remitterrating,chr(13),''),chr(10),'') as remitterrating
,replace(replace(t1.acceptorcountry,chr(13),''),chr(10),'') as acceptorcountry
,replace(replace(t1.acceptorrating,chr(13),''),chr(10),'') as acceptorrating
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.ischecks,chr(13),''),chr(10),'') as ischecks
,replace(replace(t1.ishavecheck,chr(13),''),chr(10),'') as ishavecheck
,replace(replace(t1.isbankpaste,chr(13),''),chr(10),'') as isbankpaste
,replace(replace(t1.bankpastename,chr(13),''),chr(10),'') as bankpastename
,replace(replace(t1.tdcurrency,chr(13),''),chr(10),'') as tdcurrency
,replace(replace(t1.acceptordepositno,chr(13),''),chr(10),'') as acceptordepositno
,replace(replace(t1.acceptordepositname,chr(13),''),chr(10),'') as acceptordepositname
,replace(replace(t1.sponsoraccount,chr(13),''),chr(10),'') as sponsoraccount
,replace(replace(t1.sponsordepositno,chr(13),''),chr(10),'') as sponsordepositno
,replace(replace(t1.sponsordepositname,chr(13),''),chr(10),'') as sponsordepositname
,'' as data_date
from ${iol_schema}.mims_si_bankbill t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_si_bankbill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes