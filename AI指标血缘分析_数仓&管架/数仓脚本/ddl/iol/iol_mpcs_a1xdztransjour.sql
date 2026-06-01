/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1xdztransjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1xdztransjour
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1xdztransjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1xdztransjour(
    transdate varchar2(12) -- 清算日期
    ,keyid varchar2(96) -- 流水唯一KEY
    ,acqinstid varchar2(17) -- 代理银行标识码
    ,fwdinstid varchar2(17) -- 发送银行标识码
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(15) -- 交易传输时间
    ,priacct varchar2(29) -- 主账号
    ,transamt varchar2(18) -- 交易金额
    ,acceptamt varchar2(18) -- 部分代收时的承兑金额
    ,handfee varchar2(18) -- 持卡人交易手续费
    ,msgtype varchar2(6) -- 报文类型
    ,procecode varchar2(9) -- 交易类型码
    ,mchnttype varchar2(6) -- 商户类型
    ,acptermnlid varchar2(12) -- 受卡机终端标识码
    ,accptrid varchar2(23) -- 受卡方标识码
    ,accttrnameloc varchar2(60) -- 受卡方名称地址
    ,retrivarefnum varchar2(18) -- 检索参考号
    ,servicecode varchar2(3) -- 服务点条件码
    ,authridresp varchar2(9) -- 授权应答码
    ,rcvinstid varchar2(17) -- 接收银行标识码
    ,oldsystrace varchar2(9) -- 原始交易的系统跟踪
    ,respcode varchar2(3) -- 交易返回码
    ,tranccy varchar2(5) -- 交易货币
    ,posentrymode varchar2(5) -- 服务点输入方式
    ,settccy varchar2(5) -- 清算货币
    ,settamt varchar2(18) -- 清算金额
    ,rate varchar2(12) -- 清算汇率
    ,settdate varchar2(6) -- 清算日期
    ,ratedate varchar2(6) -- 兑换日期
    ,cardholdccy varchar2(5) -- 持卡人账户货币
    ,cardholdamt varchar2(18) -- 持卡人扣账金额
    ,cardholdrate varchar2(12) -- 持卡人扣账汇率
    ,rcvtranfee varchar2(18) -- 应收手续费（交易币种）
    ,paytranfee varchar2(18) -- 应付手续费（交易币种）
    ,rcvsettfee varchar2(18) -- 应收手续费（清算币种）
    ,paysettfee varchar2(18) -- 应付手续费（清算币种）
    ,covfee varchar2(18) -- 转接服务费
    ,backfee varchar2(18) -- 退款交易手续费
    ,sindouchflg varchar2(2) -- 单双转换标志
    ,cardseq varchar2(5) -- 卡片序列号
    ,termable varchar2(2) -- 终端读取能力
    ,iccode varchar2(2) -- IC卡条件代码
    ,oldtranstime varchar2(15) -- 原始系统日期时间
    ,issurinstid varchar2(17) -- 发卡银行标识码
    ,transarea varchar2(2) -- 交易地域标志
    ,termtype varchar2(3) -- 终端类型
    ,instflg varchar2(5) -- 国际信用卡公司/外资银行标识
    ,ectflg varchar2(3) -- ECI标志
    ,addfee varchar2(18) -- 分期付款附加手续费
    ,reserve varchar2(41) -- 保留使用
    ,orderid varchar2(96) -- 外部订单号
    ,status varchar2(2) -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remark1 varchar2(384) -- 备注1
    ,remark2 varchar2(384) -- 备注2
    ,remark3 varchar2(768) -- 备注3
    ,remark4 varchar2(768) -- 备注4
    ,remark5 varchar2(1536) -- 备注5
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
grant select on ${iol_schema}.mpcs_a1xdztransjour to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1xdztransjour is '旅行通卡外卡清算交易流水表';
comment on column ${iol_schema}.mpcs_a1xdztransjour.transdate is '清算日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour.keyid is '流水唯一KEY';
comment on column ${iol_schema}.mpcs_a1xdztransjour.acqinstid is '代理银行标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.fwdinstid is '发送银行标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a1xdztransjour.transtime is '交易传输时间';
comment on column ${iol_schema}.mpcs_a1xdztransjour.priacct is '主账号';
comment on column ${iol_schema}.mpcs_a1xdztransjour.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour.acceptamt is '部分代收时的承兑金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour.handfee is '持卡人交易手续费';
comment on column ${iol_schema}.mpcs_a1xdztransjour.msgtype is '报文类型';
comment on column ${iol_schema}.mpcs_a1xdztransjour.procecode is '交易类型码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a1xdztransjour.acptermnlid is '受卡机终端标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.accptrid is '受卡方标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.accttrnameloc is '受卡方名称地址';
comment on column ${iol_schema}.mpcs_a1xdztransjour.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a1xdztransjour.servicecode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.authridresp is '授权应答码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.rcvinstid is '接收银行标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.oldsystrace is '原始交易的系统跟踪';
comment on column ${iol_schema}.mpcs_a1xdztransjour.respcode is '交易返回码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.tranccy is '交易货币';
comment on column ${iol_schema}.mpcs_a1xdztransjour.posentrymode is '服务点输入方式';
comment on column ${iol_schema}.mpcs_a1xdztransjour.settccy is '清算货币';
comment on column ${iol_schema}.mpcs_a1xdztransjour.settamt is '清算金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour.rate is '清算汇率';
comment on column ${iol_schema}.mpcs_a1xdztransjour.settdate is '清算日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour.ratedate is '兑换日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour.cardholdccy is '持卡人账户货币';
comment on column ${iol_schema}.mpcs_a1xdztransjour.cardholdamt is '持卡人扣账金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour.cardholdrate is '持卡人扣账汇率';
comment on column ${iol_schema}.mpcs_a1xdztransjour.rcvtranfee is '应收手续费（交易币种）';
comment on column ${iol_schema}.mpcs_a1xdztransjour.paytranfee is '应付手续费（交易币种）';
comment on column ${iol_schema}.mpcs_a1xdztransjour.rcvsettfee is '应收手续费（清算币种）';
comment on column ${iol_schema}.mpcs_a1xdztransjour.paysettfee is '应付手续费（清算币种）';
comment on column ${iol_schema}.mpcs_a1xdztransjour.covfee is '转接服务费';
comment on column ${iol_schema}.mpcs_a1xdztransjour.backfee is '退款交易手续费';
comment on column ${iol_schema}.mpcs_a1xdztransjour.sindouchflg is '单双转换标志';
comment on column ${iol_schema}.mpcs_a1xdztransjour.cardseq is '卡片序列号';
comment on column ${iol_schema}.mpcs_a1xdztransjour.termable is '终端读取能力';
comment on column ${iol_schema}.mpcs_a1xdztransjour.iccode is 'IC卡条件代码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.oldtranstime is '原始系统日期时间';
comment on column ${iol_schema}.mpcs_a1xdztransjour.issurinstid is '发卡银行标识码';
comment on column ${iol_schema}.mpcs_a1xdztransjour.transarea is '交易地域标志';
comment on column ${iol_schema}.mpcs_a1xdztransjour.termtype is '终端类型';
comment on column ${iol_schema}.mpcs_a1xdztransjour.instflg is '国际信用卡公司/外资银行标识';
comment on column ${iol_schema}.mpcs_a1xdztransjour.ectflg is 'ECI标志';
comment on column ${iol_schema}.mpcs_a1xdztransjour.addfee is '分期付款附加手续费';
comment on column ${iol_schema}.mpcs_a1xdztransjour.reserve is '保留使用';
comment on column ${iol_schema}.mpcs_a1xdztransjour.orderid is '外部订单号';
comment on column ${iol_schema}.mpcs_a1xdztransjour.status is '对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正';
comment on column ${iol_schema}.mpcs_a1xdztransjour.remark1 is '备注1';
comment on column ${iol_schema}.mpcs_a1xdztransjour.remark2 is '备注2';
comment on column ${iol_schema}.mpcs_a1xdztransjour.remark3 is '备注3';
comment on column ${iol_schema}.mpcs_a1xdztransjour.remark4 is '备注4';
comment on column ${iol_schema}.mpcs_a1xdztransjour.remark5 is '备注5';
comment on column ${iol_schema}.mpcs_a1xdztransjour.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour.etl_timestamp is 'ETL处理时间戳';
