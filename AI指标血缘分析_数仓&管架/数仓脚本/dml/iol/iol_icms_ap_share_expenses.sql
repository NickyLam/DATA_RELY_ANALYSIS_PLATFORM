/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_share_expenses
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
create table ${iol_schema}.icms_ap_share_expenses_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_share_expenses
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_share_expenses_op purge;
drop table ${iol_schema}.icms_ap_share_expenses_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_share_expenses_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_share_expenses where 0=1;

create table ${iol_schema}.icms_ap_share_expenses_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_share_expenses where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_share_expenses_cl(
            shareno -- 分摊记录编号
            ,expenseslist -- 列支费用项目
            ,programno -- 对应的处置方案编号
            ,expenses -- 列支费用金额
            ,expensesno -- 费用支出记录编号
            ,programname -- 对应的处置方案名称
            ,borrowerexpenses -- 属于当前借款人的列支费用金额
            ,contractno -- 合同流水号
            ,guarantyname -- (拟)抵债资产名称
            ,currency -- 列支费用币种
            ,guarantyid -- (拟)抵债资产编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_share_expenses_op(
            shareno -- 分摊记录编号
            ,expenseslist -- 列支费用项目
            ,programno -- 对应的处置方案编号
            ,expenses -- 列支费用金额
            ,expensesno -- 费用支出记录编号
            ,programname -- 对应的处置方案名称
            ,borrowerexpenses -- 属于当前借款人的列支费用金额
            ,contractno -- 合同流水号
            ,guarantyname -- (拟)抵债资产名称
            ,currency -- 列支费用币种
            ,guarantyid -- (拟)抵债资产编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.shareno, o.shareno) as shareno -- 分摊记录编号
    ,nvl(n.expenseslist, o.expenseslist) as expenseslist -- 列支费用项目
    ,nvl(n.programno, o.programno) as programno -- 对应的处置方案编号
    ,nvl(n.expenses, o.expenses) as expenses -- 列支费用金额
    ,nvl(n.expensesno, o.expensesno) as expensesno -- 费用支出记录编号
    ,nvl(n.programname, o.programname) as programname -- 对应的处置方案名称
    ,nvl(n.borrowerexpenses, o.borrowerexpenses) as borrowerexpenses -- 属于当前借款人的列支费用金额
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.guarantyname, o.guarantyname) as guarantyname -- (拟)抵债资产名称
    ,nvl(n.currency, o.currency) as currency -- 列支费用币种
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- (拟)抵债资产编号
    ,case when
            n.shareno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.shareno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.shareno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_share_expenses_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_share_expenses where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.shareno = n.shareno
where (
        o.shareno is null
    )
    or (
        n.shareno is null
    )
    or (
        o.expenseslist <> n.expenseslist
        or o.programno <> n.programno
        or o.expenses <> n.expenses
        or o.expensesno <> n.expensesno
        or o.programname <> n.programname
        or o.borrowerexpenses <> n.borrowerexpenses
        or o.contractno <> n.contractno
        or o.guarantyname <> n.guarantyname
        or o.currency <> n.currency
        or o.guarantyid <> n.guarantyid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_share_expenses_cl(
            shareno -- 分摊记录编号
            ,expenseslist -- 列支费用项目
            ,programno -- 对应的处置方案编号
            ,expenses -- 列支费用金额
            ,expensesno -- 费用支出记录编号
            ,programname -- 对应的处置方案名称
            ,borrowerexpenses -- 属于当前借款人的列支费用金额
            ,contractno -- 合同流水号
            ,guarantyname -- (拟)抵债资产名称
            ,currency -- 列支费用币种
            ,guarantyid -- (拟)抵债资产编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_share_expenses_op(
            shareno -- 分摊记录编号
            ,expenseslist -- 列支费用项目
            ,programno -- 对应的处置方案编号
            ,expenses -- 列支费用金额
            ,expensesno -- 费用支出记录编号
            ,programname -- 对应的处置方案名称
            ,borrowerexpenses -- 属于当前借款人的列支费用金额
            ,contractno -- 合同流水号
            ,guarantyname -- (拟)抵债资产名称
            ,currency -- 列支费用币种
            ,guarantyid -- (拟)抵债资产编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.shareno -- 分摊记录编号
    ,o.expenseslist -- 列支费用项目
    ,o.programno -- 对应的处置方案编号
    ,o.expenses -- 列支费用金额
    ,o.expensesno -- 费用支出记录编号
    ,o.programname -- 对应的处置方案名称
    ,o.borrowerexpenses -- 属于当前借款人的列支费用金额
    ,o.contractno -- 合同流水号
    ,o.guarantyname -- (拟)抵债资产名称
    ,o.currency -- 列支费用币种
    ,o.guarantyid -- (拟)抵债资产编号
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
from ${iol_schema}.icms_ap_share_expenses_bk o
    left join ${iol_schema}.icms_ap_share_expenses_op n
        on
            o.shareno = n.shareno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_share_expenses_cl d
        on
            o.shareno = d.shareno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_share_expenses;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_share_expenses') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_share_expenses drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_share_expenses add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_share_expenses exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_share_expenses_cl;
alter table ${iol_schema}.icms_ap_share_expenses exchange partition p_20991231 with table ${iol_schema}.icms_ap_share_expenses_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_share_expenses to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_share_expenses_op purge;
drop table ${iol_schema}.icms_ap_share_expenses_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_share_expenses_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_share_expenses',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
