/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_spsinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_spsinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_spsinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_spsinfsgmt(
    deptcode varchar2(14) -- 征信机构代码
    ,spsinfoupdate varchar2(19) -- 信息更新日期
    ,cust_no varchar2(32) -- 客户号码
    ,spotel varchar2(25) -- 配偶联系电话
    ,spoidtype varchar2(4) -- 配偶证件类型
    ,spscmpynm varchar2(80) -- 配偶工作单位
    ,spoidnum varchar2(20) -- 配偶证件号码
    ,maristatus varchar2(6) -- 婚姻状况
    ,create_time varchar2(19) -- 入库时间
    ,sponame varchar2(200) -- 配偶姓名
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
grant select on ${iol_schema}.icms_credit_spsinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_spsinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_spsinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_spsinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_spsinfsgmt is '个人基本信息记录-婚姻信息段';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.spsinfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.spotel is '配偶联系电话';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.spoidtype is '配偶证件类型';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.spscmpynm is '配偶工作单位';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.spoidnum is '配偶证件号码';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.maristatus is '婚姻状况';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.sponame is '配偶姓名';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_spsinfsgmt.etl_timestamp is 'ETL处理时间戳';
