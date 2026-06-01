/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_gl_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_gl_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_gl_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_gl_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,amount number(17,2) -- 金额
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,gl_seq_no varchar2(50) -- 总账序号
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,narrative varchar2(400) -- 摘要
    ,reversal varchar2(1) -- 是否冲正标志
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,send_system varchar2(20) -- 转发系统
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,system_id varchar2(20) -- 系统id
    ,un_real varchar2(1) -- 虚拟标志
    ,tax_percent number(11,7) -- 纳税比率
    ,tran_category varchar2(5) -- 交易种类
    ,accounting_status varchar2(3) -- 核算状态
    ,channel_date date -- 渠道日期
    ,effect_date date -- 产品生效日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_internal_key number(15) -- 账号键值
    ,busi_prod varchar2(12) -- 业务产品
    ,marketing_prod varchar2(12) -- 营销产品
    ,oth_amount number(17,2) -- 其他对手金额
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,subject_code varchar2(20) -- 银行科目代码
    ,tax_amt number(17,2) -- 税金
    ,trade_no varchar2(50) -- 交易流水识别号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,flat_rate number(15,8) -- 平盘汇率
    ,cust_rate number(15,8) -- 对客汇率
    ,settle_mode varchar2(1) -- 清算模式(流水上送)
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,balance_change_type varchar2(5) -- 余额变化类型
    ,deal_flag varchar2(1) -- 处理标识
    ,rule_no varchar2(20) -- 规则编号
    ,tailbox_id varchar2(30) -- 尾箱代号
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
grant select on ${iol_schema}.ncbs_tb_gl_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_gl_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_gl_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_gl_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_gl_hist is '公共核算流水供数表';
comment on column ${iol_schema}.ncbs_tb_gl_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.amount is '金额';
comment on column ${iol_schema}.ncbs_tb_gl_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_tb_gl_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_gl_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_tb_gl_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_tb_gl_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_tb_gl_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.term is '存期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_tb_gl_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_gl_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_tb_gl_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_tb_gl_hist.gl_seq_no is '总账序号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_tb_gl_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_tb_gl_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_tb_gl_hist.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.send_system is '转发系统';
comment on column ${iol_schema}.ncbs_tb_gl_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_tb_gl_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_tb_gl_hist.un_real is '虚拟标志';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tax_percent is '纳税比率';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_tb_gl_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_tb_gl_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_gl_hist.acct_internal_key is '账号键值';
comment on column ${iol_schema}.ncbs_tb_gl_hist.busi_prod is '业务产品';
comment on column ${iol_schema}.ncbs_tb_gl_hist.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_tb_gl_hist.oth_amount is '其他对手金额';
comment on column ${iol_schema}.ncbs_tb_gl_hist.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_tb_gl_hist.subject_code is '银行科目代码';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_tb_gl_hist.trade_no is '交易流水识别号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.flat_rate is '平盘汇率';
comment on column ${iol_schema}.ncbs_tb_gl_hist.cust_rate is '对客汇率';
comment on column ${iol_schema}.ncbs_tb_gl_hist.settle_mode is '清算模式(流水上送)';
comment on column ${iol_schema}.ncbs_tb_gl_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.balance_change_type is '余额变化类型';
comment on column ${iol_schema}.ncbs_tb_gl_hist.deal_flag is '处理标识';
comment on column ${iol_schema}.ncbs_tb_gl_hist.rule_no is '规则编号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_gl_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_gl_hist.etl_timestamp is 'ETL处理时间戳';
