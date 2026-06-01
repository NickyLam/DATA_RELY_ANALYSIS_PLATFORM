/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_offline_recovery_contract
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
create table ${iol_schema}.bdms_cpes_offline_recovery_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_offline_recovery_contract;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract_op purge;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_offline_recovery_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_offline_recovery_contract where 0=1;

create table ${iol_schema}.bdms_cpes_offline_recovery_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_offline_recovery_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_offline_recovery_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,busi_date -- 业务发生日期
            ,pay_date -- 偿付日期
            ,trader_name -- 交易对手名称
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_account -- 交易对手账号
            ,trader_bank_no -- 交易对手行行号
            ,trader_brh_no -- 交易对手机构代码
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 财务机构号
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_offline_recovery_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,busi_date -- 业务发生日期
            ,pay_date -- 偿付日期
            ,trader_name -- 交易对手名称
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_account -- 交易对手账号
            ,trader_bank_no -- 交易对手行行号
            ,trader_brh_no -- 交易对手机构代码
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 财务机构号
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构号
    ,nvl(n.recept_brh_id, o.recept_brh_id) as recept_brh_id -- 承接行机构代码
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务发生日期
    ,nvl(n.pay_date, o.pay_date) as pay_date -- 偿付日期
    ,nvl(n.trader_name, o.trader_name) as trader_name -- 交易对手名称
    ,nvl(n.trader_credit_no, o.trader_credit_no) as trader_credit_no -- 交易对手社会信用代码
    ,nvl(n.trader_account, o.trader_account) as trader_account -- 交易对手账号
    ,nvl(n.trader_bank_no, o.trader_bank_no) as trader_bank_no -- 交易对手行行号
    ,nvl(n.trader_brh_no, o.trader_brh_no) as trader_brh_no -- 交易对手机构代码
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 财务机构号
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.department_no, o.department_no) as department_no -- 部门编号
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
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
from (select * from ${iol_schema}.bdms_cpes_offline_recovery_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_offline_recovery_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_no <> n.contract_no
        or o.product_no <> n.product_no
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.top_branch_no <> n.top_branch_no
        or o.branch_no <> n.branch_no
        or o.recept_brh_id <> n.recept_brh_id
        or o.busi_date <> n.busi_date
        or o.pay_date <> n.pay_date
        or o.trader_name <> n.trader_name
        or o.trader_credit_no <> n.trader_credit_no
        or o.trader_account <> n.trader_account
        or o.trader_bank_no <> n.trader_bank_no
        or o.trader_brh_no <> n.trader_brh_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.manager_no <> n.manager_no
        or o.department_no <> n.department_no
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.cust_type <> n.cust_type
        or o.created_by <> n.created_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_offline_recovery_contract_cl(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,busi_date -- 业务发生日期
            ,pay_date -- 偿付日期
            ,trader_name -- 交易对手名称
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_account -- 交易对手账号
            ,trader_bank_no -- 交易对手行行号
            ,trader_brh_no -- 交易对手机构代码
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 财务机构号
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_offline_recovery_contract_op(
            id -- 
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,top_branch_no -- 总行机构号
            ,branch_no -- 机构号
            ,recept_brh_id -- 承接行机构代码
            ,busi_date -- 业务发生日期
            ,pay_date -- 偿付日期
            ,trader_name -- 交易对手名称
            ,trader_credit_no -- 交易对手社会信用代码
            ,trader_account -- 交易对手账号
            ,trader_bank_no -- 交易对手行行号
            ,trader_brh_no -- 交易对手机构代码
            ,busi_branch_no -- 业务机构号
            ,acct_branch_no -- 财务机构号
            ,manager_no -- 客户经理
            ,department_no -- 部门编号
            ,contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,last_upd_opr -- 最后操作人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
            ,created_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.contract_no -- 批次号
    ,o.product_no -- 产品号
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.top_branch_no -- 总行机构号
    ,o.branch_no -- 机构号
    ,o.recept_brh_id -- 承接行机构代码
    ,o.busi_date -- 业务发生日期
    ,o.pay_date -- 偿付日期
    ,o.trader_name -- 交易对手名称
    ,o.trader_credit_no -- 交易对手社会信用代码
    ,o.trader_account -- 交易对手账号
    ,o.trader_bank_no -- 交易对手行行号
    ,o.trader_brh_no -- 交易对手机构代码
    ,o.busi_branch_no -- 业务机构号
    ,o.acct_branch_no -- 财务机构号
    ,o.manager_no -- 客户经理
    ,o.department_no -- 部门编号
    ,o.contract_status -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.cust_type -- 客户类别： 1 对公客户 2 同业客户 3 理财客户
    ,o.created_by -- 创建人
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_offline_recovery_contract_bk o
    left join ${iol_schema}.bdms_cpes_offline_recovery_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_offline_recovery_contract_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_offline_recovery_contract;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_offline_recovery_contract exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_offline_recovery_contract_cl;
alter table ${iol_schema}.bdms_cpes_offline_recovery_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_offline_recovery_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_offline_recovery_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract_op purge;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_offline_recovery_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_offline_recovery_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
