/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubzlacom
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubzlacom
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubzlacom purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubzlacom(
    acqinstid varchar2(17) -- 代理机构标识码
    ,fwdinstid varchar2(17) -- 发送机构标识码
    ,systrace varchar2(9) -- 系统跟踪号
    ,transtime varchar2(15) -- 交易传输时间
    ,transdate varchar2(12) -- 交易日期
    ,priacct varchar2(29) -- 主账号
    ,transamt varchar2(18) -- 交易金额
    ,acceptamt varchar2(18) -- 部分代收时的承兑金额
    ,handfee varchar2(18) -- 持卡人交易手续费
    ,msgtype varchar2(6) -- 报文类型
    ,procecode varchar2(9) -- 交易类型码
    ,mchnttype varchar2(6) -- 商户类型
    ,acptermnlid varchar2(12) -- 受卡机终端标识码
    ,accptrid varchar2(23) -- 受卡方标识码
    ,retrivarefnum varchar2(18) -- 检索参考号
    ,servicecode varchar2(3) -- 服务点条件码
    ,authridresp varchar2(9) -- 授权应答码
    ,rcvinstid varchar2(17) -- 接收机构标识码
    ,oldsystrace varchar2(9) -- 原始交易的系统跟踪号
    ,respcode varchar2(3) -- 交易返回码
    ,posentrymode varchar2(5) -- 服务点输入方式码
    ,duehandchrg varchar2(18) -- 应付交换费
    ,rcvhandchrg varchar2(18) -- 收交换费
    ,covhangchrg varchar2(18) -- 转接清算费
    ,sindouchflg varchar2(2) -- 单双转换标志
    ,cardseqno varchar2(5) -- 卡片序列号
    ,termable varchar2(2) -- 终端读取能力
    ,iccode varchar2(2) -- ic卡条件代码
    ,oldtranstime varchar2(15) -- 原始交易日期时间
    ,issurinstid varchar2(17) -- 发卡机构标识码
    ,transarea varchar2(2) -- 交易地域标志
    ,termtype varchar2(3) -- 终端类型
    ,ectflg varchar2(3) -- eci标志
    ,addfee varchar2(18) -- 分期付款附加手续费
    ,other varchar2(21) -- 其他信息
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
grant select on ${iol_schema}.mpcs_a51ubzlacom to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubzlacom to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubzlacom to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubzlacom to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubzlacom is '清算流水表';
comment on column ${iol_schema}.mpcs_a51ubzlacom.acqinstid is '代理机构标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.fwdinstid is '发送机构标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubzlacom.transtime is '交易传输时间';
comment on column ${iol_schema}.mpcs_a51ubzlacom.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubzlacom.priacct is '主账号';
comment on column ${iol_schema}.mpcs_a51ubzlacom.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubzlacom.acceptamt is '部分代收时的承兑金额';
comment on column ${iol_schema}.mpcs_a51ubzlacom.handfee is '持卡人交易手续费';
comment on column ${iol_schema}.mpcs_a51ubzlacom.msgtype is '报文类型';
comment on column ${iol_schema}.mpcs_a51ubzlacom.procecode is '交易类型码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.mchnttype is '商户类型';
comment on column ${iol_schema}.mpcs_a51ubzlacom.acptermnlid is '受卡机终端标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.accptrid is '受卡方标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.retrivarefnum is '检索参考号';
comment on column ${iol_schema}.mpcs_a51ubzlacom.servicecode is '服务点条件码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.authridresp is '授权应答码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.rcvinstid is '接收机构标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.oldsystrace is '原始交易的系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubzlacom.respcode is '交易返回码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.posentrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.duehandchrg is '应付交换费';
comment on column ${iol_schema}.mpcs_a51ubzlacom.rcvhandchrg is '收交换费';
comment on column ${iol_schema}.mpcs_a51ubzlacom.covhangchrg is '转接清算费';
comment on column ${iol_schema}.mpcs_a51ubzlacom.sindouchflg is '单双转换标志';
comment on column ${iol_schema}.mpcs_a51ubzlacom.cardseqno is '卡片序列号';
comment on column ${iol_schema}.mpcs_a51ubzlacom.termable is '终端读取能力';
comment on column ${iol_schema}.mpcs_a51ubzlacom.iccode is 'ic卡条件代码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.oldtranstime is '原始交易日期时间';
comment on column ${iol_schema}.mpcs_a51ubzlacom.issurinstid is '发卡机构标识码';
comment on column ${iol_schema}.mpcs_a51ubzlacom.transarea is '交易地域标志';
comment on column ${iol_schema}.mpcs_a51ubzlacom.termtype is '终端类型';
comment on column ${iol_schema}.mpcs_a51ubzlacom.ectflg is 'eci标志';
comment on column ${iol_schema}.mpcs_a51ubzlacom.addfee is '分期付款附加手续费';
comment on column ${iol_schema}.mpcs_a51ubzlacom.other is '其他信息';
comment on column ${iol_schema}.mpcs_a51ubzlacom.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubzlacom.etl_timestamp is 'ETL处理时间戳';
