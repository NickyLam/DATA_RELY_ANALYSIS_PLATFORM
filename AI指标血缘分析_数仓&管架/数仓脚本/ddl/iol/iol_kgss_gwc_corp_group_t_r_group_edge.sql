/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol kgss_gwc_corp_group_t_r_group_edge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge
whenever sqlerror continue none;
drop table ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge(
    object_key varchar2(4000) -- 主键
    ,group_name varchar2(4000) -- 团伙名字
    ,from_key varchar2(4000) -- 起点主键
    ,src_name varchar2(4000) -- 起点名称
    ,src_credit_no varchar2(4000) -- 起点统一信用代码、注册号
    ,to_key varchar2(4000) -- 终点主键
    ,dst_name varchar2(4000) -- 终点名称
    ,dst_credit_no varchar2(4000) -- 终点统一信用代码、注册号
    ,label varchar2(4000) -- 边类型
    ,label_temp varchar2(4000) -- 边类型明细
    ,group_name_remark varchar2(4000) -- 派系名称
    ,distinct_flag varchar2(4000) -- 去重标识
    ,priority_level varchar2(4000) -- 优先级
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
grant select on ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge to ${iml_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge to ${icl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge to ${idl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge to ${iel_schema};

-- comment
comment on table ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge is '集团派系成团关系表';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.object_key is '主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.group_name is '团伙名字';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.from_key is '起点主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.src_name is '起点名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.src_credit_no is '起点统一信用代码、注册号';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.to_key is '终点主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.dst_name is '终点名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.dst_credit_no is '终点统一信用代码、注册号';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.label is '边类型';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.label_temp is '边类型明细';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.group_name_remark is '派系名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.distinct_flag is '去重标识';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.priority_level is '优先级';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_r_group_edge.etl_timestamp is 'ETL处理时间戳';
