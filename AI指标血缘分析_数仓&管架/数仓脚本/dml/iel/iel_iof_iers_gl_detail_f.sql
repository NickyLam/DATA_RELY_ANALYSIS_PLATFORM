: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_gl_detail_f
CreateDate: 20230607
FileName:   ${iel_data_path}/iers_gl_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.accountcode,chr(13),''),chr(10),'') as accountcode
,replace(replace(t1.adjustperiod,chr(13),''),chr(10),'') as adjustperiod
,replace(replace(t1.assid,chr(13),''),chr(10),'') as assid
,replace(replace(t1.bankaccount,chr(13),''),chr(10),'') as bankaccount
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.busireconno,chr(13),''),chr(10),'') as busireconno
,replace(replace(t1.checkdate,chr(13),''),chr(10),'') as checkdate
,replace(replace(t1.checkno,chr(13),''),chr(10),'') as checkno
,replace(replace(t1.checkstyle,chr(13),''),chr(10),'') as checkstyle
,contrastflag
,replace(replace(t1.convertflag,chr(13),''),chr(10),'') as convertflag
,creditamount
,creditquantity
,debitamount
,debitquantity
,detailindex
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.discardflagv,chr(13),''),chr(10),'') as discardflagv
,dr
,replace(replace(t1.errmessage,chr(13),''),chr(10),'') as errmessage
,replace(replace(t1.errmessage2,chr(13),''),chr(10),'') as errmessage2
,replace(replace(t1.errmessageh,chr(13),''),chr(10),'') as errmessageh
,excrate1
,excrate2
,excrate3
,excrate4
,replace(replace(t1.explanation,chr(13),''),chr(10),'') as explanation
,fraccreditamount
,fracdebitamount
,replace(replace(t1.free1,chr(13),''),chr(10),'') as free1
,replace(replace(t1.free10,chr(13),''),chr(10),'') as free10
,replace(replace(t1.free2,chr(13),''),chr(10),'') as free2
,replace(replace(t1.free3,chr(13),''),chr(10),'') as free3
,replace(replace(t1.free4,chr(13),''),chr(10),'') as free4
,replace(replace(t1.free5,chr(13),''),chr(10),'') as free5
,replace(replace(t1.free6,chr(13),''),chr(10),'') as free6
,replace(replace(t1.free7,chr(13),''),chr(10),'') as free7
,replace(replace(t1.free8,chr(13),''),chr(10),'') as free8
,replace(replace(t1.free9,chr(13),''),chr(10),'') as free9
,globalcreditamount
,globaldebitamount
,groupcreditamount
,groupdebitamount
,replace(replace(t1.innerbusdate,chr(13),''),chr(10),'') as innerbusdate
,replace(replace(t1.innerbusno,chr(13),''),chr(10),'') as innerbusno
,replace(replace(t1.isdifflag,chr(13),''),chr(10),'') as isdifflag
,localcreditamount
,localdebitamount
,replace(replace(t1.modifyflag,chr(13),''),chr(10),'') as modifyflag
,replace(replace(t1.netbankflag,chr(13),''),chr(10),'') as netbankflag
,nov
,replace(replace(t1.oppositesubj,chr(13),''),chr(10),'') as oppositesubj
,replace(replace(t1.periodv,chr(13),''),chr(10),'') as periodv
,replace(replace(t1.pk_accasoa,chr(13),''),chr(10),'') as pk_accasoa
,replace(replace(t1.pk_accchart,chr(13),''),chr(10),'') as pk_accchart
,replace(replace(t1.pk_account,chr(13),''),chr(10),'') as pk_account
,replace(replace(t1.pk_accountingbook,chr(13),''),chr(10),'') as pk_accountingbook
,replace(replace(t1.pk_currtype,chr(13),''),chr(10),'') as pk_currtype
,replace(replace(t1.pk_detail,chr(13),''),chr(10),'') as pk_detail
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_innerorg,chr(13),''),chr(10),'') as pk_innerorg
,replace(replace(t1.pk_innersob,chr(13),''),chr(10),'') as pk_innersob
,replace(replace(t1.pk_managerv,chr(13),''),chr(10),'') as pk_managerv
,replace(replace(t1.pk_offerdetail,chr(13),''),chr(10),'') as pk_offerdetail
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_org_v,chr(13),''),chr(10),'') as pk_org_v
,replace(replace(t1.pk_othercorp,chr(13),''),chr(10),'') as pk_othercorp
,replace(replace(t1.pk_otherorgbook,chr(13),''),chr(10),'') as pk_otherorgbook
,replace(replace(t1.pk_preparedv,chr(13),''),chr(10),'') as pk_preparedv
,replace(replace(t1.pk_setofbook,chr(13),''),chr(10),'') as pk_setofbook
,replace(replace(t1.pk_sourcepk,chr(13),''),chr(10),'') as pk_sourcepk
,replace(replace(t1.pk_systemv,chr(13),''),chr(10),'') as pk_systemv
,replace(replace(t1.pk_unit,chr(13),''),chr(10),'') as pk_unit
,replace(replace(t1.pk_unit_v,chr(13),''),chr(10),'') as pk_unit_v
,replace(replace(t1.pk_voucher,chr(13),''),chr(10),'') as pk_voucher
,replace(replace(t1.pk_vouchertypev,chr(13),''),chr(10),'') as pk_vouchertypev
,replace(replace(t1.prepareddatev,chr(13),''),chr(10),'') as prepareddatev
,price
,replace(replace(t1.recieptclass,chr(13),''),chr(10),'') as recieptclass
,replace(replace(t1.signdatev,chr(13),''),chr(10),'') as signdatev
,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'') as tempsaveflag
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.unitname,chr(13),''),chr(10),'') as unitname
,replace(replace(t1.verifydate,chr(13),''),chr(10),'') as verifydate
,replace(replace(t1.verifyno,chr(13),''),chr(10),'') as verifyno
,voucherkindv
,replace(replace(t1.yearv,chr(13),''),chr(10),'') as yearv

from ${iol_schema}.iers_gl_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_gl_detail.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
