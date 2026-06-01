/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_aeuv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_aeuv
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_aeuv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_aeuv(
    aeuvid number(19) -- 分录id
    ,stacid number(19) -- 帐套id
    ,bsnsdt varchar2(8) -- 业务日期
    ,bsnssq varchar2(33) -- 业务流水号
    ,entrsq number(5) -- 交易流水
    ,tranbr varchar2(12) -- 交易日期
    ,acetna varchar2(50) -- 分录名称
    ,trantp varchar2(9) -- 交易类型
    ,crcycd varchar2(3) -- 币种
    ,usercd varchar2(20) -- 操作员
    ,psauus varchar2(20) -- 复核员
    ,acsrnm number -- 附件张数
    ,dcmtno varchar2(30) -- 凭证号码
    ,dcmttp varchar2(10) -- 凭证类型
    ,remark varchar2(255) -- 备注
    ,prcscd varchar2(12) -- 处理码
    ,transt varchar2(1) -- 处理状态（1已入账0登记8流程审批中9已作废）
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(20) -- 交易流水
    ,strkst varchar2(1) -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt varchar2(8) -- 原业务日期（被冲正业务日期）
    ,odbssq varchar2(33) -- 原业务流水号（被冲正业务日期）
    ,odensq number(5) -- 原入账序号（被冲正入账序号）
    ,acetsr varchar2(1) -- 分录来源（0手工录入1入账平台2账务冲正）
    ,wkflid number(19) -- 工作流id
    ,odtrdt varchar2(8) -- 原交易日期（被冲正交易日期）
    ,odtrsq varchar2(8) -- 原交易流水（被冲正交易日期）
    ,cgresn varchar2(255) -- 冲销原因
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
grant select on ${iol_schema}.tgls_gab_aeuv to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_aeuv to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_aeuv to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_aeuv to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_aeuv is '审计调账分录主表';
comment on column ${iol_schema}.tgls_gab_aeuv.aeuvid is '分录id';
comment on column ${iol_schema}.tgls_gab_aeuv.stacid is '帐套id';
comment on column ${iol_schema}.tgls_gab_aeuv.bsnsdt is '业务日期';
comment on column ${iol_schema}.tgls_gab_aeuv.bsnssq is '业务流水号';
comment on column ${iol_schema}.tgls_gab_aeuv.entrsq is '交易流水';
comment on column ${iol_schema}.tgls_gab_aeuv.tranbr is '交易日期';
comment on column ${iol_schema}.tgls_gab_aeuv.acetna is '分录名称';
comment on column ${iol_schema}.tgls_gab_aeuv.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gab_aeuv.crcycd is '币种';
comment on column ${iol_schema}.tgls_gab_aeuv.usercd is '操作员';
comment on column ${iol_schema}.tgls_gab_aeuv.psauus is '复核员';
comment on column ${iol_schema}.tgls_gab_aeuv.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gab_aeuv.dcmtno is '凭证号码';
comment on column ${iol_schema}.tgls_gab_aeuv.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gab_aeuv.remark is '备注';
comment on column ${iol_schema}.tgls_gab_aeuv.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gab_aeuv.transt is '处理状态（1已入账0登记8流程审批中9已作废）';
comment on column ${iol_schema}.tgls_gab_aeuv.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gab_aeuv.transq is '交易流水';
comment on column ${iol_schema}.tgls_gab_aeuv.strkst is '冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gab_aeuv.odbsdt is '原业务日期（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gab_aeuv.odbssq is '原业务流水号（被冲正业务日期）';
comment on column ${iol_schema}.tgls_gab_aeuv.odensq is '原入账序号（被冲正入账序号）';
comment on column ${iol_schema}.tgls_gab_aeuv.acetsr is '分录来源（0手工录入1入账平台2账务冲正）';
comment on column ${iol_schema}.tgls_gab_aeuv.wkflid is '工作流id';
comment on column ${iol_schema}.tgls_gab_aeuv.odtrdt is '原交易日期（被冲正交易日期）';
comment on column ${iol_schema}.tgls_gab_aeuv.odtrsq is '原交易流水（被冲正交易日期）';
comment on column ${iol_schema}.tgls_gab_aeuv.cgresn is '冲销原因';
comment on column ${iol_schema}.tgls_gab_aeuv.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_aeuv.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_aeuv.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_aeuv.etl_timestamp is 'ETL处理时间戳';
