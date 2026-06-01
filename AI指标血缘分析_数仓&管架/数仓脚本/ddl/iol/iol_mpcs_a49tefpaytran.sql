/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefpaytran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefpaytran
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefpaytran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefpaytran(
    trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水号
    ,trantm varchar2(9) -- 交易时间
    ,txntype varchar2(9) -- 交易类型细分
    ,iotype varchar2(2) -- 渠道
    ,transt varchar2(2) -- 交易状态
    ,magbrn varchar2(15) -- 管理机构
    ,colldate varchar2(12) -- 对账日期
    ,hostdt varchar2(12) -- 主机日期
    ,hostsq varchar2(30) -- 主机流水号
    ,colldt varchar2(12) -- 冲正日期
    ,collsq varchar2(30) -- 冲正流水
    ,msgcode varchar2(12) -- 响应码
    ,msgtext varchar2(150) -- 响应描述
    ,priority varchar2(2) -- 优先级
    ,sysid varchar2(6) -- 发起方系统号
    ,sndzone varchar2(6) -- 发起地区代码
    ,rcvzone varchar2(6) -- 接收地区代码
    ,msgno varchar2(9) -- 报文编号
    ,msgid varchar2(30) -- 信息序号
    ,origmsgid varchar2(30) -- 原信息序号
    ,macflag varchar2(2) -- 编核押标志
    ,entrustdate varchar2(12) -- 委托日期
    ,vouchno varchar2(24) -- 凭证提交号
    ,trantp varchar2(3) -- 交易类型
    ,currencycd varchar2(5) -- 交易货币
    ,amount number(18,2) -- 交易金额
    ,feeamt number(18,2) -- 手续费
    ,postam number(18,2) -- 邮电费
    ,handam number(18,2) -- 工本费
    ,sendbank varchar2(18) -- 发起行行号/代理行
    ,payerbank varchar2(18) -- 付款行行号
    ,payeraccbank varchar2(18) -- 付款人开户行行号
    ,payeracc varchar2(53) -- 付款人账号
    ,payername varchar2(120) -- 付款人名称
    ,acctbr varchar2(15) -- 付款账号开户行
    ,payeebank varchar2(18) -- 收款行行号
    ,payeeaccbank varchar2(18) -- 收款人开户行行号
    ,payeeacc varchar2(53) -- 收款人账号
    ,payeename varchar2(120) -- 收款人名称
    ,oprchl varchar2(6) -- 业务渠道
    ,billid varchar2(30) -- 缴费标识号
    ,oprtype varchar2(8) -- 业务类型
    ,paytype varchar2(8) -- 缴费类型
    ,payterm varchar2(12) -- 查询缴费期
    ,userno varchar2(30) -- 用户编号
    ,txnid varchar2(30) -- 中心受理号
    ,txndate varchar2(12) -- 清算日期
    ,txnround varchar2(3) -- 清算场次
    ,retcd varchar2(12) -- 返回码
    ,remark varchar2(450) -- 附言
    ,prtmsg varchar2(1499) -- 打印信息
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
grant select on ${iol_schema}.mpcs_a49tefpaytran to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefpaytran to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefpaytran to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefpaytran to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefpaytran is '代理业务缴费业务登记薄';
comment on column ${iol_schema}.mpcs_a49tefpaytran.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.transq is '交易流水号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.trantm is '交易时间';
comment on column ${iol_schema}.mpcs_a49tefpaytran.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49tefpaytran.iotype is '渠道';
comment on column ${iol_schema}.mpcs_a49tefpaytran.transt is '交易状态';
comment on column ${iol_schema}.mpcs_a49tefpaytran.magbrn is '管理机构';
comment on column ${iol_schema}.mpcs_a49tefpaytran.colldate is '对账日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.hostsq is '主机流水号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.colldt is '冲正日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.collsq is '冲正流水';
comment on column ${iol_schema}.mpcs_a49tefpaytran.msgcode is '响应码';
comment on column ${iol_schema}.mpcs_a49tefpaytran.msgtext is '响应描述';
comment on column ${iol_schema}.mpcs_a49tefpaytran.priority is '优先级';
comment on column ${iol_schema}.mpcs_a49tefpaytran.sysid is '发起方系统号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.sndzone is '发起地区代码';
comment on column ${iol_schema}.mpcs_a49tefpaytran.rcvzone is '接收地区代码';
comment on column ${iol_schema}.mpcs_a49tefpaytran.msgno is '报文编号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.msgid is '信息序号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.origmsgid is '原信息序号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.macflag is '编核押标志';
comment on column ${iol_schema}.mpcs_a49tefpaytran.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.vouchno is '凭证提交号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.trantp is '交易类型';
comment on column ${iol_schema}.mpcs_a49tefpaytran.currencycd is '交易货币';
comment on column ${iol_schema}.mpcs_a49tefpaytran.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a49tefpaytran.feeamt is '手续费';
comment on column ${iol_schema}.mpcs_a49tefpaytran.postam is '邮电费';
comment on column ${iol_schema}.mpcs_a49tefpaytran.handam is '工本费';
comment on column ${iol_schema}.mpcs_a49tefpaytran.sendbank is '发起行行号/代理行';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payerbank is '付款行行号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeraccbank is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeracc is '付款人账号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payername is '付款人名称';
comment on column ${iol_schema}.mpcs_a49tefpaytran.acctbr is '付款账号开户行';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeebank is '收款行行号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeeaccbank is '收款人开户行行号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeeacc is '收款人账号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payeename is '收款人名称';
comment on column ${iol_schema}.mpcs_a49tefpaytran.oprchl is '业务渠道';
comment on column ${iol_schema}.mpcs_a49tefpaytran.billid is '缴费标识号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.oprtype is '业务类型';
comment on column ${iol_schema}.mpcs_a49tefpaytran.paytype is '缴费类型';
comment on column ${iol_schema}.mpcs_a49tefpaytran.payterm is '查询缴费期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.userno is '用户编号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.txnid is '中心受理号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.txndate is '清算日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.txnround is '清算场次';
comment on column ${iol_schema}.mpcs_a49tefpaytran.retcd is '返回码';
comment on column ${iol_schema}.mpcs_a49tefpaytran.remark is '附言';
comment on column ${iol_schema}.mpcs_a49tefpaytran.prtmsg is '打印信息';
comment on column ${iol_schema}.mpcs_a49tefpaytran.brchno is '营业点';
comment on column ${iol_schema}.mpcs_a49tefpaytran.userid is '柜员号';
comment on column ${iol_schema}.mpcs_a49tefpaytran.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a49tefpaytran.ckbkbr is '授权网点';
comment on column ${iol_schema}.mpcs_a49tefpaytran.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a49tefpaytran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefpaytran.etl_timestamp is 'ETL处理时间戳';
