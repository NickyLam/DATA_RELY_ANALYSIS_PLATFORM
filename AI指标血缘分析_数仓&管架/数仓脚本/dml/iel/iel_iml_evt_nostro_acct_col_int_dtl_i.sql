: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_nostro_acct_col_int_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_nostro_acct_col_int_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,t.col_int_start_dt as col_int_start_dt
    ,t.col_int_end_dt as col_int_end_dt
    ,t.int_accr_start_dt as int_accr_start_dt
    ,t.int_accr_end_dt as int_accr_end_dt
    ,t.exec_int_rat as exec_int_rat
    ,replace(replace(t.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
    ,t.provi_int as provi_int
    ,t.actl_recv_int as actl_recv_int
    ,replace(replace(t.col_int_proc_flg,chr(13),''),chr(10),'') as col_int_proc_flg
    ,t.col_int_proc_dt as col_int_proc_dt
    ,replace(replace(t.col_int_proc_flow_num,chr(13),''),chr(10),'') as col_int_proc_flow_num
from iml.evt_nostro_acct_col_int_dtl t
where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_nostro_acct_col_int_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes