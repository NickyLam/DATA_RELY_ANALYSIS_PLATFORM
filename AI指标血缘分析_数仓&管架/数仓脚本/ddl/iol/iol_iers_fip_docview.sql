/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fip_docview
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fip_docview
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fip_docview purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_docview(
    creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,desdocid varchar2(54) -- 目标档案类型
    ,dr number(10,0) -- 删除标志
    ,explanation varchar2(450) -- 备注
    ,explanation2 varchar2(450) -- 备注2
    ,explanation3 varchar2(450) -- 备注3
    ,explanation4 varchar2(450) -- 备注4
    ,explanation5 varchar2(450) -- 备注5
    ,explanation6 varchar2(450) -- 备注6
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,orgtype varchar2(54) -- 组织类型
    ,pk_classview varchar2(30) -- 对象标识
    ,pk_group varchar2(30) -- 集团
    ,pk_org varchar2(30) -- 组织
    ,pk_setorg1 varchar2(30) -- 关联组织
    ,ts varchar2(29) -- 时间戳
    ,viewcode varchar2(60) -- 编码
    ,viewname varchar2(450) -- 名称
    ,viewname2 varchar2(450) -- 名称2
    ,viewname3 varchar2(450) -- 名称3
    ,viewname4 varchar2(450) -- 名称4
    ,viewname5 varchar2(450) -- 名称5
    ,viewname6 varchar2(450) -- 名称6
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
grant select on ${iol_schema}.iers_fip_docview to ${iml_schema};
grant select on ${iol_schema}.iers_fip_docview to ${icl_schema};
grant select on ${iol_schema}.iers_fip_docview to ${idl_schema};
grant select on ${iol_schema}.iers_fip_docview to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fip_docview is '科目对照表';
comment on column ${iol_schema}.iers_fip_docview.creationtime is '创建时间';
comment on column ${iol_schema}.iers_fip_docview.creator is '创建人';
comment on column ${iol_schema}.iers_fip_docview.desdocid is '目标档案类型';
comment on column ${iol_schema}.iers_fip_docview.dr is '删除标志';
comment on column ${iol_schema}.iers_fip_docview.explanation is '备注';
comment on column ${iol_schema}.iers_fip_docview.explanation2 is '备注2';
comment on column ${iol_schema}.iers_fip_docview.explanation3 is '备注3';
comment on column ${iol_schema}.iers_fip_docview.explanation4 is '备注4';
comment on column ${iol_schema}.iers_fip_docview.explanation5 is '备注5';
comment on column ${iol_schema}.iers_fip_docview.explanation6 is '备注6';
comment on column ${iol_schema}.iers_fip_docview.modifiedtime is '修改时间';
comment on column ${iol_schema}.iers_fip_docview.modifier is '修改人';
comment on column ${iol_schema}.iers_fip_docview.orgtype is '组织类型';
comment on column ${iol_schema}.iers_fip_docview.pk_classview is '对象标识';
comment on column ${iol_schema}.iers_fip_docview.pk_group is '集团';
comment on column ${iol_schema}.iers_fip_docview.pk_org is '组织';
comment on column ${iol_schema}.iers_fip_docview.pk_setorg1 is '关联组织';
comment on column ${iol_schema}.iers_fip_docview.ts is '时间戳';
comment on column ${iol_schema}.iers_fip_docview.viewcode is '编码';
comment on column ${iol_schema}.iers_fip_docview.viewname is '名称';
comment on column ${iol_schema}.iers_fip_docview.viewname2 is '名称2';
comment on column ${iol_schema}.iers_fip_docview.viewname3 is '名称3';
comment on column ${iol_schema}.iers_fip_docview.viewname4 is '名称4';
comment on column ${iol_schema}.iers_fip_docview.viewname5 is '名称5';
comment on column ${iol_schema}.iers_fip_docview.viewname6 is '名称6';
comment on column ${iol_schema}.iers_fip_docview.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fip_docview.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fip_docview.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fip_docview.etl_timestamp is 'ETL处理时间戳';
