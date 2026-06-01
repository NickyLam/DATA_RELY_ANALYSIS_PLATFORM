/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_asyn_genealogy2_links
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_asyn_genealogy2_links
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_asyn_genealogy2_links purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_asyn_genealogy2_links(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,properties_legal varchar2(4000) -- 是否是法人
    ,properties_position_desc varchar2(4000) -- 职务描述
    ,properties_sharestype varchar2(4000) -- 股份类型
    ,type varchar2(4000) -- 关系类型
    ,properties_conprop varchar2(4000) -- 出资比例
    ,properties_currency varchar2(4000) -- 认缴出资币种code
    ,properties_position varchar2(4000) -- 职务code
    ,properties_subconam varchar2(4000) -- 认缴出资额
    ,properties_condate varchar2(4000) -- 认缴出资日期
    ,from varchar2(4000) -- 源节点id
    ,links varchar2(4000) -- 关联标签
    ,id varchar2(4000) -- 关系id
    ,to varchar2(4000) -- 目标节点id
    ,properties_holderamt varchar2(4000) -- 持股数量
    ,properties_holderrto varchar2(4000) -- 持股比例
    ,properties_currency_desc varchar2(4000) -- 认缴出资币种描述
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
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_links to ${iml_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_links to ${icl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_links to ${idl_schema};
grant select on ${iol_schema}.uxds_f_asyn_genealogy2_links to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_asyn_genealogy2_links is '外数图谱';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_legal is '是否是法人';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_position_desc is '职务描述';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_sharestype is '股份类型';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.type is '关系类型';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_conprop is '出资比例';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_currency is '认缴出资币种code';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_position is '职务code';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_subconam is '认缴出资额';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_condate is '认缴出资日期';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.from is '源节点id';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.links is '关联标签';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.id is '关系id';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.to is '目标节点id';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_holderamt is '持股数量';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_holderrto is '持股比例';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.properties_currency_desc is '认缴出资币种描述';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_asyn_genealogy2_links.etl_timestamp is 'ETL处理时间戳';
