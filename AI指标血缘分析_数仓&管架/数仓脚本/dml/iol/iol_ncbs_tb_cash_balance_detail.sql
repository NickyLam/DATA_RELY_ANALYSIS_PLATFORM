/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_cash_balance_detail
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
create table ${iol_schema}.ncbs_tb_cash_balance_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_cash_balance_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail_op purge;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_balance_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_balance_detail where 0=1;

create table ${iol_schema}.ncbs_tb_cash_balance_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_balance_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_balance_detail_cl(
            amount -- 金额
            ,ccy -- 币种
            ,cash_num -- 现金数量
            ,company -- 法人
            ,par_value_id -- 券别代码
            ,tailbox_id -- 尾箱代号
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_balance_detail_op(
            amount -- 金额
            ,ccy -- 币种
            ,cash_num -- 现金数量
            ,company -- 法人
            ,par_value_id -- 券别代码
            ,tailbox_id -- 尾箱代号
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.cash_num, o.cash_num) as cash_num -- 现金数量
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.par_value_id, o.par_value_id) as par_value_id -- 券别代码
    ,nvl(n.tailbox_id, o.tailbox_id) as tailbox_id -- 尾箱代号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,case when
            n.ccy is null
            and n.par_value_id is null
            and n.tailbox_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ccy is null
            and n.par_value_id is null
            and n.tailbox_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ccy is null
            and n.par_value_id is null
            and n.tailbox_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_cash_balance_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_cash_balance_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ccy = n.ccy
            and o.par_value_id = n.par_value_id
            and o.tailbox_id = n.tailbox_id
where (
        o.ccy is null
        and o.par_value_id is null
        and o.tailbox_id is null
    )
    or (
        n.ccy is null
        and n.par_value_id is null
        and n.tailbox_id is null
    )
    or (
        o.amount <> n.amount
        or o.cash_num <> n.cash_num
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.update_date <> n.update_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_balance_detail_cl(
            amount -- 金额
            ,ccy -- 币种
            ,cash_num -- 现金数量
            ,company -- 法人
            ,par_value_id -- 券别代码
            ,tailbox_id -- 尾箱代号
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_balance_detail_op(
            amount -- 金额
            ,ccy -- 币种
            ,cash_num -- 现金数量
            ,company -- 法人
            ,par_value_id -- 券别代码
            ,tailbox_id -- 尾箱代号
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amount -- 金额
    ,o.ccy -- 币种
    ,o.cash_num -- 现金数量
    ,o.company -- 法人
    ,o.par_value_id -- 券别代码
    ,o.tailbox_id -- 尾箱代号
    ,o.tran_timestamp -- 交易时间戳
    ,o.update_date -- 更新日期
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
from ${iol_schema}.ncbs_tb_cash_balance_detail_bk o
    left join ${iol_schema}.ncbs_tb_cash_balance_detail_op n
        on
            o.ccy = n.ccy
            and o.par_value_id = n.par_value_id
            and o.tailbox_id = n.tailbox_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_cash_balance_detail_cl d
        on
            o.ccy = d.ccy
            and o.par_value_id = d.par_value_id
            and o.tailbox_id = d.tailbox_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_cash_balance_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_cash_balance_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_cash_balance_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_cash_balance_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_cash_balance_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_cash_balance_detail_cl;
alter table ${iol_schema}.ncbs_tb_cash_balance_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_cash_balance_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_cash_balance_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail_op purge;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_cash_balance_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
