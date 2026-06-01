: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_dpst_agent_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_dpst_agent_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,t1.txn_dt as txn_dt
,replace(replace(t1.agent_typ_cd,chr(13),''),chr(10),'') as agent_typ_cd
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_iden_typ_cd,chr(13),''),chr(10),'') as agent_iden_typ_cd
,replace(replace(t1.agent_iden_num,chr(13),''),chr(10),'') as agent_iden_num
,t1.agent_iden_due_day as agent_iden_due_day
,replace(replace(t1.agent_gend_cd,chr(13),''),chr(10),'') as agent_gend_cd
,replace(replace(t1.agent_cont_tel,chr(13),''),chr(10),'') as agent_cont_tel
,replace(replace(t1.agent_nation_cd,chr(13),''),chr(10),'') as agent_nation_cd
,t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'EVT_DPST_AGENT_TXN_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_DPST_AGENT_TXN_DTL') as etl_task_name 
from ${idl_schema}.hdws_iml_evt_dpst_agent_txn_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_dpst_agent_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes