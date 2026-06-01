: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_appr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_appr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.serialno
,t1.relativeserialno
,t1.effectflag
,t1.term
,t1.creditarea
,t1.businesssum
,t1.totalsum
,t1.businessavlsum
,t1.begindate
,t1.enddate
,t1.approveopinion
,t1.approvedate
,t1.isestatefinance
,t1.isgovernfinance
,t1.isconsumerfinance
,t1.isbeltroadfinance
,t1.isgreenfinance
,t1.amtduelevel
,t1.pricerisktype
,t1.pbusinesstype
,t1.pbusinesscurrency
,t1.pbusinesssum
,t1.ptotalsum
,t1.pbusinessbal
,t1.pbusinessavlbal
,t1.pbegindate
,t1.penddate
,t1.operateuser
,t1.operateorgid
from ${idl_schema}.hdws_icss_t_appr_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_appr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes