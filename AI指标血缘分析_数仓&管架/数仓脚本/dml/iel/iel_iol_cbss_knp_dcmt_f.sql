: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_knp_dcmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_knp_dcmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.dcmttp,chr(13),''),chr(10),'') as dcmttp
,replace(replace(t.dcmtna,chr(13),''),chr(10),'') as dcmtna
,replace(replace(t.dcsmna,chr(13),''),chr(10),'') as dcsmna
,replace(replace(t.dcmtkd,chr(13),''),chr(10),'') as dcmtkd
,replace(replace(t.dcmtfs,chr(13),''),chr(10),'') as dcmtfs
,t.dcmtlt as dcmtlt
,t.btchlt as btchlt
,replace(replace(t.btchno,chr(13),''),chr(10),'') as btchno
,t.ebdcnm as ebdcnm
,replace(replace(t.setltp,chr(13),''),chr(10),'') as setltp
,replace(replace(t.selfdc,chr(13),''),chr(10),'') as selfdc
,replace(replace(t.csbxtg,chr(13),''),chr(10),'') as csbxtg
,replace(replace(t.saletg,chr(13),''),chr(10),'') as saletg
,replace(replace(t.brchct,chr(13),''),chr(10),'') as brchct
,replace(replace(t.secuty,chr(13),''),chr(10),'') as secuty
,replace(replace(t.dctptp,chr(13),''),chr(10),'') as dctptp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_knp_dcmt t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_knp_dcmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes