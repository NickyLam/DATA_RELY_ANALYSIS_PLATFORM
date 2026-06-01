/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1rtcbpstrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1rtcbpstrx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1rtcbpstrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1rtcbpstrx(
    syscd varchar2(6) -- 系统码
    ,mainseq varchar2(24) -- 中台流水
    ,transdt varchar2(12) -- 中台日期
    ,transtm varchar2(14) -- 中台时间
    ,pckno varchar2(30) -- 报文类型
    ,sndbrn varchar2(21) -- 发送行
    ,sndupbrn varchar2(21) -- 发送清算行
    ,rcvbrn varchar2(21) -- 接收行
    ,rcvupbrn varchar2(21) -- 接收清算行
    ,consigndt varchar2(12) -- 委托日期
    ,transseq varchar2(53) -- 报文标识号
    ,opersq varchar2(53) -- 明细标识号
    ,endtoendid varchar2(53) -- 端到端标识号
    ,businesstrace varchar2(24) -- 行内业务序号
    ,fronttrcd varchar2(15) -- 中台交易码
    ,ccynbr varchar2(5) -- 币种
    ,transamt varchar2(26) -- 交易金额
    ,iotype varchar2(2) -- 往来标识
    ,flag3 varchar2(2) -- 收费标志
    ,flag4 varchar2(2) -- 借贷标记
    ,feeflag varchar2(2) -- 手续费标志
    ,feeamt varchar2(26) -- 手续费用金额
    ,hosttrcd varchar2(30) -- 金融交易码
    ,hostdate varchar2(12) -- 金融交易日期
    ,hostnbr varchar2(96) -- 金融交易流水
    ,accptncdttm varchar2(21) -- 委托时间
    ,paycitycode varchar2(9) -- 付款人开户行所属城市代码
    ,payupbrn varchar2(21) -- 付款清算行行号
    ,paybrn varchar2(21) -- 付款人开户行机构号
    ,payopenbrn varchar2(21) -- 付款人开户行行号
    ,payopenbanknm varchar2(420) -- 付款人开户行名称
    ,payaccttp varchar2(6) -- 付款人账户类型
    ,payacct varchar2(48) -- 付款人账号
    ,payname varchar2(180) -- 付款人名称
    ,payaddr varchar2(210) -- 付款人地址
    ,incocitycode varchar2(9) -- 收款人开户行所属城市代码
    ,incoopenbank varchar2(21) -- 收款人开户行行号
    ,incoupbrn varchar2(21) -- 收款清算行行号
    ,incoopenbanknm varchar2(420) -- 收款人开户行名称
    ,incoaccttp varchar2(6) -- 收款人账户类型
    ,incoacct varchar2(48) -- 收款人账号
    ,inconame varchar2(180) -- 收款人名称
    ,incoaddr varchar2(210) -- 收款人地址
    ,bustype varchar2(6) -- 业务类型
    ,servtype varchar2(8) -- 业务种类
    ,oraconsigndt varchar2(12) -- 原委托日期
    ,oratransseq varchar2(53) -- 原报文标识号
    ,orasndbrn varchar2(21) -- 原发起行
    ,orapckno varchar2(30) -- 原报文类型
    ,paymod varchar2(2) -- 支付方式
    ,paypwd varchar2(90) -- 支付密码
    ,idtype varchar2(12) -- 证件种类
    ,idno varchar2(45) -- 证件号码
    ,bookcode varchar2(6) -- 凭证类型
    ,bookdate varchar2(12) -- 凭证日期
    ,bookseqno varchar2(53) -- 凭证号码
    ,feetype varchar2(2) -- 计费种类
    ,realam1 varchar2(26) -- 实收费额1
    ,smrycd1 varchar2(60) -- 摘要码1
    ,busino1 varchar2(23) -- 计费业务编码1
    ,fenm1 varchar2(150) -- 计费业务编码名称1
    ,realam2 varchar2(26) -- 实收费额2
    ,smrycd2 varchar2(60) -- 摘要码2
    ,busino2 varchar2(23) -- 计费业务编码2
    ,fenm2 varchar2(150) -- 计费业务编码名称2
    ,realam3 varchar2(26) -- 实收费额3
    ,smrycd3 varchar2(60) -- 摘要码3
    ,busino3 varchar2(23) -- 计费业务编码3
    ,fenm3 varchar2(150) -- 计费业务编码名称3
    ,transfee varchar2(26) -- 异地客户手续费
    ,levels varchar2(2) -- 优先级别
    ,oprbrn varchar2(9) -- 交易机构
    ,oprtlr varchar2(15) -- 交易柜员
    ,info varchar2(405) -- 附言
    ,note varchar2(405) -- 备注
    ,orgnlreason varchar2(405) -- 退汇原因
    ,opnwin varchar2(12) -- 交易渠道
    ,appenddatatable varchar2(45) -- 登记附加数据的表名
    ,maxtransamt varchar2(26) -- 转账限额
    ,errcode varchar2(30) -- 行里错误码
    ,errms varchar2(450) -- 行里错误信息
    ,rcvdt varchar2(21) -- 接收日期
    ,rcvtm varchar2(9) -- 接收时间
    ,msgid varchar2(53) -- 回执报文标识号
    ,processcode varchar2(6) -- 城银清业务状态
    ,netgrnd varchar2(3) -- 轧差场次
    ,netgdt varchar2(12) -- 轧差日期
    ,rejectcode varchar2(6) -- 城银清业务拒绝码
    ,rejectinfo varchar2(315) -- 城银清业务拒绝原因
    ,proccd varchar2(12) -- 城银清业务处理码
    ,rjbank varchar2(21) -- 拒绝业务的参与机构行号
    ,transmitdt varchar2(21) -- 转发时间
    ,cleardt varchar2(12) -- 清算日期（处理日期、终态日期）
    ,chkprodstatus varchar2(3) -- 业务对账状态
    ,chkhoststatus varchar2(3) -- 金融对账状态
    ,status varchar2(3) -- 交易状态
    ,fill varchar2(768) -- 交易结果说明
    ,changtime varchar2(21) -- 更新时间
    ,magebrn varchar2(9) -- 管理机构
    ,prtcnt number(22,0) -- 打印次数
    ,hangupreason varchar2(3) -- 挂账原因代码
    ,hangupmesg varchar2(768) -- 挂账原因说明
    ,sacdt varchar2(12) -- 挂账日期
    ,sactlr varchar2(32) -- 挂账柜员
    ,sacbrn varchar2(32) -- 挂账机构号
    ,sacacct varchar2(53) -- 挂账账号
    ,sacname varchar2(180) -- 挂账户名
    ,crdt varchar2(12) -- 维护入账日期
    ,crtlr varchar2(32) -- 维护入账柜员
    ,crbrn varchar2(32) -- 维护入账机构号
    ,cracct varchar2(53) -- 维护入账账号
    ,crname varchar2(180) -- 维护入账户名
    ,endtlr varchar2(18) -- 冲正柜员
    ,edhostnbr varchar2(96) -- 冲正流水
    ,edhostdt varchar2(12) -- 冲正日期
    ,isinout varchar2(2) -- 账务标识
    ,inacct varchar2(53) -- 实际扣帐账号
    ,inname varchar2(180) -- 实际扣帐户名
    ,eaccflg varchar2(3) -- 电子账户标识
    ,tacctp varchar2(30) -- 账户种类
    ,accttp varchar2(30) -- 账户类型
    ,acct_typ_id varchar2(2) -- 账户类型id
    ,globalseqno varchar2(60) -- 全局流水号
    ,srcsysssn varchar2(60) -- 统一支付渠道流水号
    ,od_flag varchar2(2) -- 是否发生透支
    ,od_ovtranam number(18,2) -- 透支金额
    ,nextdayflag varchar2(2) -- 次日达标识
    ,autoflag varchar2(2) -- 自动退汇标志
    ,autocount varchar2(2) -- 自动退汇次数
    ,automsg varchar2(300) -- 自动退汇信息
    ,limitorderid varchar2(48) -- 限额订单号
    ,returncode varchar2(30) -- esb接口返回码
    ,returnmsg varchar2(1536) -- esb接口返回信息
    ,transseqno varchar2(96) -- esb接口交易流水号
    ,finaccountid varchar2(60) -- 产品账户 （e账户时需要）
    ,memocntt varchar2(383) -- 电子账户记账摘要
    ,finmainseq varchar2(24) -- 金融表中台流水
    ,fintransdt varchar2(12) -- 金融表中台日期
    ,recnt varchar2(8) -- 记账/冲正处理次数
    ,msgno varchar2(30) -- 通信级标识号
    ,refmsgno varchar2(30) -- 通信级参考号
    ,trntype varchar2(45) -- 交易种类
    ,exchgflg varchar2(2) -- 个人汇兑标识
    ,orisrcsysssn varchar2(48) -- 原交易流水
    ,orisyscd varchar2(6) -- 原支付通道
    ,rcdstatus varchar2(2) -- 往账删除标识
    ,redoflag varchar2(2) -- 重发标志
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
grant select on ${iol_schema}.mpcs_a1rtcbpstrx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1rtcbpstrx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1rtcbpstrx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1rtcbpstrx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1rtcbpstrx is '城银清算业务交易流水表';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.syscd is '系统码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.mainseq is '中台流水';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transdt is '中台日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transtm is '中台时间';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sndbrn is '发送行';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sndupbrn is '发送清算行';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rcvbrn is '接收行';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rcvupbrn is '接收清算行';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.consigndt is '委托日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transseq is '报文标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.opersq is '明细标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.endtoendid is '端到端标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.businesstrace is '行内业务序号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.ccynbr is '币种';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.iotype is '往来标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.flag3 is '收费标志';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.flag4 is '借贷标记';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.feeflag is '手续费标志';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.feeamt is '手续费用金额';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.hosttrcd is '金融交易码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.hostdate is '金融交易日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.hostnbr is '金融交易流水';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.accptncdttm is '委托时间';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.paycitycode is '付款人开户行所属城市代码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payupbrn is '付款清算行行号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.paybrn is '付款人开户行机构号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payopenbrn is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payopenbanknm is '付款人开户行名称';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payaccttp is '付款人账户类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.payaddr is '付款人地址';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incocitycode is '收款人开户行所属城市代码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoopenbank is '收款人开户行行号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoupbrn is '收款清算行行号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoopenbanknm is '收款人开户行名称';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoaccttp is '收款人账户类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.incoaddr is '收款人地址';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.servtype is '业务种类';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.oraconsigndt is '原委托日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.oratransseq is '原报文标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.orasndbrn is '原发起行';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.orapckno is '原报文类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.paymod is '支付方式';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.paypwd is '支付密码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.idtype is '证件种类';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.bookcode is '凭证类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.bookdate is '凭证日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.bookseqno is '凭证号码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.feetype is '计费种类';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.realam1 is '实收费额1';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.smrycd1 is '摘要码1';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.busino1 is '计费业务编码1';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fenm1 is '计费业务编码名称1';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.realam2 is '实收费额2';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.smrycd2 is '摘要码2';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.busino2 is '计费业务编码2';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fenm2 is '计费业务编码名称2';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.realam3 is '实收费额3';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.smrycd3 is '摘要码3';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.busino3 is '计费业务编码3';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fenm3 is '计费业务编码名称3';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transfee is '异地客户手续费';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.levels is '优先级别';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.oprbrn is '交易机构';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.oprtlr is '交易柜员';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.info is '附言';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.note is '备注';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.orgnlreason is '退汇原因';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.opnwin is '交易渠道';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.appenddatatable is '登记附加数据的表名';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.maxtransamt is '转账限额';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.errcode is '行里错误码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.errms is '行里错误信息';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rcvdt is '接收日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rcvtm is '接收时间';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.msgid is '回执报文标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.processcode is '城银清业务状态';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.netgrnd is '轧差场次';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.netgdt is '轧差日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rejectcode is '城银清业务拒绝码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rejectinfo is '城银清业务拒绝原因';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.proccd is '城银清业务处理码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rjbank is '拒绝业务的参与机构行号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transmitdt is '转发时间';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.cleardt is '清算日期（处理日期、终态日期）';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.chkprodstatus is '业务对账状态';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.chkhoststatus is '金融对账状态';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.status is '交易状态';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fill is '交易结果说明';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.changtime is '更新时间';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.prtcnt is '打印次数';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.hangupreason is '挂账原因代码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.hangupmesg is '挂账原因说明';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sacdt is '挂账日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sactlr is '挂账柜员';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sacbrn is '挂账机构号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sacacct is '挂账账号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.sacname is '挂账户名';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.crdt is '维护入账日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.crtlr is '维护入账柜员';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.crbrn is '维护入账机构号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.cracct is '维护入账账号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.crname is '维护入账户名';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.endtlr is '冲正柜员';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.edhostnbr is '冲正流水';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.edhostdt is '冲正日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.isinout is '账务标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.inacct is '实际扣帐账号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.inname is '实际扣帐户名';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.eaccflg is '电子账户标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.tacctp is '账户种类';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.accttp is '账户类型';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.acct_typ_id is '账户类型id';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.srcsysssn is '统一支付渠道流水号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.od_flag is '是否发生透支';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.od_ovtranam is '透支金额';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.nextdayflag is '次日达标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.autoflag is '自动退汇标志';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.autocount is '自动退汇次数';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.automsg is '自动退汇信息';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.limitorderid is '限额订单号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.returncode is 'esb接口返回码';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.returnmsg is 'esb接口返回信息';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.transseqno is 'esb接口交易流水号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.finaccountid is '产品账户 （e账户时需要）';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.memocntt is '电子账户记账摘要';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.finmainseq is '金融表中台流水';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.fintransdt is '金融表中台日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.recnt is '记账/冲正处理次数';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.msgno is '通信级标识号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.refmsgno is '通信级参考号';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.trntype is '交易种类';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.exchgflg is '个人汇兑标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.orisrcsysssn is '原交易流水';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.orisyscd is '原支付通道';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.rcdstatus is '往账删除标识';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.redoflag is '重发标志';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1rtcbpstrx.etl_timestamp is 'ETL处理时间戳';
