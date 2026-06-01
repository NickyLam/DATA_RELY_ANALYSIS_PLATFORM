: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_si_securityinfo_a1
CreateDate: 20241211
FileName:   ${iel_data_path}/mims_si_securityinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.guartype,chr(13),''),chr(10),'') as guartype
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,replace(replace(t1.deptcode,chr(13),''),chr(10),'') as deptcode
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.conominium,chr(13),''),chr(10),'') as conominium
,conshare
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
,confmamt
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
,amount
,replace(replace(t1.issequence,chr(13),''),chr(10),'') as issequence
,replace(replace(t1.guarsign,chr(13),''),chr(10),'') as guarsign
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,etl_timestamp

from ${iol_schema}.mims_si_securityinfo t1
where 1 = 1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_si_securityinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
