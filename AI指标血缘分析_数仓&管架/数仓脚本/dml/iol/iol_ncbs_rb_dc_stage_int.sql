/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_int
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
create table ${iol_schema}.ncbs_rb_dc_stage_int_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_dc_stage_int
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_int_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_int where 0=1;

create table ${iol_schema}.ncbs_rb_dc_stage_int_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_stage_int where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_int_cl(
            ccy -- 币种
            ,int_type -- 利率类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,seq_no -- 序号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_int_op(
            ccy -- 币种
            ,int_type -- 利率类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,seq_no -- 序号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.int_calc_type, o.int_calc_type) as int_calc_type -- 计息类型
    ,nvl(n.issue_year, o.issue_year) as issue_year -- 发行年度
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.stage_code, o.stage_code) as stage_code -- 期次代码
    ,nvl(n.stage_prod_class, o.stage_prod_class) as stage_prod_class -- 期次产品分类
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,case when
            n.seq_no is null
            and n.stage_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq_no is null
            and n.stage_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq_no is null
            and n.stage_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_dc_stage_int_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_dc_stage_int where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
            and o.stage_code = n.stage_code
where (
        o.seq_no is null
        and o.stage_code is null
    )
    or (
        n.seq_no is null
        and n.stage_code is null
    )
    or (
        o.ccy <> n.ccy
        or o.int_type <> n.int_type
        or o.prod_type <> n.prod_type
        or o.company <> n.company
        or o.event_type <> n.event_type
        or o.int_calc_type <> n.int_calc_type
        or o.issue_year <> n.issue_year
        or o.stage_prod_class <> n.stage_prod_class
        or o.tran_timestamp <> n.tran_timestamp
        or o.actual_rate <> n.actual_rate
        or o.float_rate <> n.float_rate
        or o.real_rate <> n.real_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_dc_stage_int_cl(
            ccy -- 币种
            ,int_type -- 利率类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,seq_no -- 序号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_dc_stage_int_op(
            ccy -- 币种
            ,int_type -- 利率类型
            ,prod_type -- 产品编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,seq_no -- 序号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.int_type -- 利率类型
    ,o.prod_type -- 产品编号
    ,o.company -- 法人
    ,o.event_type -- 事件类型
    ,o.int_calc_type -- 计息类型
    ,o.issue_year -- 发行年度
    ,o.seq_no -- 序号
    ,o.stage_code -- 期次代码
    ,o.stage_prod_class -- 期次产品分类
    ,o.tran_timestamp -- 交易时间戳
    ,o.actual_rate -- 行内利率
    ,o.float_rate -- 浮动利率
    ,o.real_rate -- 执行利率
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
from ${iol_schema}.ncbs_rb_dc_stage_int_bk o
    left join ${iol_schema}.ncbs_rb_dc_stage_int_op n
        on
            o.seq_no = n.seq_no
            and o.stage_code = n.stage_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_dc_stage_int_cl d
        on
            o.seq_no = d.seq_no
            and o.stage_code = d.stage_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_dc_stage_int;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_dc_stage_int') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_dc_stage_int drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_dc_stage_int add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_dc_stage_int exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_stage_int_cl;
alter table ${iol_schema}.ncbs_rb_dc_stage_int exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_dc_stage_int_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_stage_int to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_op purge;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_stage_int',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
