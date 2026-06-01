/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_rpinform_pub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_rpinform_pub
whenever sqlerror continue none;
drop table ${iol_schema}.icms_rpinform_pub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_rpinform_pub(
    serialno varchar2(40) -- 流水号
    ,credit_id2 varchar2(80) -- 证件号码2(组织机构代码/统一社会信用代码)
    ,bash_date varchar2(32) -- 日期
    ,relative_name varchar2(200) -- 关联方名称
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,business_type varchar2(32) -- 业务类型
    ,relative_id varchar2(30) -- 关联方编号
    ,job varchar2(80) -- 担任职务或关联关系
    ,credit_id1 varchar2(60) -- 关联方证件号码
    ,remark varchar2(2000) -- 备注
    ,shares_percent varchar2(80) -- 持股比例
    ,relative_parent_id varchar2(32) -- 上级关联方编号
    ,relationship varchar2(80) -- 关联关系类型
    ,belong_org_name varchar2(200) -- 单位归属的企业集团全称
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
grant select on ${iol_schema}.icms_rpinform_pub to ${iml_schema};
grant select on ${iol_schema}.icms_rpinform_pub to ${icl_schema};
grant select on ${iol_schema}.icms_rpinform_pub to ${idl_schema};
grant select on ${iol_schema}.icms_rpinform_pub to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_rpinform_pub is '对公关联方基本信息';
comment on column ${iol_schema}.icms_rpinform_pub.serialno is '流水号';
comment on column ${iol_schema}.icms_rpinform_pub.credit_id2 is '证件号码2(组织机构代码/统一社会信用代码)';
comment on column ${iol_schema}.icms_rpinform_pub.bash_date is '日期';
comment on column ${iol_schema}.icms_rpinform_pub.relative_name is '关联方名称';
comment on column ${iol_schema}.icms_rpinform_pub.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_rpinform_pub.business_type is '业务类型';
comment on column ${iol_schema}.icms_rpinform_pub.relative_id is '关联方编号';
comment on column ${iol_schema}.icms_rpinform_pub.job is '担任职务或关联关系';
comment on column ${iol_schema}.icms_rpinform_pub.credit_id1 is '关联方证件号码';
comment on column ${iol_schema}.icms_rpinform_pub.remark is '备注';
comment on column ${iol_schema}.icms_rpinform_pub.shares_percent is '持股比例';
comment on column ${iol_schema}.icms_rpinform_pub.relative_parent_id is '上级关联方编号';
comment on column ${iol_schema}.icms_rpinform_pub.relationship is '关联关系类型';
comment on column ${iol_schema}.icms_rpinform_pub.belong_org_name is '单位归属的企业集团全称';
comment on column ${iol_schema}.icms_rpinform_pub.start_dt is '开始时间';
comment on column ${iol_schema}.icms_rpinform_pub.end_dt is '结束时间';
comment on column ${iol_schema}.icms_rpinform_pub.id_mark is '增删标志';
comment on column ${iol_schema}.icms_rpinform_pub.etl_timestamp is 'ETL处理时间戳';
