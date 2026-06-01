/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_eduinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_eduinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_eduinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_eduinfsgmt(
    acadegree varchar2(4) -- 学位
    ,cust_no varchar2(32) -- 客户号码
    ,deptcode varchar2(14) -- 征信机构代码
    ,create_time varchar2(19) -- 入库时间
    ,edulevel varchar2(4) -- 学历
    ,eduinfoupdate varchar2(19) -- 信息更新日期
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
grant select on ${iol_schema}.icms_credit_eduinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_eduinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_eduinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_eduinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_eduinfsgmt is '个人基本信息记录-教育信息段';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.acadegree is '学位';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.edulevel is '学历';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.eduinfoupdate is '信息更新日期';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_eduinfsgmt.etl_timestamp is 'ETL处理时间戳';
