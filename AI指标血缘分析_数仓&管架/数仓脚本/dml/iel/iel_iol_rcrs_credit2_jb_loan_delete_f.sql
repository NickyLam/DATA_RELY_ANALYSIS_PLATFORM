: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_loan_delete_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_loan_delete.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.delreccode,chr(13),''),chr(10),'') as delreccode
    ,replace(replace(t.delsgmtcode,chr(13),''),chr(10),'') as delsgmtcode
    ,replace(replace(t.delstartdate,chr(13),''),chr(10),'') as delstartdate
    ,replace(replace(t.delenddate,chr(13),''),chr(10),'') as delenddate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_loan_delete t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_loan_delete.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes