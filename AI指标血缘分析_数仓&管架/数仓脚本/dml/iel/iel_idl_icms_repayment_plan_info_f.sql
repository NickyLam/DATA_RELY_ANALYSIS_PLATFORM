: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_repayment_plan_info_f
CreateDate: 20250620
FileName:   ${iel_data_path}/icms_repayment_plan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.duebillserialno as duebillserialno
,t1.dateno as dateno
,t1.penaltyinterest as penaltyinterest
,t1.paymenttype as paymenttype
,t1.unpaidsum as unpaidsum
,t1.businessrate as businessrate
,t1.businesscurrency as businesscurrency
,t1.enddate as enddate
,t1.flag as flag
,t1.actualsum as actualsum
,t1.actualinterest as actualinterest
,t1.compoundinterest as compoundinterest
,t1.normalsum as normalsum
,t1.periodinterestsum as periodinterestsum
,t1.executiondate as executiondate
,t1.periodsum as periodsum
,t1.discountsum as discountsum
,t1.startdate as startdate
,t1.putoutunpaidsum as putoutunpaidsum
,t1.migtflag as migtflag
,t1.schedamt as schedamt
,t1.intaccrued as intaccrued
,t1.odpaccrued as odpaccrued
,t1.odiaccrued as odiaccrued
,t1.odpoutstanding as odpoutstanding
,t1.odioutstanding as odioutstanding
,t1.ysintamt as ysintamt
,t1.remark as remark
,t1.gracedate as gracedate
,t1.respaidintamt as respaidintamt

from ${idl_schema}.icms_repayment_plan_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_repayment_plan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
