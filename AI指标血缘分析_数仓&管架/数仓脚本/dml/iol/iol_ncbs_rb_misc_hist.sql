/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_misc_hist
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
drop table ${iol_schema}.ncbs_rb_misc_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_misc_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_misc_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_misc_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_misc_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_misc_hist_ex(
    amt_type -- 金额类型
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,country -- 国家
    ,doc_type -- 凭证类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,bank_seq_no -- 银行交易序号
    ,br_seq_no -- 前端流水号
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,conv_base -- 转换基础
    ,cr_dr_ind -- 借贷标志
    ,dept_code -- 现金支出项目编码
    ,gl_posted_flag -- 过账标记
    ,main_seq_no -- 主流水号
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,rate_type -- 汇率类型
    ,rec_pay_flag -- 柜面收付标志
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_id -- 系统id
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,post_date -- 入账日期
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,credit_card_no -- 信用卡号
    ,cross_rate -- 交叉汇率
    ,d2_reference -- d2参考号
    ,float_days -- 浮动天数
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_document_id -- 交易对手证件号码
    ,oth_document_type -- 交易对手证件类型
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,oth_reference -- 对方交易参考号
    ,oth_tran_addr -- 交易发生地
    ,oth_tran_name -- 交易对手名称
    ,spread_percent -- 浮动百分比
    ,tfr_branch -- 对方交易机构
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,country -- 国家
    ,doc_type -- 凭证类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,bank_seq_no -- 银行交易序号
    ,br_seq_no -- 前端流水号
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,conv_base -- 转换基础
    ,cr_dr_ind -- 借贷标志
    ,dept_code -- 现金支出项目编码
    ,gl_posted_flag -- 过账标记
    ,main_seq_no -- 主流水号
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,rate_type -- 汇率类型
    ,rec_pay_flag -- 柜面收付标志
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_id -- 系统id
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,post_date -- 入账日期
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,credit_card_no -- 信用卡号
    ,cross_rate -- 交叉汇率
    ,d2_reference -- d2参考号
    ,float_days -- 浮动天数
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_document_id -- 交易对手证件号码
    ,oth_document_type -- 交易对手证件类型
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,oth_reference -- 对方交易参考号
    ,oth_tran_addr -- 交易发生地
    ,oth_tran_name -- 交易对手名称
    ,spread_percent -- 浮动百分比
    ,tfr_branch -- 对方交易机构
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_misc_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_misc_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_misc_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_misc_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_misc_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_misc_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);