: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a0nds_split_diff_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a0nds_split_diff.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.partition_date,chr(13),''),chr(10),'') as partition_date
,replace(replace(t.error_type,chr(13),''),chr(10),'') as error_type
,replace(replace(t.bank_group_id,chr(13),''),chr(10),'') as bank_group_id
,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t.consumer_trans_id,chr(13),''),chr(10),'') as consumer_trans_id
,replace(replace(t.reg_type,chr(13),''),chr(10),'') as reg_type
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.logical_card_no,chr(13),''),chr(10),'') as logical_card_no
,t.bf_amt as bf_amt
,t.account_amt as account_amt
,t.error_amt as error_amt
,replace(replace(t.batchfilename,chr(13),''),chr(10),'') as batchfilename
,replace(replace(t.seqno,chr(13),''),chr(10),'') as seqno
from ${iol_schema}.MPCS_A0NDS_SPLIT_DIFF t 
where BATCHFILENAME LIKE '%${batch_date}%';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a0nds_split_diff.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes