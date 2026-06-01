: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_evt_agent_txn_addi_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_evt_agent_txn_addi.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,t1.txn_dt as txn_dt
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_iden_type,chr(13),''),chr(10),'') as agent_iden_type
,replace(replace(t1.agent_iden_num,chr(13),''),chr(10),'') as agent_iden_num
,replace(replace(t1.agent_iden_valid_dt,chr(13),''),chr(10),'') as agent_iden_valid_dt
,replace(replace(t1.agent_tel,chr(13),''),chr(10),'') as agent_tel
,t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
from ${idl_schema}.hdws_dul_d_opr_evt_agent_txn_addi t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_evt_agent_txn_addi.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes