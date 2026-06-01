/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_bssgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_bssgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_bssgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_bssgmt(
    top_deptcode varchar2(14) -- 顶级征信机构代码
    ,name varchar2(200) -- 姓名
    ,deptcode varchar2(14) -- 征信机构代码
    ,infsurccode varchar2(20) -- 信息来源编码
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,cimoc varchar2(14) -- 客户资料维护机构代码
    ,rptdate varchar2(19) -- 信息报告日期
    ,idtype varchar2(4) -- 证件类型
    ,create_time varchar2(19) -- 入库时间
    ,cust_no varchar2(32) -- 客户号码
    ,idnum varchar2(20) -- 证件号码
    ,infrectype varchar2(3) -- 信息记录类型
    ,customertype varchar2(4) -- 客户资料类型
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
grant select on ${iol_schema}.icms_credit_bssgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_bssgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_bssgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_bssgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_bssgmt is '个人基本信息记录-基础段';
comment on column ${iol_schema}.icms_credit_bssgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_bssgmt.name is '姓名';
comment on column ${iol_schema}.icms_credit_bssgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_bssgmt.infsurccode is '信息来源编码';
comment on column ${iol_schema}.icms_credit_bssgmt.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_credit_bssgmt.cimoc is '客户资料维护机构代码';
comment on column ${iol_schema}.icms_credit_bssgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_bssgmt.idtype is '证件类型';
comment on column ${iol_schema}.icms_credit_bssgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_bssgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_bssgmt.idnum is '证件号码';
comment on column ${iol_schema}.icms_credit_bssgmt.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_credit_bssgmt.customertype is '客户资料类型';
comment on column ${iol_schema}.icms_credit_bssgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_bssgmt.etl_timestamp is 'ETL处理时间戳';
