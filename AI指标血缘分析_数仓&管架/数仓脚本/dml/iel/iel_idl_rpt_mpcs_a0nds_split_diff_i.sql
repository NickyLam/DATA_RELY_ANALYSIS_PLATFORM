: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a0nds_split_diff_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a0nds_split_diff.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.partition_date,chr(13),''),chr(10),'') as partition_date
,replace(replace(t1.error_type,chr(13),''),chr(10),'') as error_type
,replace(replace(t1.bank_group_id,chr(13),''),chr(10),'') as bank_group_id
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.consumer_trans_id,chr(13),''),chr(10),'') as consumer_trans_id
,replace(replace(t1.reg_type,chr(13),''),chr(10),'') as reg_type
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.logical_card_no,chr(13),''),chr(10),'') as logical_card_no
,t1.bf_amt as bf_amt
,t1.account_amt as account_amt
,t1.error_amt as error_amt
,replace(replace(t1.batchfilename,chr(13),''),chr(10),'') as batchfilename
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
 from iol.mpcs_a0nds_split_diff T1
where batchfilename like '%${batch_date}%';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a0nds_split_diff.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes