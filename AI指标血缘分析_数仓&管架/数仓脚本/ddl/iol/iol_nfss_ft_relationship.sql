/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_relationship
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_relationship
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_relationship purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_relationship(
    relevance_id varchar2(75) -- 关联人
    ,be_associated_id varchar2(75) -- 被关联人
    ,relation varchar2(5) -- 关系(01 父子、02 父女、03 夫妻、04 兄弟、05 兄妹)
    ,created_by varchar2(150) -- 创建者
    ,updated_by varchar2(150) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.nfss_ft_relationship to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_relationship to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_relationship to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_relationship to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_relationship is '委托人关联关系表';
comment on column ${iol_schema}.nfss_ft_relationship.relevance_id is '关联人';
comment on column ${iol_schema}.nfss_ft_relationship.be_associated_id is '被关联人';
comment on column ${iol_schema}.nfss_ft_relationship.relation is '关系(01 父子、02 父女、03 夫妻、04 兄弟、05 兄妹)';
comment on column ${iol_schema}.nfss_ft_relationship.created_by is '创建者';
comment on column ${iol_schema}.nfss_ft_relationship.updated_by is '修改者';
comment on column ${iol_schema}.nfss_ft_relationship.create_time is '创建时间';
comment on column ${iol_schema}.nfss_ft_relationship.update_time is '修改时间';
comment on column ${iol_schema}.nfss_ft_relationship.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ft_relationship.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ft_relationship.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ft_relationship.etl_timestamp is 'ETL处理时间戳';
