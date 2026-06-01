: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_ci_custinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_ci_custinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.custid,chr(13),''),chr(10),'') as custid
    ,replace(replace(t.regioncode,chr(13),''),chr(10),'') as regioncode
    ,replace(replace(t.custname,chr(13),''),chr(10),'') as custname
    ,replace(replace(t.custflag,chr(13),''),chr(10),'') as custflag
    ,replace(replace(t.creditlevel,chr(13),''),chr(10),'') as creditlevel
    ,replace(replace(t.pd,chr(13),''),chr(10),'') as pd
    ,t.lnbal as lnbal
    ,replace(replace(t.custmgr,chr(13),''),chr(10),'') as custmgr
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.regionlayout,chr(13),''),chr(10),'') as regionlayout
    ,replace(replace(t.branchname,chr(13),''),chr(10),'') as branchname
    ,replace(replace(t.effectflag,chr(13),''),chr(10),'') as effectflag
    ,replace(replace(t.branchcode,chr(13),''),chr(10),'') as branchcode
    ,replace(replace(t.custscale,chr(13),''),chr(10),'') as custscale
    ,replace(replace(t.interindustry,chr(13),''),chr(10),'') as interindustry
    ,replace(replace(t.thisindustry,chr(13),''),chr(10),'') as thisindustry
    ,replace(replace(t.deptname,chr(13),''),chr(10),'') as deptname
    ,replace(replace(t.cardtype,chr(13),''),chr(10),'') as cardtype
    ,replace(replace(t.cardid,chr(13),''),chr(10),'') as cardid
    ,replace(replace(t.barsign,chr(13),''),chr(10),'') as barsign
    ,replace(replace(t.corecustid,chr(13),''),chr(10),'') as corecustid
    ,replace(replace(t.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
    ,replace(replace(t.establishdate,chr(13),''),chr(10),'') as establishdate
    ,replace(replace(t.ecifcustcode,chr(13),''),chr(10),'') as ecifcustcode
    ,replace(replace(t.regstarea,chr(13),''),chr(10),'') as regstarea
    ,t.subscribecapital as subscribecapital
    ,t.guarmoney as guarmoney
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.mims_ci_custinfo t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_ci_custinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes