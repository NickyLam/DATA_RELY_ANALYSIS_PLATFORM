/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_journal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_journal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_journal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_journal(
    ccy varchar2(3) -- 币种
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,cash_num number(10) -- 现金数量
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,move_id varchar2(30) -- 调拨转移id
    ,move_type varchar2(3) -- 转移类型
    ,par_value_id varchar2(20) -- 券别代码
    ,pay_rec varchar2(1) -- 收付标志
    ,program_id varchar2(20) -- 交易代码
    ,reserve_flag varchar2(1) -- 冲正标志
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,journal_id varchar2(50) -- 流水单号
    ,tailbox_user_id varchar2(8) -- 尾箱挂接柜员
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
grant select on ${iol_schema}.ncbs_tb_cash_journal to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_journal to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_journal to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_journal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_journal is '尾箱现金更新流水表';
comment on column ${iol_schema}.ncbs_tb_cash_journal.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_journal.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_cash_journal.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.cash_num is '现金数量';
comment on column ${iol_schema}.ncbs_tb_cash_journal.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_journal.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_cash_journal.move_type is '转移类型';
comment on column ${iol_schema}.ncbs_tb_cash_journal.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_cash_journal.pay_rec is '收付标志';
comment on column ${iol_schema}.ncbs_tb_cash_journal.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_tb_cash_journal.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_cash_journal.source_module is '源模块';
comment on column ${iol_schema}.ncbs_tb_cash_journal.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_journal.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.journal_id is '流水单号';
comment on column ${iol_schema}.ncbs_tb_cash_journal.tailbox_user_id is '尾箱挂接柜员';
comment on column ${iol_schema}.ncbs_tb_cash_journal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_cash_journal.etl_timestamp is 'ETL处理时间戳';
