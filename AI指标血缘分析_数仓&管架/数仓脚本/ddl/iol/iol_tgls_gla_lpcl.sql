/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_lpcl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_lpcl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_lpcl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_lpcl(
    stacid number(19) -- 账套标记
    ,systid varchar2(4) -- 源系统标识（ltts-综合业务acct-财务）
    ,sourdt varchar2(8) -- 源系统日期（结转日期）
    ,brchcd varchar2(12) -- 机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
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
    ,crcycd varchar2(3) -- 币种代码
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,transt varchar2(1) -- 处理状态（或结转状态1已处理0未处理）
    ,geldtp varchar2(1) -- 统计频度（m月、q季、h半年、y年）
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
grant select on ${iol_schema}.tgls_gla_lpcl to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_lpcl to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_lpcl to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_lpcl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_lpcl is '损益结转信息';
comment on column ${iol_schema}.tgls_gla_lpcl.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_lpcl.systid is '源系统标识（ltts-综合业务acct-财务）';
comment on column ${iol_schema}.tgls_gla_lpcl.sourdt is '源系统日期（结转日期）';
comment on column ${iol_schema}.tgls_gla_lpcl.brchcd is '机构编号';
comment on column ${iol_schema}.tgls_gla_lpcl.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_lpcl.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_lpcl.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_lpcl.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_lpcl.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_lpcl.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_lpcl.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_lpcl.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_lpcl.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_lpcl.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gla_lpcl.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_lpcl.transt is '处理状态（或结转状态1已处理0未处理）';
comment on column ${iol_schema}.tgls_gla_lpcl.geldtp is '统计频度（m月、q季、h半年、y年）';
comment on column ${iol_schema}.tgls_gla_lpcl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_lpcl.etl_timestamp is 'ETL处理时间戳';
