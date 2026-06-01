/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_ces_redsct_deal
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_ces_redsct_deal_ex purge;
alter table ${iol_schema}.bdms_ces_redsct_deal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_ces_redsct_deal;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_ces_redsct_deal_ex nologging
compress
as
select * from ${iol_schema}.bdms_ces_redsct_deal where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_ces_redsct_deal_ex(
    id -- ID
    ,dealed_no -- 成交单编号
    ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,quote_no -- 报价单编号
    ,buss_contract_id -- 业务批次表ID
    ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,trade_date -- 成交日期
    ,trade_time -- 成交时间
    ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销
    ,settle_status -- 清算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,due_settle_status -- 到期结算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
    ,brh_no -- 机构代码
    ,product_no -- 非法人产品
    ,trader_id -- 交易员ID
    ,cfm_trader_id -- 确认人ID
    ,pbc_brh_no -- 人行机构代码
    ,acpt_user_id -- 人行机构受理人用户ID
    ,acpt_user_name -- 人行机构受理人名称
    ,acpt_user_note -- 受理审核人审批意见
    ,complete_user_id -- 人行机构复核人用户ID
    ,complete_user_name -- 人行机构复核人名称
    ,complete_user_note -- 复核人审批意见
    ,approval_user_id -- 人行机构审批人用户ID
    ,approval_user_name -- 人行机构审批人名称
    ,approval_user_note -- 审批人审批意见
    ,quote_status -- 报价单状态： QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常
    ,lock_flag -- 锁定标识： 0 否 1 是
    ,misc -- 备注
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,create_time -- 创建时间
    ,create_by -- 创建人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,dealed_no -- 成交单编号
    ,busi_type -- 业务类型： RBT02 再贴现质押回购 RBT01 再贴现买断
    ,quote_no -- 报价单编号
    ,buss_contract_id -- 业务批次表ID
    ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,trade_date -- 成交日期
    ,trade_time -- 成交时间
    ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销
    ,settle_status -- 清算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,due_settle_status -- 到期结算状态： R20 结算成功 R21 结算失败 R23 已撤销
    ,approve_result -- 审批结果： SU00 同意 SU01 拒绝
    ,brh_no -- 机构代码
    ,product_no -- 非法人产品
    ,trader_id -- 交易员ID
    ,cfm_trader_id -- 确认人ID
    ,pbc_brh_no -- 人行机构代码
    ,acpt_user_id -- 人行机构受理人用户ID
    ,acpt_user_name -- 人行机构受理人名称
    ,acpt_user_note -- 受理审核人审批意见
    ,complete_user_id -- 人行机构复核人用户ID
    ,complete_user_name -- 人行机构复核人名称
    ,complete_user_note -- 复核人审批意见
    ,approval_user_id -- 人行机构审批人用户ID
    ,approval_user_name -- 人行机构审批人名称
    ,approval_user_note -- 审批人审批意见
    ,quote_status -- 报价单状态： QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常
    ,lock_flag -- 锁定标识： 0 否 1 是
    ,misc -- 备注
    ,reserver1 -- 预留域1
    ,reserver2 -- 预留域2
    ,last_upd_opr -- 最后操作员
    ,last_upd_time -- 最后修改时间
    ,create_time -- 创建时间
    ,create_by -- 创建人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_ces_redsct_deal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_ces_redsct_deal exchange partition p_${batch_date} with table ${iol_schema}.bdms_ces_redsct_deal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_ces_redsct_deal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_ces_redsct_deal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_ces_redsct_deal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);