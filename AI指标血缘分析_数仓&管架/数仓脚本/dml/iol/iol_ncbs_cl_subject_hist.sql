/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_subject_hist
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
drop table ${iol_schema}.ncbs_cl_subject_hist_ex purge;
alter table ${iol_schema}.ncbs_cl_subject_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_subject_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_subject_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_subject_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_subject_hist_ex(
    amt_type -- 金额类型
    ,branch -- 机构编号
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
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,company -- 法人
    ,conv_base -- 转换基础
    ,cr_dr_maint_ind -- 借贷标识
    ,gl_posted_flag -- 过账标记
    ,main_seq_no -- 主流水号
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,program_id -- 交易代码
    ,rate_type -- 汇率类型
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,reversal -- 是否冲正标志
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,effect_date -- 产品生效日期
    ,post_date -- 入账日期
    ,reversal_tran_date -- 冲正交易日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,float_days -- 浮动天数
    ,tfr_branch -- 对方交易机构
    ,tran_amt -- 交易金额
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    amt_type -- 金额类型
    ,branch -- 机构编号
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
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,company -- 法人
    ,conv_base -- 转换基础
    ,cr_dr_maint_ind -- 借贷标识
    ,gl_posted_flag -- 过账标记
    ,main_seq_no -- 主流水号
    ,narrative -- 摘要
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,program_id -- 交易代码
    ,rate_type -- 汇率类型
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,reversal -- 是否冲正标志
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,effect_date -- 产品生效日期
    ,post_date -- 入账日期
    ,reversal_tran_date -- 冲正交易日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,float_days -- 浮动天数
    ,tfr_branch -- 对方交易机构
    ,tran_amt -- 交易金额
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_subject_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_subject_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_subject_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_subject_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_subject_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_subject_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);