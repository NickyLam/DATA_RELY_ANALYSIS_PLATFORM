: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_xxd_loanapply_online_f
CreateDate: 20251125
FileName:   ${iel_data_path}/icms_xxd_loanapply_online.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.baserialno,chr(13),''),chr(10),'') as baserialno
,replace(replace(t1.lmtcontractno,chr(13),''),chr(10),'') as lmtcontractno
,replace(replace(t1.loancontractno,chr(13),''),chr(10),'') as loancontractno
,replace(replace(t1.prdcode,chr(13),''),chr(10),'') as prdcode
,replace(replace(t1.prdname,chr(13),''),chr(10),'') as prdname
,replace(replace(t1.putouttype,chr(13),''),chr(10),'') as putouttype
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,applyamt
,replace(replace(t1.loanterm,chr(13),''),chr(10),'') as loanterm
,replace(replace(t1.loanpurpose,chr(13),''),chr(10),'') as loanpurpose
,replace(replace(t1.concretepurpose,chr(13),''),chr(10),'') as concretepurpose
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,applydate
,startdate
,enddate
,executerate
,replace(replace(t1.rateadd,chr(13),''),chr(10),'') as rateadd
,replace(replace(t1.authotype,chr(13),''),chr(10),'') as authotype
,replace(replace(t1.biometrics,chr(13),''),chr(10),'') as biometrics
,authotime
,authostrdate
,authoenddate
,replace(replace(t1.incomingcode,chr(13),''),chr(10),'') as incomingcode
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.customermanagerno,chr(13),''),chr(10),'') as customermanagerno
,replace(replace(t1.belongorgid,chr(13),''),chr(10),'') as belongorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.putoutstatus,chr(13),''),chr(10),'') as putoutstatus
,replace(replace(t1.payaccount,chr(13),''),chr(10),'') as payaccount
,replace(replace(t1.payaccountname,chr(13),''),chr(10),'') as payaccountname
,replace(replace(t1.qryusertype,chr(13),''),chr(10),'') as qryusertype
,replace(replace(t1.qryopertp,chr(13),''),chr(10),'') as qryopertp
,replace(replace(t1.partner,chr(13),''),chr(10),'') as partner
,replace(replace(t1.reportusernm,chr(13),''),chr(10),'') as reportusernm
,replace(replace(t1.reportuseroff,chr(13),''),chr(10),'') as reportuseroff
,replace(replace(t1.istimeoutrefuse,chr(13),''),chr(10),'') as istimeoutrefuse
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.ismqrisk,chr(13),''),chr(10),'') as ismqrisk
,mqrisksendtime
,replace(replace(t1.iscollectcredit,chr(13),''),chr(10),'') as iscollectcredit
,finalapplyamount
,replace(replace(t1.apprendtime,chr(13),''),chr(10),'') as apprendtime
,replace(replace(t1.manualapproval,chr(13),''),chr(10),'') as manualapproval
,replace(replace(t1.failreason,chr(13),''),chr(10),'') as failreason
,replace(replace(t1.warninginfo,chr(13),''),chr(10),'') as warninginfo
,replace(replace(t1.isbankrel,chr(13),''),chr(10),'') as isbankrel
,replace(replace(t1.autoscore,chr(13),''),chr(10),'') as autoscore
,roomprice
,approvedamt
,replace(replace(t1.artificialno,chr(13),''),chr(10),'') as artificialno
,replace(replace(t1.paymenttype,chr(13),''),chr(10),'') as paymenttype
,replace(replace(t1.entryaccount,chr(13),''),chr(10),'') as entryaccount
,replace(replace(t1.entryaccountname,chr(13),''),chr(10),'') as entryaccountname
,replace(replace(t1.riskstatus,chr(13),''),chr(10),'') as riskstatus
,replace(replace(t1.imagebatchno,chr(13),''),chr(10),'') as imagebatchno
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno

from ${iol_schema}.icms_xxd_loanapply_online t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_xxd_loanapply_online.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
