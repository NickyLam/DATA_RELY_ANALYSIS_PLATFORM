/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_objecttype_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_objecttype_rela
whenever sqlerror continue none;
drop table ${iol_schema}.icms_objecttype_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_objecttype_rela(
    objecttype varchar2(64) -- 对象类型号
    ,relationship varchar2(400) -- 关联关系
    ,displayname varchar2(160) -- 显示名称
    ,updateuserid varchar2(64) -- 更新人编号
    ,updateuser varchar2(160) -- 更新人
    ,isinuse varchar2(12) -- 是否可用
    ,attribute2 varchar2(1000) -- 属性2
    ,updatetime date -- 更新时间
    ,relaexpr varchar2(1000) -- 关系表述
    ,inputuserid varchar2(64) -- 登记人编号
    ,updatedate date -- 更新日期
    ,viewexpr varchar2(1000) -- 视图表述
    ,attribute3 varchar2(1000) -- 属性3
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,inputorg varchar2(160) -- 登记机构
    ,sortno varchar2(64) -- 排序号
    ,updateorgid varchar2(64) -- 更新机构
    ,inputtime date -- 登记时间
    ,attribute1 varchar2(1000) -- 属性1
    ,relaobjecttype varchar2(64) -- 关联对象类型
    ,showontabexpr varchar2(1000) -- 模板表述
    ,inputuser varchar2(160) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构编号
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
grant select on ${iol_schema}.icms_objecttype_rela to ${iml_schema};
grant select on ${iol_schema}.icms_objecttype_rela to ${icl_schema};
grant select on ${iol_schema}.icms_objecttype_rela to ${idl_schema};
grant select on ${iol_schema}.icms_objecttype_rela to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_objecttype_rela is '对象关联信息表';
comment on column ${iol_schema}.icms_objecttype_rela.objecttype is '对象类型号';
comment on column ${iol_schema}.icms_objecttype_rela.relationship is '关联关系';
comment on column ${iol_schema}.icms_objecttype_rela.displayname is '显示名称';
comment on column ${iol_schema}.icms_objecttype_rela.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_objecttype_rela.updateuser is '更新人';
comment on column ${iol_schema}.icms_objecttype_rela.isinuse is '是否可用';
comment on column ${iol_schema}.icms_objecttype_rela.attribute2 is '属性2';
comment on column ${iol_schema}.icms_objecttype_rela.updatetime is '更新时间';
comment on column ${iol_schema}.icms_objecttype_rela.relaexpr is '关系表述';
comment on column ${iol_schema}.icms_objecttype_rela.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_objecttype_rela.updatedate is '更新日期';
comment on column ${iol_schema}.icms_objecttype_rela.viewexpr is '视图表述';
comment on column ${iol_schema}.icms_objecttype_rela.attribute3 is '属性3';
comment on column ${iol_schema}.icms_objecttype_rela.remark is '备注';
comment on column ${iol_schema}.icms_objecttype_rela.inputdate is '登记日期';
comment on column ${iol_schema}.icms_objecttype_rela.inputorg is '登记机构';
comment on column ${iol_schema}.icms_objecttype_rela.sortno is '排序号';
comment on column ${iol_schema}.icms_objecttype_rela.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_objecttype_rela.inputtime is '登记时间';
comment on column ${iol_schema}.icms_objecttype_rela.attribute1 is '属性1';
comment on column ${iol_schema}.icms_objecttype_rela.relaobjecttype is '关联对象类型';
comment on column ${iol_schema}.icms_objecttype_rela.showontabexpr is '模板表述';
comment on column ${iol_schema}.icms_objecttype_rela.inputuser is '登记人';
comment on column ${iol_schema}.icms_objecttype_rela.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_objecttype_rela.start_dt is '开始时间';
comment on column ${iol_schema}.icms_objecttype_rela.end_dt is '结束时间';
comment on column ${iol_schema}.icms_objecttype_rela.id_mark is '增删标志';
comment on column ${iol_schema}.icms_objecttype_rela.etl_timestamp is 'ETL处理时间戳';
