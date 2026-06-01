/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fee_amortize_agr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fee_amortize_agr
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fee_amortize_agr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fee_amortize_agr(
    client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,amortize_month varchar2(2) -- 摊销月
    ,amortize_name varchar2(50) -- 摊销名称
    ,amortize_status varchar2(1) -- 摊销状态
    ,amortize_time_type varchar2(1) -- 摊销时间类型
    ,amortize_total_cnt number(5) -- 摊销总次数
    ,amortized_cnt number(5) -- 已摊销次数
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,busi_no varchar2(50) -- 业务编码
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,charge_mode varchar2(1) -- 收取标志
    ,company varchar2(20) -- 法人
    ,fee_type varchar2(20) -- 费率类型
    ,osd_seq_no varchar2(50) -- 应收费用序号
    ,remain_amortize_cnt number(5) -- 剩余摊销次数
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,effect_date date -- 产品生效日期
    ,end_date date -- 结束日期
    ,last_amortize_date date -- 上一摊销日期
    ,next_amortize_date date -- 下一摊销日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,amortize_ccy varchar2(3) -- 摊销币种
    ,amortize_day varchar2(2) -- 摊销日
    ,amortize_period_type varchar2(1) -- 摊销期限类型
    ,amortize_total_amt number(17,2) -- 摊销总金额
    ,amortized_amt number(17,2) -- 已摊销金额
    ,auth_user_id varchar2(8) -- 授权柜员
    ,remain_amortize_amt number(17,2) -- 剩余摊销金额
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_branch varchar2(12) -- 冲正机构
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_rb_fee_amortize_agr to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fee_amortize_agr to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fee_amortize_agr to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fee_amortize_agr to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fee_amortize_agr is '摊销合约表';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_month is '摊销月';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_name is '摊销名称';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_status is '摊销状态';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_time_type is '摊销时间类型';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_total_cnt is '摊销总次数';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortized_cnt is '已摊销次数';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.busi_no is '业务编码';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.charge_mode is '收取标志';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.osd_seq_no is '应收费用序号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.remain_amortize_cnt is '剩余摊销次数';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.last_amortize_date is '上一摊销日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.next_amortize_date is '下一摊销日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_ccy is '摊销币种';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_day is '摊销日';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_period_type is '摊销期限类型';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortize_total_amt is '摊销总金额';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.amortized_amt is '已摊销金额';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.remain_amortize_amt is '剩余摊销金额';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reversal_branch is '冲正机构';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fee_amortize_agr.etl_timestamp is 'ETL处理时间戳';
