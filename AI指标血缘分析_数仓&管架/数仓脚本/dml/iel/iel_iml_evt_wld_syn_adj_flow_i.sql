: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_wld_syn_adj_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_wld_syn_adj_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.batch_doc_name,chr(13),''),chr(10),'') as batch_doc_name
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.logic_card_no,chr(13),''),chr(10),'') as logic_card_no
,t1.exc_resv_clear_amt as exc_resv_clear_amt
,t1.cnc_entry_amt as cnc_entry_amt
,t1.should_adj_bal as should_adj_bal
,t1.batch_dt as batch_dt
,replace(replace(t1.excep_type_cd,chr(13),''),chr(10),'') as excep_type_cd
from ${iml_schema}.evt_wld_syn_adj_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wld_syn_adj_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes