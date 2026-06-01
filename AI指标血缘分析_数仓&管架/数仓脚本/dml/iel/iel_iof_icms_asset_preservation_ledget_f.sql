: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_asset_preservation_ledget_f
CreateDate: 20230919
FileName:   ${iel_data_path}/icms_asset_preservation_ledget.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.branchbusinessdivision,chr(13),''),chr(10),'') as branchbusinessdivision
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.duebillid,chr(13),''),chr(10),'') as duebillid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.entscale,chr(13),''),chr(10),'') as entscale
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,begincreditbalance
,replace(replace(t1.beginriskclassify,chr(13),''),chr(10),'') as beginriskclassify
,firsttimedesc
,replace(replace(t1.riskisolationresults,chr(13),''),chr(10),'') as riskisolationresults
,ironridetime
,replace(replace(t1.handleriskclassify,chr(13),''),chr(10),'') as handleriskclassify
,replace(replace(t1.handletype,chr(13),''),chr(10),'') as handletype
,replace(replace(t1.typeassettransfer,chr(13),''),chr(10),'') as typeassettransfer
,handletime
,handlebalance
,replace(replace(t1.repaymentresource,chr(13),''),chr(10),'') as repaymentresource
,handleinterestbalance
,handlechargedbalance
,handlereinterestedbalance
,handlesubstitutecushion
,replace(replace(t1.beforeclassifyresult,chr(13),''),chr(10),'') as beforeclassifyresult
,beforebalance
,replace(replace(t1.afterclassifyresult,chr(13),''),chr(10),'') as afterclassifyresult
,cashoffdate
,recoveroffbalance
,normalrecoverbalance
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype

from ${iol_schema}.icms_asset_preservation_ledget t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_asset_preservation_ledget.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
