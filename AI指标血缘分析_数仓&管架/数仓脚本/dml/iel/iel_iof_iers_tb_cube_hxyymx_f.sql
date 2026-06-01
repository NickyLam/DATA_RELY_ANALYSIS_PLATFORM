: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_tb_cube_hxyymx_f
CreateDate: 20251017
FileName:   ${iel_data_path}/iers_tb_cube_hxyymx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_obj,chr(13),''),chr(10),'') as pk_obj
,replace(replace(t1.uniqkey,chr(13),''),chr(10),'') as uniqkey
,replace(replace(t1.pk_mvtype,chr(13),''),chr(10),'') as pk_mvtype
,replace(replace(t1.code_mvtype,chr(13),''),chr(10),'') as code_mvtype
,replace(replace(t1.pk_version,chr(13),''),chr(10),'') as pk_version
,replace(replace(t1.code_version,chr(13),''),chr(10),'') as code_version
,replace(replace(t1.pk_curr,chr(13),''),chr(10),'') as pk_curr
,replace(replace(t1.code_curr,chr(13),''),chr(10),'') as code_curr
,replace(replace(t1.pk_entity,chr(13),''),chr(10),'') as pk_entity
,replace(replace(t1.code_entity,chr(13),''),chr(10),'') as code_entity
,replace(replace(t1.pk_measure,chr(13),''),chr(10),'') as pk_measure
,replace(replace(t1.code_measure,chr(13),''),chr(10),'') as code_measure
,replace(replace(t1.pk_year,chr(13),''),chr(10),'') as pk_year
,replace(replace(t1.code_year,chr(13),''),chr(10),'') as code_year
,replace(replace(t1.pk_quarter,chr(13),''),chr(10),'') as pk_quarter
,replace(replace(t1.code_quarter,chr(13),''),chr(10),'') as code_quarter
,replace(replace(t1.pk_month,chr(13),''),chr(10),'') as pk_month
,replace(replace(t1.code_month,chr(13),''),chr(10),'') as code_month
,value
,replace(replace(t1.txtvalue,chr(13),''),chr(10),'') as txtvalue
,status2
,status3
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,dr
,replace(replace(t1.pk_dept,chr(13),''),chr(10),'') as pk_dept
,replace(replace(t1.code_dept,chr(13),''),chr(10),'') as code_dept

from ${iol_schema}.iers_tb_cube_hxyymx t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_tb_cube_hxyymx.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
