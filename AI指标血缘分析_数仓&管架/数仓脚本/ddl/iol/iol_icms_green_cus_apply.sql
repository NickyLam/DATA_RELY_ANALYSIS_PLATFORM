/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_green_cus_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_green_cus_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_green_cus_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_green_cus_apply(
    serialno varchar2(32) -- 申请流流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,attribute3 varchar2(40) -- 预留字段3
    ,isfreshcust varchar2(2) -- 是否绿色信贷
    ,inputuserid varchar2(32) -- 用户编号
    ,attribute2 varchar2(40) -- 预留字段2
    ,attribute4 varchar2(40) -- 预留字段4
    ,attribute1 varchar2(40) -- 预留字段1
    ,applystatus varchar2(2) -- 申请状态
    ,customerid varchar2(40) -- 客户号
    ,greencategory varchar2(20) -- 绿色信贷类别
    ,inputtime varchar2(50) -- 录入时间
    ,inputorgid varchar2(32) -- 机构编号
    ,isgreenbonds varchar2(10) -- 是否绿色债劵项目
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
grant select on ${iol_schema}.icms_green_cus_apply to ${iml_schema};
grant select on ${iol_schema}.icms_green_cus_apply to ${icl_schema};
grant select on ${iol_schema}.icms_green_cus_apply to ${idl_schema};
grant select on ${iol_schema}.icms_green_cus_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_green_cus_apply is '绿色信贷申请表';
comment on column ${iol_schema}.icms_green_cus_apply.serialno is '申请流流水号';
comment on column ${iol_schema}.icms_green_cus_apply.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_green_cus_apply.attribute3 is '预留字段3';
comment on column ${iol_schema}.icms_green_cus_apply.isfreshcust is '是否绿色信贷';
comment on column ${iol_schema}.icms_green_cus_apply.inputuserid is '用户编号';
comment on column ${iol_schema}.icms_green_cus_apply.attribute2 is '预留字段2';
comment on column ${iol_schema}.icms_green_cus_apply.attribute4 is '预留字段4';
comment on column ${iol_schema}.icms_green_cus_apply.attribute1 is '预留字段1';
comment on column ${iol_schema}.icms_green_cus_apply.applystatus is '申请状态';
comment on column ${iol_schema}.icms_green_cus_apply.customerid is '客户号';
comment on column ${iol_schema}.icms_green_cus_apply.greencategory is '绿色信贷类别';
comment on column ${iol_schema}.icms_green_cus_apply.inputtime is '录入时间';
comment on column ${iol_schema}.icms_green_cus_apply.inputorgid is '机构编号';
comment on column ${iol_schema}.icms_green_cus_apply.isgreenbonds is '是否绿色债劵项目';
comment on column ${iol_schema}.icms_green_cus_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_green_cus_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_green_cus_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_green_cus_apply.etl_timestamp is 'ETL处理时间戳';
