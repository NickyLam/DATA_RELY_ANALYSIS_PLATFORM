/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_menuview_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_menuview_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_menuview_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_menuview_info(
    appnum varchar2(16) -- 应用编码
    ,menuviewnum varchar2(12) -- 菜单视图编号,当实体类型为T时不能为空
    ,menuviewname varchar2(60) -- 菜单视图名称
    ,sortnum varchar2(10) -- 排序号
    ,mainbranch varchar2(10) -- 维护机构
    ,mainuser varchar2(12) -- 维护用户
    ,maindate varchar2(8) -- 维护日期
    ,maintime varchar2(6) -- 维护时间
    ,activerule varchar2(50) -- 应用规则
    ,entry varchar2(256) -- 应用入口路径
    ,activityflag varchar2(1) -- 是否启用【0-否 1-是】
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
grant select on ${iol_schema}.nibs_ib_upm_menuview_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_menuview_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_menuview_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_menuview_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_menuview_info is '系统菜单视图';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.appnum is '应用编码';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.menuviewnum is '菜单视图编号,当实体类型为T时不能为空';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.menuviewname is '菜单视图名称';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.sortnum is '排序号';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.mainbranch is '维护机构';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.mainuser is '维护用户';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.maindate is '维护日期';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.maintime is '维护时间';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.activerule is '应用规则';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.entry is '应用入口路径';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.activityflag is '是否启用【0-否 1-是】';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_menuview_info.etl_timestamp is 'ETL处理时间戳';
