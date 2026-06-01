/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_objecttype_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_objecttype_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_objecttype_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_objecttype_catalog(
    objecttype varchar2(64) -- 对象类型号
    ,objecttable varchar2(400) -- 主数据表
    ,inputorg varchar2(160) -- 登记机构
    ,sortno varchar2(64) -- 排序号
    ,objectattribute varchar2(1000) -- 属性集
    ,attribute3 varchar2(400) -- 属性3
    ,inputdate date -- 登记日期
    ,defaultview varchar2(64) -- 默认视图
    ,righttype varchar2(1000) -- 权限方法
    ,treecode varchar2(400) -- 对象树图
    ,usagedescribe varchar2(1000) -- 描述
    ,attribute2 varchar2(400) -- 属性2
    ,updatetime date -- 更新时间
    ,updatedate date -- 更新日期
    ,catalogwhere1 varchar2(1000) -- where条件1
    ,catalogwhere2 varchar2(1000) -- where条件2
    ,inputorgid varchar2(64) -- 登记机构编号
    ,inputuserid varchar2(64) -- 登记人
    ,objectname varchar2(160) -- 对象类型名称
    ,pagepath varchar2(400) -- Web访问路径
    ,attribute1 varchar2(400) -- 属性1
    ,inputtime date -- 登记时间
    ,catalogwhere3 varchar2(1000) -- where条件3
    ,updateorgid varchar2(64) -- 更新机构
    ,viewtype varchar2(64) -- 视图组
    ,catalogsql varchar2(1000) -- sql语句
    ,keycolname varchar2(160) -- 关键字段名称
    ,relativetable varchar2(400) -- 关联数据表
    ,keycol varchar2(1000) -- 关键字段
    ,inputuser varchar2(160) -- 登记人员
    ,remark varchar2(1000) -- 备注
    ,objectcolattribute varchar2(64) -- 对象列属性
    ,updateuserid varchar2(64) -- 更新人
    ,updateuser varchar2(160) -- 更新人员
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
grant select on ${iol_schema}.icms_objecttype_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_objecttype_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_objecttype_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_objecttype_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_objecttype_catalog is '对象类型信息表';
comment on column ${iol_schema}.icms_objecttype_catalog.objecttype is '对象类型号';
comment on column ${iol_schema}.icms_objecttype_catalog.objecttable is '主数据表';
comment on column ${iol_schema}.icms_objecttype_catalog.inputorg is '登记机构';
comment on column ${iol_schema}.icms_objecttype_catalog.sortno is '排序号';
comment on column ${iol_schema}.icms_objecttype_catalog.objectattribute is '属性集';
comment on column ${iol_schema}.icms_objecttype_catalog.attribute3 is '属性3';
comment on column ${iol_schema}.icms_objecttype_catalog.inputdate is '登记日期';
comment on column ${iol_schema}.icms_objecttype_catalog.defaultview is '默认视图';
comment on column ${iol_schema}.icms_objecttype_catalog.righttype is '权限方法';
comment on column ${iol_schema}.icms_objecttype_catalog.treecode is '对象树图';
comment on column ${iol_schema}.icms_objecttype_catalog.usagedescribe is '描述';
comment on column ${iol_schema}.icms_objecttype_catalog.attribute2 is '属性2';
comment on column ${iol_schema}.icms_objecttype_catalog.updatetime is '更新时间';
comment on column ${iol_schema}.icms_objecttype_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_objecttype_catalog.catalogwhere1 is 'where条件1';
comment on column ${iol_schema}.icms_objecttype_catalog.catalogwhere2 is 'where条件2';
comment on column ${iol_schema}.icms_objecttype_catalog.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_objecttype_catalog.inputuserid is '登记人';
comment on column ${iol_schema}.icms_objecttype_catalog.objectname is '对象类型名称';
comment on column ${iol_schema}.icms_objecttype_catalog.pagepath is 'Web访问路径';
comment on column ${iol_schema}.icms_objecttype_catalog.attribute1 is '属性1';
comment on column ${iol_schema}.icms_objecttype_catalog.inputtime is '登记时间';
comment on column ${iol_schema}.icms_objecttype_catalog.catalogwhere3 is 'where条件3';
comment on column ${iol_schema}.icms_objecttype_catalog.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_objecttype_catalog.viewtype is '视图组';
comment on column ${iol_schema}.icms_objecttype_catalog.catalogsql is 'sql语句';
comment on column ${iol_schema}.icms_objecttype_catalog.keycolname is '关键字段名称';
comment on column ${iol_schema}.icms_objecttype_catalog.relativetable is '关联数据表';
comment on column ${iol_schema}.icms_objecttype_catalog.keycol is '关键字段';
comment on column ${iol_schema}.icms_objecttype_catalog.inputuser is '登记人员';
comment on column ${iol_schema}.icms_objecttype_catalog.remark is '备注';
comment on column ${iol_schema}.icms_objecttype_catalog.objectcolattribute is '对象列属性';
comment on column ${iol_schema}.icms_objecttype_catalog.updateuserid is '更新人';
comment on column ${iol_schema}.icms_objecttype_catalog.updateuser is '更新人员';
comment on column ${iol_schema}.icms_objecttype_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.icms_objecttype_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.icms_objecttype_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.icms_objecttype_catalog.etl_timestamp is 'ETL处理时间戳';
