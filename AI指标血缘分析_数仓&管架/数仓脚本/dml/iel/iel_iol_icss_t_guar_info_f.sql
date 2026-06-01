: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icss_t_guar_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icss_t_guar_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t.guarantorid,chr(13),''),chr(10),'') as guarantorid
,replace(replace(t.guarantorname,chr(13),''),chr(10),'') as guarantorname
,replace(replace(t.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t.issaveowner,chr(13),''),chr(10),'') as issaveowner
,replace(replace(t.obligeename,chr(13),''),chr(10),'') as obligeename
,replace(replace(t.iscustody,chr(13),''),chr(10),'') as iscustody
,t.guarantyvalue as guarantyvalue
,replace(replace(t.guarantycurrency,chr(13),''),chr(10),'') as guarantycurrency
,replace(replace(t.begintime,chr(13),''),chr(10),'') as begintime
,replace(replace(t.endtime,chr(13),''),chr(10),'') as endtime
,replace(replace(t.guarantyid,chr(13),''),chr(10),'') as guarantyid
,replace(replace(t.guarantytype,chr(13),''),chr(10),'') as guarantytype
,replace(replace(t.guarantyname,chr(13),''),chr(10),'') as guarantyname
,replace(replace(t.ownerid,chr(13),''),chr(10),'') as ownerid
,replace(replace(t.ownername,chr(13),''),chr(10),'') as ownername
,t.confirmvalue as confirmvalue
,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t.djendtime,chr(13),''),chr(10),'') as djendtime
from ${iol_schema}.icss_t_guar_info t 
where t.etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icss_t_guar_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes