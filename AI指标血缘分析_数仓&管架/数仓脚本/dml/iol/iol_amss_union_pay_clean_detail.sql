/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_union_pay_clean_detail
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
create table ${iol_schema}.amss_union_pay_clean_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_union_pay_clean_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_clean_detail_op purge;
drop table ${iol_schema}.amss_union_pay_clean_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_clean_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_clean_detail where 0=1;

create table ${iol_schema}.amss_union_pay_clean_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_clean_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_clean_detail_cl(
            id -- 主键ID
            ,batch_no -- 批次号
            ,fund_id -- 
            ,clean_date -- 划账日期
            ,clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
            ,payer_acct -- 付款账户
            ,payer_acct_name -- 付款账户名
            ,payer_acct_type -- 付款账户类型
            ,payer_bank_no -- 付款账户开户行号
            ,payer_bank_name -- 付款账户开户行名称
            ,payee_acct -- 收款账户
            ,payee_acct_name -- 收款账户名
            ,payee_acct_type -- 收款账户类型
            ,clean_amt -- 应划账金额
            ,actual_amt -- 实际划账金额
            ,resp_msg -- 失败原因
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_emp -- 更新者
            ,channel_id -- 所属机构ID
            ,org_id -- 柜台机构ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_clean_detail_op(
            id -- 主键ID
            ,batch_no -- 批次号
            ,fund_id -- 
            ,clean_date -- 划账日期
            ,clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
            ,payer_acct -- 付款账户
            ,payer_acct_name -- 付款账户名
            ,payer_acct_type -- 付款账户类型
            ,payer_bank_no -- 付款账户开户行号
            ,payer_bank_name -- 付款账户开户行名称
            ,payee_acct -- 收款账户
            ,payee_acct_name -- 收款账户名
            ,payee_acct_type -- 收款账户类型
            ,clean_amt -- 应划账金额
            ,actual_amt -- 实际划账金额
            ,resp_msg -- 失败原因
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_emp -- 更新者
            ,channel_id -- 所属机构ID
            ,org_id -- 柜台机构ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.fund_id, o.fund_id) as fund_id -- 
    ,nvl(n.clean_date, o.clean_date) as clean_date -- 划账日期
    ,nvl(n.clean_result, o.clean_result) as clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
    ,nvl(n.payer_acct, o.payer_acct) as payer_acct -- 付款账户
    ,nvl(n.payer_acct_name, o.payer_acct_name) as payer_acct_name -- 付款账户名
    ,nvl(n.payer_acct_type, o.payer_acct_type) as payer_acct_type -- 付款账户类型
    ,nvl(n.payer_bank_no, o.payer_bank_no) as payer_bank_no -- 付款账户开户行号
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 付款账户开户行名称
    ,nvl(n.payee_acct, o.payee_acct) as payee_acct -- 收款账户
    ,nvl(n.payee_acct_name, o.payee_acct_name) as payee_acct_name -- 收款账户名
    ,nvl(n.payee_acct_type, o.payee_acct_type) as payee_acct_type -- 收款账户类型
    ,nvl(n.clean_amt, o.clean_amt) as clean_amt -- 应划账金额
    ,nvl(n.actual_amt, o.actual_amt) as actual_amt -- 实际划账金额
    ,nvl(n.resp_msg, o.resp_msg) as resp_msg -- 失败原因
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识，默认1正常，2删除
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新者
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属机构ID
    ,nvl(n.org_id, o.org_id) as org_id -- 柜台机构ID
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
from (select * from ${iol_schema}.amss_union_pay_clean_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_union_pay_clean_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.batch_no <> n.batch_no
        or o.fund_id <> n.fund_id
        or o.clean_date <> n.clean_date
        or o.clean_result <> n.clean_result
        or o.payer_acct <> n.payer_acct
        or o.payer_acct_name <> n.payer_acct_name
        or o.payer_acct_type <> n.payer_acct_type
        or o.payer_bank_no <> n.payer_bank_no
        or o.payer_bank_name <> n.payer_bank_name
        or o.payee_acct <> n.payee_acct
        or o.payee_acct_name <> n.payee_acct_name
        or o.payee_acct_type <> n.payee_acct_type
        or o.clean_amt <> n.clean_amt
        or o.actual_amt <> n.actual_amt
        or o.resp_msg <> n.resp_msg
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.create_emp <> n.create_emp
        or o.update_time <> n.update_time
        or o.update_emp <> n.update_emp
        or o.channel_id <> n.channel_id
        or o.org_id <> n.org_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_clean_detail_cl(
            id -- 主键ID
            ,batch_no -- 批次号
            ,fund_id -- 
            ,clean_date -- 划账日期
            ,clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
            ,payer_acct -- 付款账户
            ,payer_acct_name -- 付款账户名
            ,payer_acct_type -- 付款账户类型
            ,payer_bank_no -- 付款账户开户行号
            ,payer_bank_name -- 付款账户开户行名称
            ,payee_acct -- 收款账户
            ,payee_acct_name -- 收款账户名
            ,payee_acct_type -- 收款账户类型
            ,clean_amt -- 应划账金额
            ,actual_amt -- 实际划账金额
            ,resp_msg -- 失败原因
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_emp -- 更新者
            ,channel_id -- 所属机构ID
            ,org_id -- 柜台机构ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_clean_detail_op(
            id -- 主键ID
            ,batch_no -- 批次号
            ,fund_id -- 
            ,clean_date -- 划账日期
            ,clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
            ,payer_acct -- 付款账户
            ,payer_acct_name -- 付款账户名
            ,payer_acct_type -- 付款账户类型
            ,payer_bank_no -- 付款账户开户行号
            ,payer_bank_name -- 付款账户开户行名称
            ,payee_acct -- 收款账户
            ,payee_acct_name -- 收款账户名
            ,payee_acct_type -- 收款账户类型
            ,clean_amt -- 应划账金额
            ,actual_amt -- 实际划账金额
            ,resp_msg -- 失败原因
            ,physics_flag -- 物理标识，默认1正常，2删除
            ,create_time -- 创建时间
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_emp -- 更新者
            ,channel_id -- 所属机构ID
            ,org_id -- 柜台机构ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.batch_no -- 批次号
    ,o.fund_id -- 
    ,o.clean_date -- 划账日期
    ,o.clean_result -- 划账结果 0-未划账 1-划账成功 2-划账失败
    ,o.payer_acct -- 付款账户
    ,o.payer_acct_name -- 付款账户名
    ,o.payer_acct_type -- 付款账户类型
    ,o.payer_bank_no -- 付款账户开户行号
    ,o.payer_bank_name -- 付款账户开户行名称
    ,o.payee_acct -- 收款账户
    ,o.payee_acct_name -- 收款账户名
    ,o.payee_acct_type -- 收款账户类型
    ,o.clean_amt -- 应划账金额
    ,o.actual_amt -- 实际划账金额
    ,o.resp_msg -- 失败原因
    ,o.physics_flag -- 物理标识，默认1正常，2删除
    ,o.create_time -- 创建时间
    ,o.create_emp -- 创建者
    ,o.update_time -- 更新时间
    ,o.update_emp -- 更新者
    ,o.channel_id -- 所属机构ID
    ,o.org_id -- 柜台机构ID
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
from ${iol_schema}.amss_union_pay_clean_detail_bk o
    left join ${iol_schema}.amss_union_pay_clean_detail_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_union_pay_clean_detail_cl d
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
--truncate table ${iol_schema}.amss_union_pay_clean_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_union_pay_clean_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_union_pay_clean_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_union_pay_clean_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_union_pay_clean_detail exchange partition p_${batch_date} with table ${iol_schema}.amss_union_pay_clean_detail_cl;
alter table ${iol_schema}.amss_union_pay_clean_detail exchange partition p_20991231 with table ${iol_schema}.amss_union_pay_clean_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_union_pay_clean_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_clean_detail_op purge;
drop table ${iol_schema}.amss_union_pay_clean_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_union_pay_clean_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_union_pay_clean_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
