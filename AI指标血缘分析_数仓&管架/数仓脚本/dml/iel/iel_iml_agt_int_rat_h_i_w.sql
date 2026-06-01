: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_int_rat_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_int_rat_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,t.start_dt as start_dt
,replace(replace(t.int_rat_id,chr(13),''),chr(10),'') as int_rat_id
,t.base_int_rat as base_int_rat
,t.exec_int_rat as exec_int_rat
,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,t.int_rat_float_point as int_rat_float_point
,t.int_rat_fl_rt as int_rat_fl_rt
,replace(replace(t.int_rat_period_cd,chr(13),''),chr(10),'') as int_rat_period_cd
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_int_rat_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6)  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_int_rat_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes