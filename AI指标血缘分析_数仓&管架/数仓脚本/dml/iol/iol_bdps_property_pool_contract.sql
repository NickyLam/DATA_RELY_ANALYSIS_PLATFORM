/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_property_pool_contract
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
create table ${iol_schema}.bdps_property_pool_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_property_pool_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_pool_contract_op purge;
drop table ${iol_schema}.bdps_property_pool_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_pool_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_pool_contract where 0=1;

create table ${iol_schema}.bdps_property_pool_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_pool_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_pool_contract_cl(
            id -- 
            ,protocol_no -- 资产池协议编号
            ,contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
            ,property_type -- 1-理财产品
            ,branch_id -- 机构ID
            ,operator_id -- 操作员号
            ,app_cust_id -- 申请客户号
            ,txn_date -- 申请日期
            ,contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
            ,audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
            ,logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
            ,manager_id -- 客户经理号
            ,depart_id -- 部门号
            ,appno -- 申请编号
            ,misc -- 信息域
            ,ebank_apply -- 网银申请标志 0-否 1-是
            ,ebank_oper_name -- 网银操作员名称
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,bail_account -- 保证金账号
            ,applock -- 00-未加锁 01--加锁
            ,auto_flag -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_pool_contract_op(
            id -- 
            ,protocol_no -- 资产池协议编号
            ,contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
            ,property_type -- 1-理财产品
            ,branch_id -- 机构ID
            ,operator_id -- 操作员号
            ,app_cust_id -- 申请客户号
            ,txn_date -- 申请日期
            ,contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
            ,audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
            ,logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
            ,manager_id -- 客户经理号
            ,depart_id -- 部门号
            ,appno -- 申请编号
            ,misc -- 信息域
            ,ebank_apply -- 网银申请标志 0-否 1-是
            ,ebank_oper_name -- 网银操作员名称
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,bail_account -- 保证金账号
            ,applock -- 00-未加锁 01--加锁
            ,auto_flag -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 资产池协议编号
    ,nvl(n.contract_type, o.contract_type) as contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
    ,nvl(n.property_type, o.property_type) as property_type -- 1-理财产品
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构ID
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 操作员号
    ,nvl(n.app_cust_id, o.app_cust_id) as app_cust_id -- 申请客户号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 申请日期
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
    ,nvl(n.logic_check_status, o.logic_check_status) as logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 客户经理号
    ,nvl(n.depart_id, o.depart_id) as depart_id -- 部门号
    ,nvl(n.appno, o.appno) as appno -- 申请编号
    ,nvl(n.misc, o.misc) as misc -- 信息域
    ,nvl(n.ebank_apply, o.ebank_apply) as ebank_apply -- 网银申请标志 0-否 1-是
    ,nvl(n.ebank_oper_name, o.ebank_oper_name) as ebank_oper_name -- 网银操作员名称
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 最后修改操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.bail_account, o.bail_account) as bail_account -- 保证金账号
    ,nvl(n.applock, o.applock) as applock -- 00-未加锁 01--加锁
    ,nvl(n.auto_flag, o.auto_flag) as auto_flag -- 
    ,nvl(n.bsnssq, o.bsnssq) as bsnssq -- 全局流水号
    ,nvl(n.transq, o.transq) as transq -- 业务流水号
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
from (select * from ${iol_schema}.bdps_property_pool_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_property_pool_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.protocol_no <> n.protocol_no
        or o.contract_type <> n.contract_type
        or o.property_type <> n.property_type
        or o.branch_id <> n.branch_id
        or o.operator_id <> n.operator_id
        or o.app_cust_id <> n.app_cust_id
        or o.txn_date <> n.txn_date
        or o.contract_status <> n.contract_status
        or o.audit_status <> n.audit_status
        or o.logic_check_status <> n.logic_check_status
        or o.manager_id <> n.manager_id
        or o.depart_id <> n.depart_id
        or o.appno <> n.appno
        or o.misc <> n.misc
        or o.ebank_apply <> n.ebank_apply
        or o.ebank_oper_name <> n.ebank_oper_name
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.bail_account <> n.bail_account
        or o.applock <> n.applock
        or o.auto_flag <> n.auto_flag
        or o.bsnssq <> n.bsnssq
        or o.transq <> n.transq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_pool_contract_cl(
            id -- 
            ,protocol_no -- 资产池协议编号
            ,contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
            ,property_type -- 1-理财产品
            ,branch_id -- 机构ID
            ,operator_id -- 操作员号
            ,app_cust_id -- 申请客户号
            ,txn_date -- 申请日期
            ,contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
            ,audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
            ,logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
            ,manager_id -- 客户经理号
            ,depart_id -- 部门号
            ,appno -- 申请编号
            ,misc -- 信息域
            ,ebank_apply -- 网银申请标志 0-否 1-是
            ,ebank_oper_name -- 网银操作员名称
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,bail_account -- 保证金账号
            ,applock -- 00-未加锁 01--加锁
            ,auto_flag -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_pool_contract_op(
            id -- 
            ,protocol_no -- 资产池协议编号
            ,contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
            ,property_type -- 1-理财产品
            ,branch_id -- 机构ID
            ,operator_id -- 操作员号
            ,app_cust_id -- 申请客户号
            ,txn_date -- 申请日期
            ,contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
            ,audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
            ,logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
            ,manager_id -- 客户经理号
            ,depart_id -- 部门号
            ,appno -- 申请编号
            ,misc -- 信息域
            ,ebank_apply -- 网银申请标志 0-否 1-是
            ,ebank_oper_name -- 网银操作员名称
            ,last_upd_oper_id -- 最后修改操作员
            ,last_upd_time -- 最后修改时间
            ,bail_account -- 保证金账号
            ,applock -- 00-未加锁 01--加锁
            ,auto_flag -- 
            ,bsnssq -- 全局流水号
            ,transq -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.protocol_no -- 资产池协议编号
    ,o.contract_type -- 协议类型 1 -- 申请协议 2 -- 解除协议
    ,o.property_type -- 1-理财产品
    ,o.branch_id -- 机构ID
    ,o.operator_id -- 操作员号
    ,o.app_cust_id -- 申请客户号
    ,o.txn_date -- 申请日期
    ,o.contract_status -- 协议状态  0-已录入 1-审批中 2-审核成功 3-审核失败
    ,o.audit_status -- 审核状态 0-未审核（默认） 2-审核中 3-审核成功 4-审核失败 5-审核退回
    ,o.logic_check_status -- 业务逻辑查询状态 1-未业务逻辑查询（默认） 2-业务逻辑查询成功 3-业务逻辑查询失败
    ,o.manager_id -- 客户经理号
    ,o.depart_id -- 部门号
    ,o.appno -- 申请编号
    ,o.misc -- 信息域
    ,o.ebank_apply -- 网银申请标志 0-否 1-是
    ,o.ebank_oper_name -- 网银操作员名称
    ,o.last_upd_oper_id -- 最后修改操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.bail_account -- 保证金账号
    ,o.applock -- 00-未加锁 01--加锁
    ,o.auto_flag -- 
    ,o.bsnssq -- 全局流水号
    ,o.transq -- 业务流水号
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
from ${iol_schema}.bdps_property_pool_contract_bk o
    left join ${iol_schema}.bdps_property_pool_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_property_pool_contract_cl d
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
--truncate table ${iol_schema}.bdps_property_pool_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdps_property_pool_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdps_property_pool_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdps_property_pool_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdps_property_pool_contract exchange partition p_${batch_date} with table ${iol_schema}.bdps_property_pool_contract_cl;
alter table ${iol_schema}.bdps_property_pool_contract exchange partition p_20991231 with table ${iol_schema}.bdps_property_pool_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_property_pool_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_pool_contract_op purge;
drop table ${iol_schema}.bdps_property_pool_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_property_pool_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_property_pool_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
