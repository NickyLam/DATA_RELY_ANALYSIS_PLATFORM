: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareleadunderwriter_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareleadunderwriter.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.s_lu_annissuedate,chr(13),''),chr(10),'') as s_lu_annissuedate
    ,replace(replace(t.s_lu_issuedate,chr(13),''),chr(10),'') as s_lu_issuedate
    ,replace(replace(t.s_lu_issuetype,chr(13),''),chr(10),'') as s_lu_issuetype
    ,t.s_lu_totalissuecollection as s_lu_totalissuecollection
    ,t.s_lu_totalissueexpenses as s_lu_totalissueexpenses
    ,t.s_lu_totaluderandsponefee as s_lu_totaluderandsponefee
    ,replace(replace(t.s_lu_number,chr(13),''),chr(10),'') as s_lu_number
    ,replace(replace(t.s_lu_name,chr(13),''),chr(10),'') as s_lu_name
    ,replace(replace(t.s_lu_institype,chr(13),''),chr(10),'') as s_lu_institype
    ,replace(replace(t.s_lu_aux_type,chr(13),''),chr(10),'') as s_lu_aux_type
    ,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
    ,replace(replace(t.all_lu,chr(13),''),chr(10),'') as all_lu
    ,replace(replace(t.meeting_dt,chr(13),''),chr(10),'') as meeting_dt
    ,replace(replace(t.pass_dt,chr(13),''),chr(10),'') as pass_dt
    ,replace(replace(t.s_info_listdate,chr(13),''),chr(10),'') as s_info_listdate
    ,replace(replace(t.type,chr(13),''),chr(10),'') as type
    ,t.netcollection as netcollection
    ,t.avg_totalcoll as avg_totalcoll
    ,t.avg_netcoll as avg_netcoll
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_ashareleadunderwriter t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareleadunderwriter.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes