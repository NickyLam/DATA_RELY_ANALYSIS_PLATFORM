/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_asyn_genealogy2_nodes
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_asyn_genealogy2_nodes
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_asyn_genealogy2_nodes purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_asyn_genealogy2_nodes(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,properties_name varchar2(4000) -- 名称
    ,properties_entstatus varchar2(4000) -- 企业状态
    ,properties_regcapcur varchar2(4000) -- 注册币种code
    ,innode varchar2(4000) -- 是否是输入节点
    ,type varchar2(4000) -- 节点类型
    ,nodes varchar2(4000) -- 关联标签
    ,properties_regno varchar2(4000) -- 注册号
    ,properties_regcap varchar2(4000) -- 注册资本
    ,name varchar2(4000) -- 节点名称
    ,properties_esdate varchar2(4000) -- 成立日期
    ,id varchar2(4000) -- 节点id
    ,properties_creditcode varchar2(4000) -- 统一社会信用代码
    ,properties_islist varchar2(4000) -- 是否上市
    ,properties_nodeid varchar2(4000) -- 节点id
    ,properties_samevalue varchar2(4000) -- 疑似关系节点信息
    ,properties_regcapcur_desc varchar2(4000) -- 注册币种描述
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
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_nodes to ${iml_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_nodes to ${icl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_nodes to ${idl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_nodes to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_asyn_genealogy2_nodes is '外数图谱';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_name is '名称';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_entstatus is '企业状态';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_regcapcur is '注册币种code';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.innode is '是否是输入节点';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.type is '节点类型';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.nodes is '关联标签';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_regno is '注册号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_regcap is '注册资本';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.name is '节点名称';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_esdate is '成立日期';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.id is '节点id';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_creditcode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_islist is '是否上市';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_nodeid is '节点id';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_samevalue is '疑似关系节点信息';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.properties_regcapcur_desc is '注册币种描述';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_nodes.etl_timestamp is 'ETL处理时间戳';
