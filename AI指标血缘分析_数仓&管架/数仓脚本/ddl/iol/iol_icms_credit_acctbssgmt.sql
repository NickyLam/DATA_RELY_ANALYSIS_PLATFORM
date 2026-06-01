/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctbssgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctbssgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctbssgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctbssgmt(
    topdeptcode varchar2(14) -- 顶级征信机构代码
    ,extrainfo varchar2(2000) -- 拓展字段
    ,acctcode varchar2(60) -- 账户标识码
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,custno varchar2(64) -- 客户号码
    ,deptcode varchar2(14) -- 征信机构代码
    ,mngmtorgcode varchar2(100) -- 业务管理机构代码
    ,idnum varchar2(20) -- 借款人证件号码
    ,rptdate varchar2(19) -- 信息报告日期
    ,name varchar2(200) -- 借款人姓名
    ,infrectype varchar2(3) -- 信息记录类型
    ,createtime varchar2(19) -- 入库日期
    ,accttype varchar2(6) -- 账户类型
    ,idtype varchar2(20) -- 借款人证件类型
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
grant select on ${iol_schema}.icms_credit_acctbssgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctbssgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctbssgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctbssgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctbssgmt is '';
comment on column ${iol_schema}.icms_credit_acctbssgmt.topdeptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.extrainfo is '拓展字段';
comment on column ${iol_schema}.icms_credit_acctbssgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.custno is '客户号码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.idnum is '借款人证件号码';
comment on column ${iol_schema}.icms_credit_acctbssgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctbssgmt.name is '借款人姓名';
comment on column ${iol_schema}.icms_credit_acctbssgmt.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_credit_acctbssgmt.createtime is '入库日期';
comment on column ${iol_schema}.icms_credit_acctbssgmt.accttype is '账户类型';
comment on column ${iol_schema}.icms_credit_acctbssgmt.idtype is '借款人证件类型';
comment on column ${iol_schema}.icms_credit_acctbssgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctbssgmt.etl_timestamp is 'ETL处理时间戳';
