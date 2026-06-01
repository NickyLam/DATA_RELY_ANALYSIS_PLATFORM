: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_pol_rule_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_pol_rule.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.rule_code,chr(13),''),chr(10),'') as rule_code
,replace(replace(t.variable_code,chr(13),''),chr(10),'') as variable_code
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.operator,chr(13),''),chr(10),'') as operator
,replace(replace(t.param,chr(13),''),chr(10),'') as param
,t.ctime as ctime
,replace(replace(t.cuid,chr(13),''),chr(10),'') as cuid
,t.mtime as mtime
,replace(replace(t.muid,chr(13),''),chr(10),'') as muid
,t.version as version
,replace(replace(t.assemble_code,chr(13),''),chr(10),'') as assemble_code
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_pol_rule t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_pol_rule.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes