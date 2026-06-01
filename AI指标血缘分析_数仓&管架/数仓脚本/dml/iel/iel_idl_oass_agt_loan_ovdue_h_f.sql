: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_ovdue_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_ovdue_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.pric_ovdue_days as pric_ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.ovdue_pric as ovdue_pric
,t1.ovdue_int as ovdue_int
,t1.ovdue_pric_pnlt as ovdue_pric_pnlt
,t1.ovdue_int_pnlt as ovdue_int_pnlt
,t1.pric_turn_ovdue_dt as pric_turn_ovdue_dt
,t1.int_turn_ovdue_dt as int_turn_ovdue_dt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_ovdue_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_ovdue_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
