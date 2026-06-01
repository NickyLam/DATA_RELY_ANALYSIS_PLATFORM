/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_ecomplex_batch_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_ecomplex_batch_flow
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_ecomplex_batch_flow(
    ebf_batchno varchar2(20) -- 批次号
    ,ebf_batchdate varchar2(8) -- 提交日期
    ,ebf_upload_flowno varchar2(32) -- 文件上传流水号
    ,ebf_flowno varchar2(32) -- 提交交易流水号
    ,ebf_ecifno varchar2(32) -- 客户号
    ,ebf_userno varchar2(32) -- 用户序号
    ,ebf_accno varchar2(32) -- 账户序号
    ,ebf_showflag varchar2(2) -- 显示明细标识
    ,ebf_totalcount number(15,2) -- 总笔数
    ,ebf_totalamount number(15,2) -- 总金额
    ,ebf_transdate varchar2(8) -- 交易日期
    ,ebf_transtime varchar2(14) -- 交易时间
    ,ebf_filename varchar2(512) -- 文件名
    ,ebf_checkcount number(22) -- 检查条数
    ,ebf_checkerrorcount number(22) -- 错误条数
    ,ebf_checkstatus varchar2(1) -- 校验状态（0-校验成功，1-校验失败，2-校验中）
    ,ebf_batchstate varchar2(2) -- 批次状态
    ,ebf_operater varchar2(1) -- 操作类型:1-退税
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
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_flow to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_flow to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_flow to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_ecomplex_batch_flow is '批量转账五万以下批次信息表';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_batchno is '批次号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_batchdate is '提交日期';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_upload_flowno is '文件上传流水号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_flowno is '提交交易流水号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_ecifno is '客户号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_userno is '用户序号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_accno is '账户序号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_showflag is '显示明细标识';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_totalcount is '总笔数';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_totalamount is '总金额';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_transdate is '交易日期';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_transtime is '交易时间';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_filename is '文件名';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_checkcount is '检查条数';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_checkerrorcount is '错误条数';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_checkstatus is '校验状态（0-校验成功，1-校验失败，2-校验中）';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_batchstate is '批次状态';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.ebf_operater is '操作类型:1-退税';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_flow.etl_timestamp is 'ETL处理时间戳';
