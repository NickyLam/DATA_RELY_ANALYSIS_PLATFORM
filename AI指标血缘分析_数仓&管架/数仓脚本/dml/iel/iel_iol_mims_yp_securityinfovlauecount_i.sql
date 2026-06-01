: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_yp_securityinfovlauecount_i
CreateDate: 20240430
FileName:   ${iel_data_path}/mims_yp_securityinfovlauecount.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.businessinsid,chr(13),''),chr(10),'') as businessinsid
,replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.guartype,chr(13),''),chr(10),'') as guartype
,confmamt
,replace(replace(t1.confmcurrency,chr(13),''),chr(10),'') as confmcurrency
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.busovetime,chr(13),''),chr(10),'') as busovetime
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode

from ${iol_schema}.mims_yp_securityinfovlauecount t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_yp_securityinfovlauecount.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
