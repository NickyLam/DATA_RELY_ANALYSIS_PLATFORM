/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_send_coll_contract
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
create table ${iol_schema}.bdms_bms_send_coll_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_send_coll_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_send_coll_contract_op purge;
drop table ${iol_schema}.bdms_bms_send_coll_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_send_coll_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_send_coll_contract where 0=1;

create table ${iol_schema}.bdms_bms_send_coll_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_send_coll_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_send_coll_contract_cl(
            id -- ID
            ,protocol_no -- 发托协议号
            ,product_no -- 产品类型编码
            ,sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,drft_hldr_no -- 提示付款人客户号
            ,drft_hldr_name -- 提示入款人全称
            ,drft_hldr_account -- 提示付款人入账帐号
            ,drft_hldr_bank_no -- 提示付款人开户行行号
            ,drft_hldr_bank_name -- 提示付款人开户行名称
            ,apply_date -- 托收申请日
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,operator_no -- 业务发起人编号
            ,txn_date -- 交易日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,top_branch_no -- 总行机构号
            ,branch_id -- 机构id 0：人工（默认）1：批量
            ,cust_address -- 客户地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_send_coll_contract_op(
            id -- ID
            ,protocol_no -- 发托协议号
            ,product_no -- 产品类型编码
            ,sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,drft_hldr_no -- 提示付款人客户号
            ,drft_hldr_name -- 提示入款人全称
            ,drft_hldr_account -- 提示付款人入账帐号
            ,drft_hldr_bank_no -- 提示付款人开户行行号
            ,drft_hldr_bank_name -- 提示付款人开户行名称
            ,apply_date -- 托收申请日
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,operator_no -- 业务发起人编号
            ,txn_date -- 交易日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,top_branch_no -- 总行机构号
            ,branch_id -- 机构id 0：人工（默认）1：批量
            ,cust_address -- 客户地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 发托协议号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品类型编码
    ,nvl(n.sned_state, o.sned_state) as sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
    ,nvl(n.drft_hldr_no, o.drft_hldr_no) as drft_hldr_no -- 提示付款人客户号
    ,nvl(n.drft_hldr_name, o.drft_hldr_name) as drft_hldr_name -- 提示入款人全称
    ,nvl(n.drft_hldr_account, o.drft_hldr_account) as drft_hldr_account -- 提示付款人入账帐号
    ,nvl(n.drft_hldr_bank_no, o.drft_hldr_bank_no) as drft_hldr_bank_no -- 提示付款人开户行行号
    ,nvl(n.drft_hldr_bank_name, o.drft_hldr_bank_name) as drft_hldr_bank_name -- 提示付款人开户行名称
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 托收申请日
    ,nvl(n.valet_flag, o.valet_flag) as valet_flag -- 是否代客托收： 0 否 1 是
    ,nvl(n.fee_mode, o.fee_mode) as fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 业务发起人编号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 交易日期
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.check_status, o.check_status) as check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- BUSI_BRANCH_NO
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构id 0：人工（默认）1：批量
    ,nvl(n.cust_address, o.cust_address) as cust_address -- 客户地址
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
from (select * from ${iol_schema}.bdms_bms_send_coll_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_send_coll_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.product_no <> n.product_no
        or o.sned_state <> n.sned_state
        or o.drft_hldr_no <> n.drft_hldr_no
        or o.drft_hldr_name <> n.drft_hldr_name
        or o.drft_hldr_account <> n.drft_hldr_account
        or o.drft_hldr_bank_no <> n.drft_hldr_bank_no
        or o.drft_hldr_bank_name <> n.drft_hldr_bank_name
        or o.apply_date <> n.apply_date
        or o.valet_flag <> n.valet_flag
        or o.fee_mode <> n.fee_mode
        or o.operator_no <> n.operator_no
        or o.txn_date <> n.txn_date
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.check_status <> n.check_status
        or o.contract_status <> n.contract_status
        or o.account_status <> n.account_status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.branch_id <> n.branch_id
        or o.cust_address <> n.cust_address
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_send_coll_contract_cl(
            id -- ID
            ,protocol_no -- 发托协议号
            ,product_no -- 产品类型编码
            ,sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,drft_hldr_no -- 提示付款人客户号
            ,drft_hldr_name -- 提示入款人全称
            ,drft_hldr_account -- 提示付款人入账帐号
            ,drft_hldr_bank_no -- 提示付款人开户行行号
            ,drft_hldr_bank_name -- 提示付款人开户行名称
            ,apply_date -- 托收申请日
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,operator_no -- 业务发起人编号
            ,txn_date -- 交易日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,top_branch_no -- 总行机构号
            ,branch_id -- 机构id 0：人工（默认）1：批量
            ,cust_address -- 客户地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_send_coll_contract_op(
            id -- ID
            ,protocol_no -- 发托协议号
            ,product_no -- 产品类型编码
            ,sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,drft_hldr_no -- 提示付款人客户号
            ,drft_hldr_name -- 提示入款人全称
            ,drft_hldr_account -- 提示付款人入账帐号
            ,drft_hldr_bank_no -- 提示付款人开户行行号
            ,drft_hldr_bank_name -- 提示付款人开户行名称
            ,apply_date -- 托收申请日
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,operator_no -- 业务发起人编号
            ,txn_date -- 交易日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
            ,contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,top_branch_no -- 总行机构号
            ,branch_id -- 机构id 0：人工（默认）1：批量
            ,cust_address -- 客户地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.protocol_no -- 发托协议号
    ,o.product_no -- 产品类型编码
    ,o.sned_state -- 发托状态： 1 发托 2 款到 3 托收退票
    ,o.drft_hldr_no -- 提示付款人客户号
    ,o.drft_hldr_name -- 提示入款人全称
    ,o.drft_hldr_account -- 提示付款人入账帐号
    ,o.drft_hldr_bank_no -- 提示付款人开户行行号
    ,o.drft_hldr_bank_name -- 提示付款人开户行名称
    ,o.apply_date -- 托收申请日
    ,o.valet_flag -- 是否代客托收： 0 否 1 是
    ,o.fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,o.operator_no -- 业务发起人编号
    ,o.txn_date -- 交易日期
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.check_status -- 业务检查状态： 00 无效 01 检查通过 02 检查通过，存在风险 03 检查不通过
    ,o.contract_status -- 批次状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 已抹账 13 部分散票审核退回
    ,o.account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.busi_branch_no -- BUSI_BRANCH_NO
    ,o.top_branch_no -- 总行机构号
    ,o.branch_id -- 机构id 0：人工（默认）1：批量
    ,o.cust_address -- 客户地址
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
from ${iol_schema}.bdms_bms_send_coll_contract_bk o
    left join ${iol_schema}.bdms_bms_send_coll_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_send_coll_contract_cl d
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
--truncate table ${iol_schema}.bdms_bms_send_coll_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_send_coll_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_send_coll_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_send_coll_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_send_coll_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_send_coll_contract_cl;
alter table ${iol_schema}.bdms_bms_send_coll_contract exchange partition p_20991231 with table ${iol_schema}.bdms_bms_send_coll_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_send_coll_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_send_coll_contract_op purge;
drop table ${iol_schema}.bdms_bms_send_coll_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_send_coll_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_send_coll_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
