/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_prod_acct_bal
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
create table ${iol_schema}.ncbs_cl_prod_acct_bal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_prod_acct_bal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal_op purge;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_prod_acct_bal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_prod_acct_bal where 0=1;

create table ${iol_schema}.ncbs_cl_prod_acct_bal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_prod_acct_bal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_prod_acct_bal_cl(
            amt_type -- 金额类型
            ,balance -- 余额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,company -- 法人
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_prod_acct_bal_op(
            amt_type -- 金额类型
            ,balance -- 余额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,company -- 法人
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.gl_code, o.gl_code) as gl_code -- 科目代码
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.tran_category, o.tran_category) as tran_category -- 交易种类
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
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
from (select * from ${iol_schema}.ncbs_cl_prod_acct_bal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_prod_acct_bal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq_no = n.seq_no
where (
        o.seq_no is null
    )
    or (
        n.seq_no is null
    )
    or (
        o.amt_type <> n.amt_type
        or o.balance <> n.balance
        or o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.gl_code <> n.gl_code
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.company <> n.company
        or o.system_id <> n.system_id
        or o.tran_category <> n.tran_category
        or o.accounting_status <> n.accounting_status
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_prod_acct_bal_cl(
            amt_type -- 金额类型
            ,balance -- 余额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,company -- 法人
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_prod_acct_bal_op(
            amt_type -- 金额类型
            ,balance -- 余额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,gl_code -- 科目代码
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,company -- 法人
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,tran_category -- 交易种类
            ,accounting_status -- 核算状态
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amt_type -- 金额类型
    ,o.balance -- 余额
    ,o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.gl_code -- 科目代码
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.company -- 法人
    ,o.seq_no -- 序号
    ,o.system_id -- 系统id
    ,o.tran_category -- 交易种类
    ,o.accounting_status -- 核算状态
    ,o.last_change_date -- 最后修改日期
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
from ${iol_schema}.ncbs_cl_prod_acct_bal_bk o
    left join ${iol_schema}.ncbs_cl_prod_acct_bal_op n
        on
            o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_prod_acct_bal_cl d
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
--truncate table ${iol_schema}.ncbs_cl_prod_acct_bal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_prod_acct_bal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_prod_acct_bal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_prod_acct_bal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_prod_acct_bal exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_prod_acct_bal_cl;
alter table ${iol_schema}.ncbs_cl_prod_acct_bal exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_prod_acct_bal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_prod_acct_bal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal_op purge;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_prod_acct_bal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_prod_acct_bal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
