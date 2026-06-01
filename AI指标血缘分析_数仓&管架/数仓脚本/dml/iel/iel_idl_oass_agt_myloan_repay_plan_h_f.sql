: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_myloan_repay_plan_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_myloan_repay_plan_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.dubil_id as dubil_id
,t1.pd_num as pd_num
,t1.rpbl_int as rpbl_int
,t1.rpbl_pric as rpbl_pric
,t1.inst_start_dt as inst_start_dt
,t1.inst_end_dt as inst_end_dt
,t1.inst_status_cd as inst_status_cd
,t1.payoff_dt as payoff_dt
,t1.pric_turn_ovdue_dt as pric_turn_ovdue_dt
,t1.int_turn_ovdue_dt as int_turn_ovdue_dt
,t1.pric_ovdue_days as pric_ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.pric_bal as pric_bal
,t1.int_bal as int_bal
,t1.rpbl_ovdue_pric_pnlt as rpbl_ovdue_pric_pnlt
,t1.rpbl_ovdue_int_pnlt as rpbl_ovdue_int_pnlt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_myloan_repay_plan_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_myloan_repay_plan_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
