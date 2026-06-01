/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cent_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cent_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cent_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cent_reg(
    seq_no varchar2(50) -- 序号
    ,reference varchar2(50) -- 交易参考号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,orig_channel_seq_no varchar2(50) -- 原渠道流水号
    ,orig_sub_seq_no varchar2(50) -- 原渠道子流水号
    ,close_acct_ind varchar2(1) -- 销户标志
    ,cent_deal_type varchar2(1) -- 分位处理方式
    ,cent_amt number(17,2) -- 分位金额
    ,ccy varchar2(3) -- 币种
    ,amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,tran_date date -- 交易日期
    ,status varchar2(1) -- 状态
    ,tran_type varchar2(10) -- 交易类型
    ,event_type varchar2(20) -- 事件类型
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_seq_no varchar2(50) -- 冲正序号
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,reversal_tran_date date -- 冲正交易日期
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,wipe_account varchar2(1) -- 冲正和抹账标识
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,reversal_reason varchar2(200) -- 冲正原因
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,orig_tran_amt number(17,2) -- 原交易金额
    ,orig_tran_date date -- 原交易时间
    ,main_source_module varchar2(3) -- 主模块
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
grant select on ${iol_schema}.ncbs_rb_cent_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cent_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cent_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cent_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cent_reg is '分位金额处理登记簿';
comment on column ${iol_schema}.ncbs_rb_cent_reg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.orig_channel_seq_no is '原渠道流水号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.orig_sub_seq_no is '原渠道子流水号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.close_acct_ind is '销户标志';
comment on column ${iol_schema}.ncbs_rb_cent_reg.cent_deal_type is '分位处理方式';
comment on column ${iol_schema}.ncbs_rb_cent_reg.cent_amt is '分位金额';
comment on column ${iol_schema}.ncbs_rb_cent_reg.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_cent_reg.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_cent_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_cent_reg.status is '状态';
comment on column ${iol_schema}.ncbs_rb_cent_reg.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_cent_reg.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_seq_no is '冲正序号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_tran_date is '冲正交易日期';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_cent_reg.wipe_account is '冲正和抹账标识';
comment on column ${iol_schema}.ncbs_rb_cent_reg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cent_reg.reversal_reason is '冲正原因';
comment on column ${iol_schema}.ncbs_rb_cent_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cent_reg.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_cent_reg.orig_tran_amt is '原交易金额';
comment on column ${iol_schema}.ncbs_rb_cent_reg.orig_tran_date is '原交易时间';
comment on column ${iol_schema}.ncbs_rb_cent_reg.main_source_module is '主模块';
comment on column ${iol_schema}.ncbs_rb_cent_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cent_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cent_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cent_reg.etl_timestamp is 'ETL处理时间戳';
