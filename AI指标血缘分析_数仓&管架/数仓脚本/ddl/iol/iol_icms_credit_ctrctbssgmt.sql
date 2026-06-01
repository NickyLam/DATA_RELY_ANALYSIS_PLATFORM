/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_ctrctbssgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_ctrctbssgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_ctrctbssgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_ctrctbssgmt(
    name varchar2(200) -- 受信人姓名
    ,rptdate varchar2(19) -- 信息报告日期
    ,rptdatecode varchar2(4) -- 报告时点说明代码
    ,idtype varchar2(20) -- 受信人证件类型
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,infrectype varchar2(3) -- 信息记录类型
    ,deptcode varchar2(14) -- 征信机构代码
    ,mngmtorgcode varchar2(14) -- 业务管理机构代码
    ,create_time varchar2(19) -- 入库时间
    ,cust_no varchar2(32) -- 客户号码
    ,contractcode varchar2(80) -- 授信协议标识码
    ,idnum varchar2(20) -- 受信人证件号码
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
grant select on ${iol_schema}.icms_credit_ctrctbssgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_ctrctbssgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_ctrctbssgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_ctrctbssgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_ctrctbssgmt is '个人授信协议信息记录-基础段';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.name is '受信人姓名';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.rptdatecode is '报告时点说明代码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.idtype is '受信人证件类型';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.infrectype is '信息记录类型';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.mngmtorgcode is '业务管理机构代码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.contractcode is '授信协议标识码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.idnum is '受信人证件号码';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_ctrctbssgmt.etl_timestamp is 'ETL处理时间戳';
