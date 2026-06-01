: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ifs_prod_int_set_dtl_evt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ifs_prod_int_set_dtl_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,t1.stl_pric as stl_pric
,t1.exec_int_rat as exec_int_rat
,t1.ths_tm_int as ths_tm_int
,replace(replace(t1.tran_proc_status_cd,chr(13),''),chr(10),'') as tran_proc_status_cd
from ${iml_schema}.evt_ifs_prod_int_set_dtl_evt t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ifs_prod_int_set_dtl_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes