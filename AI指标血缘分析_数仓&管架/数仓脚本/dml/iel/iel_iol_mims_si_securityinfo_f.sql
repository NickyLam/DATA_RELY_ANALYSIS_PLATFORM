: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_si_securityinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_si_securityinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t.guartype,chr(13),''),chr(10),'') as guartype
,replace(replace(t.createuser,chr(13),''),chr(10),'') as createuser
,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t.conominium,chr(13),''),chr(10),'') as conominium
,t.conshare as conshare
,replace(replace(t.effecttype,chr(13),''),chr(10),'') as effecttype
,replace(replace(t.isinsure,chr(13),''),chr(10),'') as isinsure
,replace(replace(t.guaregisterstate,chr(13),''),chr(10),'') as guaregisterstate
,replace(replace(t.guainsurestate,chr(13),''),chr(10),'') as guainsurestate
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,replace(replace(t.usestate,chr(13),''),chr(10),'') as usestate
,replace(replace(t.guaspecialstate,chr(13),''),chr(10),'') as guaspecialstate
,replace(replace(t.bxability,chr(13),''),chr(10),'') as bxability
,replace(replace(t.isotherguar,chr(13),''),chr(10),'') as isotherguar
,replace(replace(t.isgencust,chr(13),''),chr(10),'') as isgencust
,t.confmamt as confmamt
,replace(replace(t.confmcurrency,chr(13),''),chr(10),'') as confmcurrency
,replace(replace(t.evaldate,chr(13),''),chr(10),'') as evaldate
,replace(replace(t.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t.exapstate,chr(13),''),chr(10),'') as exapstate
,replace(replace(t.editstate,chr(13),''),chr(10),'') as editstate
,replace(replace(t.bxability2,chr(13),''),chr(10),'') as bxability2
,replace(replace(t.isgain,chr(13),''),chr(10),'') as isgain
,replace(replace(t.ismodify,chr(13),''),chr(10),'') as ismodify
,replace(replace(t.guarinfoname,chr(13),''),chr(10),'') as guarinfoname
,replace(replace(t.controlchange,chr(13),''),chr(10),'') as controlchange
,replace(replace(t.updates,chr(13),''),chr(10),'') as updates
,replace(replace(t.upduser,chr(13),''),chr(10),'') as upduser
,replace(replace(t.issaveowner,chr(13),''),chr(10),'') as issaveowner
,t.amount as amount
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_si_securityinfo t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_si_securityinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes