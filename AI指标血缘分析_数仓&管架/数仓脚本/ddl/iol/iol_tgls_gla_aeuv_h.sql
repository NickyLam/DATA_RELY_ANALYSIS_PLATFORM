/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_aeuv_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_aeuv_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_aeuv_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_aeuv_h(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识（ltts综合业务系统acct财务系统glis总账系统）
    ,sourdt varchar2(8) -- 源系统日期（sourst=glis时为业务日期）
    ,soursq varchar2(64) -- 源系统流水号（sourst=glis时为总账业务流水）
    ,tranbr varchar2(16) -- 交易机构
    ,acetna varchar2(50) -- 分录名称
    ,trantp varchar2(9) -- 交易类型（tr－转帐,cs－现金）
    ,crcycd varchar2(3) -- 币种代码
    ,usercd varchar2(20) -- 用户代码
    ,psauus varchar2(20) -- 复核用户
    ,acsrnm number -- 附件张数
    ,dcmtno varchar2(30) -- 凭证号码
    ,dcmttp varchar2(10) -- 凭证类型
    ,remark varchar2(255) -- 备注
    ,prcscd varchar2(12) -- 处理码
    ,transt varchar2(1) -- 处理状态（1已处理0未处理8流程审批中9已作废）
    ,trandt varchar2(8) -- 交易日期（总账入账日期）
    ,transq varchar2(20) -- 交易流水（总账入账流水）
    ,strkst varchar2(1) -- 冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt varchar2(8) -- 原业务日期（被冲正业务日期）
    ,odbssq varchar2(33) -- 原业务流水号（被冲正业务日期）
    ,wkflid number(19) -- 工作流id
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
grant select on ${iol_schema}.tgls_gla_aeuv_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_aeuv_h is '会计分录历史';
comment on column ${iol_schema}.tgls_gla_aeuv_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_aeuv_h.sourst is '源系统标识（ltts综合业务系统acct财务系统glis总账系统）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.sourdt is '源系统日期（sourst=glis时为业务日期）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.soursq is '源系统流水号（sourst=glis时为总账业务流水）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_gla_aeuv_h.acetna is '分录名称';
comment on column ${iol_schema}.tgls_gla_aeuv_h.trantp is '交易类型（tr－转帐,cs－现金）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_aeuv_h.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_aeuv_h.psauus is '复核用户';
comment on column ${iol_schema}.tgls_gla_aeuv_h.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gla_aeuv_h.dcmtno is '凭证号码';
comment on column ${iol_schema}.tgls_gla_aeuv_h.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gla_aeuv_h.remark is '备注';
comment on column ${iol_schema}.tgls_gla_aeuv_h.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gla_aeuv_h.transt is '处理状态（1已处理0未处理8流程审批中9已作废）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.trandt is '交易日期（总账入账日期）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.transq is '交易流水（总账入账流水）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.strkst is '冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.odbsdt is '原业务日期（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.odbssq is '原业务流水号（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gla_aeuv_h.wkflid is '工作流id';
comment on column ${iol_schema}.tgls_gla_aeuv_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_aeuv_h.etl_timestamp is 'ETL处理时间戳';
