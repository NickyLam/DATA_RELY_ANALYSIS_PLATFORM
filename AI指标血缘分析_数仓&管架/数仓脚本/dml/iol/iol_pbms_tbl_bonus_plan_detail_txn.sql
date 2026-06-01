/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_bonus_plan_detail_txn
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
drop table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn_ex purge;
alter table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn;

-- 2.3 insert data to ex table
create table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn_ex nologging
compress
as
select * from ${iol_schema}.pbms_tbl_bonus_plan_detail_txn where 0=1;

insert /*+ append */ into ${iol_schema}.pbms_tbl_bonus_plan_detail_txn_ex(
    pk_bonus_plan_detail_txn -- 主键
    ,ssn -- 积分权益管理平台交易流水号
    ,ori_order_id -- 原订单号（只有退货时才有）
    ,glob_seq -- 全局流水号
    ,order_id -- 订单号（业务流水号）
    ,txn_chn -- 交易渠道，源发送通道号
    ,txn_date -- 交易日期（yyyyMMdd）
    ,txn_time -- 交易时间（HHmmss）
    ,posting_date -- 入账日期（yyyyMMdd）
    ,posting_time -- 入账时间（HHmmss）
    ,txn_type -- 1：获赠2：消费3：到期 4：手工调整、5:退货
    ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
    ,summary -- 摘要，显示给用户
    ,memo_info -- 备注，仅显示在系统页面
    ,txn_code -- 交易码
    ,txn_desc -- 交易描述
    ,cnsn_arti_id -- 消费者编码
    ,usage_key -- 权益用途key
    ,ext_coulmn3 -- 预留字段3
    ,ext_coulmn2 -- 预留字段2
    ,ext_coulmn1 -- 预留字段1
    ,cust_id -- 客户号
    ,org_id -- 机构
    ,bonus_sub_type -- 积分二级分类
    ,valid_date -- 有效期（yyyyMMdd）
    ,bonus_plan_type -- 积分来源，权益层级：x
    ,txn_amount -- 交易金额
    ,txn_bonus -- 交易积分
    ,bonus_cd_flag -- 交易方向，1-增加 0-减少
    ,return_flag -- 冲正标志，0-正常 1-待冲正
    ,batch_id -- 批次号
    ,rule_id -- 赠送规则编号
    ,rule_name -- 赠送规则名称
    ,created_by -- 创建人，系统创建写system
    ,create_time -- 创建时间
    ,updated_by -- 更新人，系统创建写system
    ,update_time -- 更新时间
    ,del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,rema_usab_bonus -- 交易后可用积分余额
    ,jrnl_no -- 卡系统流水号
    ,tran_seq_no_uuid -- 聚合支付流水号
    ,card_no -- 卡号
    ,txn_status -- 交易状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pk_bonus_plan_detail_txn -- 主键
    ,ssn -- 积分权益管理平台交易流水号
    ,ori_order_id -- 原订单号（只有退货时才有）
    ,glob_seq -- 全局流水号
    ,order_id -- 订单号（业务流水号）
    ,txn_chn -- 交易渠道，源发送通道号
    ,txn_date -- 交易日期（yyyyMMdd）
    ,txn_time -- 交易时间（HHmmss）
    ,posting_date -- 入账日期（yyyyMMdd）
    ,posting_time -- 入账时间（HHmmss）
    ,txn_type -- 1：获赠2：消费3：到期 4：手工调整、5:退货
    ,biz_typ -- 业务类型，如0001：网上商城，0002：刷卡
    ,summary -- 摘要，显示给用户
    ,memo_info -- 备注，仅显示在系统页面
    ,txn_code -- 交易码
    ,txn_desc -- 交易描述
    ,cnsn_arti_id -- 消费者编码
    ,usage_key -- 权益用途key
    ,ext_coulmn3 -- 预留字段3
    ,ext_coulmn2 -- 预留字段2
    ,ext_coulmn1 -- 预留字段1
    ,cust_id -- 客户号
    ,org_id -- 机构
    ,bonus_sub_type -- 积分二级分类
    ,valid_date -- 有效期（yyyyMMdd）
    ,bonus_plan_type -- 积分来源，权益层级：x
    ,txn_amount -- 交易金额
    ,txn_bonus -- 交易积分
    ,bonus_cd_flag -- 交易方向，1-增加 0-减少
    ,return_flag -- 冲正标志，0-正常 1-待冲正
    ,batch_id -- 批次号
    ,rule_id -- 赠送规则编号
    ,rule_name -- 赠送规则名称
    ,created_by -- 创建人，系统创建写system
    ,create_time -- 创建时间
    ,updated_by -- 更新人，系统创建写system
    ,update_time -- 更新时间
    ,del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,rema_usab_bonus -- 交易后可用积分余额
    ,jrnl_no -- 卡系统流水号
    ,tran_seq_no_uuid -- 聚合支付流水号
    ,card_no -- 卡号
    ,txn_status -- 交易状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pbms_tbl_bonus_plan_detail_txn
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_txn to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_bonus_plan_detail_txn',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);