/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tfintranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tfintranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tfintranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tfintranlist(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,transtime varchar2(21) -- 交易时间
    ,businesstrace varchar2(24) -- 行内业务序号
    ,transamt varchar2(26) -- 交易金额
    ,pckno varchar2(30) -- 报文编号（报文类型）
    ,hosttrcd varchar2(30) -- 主机交易码
    ,fronttrcd varchar2(23) -- 中台交易码
    ,magebrn varchar2(9) -- 管理机构
    ,userid varchar2(12) -- 柜员
    ,status varchar2(3) -- 状态
    ,hostdate varchar2(12) -- 主机日期
    ,hostnbr varchar2(60) -- 主机流水
    ,payacct varchar2(53) -- 付款人账号
    ,payname varchar2(180) -- 付款人名称
    ,rcvacct varchar2(53) -- 收款人账号
    ,rcvname varchar2(180) -- 收款人名称
    ,dataid varchar2(96) -- 第三方标识号
    ,errcode varchar2(23) -- 返回代码
    ,errms varchar2(600) -- 返回信息
    ,colsts varchar2(2) -- 对账状态
    ,abscde varchar2(15) -- 会计分录码
    ,colldt varchar2(12) -- 对账日期
    ,upporderid varchar2(60) -- upp返回订单标识
    ,chn_id varchar2(15) -- 渠道号
    ,globseq varchar2(50) -- 全局流水号
    ,uniqueseq varchar2(50) -- 业务流水号
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
grant select on ${iol_schema}.mpcs_a68tfintranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tfintranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tfintranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tfintranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tfintranlist is '金融交易流水表';
comment on column ${iol_schema}.mpcs_a68tfintranlist.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a68tfintranlist.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a68tfintranlist.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a68tfintranlist.pckno is '报文编号（报文类型）';
comment on column ${iol_schema}.mpcs_a68tfintranlist.hosttrcd is '主机交易码';
comment on column ${iol_schema}.mpcs_a68tfintranlist.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a68tfintranlist.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a68tfintranlist.userid is '柜员';
comment on column ${iol_schema}.mpcs_a68tfintranlist.status is '状态';
comment on column ${iol_schema}.mpcs_a68tfintranlist.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a68tfintranlist.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a68tfintranlist.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a68tfintranlist.rcvacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.rcvname is '收款人名称';
comment on column ${iol_schema}.mpcs_a68tfintranlist.dataid is '第三方标识号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.errcode is '返回代码';
comment on column ${iol_schema}.mpcs_a68tfintranlist.errms is '返回信息';
comment on column ${iol_schema}.mpcs_a68tfintranlist.colsts is '对账状态';
comment on column ${iol_schema}.mpcs_a68tfintranlist.abscde is '会计分录码';
comment on column ${iol_schema}.mpcs_a68tfintranlist.colldt is '对账日期';
comment on column ${iol_schema}.mpcs_a68tfintranlist.upporderid is 'upp返回订单标识';
comment on column ${iol_schema}.mpcs_a68tfintranlist.chn_id is '渠道号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.globseq is '全局流水号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.uniqueseq is '业务流水号';
comment on column ${iol_schema}.mpcs_a68tfintranlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tfintranlist.etl_timestamp is 'ETL处理时间戳';
