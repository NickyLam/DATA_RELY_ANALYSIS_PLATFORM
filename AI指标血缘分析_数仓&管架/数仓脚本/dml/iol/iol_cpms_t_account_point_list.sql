/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_point_list
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.cpms_t_account_point_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.cpms_t_account_point_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_point_list_op purge;
drop table ${iol_schema}.cpms_t_account_point_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cpms_t_account_point_list_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.cpms_t_account_point_list where 0=1;

create table ${iol_schema}.cpms_t_account_point_list_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.cpms_t_account_point_list where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.cpms_t_account_point_list_op(
        id -- 
        ,branch_no -- 
        ,card_no -- 
        ,customer_no -- 
        ,custom_type -- 
        ,consume_date -- 
        ,consume_time -- 
        ,merchant_no -- 
        ,merchant_name -- 
        ,trans_name -- 
        ,trans_code -- 
        ,trans_money -- 
        ,trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
        ,operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,trans_channel -- 
        ,sub_trans_channel -- 
        ,increase_point -- 
        ,reduce_point -- 
        ,deduc_money -- 
        ,remain_point -- 
        ,remark -- 
        ,operate_date -- 
        ,operate_time -- 
        ,operator_id -- 
        ,author_id -- 
        ,operator_org -- 
        ,operate_no -- 
        ,jrnl_no -- 
        ,tpcuid -- 
        ,uuid -- 
        ,point_time_begin -- 
        ,summary -- 
        ,expand_1 -- 
        ,expand_2 -- 
        ,expand_3 -- 
        ,expand_4 -- 
        ,expand_5 -- 
        ,is_valid -- 0-有效 1-失效
        ,last_ope_time -- 
        ,tran_seq_no_ih -- 聚合支付流水号
        ,trans_chan -- 交易渠道
        ,trade_type -- 交易类型
        ,memo -- 备注
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- 
    ,n.branch_no -- 
    ,n.card_no -- 
    ,n.customer_no -- 
    ,n.custom_type -- 
    ,n.consume_date -- 
    ,n.consume_time -- 
    ,n.merchant_no -- 
    ,n.merchant_name -- 
    ,n.trans_name -- 
    ,n.trans_code -- 
    ,n.trans_money -- 
    ,n.trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
    ,n.operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,n.operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,n.trans_channel -- 
    ,n.sub_trans_channel -- 
    ,n.increase_point -- 
    ,n.reduce_point -- 
    ,n.deduc_money -- 
    ,n.remain_point -- 
    ,n.remark -- 
    ,n.operate_date -- 
    ,n.operate_time -- 
    ,n.operator_id -- 
    ,n.author_id -- 
    ,n.operator_org -- 
    ,n.operate_no -- 
    ,n.jrnl_no -- 
    ,n.tpcuid -- 
    ,n.uuid -- 
    ,n.point_time_begin -- 
    ,n.summary -- 
    ,n.expand_1 -- 
    ,n.expand_2 -- 
    ,n.expand_3 -- 
    ,n.expand_4 -- 
    ,n.expand_5 -- 
    ,n.is_valid -- 0-有效 1-失效
    ,n.last_ope_time -- 
    ,n.tran_seq_no_ih -- 聚合支付流水号
    ,n.trans_chan -- 交易渠道
    ,n.trade_type -- 交易类型
    ,n.memo -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.cpms_t_account_point_list_bk o
    right join (select * from ${itl_schema}.cpms_t_account_point_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        o.branch_no <> n.branch_no
        or o.card_no <> n.card_no
        or o.customer_no <> n.customer_no
        or o.custom_type <> n.custom_type
        or o.consume_date <> n.consume_date
        or o.consume_time <> n.consume_time
        or o.merchant_no <> n.merchant_no
        or o.merchant_name <> n.merchant_name
        or o.trans_name <> n.trans_name
        or o.trans_code <> n.trans_code
        or o.trans_money <> n.trans_money
        or o.trans_type <> n.trans_type
        or o.operate_type <> n.operate_type
        or o.operate_type_name <> n.operate_type_name
        or o.trans_channel <> n.trans_channel
        or o.sub_trans_channel <> n.sub_trans_channel
        or o.increase_point <> n.increase_point
        or o.reduce_point <> n.reduce_point
        or o.deduc_money <> n.deduc_money
        or o.remain_point <> n.remain_point
        or o.remark <> n.remark
        or o.operate_date <> n.operate_date
        or o.operate_time <> n.operate_time
        or o.operator_id <> n.operator_id
        or o.author_id <> n.author_id
        or o.operator_org <> n.operator_org
        or o.operate_no <> n.operate_no
        or o.jrnl_no <> n.jrnl_no
        or o.tpcuid <> n.tpcuid
        or o.uuid <> n.uuid
        or o.point_time_begin <> n.point_time_begin
        or o.summary <> n.summary
        or o.expand_1 <> n.expand_1
        or o.expand_2 <> n.expand_2
        or o.expand_3 <> n.expand_3
        or o.expand_4 <> n.expand_4
        or o.expand_5 <> n.expand_5
        or o.is_valid <> n.is_valid
        or o.last_ope_time <> n.last_ope_time
        or o.tran_seq_no_ih <> n.tran_seq_no_ih
        or o.trans_chan <> n.trans_chan
        or o.trade_type <> n.trade_type
        or o.memo <> n.memo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cpms_t_account_point_list_cl(
            id -- 
        ,branch_no -- 
        ,card_no -- 
        ,customer_no -- 
        ,custom_type -- 
        ,consume_date -- 
        ,consume_time -- 
        ,merchant_no -- 
        ,merchant_name -- 
        ,trans_name -- 
        ,trans_code -- 
        ,trans_money -- 
        ,trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
        ,operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,trans_channel -- 
        ,sub_trans_channel -- 
        ,increase_point -- 
        ,reduce_point -- 
        ,deduc_money -- 
        ,remain_point -- 
        ,remark -- 
        ,operate_date -- 
        ,operate_time -- 
        ,operator_id -- 
        ,author_id -- 
        ,operator_org -- 
        ,operate_no -- 
        ,jrnl_no -- 
        ,tpcuid -- 
        ,uuid -- 
        ,point_time_begin -- 
        ,summary -- 
        ,expand_1 -- 
        ,expand_2 -- 
        ,expand_3 -- 
        ,expand_4 -- 
        ,expand_5 -- 
        ,is_valid -- 0-有效 1-失效
        ,last_ope_time -- 
        ,tran_seq_no_ih -- 聚合支付流水号
        ,trans_chan -- 交易渠道
        ,trade_type -- 交易类型
        ,memo -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cpms_t_account_point_list_op(
            id -- 
        ,branch_no -- 
        ,card_no -- 
        ,customer_no -- 
        ,custom_type -- 
        ,consume_date -- 
        ,consume_time -- 
        ,merchant_no -- 
        ,merchant_name -- 
        ,trans_name -- 
        ,trans_code -- 
        ,trans_money -- 
        ,trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
        ,operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
        ,trans_channel -- 
        ,sub_trans_channel -- 
        ,increase_point -- 
        ,reduce_point -- 
        ,deduc_money -- 
        ,remain_point -- 
        ,remark -- 
        ,operate_date -- 
        ,operate_time -- 
        ,operator_id -- 
        ,author_id -- 
        ,operator_org -- 
        ,operate_no -- 
        ,jrnl_no -- 
        ,tpcuid -- 
        ,uuid -- 
        ,point_time_begin -- 
        ,summary -- 
        ,expand_1 -- 
        ,expand_2 -- 
        ,expand_3 -- 
        ,expand_4 -- 
        ,expand_5 -- 
        ,is_valid -- 0-有效 1-失效
        ,last_ope_time -- 
        ,tran_seq_no_ih -- 聚合支付流水号
        ,trans_chan -- 交易渠道
        ,trade_type -- 交易类型
        ,memo -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.branch_no -- 
    ,o.card_no -- 
    ,o.customer_no -- 
    ,o.custom_type -- 
    ,o.consume_date -- 
    ,o.consume_time -- 
    ,o.merchant_no -- 
    ,o.merchant_name -- 
    ,o.trans_name -- 
    ,o.trans_code -- 
    ,o.trans_money -- 
    ,o.trans_type -- P-正交易；R-冲正交易；V-撤销交易；L-撤销冲正交易
    ,o.operate_type -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,o.operate_type_name -- 01消费积分；02换卡转移积分；03销卡积分清零；04开卡赠送积分；05礼品兑换；06礼品兑换撤销；07积分调整；08积分转移；09积分结转；10POS兑换；11年费兑换；12短信费兑换；13话费兑换；14消费积分冲正;15消费积分撤销;16消费积分撤销冲正;17POS兑换冲正；18POS兑换撤销；19POS兑换撤销冲正；20积分转移冲正；21积分调整冲正；22退货；23退货冲正；
    ,o.trans_channel -- 
    ,o.sub_trans_channel -- 
    ,o.increase_point -- 
    ,o.reduce_point -- 
    ,o.deduc_money -- 
    ,o.remain_point -- 
    ,o.remark -- 
    ,o.operate_date -- 
    ,o.operate_time -- 
    ,o.operator_id -- 
    ,o.author_id -- 
    ,o.operator_org -- 
    ,o.operate_no -- 
    ,o.jrnl_no -- 
    ,o.tpcuid -- 
    ,o.uuid -- 
    ,o.point_time_begin -- 
    ,o.summary -- 
    ,o.expand_1 -- 
    ,o.expand_2 -- 
    ,o.expand_3 -- 
    ,o.expand_4 -- 
    ,o.expand_5 -- 
    ,o.is_valid -- 0-有效 1-失效
    ,o.last_ope_time -- 
    ,o.tran_seq_no_ih -- 聚合支付流水号
    ,o.trans_chan -- 交易渠道
    ,o.trade_type -- 交易类型
    ,o.memo -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.cpms_t_account_point_list_bk o
    left join ${iol_schema}.cpms_t_account_point_list_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.cpms_t_account_point_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('cpms_t_account_point_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.cpms_t_account_point_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.cpms_t_account_point_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.cpms_t_account_point_list exchange partition p_${batch_date} with table ${iol_schema}.cpms_t_account_point_list_cl;
alter table ${iol_schema}.cpms_t_account_point_list exchange partition p_20991231 with table ${iol_schema}.cpms_t_account_point_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_account_point_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cpms_t_account_point_list_op purge;
drop table ${iol_schema}.cpms_t_account_point_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.cpms_t_account_point_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_account_point_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
