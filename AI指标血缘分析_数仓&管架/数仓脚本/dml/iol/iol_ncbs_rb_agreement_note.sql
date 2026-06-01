/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_note
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_agreement_note_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_note
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_note_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_note_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_note_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_note where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_note_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_note where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_note_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,seq_no -- 序号
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,fin_amt_unit -- 理财基数
            ,fin_prod_type -- 理财产品编号
            ,int_min_amt -- 最小起存金额
            ,real_rate -- 执行利率
            ,fin_fixed_amt -- 理财固定金额
            ,fin_turn_method -- 理财转回方式
            ,note_turn_type -- 理财转回类型
            ,fin_cycle_method -- 理财利息结算方式
            ,fin_renew_type -- 理财转存类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_note_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,seq_no -- 序号
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,fin_amt_unit -- 理财基数
            ,fin_prod_type -- 理财产品编号
            ,int_min_amt -- 最小起存金额
            ,real_rate -- 执行利率
            ,fin_fixed_amt -- 理财固定金额
            ,fin_turn_method -- 理财转回方式
            ,note_turn_type -- 理财转回类型
            ,fin_cycle_method -- 理财利息结算方式
            ,fin_renew_type -- 理财转存类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.lowest_amt, o.lowest_amt) as lowest_amt -- 保底金额
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.fin_amt_unit, o.fin_amt_unit) as fin_amt_unit -- 理财基数
    ,nvl(n.fin_prod_type, o.fin_prod_type) as fin_prod_type -- 理财产品编号
    ,nvl(n.int_min_amt, o.int_min_amt) as int_min_amt -- 最小起存金额
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.fin_fixed_amt, o.fin_fixed_amt) as fin_fixed_amt -- 理财固定金额
    ,nvl(n.fin_turn_method, o.fin_turn_method) as fin_turn_method -- 理财转回方式
    ,nvl(n.note_turn_type, o.note_turn_type) as note_turn_type -- 理财转回类型
    ,nvl(n.fin_cycle_method, o.fin_cycle_method) as fin_cycle_method -- 理财利息结算方式
    ,nvl(n.fin_renew_type, o.fin_renew_type) as fin_renew_type -- 理财转存类型
    ,case when
            n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_note_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_note where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.agreement_id <> n.agreement_id
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.company <> n.company
        or o.lowest_amt <> n.lowest_amt
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.fin_amt_unit <> n.fin_amt_unit
        or o.fin_prod_type <> n.fin_prod_type
        or o.int_min_amt <> n.int_min_amt
        or o.real_rate <> n.real_rate
        or o.fin_fixed_amt <> n.fin_fixed_amt
        or o.fin_turn_method <> n.fin_turn_method
        or o.note_turn_type <> n.note_turn_type
        or o.fin_cycle_method <> n.fin_cycle_method
        or o.fin_renew_type <> n.fin_renew_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_note_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,seq_no -- 序号
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,fin_amt_unit -- 理财基数
            ,fin_prod_type -- 理财产品编号
            ,int_min_amt -- 最小起存金额
            ,real_rate -- 执行利率
            ,fin_fixed_amt -- 理财固定金额
            ,fin_turn_method -- 理财转回方式
            ,note_turn_type -- 理财转回类型
            ,fin_cycle_method -- 理财利息结算方式
            ,fin_renew_type -- 理财转存类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_note_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,term -- 存期
            ,term_type -- 期限单位
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,seq_no -- 序号
            ,lowest_amt -- 保底金额
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,fin_amt_unit -- 理财基数
            ,fin_prod_type -- 理财产品编号
            ,int_min_amt -- 最小起存金额
            ,real_rate -- 执行利率
            ,fin_fixed_amt -- 理财固定金额
            ,fin_turn_method -- 理财转回方式
            ,note_turn_type -- 理财转回类型
            ,fin_cycle_method -- 理财利息结算方式
            ,fin_renew_type -- 理财转存类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.company -- 法人
    ,o.seq_no -- 序号
    ,o.lowest_amt -- 保底金额
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.fin_amt_unit -- 理财基数
    ,o.fin_prod_type -- 理财产品编号
    ,o.int_min_amt -- 最小起存金额
    ,o.real_rate -- 执行利率
    ,o.fin_fixed_amt -- 理财固定金额
    ,o.fin_turn_method -- 理财转回方式
    ,o.note_turn_type -- 理财转回类型
    ,o.fin_cycle_method -- 理财利息结算方式
    ,o.fin_renew_type -- 理财转存类型
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_agreement_note_bk o
    left join ${iol_schema}.ncbs_rb_agreement_note_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_note_cl d
        on
            o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_note;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_note') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_note drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_note add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_note exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_note_cl;
alter table ${iol_schema}.ncbs_rb_agreement_note exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_note_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_note to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_note_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_note_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_note_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_note',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
