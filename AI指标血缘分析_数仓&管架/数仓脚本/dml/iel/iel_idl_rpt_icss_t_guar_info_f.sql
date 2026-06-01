: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_icss_t_guar_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_icss_t_guar_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.guarantorid,chr(13),''),chr(10),'') as guarantorid
,replace(replace(t1.guarantorname,chr(13),''),chr(10),'') as guarantorname
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.issaveowner,chr(13),''),chr(10),'') as issaveowner
,replace(replace(t1.obligeename,chr(13),''),chr(10),'') as obligeename
,replace(replace(t1.iscustody,chr(13),''),chr(10),'') as iscustody
,t1.guarantyvalue as guarantyvalue
,replace(replace(t1.guarantycurrency,chr(13),''),chr(10),'') as guarantycurrency
,replace(replace(t1.begintime,chr(13),''),chr(10),'') as begintime
,replace(replace(t1.endtime,chr(13),''),chr(10),'') as endtime
,replace(replace(t1.guarantyid,chr(13),''),chr(10),'') as guarantyid
,replace(replace(t1.guarantytype,chr(13),''),chr(10),'') as guarantytype
,replace(replace(t1.guarantyname,chr(13),''),chr(10),'') as guarantyname
,replace(replace(t1.ownerid,chr(13),''),chr(10),'') as ownerid
,replace(replace(t1.ownername,chr(13),''),chr(10),'') as ownername
,t1.confirmvalue as confirmvalue
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.djendtime,chr(13),''),chr(10),'') as djendtime
 from iol.icss_t_guar_info T1
where 1=1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_icss_t_guar_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes