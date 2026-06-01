: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_prd_catalog_f
CreateDate: 20250603
FileName:   ${iel_data_path}/icms_prd_catalog.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.productid as productid
,t1.expirydate as expirydate
,t1.indpostloancheckrate as indpostloancheckrate
,t1.parentproductid as parentproductid
,t1.productclassify as productclassify
,t1.permitpackage as permitpackage
,t1.occupylimitdesc as occupylimitdesc
,t1.publiclimit as publiclimit
,t1.multiloan as multiloan
,t1.updatedate as updatedate
,t1.exflusiveflag as exflusiveflag
,t1.uniquesuitscope as uniquesuitscope
,t1.iscapitalpurposecheck as iscapitalpurposecheck
,t1.packageproduct as packageproduct
,t1.businessflag as businessflag
,t1.productstatus as productstatus
,t1.updateorgid as updateorgid
,t1.belongdept as belongdept
,t1.multiputout as multiputout
,t1.purposechecktopdays as purposechecktopdays
,t1.purposecheckbottomdays as purposecheckbottomdays
,t1.corporgid as corporgid
,t1.occupylimit as occupylimit
,t1.earlyrepayment as earlyrepayment
,t1.offsheetflag as offsheetflag
,t1.suitcurrency as suitcurrency
,t1.inputorgid as inputorgid
,t1.uniquelimit as uniquelimit
,t1.suitroles as suitroles
,t1.belongproductid as belongproductid
,t1.baseproduct as baseproduct
,t1.productname as productname
,t1.underproduct as underproduct
,t1.limitrelaprotocal as limitrelaprotocal
,t1.productdesc as productdesc
,t1.basetermmodelno as basetermmodelno
,t1.relatermmodelno as relatermmodelno
,t1.effectivedate as effectivedate
,t1.inputuserid as inputuserid
,t1.inputdate as inputdate
,t1.usabledept as usabledept
,t1.producttype as producttype
,t1.limitperiod as limitperiod
,t1.updateuserid as updateuserid
,t1.assetthreetype as assetthreetype
,t1.occupytype as occupytype
,t1.rotative as rotative
,t1.sortno as sortno
,t1.norisk as norisk
,t1.totalexposure as totalexposure
,t1.isleafnode as isleafnode
,t1.entcreditclassify as entcreditclassify
,t1.saveflag as saveflag
,t1.queryparam as queryparam
,t1.isgrouplimit as isgrouplimit
,t1.iscallimit as iscallimit

from ${idl_schema}.icms_prd_catalog t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_prd_catalog.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
