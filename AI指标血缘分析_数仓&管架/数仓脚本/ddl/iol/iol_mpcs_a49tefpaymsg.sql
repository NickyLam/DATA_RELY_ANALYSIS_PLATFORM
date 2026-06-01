/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefpaymsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefpaymsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefpaymsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefpaymsg(
    trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水号
    ,trantm varchar2(9) -- 交易时间
    ,iotype varchar2(2) -- 渠道
    ,transt varchar2(2) -- 交易状态
    ,priority varchar2(2) -- 优先级
    ,sysid varchar2(6) -- 发起方系统号
    ,sndzone varchar2(6) -- 发起地区代码
    ,rcvzone varchar2(6) -- 接收地区代码
    ,msgno varchar2(9) -- 报文编号
    ,msgid varchar2(30) -- 信息序号
    ,origmsgid varchar2(30) -- 原信息序号
    ,macflag varchar2(2) -- 编核押标志
    ,txntype varchar2(9) -- 交易类型细分
    ,entrustdate varchar2(12) -- 委托日期
    ,sendbank varchar2(18) -- 发起行行号/机构号
    ,recvbank varchar2(18) -- 接收行行号/机构号
    ,oprchl varchar2(6) -- 业务渠道
    ,oprtype varchar2(8) -- 业务类型
    ,paytype varchar2(5) -- 缴费类型
    ,payterm varchar2(12) -- 查询缴费期
    ,userno varchar2(27) -- 用户编号
    ,remark varchar2(450) -- 请求附言
    ,billid varchar2(30) -- 缴费标识号
    ,currencycd varchar2(5) -- 缴费货币
    ,billamount number(18,2) -- 缴费金额
    ,bill varchar2(1499) -- 账单明细
    ,retcd varchar2(12) -- 返回码
    ,rspinfo varchar2(450) -- 附言
    ,brchno varchar2(15) -- 营业点
    ,userid varchar2(15) -- 柜员号
    ,ckbkus varchar2(15) -- 授权柜员
    ,ckbkbr varchar2(15) -- 授权网点
    ,linkid number(22) -- 链路id
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
grant select on ${iol_schema}.mpcs_a49tefpaymsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefpaymsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefpaymsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefpaymsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefpaymsg is '银行代理缴费查询登记簿';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.transq is '交易流水号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.trantm is '交易时间';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.iotype is '渠道';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.transt is '交易状态';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.priority is '优先级';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.sysid is '发起方系统号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.sndzone is '发起地区代码';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.rcvzone is '接收地区代码';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.msgno is '报文编号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.msgid is '信息序号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.origmsgid is '原信息序号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.macflag is '编核押标志';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.sendbank is '发起行行号/机构号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.recvbank is '接收行行号/机构号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.oprchl is '业务渠道';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.oprtype is '业务类型';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.paytype is '缴费类型';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.payterm is '查询缴费期';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.userno is '用户编号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.remark is '请求附言';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.billid is '缴费标识号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.currencycd is '缴费货币';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.billamount is '缴费金额';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.bill is '账单明细';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.retcd is '返回码';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.rspinfo is '附言';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.brchno is '营业点';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.userid is '柜员号';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.ckbkbr is '授权网点';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefpaymsg.etl_timestamp is 'ETL处理时间戳';
