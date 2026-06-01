: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_acs_t_call_task_reg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_acs_t_call_task_reg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,process_inst_id
,main_flow_id
,scan_seq_no
,tr_date
,callcontext
,copname
,adminname
,admintelno
,adminmoboleno
,status
,calltimes
,lastacstime
,callresult
,create_date
,is_pass_time
,call_manager_center
,eteller_call_result
,task_operator
,adminposition
,question
,vfilecode
,discipline
,wait_task_id
,trun_eteller_reason
,call_repair_desc
,call_repair_opr
,is_dispense
,call_repair_result
,call_opr
,call_seq_no
,call_center_submit_time
,busi_center_obtain_time
,busi_center_submit_time
,ete_center_call_opr
,ete_center_call_desc
,ete_center_obtain_time
,ete_center_submit_time
from ${idl_schema}.odss_acs_t_call_task_reg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_acs_t_call_task_reg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes