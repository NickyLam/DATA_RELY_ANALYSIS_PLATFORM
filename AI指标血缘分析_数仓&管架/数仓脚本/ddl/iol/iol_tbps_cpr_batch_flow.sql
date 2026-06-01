/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_batch_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_batch_flow
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_batch_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_batch_flow(
    bfl_batchno varchar2(32) -- 批次号
    ,bfl_trade_flowno varchar2(32) -- 流水号
    ,bfl_ecifno varchar2(32) -- 全行统一客户号
    ,bfl_userno varchar2(32) -- 录入操作员
    ,bfl_username varchar2(64) -- 录入操作员姓名
    ,bfl_valuedate varchar2(8) -- 预约日期
    ,bfl_currency varchar2(3) -- 币种
    ,bfl_payacc varchar2(32) -- 付款方账号
    ,bfl_payname varchar2(300) -- 付款方户名
    ,bfl_paynode varchar2(20) -- 付款方网点
    ,bfl_transauthtype varchar2(1) -- 安全工具类型
    ,bfl_totalcount number(4) -- 总笔数
    ,bfl_totalamount number(15,2) -- 总金额
    ,bfl_successcount number(4) -- 成功笔数
    ,bfl_successamount number(15,2) -- 成功金额
    ,bfl_failcount number(4) -- 失败笔数
    ,bfl_failamount number(15,2) -- 失败金额
    ,bfl_fee number(15,2) -- 费用
    ,bfl_transdate varchar2(8) -- 交易日期
    ,bfl_transtime varchar2(14) -- 交易时间
    ,bfl_schedulestarttime varchar2(14) -- 定时启动时间
    ,bfl_scheduleendtime varchar2(14) -- 定时结束时间
    ,bfl_bsncode varchar2(32) -- 交易代码
    ,bfl_stt varchar2(3) -- 批量状态
    ,bfl_filename varchar2(512) -- 文件名
    ,bfl_isnextday varchar2(1) -- 是否下一执行日
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_batch_flow to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_batch_flow to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_batch_flow to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_batch_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_batch_flow is '批量转账批次信息表';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_batchno is '批次号';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_trade_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_userno is '录入操作员';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_username is '录入操作员姓名';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_valuedate is '预约日期';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_payacc is '付款方账号';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_payname is '付款方户名';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_paynode is '付款方网点';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_transauthtype is '安全工具类型';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_totalcount is '总笔数';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_totalamount is '总金额';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_successcount is '成功笔数';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_successamount is '成功金额';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_failcount is '失败笔数';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_failamount is '失败金额';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_fee is '费用';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_transdate is '交易日期';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_transtime is '交易时间';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_schedulestarttime is '定时启动时间';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_scheduleendtime is '定时结束时间';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_bsncode is '交易代码';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_stt is '批量状态';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_filename is '文件名';
comment on column ${iol_schema}.tbps_cpr_batch_flow.bfl_isnextday is '是否下一执行日';
comment on column ${iol_schema}.tbps_cpr_batch_flow.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_batch_flow.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_batch_flow.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_batch_flow.etl_timestamp is 'ETL处理时间戳';
