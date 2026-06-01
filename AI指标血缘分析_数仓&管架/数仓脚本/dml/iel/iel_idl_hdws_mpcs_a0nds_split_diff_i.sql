: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a0nds_split_diff_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a0nds_split_diff.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.partition_date
,t1.error_type
,t1.bank_group_id
,t1.bank_no
,t1.consumer_trans_id
,t1.reg_type
,t1.name
,t1.logical_card_no
,t1.bf_amt
,t1.account_amt
,t1.error_amt
,t1.batchfilename
,t1.seqno
from ${idl_schema}.hdws_mpcs_a0nds_split_diff t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a0nds_split_diff.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes