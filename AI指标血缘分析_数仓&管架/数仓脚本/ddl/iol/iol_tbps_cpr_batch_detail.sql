/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_batch_detail(
    cbd_batchno varchar2(20) -- 批次号
    ,cbd_seqno number -- 序号，从1-9999
    ,cbd_trade_flowno varchar2(32) -- 流水号
    ,cbd_sendflowno varchar2(64) -- 
    ,cbd_payacc varchar2(32) -- 付款账号
    ,cbd_payname varchar2(256) -- 付款账号户名
    ,cbd_payacctype varchar2(4) -- 付款账户类型
    ,cbd_currency varchar2(3) -- 付款账户币种
    ,cbd_paynode varchar2(20) -- 付款方网点
    ,cbd_paybank varchar2(300) -- 付款方开户行名称
    ,cbd_crflag varchar2(1) -- 钞汇标志：C：钞；R：汇；X：不适用
    ,cbd_rcvacc varchar2(40) -- 收款账号
    ,cbd_rcvname varchar2(256) -- 收款账号户名
    ,cbd_rcvcry varchar2(3) -- 收款账户币种
    ,cbd_rcvciftype varchar2(1) -- 收款人类型：1；企业；2；个人
    ,cbd_rcvnode varchar2(20) -- 收款行网点
    ,cbd_rcvbank varchar2(300) -- 收款行开户行名称
    ,cbd_payeebankname varchar2(128) -- 收款行名
    ,cbd_payeeprovincecode varchar2(16) -- 收款行省号
    ,cbd_payeeprovincename varchar2(64) -- 收款行省名
    ,cbd_payeecitycode varchar2(16) -- 收款行城市号
    ,cbd_payeecityname varchar2(128) -- 收款行城市名
    ,cbd_unionnode varchar2(20) -- 收款行联行号
    ,cbd_payeeuniondeptname varchar2(255) -- 收款行联行名
    ,cbd_rcvclearbankid varchar2(12) -- 收款行清算行号
    ,cbd_rcvphone varchar2(16) -- 收款人手机号码
    ,cbd_tranamt number(15,2) -- 金额
    ,cbd_fee number(15,2) -- 手续费
    ,cbd_tranchannel varchar2(20) -- 转账路由
    ,cbd_purpose varchar2(256) -- 转账用途
    ,cbd_remark varchar2(512) -- 附言
    ,cbd_transcode varchar2(32) -- 交易码
    ,cbd_transdate varchar2(8) -- 交易日期
    ,cbd_transtime varchar2(14) -- 交易时间
    ,cbd_saveflag varchar2(1) -- 保存收款人
    ,cbd_noticercv varchar2(1) -- 通知收款人
    ,cbd_stt varchar2(1) -- 状态
    ,cbd_returncode varchar2(1024) -- 返回码
    ,cbd_returnmsg varchar2(1024) -- 返回信息
    ,cbd_starttime varchar2(14) -- 处理开始时间
    ,cbd_endtime varchar2(14) -- 处理结束时间
    ,cbd_hostflow varchar2(64) -- 核心流水号
    ,cbd_validatemsg varchar2(256) -- 验证信息
    ,cbd_errormsg varchar2(512) -- 错误信息
    ,cbd_hostdate varchar2(14) -- 核心日期
    ,cbd_other varchar2(128) -- 其他
    ,cbd_biz_flow_no varchar2(64) -- 业务流水号
    ,cbd_chain_track_no varchar2(64) -- 链路跟踪号
    ,cbd_send_flow_no varchar2(64) -- 上游交易流水号
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
grant select on ${iol_schema}.tbps_cpr_batch_detail to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_batch_detail to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_batch_detail to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_batch_detail is '批量转账指令流水明细表';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_batchno is '批次号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_seqno is '序号，从1-9999';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_trade_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_sendflowno is '';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payacc is '付款账号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payname is '付款账号户名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payacctype is '付款账户类型';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_currency is '付款账户币种';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_paynode is '付款方网点';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_paybank is '付款方开户行名称';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_crflag is '钞汇标志：C：钞；R：汇；X：不适用';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvacc is '收款账号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvname is '收款账号户名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvcry is '收款账户币种';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvciftype is '收款人类型：1；企业；2；个人';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvnode is '收款行网点';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvbank is '收款行开户行名称';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeebankname is '收款行名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeeprovincecode is '收款行省号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeeprovincename is '收款行省名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeecitycode is '收款行城市号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeecityname is '收款行城市名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_unionnode is '收款行联行号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_payeeuniondeptname is '收款行联行名';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvclearbankid is '收款行清算行号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_rcvphone is '收款人手机号码';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_tranamt is '金额';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_fee is '手续费';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_tranchannel is '转账路由';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_purpose is '转账用途';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_remark is '附言';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_transcode is '交易码';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_transdate is '交易日期';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_transtime is '交易时间';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_saveflag is '保存收款人';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_noticercv is '通知收款人';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_stt is '状态';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_returncode is '返回码';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_returnmsg is '返回信息';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_starttime is '处理开始时间';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_endtime is '处理结束时间';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_hostflow is '核心流水号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_validatemsg is '验证信息';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_errormsg is '错误信息';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_hostdate is '核心日期';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_other is '其他';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_biz_flow_no is '业务流水号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_chain_track_no is '链路跟踪号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.cbd_send_flow_no is '上游交易流水号';
comment on column ${iol_schema}.tbps_cpr_batch_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbps_cpr_batch_detail.etl_timestamp is 'ETL处理时间戳';
