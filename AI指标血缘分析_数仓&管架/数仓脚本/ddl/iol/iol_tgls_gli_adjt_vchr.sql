/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gli_adjt_vchr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gli_adjt_vchr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gli_adjt_vchr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gli_adjt_vchr(
    stacid number(19) -- 账套
    ,sourst varchar2(4) -- 源系统标识（ltts-综合业务acct-财务）
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号（凭证号）
    ,vchrsq varchar2(30) -- 传票流水
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,centcd varchar2(16) -- 责任中心辅助核算
    ,prsncd varchar2(16) -- 职员辅助核算
    ,custcd varchar2(16) -- 客户辅助核算
    ,prducd varchar2(16) -- 产品辅助核算
    ,prlncd varchar2(16) -- 产品线辅助核算
    ,acctno varchar2(30) -- 账户辅助核算
    ,amntcd varchar2(9) -- 借贷方向（d:借(收)c:贷(付)）
    ,tranam number(20,2) -- 交易金额
    ,smrytx varchar2(400) -- 摘要
    ,usercd varchar2(20) -- 用户代码
    ,transt varchar2(1) -- 处理状态（1已处理0未处理9出错）
    ,trandt varchar2(8) -- 交易日期（总账入账日期）
    ,transq varchar2(20) -- 交易流水（总账入账流水）
    ,assis0 varchar2(30) -- 辅助核算0
    ,assis1 varchar2(30) -- 辅助核算1
    ,assis2 varchar2(30) -- 辅助核算2
    ,assis3 varchar2(30) -- 辅助核算3
    ,assis4 varchar2(30) -- 辅助核算4
    ,assis5 varchar2(30) -- 辅助核算5
    ,assis6 varchar2(30) -- 辅助核算6
    ,assis7 varchar2(30) -- 辅助核算7
    ,assis8 varchar2(30) -- 辅助核算8
    ,assis9 varchar2(30) -- 辅助核算9
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
grant select on ${iol_schema}.tgls_gli_adjt_vchr to ${iml_schema};
grant select on ${iol_schema}.tgls_gli_adjt_vchr to ${icl_schema};
grant select on ${iol_schema}.tgls_gli_adjt_vchr to ${idl_schema};
grant select on ${iol_schema}.tgls_gli_adjt_vchr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gli_adjt_vchr is '审计调账外围传票';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.stacid is '账套';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.sourst is '源系统标识（ltts-综合业务acct-财务）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.soursq is '源系统流水号（凭证号）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.vchrsq is '传票流水';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.centcd is '责任中心辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.prsncd is '职员辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.custcd is '客户辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.prducd is '产品辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.prlncd is '产品线辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.acctno is '账户辅助核算';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.amntcd is '借贷方向（d:借(收)c:贷(付)）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.transt is '处理状态（1已处理0未处理9出错）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.trandt is '交易日期（总账入账日期）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.transq is '交易流水（总账入账流水）';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis0 is '辅助核算0';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis1 is '辅助核算1';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis2 is '辅助核算2';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis3 is '辅助核算3';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis4 is '辅助核算4';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis5 is '辅助核算5';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis6 is '辅助核算6';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis7 is '辅助核算7';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis8 is '辅助核算8';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.assis9 is '辅助核算9';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gli_adjt_vchr.etl_timestamp is 'ETL处理时间戳';
