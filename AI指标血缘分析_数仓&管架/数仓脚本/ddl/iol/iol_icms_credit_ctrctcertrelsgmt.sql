/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_ctrctcertrelsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_ctrctcertrelsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_ctrctcertrelsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_ctrctcertrelsgmt(
    contractcode varchar2(60) -- 授信协议标识码
    ,certrelidnum varchar2(40) -- 共同受信人身份标识号码
    ,certrelidtype varchar2(4) -- 共同受信人身份标识类型
    ,brernm varchar2(2) -- 共同受信人个数
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,rptdate varchar2(19) -- 信息报告日期
    ,certrelname varchar2(80) -- 共同受信人名称
    ,brertype varchar2(64) -- 共同受信人身份类别
    ,cust_no varchar2(32) -- 客户号码
    ,deptcode varchar2(14) -- 征信机构代码
    ,create_time varchar2(19) -- 入库时间
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
grant select on ${iol_schema}.icms_credit_ctrctcertrelsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_ctrctcertrelsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_ctrctcertrelsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_ctrctcertrelsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_ctrctcertrelsgmt is '个人授信协议信息记录-共同受信人信息段';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.contractcode is '授信协议标识码';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.certrelidnum is '共同受信人身份标识号码';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.certrelidtype is '共同受信人身份标识类型';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.brernm is '共同受信人个数';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.certrelname is '共同受信人名称';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.brertype is '共同受信人身份类别';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_ctrctcertrelsgmt.etl_timestamp is 'ETL处理时间戳';
