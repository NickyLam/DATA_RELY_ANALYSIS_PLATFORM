: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_int_rat_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_int_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.int_rat_type_cd as int_rat_type_cd
,t1.int_rat_id as int_rat_id
,t1.base_int_rat as base_int_rat
,t1.exec_int_rat as exec_int_rat
,t1.int_rat_float_way_cd as int_rat_float_way_cd
,t1.int_rat_float_point as int_rat_float_point
,t1.int_rat_fl_rt as int_rat_fl_rt
,t1.int_rat_period_cd as int_rat_period_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_int_rat_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_int_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
