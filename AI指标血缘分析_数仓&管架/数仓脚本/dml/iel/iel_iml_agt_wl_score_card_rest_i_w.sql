: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wl_score_card_rest_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_score_card_rest_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t.cred_rat_appl_flow_num,chr(13),''),chr(10),'') as cred_rat_appl_flow_num
,t.cred_rat_score as cred_rat_score
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_wl_score_card_rest t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_score_card_rest_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes