/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_chs_charge_detail
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
create table ${iol_schema}.bdms_chs_charge_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_chs_charge_detail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_chs_charge_detail_op purge;
drop table ${iol_schema}.bdms_chs_charge_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_chs_charge_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_chs_charge_detail where 0=1;

create table ${iol_schema}.bdms_chs_charge_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_chs_charge_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_chs_charge_detail_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,mem_name -- 会员名称
            ,charge_period -- 服务费期数
            ,busi_date -- 业务发生日期
            ,branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,brh_no -- 机构代码
            ,brh_name -- 机构名称
            ,contract_id -- 业务批次表ID
            ,contract_no -- 业务表批次号
            ,details_id -- 明细表ID
            ,draft_number -- 票号
            ,busi_amount -- 业务金额
            ,charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
            ,charge_standard -- 收费标准
            ,busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
            ,total_amt -- 计费总额
            ,rebate_amt -- 优惠金额
            ,fee_amt -- 应缴金额
            ,deal_operator -- 批量处理操作员
            ,deal_time -- 操作处理时间
            ,tenor_days -- 持票期限
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_chs_charge_detail_op(
            id -- ID
            ,mem_no -- 会员代码
            ,mem_name -- 会员名称
            ,charge_period -- 服务费期数
            ,busi_date -- 业务发生日期
            ,branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,brh_no -- 机构代码
            ,brh_name -- 机构名称
            ,contract_id -- 业务批次表ID
            ,contract_no -- 业务表批次号
            ,details_id -- 明细表ID
            ,draft_number -- 票号
            ,busi_amount -- 业务金额
            ,charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
            ,charge_standard -- 收费标准
            ,busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
            ,total_amt -- 计费总额
            ,rebate_amt -- 优惠金额
            ,fee_amt -- 应缴金额
            ,deal_operator -- 批量处理操作员
            ,deal_time -- 操作处理时间
            ,tenor_days -- 持票期限
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.mem_no, o.mem_no) as mem_no -- 会员代码
    ,nvl(n.mem_name, o.mem_name) as mem_name -- 会员名称
    ,nvl(n.charge_period, o.charge_period) as charge_period -- 服务费期数
    ,nvl(n.busi_date, o.busi_date) as busi_date -- 业务发生日期
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 票据所属机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.brh_name, o.brh_name) as brh_name -- 机构名称
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 业务批次表ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 业务表批次号
    ,nvl(n.details_id, o.details_id) as details_id -- 明细表ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票号
    ,nvl(n.busi_amount, o.busi_amount) as busi_amount -- 业务金额
    ,nvl(n.charge_item, o.charge_item) as charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
    ,nvl(n.charge_standard, o.charge_standard) as charge_standard -- 收费标准
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 计费总额
    ,nvl(n.rebate_amt, o.rebate_amt) as rebate_amt -- 优惠金额
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 应缴金额
    ,nvl(n.deal_operator, o.deal_operator) as deal_operator -- 批量处理操作员
    ,nvl(n.deal_time, o.deal_time) as deal_time -- 操作处理时间
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 持票期限
    ,nvl(n.misc, o.misc) as misc -- 备注
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
from (select * from ${iol_schema}.bdms_chs_charge_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_chs_charge_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.mem_no <> n.mem_no
        or o.mem_name <> n.mem_name
        or o.charge_period <> n.charge_period
        or o.busi_date <> n.busi_date
        or o.branch_no <> n.branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.brh_no <> n.brh_no
        or o.brh_name <> n.brh_name
        or o.contract_id <> n.contract_id
        or o.contract_no <> n.contract_no
        or o.details_id <> n.details_id
        or o.draft_number <> n.draft_number
        or o.busi_amount <> n.busi_amount
        or o.charge_item <> n.charge_item
        or o.charge_standard <> n.charge_standard
        or o.busi_type <> n.busi_type
        or o.total_amt <> n.total_amt
        or o.rebate_amt <> n.rebate_amt
        or o.fee_amt <> n.fee_amt
        or o.deal_operator <> n.deal_operator
        or o.deal_time <> n.deal_time
        or o.tenor_days <> n.tenor_days
        or o.misc <> n.misc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_chs_charge_detail_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,mem_name -- 会员名称
            ,charge_period -- 服务费期数
            ,busi_date -- 业务发生日期
            ,branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,brh_no -- 机构代码
            ,brh_name -- 机构名称
            ,contract_id -- 业务批次表ID
            ,contract_no -- 业务表批次号
            ,details_id -- 明细表ID
            ,draft_number -- 票号
            ,busi_amount -- 业务金额
            ,charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
            ,charge_standard -- 收费标准
            ,busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
            ,total_amt -- 计费总额
            ,rebate_amt -- 优惠金额
            ,fee_amt -- 应缴金额
            ,deal_operator -- 批量处理操作员
            ,deal_time -- 操作处理时间
            ,tenor_days -- 持票期限
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_chs_charge_detail_op(
            id -- ID
            ,mem_no -- 会员代码
            ,mem_name -- 会员名称
            ,charge_period -- 服务费期数
            ,busi_date -- 业务发生日期
            ,branch_no -- 票据所属机构号
            ,top_branch_no -- 总行机构号
            ,brh_no -- 机构代码
            ,brh_name -- 机构名称
            ,contract_id -- 业务批次表ID
            ,contract_no -- 业务表批次号
            ,details_id -- 明细表ID
            ,draft_number -- 票号
            ,busi_amount -- 业务金额
            ,charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
            ,charge_standard -- 收费标准
            ,busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
            ,total_amt -- 计费总额
            ,rebate_amt -- 优惠金额
            ,fee_amt -- 应缴金额
            ,deal_operator -- 批量处理操作员
            ,deal_time -- 操作处理时间
            ,tenor_days -- 持票期限
            ,misc -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.mem_no -- 会员代码
    ,o.mem_name -- 会员名称
    ,o.charge_period -- 服务费期数
    ,o.busi_date -- 业务发生日期
    ,o.branch_no -- 票据所属机构号
    ,o.top_branch_no -- 总行机构号
    ,o.brh_no -- 机构代码
    ,o.brh_name -- 机构名称
    ,o.contract_id -- 业务批次表ID
    ,o.contract_no -- 业务表批次号
    ,o.details_id -- 明细表ID
    ,o.draft_number -- 票号
    ,o.busi_amount -- 业务金额
    ,o.charge_item -- 收费项目： 0 交易手续费 1 账户维护费 2 结算过户费 3 其他结算费
    ,o.charge_standard -- 收费标准
    ,o.busi_type -- 业务类型： 00 转贴现 01 质押式回购 02 买断式回购 03 转贴现 纯票过户 04 转贴现 票款兑付 05 质押式回购 纯票过户 06 质押式回购 票款对付 07 买断式回购 纯票过户 08 买断式回购 票款对付 09 跨机构权属登记 10 已贴现票据质押 11 非交易过户 12 提前/逾期赎回 13 已贴现票据托收 14 追偿结算 15 票交所资金账户扣划 16 信息更正 17 未贴现票据背书转让 18 未贴现票据托收
    ,o.total_amt -- 计费总额
    ,o.rebate_amt -- 优惠金额
    ,o.fee_amt -- 应缴金额
    ,o.deal_operator -- 批量处理操作员
    ,o.deal_time -- 操作处理时间
    ,o.tenor_days -- 持票期限
    ,o.misc -- 备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_chs_charge_detail_bk o
    left join ${iol_schema}.bdms_chs_charge_detail_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_chs_charge_detail_cl d
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
-- truncate table ${iol_schema}.bdms_chs_charge_detail;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_chs_charge_detail exchange partition p_19000101 with table ${iol_schema}.bdms_chs_charge_detail_cl;
alter table ${iol_schema}.bdms_chs_charge_detail exchange partition p_20991231 with table ${iol_schema}.bdms_chs_charge_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_chs_charge_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_chs_charge_detail_op purge;
drop table ${iol_schema}.bdms_chs_charge_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_chs_charge_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_chs_charge_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
