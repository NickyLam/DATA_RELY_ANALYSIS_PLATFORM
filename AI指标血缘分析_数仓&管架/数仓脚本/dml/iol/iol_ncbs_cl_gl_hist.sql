/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_gl_hist
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
drop table ${iol_schema}.ncbs_cl_gl_hist_ex purge;
alter table ${iol_schema}.ncbs_cl_gl_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_gl_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_gl_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_gl_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_gl_hist_ex(
    gl_seq_no -- 总账序号
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_branch -- 核心交易机构编号
    ,effect_date -- 产品生效日期
    ,acct_ccy -- 账户币种
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,business_unit -- 账套
    ,amt_type -- 金额类型
    ,amount -- 金额
    ,prod_type -- 产品编号
    ,busi_prod -- 业务产品
    ,loan_no -- 贷款号
    ,branch -- 交易机构编号
    ,accounting_status -- 核算状态
    ,profit_center -- 利润中心
    ,ccy -- 币种
    ,client_type -- 客户类型
    ,client_no -- 客户编号
    ,system_id -- 系统ID
    ,reversal -- 是否冲正标志
    ,narrative -- 摘要
    ,pri_amt -- 本金金额
    ,int_amt -- 利息金额
    ,odp_amt -- 罚息金额
    ,odi_amt -- 复利金额
    ,tran_profit_center -- 交易利润中心
    ,event_type -- 事件类型
    ,tran_type -- 交易类型
    ,tran_date -- 交易日期
    ,bank_seq_no -- 银行交易序号
    ,gl_code -- 科目代码
    ,channel_date -- 渠道日期
    ,tax_amt -- 税金
    ,cr_dr_maint_ind -- 借贷标识
    ,gl_posted_flag -- 过账标记
    ,channel_seq_no -- 全局流水号
    ,reversal_seq_no -- 冲正流水号
    ,reversal_date -- 冲正日期
    ,spread_percent -- 浮动百分比
    ,in_status -- 入账方式
    ,marketing_prod -- 营销产品
    ,marketing_prod_desc -- 营销产品名称
    ,tran_category -- 交易种类
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,channel_sub_seq_no -- 渠道子流水号
    ,un_real -- 虚拟标志
    ,settle_mode -- 清算模式(流水上送)
    ,company -- 法人
    ,tran_timestamp -- 交易时间戳
    ,bus_seq_no -- 业务流水号
    ,reaccount_cd -- 对账代码
    ,old_branch -- 变更前机构
    ,rule_no -- 规则编号
    ,deal_flag -- 处理标识
    ,balance_change_type -- 余额变化类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gl_seq_no -- 总账序号
    ,internal_key -- 账户内部键值
    ,reference -- 交易参考号
    ,tran_branch -- 核心交易机构编号
    ,effect_date -- 产品生效日期
    ,acct_ccy -- 账户币种
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,business_unit -- 账套
    ,amt_type -- 金额类型
    ,amount -- 金额
    ,prod_type -- 产品编号
    ,busi_prod -- 业务产品
    ,loan_no -- 贷款号
    ,branch -- 交易机构编号
    ,accounting_status -- 核算状态
    ,profit_center -- 利润中心
    ,ccy -- 币种
    ,client_type -- 客户类型
    ,client_no -- 客户编号
    ,system_id -- 系统ID
    ,reversal -- 是否冲正标志
    ,narrative -- 摘要
    ,pri_amt -- 本金金额
    ,int_amt -- 利息金额
    ,odp_amt -- 罚息金额
    ,odi_amt -- 复利金额
    ,tran_profit_center -- 交易利润中心
    ,event_type -- 事件类型
    ,tran_type -- 交易类型
    ,tran_date -- 交易日期
    ,bank_seq_no -- 银行交易序号
    ,gl_code -- 科目代码
    ,channel_date -- 渠道日期
    ,tax_amt -- 税金
    ,cr_dr_maint_ind -- 借贷标识
    ,gl_posted_flag -- 过账标记
    ,channel_seq_no -- 全局流水号
    ,reversal_seq_no -- 冲正流水号
    ,reversal_date -- 冲正日期
    ,spread_percent -- 浮动百分比
    ,in_status -- 入账方式
    ,marketing_prod -- 营销产品
    ,marketing_prod_desc -- 营销产品名称
    ,tran_category -- 交易种类
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,channel_sub_seq_no -- 渠道子流水号
    ,un_real -- 虚拟标志
    ,settle_mode -- 清算模式(流水上送)
    ,company -- 法人
    ,tran_timestamp -- 交易时间戳
    ,bus_seq_no -- 业务流水号
    ,reaccount_cd -- 对账代码
    ,old_branch -- 变更前机构
    ,rule_no -- 规则编号
    ,deal_flag -- 处理标识
    ,balance_change_type -- 余额变化类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_gl_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_gl_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_gl_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_gl_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_gl_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_gl_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);