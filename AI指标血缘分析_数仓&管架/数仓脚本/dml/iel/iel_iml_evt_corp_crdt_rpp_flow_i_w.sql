: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_crdt_rpp_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_crdt_rpp_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.rpp_amt as rpp_amt
,t.rpp_dt as rpp_dt
,replace(replace(t.acct_bill_type_cd,chr(13),''),chr(10),'') as acct_bill_type_cd
,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t.term_num,chr(13),''),chr(10),'') as term_num
from ${iml_schema}.evt_corp_crdt_rpp_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_crdt_rpp_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes