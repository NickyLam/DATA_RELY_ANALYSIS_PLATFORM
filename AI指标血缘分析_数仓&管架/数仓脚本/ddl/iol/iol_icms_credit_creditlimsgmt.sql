/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_creditlimsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_creditlimsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_creditlimsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_creditlimsgmt(
    deptcode varchar2(14) -- 征信机构代码
    ,coneffdate varchar2(19) -- 额度生效日期
    ,constatus varchar2(1) -- 额度状态
    ,creditrestcode varchar2(60) -- 授信限额编号
    ,cust_no varchar2(32) -- 客户号码
    ,creditlim number(24,6) -- 授信额度
    ,rptdate varchar2(19) -- 信息报告日期
    ,conexpdate varchar2(19) -- 额度到期日期
    ,creditrest number(24,6) -- 授信限额
    ,contractcode varchar2(80) -- 授信协议标识码
    ,limloopflg varchar2(1) -- 额度循环标志
    ,creditlimtype varchar2(2) -- 授信额度类型
    ,cy varchar2(3) -- 币种
    ,create_time varchar2(19) -- 入库时间
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
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
grant select on ${iol_schema}.icms_credit_creditlimsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_creditlimsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_creditlimsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_creditlimsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_creditlimsgmt is '个人授信协议信息记录-额度信息段';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.coneffdate is '额度生效日期';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.constatus is '额度状态';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.creditrestcode is '授信限额编号';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.creditlim is '授信额度';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.conexpdate is '额度到期日期';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.creditrest is '授信限额';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.contractcode is '授信协议标识码';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.limloopflg is '额度循环标志';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.creditlimtype is '授信额度类型';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.cy is '币种';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_creditlimsgmt.etl_timestamp is 'ETL处理时间戳';
