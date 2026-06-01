/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_manual_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_manual_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_manual_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_manual_tran_hist(
    business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,gl_code varchar2(20) -- 科目代码
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,gl_seq_no varchar2(50) -- 总账序号
    ,manual_status varchar2(1) -- 记账状态
    ,narrative varchar2(400) -- 摘要
    ,reversal varchar2(1) -- 是否冲正标志
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,post_date date -- 入账日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,value_date date -- 记账日期
    ,gl_branch varchar2(12) -- 总账机构
    ,gl_ccy varchar2(3) -- 总账币种
    ,gl_client_no varchar2(16) -- 总账客户号
    ,gl_profit_center varchar2(20) -- 总账利润中心
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_manual_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_manual_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_manual_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_manual_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_manual_tran_hist is '存款手工记账务表';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_seq_no is '总账序号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.manual_status is '记账状态';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.post_date is '入账日期';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.value_date is '记账日期';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_branch is '总账机构';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_ccy is '总账币种';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_client_no is '总账客户号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.gl_profit_center is '总账利润中心';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_manual_tran_hist.etl_timestamp is 'ETL处理时间戳';
