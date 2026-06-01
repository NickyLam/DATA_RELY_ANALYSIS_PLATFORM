: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_uxds_f_yzgais02002_f
CreateDate: 20250318
FileName:   ${iel_data_path}/uxds_f_yzgais02002.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.gendate,chr(13),''),chr(10),'') as gendate
,replace(replace(t1.serialnumber,chr(13),''),chr(10),'') as serialnumber
,replace(replace(t1.sequenceid,chr(13),''),chr(10),'') as sequenceid
,replace(replace(t1.handleracclist_handleracc,chr(13),''),chr(10),'') as handleracclist_handleracc
,replace(replace(t1.legalentitycorplist_legalentitycorp,chr(13),''),chr(10),'') as legalentitycorplist_legalentitycorp
,replace(replace(t1.corpbizrecordlist_corpbizrecord,chr(13),''),chr(10),'') as corpbizrecordlist_corpbizrecord
,replace(replace(t1.legalentityacclist_legalentityacc,chr(13),''),chr(10),'') as legalentityacclist_legalentityacc
,replace(replace(t1.handlertelacclist_handlertelacc,chr(13),''),chr(10),'') as handlertelacclist_handlertelacc
,replace(replace(t1.legalpayabnormalcaselist_legalpayabnormalcase,chr(13),''),chr(10),'') as legalpayabnormalcaselist_legalpayabnormalcase
,replace(replace(t1.addrsimilaracclist_addrsimilaracc,chr(13),''),chr(10),'') as addrsimilaracclist_addrsimilaracc
,replace(replace(t1.ydkhlist_ydkh,chr(13),''),chr(10),'') as ydkhlist_ydkh
,replace(replace(t1.creditinfolist_creditinfo,chr(13),''),chr(10),'') as creditinfolist_creditinfo
,replace(replace(t1.legalaccnamelist_legalaccname,chr(13),''),chr(10),'') as legalaccnamelist_legalaccname
,replace(replace(t1.legaltelacclist_legaltelacc,chr(13),''),chr(10),'') as legaltelacclist_legaltelacc
,replace(replace(t1.abnormalcaselist_abnormalcase,chr(13),''),chr(10),'') as abnormalcaselist_abnormalcase
,replace(replace(t1.itemcode,chr(13),''),chr(10),'') as itemcode
,replace(replace(t1.iteminfo,chr(13),''),chr(10),'') as iteminfo
,replace(replace(t1.genmonth,chr(13),''),chr(10),'') as genmonth

from ${iol_schema}.uxds_f_yzgais02002 t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_f_yzgais02002.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
