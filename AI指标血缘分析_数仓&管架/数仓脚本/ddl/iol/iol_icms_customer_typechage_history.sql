/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_typechage_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_typechage_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_typechage_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_typechage_history(
    serialno varchar2(32) -- 流水号
    ,inputuser varchar2(8) -- 登记人
    ,updateorgid varchar2(12) -- 更新机构
    ,updatedate date -- 更新时间
    ,updateuserid varchar2(8) -- 更新人
    ,describe varchar2(1500) -- 变更描述
    ,migtflag varchar2(80) -- 
    ,inputtime date -- 登记时间
    ,inputorgid varchar2(12) -- 登记机构
    ,customerid varchar2(16) -- 客户编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_customer_typechage_history to ${iml_schema};
grant select on ${iol_schema}.icms_customer_typechage_history to ${icl_schema};
grant select on ${iol_schema}.icms_customer_typechage_history to ${idl_schema};
grant select on ${iol_schema}.icms_customer_typechage_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_typechage_history is '客户类型变更信息表';
comment on column ${iol_schema}.icms_customer_typechage_history.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_typechage_history.inputuser is '登记人';
comment on column ${iol_schema}.icms_customer_typechage_history.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_typechage_history.updatedate is '更新时间';
comment on column ${iol_schema}.icms_customer_typechage_history.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_typechage_history.describe is '变更描述';
comment on column ${iol_schema}.icms_customer_typechage_history.migtflag is '';
comment on column ${iol_schema}.icms_customer_typechage_history.inputtime is '登记时间';
comment on column ${iol_schema}.icms_customer_typechage_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_typechage_history.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_typechage_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_typechage_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_typechage_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_typechage_history.etl_timestamp is 'ETL处理时间戳';
