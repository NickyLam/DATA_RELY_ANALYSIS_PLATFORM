/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_tps_batch_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_tps_batch_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_tps_batch_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_tps_batch_flow(
    tbf_batchno varchar2(32) -- 批次号
    ,tbf_flowno varchar2(64) -- 流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)
    ,tbf_ecifno varchar2(32) -- 客户号
    ,tbf_userno varchar2(32) -- 用户号
    ,tbf_deptid varchar2(32) -- 部门ID
    ,tbf_transauthtype varchar2(1) -- 安全工具类型(1-U盾,2-手机动态密码)
    ,tbf_authtype varchar2(1) -- 授权类型(R:自助注册,G:安全认证方式)
    ,tbf_totalcount number(20) -- 总笔数
    ,tbf_totalamount number(20,2) -- 总金额
    ,tbf_successcount number(20) -- 成功次数
    ,tbf_successamount number(20,2) -- 成功金额
    ,tbf_failcount number(20) -- 失败次数
    ,tbf_failamount number(20,2) -- 失败金额
    ,tbf_transdate varchar2(14) -- 交易日期
    ,tbf_transtime varchar2(14) -- 交易时间戳
    ,tbf_schedulestarttime varchar2(14) -- 定时开始时间
    ,tbf_scheduleendtime varchar2(14) -- 定时结束时间
    ,tbf_transcode varchar2(32) -- 交易码
    ,tbf_batchstate varchar2(3) -- I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销
    ,tbf_batchtype varchar2(1) -- 批量类型(I-手工录入,F-文件导入)
    ,tbf_filename varchar2(120) -- 文件名
    ,tbf_isnextday varchar2(2) -- 是否下一日期(N/空-否,Y-是)
    ,tbf_transfertype varchar2(30) -- 转出方式:todayFlag-当日转账;otherFlag-其他时间
    ,tbf_transferdate varchar2(8) -- 转出日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.osbs_tps_batch_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_tps_batch_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_tps_batch_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_tps_batch_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_tps_batch_flow is '协议信息表';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_batchno is '批次号';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_flowno is '流水号(关联表PUB_TRADE_FLOW的PTF_TRADE_FLOWNO)';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_ecifno is '客户号';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_userno is '用户号';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_deptid is '部门ID';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transauthtype is '安全工具类型(1-U盾,2-手机动态密码)';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_authtype is '授权类型(R:自助注册,G:安全认证方式)';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_totalcount is '总笔数';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_totalamount is '总金额';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_successcount is '成功次数';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_successamount is '成功金额';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_failcount is '失败次数';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_failamount is '失败金额';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transdate is '交易日期';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transtime is '交易时间戳';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_schedulestarttime is '定时开始时间';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_scheduleendtime is '定时结束时间';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transcode is '交易码';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_batchstate is 'I-入库，等待跑批,L-结果未明，正在跑批,S-转账成功,U-结果未明,F-转账失败,C-批量预约已撤销';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_batchtype is '批量类型(I-手工录入,F-文件导入)';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_filename is '文件名';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_isnextday is '是否下一日期(N/空-否,Y-是)';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transfertype is '转出方式:todayFlag-当日转账;otherFlag-其他时间';
comment on column ${iol_schema}.osbs_tps_batch_flow.tbf_transferdate is '转出日期';
comment on column ${iol_schema}.osbs_tps_batch_flow.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_tps_batch_flow.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_tps_batch_flow.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_tps_batch_flow.etl_timestamp is 'ETL处理时间戳';
