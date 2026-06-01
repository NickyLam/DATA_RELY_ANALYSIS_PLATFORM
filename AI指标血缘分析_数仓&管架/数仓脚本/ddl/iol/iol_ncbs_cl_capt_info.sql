/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_capt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_capt_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_capt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_capt_info(
    branch varchar2(12) -- 机构编号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,days number(5) -- 天数
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,company varchar2(20) -- 法人
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,reversal varchar2(1) -- 是否冲正标志
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tax_type varchar2(2) -- 税种
    ,tran_source varchar2(1) -- 交易发起方
    ,tran_status varchar2(1) -- 冲补抹标志
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,capt_date date -- 结息日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,float_rate number(15,8) -- 浮动利率
    ,int_accrued number(17,2) -- 累计计提
    ,int_adj number(17,2) -- 利息调增金额
    ,int_amt number(17,2) -- 利息金额
    ,int_posted number(17,2) -- 结息金额
    ,int_posted_ctd number(17,2) -- 结息日利息金额
    ,loan_no varchar2(50) -- 贷款号
    ,pay_int number(17,2) -- 前付息金额
    ,real_rate number(15,8) -- 执行利率
    ,tax_posted number(17,2) -- 利息税累计金额
    ,tax_posted_ctd number(17,2) -- 结息日利息税
    ,tax_rate number(15,8) -- 税率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_capt_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_capt_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_capt_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_capt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_capt_info is '核心结息信息表';
comment on column ${iol_schema}.ncbs_cl_capt_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_capt_info.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_capt_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_capt_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_capt_info.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_capt_info.days is '天数';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_cl_capt_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_capt_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_capt_info.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_capt_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_capt_info.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_capt_info.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_cl_capt_info.company is '法人';
comment on column ${iol_schema}.ncbs_cl_capt_info.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_capt_info.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_capt_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_capt_info.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_capt_info.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_capt_info.tax_type is '税种';
comment on column ${iol_schema}.ncbs_cl_capt_info.tran_source is '交易发起方';
comment on column ${iol_schema}.ncbs_cl_capt_info.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_capt_info.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_capt_info.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_capt_info.capt_date is '结息日期';
comment on column ${iol_schema}.ncbs_cl_capt_info.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_capt_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_capt_info.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_cl_capt_info.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_capt_info.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_capt_info.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_cl_capt_info.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_cl_capt_info.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_cl_capt_info.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_cl_capt_info.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.int_posted_ctd is '结息日利息金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_capt_info.pay_int is '前付息金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_cl_capt_info.tax_posted is '利息税累计金额';
comment on column ${iol_schema}.ncbs_cl_capt_info.tax_posted_ctd is '结息日利息税';
comment on column ${iol_schema}.ncbs_cl_capt_info.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_cl_capt_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_capt_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_capt_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_capt_info.etl_timestamp is 'ETL处理时间戳';
