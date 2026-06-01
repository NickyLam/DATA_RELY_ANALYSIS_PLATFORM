: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_connector_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_connector.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.connector_id as connector_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.connector_name,chr(13),''),chr(10),'') as connector_name
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.borrower_relation,chr(13),''),chr(10),'') as borrower_relation
,t.input_time as input_time
,t.lastupdate_time as lastupdate_time
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.idcard_no,chr(13),''),chr(10),'') as idcard_no
from iol.heps_hep_connector t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_connector.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes