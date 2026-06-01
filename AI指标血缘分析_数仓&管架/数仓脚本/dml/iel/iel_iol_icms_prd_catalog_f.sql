: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_prd_catalog_f
CreateDate: 20230223
FileName:   ${iel_data_path}/icms_prd_catalog.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,expirydate
,indpostloancheckrate
,replace(replace(t1.parentproductid,chr(13),''),chr(10),'') as parentproductid
,replace(replace(t1.productclassify,chr(13),''),chr(10),'') as productclassify
,replace(replace(t1.permitpackage,chr(13),''),chr(10),'') as permitpackage
,replace(replace(t1.occupylimitdesc,chr(13),''),chr(10),'') as occupylimitdesc
,replace(replace(t1.publiclimit,chr(13),''),chr(10),'') as publiclimit
,replace(replace(t1.multiloan,chr(13),''),chr(10),'') as multiloan
,updatedate
,replace(replace(t1.exflusiveflag,chr(13),''),chr(10),'') as exflusiveflag
,replace(replace(t1.uniquesuitscope,chr(13),''),chr(10),'') as uniquesuitscope
,replace(replace(t1.iscapitalpurposecheck,chr(13),''),chr(10),'') as iscapitalpurposecheck
,replace(replace(t1.packageproduct,chr(13),''),chr(10),'') as packageproduct
,replace(replace(t1.businessflag,chr(13),''),chr(10),'') as businessflag
,replace(replace(t1.productstatus,chr(13),''),chr(10),'') as productstatus
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept
,replace(replace(t1.multiputout,chr(13),''),chr(10),'') as multiputout
,purposechecktopdays
,purposecheckbottomdays
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.occupylimit,chr(13),''),chr(10),'') as occupylimit
,replace(replace(t1.earlyrepayment,chr(13),''),chr(10),'') as earlyrepayment
,replace(replace(t1.offsheetflag,chr(13),''),chr(10),'') as offsheetflag
,replace(replace(t1.suitcurrency,chr(13),''),chr(10),'') as suitcurrency
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.uniquelimit,chr(13),''),chr(10),'') as uniquelimit
,replace(replace(t1.suitroles,chr(13),''),chr(10),'') as suitroles
,replace(replace(t1.belongproductid,chr(13),''),chr(10),'') as belongproductid
,baseproduct
,replace(replace(t1.productname,chr(13),''),chr(10),'') as productname
,replace(replace(t1.underproduct,chr(13),''),chr(10),'') as underproduct
,replace(replace(t1.limitrelaprotocal,chr(13),''),chr(10),'') as limitrelaprotocal
,replace(replace(t1.productdesc,chr(13),''),chr(10),'') as productdesc
,replace(replace(t1.basetermmodelno,chr(13),''),chr(10),'') as basetermmodelno
,replace(replace(t1.relatermmodelno,chr(13),''),chr(10),'') as relatermmodelno
,effectivedate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,inputdate
,replace(replace(t1.usabledept,chr(13),''),chr(10),'') as usabledept
,replace(replace(t1.producttype,chr(13),''),chr(10),'') as producttype
,replace(replace(t1.limitperiod,chr(13),''),chr(10),'') as limitperiod
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.assetthreetype,chr(13),''),chr(10),'') as assetthreetype
,replace(replace(t1.occupytype,chr(13),''),chr(10),'') as occupytype
,replace(replace(t1.rotative,chr(13),''),chr(10),'') as rotative
,replace(replace(t1.sortno,chr(13),''),chr(10),'') as sortno
,replace(replace(t1.norisk,chr(13),''),chr(10),'') as norisk
,replace(replace(t1.totalexposure,chr(13),''),chr(10),'') as totalexposure
,replace(replace(t1.isleafnode,chr(13),''),chr(10),'') as isleafnode
,replace(replace(t1.entcreditclassify,chr(13),''),chr(10),'') as entcreditclassify
,replace(replace(t1.saveflag,chr(13),''),chr(10),'') as saveflag
,replace(replace(t1.queryparam,chr(13),''),chr(10),'') as queryparam

from ${iol_schema}.icms_prd_catalog t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_prd_catalog.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
