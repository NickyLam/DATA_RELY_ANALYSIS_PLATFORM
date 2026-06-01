: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_myloan_repay_plan_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_myloan_repay_plan_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.pd_num,chr(13),''),chr(10),'') as pd_num
,t.rpbl_int as rpbl_int
,t.rpbl_pric as rpbl_pric
,t.inst_start_dt as inst_start_dt
,t.inst_end_dt as inst_end_dt
,replace(replace(t.inst_status_cd,chr(13),''),chr(10),'') as inst_status_cd
,t.payoff_dt as payoff_dt
,t.pric_turn_ovdue_dt as pric_turn_ovdue_dt
,t.int_turn_ovdue_dt as int_turn_ovdue_dt
,t.pric_ovdue_days as pric_ovdue_days
,t.int_ovdue_days as int_ovdue_days
,t.pric_bal as pric_bal
,t.int_bal as int_bal
,t.rpbl_ovdue_pric_pnlt as rpbl_ovdue_pric_pnlt
,t.rpbl_ovdue_int_pnlt as rpbl_ovdue_int_pnlt
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_myloan_repay_plan_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_repay_plan_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes