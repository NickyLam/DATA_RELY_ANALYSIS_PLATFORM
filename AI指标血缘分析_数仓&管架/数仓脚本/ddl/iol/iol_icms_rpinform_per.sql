/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_rpinform_per
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_rpinform_per
whenever sqlerror continue none;
drop table ${iol_schema}.icms_rpinform_per purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_rpinform_per(
    serialno varchar2(40) -- 流水号
    ,job varchar2(80) -- 本行岗位或职务
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,belong_org_name varchar2(200) -- 所属机构
    ,relationship varchar2(80) -- 关联关系类型
    ,relative_name varchar2(200) -- 关联方名称
    ,business_type varchar2(32) -- 业务类型
    ,bash_date varchar2(32) -- 文件日期
    ,shares_percent varchar2(80) -- 持股比例
    ,relative_org_name varchar2(200) -- 关联单位全称
    ,remark varchar2(2000) -- 备注
    ,relative_id varchar2(30) -- 关联方编号
    ,credit_type varchar2(80) -- 证件类型
    ,belong_part_name varchar2(200) -- 所属部门
    ,credit_id varchar2(60) -- 关联方证件号码
    ,departure_time varchar2(80) -- 离职时间
    ,relative_job varchar2(80) -- 在关联单位担任的职务
    ,relative_parent_id varchar2(32) -- 上级关联方编号
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
grant select on ${iol_schema}.icms_rpinform_per to ${iml_schema};
grant select on ${iol_schema}.icms_rpinform_per to ${icl_schema};
grant select on ${iol_schema}.icms_rpinform_per to ${idl_schema};
grant select on ${iol_schema}.icms_rpinform_per to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_rpinform_per is '个人关联方基本信息';
comment on column ${iol_schema}.icms_rpinform_per.serialno is '流水号';
comment on column ${iol_schema}.icms_rpinform_per.job is '本行岗位或职务';
comment on column ${iol_schema}.icms_rpinform_per.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_rpinform_per.belong_org_name is '所属机构';
comment on column ${iol_schema}.icms_rpinform_per.relationship is '关联关系类型';
comment on column ${iol_schema}.icms_rpinform_per.relative_name is '关联方名称';
comment on column ${iol_schema}.icms_rpinform_per.business_type is '业务类型';
comment on column ${iol_schema}.icms_rpinform_per.bash_date is '文件日期';
comment on column ${iol_schema}.icms_rpinform_per.shares_percent is '持股比例';
comment on column ${iol_schema}.icms_rpinform_per.relative_org_name is '关联单位全称';
comment on column ${iol_schema}.icms_rpinform_per.remark is '备注';
comment on column ${iol_schema}.icms_rpinform_per.relative_id is '关联方编号';
comment on column ${iol_schema}.icms_rpinform_per.credit_type is '证件类型';
comment on column ${iol_schema}.icms_rpinform_per.belong_part_name is '所属部门';
comment on column ${iol_schema}.icms_rpinform_per.credit_id is '关联方证件号码';
comment on column ${iol_schema}.icms_rpinform_per.departure_time is '离职时间';
comment on column ${iol_schema}.icms_rpinform_per.relative_job is '在关联单位担任的职务';
comment on column ${iol_schema}.icms_rpinform_per.relative_parent_id is '上级关联方编号';
comment on column ${iol_schema}.icms_rpinform_per.start_dt is '开始时间';
comment on column ${iol_schema}.icms_rpinform_per.end_dt is '结束时间';
comment on column ${iol_schema}.icms_rpinform_per.id_mark is '增删标志';
comment on column ${iol_schema}.icms_rpinform_per.etl_timestamp is 'ETL处理时间戳';
