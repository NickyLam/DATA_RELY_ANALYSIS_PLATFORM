: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knp_wktp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knp_wktp.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.wktpcd,chr(13),''),chr(10),'') as wktpcd
,replace(replace(t.wktpna,chr(13),''),chr(10),'') as wktpna
,replace(replace(t.csbxtp,chr(13),''),chr(10),'') as csbxtp
,replace(replace(t.spclsc,chr(13),''),chr(10),'') as spclsc
,replace(replace(t.spclbr,chr(13),''),chr(10),'') as spclbr
,replace(replace(t.menugp,chr(13),''),chr(10),'') as menugp
,replace(replace(t.hvcsbx,chr(13),''),chr(10),'') as hvcsbx
,t.wkmxnm as wkmxnm
,replace(replace(t.mangtp,chr(13),''),chr(10),'') as mangtp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_knp_wktp t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knp_wktp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes