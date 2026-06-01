/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txa_vchr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txa_vchr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txa_vchr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txa_vchr(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(50) -- 交易流水
    ,vchrsq varchar2(30) -- 传票序号
    ,tranbr varchar2(12) -- 交易机构编号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码（原币）
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,trantp varchar2(9) -- 交易类型
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额（原币）
    ,smrytx varchar2(400) -- 摘要
    ,exchcn number(15,8) -- 中间价
    ,exchus number(15,8) -- 折算汇率
    ,usercd varchar2(20) -- 用户代码
    ,toitem varchar2(30) -- 对方科目编号
    ,assis0 varchar2(30) -- 辅助核算0（自定义）
    ,assis1 varchar2(30) -- 辅助核算1（自定义）
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,transt varchar2(1) -- 交易状态
    ,trsdam number(20,2) -- 交易金额（本位币）
    ,crcysd varchar2(3) -- 币种代码（本位币）
    ,sperdt varchar2(8) -- 价税分离日期
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
grant select on ${iol_schema}.tgls_txa_vchr to ${iml_schema};
grant select on ${iol_schema}.tgls_txa_vchr to ${icl_schema};
grant select on ${iol_schema}.tgls_txa_vchr to ${idl_schema};
grant select on ${iol_schema}.tgls_txa_vchr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txa_vchr is '会计分录表';
comment on column ${iol_schema}.tgls_txa_vchr.stacid is '账套标记';
comment on column ${iol_schema}.tgls_txa_vchr.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_txa_vchr.trandt is '交易日期';
comment on column ${iol_schema}.tgls_txa_vchr.transq is '交易流水';
comment on column ${iol_schema}.tgls_txa_vchr.vchrsq is '传票序号';
comment on column ${iol_schema}.tgls_txa_vchr.tranbr is '交易机构编号';
comment on column ${iol_schema}.tgls_txa_vchr.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_txa_vchr.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_txa_vchr.crcycd is '币种代码（原币）';
comment on column ${iol_schema}.tgls_txa_vchr.centcd is '责任中心';
comment on column ${iol_schema}.tgls_txa_vchr.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_txa_vchr.custcd is '客户编号';
comment on column ${iol_schema}.tgls_txa_vchr.prducd is '产品编号';
comment on column ${iol_schema}.tgls_txa_vchr.prlncd is '产品线';
comment on column ${iol_schema}.tgls_txa_vchr.acctno is '账户';
comment on column ${iol_schema}.tgls_txa_vchr.trantp is '交易类型';
comment on column ${iol_schema}.tgls_txa_vchr.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_txa_vchr.tranam is '交易金额（原币）';
comment on column ${iol_schema}.tgls_txa_vchr.smrytx is '摘要';
comment on column ${iol_schema}.tgls_txa_vchr.exchcn is '中间价';
comment on column ${iol_schema}.tgls_txa_vchr.exchus is '折算汇率';
comment on column ${iol_schema}.tgls_txa_vchr.usercd is '用户代码';
comment on column ${iol_schema}.tgls_txa_vchr.toitem is '对方科目编号';
comment on column ${iol_schema}.tgls_txa_vchr.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_txa_vchr.transt is '交易状态';
comment on column ${iol_schema}.tgls_txa_vchr.trsdam is '交易金额（本位币）';
comment on column ${iol_schema}.tgls_txa_vchr.crcysd is '币种代码（本位币）';
comment on column ${iol_schema}.tgls_txa_vchr.sperdt is '价税分离日期';
comment on column ${iol_schema}.tgls_txa_vchr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_txa_vchr.etl_timestamp is 'ETL处理时间戳';
