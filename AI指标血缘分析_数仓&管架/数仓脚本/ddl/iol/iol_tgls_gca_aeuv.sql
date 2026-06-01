/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gca_aeuv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gca_aeuv
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gca_aeuv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gca_aeuv(
    stacid number(19) -- 账套标识
    ,systid varchar2(4) -- 系统标识
    ,bsnsdt varchar2(8) -- 业务日期
    ,bsnssq varchar2(33) -- 业务流水号
    ,tranbr varchar2(12) -- 交易机构编号
    ,acetna varchar2(50) -- 分录名称
    ,usercd varchar2(20) -- 用户代码
    ,psauus varchar2(20) -- 复核用户
    ,remark varchar2(255) -- 备注
    ,prcscd varchar2(12) -- 处理码
    ,transt varchar2(1) -- 处理状态（1已入账0登记8流程审批中9已作废）
    ,trandt varchar2(8) -- 交易日期（入账日期）
    ,transq varchar2(20) -- 交易流水（入账流水）
    ,strkst varchar2(1) -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt varchar2(8) -- 原业务日期
    ,odbssq varchar2(33) -- 原业务流水号
    ,wkflid number(19) -- 工作流id
    ,trantp varchar2(1) -- 交易类型(1-手工账，2-系统账)
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
grant select on ${iol_schema}.tgls_gca_aeuv to ${iml_schema};
grant select on ${iol_schema}.tgls_gca_aeuv to ${icl_schema};
grant select on ${iol_schema}.tgls_gca_aeuv to ${idl_schema};
grant select on ${iol_schema}.tgls_gca_aeuv to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gca_aeuv is '手动抵消分录';
comment on column ${iol_schema}.tgls_gca_aeuv.stacid is '账套标识';
comment on column ${iol_schema}.tgls_gca_aeuv.systid is '系统标识';
comment on column ${iol_schema}.tgls_gca_aeuv.bsnsdt is '业务日期';
comment on column ${iol_schema}.tgls_gca_aeuv.bsnssq is '业务流水号';
comment on column ${iol_schema}.tgls_gca_aeuv.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gca_aeuv.acetna is '分录名称';
comment on column ${iol_schema}.tgls_gca_aeuv.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gca_aeuv.psauus is '复核用户';
comment on column ${iol_schema}.tgls_gca_aeuv.remark is '备注';
comment on column ${iol_schema}.tgls_gca_aeuv.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gca_aeuv.transt is '处理状态（1已入账0登记8流程审批中9已作废）';
comment on column ${iol_schema}.tgls_gca_aeuv.trandt is '交易日期（入账日期）';
comment on column ${iol_schema}.tgls_gca_aeuv.transq is '交易流水（入账流水）';
comment on column ${iol_schema}.tgls_gca_aeuv.strkst is '冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gca_aeuv.odbsdt is '原业务日期';
comment on column ${iol_schema}.tgls_gca_aeuv.odbssq is '原业务流水号';
comment on column ${iol_schema}.tgls_gca_aeuv.wkflid is '工作流id';
comment on column ${iol_schema}.tgls_gca_aeuv.trantp is '交易类型(1-手工账，2-系统账)';
comment on column ${iol_schema}.tgls_gca_aeuv.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gca_aeuv.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gca_aeuv.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gca_aeuv.etl_timestamp is 'ETL处理时间戳';
