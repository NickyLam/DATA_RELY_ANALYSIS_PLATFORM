/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_catalog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_catalog
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_catalog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_catalog(
    clrtypeid varchar2(96) -- 押品类型编号
    ,clrtypename varchar2(240) -- 押品类型名称
    ,parentnodeid varchar2(96) -- 父节点编号
    ,isleafnode varchar2(3) -- 是否叶节点
    ,clrtablename varchar2(240) -- 押品表名
    ,templetno varchar2(96) -- 模板编号
    ,corefields varchar2(1500) -- 核心要素
    ,subfields varchar2(1500) -- 辅助要素
    ,clronlyscope varchar2(1500) -- 押品唯一性校验范围
    ,effectivedate date -- 生效日期
    ,expirydate date -- 失效日期
    ,status varchar2(3) -- 状态
    ,inputorgid varchar2(96) -- 登记机构
    ,inputuserid varchar2(240) -- 登记人
    ,inputdate timestamp -- 登记日期
    ,updateorgid varchar2(96) -- 更新机构
    ,updateuserid varchar2(240) -- 更新人
    ,updatedate timestamp -- 更新日期
    ,remark varchar2(1500) -- 备注
    ,detailurl varchar2(600) -- 详情页面url
    ,editurl varchar2(600) -- 编辑页面url
    ,corporgid varchar2(96) -- 法人机构编号
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
grant select on ${iol_schema}.icms_clr_catalog to ${iml_schema};
grant select on ${iol_schema}.icms_clr_catalog to ${icl_schema};
grant select on ${iol_schema}.icms_clr_catalog to ${idl_schema};
grant select on ${iol_schema}.icms_clr_catalog to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_catalog is '押品分类目录';
comment on column ${iol_schema}.icms_clr_catalog.clrtypeid is '押品类型编号';
comment on column ${iol_schema}.icms_clr_catalog.clrtypename is '押品类型名称';
comment on column ${iol_schema}.icms_clr_catalog.parentnodeid is '父节点编号';
comment on column ${iol_schema}.icms_clr_catalog.isleafnode is '是否叶节点';
comment on column ${iol_schema}.icms_clr_catalog.clrtablename is '押品表名';
comment on column ${iol_schema}.icms_clr_catalog.templetno is '模板编号';
comment on column ${iol_schema}.icms_clr_catalog.corefields is '核心要素';
comment on column ${iol_schema}.icms_clr_catalog.subfields is '辅助要素';
comment on column ${iol_schema}.icms_clr_catalog.clronlyscope is '押品唯一性校验范围';
comment on column ${iol_schema}.icms_clr_catalog.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_clr_catalog.expirydate is '失效日期';
comment on column ${iol_schema}.icms_clr_catalog.status is '状态';
comment on column ${iol_schema}.icms_clr_catalog.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_catalog.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_catalog.inputdate is '登记日期';
comment on column ${iol_schema}.icms_clr_catalog.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_catalog.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_catalog.updatedate is '更新日期';
comment on column ${iol_schema}.icms_clr_catalog.remark is '备注';
comment on column ${iol_schema}.icms_clr_catalog.detailurl is '详情页面url';
comment on column ${iol_schema}.icms_clr_catalog.editurl is '编辑页面url';
comment on column ${iol_schema}.icms_clr_catalog.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_clr_catalog.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_catalog.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_catalog.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_catalog.etl_timestamp is 'ETL处理时间戳';
