: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_status_h_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_status_h_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}', 'yyyymmdd') as ETL_DT
,replace(replace(t1.AGT_ID,chr(13),''),chr(10),'') as AGT_ID
,replace(replace(t1.LP_ID,chr(13),''),chr(10),'') as LP_ID
,replace(replace(t1.AGT_STATUS_TYPE_CD,chr(13),''),chr(10),'') as AGT_STATUS_TYPE_CD
,t1.START_DT as START_DT
,replace(replace(t1.AGT_STATUS_CD,chr(13),''),chr(10),'') as AGT_STATUS_CD
,t1.END_DT as END_DT
,replace(replace(t1.ID_MARK,chr(13),''),chr(10),'') as ID_MARK
,replace(replace(t1.SRC_TABLE_NAME,chr(13),''),chr(10),'') as SRC_TABLE_NAME
from ${iml_schema}.agt_status_h t1 
where (start_dt <= to_date('${batch_date}', 'yyyymmdd') and
       start_dt >= to_date('${batch_date}', 'yyyymmdd') - 6)
    or (end_dt <= to_date('${batch_date}', 'yyyymmdd') and
       end_dt >= to_date('${batch_date}', 'yyyymmdd') - 6)   ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_status_h_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes