: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_fo_extend_info_f
CreateDate: 20241021
FileName:   ${iel_data_path}/icms_fo_extend_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.vouchtype,chr(13),''),chr(10),'') as vouchtype
,replace(replace(t1.othervouchtype,chr(13),''),chr(10),'') as othervouchtype
,replace(replace(t1.credittypeone,chr(13),''),chr(10),'') as credittypeone
,replace(replace(t1.ownerline,chr(13),''),chr(10),'') as ownerline
,replace(replace(t1.credittypetwo,chr(13),''),chr(10),'') as credittypetwo
,replace(replace(t1.creditareaflag,chr(13),''),chr(10),'') as creditareaflag
,replace(replace(t1.iscityinvestcomp,chr(13),''),chr(10),'') as iscityinvestcomp
,replace(replace(t1.ownershipclassify,chr(13),''),chr(10),'') as ownershipclassify
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.iscreditpolicy,chr(13),''),chr(10),'') as iscreditpolicy
,replace(replace(t1.iscredit,chr(13),''),chr(10),'') as iscredit
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.updateorg,chr(13),''),chr(10),'') as updateorg
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,inputtime
,updatetime
,replace(replace(t1.isprojectloan,chr(13),''),chr(10),'') as isprojectloan
,replace(replace(t1.iscityupdate,chr(13),''),chr(10),'') as iscityupdate
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.score,chr(13),''),chr(10),'') as score

from ${iol_schema}.icms_fo_extend_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_fo_extend_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
