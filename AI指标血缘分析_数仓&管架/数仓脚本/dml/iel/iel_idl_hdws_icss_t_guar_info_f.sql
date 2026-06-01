: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_guar_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_guar_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.objectno
,t1.serialno
,t1.guarantorid
,t1.guarantorname
,t1.vouchtype
,t1.issaveowner
,t1.obligeename
,t1.iscustody
,t1.guarantyvalue
,t1.guarantycurrency
,t1.begintime
,t1.endtime
,t1.guarantyid
,t1.guarantytype
,t1.guarantyname
,t1.ownerid
,t1.ownername
,t1.confirmvalue
,t1.inputdate
,t1.djendtime
from ${idl_schema}.hdws_icss_t_guar_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_guar_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes