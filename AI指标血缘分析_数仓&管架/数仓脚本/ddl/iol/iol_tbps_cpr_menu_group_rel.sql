/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_menu_group_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_menu_group_rel
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_menu_group_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_menu_group_rel(
    mgr_groupid varchar2(32) -- 功能组编号
    ,mgr_menuid varchar2(32) -- 菜单编号
    ,mgr_state varchar2(1) -- 状态
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
grant select on ${iol_schema}.tbps_cpr_menu_group_rel to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_menu_group_rel to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_menu_group_rel to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_menu_group_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_menu_group_rel is '企业功能组关联表';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.mgr_groupid is '功能组编号';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.mgr_menuid is '菜单编号';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.mgr_state is '状态';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_menu_group_rel.etl_timestamp is 'ETL处理时间戳';
