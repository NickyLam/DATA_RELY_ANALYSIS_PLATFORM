/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1stfintranlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1stfintranlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1stfintranlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1stfintranlist(
    syscd varchar2(6) -- 系统码
    ,mainseq varchar2(24) -- 中台流水
    ,transdt varchar2(12) -- 中台日期
    ,transtm varchar2(14) -- 中台时间
    ,businesstrace varchar2(24) -- 行内业务序号
    ,pckno varchar2(30) -- 报文类型
    ,hosttrcd varchar2(30) -- 金融交易码
    ,fronttrcd varchar2(23) -- 中台交易码
    ,magebrn varchar2(9) -- 管理机构
    ,brcno varchar2(9) -- 交易机构
    ,userid varchar2(15) -- 柜员
    ,trntp varchar2(3) -- 交易类型:1-记账，2-冲账
    ,status varchar2(3) -- 状态:1-成功，E-失败
    ,hostdate varchar2(12) -- 金融交易日期
    ,hostnbr varchar2(96) -- 金融交易流水
    ,payacct varchar2(1500) -- 付款人账号
    ,payname varchar2(1500) -- 付款人名称
    ,incoacct varchar2(1500) -- 收款人账号
    ,inconame varchar2(1500) -- 收款人名称
    ,dataid varchar2(96) -- 支付流水号
    ,orgdataid varchar2(96) -- 原支付流水号
    ,errcode varchar2(30) -- 返回代码
    ,errms varchar2(450) -- 返回信息
    ,transamt varchar2(29) -- 交易金额
    ,abscde varchar2(15) -- 记账分录
    ,colldt varchar2(12) -- 对账日期
    ,colsts varchar2(2) -- 对账状态
    ,batchid varchar2(20) -- 交易批次号
    ,changtime varchar2(21) -- 更新时间
    ,globalseqno varchar2(96) -- 全局流水号
    ,chnid varchar2(15) -- 渠道编号
    ,revreason varchar2(750) -- 冲正原因
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
grant select on ${iol_schema}.mpcs_a1stfintranlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1stfintranlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1stfintranlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1stfintranlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1stfintranlist is '数字货币金融流水表';
comment on column ${iol_schema}.mpcs_a1stfintranlist.syscd is '系统码';
comment on column ${iol_schema}.mpcs_a1stfintranlist.mainseq is '中台流水';
comment on column ${iol_schema}.mpcs_a1stfintranlist.transdt is '中台日期';
comment on column ${iol_schema}.mpcs_a1stfintranlist.transtm is '中台时间';
comment on column ${iol_schema}.mpcs_a1stfintranlist.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a1stfintranlist.hosttrcd is '金融交易码';
comment on column ${iol_schema}.mpcs_a1stfintranlist.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a1stfintranlist.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a1stfintranlist.brcno is '交易机构';
comment on column ${iol_schema}.mpcs_a1stfintranlist.userid is '柜员';
comment on column ${iol_schema}.mpcs_a1stfintranlist.trntp is '交易类型:1-记账，2-冲账';
comment on column ${iol_schema}.mpcs_a1stfintranlist.status is '状态:1-成功，E-失败';
comment on column ${iol_schema}.mpcs_a1stfintranlist.hostdate is '金融交易日期';
comment on column ${iol_schema}.mpcs_a1stfintranlist.hostnbr is '金融交易流水';
comment on column ${iol_schema}.mpcs_a1stfintranlist.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a1stfintranlist.incoacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a1stfintranlist.dataid is '支付流水号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.orgdataid is '原支付流水号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.errcode is '返回代码';
comment on column ${iol_schema}.mpcs_a1stfintranlist.errms is '返回信息';
comment on column ${iol_schema}.mpcs_a1stfintranlist.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a1stfintranlist.abscde is '记账分录';
comment on column ${iol_schema}.mpcs_a1stfintranlist.colldt is '对账日期';
comment on column ${iol_schema}.mpcs_a1stfintranlist.colsts is '对账状态';
comment on column ${iol_schema}.mpcs_a1stfintranlist.batchid is '交易批次号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.changtime is '更新时间';
comment on column ${iol_schema}.mpcs_a1stfintranlist.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.chnid is '渠道编号';
comment on column ${iol_schema}.mpcs_a1stfintranlist.revreason is '冲正原因';
comment on column ${iol_schema}.mpcs_a1stfintranlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1stfintranlist.etl_timestamp is 'ETL处理时间戳';
