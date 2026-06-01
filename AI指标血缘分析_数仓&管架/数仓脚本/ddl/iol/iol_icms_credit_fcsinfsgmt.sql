/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_fcsinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_fcsinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_fcsinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_fcsinfsgmt(
    cellphone varchar2(11) -- 手机号码
    ,create_time varchar2(19) -- 入库时间
    ,dob varchar2(19) -- 出生日期
    ,houseadd varchar2(100) -- 户籍地址
    ,email varchar2(60) -- 电子邮箱
    ,cust_no varchar2(32) -- 客户号码
    ,nation varchar2(6) -- 国籍
    ,deptcode varchar2(14) -- 征信机构代码
    ,fcsinfoupdate varchar2(19) -- 信息更新日期
    ,sex varchar2(2) -- 性别
    ,hhdist varchar2(6) -- 户籍所在地行政区划
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
grant select on ${iol_schema}.icms_credit_fcsinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_fcsinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_fcsinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_fcsinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_fcsinfsgmt is '个人基本信息记录-基本概况段';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.cellphone is '手机号码';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.dob is '出生日期';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.houseadd is '户籍地址';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.email is '电子邮箱';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.nation is '国籍';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.fcsinfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.sex is '性别';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.hhdist is '户籍所在地行政区划';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_fcsinfsgmt.etl_timestamp is 'ETL处理时间戳';
