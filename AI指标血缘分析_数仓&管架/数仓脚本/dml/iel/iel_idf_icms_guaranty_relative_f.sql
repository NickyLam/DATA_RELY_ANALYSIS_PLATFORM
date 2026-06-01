: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_icms_guaranty_relative_f
CreateDate: 20250603
FileName:   ${iel_data_path}/icms_guaranty_relative.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.objecttype as objecttype
,t1.objectno as objectno
,t1.guarantycontractno as guarantycontractno
,t1.clrid as clrid
,t1.guarantycurrency as guarantycurrency
,t1.inputuserid as inputuserid
,t1.inputorgid as inputorgid
,t1.updatedate as updatedate
,t1.guarantysum as guarantysum
,t1.guarantyrate as guarantyrate
,t1.inputdate as inputdate
,t1.isapplyinput as isapplyinput
,t1.migtflag as migtflag
,t1.updateorgid as updateorgid
,t1.updateuserid as updateuserid
,t1.issecondmortgage as issecondmortgage
,t1.relationstatus as relationstatus
,t1.remark as remark
,t1.actualguarantyrate as actualguarantyrate
,t1.balancefirst as balancefirst
,t1.businesssumfirst as businesssumfirst

from ${idl_schema}.icms_guaranty_relative t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_guaranty_relative.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
