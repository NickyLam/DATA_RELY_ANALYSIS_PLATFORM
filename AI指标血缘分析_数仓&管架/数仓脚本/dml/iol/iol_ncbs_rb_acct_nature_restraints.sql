/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_nature_restraints
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
create table ${iol_schema}.ncbs_rb_acct_nature_restraints_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_nature_restraints
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_nature_restraints_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_nature_restraints where 0=1;

create table ${iol_schema}.ncbs_rb_acct_nature_restraints_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_nature_restraints where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_nature_restraints_cl(
            restraint_type -- 限制类型
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_nature -- 存款账户类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_nature_restraints_op(
            restraint_type -- 限制类型
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_nature -- 存款账户类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.restraint_type, o.restraint_type) as restraint_type -- 限制类型
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_nature, o.acct_nature) as acct_nature -- 存款账户类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.restraint_type is null
            and n.acct_nature is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.restraint_type is null
            and n.acct_nature is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.restraint_type is null
            and n.acct_nature is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_nature_restraints_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_nature_restraints where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.restraint_type = n.restraint_type
            and o.acct_nature = n.acct_nature
where (
        o.restraint_type is null
        and o.acct_nature is null
    )
    or (
        n.restraint_type is null
        and n.acct_nature is null
    )
    or (
        o.term <> n.term
        or o.term_type <> n.term_type
        or o.company <> n.company
        or o.libra_op_time <> n.libra_op_time
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_nature_restraints_cl(
            restraint_type -- 限制类型
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_nature -- 存款账户类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_nature_restraints_op(
            restraint_type -- 限制类型
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_nature -- 存款账户类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.restraint_type -- 限制类型
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_nature -- 存款账户类型
    ,o.company -- 法人
    ,o.libra_op_time -- libra执行次数
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_rb_acct_nature_restraints_bk o
    left join ${iol_schema}.ncbs_rb_acct_nature_restraints_op n
        on
            o.restraint_type = n.restraint_type
            and o.acct_nature = n.acct_nature
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_nature_restraints_cl d
        on
            o.restraint_type = d.restraint_type
            and o.acct_nature = d.acct_nature
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_nature_restraints;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_nature_restraints') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_nature_restraints drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_nature_restraints add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_nature_restraints exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_nature_restraints_cl;
alter table ${iol_schema}.ncbs_rb_acct_nature_restraints exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_nature_restraints_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_nature_restraints to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_nature_restraints_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_nature_restraints',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
