: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_fina_row_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_fina_row.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rowno as rowno
,replace(replace(t1.sheetno,chr(13),''),chr(10),'') as sheetno
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.valueone,chr(13),''),chr(10),'') as valueone
,replace(replace(t1.rowname,chr(13),''),chr(10),'') as rowname
,t1.standardvalue as standardvalue
,replace(replace(t1.subjectno,chr(13),''),chr(10),'') as subjectno
,replace(replace(t1.valuetwo,chr(13),''),chr(10),'') as valuetwo
,t1.inputdate as inputdate
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,t1.valuefour as valuefour
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,t1.updatedate as updatedate
,t1.valuethree as valuethree
,replace(replace(t1.displayorder,chr(13),''),chr(10),'') as displayorder
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
from ${iol_schema}.icms_fina_row t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_fina_row.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes