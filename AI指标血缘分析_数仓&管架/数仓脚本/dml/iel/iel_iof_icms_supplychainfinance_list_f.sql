: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_supplychainfinance_list_f
CreateDate: 20241113
FileName:   ${iel_data_path}/icms_supplychainfinance_list.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.operatebranchorgid,chr(13),''),chr(10),'') as operatebranchorgid
,balance
,replace(replace(t1.coreenterprisename,chr(13),''),chr(10),'') as coreenterprisename
,totalsum
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,maturity
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.putoutdate,chr(13),''),chr(10),'') as putoutdate
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.commissionrate,chr(13),''),chr(10),'') as commissionrate
,replace(replace(t1.supplychainfinancetype,chr(13),''),chr(10),'') as supplychainfinancetype
,businesssum
,additionalbailsum
,inputdate
,initbailsum
,replace(replace(t1.businessrate,chr(13),''),chr(10),'') as businessrate

from ${iol_schema}.icms_supplychainfinance_list t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_supplychainfinance_list.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
