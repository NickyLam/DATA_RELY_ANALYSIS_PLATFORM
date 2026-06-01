: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_busi_duebill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_busi_duebill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.serialno
,t1.relativeserialno1
,t1.relativeserialno2
,t1.transactionrecordst
,t1.businesscurrency
,t1.businesssum
,t1.businessrate
,t1.putoutdate
,t1.maturity
,t1.balance
,t1.interestbalance1
,t1.interestbalance2
,t1.innerbalance
,t1.outterbalance
,t1.overduedate
,t1.overduedays
,t1.classifyresult
from ${idl_schema}.hdws_icss_t_busi_duebill t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_busi_duebill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes