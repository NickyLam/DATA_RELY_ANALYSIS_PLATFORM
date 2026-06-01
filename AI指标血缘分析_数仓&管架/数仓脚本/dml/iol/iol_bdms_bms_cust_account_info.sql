/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_cust_account_info
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
create table ${iol_schema}.bdms_bms_cust_account_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_cust_account_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_cust_account_info_op purge;
drop table ${iol_schema}.bdms_bms_cust_account_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_cust_account_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_cust_account_info where 0=1;

create table ${iol_schema}.bdms_bms_cust_account_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_cust_account_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_cust_account_info_cl(
            id -- ID
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,branch_no -- 所属机构
            ,top_branch_no -- 所属总行机构
            ,account_no -- 帐号编号
            ,acc_bank_name -- 开户行名称
            ,acc_bank_no -- 开户行行号
            ,acc_type -- 帐号类型： 01 结算账号 02 保证金账号
            ,currency -- 账户币种
            ,status -- 状态
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
            ,acct_class -- 账号种类： 01 活期 02 定期
            ,dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
            ,account_name -- 账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_cust_account_info_op(
            id -- ID
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,branch_no -- 所属机构
            ,top_branch_no -- 所属总行机构
            ,account_no -- 帐号编号
            ,acc_bank_name -- 开户行名称
            ,acc_bank_no -- 开户行行号
            ,acc_type -- 帐号类型： 01 结算账号 02 保证金账号
            ,currency -- 账户币种
            ,status -- 状态
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
            ,acct_class -- 账号种类： 01 活期 02 定期
            ,dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
            ,account_name -- 账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 所属机构
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 所属总行机构
    ,nvl(n.account_no, o.account_no) as account_no -- 帐号编号
    ,nvl(n.acc_bank_name, o.acc_bank_name) as acc_bank_name -- 开户行名称
    ,nvl(n.acc_bank_no, o.acc_bank_no) as acc_bank_no -- 开户行行号
    ,nvl(n.acc_type, o.acc_type) as acc_type -- 帐号类型： 01 结算账号 02 保证金账号
    ,nvl(n.currency, o.currency) as currency -- 账户币种
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.dualcontrol_lockstatus, o.dualcontrol_lockstatus) as dualcontrol_lockstatus -- 双岗复核锁标记
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.acct_busi_type, o.acct_busi_type) as acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
    ,nvl(n.acct_class, o.acct_class) as acct_class -- 账号种类： 01 活期 02 定期
    ,nvl(n.dist_type, o.dist_type) as dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
    ,nvl(n.account_name, o.account_name) as account_name -- 账号名称
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_cust_account_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_cust_account_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.branch_no <> n.branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.account_no <> n.account_no
        or o.acc_bank_name <> n.acc_bank_name
        or o.acc_bank_no <> n.acc_bank_no
        or o.acc_type <> n.acc_type
        or o.currency <> n.currency
        or o.status <> n.status
        or o.dualcontrol_lockstatus <> n.dualcontrol_lockstatus
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.acct_busi_type <> n.acct_busi_type
        or o.acct_class <> n.acct_class
        or o.dist_type <> n.dist_type
        or o.account_name <> n.account_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_cust_account_info_cl(
            id -- ID
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,branch_no -- 所属机构
            ,top_branch_no -- 所属总行机构
            ,account_no -- 帐号编号
            ,acc_bank_name -- 开户行名称
            ,acc_bank_no -- 开户行行号
            ,acc_type -- 帐号类型： 01 结算账号 02 保证金账号
            ,currency -- 账户币种
            ,status -- 状态
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
            ,acct_class -- 账号种类： 01 活期 02 定期
            ,dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
            ,account_name -- 账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_cust_account_info_op(
            id -- ID
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,branch_no -- 所属机构
            ,top_branch_no -- 所属总行机构
            ,account_no -- 帐号编号
            ,acc_bank_name -- 开户行名称
            ,acc_bank_no -- 开户行行号
            ,acc_type -- 帐号类型： 01 结算账号 02 保证金账号
            ,currency -- 账户币种
            ,status -- 状态
            ,dualcontrol_lockstatus -- 双岗复核锁标记
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
            ,acct_class -- 账号种类： 01 活期 02 定期
            ,dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
            ,account_name -- 账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.cust_no -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.branch_no -- 所属机构
    ,o.top_branch_no -- 所属总行机构
    ,o.account_no -- 帐号编号
    ,o.acc_bank_name -- 开户行名称
    ,o.acc_bank_no -- 开户行行号
    ,o.acc_type -- 帐号类型： 01 结算账号 02 保证金账号
    ,o.currency -- 账户币种
    ,o.status -- 状态
    ,o.dualcontrol_lockstatus -- 双岗复核锁标记
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.acct_busi_type -- 账户类型： 1 同业账户 2 对公账户 3 托收账户 4 票据池账户
    ,o.acct_class -- 账号种类： 01 活期 02 定期
    ,o.dist_type -- 识别类型： DT01-票据账户, DT02-银行账户
    ,o.account_name -- 账号名称
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
from ${iol_schema}.bdms_bms_cust_account_info_bk o
    left join ${iol_schema}.bdms_bms_cust_account_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_cust_account_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_cust_account_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_cust_account_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_cust_account_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_cust_account_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_cust_account_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_cust_account_info_cl;
alter table ${iol_schema}.bdms_bms_cust_account_info exchange partition p_20991231 with table ${iol_schema}.bdms_bms_cust_account_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_cust_account_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_cust_account_info_op purge;
drop table ${iol_schema}.bdms_bms_cust_account_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_cust_account_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_cust_account_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
