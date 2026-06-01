: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_busi_duebill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_busi_duebill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.relativeserialno1,chr(13),''),chr(10),'') as relativeserialno1
,replace(replace(t.relativeserialno2,chr(13),''),chr(10),'') as relativeserialno2
,replace(replace(t.transactionrecordst,chr(13),''),chr(10),'') as transactionrecordst
,replace(replace(t.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,t.businesssum as businesssum
,t.businessrate as businessrate
,replace(replace(t.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t.maturity,chr(13),''),chr(10),'') as maturity
,t.balance as balance
,t.interestbalance1 as interestbalance1
,t.interestbalance2 as interestbalance2
,t.innerbalance as innerbalance
,t.outterbalance as outterbalance
,replace(replace(t.overduedate,chr(13),''),chr(10),'') as overduedate
,t.overduedays as overduedays
,replace(replace(t.classifyresult,chr(13),''),chr(10),'') as classifyresult
from ${iol_schema}.icss_t_busi_duebill t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_busi_duebill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes