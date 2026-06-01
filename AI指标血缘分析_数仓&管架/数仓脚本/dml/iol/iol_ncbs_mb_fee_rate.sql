/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_fee_rate
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
create table ${iol_schema}.ncbs_mb_fee_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_fee_rate
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_rate_op purge;
drop table ${iol_schema}.ncbs_mb_fee_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_rate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_rate where 0=1;

create table ${iol_schema}.ncbs_mb_fee_rate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_fee_rate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_rate_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,company -- 法人
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,high_limit -- 收费金额上限
            ,low_limit -- 收费金额下限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_rate_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,company -- 法人
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,high_limit -- 收费金额上限
            ,low_limit -- 收费金额下限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型
    ,nvl(n.irl_seq_no, o.irl_seq_no) as irl_seq_no -- 费率编号
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.high_limit, o.high_limit) as high_limit -- 收费金额上限
    ,nvl(n.low_limit, o.low_limit) as low_limit -- 收费金额下限
    ,case when
            n.irl_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.irl_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.irl_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_fee_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_fee_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.irl_seq_no = n.irl_seq_no
where (
        o.irl_seq_no is null
    )
    or (
        n.irl_seq_no is null
    )
    or (
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.company <> n.company
        or o.fee_type <> n.fee_type
        or o.effect_date <> n.effect_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.high_limit <> n.high_limit
        or o.low_limit <> n.low_limit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_fee_rate_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,company -- 法人
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,high_limit -- 收费金额上限
            ,low_limit -- 收费金额下限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_fee_rate_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,company -- 法人
            ,fee_type -- 费率类型
            ,irl_seq_no -- 费率编号
            ,effect_date -- 产品生效日期
            ,tran_timestamp -- 交易时间戳
            ,high_limit -- 收费金额上限
            ,low_limit -- 收费金额下限
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.company -- 法人
    ,o.fee_type -- 费率类型
    ,o.irl_seq_no -- 费率编号
    ,o.effect_date -- 产品生效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.high_limit -- 收费金额上限
    ,o.low_limit -- 收费金额下限
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
from ${iol_schema}.ncbs_mb_fee_rate_bk o
    left join ${iol_schema}.ncbs_mb_fee_rate_op n
        on
            o.irl_seq_no = n.irl_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_fee_rate_cl d
        on
            o.irl_seq_no = d.irl_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_fee_rate;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_fee_rate') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_fee_rate drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_fee_rate add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_fee_rate exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_fee_rate_cl;
alter table ${iol_schema}.ncbs_mb_fee_rate exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_fee_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_fee_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_fee_rate_op purge;
drop table ${iol_schema}.ncbs_mb_fee_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_fee_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_fee_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
