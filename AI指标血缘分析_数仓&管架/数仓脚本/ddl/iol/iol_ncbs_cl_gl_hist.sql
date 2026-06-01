/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_gl_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_gl_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_gl_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_gl_hist(
    gl_seq_no varchar2(50) -- 总账序号
    ,internal_key number(15,0) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,effect_date date -- 产品生效日期
    ,acct_ccy varchar2(3) -- 账户币种
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,business_unit varchar2(10) -- 账套
    ,amt_type varchar2(10) -- 金额类型
    ,amount number(17,2) -- 金额
    ,prod_type varchar2(12) -- 产品编号
    ,busi_prod varchar2(12) -- 业务产品
    ,loan_no varchar2(50) -- 贷款号
    ,branch varchar2(12) -- 交易机构编号
    ,accounting_status varchar2(3) -- 核算状态
    ,profit_center varchar2(20) -- 利润中心
    ,ccy varchar2(3) -- 币种
    ,client_type varchar2(3) -- 客户类型
    ,client_no varchar2(16) -- 客户编号
    ,system_id varchar2(20) -- 系统ID
    ,reversal varchar2(1) -- 是否冲正标志
    ,narrative varchar2(400) -- 摘要
    ,pri_amt number(17,2) -- 本金金额
    ,int_amt number(17,2) -- 利息金额
    ,odp_amt number(17,2) -- 罚息金额
    ,odi_amt number(17,2) -- 复利金额
    ,tran_profit_center varchar2(20) -- 交易利润中心
    ,event_type varchar2(20) -- 事件类型
    ,tran_type varchar2(10) -- 交易类型
    ,tran_date date -- 交易日期
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,gl_code varchar2(20) -- 科目代码
    ,channel_date date -- 渠道日期
    ,tax_amt number(17,2) -- 税金
    ,cr_dr_maint_ind varchar2(1) -- 借贷标识
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,reversal_date date -- 冲正日期
    ,spread_percent number(11,7) -- 浮动百分比
    ,in_status varchar2(1) -- 入账方式
    ,marketing_prod varchar2(12) -- 营销产品
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,tran_category varchar2(5) -- 交易种类
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,un_real varchar2(1) -- 虚拟标志
    ,settle_mode varchar2(1) -- 清算模式(流水上送)
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,old_branch varchar2(12) -- 变更前机构
    ,rule_no varchar2(20) -- 规则编号
    ,deal_flag varchar2(1) -- 处理标识
    ,balance_change_type varchar2(5) -- 余额变化类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_gl_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_gl_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_gl_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_gl_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_gl_hist is '核算流水表|记录供总账流水数据';
comment on column ${iol_schema}.ncbs_cl_gl_hist.gl_seq_no is '总账序号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_gl_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_cl_gl_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_gl_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_gl_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_gl_hist.amount is '金额';
comment on column ${iol_schema}.ncbs_cl_gl_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.busi_prod is '业务产品';
comment on column ${iol_schema}.ncbs_cl_gl_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_gl_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_gl_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_gl_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_gl_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.system_id is '系统ID';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_gl_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_gl_hist.pri_amt is '本金金额';
comment on column ${iol_schema}.ncbs_cl_gl_hist.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_cl_gl_hist.odp_amt is '罚息金额';
comment on column ${iol_schema}.ncbs_cl_gl_hist.odi_amt is '复利金额';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_profit_center is '交易利润中心';
comment on column ${iol_schema}.ncbs_cl_gl_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_gl_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_cl_gl_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_cl_gl_hist.cr_dr_maint_ind is '借贷标识';
comment on column ${iol_schema}.ncbs_cl_gl_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_gl_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_cl_gl_hist.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_cl_gl_hist.in_status is '入账方式';
comment on column ${iol_schema}.ncbs_cl_gl_hist.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_cl_gl_hist.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_gl_hist.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.un_real is '虚拟标志';
comment on column ${iol_schema}.ncbs_cl_gl_hist.settle_mode is '清算模式(流水上送)';
comment on column ${iol_schema}.ncbs_cl_gl_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_gl_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_gl_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_gl_hist.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_cl_gl_hist.rule_no is '规则编号';
comment on column ${iol_schema}.ncbs_cl_gl_hist.deal_flag is '处理标识';
comment on column ${iol_schema}.ncbs_cl_gl_hist.balance_change_type is '余额变化类型';
comment on column ${iol_schema}.ncbs_cl_gl_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_gl_hist.etl_timestamp is 'ETL处理时间戳';
