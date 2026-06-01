/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_aeuv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_aeuv
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_aeuv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_aeuv(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识
    ,sourdt varchar2(8) -- 源系统日期（sourst=glis时为业务日期）
    ,soursq varchar2(30) -- 源系统流水（sourst=glis时为总账业务流水）
    ,tranbr varchar2(12) -- 交易机构编号
    ,acetna varchar2(255) -- 分录名称（套账备注）
    ,trantp varchar2(9) -- 套账类别(1手工账2系统账)
    ,usercd varchar2(20) -- 用户代码
    ,psauus varchar2(20) -- 复核用户
    ,acsrnm number -- 附件张数
    ,dcmttp varchar2(10) -- 凭证类型
    ,remark varchar2(255) -- 备注
    ,prcscd varchar2(12) -- 处理码
    ,transt varchar2(1) -- 处理状态（1已入账0登记8流程审批中9已作废）
    ,trandt varchar2(8) -- 受理日期（入账日期）
    ,transq varchar2(20) -- 受理流水（入账流水）
    ,strkst varchar2(1) -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt varchar2(8) -- 原业务日期（被冲正业务日期）
    ,odbssq varchar2(20) -- 原业务流水（被冲正业务流水）
    ,wkflid number(19) -- 工作流id
    ,dcmtno varchar2(32) -- 凭证编号
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
grant select on ${iol_schema}.tgls_gla_aeuv to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_aeuv to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_aeuv is '会计分录';
comment on column ${iol_schema}.tgls_gla_aeuv.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_aeuv.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gla_aeuv.sourdt is '源系统日期（sourst=glis时为业务日期）';
comment on column ${iol_schema}.tgls_gla_aeuv.soursq is '源系统流水（sourst=glis时为总账业务流水）';
comment on column ${iol_schema}.tgls_gla_aeuv.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gla_aeuv.acetna is '分录名称（套账备注）';
comment on column ${iol_schema}.tgls_gla_aeuv.trantp is '套账类别(1手工账2系统账)';
comment on column ${iol_schema}.tgls_gla_aeuv.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_aeuv.psauus is '复核用户';
comment on column ${iol_schema}.tgls_gla_aeuv.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gla_aeuv.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gla_aeuv.remark is '备注';
comment on column ${iol_schema}.tgls_gla_aeuv.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gla_aeuv.transt is '处理状态（1已入账0登记8流程审批中9已作废）';
comment on column ${iol_schema}.tgls_gla_aeuv.trandt is '受理日期（入账日期）';
comment on column ${iol_schema}.tgls_gla_aeuv.transq is '受理流水（入账流水）';
comment on column ${iol_schema}.tgls_gla_aeuv.strkst is '冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_aeuv.odbsdt is '原业务日期（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_aeuv.odbssq is '原业务流水（被冲正业务流水）';
comment on column ${iol_schema}.tgls_gla_aeuv.wkflid is '工作流id';
comment on column ${iol_schema}.tgls_gla_aeuv.dcmtno is '凭证编号';
comment on column ${iol_schema}.tgls_gla_aeuv.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_aeuv.etl_timestamp is 'ETL处理时间戳';
