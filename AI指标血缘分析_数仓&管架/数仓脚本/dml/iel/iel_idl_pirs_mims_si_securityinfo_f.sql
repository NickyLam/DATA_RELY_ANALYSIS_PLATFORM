: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_si_securityinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_si_securityinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.guartype,chr(13),''),chr(10),'') as guartype
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.conominium,chr(13),''),chr(10),'') as conominium
,t1.conshare as conshare
,replace(replace(t1.effecttype,chr(13),''),chr(10),'') as effecttype
,replace(replace(t1.isinsure,chr(13),''),chr(10),'') as isinsure
,replace(replace(t1.guaregisterstate,chr(13),''),chr(10),'') as guaregisterstate
,replace(replace(t1.guainsurestate,chr(13),''),chr(10),'') as guainsurestate
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.usestate,chr(13),''),chr(10),'') as usestate
,replace(replace(t1.guaspecialstate,chr(13),''),chr(10),'') as guaspecialstate
,replace(replace(t1.bxability,chr(13),''),chr(10),'') as bxability
,replace(replace(t1.isotherguar,chr(13),''),chr(10),'') as isotherguar
,replace(replace(t1.isgencust,chr(13),''),chr(10),'') as isgencust
,t1.confmamt as confmamt
,replace(replace(t1.confmcurrency,chr(13),''),chr(10),'') as confmcurrency
,replace(replace(t1.evaldate,chr(13),''),chr(10),'') as evaldate
,replace(replace(t1.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t1.exapstate,chr(13),''),chr(10),'') as exapstate
,replace(replace(t1.editstate,chr(13),''),chr(10),'') as editstate
,replace(replace(t1.bxability2,chr(13),''),chr(10),'') as bxability2
,replace(replace(t1.isgain,chr(13),''),chr(10),'') as isgain
,replace(replace(t1.ismodify,chr(13),''),chr(10),'') as ismodify
,replace(replace(t1.guarinfoname,chr(13),''),chr(10),'') as guarinfoname
,replace(replace(t1.controlchange,chr(13),''),chr(10),'') as controlchange
,replace(replace(t1.updates,chr(13),''),chr(10),'') as updates
,replace(replace(t1.upduser,chr(13),''),chr(10),'') as upduser
,replace(replace(t1.issaveowner,chr(13),''),chr(10),'') as issaveowner
,'' as data_date
from ${iol_schema}.mims_si_securityinfo t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_si_securityinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes