: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_acpt_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_acpt_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.ETL_DT as ETL_DT
,replace(replace(t1.AGT_ID,chr(13),''),chr(10),'') as AGT_ID
,replace(replace(t1.LP_ID,chr(13),''),chr(10),'') as LP_ID
,replace(replace(t1.ACPT_DTL_ID,chr(13),''),chr(10),'') as ACPT_DTL_ID
,replace(replace(t1.BATCH_ID,chr(13),''),chr(10),'') as BATCH_ID
,replace(replace(t1.BILL_ID,chr(13),''),chr(10),'') as BILL_ID
,t1.COMM_FEE as COMM_FEE
,t1.TODOS as TODOS
,replace(replace(t1.EXP_UNCOND_PAY_ENTR_CD,chr(13),''),chr(10),'') as EXP_UNCOND_PAY_ENTR_CD
,replace(replace(t1.PAY_BANK_IBANK_NO,chr(13),''),chr(10),'') as PAY_BANK_IBANK_NO
,t1.LMT_DEDUCT_AMT as LMT_DEDUCT_AMT
,replace(replace(t1.BILL_ACPT_PROC_STATUS_CD,chr(13),''),chr(10),'') as BILL_ACPT_PROC_STATUS_CD
,t1.RECV_DT as RECV_DT
,replace(replace(t1.ENTRY_STATUS_CD,chr(13),''),chr(10),'') as ENTRY_STATUS_CD
,replace(replace(t1.RECV_OPINION_CD,chr(13),''),chr(10),'') as RECV_OPINION_CD
,t1.FINAL_MODIF_TM as FINAL_MODIF_TM
,replace(replace(t1.ACCPTOR_AGENT_REPLY_CD,chr(13),''),chr(10),'') as ACCPTOR_AGENT_REPLY_CD
,t1.ENTRY_DT as ENTRY_DT
,t1.REVO_DT as REVO_DT
,replace(replace(t1.DRAW_STATUS_CD,chr(13),''),chr(10),'') as DRAW_STATUS_CD
,replace(replace(t1.PAYOFF_FLG,chr(13),''),chr(10),'') as PAYOFF_FLG
,replace(replace(t1.BILL_PKG_INTRV_ID,chr(13),''),chr(10),'') as BILL_PKG_INTRV_ID
,t1.BILL_AMT as BILL_AMT
,t1.BILL_INTRV_CORP_AMT as BILL_INTRV_CORP_AMT
,t1.BILL_INTRV_QTTY as BILL_INTRV_QTTY
,t1.BILL_INTRV_QTTY as BILL_INTRV_QTTY
,replace(replace(t1.CRDT_OUT_ACCT_FLOW_NUM,chr(13),''),chr(10),'') as CRDT_OUT_ACCT_FLOW_NUM
,t1.CREATE_DT as CREATE_DT
,t1.UPDATE_DT as UPDATE_DT
,replace(replace(t1.ID_MARK,chr(13),''),chr(10),'') as ID_MARK
,replace(replace(t1.SRC_TABLE_NAME,chr(13),''),chr(10),'') as SRC_TABLE_NAME
from ${iml_schema}.agt_bill_acpt_dtl t1 
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_acpt_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes