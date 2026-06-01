/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_alloc_define
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
create table ${iol_schema}.ncbs_cl_alloc_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_alloc_define
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_alloc_define_op purge;
drop table ${iol_schema}.ncbs_cl_alloc_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_alloc_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_alloc_define where 0=1;

create table ${iol_schema}.ncbs_cl_alloc_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_alloc_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_alloc_define_cl(
            alloc_code -- 扣款顺序编号
            ,alloc_desc -- 扣款顺序描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_alloc_define_op(
            alloc_code -- 扣款顺序编号
            ,alloc_desc -- 扣款顺序描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.alloc_code, o.alloc_code) as alloc_code -- 扣款顺序编号
    ,nvl(n.alloc_desc, o.alloc_desc) as alloc_desc -- 扣款顺序描述
    ,nvl(n.alloc_seq_fee, o.alloc_seq_fee) as alloc_seq_fee -- 贷款费用还款顺序
    ,nvl(n.alloc_seq_int, o.alloc_seq_int) as alloc_seq_int -- 贷款利息还款顺序
    ,nvl(n.alloc_seq_odi, o.alloc_seq_odi) as alloc_seq_odi -- 贷款复利还款顺序
    ,nvl(n.alloc_seq_odp, o.alloc_seq_odp) as alloc_seq_odp -- 贷款罚息还款顺序
    ,nvl(n.alloc_seq_pri, o.alloc_seq_pri) as alloc_seq_pri -- 贷款本金还款顺序
    ,nvl(n.alloc_seq_type, o.alloc_seq_type) as alloc_seq_type -- 贷款自动还款类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.alloc_code is null
            and n.accounting_status is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.alloc_code is null
            and n.accounting_status is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.alloc_code is null
            and n.accounting_status is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_alloc_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_alloc_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.alloc_code = n.alloc_code
            and o.accounting_status = n.accounting_status
where (
        o.alloc_code is null
        and o.accounting_status is null
    )
    or (
        n.alloc_code is null
        and n.accounting_status is null
    )
    or (
        o.alloc_desc <> n.alloc_desc
        or o.alloc_seq_fee <> n.alloc_seq_fee
        or o.alloc_seq_int <> n.alloc_seq_int
        or o.alloc_seq_odi <> n.alloc_seq_odi
        or o.alloc_seq_odp <> n.alloc_seq_odp
        or o.alloc_seq_pri <> n.alloc_seq_pri
        or o.alloc_seq_type <> n.alloc_seq_type
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
        into ${iol_schema}.ncbs_cl_alloc_define_cl(
            alloc_code -- 扣款顺序编号
            ,alloc_desc -- 扣款顺序描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_alloc_define_op(
            alloc_code -- 扣款顺序编号
            ,alloc_desc -- 扣款顺序描述
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,company -- 法人
            ,libra_op_time -- libra执行次数
            ,accounting_status -- 核算状态
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.alloc_code -- 扣款顺序编号
    ,o.alloc_desc -- 扣款顺序描述
    ,o.alloc_seq_fee -- 贷款费用还款顺序
    ,o.alloc_seq_int -- 贷款利息还款顺序
    ,o.alloc_seq_odi -- 贷款复利还款顺序
    ,o.alloc_seq_odp -- 贷款罚息还款顺序
    ,o.alloc_seq_pri -- 贷款本金还款顺序
    ,o.alloc_seq_type -- 贷款自动还款类型
    ,o.company -- 法人
    ,o.libra_op_time -- libra执行次数
    ,o.accounting_status -- 核算状态
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
from ${iol_schema}.ncbs_cl_alloc_define_bk o
    left join ${iol_schema}.ncbs_cl_alloc_define_op n
        on
            o.alloc_code = n.alloc_code
            and o.accounting_status = n.accounting_status
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_alloc_define_cl d
        on
            o.alloc_code = d.alloc_code
            and o.accounting_status = d.accounting_status
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_alloc_define;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_alloc_define') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_alloc_define drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_alloc_define add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_alloc_define exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_alloc_define_cl;
alter table ${iol_schema}.ncbs_cl_alloc_define exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_alloc_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_alloc_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_alloc_define_op purge;
drop table ${iol_schema}.ncbs_cl_alloc_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_alloc_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_alloc_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
