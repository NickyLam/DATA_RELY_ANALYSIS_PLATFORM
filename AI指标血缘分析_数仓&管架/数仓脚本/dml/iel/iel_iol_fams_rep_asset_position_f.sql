: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_rep_asset_position_f
CreateDate: 20240228
FileName:   ${iel_data_path}/fams_rep_asset_position.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cdate,chr(13),''),chr(10),'') as cdate
,replace(replace(t1.assetcode,chr(13),''),chr(10),'') as assetcode
,replace(replace(t1.assetname,chr(13),''),chr(10),'') as assetname
,replace(replace(t1.vdate,chr(13),''),chr(10),'') as vdate
,replace(replace(t1.mdate,chr(13),''),chr(10),'') as mdate
,replace(replace(t1.custrate,chr(13),''),chr(10),'') as custrate
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,position
,criceamt
,tdylossamt
,unpayamt
,friceamt
,replace(replace(t1.sppiactmdate,chr(13),''),chr(10),'') as sppiactmdate
,replace(replace(t1.accounttype,chr(13),''),chr(10),'') as accounttype
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.detailassettype,chr(13),''),chr(10),'') as detailassettype
,replace(replace(t1.profittype,chr(13),''),chr(10),'') as profittype
,replace(replace(t1.assettypeone,chr(13),''),chr(10),'') as assettypeone
,replace(replace(t1.assettypetwo,chr(13),''),chr(10),'') as assettypetwo
,replace(replace(t1.assettypethree,chr(13),''),chr(10),'') as assettypethree
,replace(replace(t1.assettypefour,chr(13),''),chr(10),'') as assettypefour
,replace(replace(t1.assettypesecone,chr(13),''),chr(10),'') as assettypesecone
,replace(replace(t1.assettypesectwo,chr(13),''),chr(10),'') as assettypesectwo
,replace(replace(t1.assettypeissueone,chr(13),''),chr(10),'') as assettypeissueone
,replace(replace(t1.maingrade,chr(13),''),chr(10),'') as maingrade
,replace(replace(t1.maingradeorg,chr(13),''),chr(10),'') as maingradeorg
,replace(replace(t1.creditgrade,chr(13),''),chr(10),'') as creditgrade
,replace(replace(t1.creditgradeorg,chr(13),''),chr(10),'') as creditgradeorg
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.investnature,chr(13),''),chr(10),'') as investnature
,replace(replace(t1.isstandasset,chr(13),''),chr(10),'') as isstandasset
,replace(replace(t1.investmenttype,chr(13),''),chr(10),'') as investmenttype
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_rep_asset_position t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_rep_asset_position.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
