/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tfintranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tfintranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tfintranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tfintranlist(
    mainseq varchar2(24) -- 中台流水号
    ,sysid varchar2(6) -- 系统标识
    ,transdt varchar2(12) -- 交易日期
    ,transtime varchar2(21) -- 交易时间
    ,businesstrace varchar2(24) -- 行内业务序号
    ,businessno varchar2(24) -- 业务序号
    ,cmtno varchar2(30) -- 报文编号（报文类型）
    ,hosttrcd varchar2(30) -- 主机交易码
    ,fronttrcd varchar2(23) -- 中台交易码
    ,magebrn varchar2(9) -- 管理机构
    ,userid varchar2(15) -- 柜员
    ,status varchar2(3) -- 状态
    ,hostdate varchar2(12) -- 主机日期
    ,hostnbr varchar2(96) -- 主机流水
    ,payacct varchar2(53) -- 付款人账号
    ,payname varchar2(180) -- 付款人名称
    ,incoacct varchar2(53) -- 收款人账号
    ,inconame varchar2(180) -- 收款人名称
    ,dataid varchar2(105) -- 第三方标识号
    ,errcode varchar2(30) -- 返回代码
    ,errms varchar2(450) -- 返回信息
    ,colsts varchar2(2) -- 对账状态
    ,transamt varchar2(29) -- 交易金额
    ,abscde varchar2(15) -- 记账分录
    ,colldt varchar2(12) -- 对账日期
    ,eaccflg varchar2(3) -- 电子账户标志
    ,transeqno varchar2(105) -- 交易流水号
    ,globalseqno varchar2(96) -- 全局流水号
    ,orgdataid varchar2(98) -- 原记账流水
    ,trntp varchar2(2) -- 交易类型
    ,chnid varchar2(15) -- 渠道id
    ,revreason varchar2(750) -- 冲账原因
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
grant select on ${iol_schema}.mpcs_a08tfintranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tfintranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tfintranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tfintranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tfintranlist is '';
comment on column ${iol_schema}.mpcs_a08tfintranlist.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.sysid is '系统标识';
comment on column ${iol_schema}.mpcs_a08tfintranlist.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a08tfintranlist.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a08tfintranlist.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.businessno is '业务序号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.cmtno is '报文编号（报文类型）';
comment on column ${iol_schema}.mpcs_a08tfintranlist.hosttrcd is '主机交易码';
comment on column ${iol_schema}.mpcs_a08tfintranlist.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a08tfintranlist.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a08tfintranlist.userid is '柜员';
comment on column ${iol_schema}.mpcs_a08tfintranlist.status is '状态';
comment on column ${iol_schema}.mpcs_a08tfintranlist.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a08tfintranlist.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a08tfintranlist.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a08tfintranlist.incoacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a08tfintranlist.dataid is '第三方标识号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.errcode is '返回代码';
comment on column ${iol_schema}.mpcs_a08tfintranlist.errms is '返回信息';
comment on column ${iol_schema}.mpcs_a08tfintranlist.colsts is '对账状态';
comment on column ${iol_schema}.mpcs_a08tfintranlist.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a08tfintranlist.abscde is '记账分录';
comment on column ${iol_schema}.mpcs_a08tfintranlist.colldt is '对账日期';
comment on column ${iol_schema}.mpcs_a08tfintranlist.eaccflg is '电子账户标志';
comment on column ${iol_schema}.mpcs_a08tfintranlist.transeqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a08tfintranlist.orgdataid is '原记账流水';
comment on column ${iol_schema}.mpcs_a08tfintranlist.trntp is '交易类型';
comment on column ${iol_schema}.mpcs_a08tfintranlist.chnid is '渠道id';
comment on column ${iol_schema}.mpcs_a08tfintranlist.revreason is '冲账原因';
comment on column ${iol_schema}.mpcs_a08tfintranlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tfintranlist.etl_timestamp is 'ETL处理时间戳';
