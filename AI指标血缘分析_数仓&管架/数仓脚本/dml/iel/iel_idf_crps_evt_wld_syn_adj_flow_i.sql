: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_evt_wld_syn_adj_flow_i
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_evt_wld_syn_adj_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.batch_doc_name as batch_doc_name
,t1.seq_num as seq_num
,t1.bus_flow_num as bus_flow_num
,t1.syn_id as syn_id
,t1.bank_id as bank_id
,t1.tran_type_cd as tran_type_cd
,t1.logic_card_no as logic_card_no
,t1.exc_resv_clear_amt as exc_resv_clear_amt
,t1.cnc_entry_amt as cnc_entry_amt
,t1.should_adj_bal as should_adj_bal
,t1.batch_dt as batch_dt
,t1.excep_type_cd as excep_type_cd
,t1.cust_name as cust_name

from ${idl_schema}.crps_evt_wld_syn_adj_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_evt_wld_syn_adj_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
