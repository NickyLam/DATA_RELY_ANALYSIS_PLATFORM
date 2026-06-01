: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_cc_guarcorres_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_cc_guarcorres.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.guarno,chr(13),''),chr(10),'') as guarno
,replace(replace(t1.bussno,chr(13),''),chr(10),'') as bussno
,replace(replace(t1.assconttype,chr(13),''),chr(10),'') as assconttype
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,t1.useassamt as useassamt
,replace(replace(t1.useasscurrency,chr(13),''),chr(10),'') as useasscurrency
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.state2,chr(13),''),chr(10),'') as state2
,t1.guarrate as guarrate
,t1.adguarrate as adguarrate
,replace(replace(t1.mainguartype,chr(13),''),chr(10),'') as mainguartype
,replace(replace(t1.isimp,chr(13),''),chr(10),'') as isimp
,replace(replace(t1.guarorder,chr(13),''),chr(10),'') as guarorder
,t1.guardate as guardate
,t1.guarvalue as guarvalue
,replace(replace(t1.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.barsign,chr(13),''),chr(10),'') as barsign
,'' as data_date
from ${iol_schema}.mims_cc_guarcorres t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_cc_guarcorres.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes