: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_cc_guarcorres_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_cc_guarcorres.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.guarno,chr(13),''),chr(10),'') as guarno
,replace(replace(t.bussno,chr(13),''),chr(10),'') as bussno
,replace(replace(t.assconttype,chr(13),''),chr(10),'') as assconttype
,replace(replace(t.period,chr(13),''),chr(10),'') as period
,t.useassamt as useassamt
,replace(replace(t.useasscurrency,chr(13),''),chr(10),'') as useasscurrency
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,replace(replace(t.state2,chr(13),''),chr(10),'') as state2
,t.guarrate as guarrate
,t.adguarrate as adguarrate
,replace(replace(t.mainguartype,chr(13),''),chr(10),'') as mainguartype
,replace(replace(t.isimp,chr(13),''),chr(10),'') as isimp
,replace(replace(t.guarorder,chr(13),''),chr(10),'') as guarorder
,t.guardate as guardate
,t.guarvalue as guarvalue
,replace(replace(t.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t.barsign,chr(13),''),chr(10),'') as barsign
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mims_cc_guarcorres t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_cc_guarcorres.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes