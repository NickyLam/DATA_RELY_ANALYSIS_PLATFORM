: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_bd_supplier_f
CreateDate: 20240207
FileName:   ${iel_data_path}/iers_bd_supplier.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.buslicensenum,chr(13),''),chr(10),'') as buslicensenum
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.corcustomer,chr(13),''),chr(10),'') as corcustomer
,replace(replace(t1.corpaddress,chr(13),''),chr(10),'') as corpaddress
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dataoriginflag
,replace(replace(t1.def1,chr(13),''),chr(10),'') as def1
,replace(replace(t1.def10,chr(13),''),chr(10),'') as def10
,replace(replace(t1.def11,chr(13),''),chr(10),'') as def11
,replace(replace(t1.def12,chr(13),''),chr(10),'') as def12
,replace(replace(t1.def13,chr(13),''),chr(10),'') as def13
,replace(replace(t1.def14,chr(13),''),chr(10),'') as def14
,replace(replace(t1.def15,chr(13),''),chr(10),'') as def15
,replace(replace(t1.def16,chr(13),''),chr(10),'') as def16
,replace(replace(t1.def17,chr(13),''),chr(10),'') as def17
,replace(replace(t1.def18,chr(13),''),chr(10),'') as def18
,replace(replace(t1.def19,chr(13),''),chr(10),'') as def19
,replace(replace(t1.def2,chr(13),''),chr(10),'') as def2
,replace(replace(t1.def20,chr(13),''),chr(10),'') as def20
,replace(replace(t1.def21,chr(13),''),chr(10),'') as def21
,replace(replace(t1.def22,chr(13),''),chr(10),'') as def22
,replace(replace(t1.def23,chr(13),''),chr(10),'') as def23
,replace(replace(t1.def24,chr(13),''),chr(10),'') as def24
,replace(replace(t1.def25,chr(13),''),chr(10),'') as def25
,replace(replace(t1.def26,chr(13),''),chr(10),'') as def26
,replace(replace(t1.def27,chr(13),''),chr(10),'') as def27
,replace(replace(t1.def28,chr(13),''),chr(10),'') as def28
,replace(replace(t1.def29,chr(13),''),chr(10),'') as def29
,replace(replace(t1.def3,chr(13),''),chr(10),'') as def3
,replace(replace(t1.def30,chr(13),''),chr(10),'') as def30
,replace(replace(t1.def4,chr(13),''),chr(10),'') as def4
,replace(replace(t1.def5,chr(13),''),chr(10),'') as def5
,replace(replace(t1.def6,chr(13),''),chr(10),'') as def6
,replace(replace(t1.def7,chr(13),''),chr(10),'') as def7
,replace(replace(t1.def8,chr(13),''),chr(10),'') as def8
,replace(replace(t1.def9,chr(13),''),chr(10),'') as def9
,deletestate
,replace(replace(t1.delperson,chr(13),''),chr(10),'') as delperson
,replace(replace(t1.deltime,chr(13),''),chr(10),'') as deltime
,dr
,replace(replace(t1.ecotypesincevfive,chr(13),''),chr(10),'') as ecotypesincevfive
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,enablestate
,replace(replace(t1.ename,chr(13),''),chr(10),'') as ename
,replace(replace(t1.establishdate,chr(13),''),chr(10),'') as establishdate
,replace(replace(t1.fax1,chr(13),''),chr(10),'') as fax1
,replace(replace(t1.fax2,chr(13),''),chr(10),'') as fax2
,replace(replace(t1.iscarrier,chr(13),''),chr(10),'') as iscarrier
,replace(replace(t1.iscustomer,chr(13),''),chr(10),'') as iscustomer
,replace(replace(t1.isfreecust,chr(13),''),chr(10),'') as isfreecust
,replace(replace(t1.ismobilecoopertive,chr(13),''),chr(10),'') as ismobilecoopertive
,replace(replace(t1.isoutcheck,chr(13),''),chr(10),'') as isoutcheck
,replace(replace(t1.isvat,chr(13),''),chr(10),'') as isvat
,replace(replace(t1.legalbody,chr(13),''),chr(10),'') as legalbody
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.mnecode,chr(13),''),chr(10),'') as mnecode
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.pk_areacl,chr(13),''),chr(10),'') as pk_areacl
,replace(replace(t1.pk_billtypecode,chr(13),''),chr(10),'') as pk_billtypecode
,replace(replace(t1.pk_country,chr(13),''),chr(10),'') as pk_country
,replace(replace(t1.pk_currtype,chr(13),''),chr(10),'') as pk_currtype
,replace(replace(t1.pk_financeorg,chr(13),''),chr(10),'') as pk_financeorg
,replace(replace(t1.pk_format,chr(13),''),chr(10),'') as pk_format
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_oldsupplier,chr(13),''),chr(10),'') as pk_oldsupplier
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_supplier,chr(13),''),chr(10),'') as pk_supplier
,replace(replace(t1.pk_supplier_main,chr(13),''),chr(10),'') as pk_supplier_main
,replace(replace(t1.pk_supplier_pf,chr(13),''),chr(10),'') as pk_supplier_pf
,replace(replace(t1.pk_supplierclass,chr(13),''),chr(10),'') as pk_supplierclass
,replace(replace(t1.pk_suptaxes,chr(13),''),chr(10),'') as pk_suptaxes
,replace(replace(t1.pk_timezone,chr(13),''),chr(10),'') as pk_timezone
,registerfund
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,supprop
,supstate
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,replace(replace(t1.tel1,chr(13),''),chr(10),'') as tel1
,replace(replace(t1.tel2,chr(13),''),chr(10),'') as tel2
,replace(replace(t1.tel3,chr(13),''),chr(10),'') as tel3
,replace(replace(t1.trade,chr(13),''),chr(10),'') as trade
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.url,chr(13),''),chr(10),'') as url
,replace(replace(t1.vatcode,chr(13),''),chr(10),'') as vatcode
,replace(replace(t1.zipcode,chr(13),''),chr(10),'') as zipcode

from ${iol_schema}.iers_bd_supplier t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_bd_supplier.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
