: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_busi_apply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_busi_apply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.serialno
,t1.operateorg
,t1.leader
,t1.businesstype
,t1.occurtype
,t1.vouchtype
,t1.businesssum
,t1.totalsum
,t1.termmonth
,t1.pbusinesstype
,t1.pbusinesscurrency
,t1.pbusinesssum
,t1.ptotalsum
,t1.pbegindate
,t1.penddate
from ${idl_schema}.hdws_icss_t_busi_apply t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_busi_apply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes