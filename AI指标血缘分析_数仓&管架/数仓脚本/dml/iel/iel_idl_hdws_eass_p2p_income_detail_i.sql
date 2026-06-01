: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_eass_p2p_income_detail_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_eass_p2p_income_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.p2p_income_detail_id
,t1.merchant_id
,t1.invest_obj_id
,t1.tran_seq_no
,t1.req_seq_no
,t1.sub_seq_no
,t1.bw_ac_no
,t1.bw_ac_name
,t1.iv_fin_account_id
,t1.iv_fin_account_name
,t1.total_amt
,t1.income_date
,t1.amount
,t1.principal_amt
,t1.income_amt
,t1.fee_amt
,t1.status_id
,t1.remark
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_eass_p2p_income_detail t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_eass_p2p_income_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes