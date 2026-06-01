/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a01tbattranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a01tbattranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a01tbattranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a01tbattranlist(
    trntype varchar2(3) -- 交易类型
    ,trnseqno varchar2(96) -- 交易流水号
    ,fntdt varchar2(12) -- 前置日期
    ,fntseqno varchar2(12) -- 前置流水
    ,filename varchar2(48) -- 文件名
    ,custno varchar2(15) -- 客户编号
    ,payacctno varchar2(48) -- 付款账户
    ,payacctname varchar2(384) -- 付款账户名
    ,rcvacctno varchar2(48) -- 收款账户
    ,rcvacctname varchar2(256) -- 收款账户名
    ,ccy varchar2(5) -- 币种
    ,trnamt varchar2(23) -- 交易金额
    ,trndtts varchar2(21) -- 交易时间
    ,hostdt varchar2(15) -- 主机日期
    ,hostseqno varchar2(96) -- 主机流水
    ,trnresult varchar2(9) -- 交易结果
    ,chkflag varchar2(2) -- 标识
    ,chkdtts varchar2(21) -- 时间
    ,revhflag varchar2(2) -- 标识
    ,revhostdt varchar2(15) -- 日期
    ,revhostseqno varchar2(96) -- 流水
    ,reserve varchar2(192) -- 备注
    ,inneracno varchar2(30) -- 过渡内部户账号
    ,inneracna varchar2(384) -- 过渡内部户户名
    ,unique_seq_num varchar2(96) -- 业务流水号
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
grant select on ${iol_schema}.mpcs_a01tbattranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a01tbattranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a01tbattranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a01tbattranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a01tbattranlist is '批次流水表';
comment on column ${iol_schema}.mpcs_a01tbattranlist.trntype is '交易类型';
comment on column ${iol_schema}.mpcs_a01tbattranlist.trnseqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a01tbattranlist.fntdt is '前置日期';
comment on column ${iol_schema}.mpcs_a01tbattranlist.fntseqno is '前置流水';
comment on column ${iol_schema}.mpcs_a01tbattranlist.filename is '文件名';
comment on column ${iol_schema}.mpcs_a01tbattranlist.custno is '客户编号';
comment on column ${iol_schema}.mpcs_a01tbattranlist.payacctno is '付款账户';
comment on column ${iol_schema}.mpcs_a01tbattranlist.payacctname is '付款账户名';
comment on column ${iol_schema}.mpcs_a01tbattranlist.rcvacctno is '收款账户';
comment on column ${iol_schema}.mpcs_a01tbattranlist.rcvacctname is '收款账户名';
comment on column ${iol_schema}.mpcs_a01tbattranlist.ccy is '币种';
comment on column ${iol_schema}.mpcs_a01tbattranlist.trnamt is '交易金额';
comment on column ${iol_schema}.mpcs_a01tbattranlist.trndtts is '交易时间';
comment on column ${iol_schema}.mpcs_a01tbattranlist.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a01tbattranlist.hostseqno is '主机流水';
comment on column ${iol_schema}.mpcs_a01tbattranlist.trnresult is '交易结果';
comment on column ${iol_schema}.mpcs_a01tbattranlist.chkflag is '标识';
comment on column ${iol_schema}.mpcs_a01tbattranlist.chkdtts is '时间';
comment on column ${iol_schema}.mpcs_a01tbattranlist.revhflag is '标识';
comment on column ${iol_schema}.mpcs_a01tbattranlist.revhostdt is '日期';
comment on column ${iol_schema}.mpcs_a01tbattranlist.revhostseqno is '流水';
comment on column ${iol_schema}.mpcs_a01tbattranlist.reserve is '备注';
comment on column ${iol_schema}.mpcs_a01tbattranlist.inneracno is '过渡内部户账号';
comment on column ${iol_schema}.mpcs_a01tbattranlist.inneracna is '过渡内部户户名';
comment on column ${iol_schema}.mpcs_a01tbattranlist.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a01tbattranlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a01tbattranlist.etl_timestamp is 'ETL处理时间戳';
