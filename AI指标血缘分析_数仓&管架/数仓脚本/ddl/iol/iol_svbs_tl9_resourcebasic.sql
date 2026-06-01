/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svbs_tl9_resourcebasic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svbs_tl9_resourcebasic
whenever sqlerror continue none;
drop table ${iol_schema}.svbs_tl9_resourcebasic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_tl9_resourcebasic(
    resourceid varchar2(192) -- 资源ID
    ,parent varchar2(192) -- 父级资源ID
    ,resourcename varchar2(192) -- 资源名称
    ,accesscontrol varchar2(3) -- 访问控制
    ,updatetime date -- 更新日期
    ,createtime date -- 创建日期
    ,recordstatus varchar2(3) -- 记录状态
    ,resourcetypeid varchar2(6) -- 资源类型ID
    ,icon varchar2(384) -- 图标
    ,catalog_id varchar2(24) -- 分类ID
    ,specialflag varchar2(24) -- 特别ID
    ,showflag varchar2(3) -- 显示标志
    ,systemid varchar2(192) -- 系统标识
    ,url varchar2(384) -- 资源路径
    ,given_name varchar2(192) -- 资源英文名称
    ,details varchar2(768) -- 详情
    ,sort_no number -- 排序序号
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
grant select on ${iol_schema}.svbs_tl9_resourcebasic to ${iml_schema};
grant select on ${iol_schema}.svbs_tl9_resourcebasic to ${icl_schema};
grant select on ${iol_schema}.svbs_tl9_resourcebasic to ${idl_schema};
grant select on ${iol_schema}.svbs_tl9_resourcebasic to ${iel_schema};

-- comment
comment on table ${iol_schema}.svbs_tl9_resourcebasic is '资源基础信息表';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.resourceid is '资源ID';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.parent is '父级资源ID';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.resourcename is '资源名称';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.accesscontrol is '访问控制';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.updatetime is '更新日期';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.createtime is '创建日期';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.recordstatus is '记录状态';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.resourcetypeid is '资源类型ID';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.icon is '图标';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.catalog_id is '分类ID';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.specialflag is '特别ID';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.showflag is '显示标志';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.systemid is '系统标识';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.url is '资源路径';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.given_name is '资源英文名称';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.details is '详情';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.sort_no is '排序序号';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.start_dt is '开始时间';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.end_dt is '结束时间';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.id_mark is '增删标志';
comment on column ${iol_schema}.svbs_tl9_resourcebasic.etl_timestamp is 'ETL处理时间戳';
