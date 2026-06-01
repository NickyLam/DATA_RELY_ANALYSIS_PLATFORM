/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_tran
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_tran(
    stacid number(19) -- 帐套id
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(20) -- 交易流水
    ,tranti timestamp -- 交易时间
    ,tranbr varchar2(12) -- 交易机构编号
    ,usercd varchar2(20) -- 用户代码
    ,acctbr varchar2(12) -- 账务机构编号
    ,bsnsdt varchar2(8) -- 业务日期
    ,bsnssq varchar2(33) -- 业务流水
    ,entrsq number(5) -- 入账流水
    ,trantp varchar2(9) -- 交易类型
    ,crcycd varchar2(3) -- 币种
    ,dcmtno varchar2(30) -- 凭证号码
    ,dcmttp varchar2(10) -- 凭证类型
    ,prcscd varchar2(12) -- 原交易处理码
    ,tranam number(20,2) -- 原值变动交易金额
    ,itemcd varchar2(30) -- 总账科目编号
    ,psauus varchar2(20) -- 授权柜员
    ,strkst varchar2(1) -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odtrdt varchar2(8) -- 原交易日期（被冲正交易日期）
    ,odtrsq varchar2(20) -- 原交易流水串（被冲正交流流水）
    ,acsrnm number -- 附件张数
    ,remark varchar2(400) -- 摘要
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
grant select on ${iol_schema}.tgls_gab_tran to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_tran to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_tran to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_tran is '交易流水（审计调账）';
comment on column ${iol_schema}.tgls_gab_tran.stacid is '帐套id';
comment on column ${iol_schema}.tgls_gab_tran.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gab_tran.transq is '交易流水';
comment on column ${iol_schema}.tgls_gab_tran.tranti is '交易时间';
comment on column ${iol_schema}.tgls_gab_tran.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gab_tran.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gab_tran.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gab_tran.bsnsdt is '业务日期';
comment on column ${iol_schema}.tgls_gab_tran.bsnssq is '业务流水';
comment on column ${iol_schema}.tgls_gab_tran.entrsq is '入账流水';
comment on column ${iol_schema}.tgls_gab_tran.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gab_tran.crcycd is '币种';
comment on column ${iol_schema}.tgls_gab_tran.dcmtno is '凭证号码';
comment on column ${iol_schema}.tgls_gab_tran.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gab_tran.prcscd is '原交易处理码';
comment on column ${iol_schema}.tgls_gab_tran.tranam is '原值变动交易金额';
comment on column ${iol_schema}.tgls_gab_tran.itemcd is '总账科目编号';
comment on column ${iol_schema}.tgls_gab_tran.psauus is '授权柜员';
comment on column ${iol_schema}.tgls_gab_tran.strkst is '冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gab_tran.odtrdt is '原交易日期（被冲正交易日期）';
comment on column ${iol_schema}.tgls_gab_tran.odtrsq is '原交易流水串（被冲正交流流水）';
comment on column ${iol_schema}.tgls_gab_tran.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gab_tran.remark is '摘要';
comment on column ${iol_schema}.tgls_gab_tran.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_tran.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_tran.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_tran.etl_timestamp is 'ETL处理时间戳';
