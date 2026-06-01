: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_ovdue_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_ovdue_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
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
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_loan_ovdue_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd')-1 and end_dt > to_date('${batch_date}','yyyymmdd')-1;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_ovdue_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes