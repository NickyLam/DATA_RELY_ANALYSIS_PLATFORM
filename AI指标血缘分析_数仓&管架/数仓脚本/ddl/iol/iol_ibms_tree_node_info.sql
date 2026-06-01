/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_tree_node_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_tree_node_info
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_tree_node_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tree_node_info(
    tree_code varchar2(75) -- 
    ,node_id number(22,0) -- 
    ,parent_id number(22,0) -- 
    ,node_name varchar2(150) -- 
    ,node_type varchar2(12) -- 
    ,node_value varchar2(150) -- 
    ,sort_id number(22,0) -- 
    ,py_code varchar2(150) -- 
    ,update_time varchar2(29) -- 
    ,seat_no varchar2(29) -- 通道号
    ,seat_name varchar2(150) -- 通道名称
    ,p_node_name varchar2(150) -- 
    ,ext_info varchar2(1500) -- 扩展信息
    ,ext_description varchar2(300) -- 扩展字段描述
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
grant select on ${iol_schema}.ibms_tree_node_info to ${iml_schema};
grant select on ${iol_schema}.ibms_tree_node_info to ${icl_schema};
grant select on ${iol_schema}.ibms_tree_node_info to ${idl_schema};
grant select on ${iol_schema}.ibms_tree_node_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_tree_node_info is '树状数据表';
comment on column ${iol_schema}.ibms_tree_node_info.tree_code is '';
comment on column ${iol_schema}.ibms_tree_node_info.node_id is '';
comment on column ${iol_schema}.ibms_tree_node_info.parent_id is '';
comment on column ${iol_schema}.ibms_tree_node_info.node_name is '';
comment on column ${iol_schema}.ibms_tree_node_info.node_type is '';
comment on column ${iol_schema}.ibms_tree_node_info.node_value is '';
comment on column ${iol_schema}.ibms_tree_node_info.sort_id is '';
comment on column ${iol_schema}.ibms_tree_node_info.py_code is '';
comment on column ${iol_schema}.ibms_tree_node_info.update_time is '';
comment on column ${iol_schema}.ibms_tree_node_info.seat_no is '通道号';
comment on column ${iol_schema}.ibms_tree_node_info.seat_name is '通道名称';
comment on column ${iol_schema}.ibms_tree_node_info.p_node_name is '';
comment on column ${iol_schema}.ibms_tree_node_info.ext_info is '扩展信息';
comment on column ${iol_schema}.ibms_tree_node_info.ext_description is '扩展字段描述';
comment on column ${iol_schema}.ibms_tree_node_info.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_tree_node_info.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_tree_node_info.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_tree_node_info.etl_timestamp is 'ETL处理时间戳';
