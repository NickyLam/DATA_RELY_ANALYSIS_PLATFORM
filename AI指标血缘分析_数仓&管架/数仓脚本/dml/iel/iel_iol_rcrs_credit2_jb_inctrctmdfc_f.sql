: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_inctrctmdfc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_inctrctmdfc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.modreccode,chr(13),''),chr(10),'') as modreccode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.mdfcsgmtcode,chr(13),''),chr(10),'') as mdfcsgmtcode
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
    ,t.brernm as brernm
    ,replace(replace(t.ctrctcertreldata,chr(13),''),chr(10),'') as ctrctcertreldata
    ,replace(replace(t.creditlimtype,chr(13),''),chr(10),'') as creditlimtype
    ,replace(replace(t.limloopflg,chr(13),''),chr(10),'') as limloopflg
    ,t.creditlim as creditlim
    ,replace(replace(t.cy,chr(13),''),chr(10),'') as cy
    ,replace(replace(t.coneffdate,chr(13),''),chr(10),'') as coneffdate
    ,replace(replace(t.conexpdate,chr(13),''),chr(10),'') as conexpdate
    ,replace(replace(t.constatus,chr(13),''),chr(10),'') as constatus
    ,replace(replace(t.creditrest,chr(13),''),chr(10),'') as creditrest
    ,replace(replace(t.creditrestcode,chr(13),''),chr(10),'') as creditrestcode
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_inctrctmdfc t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_inctrctmdfc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes