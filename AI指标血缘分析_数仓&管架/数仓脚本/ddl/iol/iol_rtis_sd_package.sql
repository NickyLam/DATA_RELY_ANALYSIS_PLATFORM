/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_sd_package
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_sd_package
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_sd_package purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sd_package(
    id_ number(11) -- 主键ID
    ,pkg_id varchar2(36) -- 规则包技术编码
    ,version_ number(11) -- 版本
    ,simulation_id varchar2(36) -- 仿真集ID
    ,is_latest number(3) -- 是否最新版本(0-否，1-是)
    ,name_ varchar2(640) -- 规则包名称
    ,type_ varchar2(20) -- 规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）
    ,oper_scene_id varchar2(4000) -- 所属运营场景(取自CHANNEL_ID)
    ,order_index number(11) -- 标签排序
    ,status_ number(3) -- 规则包状态(0-删除; 1-可用)
    ,cate_id varchar2(36) -- 规则包类目ID
    ,org_id varchar2(100) -- 规则包所属机构
    ,apply_org varchar2(4000) -- 申请组织
    ,note varchar2(255) -- 备注
    ,create_by varchar2(150) -- 创建人
    ,update_by varchar2(150) -- 修改人
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 修改时间
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
grant select on ${iol_schema}.rtis_sd_package to ${iml_schema};
grant select on ${iol_schema}.rtis_sd_package to ${icl_schema};
grant select on ${iol_schema}.rtis_sd_package to ${idl_schema};
grant select on ${iol_schema}.rtis_sd_package to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_sd_package is '风控规则包信息表';
comment on column ${iol_schema}.rtis_sd_package.id_ is '主键ID';
comment on column ${iol_schema}.rtis_sd_package.pkg_id is '规则包技术编码';
comment on column ${iol_schema}.rtis_sd_package.version_ is '版本';
comment on column ${iol_schema}.rtis_sd_package.simulation_id is '仿真集ID';
comment on column ${iol_schema}.rtis_sd_package.is_latest is '是否最新版本(0-否，1-是)';
comment on column ${iol_schema}.rtis_sd_package.name_ is '规则包名称';
comment on column ${iol_schema}.rtis_sd_package.type_ is '规则包类型（HIT-命中规则包，DECISION-TREE-决策树，SCORECARD-评分卡）';
comment on column ${iol_schema}.rtis_sd_package.oper_scene_id is '所属运营场景(取自CHANNEL_ID)';
comment on column ${iol_schema}.rtis_sd_package.order_index is '标签排序';
comment on column ${iol_schema}.rtis_sd_package.status_ is '规则包状态(0-删除; 1-可用)';
comment on column ${iol_schema}.rtis_sd_package.cate_id is '规则包类目ID';
comment on column ${iol_schema}.rtis_sd_package.org_id is '规则包所属机构';
comment on column ${iol_schema}.rtis_sd_package.apply_org is '申请组织';
comment on column ${iol_schema}.rtis_sd_package.note is '备注';
comment on column ${iol_schema}.rtis_sd_package.create_by is '创建人';
comment on column ${iol_schema}.rtis_sd_package.update_by is '修改人';
comment on column ${iol_schema}.rtis_sd_package.create_time is '创建时间';
comment on column ${iol_schema}.rtis_sd_package.update_time is '修改时间';
comment on column ${iol_schema}.rtis_sd_package.start_dt is '开始时间';
comment on column ${iol_schema}.rtis_sd_package.end_dt is '结束时间';
comment on column ${iol_schema}.rtis_sd_package.id_mark is '增删标志';
comment on column ${iol_schema}.rtis_sd_package.etl_timestamp is 'ETL处理时间戳';
