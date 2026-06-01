: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_ywgj_d_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_ywgj_d_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,curr_code
,branch_code
,branch_name
,code1
,name1
,bal1
,code2
,name2
,bal2
,processor
from ${idl_schema}.orws_m_omd_ywgj_d
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_ywgj_d_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes