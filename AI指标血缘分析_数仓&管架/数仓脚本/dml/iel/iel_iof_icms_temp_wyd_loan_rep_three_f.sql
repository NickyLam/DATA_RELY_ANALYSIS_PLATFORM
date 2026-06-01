: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_loan_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_loan_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.busisno,chr(13),''),chr(10),'') as busisno
,replace(replace(t1.ccif,chr(13),''),chr(10),'') as ccif
,replace(replace(t1.custtype,chr(13),''),chr(10),'') as custtype
,replace(replace(t1.loanno,chr(13),''),chr(10),'') as loanno
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.termdate,chr(13),''),chr(10),'') as termdate
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.maturity,chr(13),''),chr(10),'') as maturity
,replace(replace(t1.tremmonth,chr(13),''),chr(10),'') as tremmonth
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,businesssum
,balance
,businessrate
,overduefine
,replace(replace(t1.startinterestdate,chr(13),''),chr(10),'') as startinterestdate
,replace(replace(t1.payday,chr(13),''),chr(10),'') as payday
,replace(replace(t1.loanstatus,chr(13),''),chr(10),'') as loanstatus
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.composedproductid,chr(13),''),chr(10),'') as composedproductid
,replace(replace(t1.projectid,chr(13),''),chr(10),'') as projectid
,replace(replace(t1.writeoffdate,chr(13),''),chr(10),'') as writeoffdate
,replace(replace(t1.finishdate,chr(13),''),chr(10),'') as finishdate
,replace(replace(t1.corpuspaymethod,chr(13),''),chr(10),'') as corpuspaymethod
,replace(replace(t1.payacctno,chr(13),''),chr(10),'') as payacctno
,replace(replace(t1.payacctnoname,chr(13),''),chr(10),'') as payacctnoname
,replace(replace(t1.payacctbankno,chr(13),''),chr(10),'') as payacctbankno
,replace(replace(t1.payacctbank,chr(13),''),chr(10),'') as payacctbank
,replace(replace(t1.inacctno,chr(13),''),chr(10),'') as inacctno
,replace(replace(t1.inacctnoname,chr(13),''),chr(10),'') as inacctnoname
,replace(replace(t1.inacctbankno,chr(13),''),chr(10),'') as inacctbankno
,replace(replace(t1.inacctbank,chr(13),''),chr(10),'') as inacctbank
,lprbaserate
,participantratio
,replace(replace(t1.loanusage,chr(13),''),chr(10),'') as loanusage
,replace(replace(t1.recommender,chr(13),''),chr(10),'') as recommender
,replace(replace(t1.guaranteeflag,chr(13),''),chr(10),'') as guaranteeflag
,replace(replace(t1.loanchangefrequency,chr(13),''),chr(10),'') as loanchangefrequency

from ${iol_schema}.icms_temp_wyd_loan_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_loan_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
