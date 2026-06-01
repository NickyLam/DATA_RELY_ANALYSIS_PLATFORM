: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icms_guaranty_info_f
CreateDate: 20250603
FileName:   ${iel_data_path}/icms_guaranty_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.guarantyid as guarantyid
,t1.rwisenoughvalue as rwisenoughvalue
,t1.ownertype as ownertype
,t1.contracttype as contracttype
,t1.evaluatenetvalue as evaluatenetvalue
,t1.guarantytype as guarantytype
,t1.floorarea as floorarea
,t1.rwlocation as rwlocation
,t1.rwbuildbuyprice as rwbuildbuyprice
,t1.evalorgname as evalorgname
,t1.ownerid as ownerid
,t1.realestatecode as realestatecode
,t1.guarantystatus as guarantystatus
,t1.updateorgid as updateorgid
,t1.rwpledgerate as rwpledgerate
,t1.guarantyname as guarantyname
,t1.lettertype as lettertype
,t1.lettercontry as lettercontry
,t1.evaldate as evaldate
,t1.ypguarantyid as ypguarantyid
,t1.migtflag as migtflag
,t1.letterno as letterno
,t1.certid as certid
,t1.confirmvalue as confirmvalue
,t1.inputuserid as inputuserid
,t1.lettersum as lettersum
,t1.guarantyrightid as guarantyrightid
,t1.inputdate as inputdate
,t1.guarantyrighttype as guarantyrighttype
,t1.updatedate as updatedate
,t1.updateuserid as updateuserid
,t1.issueorgtype as issueorgtype
,t1.ownername as ownername
,t1.certtype as certtype
,t1.guaranteetype as guaranteetype
,t1.lettercurrency as lettercurrency
,t1.inputorgid as inputorgid
,t1.rwpracticalvalue as rwpracticalvalue
,t1.guarantylocation as guarantylocation
,t1.aboutotherid1 as aboutotherid1

from ${idl_schema}.icms_guaranty_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_guaranty_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
