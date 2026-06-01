/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_lm_tran_limit_def
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
create table ${iol_schema}.ncbs_rb_lm_tran_limit_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_lm_tran_limit_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def_op purge;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_tran_limit_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_lm_tran_limit_def where 0=1;

create table ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_lm_tran_limit_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl(
            ccy -- 币种
            ,company -- 法人
            ,deal_flow -- 处理方式
            ,enable_define -- 允许自定义标志
            ,limit_desc -- 限制说明
            ,limit_level -- 限制级别
            ,limit_ref -- 限额编码
            ,limit_status -- 限额状态
            ,limit_type -- 限额类型
            ,libra_op_time -- libra执行次数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_main_type -- 限额大类
            ,limit_term -- 限额累计频率
            ,limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
            ,limit_max_num -- 限额最大笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_lm_tran_limit_def_op(
            ccy -- 币种
            ,company -- 法人
            ,deal_flow -- 处理方式
            ,enable_define -- 允许自定义标志
            ,limit_desc -- 限制说明
            ,limit_level -- 限制级别
            ,limit_ref -- 限额编码
            ,limit_status -- 限额状态
            ,limit_type -- 限额类型
            ,libra_op_time -- libra执行次数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_main_type -- 限额大类
            ,limit_term -- 限额累计频率
            ,limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
            ,limit_max_num -- 限额最大笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deal_flow, o.deal_flow) as deal_flow -- 处理方式
    ,nvl(n.enable_define, o.enable_define) as enable_define -- 允许自定义标志
    ,nvl(n.limit_desc, o.limit_desc) as limit_desc -- 限制说明
    ,nvl(n.limit_level, o.limit_level) as limit_level -- 限制级别
    ,nvl(n.limit_ref, o.limit_ref) as limit_ref -- 限额编码
    ,nvl(n.limit_status, o.limit_status) as limit_status -- 限额状态
    ,nvl(n.limit_type, o.limit_type) as limit_type -- 限额类型
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.limit_max_amt, o.limit_max_amt) as limit_max_amt -- 最大限额
    ,nvl(n.limit_min_amt, o.limit_min_amt) as limit_min_amt -- 限额最小金额
    ,nvl(n.limit_main_type, o.limit_main_type) as limit_main_type -- 限额大类
    ,nvl(n.limit_term, o.limit_term) as limit_term -- 限额累计频率
    ,nvl(n.limit_check_method, o.limit_check_method) as limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
    ,nvl(n.limit_max_num, o.limit_max_num) as limit_max_num -- 限额最大笔数
    ,case when
            n.limit_ref is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.limit_ref is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.limit_ref is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_lm_tran_limit_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_lm_tran_limit_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.limit_ref = n.limit_ref
where (
        o.limit_ref is null
    )
    or (
        n.limit_ref is null
    )
    or (
        o.ccy <> n.ccy
        or o.company <> n.company
        or o.deal_flow <> n.deal_flow
        or o.enable_define <> n.enable_define
        or o.limit_desc <> n.limit_desc
        or o.limit_level <> n.limit_level
        or o.limit_status <> n.limit_status
        or o.limit_type <> n.limit_type
        or o.libra_op_time <> n.libra_op_time
        or o.effect_date <> n.effect_date
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.limit_max_amt <> n.limit_max_amt
        or o.limit_min_amt <> n.limit_min_amt
        or o.limit_main_type <> n.limit_main_type
        or o.limit_term <> n.limit_term
        or o.limit_check_method <> n.limit_check_method
        or o.limit_max_num <> n.limit_max_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl(
            ccy -- 币种
            ,company -- 法人
            ,deal_flow -- 处理方式
            ,enable_define -- 允许自定义标志
            ,limit_desc -- 限制说明
            ,limit_level -- 限制级别
            ,limit_ref -- 限额编码
            ,limit_status -- 限额状态
            ,limit_type -- 限额类型
            ,libra_op_time -- libra执行次数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_main_type -- 限额大类
            ,limit_term -- 限额累计频率
            ,limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
            ,limit_max_num -- 限额最大笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_lm_tran_limit_def_op(
            ccy -- 币种
            ,company -- 法人
            ,deal_flow -- 处理方式
            ,enable_define -- 允许自定义标志
            ,limit_desc -- 限制说明
            ,limit_level -- 限制级别
            ,limit_ref -- 限额编码
            ,limit_status -- 限额状态
            ,limit_type -- 限额类型
            ,libra_op_time -- libra执行次数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,limit_max_amt -- 最大限额
            ,limit_min_amt -- 限额最小金额
            ,limit_main_type -- 限额大类
            ,limit_term -- 限额累计频率
            ,limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
            ,limit_max_num -- 限额最大笔数
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.company -- 法人
    ,o.deal_flow -- 处理方式
    ,o.enable_define -- 允许自定义标志
    ,o.limit_desc -- 限制说明
    ,o.limit_level -- 限制级别
    ,o.limit_ref -- 限额编码
    ,o.limit_status -- 限额状态
    ,o.limit_type -- 限额类型
    ,o.libra_op_time -- libra执行次数
    ,o.effect_date -- 产品生效日期
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.limit_max_amt -- 最大限额
    ,o.limit_min_amt -- 限额最小金额
    ,o.limit_main_type -- 限额大类
    ,o.limit_term -- 限额累计频率
    ,o.limit_check_method -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
    ,o.limit_max_num -- 限额最大笔数
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
from ${iol_schema}.ncbs_rb_lm_tran_limit_def_bk o
    left join ${iol_schema}.ncbs_rb_lm_tran_limit_def_op n
        on
            o.limit_ref = n.limit_ref
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl d
        on
            o.limit_ref = d.limit_ref
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_lm_tran_limit_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_lm_tran_limit_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_lm_tran_limit_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_lm_tran_limit_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_lm_tran_limit_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl;
alter table ${iol_schema}.ncbs_rb_lm_tran_limit_def exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_lm_tran_limit_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_lm_tran_limit_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def_op purge;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_lm_tran_limit_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
