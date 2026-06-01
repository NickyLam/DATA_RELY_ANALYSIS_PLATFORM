/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_journal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_journal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_journal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_journal(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_status varchar2(3) -- 凭证状态
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,move_id varchar2(30) -- 调拨转移id
    ,move_type varchar2(3) -- 转移类型
    ,old_status varchar2(3) -- 凭证原状态
    ,prefix varchar2(10) -- 前缀
    ,program_id varchar2(20) -- 交易代码
    ,reserve_flag varchar2(1) -- 冲正标志
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_desc varchar2(200) -- 交易描述
    ,voucher_num number(6) -- 凭证数量
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_tb_voucher_journal to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_journal to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_journal to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_journal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_journal is '尾箱凭证更新流水表';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.move_type is '转移类型';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.old_status is '凭证原状态';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.source_module is '源模块';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.voucher_num is '凭证数量';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.journal_id is '流水单号';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.tailbox_user_id is '尾箱挂接柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_voucher_journal.etl_timestamp is 'ETL处理时间戳';
