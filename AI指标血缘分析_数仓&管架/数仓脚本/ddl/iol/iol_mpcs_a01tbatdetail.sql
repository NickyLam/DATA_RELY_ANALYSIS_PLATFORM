/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a01tbatdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a01tbatdetail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a01tbatdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a01tbatdetail(
    batchdt varchar2(12) -- 批次日期
    ,batchno varchar2(30) -- 批次流水
    ,fntdt varchar2(12) -- 前置日期
    ,fntseqno varchar2(12) -- 前置流水
    ,trntype varchar2(3) -- 处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.
    ,prdcd varchar2(12) -- 产品代码
    ,recordno varchar2(38) -- 记录编号
    ,bgndt varchar2(12) -- 缴费起始日期
    ,enddt varchar2(12) -- 缴费结束日期
    ,trnmonth varchar2(6) -- 缴费月数
    ,payacctno varchar2(53) -- 明细账号
    ,trnamt varchar2(23) -- 交易金额
    ,amt1 varchar2(23) -- 备用金额1
    ,amt2 varchar2(23) -- 备用金额2
    ,amt3 varchar2(23) -- 备用金额3
    ,amt4 varchar2(23) -- 备用金额4
    ,paytype varchar2(2) -- 扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送
    ,memocd varchar2(6) -- 摘要代码
    ,dt1 varchar2(12) -- 备用日期1
    ,prtmemocd varchar2(6) -- 打印摘要
    ,oppoacctno varchar2(45) -- 代理账号记账对手方账号
    ,payacctname varchar2(384) -- 明细账号户名
    ,freezedt varchar2(12) -- 原止付交易日期
    ,freezeno varchar2(30) -- 原止付交易流水
    ,succamt varchar2(23) -- 成功金额
    ,hostseqno varchar2(96) -- 核心交易流水
    ,hostseqdt varchar2(12) -- 核心交易日期
    ,rspcd varchar2(30) -- 响应码
    ,rspmsg varchar2(600) -- 响应信息
    ,otherbankno varchar2(30) -- 他行联行号
    ,addword varchar2(600) -- 附言
    ,orderid varchar2(96) -- 订单标识
    ,upptranseqno varchar2(60) -- 交易流水号
    ,trndate varchar2(12) -- 中台交易日期
    ,glob_seq_num varchar2(96) -- 全局流水号
    ,srv_cllpty_trx_seq varchar2(96) -- 交易流水号
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
grant select on ${iol_schema}.mpcs_a01tbatdetail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a01tbatdetail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a01tbatdetail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a01tbatdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a01tbatdetail is '企业网银代发明细表';
comment on column ${iol_schema}.mpcs_a01tbatdetail.batchdt is '批次日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.batchno is '批次流水';
comment on column ${iol_schema}.mpcs_a01tbatdetail.fntdt is '前置日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.fntseqno is '前置流水';
comment on column ${iol_schema}.mpcs_a01tbatdetail.trntype is '处理类型00－扣款05－入账10－解冻并扣款15－入账并冻结20－解冻25－冻结此类型是站在[明细账户]的角度定义.';
comment on column ${iol_schema}.mpcs_a01tbatdetail.prdcd is '产品代码';
comment on column ${iol_schema}.mpcs_a01tbatdetail.recordno is '记录编号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.bgndt is '缴费起始日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.enddt is '缴费结束日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.trnmonth is '缴费月数';
comment on column ${iol_schema}.mpcs_a01tbatdetail.payacctno is '明细账号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.trnamt is '交易金额';
comment on column ${iol_schema}.mpcs_a01tbatdetail.amt1 is '备用金额1';
comment on column ${iol_schema}.mpcs_a01tbatdetail.amt2 is '备用金额2';
comment on column ${iol_schema}.mpcs_a01tbatdetail.amt3 is '备用金额3';
comment on column ${iol_schema}.mpcs_a01tbatdetail.amt4 is '备用金额4';
comment on column ${iol_schema}.mpcs_a01tbatdetail.paytype is '扣款模式0－可用余额必须大于等于请求金额,不够则失败1－可用余额大余零则处理,等于零则失败处理类型为:00时需送';
comment on column ${iol_schema}.mpcs_a01tbatdetail.memocd is '摘要代码';
comment on column ${iol_schema}.mpcs_a01tbatdetail.dt1 is '备用日期1';
comment on column ${iol_schema}.mpcs_a01tbatdetail.prtmemocd is '打印摘要';
comment on column ${iol_schema}.mpcs_a01tbatdetail.oppoacctno is '代理账号记账对手方账号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.payacctname is '明细账号户名';
comment on column ${iol_schema}.mpcs_a01tbatdetail.freezedt is '原止付交易日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.freezeno is '原止付交易流水';
comment on column ${iol_schema}.mpcs_a01tbatdetail.succamt is '成功金额';
comment on column ${iol_schema}.mpcs_a01tbatdetail.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a01tbatdetail.hostseqdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.rspcd is '响应码';
comment on column ${iol_schema}.mpcs_a01tbatdetail.rspmsg is '响应信息';
comment on column ${iol_schema}.mpcs_a01tbatdetail.otherbankno is '他行联行号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.addword is '附言';
comment on column ${iol_schema}.mpcs_a01tbatdetail.orderid is '订单标识';
comment on column ${iol_schema}.mpcs_a01tbatdetail.upptranseqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.trndate is '中台交易日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.srv_cllpty_trx_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a01tbatdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a01tbatdetail.etl_timestamp is 'ETL处理时间戳';
