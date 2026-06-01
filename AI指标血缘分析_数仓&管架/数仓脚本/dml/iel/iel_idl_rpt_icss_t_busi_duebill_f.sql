: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_busi_duebill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_busi_duebill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.relativeserialno1,chr(13),''),chr(10),'') as relativeserialno1
,replace(replace(t1.relativeserialno2,chr(13),''),chr(10),'') as relativeserialno2
,replace(replace(t1.transactionrecordst,chr(13),''),chr(10),'') as transactionrecordst
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,t1.businesssum as businesssum
,t1.businessrate as businessrate
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.maturity,chr(13),''),chr(10),'') as maturity
,t1.balance as balance
,t1.interestbalance1 as interestbalance1
,t1.interestbalance2 as interestbalance2
,t1.innerbalance as innerbalance
,t1.outterbalance as outterbalance
,replace(replace(t1.overduedate,chr(13),''),chr(10),'') as overduedate
,t1.overduedays as overduedays
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
 from iol.icss_t_busi_duebill T1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_busi_duebill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes