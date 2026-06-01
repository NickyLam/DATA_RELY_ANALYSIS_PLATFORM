/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ztljtsfxqmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ztljtsfxqmx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ztljtsfxqmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ztljtsfxqmx(
    transdt varchar2(18) -- 中台交易日期
    ,transtm varchar2(18) -- 中台交易时间
    ,mainseq varchar2(48) -- 中台交易流水
    ,chnlid varchar2(6) -- 交易渠道:1.柜面转账；2.微信内部户；3.支付宝内部户 4.行外 5.行内
    ,base_acct_no varchar2(96) -- 主账户号(内部户)
    ,base_acct_name varchar2(768) -- 主账号名称(内部户名称)
    ,tran_amt varchar2(48) -- 核心交易金额
    ,pay_acct varchar2(96) -- 付款账户
    ,pay_name varchar2(768) -- 付款账户名
    ,recv_acct varchar2(96) -- 收款账户
    ,recv_name varchar2(768) -- 收款账户名
    ,inhostdt varchar2(18) -- 收入的核心日期
    ,inhosttm varchar2(18) -- 收入的核心时间
    ,inhostseqno varchar2(192) -- 收入的核心流水
    ,inhostseqnosub varchar2(48) -- 收入的核心子流水
    ,outhostdt varchar2(18) -- 支出的核心日期
    ,outhosttm varchar2(18) -- 支出的核心时间
    ,outhostseqno varchar2(192) -- 支出的核心流水
    ,outhostseqnosub varchar2(48) -- 支出的核心子流水
    ,remark varchar2(192) -- 备注
    ,remark1 varchar2(384) -- 备注1
    ,remark2 varchar2(768) -- 备注2
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
grant select on ${iol_schema}.mpcs_a1ztljtsfxqmx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ztljtsfxqmx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ztljtsfxqmx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ztljtsfxqmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ztljtsfxqmx is '离境退税反洗钱明细表';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.transdt is '中台交易日期';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.transtm is '中台交易时间';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.mainseq is '中台交易流水';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.chnlid is '交易渠道:1.柜面转账；2.微信内部户；3.支付宝内部户 4.行外 5.行内';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.base_acct_no is '主账户号(内部户)';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.base_acct_name is '主账号名称(内部户名称)';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.tran_amt is '核心交易金额';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.pay_acct is '付款账户';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.pay_name is '付款账户名';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.recv_acct is '收款账户';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.recv_name is '收款账户名';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.inhostdt is '收入的核心日期';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.inhosttm is '收入的核心时间';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.inhostseqno is '收入的核心流水';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.inhostseqnosub is '收入的核心子流水';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.outhostdt is '支出的核心日期';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.outhosttm is '支出的核心时间';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.outhostseqno is '支出的核心流水';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.outhostseqnosub is '支出的核心子流水';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.remark is '备注';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.remark1 is '备注1';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.remark2 is '备注2';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ztljtsfxqmx.etl_timestamp is 'ETL处理时间戳';
