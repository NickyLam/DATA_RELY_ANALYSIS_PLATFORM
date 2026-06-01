/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_salary_batch_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_salary_batch_flow
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_salary_batch_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_salary_batch_flow(
    sbf_batchno varchar2(20) -- 批次号
    ,sbf_trade_flowno varchar2(32) -- 流水号
    ,sbf_month varchar2(6) -- 月份
    ,sbf_ecifno varchar2(32) -- 全行统一客户号
    ,sbf_userno varchar2(32) -- 用户顺序号
    ,sbf_username varchar2(100) -- 用户名
    ,sbf_payeracno varchar2(40) -- 付款人账号
    ,sbf_payeracname varchar2(500) -- 付款人户名
    ,sbf_currency varchar2(3) -- 币种
    ,sbf_totalcount number(22) -- 总笔数
    ,sbf_totalamount number(15,2) -- 总金额
    ,sbf_uploadfilename varchar2(512) -- 上传文件名
    ,sbf_filename varchar2(128) -- 文件名
    ,sbf_orderflag varchar2(1) -- 是否预约：0：否；1：是
    ,sbf_batchstyle varchar2(1) -- 批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资
    ,sbf_sysflag varchar2(1) -- 行内外标识：0：行内 1：行外
    ,sbf_transdate varchar2(8) -- 交易日期/提交日期
    ,sbf_transtime varchar2(14) -- 交易时间/提交时间
    ,sbf_processendtime varchar2(14) -- 中台处理时间
    ,sbf_timerrule varchar2(14) -- 预约时间(行内和行外发工资的预约时间)
    ,sbf_successcount number(22) -- 成功笔数
    ,sbf_successamount number(15,2) -- 成功金额
    ,sbf_failcount number(22) -- 失败笔数
    ,sbf_failamount number(15,2) -- 失败金额
    ,sbf_remark varchar2(128) -- 附言
    ,sbf_batchstate varchar2(1) -- 状态
    ,sbf_returncode varchar2(128) -- 返回码
    ,sbf_returnmsg varchar2(512) -- 返回信息
    ,sbf_hostremark varchar2(512) -- 核心附言
    ,sbf_hostbatchno varchar2(20) -- 核心批次号
    ,sbf_showflag varchar2(1) -- 是否显示明细
    ,sbf_parentlogno varchar2(32) -- 父流水号
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
grant select on ${iol_schema}.tbps_cpr_salary_batch_flow to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_flow to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_flow to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_salary_batch_flow is '代发工资批次表';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_batchno is '批次号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_trade_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_month is '月份';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_username is '用户名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_payeracno is '付款人账号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_payeracname is '付款人户名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_totalcount is '总笔数';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_totalamount is '总金额';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_uploadfilename is '上传文件名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_filename is '文件名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_orderflag is '是否预约：0：否；1：是';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_batchstyle is '批量类型：0：行内发工资；1：报销；2：行外发工资 3：行内外发工资';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_sysflag is '行内外标识：0：行内 1：行外';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_transdate is '交易日期/提交日期';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_transtime is '交易时间/提交时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_processendtime is '中台处理时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_timerrule is '预约时间(行内和行外发工资的预约时间)';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_successcount is '成功笔数';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_successamount is '成功金额';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_failcount is '失败笔数';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_failamount is '失败金额';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_remark is '附言';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_batchstate is '状态';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_returncode is '返回码';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_returnmsg is '返回信息';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_hostremark is '核心附言';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_hostbatchno is '核心批次号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_showflag is '是否显示明细';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.sbf_parentlogno is '父流水号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_salary_batch_flow.etl_timestamp is 'ETL处理时间戳';
