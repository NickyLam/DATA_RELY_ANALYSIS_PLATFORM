: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_loan_detail_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_loan_detail_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ietmcd,chr(13),''),chr(10),'') as ietmcd
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.ccif,chr(13),''),chr(10),'') as ccif
,replace(replace(t1.loanpurpose,chr(13),''),chr(10),'') as loanpurpose
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.schmaturitydate,chr(13),''),chr(10),'') as schmaturitydate
,replace(replace(t1.graceperiod,chr(13),''),chr(10),'') as graceperiod
,rate
,baserate
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,amount
,balance
,replace(replace(t1.paymentfeq,chr(13),''),chr(10),'') as paymentfeq
,replace(replace(t1.payway,chr(13),''),chr(10),'') as payway
,replace(replace(t1.repricingdate,chr(13),''),chr(10),'') as repricingdate
,replace(replace(t1.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t1.overduedays,chr(13),''),chr(10),'') as overduedays
,interest
,replace(replace(t1.prinoddate,chr(13),''),chr(10),'') as prinoddate
,prinodamt
,replace(replace(t1.intoddate,chr(13),''),chr(10),'') as intoddate
,intodamt
,poverdueamt
,replace(replace(t1.pcanceldate,chr(13),''),chr(10),'') as pcanceldate
,replace(replace(t1.pinitterm,chr(13),''),chr(10),'') as pinitterm
,replace(replace(t1.activatedate,chr(13),''),chr(10),'') as activatedate
,replace(replace(t1.pcurrterm,chr(13),''),chr(10),'') as pcurrterm
,replace(replace(t1.paidoutdate,chr(13),''),chr(10),'') as paidoutdate
,replace(replace(t1.extensionflg,chr(13),''),chr(10),'') as extensionflg
,extensionamt
,replace(replace(t1.extensionstart,chr(13),''),chr(10),'') as extensionstart
,replace(replace(t1.extensionmaturity,chr(13),''),chr(10),'') as extensionmaturity
,replace(replace(t1.recomflg,chr(13),''),chr(10),'') as recomflg
,replace(replace(t1.recomdate,chr(13),''),chr(10),'') as recomdate

from ${iol_schema}.icms_temp_wyd_loan_detail_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_loan_detail_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
