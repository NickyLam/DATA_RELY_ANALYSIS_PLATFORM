/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bankpub_orgmapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bankpub_orgmapping
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bankpub_orgmapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bankpub_orgmapping(
    pk_orgmapping varchar2(30) -- 主键
    ,pk_src_system varchar2(30) -- 来源信息主键
    ,pk_group varchar2(30) -- 主键
    ,pk_org varchar2(30) -- 主键
    ,pk_accountingbook varchar2(30) -- 主键
    ,pk_org_v varchar2(30) -- 主键
    ,pk_dept varchar2(30) -- 主键
    ,mapping_orgcode varchar2(150) -- 编码
    ,mapping_orgname varchar2(150) -- 名称
    ,mapping_deptcode varchar2(150) -- 编码
    ,mapping_deptname varchar2(150) -- 名称
    ,mapping_parent_deptcode varchar2(75) -- 编码
    ,isorgmapping varchar2(2) -- 
    ,creator varchar2(30) -- 创建人
    ,creationtime varchar2(29) -- 创建时间
    ,modifier varchar2(30) -- 修改者
    ,modifiedtime varchar2(29) -- 修改时间
    ,def1 varchar2(152) -- 自定义项
    ,def2 varchar2(152) -- 自定义项
    ,def3 varchar2(152) -- 自定义项
    ,def4 varchar2(152) -- 自定义项
    ,def5 varchar2(152) -- 自定义项
    ,def6 varchar2(152) -- 自定义项
    ,def7 varchar2(152) -- 自定义项
    ,def8 varchar2(152) -- 自定义项
    ,def9 varchar2(152) -- 自定义项
    ,def10 varchar2(152) -- 自定义项
    ,ts varchar2(29) -- 时间戳
    ,dr number(38,0) -- 删除标志
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
grant select on ${iol_schema}.iers_bankpub_orgmapping to ${iml_schema};
grant select on ${iol_schema}.iers_bankpub_orgmapping to ${icl_schema};
grant select on ${iol_schema}.iers_bankpub_orgmapping to ${idl_schema};
grant select on ${iol_schema}.iers_bankpub_orgmapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bankpub_orgmapping is '新费用机构映射表';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_orgmapping is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_src_system is '来源信息主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_group is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_org is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_accountingbook is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_org_v is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.pk_dept is '主键';
comment on column ${iol_schema}.iers_bankpub_orgmapping.mapping_orgcode is '编码';
comment on column ${iol_schema}.iers_bankpub_orgmapping.mapping_orgname is '名称';
comment on column ${iol_schema}.iers_bankpub_orgmapping.mapping_deptcode is '编码';
comment on column ${iol_schema}.iers_bankpub_orgmapping.mapping_deptname is '名称';
comment on column ${iol_schema}.iers_bankpub_orgmapping.mapping_parent_deptcode is '编码';
comment on column ${iol_schema}.iers_bankpub_orgmapping.isorgmapping is '';
comment on column ${iol_schema}.iers_bankpub_orgmapping.creator is '创建人';
comment on column ${iol_schema}.iers_bankpub_orgmapping.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bankpub_orgmapping.modifier is '修改者';
comment on column ${iol_schema}.iers_bankpub_orgmapping.modifiedtime is '修改时间';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def1 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def2 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def3 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def4 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def5 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def6 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def7 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def8 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def9 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.def10 is '自定义项';
comment on column ${iol_schema}.iers_bankpub_orgmapping.ts is '时间戳';
comment on column ${iol_schema}.iers_bankpub_orgmapping.dr is '删除标志';
comment on column ${iol_schema}.iers_bankpub_orgmapping.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bankpub_orgmapping.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bankpub_orgmapping.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bankpub_orgmapping.etl_timestamp is 'ETL处理时间戳';
