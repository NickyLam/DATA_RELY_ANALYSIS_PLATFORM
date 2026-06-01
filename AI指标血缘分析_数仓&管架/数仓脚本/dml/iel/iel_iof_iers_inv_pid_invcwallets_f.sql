: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_inv_pid_invcwallets_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_inv_pid_invcwallets.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_invcwallets,chr(13),''),chr(10),'') as pk_invcwallets
,dr
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.invctype,chr(13),''),chr(10),'') as invctype
,replace(replace(t1.srcsystem,chr(13),''),chr(10),'') as srcsystem
,replace(replace(t1.collectmode,chr(13),''),chr(10),'') as collectmode
,totallev
,totalamt
,replace(replace(t1.taxrate,chr(13),''),chr(10),'') as taxrate
,totaltax
,totallevbal
,totaltaxbal
,replace(replace(t1.bxstate,chr(13),''),chr(10),'') as bxstate
,replace(replace(t1.checkstate,chr(13),''),chr(10),'') as checkstate
,replace(replace(t1.sealspecial,chr(13),''),chr(10),'') as sealspecial
,replace(replace(t1.sealprod,chr(13),''),chr(10),'') as sealprod
,replace(replace(t1.invcurl,chr(13),''),chr(10),'') as invcurl
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.invcdate,chr(13),''),chr(10),'') as invcdate
,replace(replace(t1.salename,chr(13),''),chr(10),'') as salename
,replace(replace(t1.saletaxno,chr(13),''),chr(10),'') as saletaxno
,replace(replace(t1.saleaddress,chr(13),''),chr(10),'') as saleaddress
,replace(replace(t1.salebank,chr(13),''),chr(10),'') as salebank
,replace(replace(t1.buyname,chr(13),''),chr(10),'') as buyname
,replace(replace(t1.buytaxno,chr(13),''),chr(10),'') as buytaxno
,replace(replace(t1.buyaddress,chr(13),''),chr(10),'') as buyaddress
,replace(replace(t1.buybank,chr(13),''),chr(10),'') as buybank
,replace(replace(t1.invcode,chr(13),''),chr(10),'') as invcode
,replace(replace(t1.invcno,chr(13),''),chr(10),'') as invcno
,replace(replace(t1.chkcode,chr(13),''),chr(10),'') as chkcode
,replace(replace(t1.machcode,chr(13),''),chr(10),'') as machcode
,replace(replace(t1.drawer,chr(13),''),chr(10),'') as drawer
,replace(replace(t1.receiptor,chr(13),''),chr(10),'') as receiptor
,replace(replace(t1.reviewer,chr(13),''),chr(10),'') as reviewer
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.custidno,chr(13),''),chr(10),'') as custidno
,replace(replace(t1.fromaddr,chr(13),''),chr(10),'') as fromaddr
,replace(replace(t1.toaddr,chr(13),''),chr(10),'') as toaddr
,replace(replace(t1.tripcode,chr(13),''),chr(10),'') as tripcode
,replace(replace(t1.startime,chr(13),''),chr(10),'') as startime
,replace(replace(t1.endtime,chr(13),''),chr(10),'') as endtime
,cca_devfund
,fuelsrchrg
,otherfees
,insurance
,replace(replace(t1.seatno,chr(13),''),chr(10),'') as seatno
,replace(replace(t1.seatrank,chr(13),''),chr(10),'') as seatrank
,price
,mileage
,transfertax
,amt
,replace(replace(t1.airstate,chr(13),''),chr(10),'') as airstate
,replace(replace(t1.category,chr(13),''),chr(10),'') as category
,replace(replace(t1.ticketbagid,chr(13),''),chr(10),'') as ticketbagid
,replace(replace(t1.accountno,chr(13),''),chr(10),'') as accountno
,replace(replace(t1.billperiod,chr(13),''),chr(10),'') as billperiod
,replace(replace(t1.doubtstatus,chr(13),''),chr(10),'') as doubtstatus
,replace(replace(t1.doubtreasons,chr(13),''),chr(10),'') as doubtreasons
,replace(replace(t1.billtype,chr(13),''),chr(10),'') as billtype
,replace(replace(t1.taxperiod,chr(13),''),chr(10),'') as taxperiod
,replace(replace(t1.tick,chr(13),''),chr(10),'') as tick
,replace(replace(t1.tickdate,chr(13),''),chr(10),'') as tickdate
,replace(replace(t1.tickmethod,chr(13),''),chr(10),'') as tickmethod
,replace(replace(t1.authstatus,chr(13),''),chr(10),'') as authstatus
,replace(replace(t1.authfailurereason,chr(13),''),chr(10),'') as authfailurereason
,replace(replace(t1.authdate,chr(13),''),chr(10),'') as authdate
,effectivededuction
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.def6,chr(13),''),chr(10),'') as def6
,replace(replace(t1.def7,chr(13),''),chr(10),'') as def7
,replace(replace(t1.def8,chr(13),''),chr(10),'') as def8
,replace(replace(t1.def9,chr(13),''),chr(10),'') as def9
,replace(replace(t1.def10,chr(13),''),chr(10),'') as def10
,replace(replace(t1.def11,chr(13),''),chr(10),'') as def11
,replace(replace(t1.def12,chr(13),''),chr(10),'') as def12
,replace(replace(t1.def13,chr(13),''),chr(10),'') as def13
,replace(replace(t1.def14,chr(13),''),chr(10),'') as def14
,replace(replace(t1.def15,chr(13),''),chr(10),'') as def15
,replace(replace(t1.def16,chr(13),''),chr(10),'') as def16
,replace(replace(t1.def17,chr(13),''),chr(10),'') as def17
,replace(replace(t1.def18,chr(13),''),chr(10),'') as def18
,replace(replace(t1.def19,chr(13),''),chr(10),'') as def19
,replace(replace(t1.def20,chr(13),''),chr(10),'') as def20
,replace(replace(t1.invcid,chr(13),''),chr(10),'') as invcid
,replace(replace(t1.createtime,chr(13),''),chr(10),'') as createtime
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t1.invcnoprint,chr(13),''),chr(10),'') as invcnoprint
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.carrystatus,chr(13),''),chr(10),'') as carrystatus
,replace(replace(t1.carrydate,chr(13),''),chr(10),'') as carrydate
,replace(replace(t1.carryno,chr(13),''),chr(10),'') as carryno
,replace(replace(t1.tickresult,chr(13),''),chr(10),'') as tickresult
,replace(replace(t1.authresult,chr(13),''),chr(10),'') as authresult
,replace(replace(t1.castatus,chr(13),''),chr(10),'') as castatus
,replace(replace(t1.authmethod,chr(13),''),chr(10),'') as authmethod
,replace(replace(t1.tagid,chr(13),''),chr(10),'') as tagid
,replace(replace(t1.reimbursementtype,chr(13),''),chr(10),'') as reimbursementtype
,reimbursementbalance
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_inv_pid_invcwallets t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_inv_pid_invcwallets.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
