/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1stdcpstrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1stdcpstrx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1stdcpstrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1stdcpstrx(
    syscd varchar2(6) -- 系统码
    ,mainseq varchar2(24) -- 中台流水
    ,transdt varchar2(12) -- 中台日期
    ,transtm varchar2(14) -- 中台时间
    ,pckno varchar2(30) -- 报文类型
    ,sndbrn varchar2(21) -- 发送行
    ,sndbrnlei varchar2(30) -- 发起机构LEI码
    ,rcvbrn varchar2(21) -- 接收行
    ,rcvbrnlei varchar2(30) -- 接收机构LEI码
    ,consigndt varchar2(12) -- 委托日期
    ,transseq varchar2(53) -- 报文标识号
    ,batchid varchar2(20) -- 交易批次号
    ,businesstrace varchar2(24) -- 行内业务序号
    ,fronttrcd varchar2(15) -- 中台交易码
    ,ccynbr varchar2(5) -- 币种
    ,transamt varchar2(29) -- 交易金额
    ,iotype varchar2(2) -- 往来标识:0-往，1-来
    ,cdflag varchar2(2) -- 借贷标记:D-借，C-贷
    ,feeflag varchar2(2) -- 手续费标志:0-无
    ,feeamt varchar2(26) -- 手续费用金额
    ,hosttrcd varchar2(30) -- 金融交易码
    ,hostdate varchar2(12) -- 金融交易日期
    ,hostnbr varchar2(96) -- 金融交易流水
    ,payopenbrn varchar2(21) -- 付款人开户行行号
    ,payopenbanknm varchar2(420) -- 付款人开户行名称
    ,payaccttp varchar2(6) -- 付款人账户类型
    ,payacct varchar2(1500) -- 付款人账号钱包
    ,payname varchar2(1500) -- 付款人名称
    ,incoopenbank varchar2(21) -- 收款人开户行行号
    ,incoopenbanknm varchar2(420) -- 收款人开户行名称
    ,incoaccttp varchar2(6) -- 收款人账户类型
    ,incoacct varchar2(1500) -- 收款人账号钱包
    ,inconame varchar2(1500) -- 收款人名称
    ,cdtrwltlvl varchar2(6) -- 钱包等级
    ,cdtrwlttp varchar2(6) -- 钱包类型
    ,cdtrwltnm varchar2(180) -- 钱包名称
    ,bustype varchar2(6) -- 业务类型
    ,servtype varchar2(12) -- 业务种类
    ,transaction varchar2(9) -- 交易用途\交易资金来源
    ,sgnno varchar2(51) -- 挂接协议号
    ,oraconsigndt varchar2(12) -- 原委托日期
    ,oratransseq varchar2(53) -- 原报文标识号
    ,orasndbrn varchar2(21) -- 原发起行
    ,orapckno varchar2(30) -- 原报文类型
    ,dsptrsncd varchar2(6) -- 差错原因码
    ,dsptrsndesc varchar2(192) -- 差错原因说明
    ,dsptamt varchar2(29) -- 调账金额
    ,oprbrn varchar2(9) -- 开户机构
    ,oprtlr varchar2(15) -- 交易柜员
    ,info varchar2(360) -- 附言
    ,note varchar2(420) -- 备注
    ,opnwin varchar2(12) -- 交易渠道
    ,msgno varchar2(60) -- 通信级标识号
    ,refmsgno varchar2(60) -- 通信级参考号
    ,errcode varchar2(30) -- 行里错误码
    ,errms varchar2(450) -- 行里错误信息
    ,rcvdt varchar2(21) -- 回执交易日期
    ,rcvtm varchar2(9) -- 回执交易时间
    ,msgid varchar2(53) -- 回执报文标识号
    ,msgtp varchar2(30) -- 回执报文类型
    ,prcsts varchar2(6) -- 业务状态
    ,prccd varchar2(15) -- 业务处理码
    ,processcode varchar2(6) -- 业务回执状态
    ,rejectcode varchar2(6) -- 业务拒绝码
    ,rejectinfo varchar2(315) -- 业务拒绝信息
    ,transmitdt varchar2(21) -- 业务处理时间
    ,chkprodstatus varchar2(3) -- 业务对账状态
    ,chkhoststatus varchar2(3) -- 金融对账状态
    ,status varchar2(3) -- 交易状态
    ,fill varchar2(768) -- 交易结果说明
    ,changtime varchar2(21) -- 更新时间
    ,magebrn varchar2(9) -- 管理机构
    ,accttp varchar2(30) -- 账户类型
    ,globalseqno varchar2(50) -- 全局流水号
    ,srcsysssn varchar2(96) -- 统一支付渠道流水号
    ,returncode varchar2(30) -- ESC接口返回码
    ,returnmsg varchar2(1536) -- ESC接口返回信息
    ,transseqno varchar2(96) -- ESC接口交易流水号
    ,finmainseq varchar2(24) -- 金融表中台流水
    ,fintransdt varchar2(12) -- 金融表中台日期
    ,recnt varchar2(8) -- 记账/冲正处理次数
    ,uniqueseqnum varchar2(50) -- 业务流水号
    ,procflag varchar2(2) -- 处理标志  1-处理中
    ,begintm varchar2(26) -- 交易开始时间
    ,endtm varchar2(26) -- 交易结束时间
    ,payresdttp varchar2(9) -- 付款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,payctrycode varchar2(5) -- 付款用户常驻国家/地区代码
    ,rcvresdttp varchar2(9) -- 收款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,rcvctrycode varchar2(5) -- 收款用户常驻国家/地区代码
    ,phnctrycode varchar2(5) -- 钱包注册手机号所在国家/地区代码
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
grant select on ${iol_schema}.mpcs_a1stdcpstrx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1stdcpstrx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1stdcpstrx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1stdcpstrx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1stdcpstrx is '数字货币业务流水表';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.syscd is '系统码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.mainseq is '中台流水';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transdt is '中台日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transtm is '中台时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.sndbrn is '发送行';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.sndbrnlei is '发起机构LEI码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvbrn is '接收行';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvbrnlei is '接收机构LEI码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.consigndt is '委托日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transseq is '报文标识号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.batchid is '交易批次号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.ccynbr is '币种';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.iotype is '往来标识:0-往，1-来';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.cdflag is '借贷标记:D-借，C-贷';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.feeflag is '手续费标志:0-无';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.feeamt is '手续费用金额';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.hosttrcd is '金融交易码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.hostdate is '金融交易日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.hostnbr is '金融交易流水';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payopenbrn is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payopenbanknm is '付款人开户行名称';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payaccttp is '付款人账户类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payacct is '付款人账号钱包';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.incoopenbank is '收款人开户行行号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.incoopenbanknm is '收款人开户行名称';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.incoaccttp is '收款人账户类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.incoacct is '收款人账号钱包';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.cdtrwltlvl is '钱包等级';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.cdtrwlttp is '钱包类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.cdtrwltnm is '钱包名称';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.servtype is '业务种类';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transaction is '交易用途\交易资金来源';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.sgnno is '挂接协议号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.oraconsigndt is '原委托日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.oratransseq is '原报文标识号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.orasndbrn is '原发起行';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.orapckno is '原报文类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.dsptrsncd is '差错原因码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.dsptrsndesc is '差错原因说明';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.dsptamt is '调账金额';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.oprbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.oprtlr is '交易柜员';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.info is '附言';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.note is '备注';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.opnwin is '交易渠道';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.msgno is '通信级标识号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.refmsgno is '通信级参考号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.errcode is '行里错误码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.errms is '行里错误信息';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvdt is '回执交易日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvtm is '回执交易时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.msgid is '回执报文标识号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.msgtp is '回执报文类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.prcsts is '业务状态';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.prccd is '业务处理码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.processcode is '业务回执状态';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rejectcode is '业务拒绝码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rejectinfo is '业务拒绝信息';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transmitdt is '业务处理时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.chkprodstatus is '业务对账状态';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.chkhoststatus is '金融对账状态';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.status is '交易状态';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.fill is '交易结果说明';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.changtime is '更新时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.accttp is '账户类型';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.srcsysssn is '统一支付渠道流水号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.returncode is 'ESC接口返回码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.returnmsg is 'ESC接口返回信息';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.transseqno is 'ESC接口交易流水号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.finmainseq is '金融表中台流水';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.fintransdt is '金融表中台日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.recnt is '记账/冲正处理次数';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.uniqueseqnum is '业务流水号';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.procflag is '处理标志  1-处理中';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.begintm is '交易开始时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.endtm is '交易结束时间';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payresdttp is '付款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.payctrycode is '付款用户常驻国家/地区代码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvresdttp is '收款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.rcvctrycode is '收款用户常驻国家/地区代码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.phnctrycode is '钱包注册手机号所在国家/地区代码';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1stdcpstrx.etl_timestamp is 'ETL处理时间戳';
