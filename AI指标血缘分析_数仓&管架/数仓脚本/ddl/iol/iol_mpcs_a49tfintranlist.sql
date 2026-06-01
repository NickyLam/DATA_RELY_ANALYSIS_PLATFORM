/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tfintranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tfintranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tfintranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tfintranlist(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,sysid varchar2(6) -- 系统标识
    ,transtime varchar2(21) -- 交易时间
    ,unotnbr varchar2(15) -- 前置流水号
    ,unotdate varchar2(12) -- 前置日期
    ,hosttrcd varchar2(60) -- 核心交易码
    ,fronttrcd varchar2(15) -- 中台交易码
    ,magbrn varchar2(15) -- 处理机构
    ,userid varchar2(15) -- 处理柜员
    ,status varchar2(3) -- 状态
    ,hostdate varchar2(12) -- 核心日期
    ,hostnbr varchar2(105) -- 核心流水
    ,payacct varchar2(53) -- 付款账户
    ,payname varchar2(180) -- 付款账户名
    ,incoacct varchar2(53) -- 收款账户
    ,inconame varchar2(180) -- 收款账户名称
    ,dataid varchar2(60) -- 交易索引号
    ,errcode varchar2(30) -- 错误代码
    ,errms varchar2(450) -- 错误信息
    ,colsts varchar2(2) -- 对账状态
    ,transamt varchar2(29) -- 交易金额
    ,abscde varchar2(15) -- 记账分录
    ,colldate varchar2(12) -- 对账日期
    ,eaccflg varchar2(3) -- 电子账户标志
    ,transeqno varchar2(105) -- 交易流水号
    ,globalseqno varchar2(105) -- 全局流水号
    ,gtranseqno varchar2(105) -- 交易流水
    ,chn_id varchar2(15) -- 渠道码
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
grant select on ${iol_schema}.mpcs_a49tfintranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tfintranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tfintranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tfintranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tfintranlist is '金融交易流水登记簿';
comment on column ${iol_schema}.mpcs_a49tfintranlist.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a49tfintranlist.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a49tfintranlist.sysid is '系统标识';
comment on column ${iol_schema}.mpcs_a49tfintranlist.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a49tfintranlist.unotnbr is '前置流水号';
comment on column ${iol_schema}.mpcs_a49tfintranlist.unotdate is '前置日期';
comment on column ${iol_schema}.mpcs_a49tfintranlist.hosttrcd is '核心交易码';
comment on column ${iol_schema}.mpcs_a49tfintranlist.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a49tfintranlist.magbrn is '处理机构';
comment on column ${iol_schema}.mpcs_a49tfintranlist.userid is '处理柜员';
comment on column ${iol_schema}.mpcs_a49tfintranlist.status is '状态';
comment on column ${iol_schema}.mpcs_a49tfintranlist.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a49tfintranlist.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a49tfintranlist.payacct is '付款账户';
comment on column ${iol_schema}.mpcs_a49tfintranlist.payname is '付款账户名';
comment on column ${iol_schema}.mpcs_a49tfintranlist.incoacct is '收款账户';
comment on column ${iol_schema}.mpcs_a49tfintranlist.inconame is '收款账户名称';
comment on column ${iol_schema}.mpcs_a49tfintranlist.dataid is '交易索引号';
comment on column ${iol_schema}.mpcs_a49tfintranlist.errcode is '错误代码';
comment on column ${iol_schema}.mpcs_a49tfintranlist.errms is '错误信息';
comment on column ${iol_schema}.mpcs_a49tfintranlist.colsts is '对账状态';
comment on column ${iol_schema}.mpcs_a49tfintranlist.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a49tfintranlist.abscde is '记账分录';
comment on column ${iol_schema}.mpcs_a49tfintranlist.colldate is '对账日期';
comment on column ${iol_schema}.mpcs_a49tfintranlist.eaccflg is '电子账户标志';
comment on column ${iol_schema}.mpcs_a49tfintranlist.transeqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a49tfintranlist.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a49tfintranlist.gtranseqno is '交易流水';
comment on column ${iol_schema}.mpcs_a49tfintranlist.chn_id is '渠道码';
comment on column ${iol_schema}.mpcs_a49tfintranlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tfintranlist.etl_timestamp is 'ETL处理时间戳';
