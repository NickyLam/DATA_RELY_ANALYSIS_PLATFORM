: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_oc_orgstruc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rwas_oc_orgstruc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.orgstrucid as orgstrucid
    ,replace(replace(t.orgstrucdesc,chr(13),''),chr(10),'') as orgstrucdesc
    ,t.orgl01 as orgl01
    ,t.orgl02 as orgl02
    ,t.orgl03 as orgl03
    ,t.orgl04 as orgl04
    ,t.orgl05 as orgl05
    ,t.orgl06 as orgl06
    ,t.orgl07 as orgl07
    ,t.orgl08 as orgl08
    ,t.orgl09 as orgl09
    ,t.orgl10 as orgl10
    ,t.orgl11 as orgl11
    ,t.orgl12 as orgl12
    ,t.orgl13 as orgl13
    ,t.orgl14 as orgl14
    ,t.orgl15 as orgl15
    ,t.orgl16 as orgl16
    ,t.orgl17 as orgl17
    ,t.orgl18 as orgl18
    ,t.orgl19 as orgl19
    ,t.orgl20 as orgl20
    ,replace(replace(t.currentrecdesc,chr(13),''),chr(10),'') as currentrecdesc
    ,t.fromtimeid as fromtimeid
    ,t.totimeid as totimeid
    ,t.creationdate as creationdate
    ,t.lastupdatedate as lastupdatedate
    ,t.activitytypeid as activitytypeid
    ,t.parentid as parentid
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rwas_oc_orgstruc t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_oc_orgstruc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes