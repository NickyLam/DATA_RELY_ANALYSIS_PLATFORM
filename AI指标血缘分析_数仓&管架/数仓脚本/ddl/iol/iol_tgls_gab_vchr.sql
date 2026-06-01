/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gab_vchr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gab_vchr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gab_vchr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gab_vchr(
    stacid number(19) -- 账套
    ,sourdt varchar2(8) -- 交易日期
    ,soursq varchar2(30) -- 交易流水
    ,vchrsq varchar2(20) -- 传票流水
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,centcd varchar2(16) -- 责任中心辅助核算
    ,prsncd varchar2(16) -- 职员辅助核算
    ,custcd varchar2(16) -- 客户辅助核算
    ,prducd varchar2(16) -- 产品辅助核算
    ,prlncd varchar2(16) -- 产品线辅助核算
    ,acctno varchar2(30) -- 账户辅助核算
    ,trantp varchar2(9) -- 交易类型（tr,cs）
    ,amntcd varchar2(9) -- 借贷方向（d:借(收)c:贷(付)）
    ,tranam number(20,2) -- 交易金额
    ,trannm number -- 交易笔数
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,usercd varchar2(20) -- 用户代码
    ,toitem varchar2(30) -- 对方科目编号
    ,transt varchar2(1) -- 处理状态（1已处理0未处理）
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2
    ,assis3 varchar2(30) -- 辅助核算3
    ,assis4 varchar2(30) -- 辅助核算4
    ,assis5 varchar2(30) -- 辅助核算5
    ,assis6 varchar2(30) -- 辅助核算6
    ,assis7 varchar2(30) -- 辅助核算7
    ,assis8 varchar2(30) -- 辅助核算8
    ,assis9 varchar2(30) -- 辅助核算9
    ,trandt varchar2(8) -- 维护日期
    ,transq varchar2(30) -- 维护流水
    ,acctdt varchar2(8) -- 账务会计日期
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
grant select on ${iol_schema}.tgls_gab_vchr to ${iml_schema};
grant select on ${iol_schema}.tgls_gab_vchr to ${icl_schema};
grant select on ${iol_schema}.tgls_gab_vchr to ${idl_schema};
grant select on ${iol_schema}.tgls_gab_vchr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gab_vchr is '审计调账凭证';
comment on column ${iol_schema}.tgls_gab_vchr.stacid is '账套';
comment on column ${iol_schema}.tgls_gab_vchr.sourdt is '交易日期';
comment on column ${iol_schema}.tgls_gab_vchr.soursq is '交易流水';
comment on column ${iol_schema}.tgls_gab_vchr.vchrsq is '传票流水';
comment on column ${iol_schema}.tgls_gab_vchr.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_gab_vchr.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gab_vchr.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gab_vchr.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gab_vchr.centcd is '责任中心辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.prsncd is '职员辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.custcd is '客户辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.prducd is '产品辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.prlncd is '产品线辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.acctno is '账户辅助核算';
comment on column ${iol_schema}.tgls_gab_vchr.trantp is '交易类型（tr,cs）';
comment on column ${iol_schema}.tgls_gab_vchr.amntcd is '借贷方向（d:借(收)c:贷(付)）';
comment on column ${iol_schema}.tgls_gab_vchr.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gab_vchr.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_gab_vchr.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gab_vchr.exchcn is '中间价';
comment on column ${iol_schema}.tgls_gab_vchr.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_gab_vchr.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gab_vchr.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_gab_vchr.transt is '处理状态（1已处理0未处理）';
comment on column ${iol_schema}.tgls_gab_vchr.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gab_vchr.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gab_vchr.assis2 is '辅助核算2';
comment on column ${iol_schema}.tgls_gab_vchr.assis3 is '辅助核算3';
comment on column ${iol_schema}.tgls_gab_vchr.assis4 is '辅助核算4';
comment on column ${iol_schema}.tgls_gab_vchr.assis5 is '辅助核算5';
comment on column ${iol_schema}.tgls_gab_vchr.assis6 is '辅助核算6';
comment on column ${iol_schema}.tgls_gab_vchr.assis7 is '辅助核算7';
comment on column ${iol_schema}.tgls_gab_vchr.assis8 is '辅助核算8';
comment on column ${iol_schema}.tgls_gab_vchr.assis9 is '辅助核算9';
comment on column ${iol_schema}.tgls_gab_vchr.trandt is '维护日期';
comment on column ${iol_schema}.tgls_gab_vchr.transq is '维护流水';
comment on column ${iol_schema}.tgls_gab_vchr.acctdt is '账务会计日期';
comment on column ${iol_schema}.tgls_gab_vchr.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gab_vchr.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gab_vchr.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gab_vchr.etl_timestamp is 'ETL处理时间戳';
