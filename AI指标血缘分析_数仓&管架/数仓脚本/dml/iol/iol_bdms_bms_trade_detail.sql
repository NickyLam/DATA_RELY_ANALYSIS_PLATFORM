/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_trade_detail
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
drop table ${iol_schema}.bdms_bms_trade_detail_ex purge;
alter table ${iol_schema}.bdms_bms_trade_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_bms_trade_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_bms_trade_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_trade_detail where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_bms_trade_detail_ex(
    trade_detail_id -- 记账交易订单记录表ID
    ,top_bank_no -- 所属总行行号
    ,trans_branch_no -- 交易机构编号
    ,trade_no -- 记账交易号
    ,trade_attr_str -- 交易属性字符串
    ,product_no -- 产品号
    ,contract_id -- 协议ID
    ,protocol_no -- 协议号
    ,detail_id -- 明细ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_amount -- 票面金额
    ,code_no -- 分录顺序号
    ,take -- 取值字段
    ,dr_cr -- 借代方向： D 借 C 贷 R 收 P 付
    ,party_role -- 参与方角色
    ,amount -- 参与方金额
    ,flag -- 分录标识
    ,sub_no -- 科目号
    ,name -- 科目名称
    ,customer_id -- 客户号
    ,account_no -- 目标账户号
    ,account_type -- 参与方账户类型
    ,inst_code -- 机构编码
    ,party_type -- 参与方类型
    ,extension -- 参与方扩展
    ,amount_reserve1 -- 扩展金额1
    ,amount_reserve2 -- 扩展金额2
    ,amount_reserve3 -- 扩展金额3
    ,is_batch_acct -- 是否批次记账： 1 是 0 否
    ,status -- 明细状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,create_time -- 创建时间
    ,update_time -- 创建时间
    ,last_upd_oper_no -- 最后修改操作员号
    ,reserve1 -- 备注1
    ,reserve2 -- 备注2
    ,reserve3 -- 备注3
    ,reserve4 -- 备注4
    ,acct_branch_no -- 账务机构号
    ,bms_draft_id -- 原票据系统的登记中心ID
    ,cd_split -- 是否允许分包流转： 0 否 1 是
    ,cd_range -- 子票区间
    ,maturity_date -- 
    ,settle_status -- 
    ,src_type -- 鏉ユ簮
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    trade_detail_id -- 记账交易订单记录表ID
    ,top_bank_no -- 所属总行行号
    ,trans_branch_no -- 交易机构编号
    ,trade_no -- 记账交易号
    ,trade_attr_str -- 交易属性字符串
    ,product_no -- 产品号
    ,contract_id -- 协议ID
    ,protocol_no -- 协议号
    ,detail_id -- 明细ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_amount -- 票面金额
    ,code_no -- 分录顺序号
    ,take -- 取值字段
    ,dr_cr -- 借代方向： D 借 C 贷 R 收 P 付
    ,party_role -- 参与方角色
    ,amount -- 参与方金额
    ,flag -- 分录标识
    ,sub_no -- 科目号
    ,name -- 科目名称
    ,customer_id -- 客户号
    ,account_no -- 目标账户号
    ,account_type -- 参与方账户类型
    ,inst_code -- 机构编码
    ,party_type -- 参与方类型
    ,extension -- 参与方扩展
    ,amount_reserve1 -- 扩展金额1
    ,amount_reserve2 -- 扩展金额2
    ,amount_reserve3 -- 扩展金额3
    ,is_batch_acct -- 是否批次记账： 1 是 0 否
    ,status -- 明细状态： 0 记账失败 1 记账成功 2 记账处理中 3 冲正处理中 4 冲正成功 5 冲正失败
    ,create_time -- 创建时间
    ,update_time -- 创建时间
    ,last_upd_oper_no -- 最后修改操作员号
    ,reserve1 -- 备注1
    ,reserve2 -- 备注2
    ,reserve3 -- 备注3
    ,reserve4 -- 备注4
    ,acct_branch_no -- 账务机构号
    ,bms_draft_id -- 原票据系统的登记中心ID
    ,cd_split -- 是否允许分包流转： 0 否 1 是
    ,cd_range -- 子票区间
    ,maturity_date -- 
    ,settle_status -- 
    ,src_type -- 鏉ユ簮
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_bms_trade_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_bms_trade_detail exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_trade_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_trade_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_bms_trade_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_trade_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);