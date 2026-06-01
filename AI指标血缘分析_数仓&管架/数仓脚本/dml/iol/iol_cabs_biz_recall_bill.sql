/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cabs_biz_recall_bill
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
create table ${iol_schema}.cabs_biz_recall_bill_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.cabs_biz_recall_bill
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cabs_biz_recall_bill_op purge;
drop table ${iol_schema}.cabs_biz_recall_bill_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cabs_biz_recall_bill_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cabs_biz_recall_bill where 0=1;

create table ${iol_schema}.cabs_biz_recall_bill_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cabs_biz_recall_bill where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cabs_biz_recall_bill_cl(
            id -- ID编号
            ,account -- 账户
            ,brchno -- 分行机构号
            ,curr_flag -- 活期标识 0活期 1非活期
            ,clerk_mobile -- 企业对账员手机号码
            ,message -- 发送信息
            ,no_sign -- 没有签约
            ,org_code -- 开户机构
            ,oper_clerk -- 操作柜员
            ,oper_date -- 操作日期
            ,oper_rlt -- 发送结果
            ,bill_no -- 账单编号
            ,cust_name -- 客户姓名
            ,cust_address -- 客户地址
            ,acc_nanme -- 账户名称
            ,currency -- 币种
            ,balance -- 余额
            ,brs_fqcy -- 对账频率
            ,term_no -- 账期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cabs_biz_recall_bill_op(
            id -- ID编号
            ,account -- 账户
            ,brchno -- 分行机构号
            ,curr_flag -- 活期标识 0活期 1非活期
            ,clerk_mobile -- 企业对账员手机号码
            ,message -- 发送信息
            ,no_sign -- 没有签约
            ,org_code -- 开户机构
            ,oper_clerk -- 操作柜员
            ,oper_date -- 操作日期
            ,oper_rlt -- 发送结果
            ,bill_no -- 账单编号
            ,cust_name -- 客户姓名
            ,cust_address -- 客户地址
            ,acc_nanme -- 账户名称
            ,currency -- 币种
            ,balance -- 余额
            ,brs_fqcy -- 对账频率
            ,term_no -- 账期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID编号
    ,nvl(n.account, o.account) as account -- 账户
    ,nvl(n.brchno, o.brchno) as brchno -- 分行机构号
    ,nvl(n.curr_flag, o.curr_flag) as curr_flag -- 活期标识 0活期 1非活期
    ,substr(nvl(trim(n.clerk_mobile), o.clerk_mobile),1,19) as clerk_mobile -- 企业对账员手机号码
    ,nvl(n.message, o.message) as message -- 发送信息
    ,nvl(n.no_sign, o.no_sign) as no_sign -- 没有签约
    ,nvl(n.org_code, o.org_code) as org_code -- 开户机构
    ,nvl(n.oper_clerk, o.oper_clerk) as oper_clerk -- 操作柜员
    ,nvl(n.oper_date, o.oper_date) as oper_date -- 操作日期
    ,nvl(n.oper_rlt, o.oper_rlt) as oper_rlt -- 发送结果
    ,nvl(n.bill_no, o.bill_no) as bill_no -- 账单编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户姓名
    ,nvl(n.cust_address, o.cust_address) as cust_address -- 客户地址
    ,nvl(n.acc_nanme, o.acc_nanme) as acc_nanme -- 账户名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.brs_fqcy, o.brs_fqcy) as brs_fqcy -- 对账频率
    ,nvl(n.term_no, o.term_no) as term_no -- 账期
    ,case when
            n.bill_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bill_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bill_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.cabs_biz_recall_bill_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.cabs_biz_recall_bill where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bill_no = n.bill_no
where (
        o.bill_no is null
    )
    or (
        n.bill_no is null
    )
    or (
        o.id <> n.id
        or o.account <> n.account
        or o.brchno <> n.brchno
        or o.curr_flag <> n.curr_flag
        or o.clerk_mobile <> n.clerk_mobile
        or o.message <> n.message
        or o.no_sign <> n.no_sign
        or o.org_code <> n.org_code
        or o.oper_clerk <> n.oper_clerk
        or o.oper_date <> n.oper_date
        or o.oper_rlt <> n.oper_rlt
        or o.cust_name <> n.cust_name
        or o.cust_address <> n.cust_address
        or o.acc_nanme <> n.acc_nanme
        or o.currency <> n.currency
        or o.balance <> n.balance
        or o.brs_fqcy <> n.brs_fqcy
        or o.term_no <> n.term_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.cabs_biz_recall_bill_cl(
            id -- ID编号
            ,account -- 账户
            ,brchno -- 分行机构号
            ,curr_flag -- 活期标识 0活期 1非活期
            ,clerk_mobile -- 企业对账员手机号码
            ,message -- 发送信息
            ,no_sign -- 没有签约
            ,org_code -- 开户机构
            ,oper_clerk -- 操作柜员
            ,oper_date -- 操作日期
            ,oper_rlt -- 发送结果
            ,bill_no -- 账单编号
            ,cust_name -- 客户姓名
            ,cust_address -- 客户地址
            ,acc_nanme -- 账户名称
            ,currency -- 币种
            ,balance -- 余额
            ,brs_fqcy -- 对账频率
            ,term_no -- 账期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.cabs_biz_recall_bill_op(
            id -- ID编号
            ,account -- 账户
            ,brchno -- 分行机构号
            ,curr_flag -- 活期标识 0活期 1非活期
            ,clerk_mobile -- 企业对账员手机号码
            ,message -- 发送信息
            ,no_sign -- 没有签约
            ,org_code -- 开户机构
            ,oper_clerk -- 操作柜员
            ,oper_date -- 操作日期
            ,oper_rlt -- 发送结果
            ,bill_no -- 账单编号
            ,cust_name -- 客户姓名
            ,cust_address -- 客户地址
            ,acc_nanme -- 账户名称
            ,currency -- 币种
            ,balance -- 余额
            ,brs_fqcy -- 对账频率
            ,term_no -- 账期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID编号
    ,o.account -- 账户
    ,o.brchno -- 分行机构号
    ,o.curr_flag -- 活期标识 0活期 1非活期
    ,o.clerk_mobile -- 企业对账员手机号码
    ,o.message -- 发送信息
    ,o.no_sign -- 没有签约
    ,o.org_code -- 开户机构
    ,o.oper_clerk -- 操作柜员
    ,o.oper_date -- 操作日期
    ,o.oper_rlt -- 发送结果
    ,o.bill_no -- 账单编号
    ,o.cust_name -- 客户姓名
    ,o.cust_address -- 客户地址
    ,o.acc_nanme -- 账户名称
    ,o.currency -- 币种
    ,o.balance -- 余额
    ,o.brs_fqcy -- 对账频率
    ,o.term_no -- 账期
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
from ${iol_schema}.cabs_biz_recall_bill_bk o
    left join ${iol_schema}.cabs_biz_recall_bill_op n
        on
            o.bill_no = n.bill_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.cabs_biz_recall_bill_cl d
        on
            o.bill_no = d.bill_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.cabs_biz_recall_bill;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('cabs_biz_recall_bill') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.cabs_biz_recall_bill drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.cabs_biz_recall_bill add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.cabs_biz_recall_bill exchange partition p_${batch_date} with table ${iol_schema}.cabs_biz_recall_bill_cl;
alter table ${iol_schema}.cabs_biz_recall_bill exchange partition p_20991231 with table ${iol_schema}.cabs_biz_recall_bill_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cabs_biz_recall_bill to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cabs_biz_recall_bill_op purge;
drop table ${iol_schema}.cabs_biz_recall_bill_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.cabs_biz_recall_bill_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cabs_biz_recall_bill',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
