: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knp_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knp_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.parmcd,chr(13),''),chr(10),'') as parmcd
,replace(replace(t.pmkey1,chr(13),''),chr(10),'') as pmkey1
,replace(replace(t.pmkey2,chr(13),''),chr(10),'') as pmkey2
,replace(replace(t.pmkey3,chr(13),''),chr(10),'') as pmkey3
,replace(replace(t.pmval1,chr(13),''),chr(10),'') as pmval1
,replace(replace(t.pmval2,chr(13),''),chr(10),'') as pmval2
,replace(replace(t.pmval3,chr(13),''),chr(10),'') as pmval3
,replace(replace(t.pmval4,chr(13),''),chr(10),'') as pmval4
,replace(replace(t.pmval5,chr(13),''),chr(10),'') as pmval5
,replace(replace(t.vermod,chr(13),''),chr(10),'') as vermod
,replace(replace(t.module,chr(13),''),chr(10),'') as module
,replace(replace(t.projcd,chr(13),''),chr(10),'') as projcd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_knp_para t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knp_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes