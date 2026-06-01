/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1xwktransjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1xwktransjour
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1xwktransjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1xwktransjour(
    fntdt varchar2(12) -- 渠道日期
    ,globalseq varchar2(96) -- 全局流水号
    ,transcode varchar2(3) -- 交易类型 01-充值 02-退卡 03-3DS 99-外卡异步回调
    ,oldtranscode varchar2(3) -- 原交易类型 01-充值 02-退卡 03-3DS
    ,txnno varchar2(96) -- 银联交易流水号
    ,messageid varchar2(48) -- 外卡收单消息ID
    ,orderid varchar2(48) -- 外卡收单订单号
    ,reforderid varchar2(48) -- 外卡收单关联订单号
    ,txnamt varchar2(21) -- 交易金额
    ,txnwkamt varchar2(21) -- 外卡交易金额
    ,feeamt varchar2(21) -- 外卡手续费
    ,txnccy varchar2(5) -- 币种
    ,acctno varchar2(29) -- 外卡账号
    ,acctprd varchar2(6) -- 外卡账号卡有效期
    ,acctcvn varchar2(6) -- 外卡账号卡CVN
    ,phoneno varchar2(24) -- 手机号
    ,customid varchar2(45) -- 客户ID
    ,baseacctno varchar2(30) -- 旅行通账号
    ,custno varchar2(24) -- 客户号
    ,acctna varchar2(300) -- 账号户名
    ,issinscode varchar2(17) -- 机构代码
    ,merchantid varchar2(48) -- 商户号
    ,frncurcode varchar2(5) -- 币种
    ,frntxnamt varchar2(21) -- 外币金额
    ,callbackurl varchar2(1536) -- 回调地址
    ,authurl varchar2(1536) -- 3ds认证Url
    ,modetp varchar2(48) -- 商户的3DS策略 NEEDED-需要去进行3DS，NONEED-不需要进行3DS
    ,synctype varchar2(24) -- 同步方式
    ,code varchar2(15) -- 应答码 00-成功 05-超时 08-失败
    ,rspdesc varchar2(1536) -- 应答信息
    ,authcode varchar2(48) -- 授权码
    ,retrievalnumber varchar2(18) -- 检索参考号
    ,settldate varchar2(12) -- 清算日期
    ,brand varchar2(5) -- 卡品牌 VIS, MCC, JCB, AME, CUP, DNC
    ,status varchar2(3) -- 状态 0-初始状态 1-成功 2-冲正 4-已发送到第三方支付 5-已发送核心 6-第三方成功 7-核心成功 8-失败 9-第三方异步回调处理中
    ,degree varchar2(2) -- 账户等级 1-不记名 2-记名普通 3-记名高级
    ,busiseq varchar2(96) -- 业务流水号
    ,transeq varchar2(96) -- 交易流水号
    ,hostnbr varchar2(96) -- 核心流水
    ,destrnseq varchar2(96) -- 3DES认证交易流水号
    ,rtitraceseqno varchar2(96) -- 实时智能跟踪流水号
    ,inserttm date -- 入库时间
    ,updatetm date -- 最新维护时间
    ,callbacktm date -- 异步回调时间
    ,hostchkflg varchar2(2) -- 核心对账状态 0-未对账 1-成功 2-已冲正 N-不涉及
    ,eci varchar2(3) -- 电子商务标识
    ,av varchar2(42) -- 身份认证值
    ,dstransactionid varchar2(54) -- DS交易标识符
    ,transstatus varchar2(2) -- 交易状态标识 Y-平滑模式验证成功 C-挑战模式验证成功 A-尝试验证成功 N-验证未完成，交易失败 U-验证无法进行，交易失败 R-验证被拒绝，交易失败
    ,settleamt varchar2(18) -- 清算金额
    ,settlecurrencycode varchar2(5) -- 币种
    ,exchangedate varchar2(6) -- 兑换日期
    ,exchangerate varchar2(12) -- 清算汇率
    ,traceno varchar2(9) -- 系统跟踪号
    ,tracetime varchar2(15) -- 交易传输时间
    ,hostdate varchar2(12) -- 核心日期
    ,queryid varchar2(32) -- 交易查询流水号
    ,txntime varchar2(21) -- 订单发送时间
    ,bkstatus varchar2(3) -- 退款状态 0-未退款 1-已发起退款 2-退款失败 3-退款成功
    ,remark1 varchar2(384) -- 备注1
    ,remark2 varchar2(384) -- 备注2
    ,remark3 varchar2(768) -- 备注3
    ,remark4 varchar2(768) -- 备注4
    ,remark5 varchar2(1536) -- 备注5
    ,remark6 varchar2(1536) -- 备注6
    ,remark7 varchar2(3072) -- 备注7
    ,remark8 varchar2(3072) -- 备注8
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
grant select on ${iol_schema}.mpcs_a1xwktransjour to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1xwktransjour to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1xwktransjour to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1xwktransjour to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1xwktransjour is '旅行通卡外卡交易流水表';
comment on column ${iol_schema}.mpcs_a1xwktransjour.fntdt is '渠道日期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.globalseq is '全局流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.transcode is '交易类型 01-充值 02-退卡 03-3DS 99-外卡异步回调';
comment on column ${iol_schema}.mpcs_a1xwktransjour.oldtranscode is '原交易类型 01-充值 02-退卡 03-3DS';
comment on column ${iol_schema}.mpcs_a1xwktransjour.txnno is '银联交易流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.messageid is '外卡收单消息ID';
comment on column ${iol_schema}.mpcs_a1xwktransjour.orderid is '外卡收单订单号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.reforderid is '外卡收单关联订单号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.txnamt is '交易金额';
comment on column ${iol_schema}.mpcs_a1xwktransjour.txnwkamt is '外卡交易金额';
comment on column ${iol_schema}.mpcs_a1xwktransjour.feeamt is '外卡手续费';
comment on column ${iol_schema}.mpcs_a1xwktransjour.txnccy is '币种';
comment on column ${iol_schema}.mpcs_a1xwktransjour.acctno is '外卡账号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.acctprd is '外卡账号卡有效期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.acctcvn is '外卡账号卡CVN';
comment on column ${iol_schema}.mpcs_a1xwktransjour.phoneno is '手机号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.customid is '客户ID';
comment on column ${iol_schema}.mpcs_a1xwktransjour.baseacctno is '旅行通账号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.custno is '客户号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.acctna is '账号户名';
comment on column ${iol_schema}.mpcs_a1xwktransjour.issinscode is '机构代码';
comment on column ${iol_schema}.mpcs_a1xwktransjour.merchantid is '商户号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.frncurcode is '币种';
comment on column ${iol_schema}.mpcs_a1xwktransjour.frntxnamt is '外币金额';
comment on column ${iol_schema}.mpcs_a1xwktransjour.callbackurl is '回调地址';
comment on column ${iol_schema}.mpcs_a1xwktransjour.authurl is '3ds认证Url';
comment on column ${iol_schema}.mpcs_a1xwktransjour.modetp is '商户的3DS策略 NEEDED-需要去进行3DS，NONEED-不需要进行3DS';
comment on column ${iol_schema}.mpcs_a1xwktransjour.synctype is '同步方式';
comment on column ${iol_schema}.mpcs_a1xwktransjour.code is '应答码 00-成功 05-超时 08-失败';
comment on column ${iol_schema}.mpcs_a1xwktransjour.rspdesc is '应答信息';
comment on column ${iol_schema}.mpcs_a1xwktransjour.authcode is '授权码';
comment on column ${iol_schema}.mpcs_a1xwktransjour.retrievalnumber is '检索参考号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.settldate is '清算日期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.brand is '卡品牌 VIS, MCC, JCB, AME, CUP, DNC';
comment on column ${iol_schema}.mpcs_a1xwktransjour.status is '状态 0-初始状态 1-成功 2-冲正 4-已发送到第三方支付 5-已发送核心 6-第三方成功 7-核心成功 8-失败 9-第三方异步回调处理中';
comment on column ${iol_schema}.mpcs_a1xwktransjour.degree is '账户等级 1-不记名 2-记名普通 3-记名高级';
comment on column ${iol_schema}.mpcs_a1xwktransjour.busiseq is '业务流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.transeq is '交易流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a1xwktransjour.destrnseq is '3DES认证交易流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.rtitraceseqno is '实时智能跟踪流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.inserttm is '入库时间';
comment on column ${iol_schema}.mpcs_a1xwktransjour.updatetm is '最新维护时间';
comment on column ${iol_schema}.mpcs_a1xwktransjour.callbacktm is '异步回调时间';
comment on column ${iol_schema}.mpcs_a1xwktransjour.hostchkflg is '核心对账状态 0-未对账 1-成功 2-已冲正 N-不涉及';
comment on column ${iol_schema}.mpcs_a1xwktransjour.eci is '电子商务标识';
comment on column ${iol_schema}.mpcs_a1xwktransjour.av is '身份认证值';
comment on column ${iol_schema}.mpcs_a1xwktransjour.dstransactionid is 'DS交易标识符';
comment on column ${iol_schema}.mpcs_a1xwktransjour.transstatus is '交易状态标识 Y-平滑模式验证成功 C-挑战模式验证成功 A-尝试验证成功 N-验证未完成，交易失败 U-验证无法进行，交易失败 R-验证被拒绝，交易失败';
comment on column ${iol_schema}.mpcs_a1xwktransjour.settleamt is '清算金额';
comment on column ${iol_schema}.mpcs_a1xwktransjour.settlecurrencycode is '币种';
comment on column ${iol_schema}.mpcs_a1xwktransjour.exchangedate is '兑换日期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.exchangerate is '清算汇率';
comment on column ${iol_schema}.mpcs_a1xwktransjour.traceno is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.tracetime is '交易传输时间';
comment on column ${iol_schema}.mpcs_a1xwktransjour.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.queryid is '交易查询流水号';
comment on column ${iol_schema}.mpcs_a1xwktransjour.txntime is '订单发送时间';
comment on column ${iol_schema}.mpcs_a1xwktransjour.bkstatus is '退款状态 0-未退款 1-已发起退款 2-退款失败 3-退款成功';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark1 is '备注1';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark2 is '备注2';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark3 is '备注3';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark4 is '备注4';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark5 is '备注5';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark6 is '备注6';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark7 is '备注7';
comment on column ${iol_schema}.mpcs_a1xwktransjour.remark8 is '备注8';
comment on column ${iol_schema}.mpcs_a1xwktransjour.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1xwktransjour.etl_timestamp is 'ETL处理时间戳';
