/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_val_table_data
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
create table ${iol_schema}.fams_bok_val_table_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_val_table_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_val_table_data_op purge;
drop table ${iol_schema}.fams_bok_val_table_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_val_table_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_val_table_data where 0=1;

create table ${iol_schema}.fams_bok_val_table_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_val_table_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_val_table_data_cl(
            seq_no -- 流水号
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,profit_type -- 收益类型
            ,val_date -- 估值日期
            ,detail_dist -- 明细区分
            ,layering_id -- 分层代码
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,fsubject_id -- 上级科目号
            ,num_amt -- 数量
            ,unit_cost -- 单位成本
            ,cost -- 本币成本
            ,cost_percent -- 本币成本占净值比
            ,close_price -- 行情收市价
            ,market_value -- 本币估值
            ,value_percent -- 本币估值占净值比
            ,value_increment -- 本币估值增值
            ,bal_flag -- 余额方向
            ,shadow_price_value -- 影子价格估值
            ,market_val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,o_ccy -- 原币币种
            ,exchange_rate -- 汇率(原币对本币)
            ,o_cost -- 原币成本
            ,o_market_value -- 原币估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_val_table_data_op(
            seq_no -- 流水号
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,profit_type -- 收益类型
            ,val_date -- 估值日期
            ,detail_dist -- 明细区分
            ,layering_id -- 分层代码
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,fsubject_id -- 上级科目号
            ,num_amt -- 数量
            ,unit_cost -- 单位成本
            ,cost -- 本币成本
            ,cost_percent -- 本币成本占净值比
            ,close_price -- 行情收市价
            ,market_value -- 本币估值
            ,value_percent -- 本币估值占净值比
            ,value_increment -- 本币估值增值
            ,bal_flag -- 余额方向
            ,shadow_price_value -- 影子价格估值
            ,market_val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,o_ccy -- 原币币种
            ,exchange_rate -- 汇率(原币对本币)
            ,o_cost -- 原币成本
            ,o_market_value -- 原币估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq_no, o.seq_no) as seq_no -- 流水号
    ,nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.bookset_name, o.bookset_name) as bookset_name -- 账套名称
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 收益类型
    ,nvl(n.val_date, o.val_date) as val_date -- 估值日期
    ,nvl(n.detail_dist, o.detail_dist) as detail_dist -- 明细区分
    ,nvl(n.layering_id, o.layering_id) as layering_id -- 分层代码
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.subject_name, o.subject_name) as subject_name -- 科目名称
    ,nvl(n.fsubject_id, o.fsubject_id) as fsubject_id -- 上级科目号
    ,nvl(n.num_amt, o.num_amt) as num_amt -- 数量
    ,nvl(n.unit_cost, o.unit_cost) as unit_cost -- 单位成本
    ,nvl(n.cost, o.cost) as cost -- 本币成本
    ,nvl(n.cost_percent, o.cost_percent) as cost_percent -- 本币成本占净值比
    ,nvl(n.close_price, o.close_price) as close_price -- 行情收市价
    ,nvl(n.market_value, o.market_value) as market_value -- 本币估值
    ,nvl(n.value_percent, o.value_percent) as value_percent -- 本币估值占净值比
    ,nvl(n.value_increment, o.value_increment) as value_increment -- 本币估值增值
    ,nvl(n.bal_flag, o.bal_flag) as bal_flag -- 余额方向
    ,nvl(n.shadow_price_value, o.shadow_price_value) as shadow_price_value -- 影子价格估值
    ,nvl(n.market_val_date, o.market_val_date) as market_val_date -- 行情日期
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.o_ccy, o.o_ccy) as o_ccy -- 原币币种
    ,nvl(n.exchange_rate, o.exchange_rate) as exchange_rate -- 汇率(原币对本币)
    ,nvl(n.o_cost, o.o_cost) as o_cost -- 原币成本
    ,nvl(n.o_market_value, o.o_market_value) as o_market_value -- 原币估值
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
from (select * from ${iol_schema}.fams_bok_val_table_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_val_table_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.bookset_id <> n.bookset_id
        or o.bookset_name <> n.bookset_name
        or o.profit_type <> n.profit_type
        or o.val_date <> n.val_date
        or o.detail_dist <> n.detail_dist
        or o.layering_id <> n.layering_id
        or o.subject_no <> n.subject_no
        or o.subject_name <> n.subject_name
        or o.fsubject_id <> n.fsubject_id
        or o.num_amt <> n.num_amt
        or o.unit_cost <> n.unit_cost
        or o.cost <> n.cost
        or o.cost_percent <> n.cost_percent
        or o.close_price <> n.close_price
        or o.market_value <> n.market_value
        or o.value_percent <> n.value_percent
        or o.value_increment <> n.value_increment
        or o.bal_flag <> n.bal_flag
        or o.shadow_price_value <> n.shadow_price_value
        or o.market_val_date <> n.market_val_date
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.o_ccy <> n.o_ccy
        or o.exchange_rate <> n.exchange_rate
        or o.o_cost <> n.o_cost
        or o.o_market_value <> n.o_market_value
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_val_table_data_cl(
            seq_no -- 流水号
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,profit_type -- 收益类型
            ,val_date -- 估值日期
            ,detail_dist -- 明细区分
            ,layering_id -- 分层代码
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,fsubject_id -- 上级科目号
            ,num_amt -- 数量
            ,unit_cost -- 单位成本
            ,cost -- 本币成本
            ,cost_percent -- 本币成本占净值比
            ,close_price -- 行情收市价
            ,market_value -- 本币估值
            ,value_percent -- 本币估值占净值比
            ,value_increment -- 本币估值增值
            ,bal_flag -- 余额方向
            ,shadow_price_value -- 影子价格估值
            ,market_val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,o_ccy -- 原币币种
            ,exchange_rate -- 汇率(原币对本币)
            ,o_cost -- 原币成本
            ,o_market_value -- 原币估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_val_table_data_op(
            seq_no -- 流水号
            ,bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,profit_type -- 收益类型
            ,val_date -- 估值日期
            ,detail_dist -- 明细区分
            ,layering_id -- 分层代码
            ,subject_no -- 科目号
            ,subject_name -- 科目名称
            ,fsubject_id -- 上级科目号
            ,num_amt -- 数量
            ,unit_cost -- 单位成本
            ,cost -- 本币成本
            ,cost_percent -- 本币成本占净值比
            ,close_price -- 行情收市价
            ,market_value -- 本币估值
            ,value_percent -- 本币估值占净值比
            ,value_increment -- 本币估值增值
            ,bal_flag -- 余额方向
            ,shadow_price_value -- 影子价格估值
            ,market_val_date -- 行情日期
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,o_ccy -- 原币币种
            ,exchange_rate -- 汇率(原币对本币)
            ,o_cost -- 原币成本
            ,o_market_value -- 原币估值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq_no -- 流水号
    ,o.bookset_id -- 账套代码
    ,o.bookset_name -- 账套名称
    ,o.profit_type -- 收益类型
    ,o.val_date -- 估值日期
    ,o.detail_dist -- 明细区分
    ,o.layering_id -- 分层代码
    ,o.subject_no -- 科目号
    ,o.subject_name -- 科目名称
    ,o.fsubject_id -- 上级科目号
    ,o.num_amt -- 数量
    ,o.unit_cost -- 单位成本
    ,o.cost -- 本币成本
    ,o.cost_percent -- 本币成本占净值比
    ,o.close_price -- 行情收市价
    ,o.market_value -- 本币估值
    ,o.value_percent -- 本币估值占净值比
    ,o.value_increment -- 本币估值增值
    ,o.bal_flag -- 余额方向
    ,o.shadow_price_value -- 影子价格估值
    ,o.market_val_date -- 行情日期
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.o_ccy -- 原币币种
    ,o.exchange_rate -- 汇率(原币对本币)
    ,o.o_cost -- 原币成本
    ,o.o_market_value -- 原币估值
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
from ${iol_schema}.fams_bok_val_table_data_bk o
    left join ${iol_schema}.fams_bok_val_table_data_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_val_table_data_cl d
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
--truncate table ${iol_schema}.fams_bok_val_table_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_bok_val_table_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_bok_val_table_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_bok_val_table_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_bok_val_table_data exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_val_table_data_cl;
alter table ${iol_schema}.fams_bok_val_table_data exchange partition p_20991231 with table ${iol_schema}.fams_bok_val_table_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_val_table_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_val_table_data_op purge;
drop table ${iol_schema}.fams_bok_val_table_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_val_table_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_val_table_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
