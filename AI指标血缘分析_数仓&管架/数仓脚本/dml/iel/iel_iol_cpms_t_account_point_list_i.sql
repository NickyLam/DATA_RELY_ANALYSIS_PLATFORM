: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cpms_t_account_point_list_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_t_account_point_list.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.id as id
    ,replace(replace(t.branch_no,chr(13),''),chr(10),'') as branch_no
    ,replace(replace(t.card_no,chr(13),''),chr(10),'') as card_no
    ,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
    ,replace(replace(t.custom_type,chr(13),''),chr(10),'') as custom_type
    ,replace(replace(t.consume_date,chr(13),''),chr(10),'') as consume_date
    ,replace(replace(t.consume_time,chr(13),''),chr(10),'') as consume_time
    ,replace(replace(t.merchant_no,chr(13),''),chr(10),'') as merchant_no
    ,replace(replace(t.merchant_name,chr(13),''),chr(10),'') as merchant_name
    ,replace(replace(t.trans_name,chr(13),''),chr(10),'') as trans_name
    ,replace(replace(t.trans_code,chr(13),''),chr(10),'') as trans_code
    ,t.trans_money as trans_money
    ,replace(replace(t.trans_type,chr(13),''),chr(10),'') as trans_type
    ,replace(replace(t.operate_type,chr(13),''),chr(10),'') as operate_type
    ,replace(replace(t.operate_type_name,chr(13),''),chr(10),'') as operate_type_name
    ,replace(replace(t.trans_channel,chr(13),''),chr(10),'') as trans_channel
    ,replace(replace(t.sub_trans_channel,chr(13),''),chr(10),'') as sub_trans_channel
    ,t.increase_point as increase_point
    ,t.reduce_point as reduce_point
    ,t.deduc_money as deduc_money
    ,t.remain_point as remain_point
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.operate_date,chr(13),''),chr(10),'') as operate_date
    ,replace(replace(t.operate_time,chr(13),''),chr(10),'') as operate_time
    ,replace(replace(t.operator_id,chr(13),''),chr(10),'') as operator_id
    ,replace(replace(t.author_id,chr(13),''),chr(10),'') as author_id
    ,replace(replace(t.operator_org,chr(13),''),chr(10),'') as operator_org
    ,replace(replace(t.operate_no,chr(13),''),chr(10),'') as operate_no
    ,replace(replace(t.jrnl_no,chr(13),''),chr(10),'') as jrnl_no
    ,replace(replace(t.tpcuid,chr(13),''),chr(10),'') as tpcuid
    ,replace(replace(t.uuid,chr(13),''),chr(10),'') as uuid
    ,replace(replace(t.point_time_begin,chr(13),''),chr(10),'') as point_time_begin
    ,replace(replace(t.summary,chr(13),''),chr(10),'') as summary
    ,replace(replace(t.expand_1,chr(13),''),chr(10),'') as expand_1
    ,replace(replace(t.expand_2,chr(13),''),chr(10),'') as expand_2
    ,replace(replace(t.expand_3,chr(13),''),chr(10),'') as expand_3
    ,replace(replace(t.expand_4,chr(13),''),chr(10),'') as expand_4
    ,replace(replace(t.expand_5,chr(13),''),chr(10),'') as expand_5
    ,replace(replace(t.is_valid,chr(13),''),chr(10),'') as is_valid
    ,replace(replace(t.last_ope_time,chr(13),''),chr(10),'') as last_ope_time
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.tran_seq_no_ih,chr(13),''),chr(10),'') as tran_seq_no_ih
    ,replace(replace(t.trans_chan,chr(13),''),chr(10),'') as trans_chan
    ,replace(replace(t.trade_type,chr(13),''),chr(10),'') as trade_type
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
from iol.cpms_t_account_point_list t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') 
  and t.end_dt > to_date('${batch_date}','yyyymmdd')
  and t.consume_date = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cpms_t_account_point_list.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes