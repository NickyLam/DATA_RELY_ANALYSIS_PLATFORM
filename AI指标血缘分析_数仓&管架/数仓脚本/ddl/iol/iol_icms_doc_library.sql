/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_doc_library
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_doc_library
whenever sqlerror continue none;
drop table ${iol_schema}.icms_doc_library purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_doc_library(
    docno varchar2(64) -- 文档编号
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(64) -- 对象编号
    ,doctitle varchar2(500) -- 文档名称
    ,doctype varchar2(64) -- 文档类型
    ,doclength varchar2(64) -- 文档长度
    ,docimportance varchar2(64) -- 文档重要性
    ,docsecret varchar2(64) -- 文档密级
    ,docstage varchar2(64) -- 所属阶段
    ,docsource varchar2(160) -- 文档来源
    ,docunit varchar2(160) -- 编制单位
    ,docdate date -- 编制日期
    ,docorganizer varchar2(160) -- 编制人
    ,dockeyword varchar2(1000) -- 文档主体词
    ,docabstract varchar2(1000) -- 文档摘要
    ,doclocation varchar2(1000) -- 文档保存位置
    ,docattribute varchar2(64) -- 文档性质
    ,remark varchar2(1000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,olddocno varchar2(64) -- 迁移前文档编号
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_doc_library to ${iml_schema};
grant select on ${iol_schema}.icms_doc_library to ${icl_schema};
grant select on ${iol_schema}.icms_doc_library to ${idl_schema};
grant select on ${iol_schema}.icms_doc_library to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_doc_library is '文档资料库';
comment on column ${iol_schema}.icms_doc_library.docno is '文档编号';
comment on column ${iol_schema}.icms_doc_library.objecttype is '对象类型';
comment on column ${iol_schema}.icms_doc_library.objectno is '对象编号';
comment on column ${iol_schema}.icms_doc_library.doctitle is '文档名称';
comment on column ${iol_schema}.icms_doc_library.doctype is '文档类型';
comment on column ${iol_schema}.icms_doc_library.doclength is '文档长度';
comment on column ${iol_schema}.icms_doc_library.docimportance is '文档重要性';
comment on column ${iol_schema}.icms_doc_library.docsecret is '文档密级';
comment on column ${iol_schema}.icms_doc_library.docstage is '所属阶段';
comment on column ${iol_schema}.icms_doc_library.docsource is '文档来源';
comment on column ${iol_schema}.icms_doc_library.docunit is '编制单位';
comment on column ${iol_schema}.icms_doc_library.docdate is '编制日期';
comment on column ${iol_schema}.icms_doc_library.docorganizer is '编制人';
comment on column ${iol_schema}.icms_doc_library.dockeyword is '文档主体词';
comment on column ${iol_schema}.icms_doc_library.docabstract is '文档摘要';
comment on column ${iol_schema}.icms_doc_library.doclocation is '文档保存位置';
comment on column ${iol_schema}.icms_doc_library.docattribute is '文档性质';
comment on column ${iol_schema}.icms_doc_library.remark is '备注';
comment on column ${iol_schema}.icms_doc_library.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_doc_library.inputuserid is '登记人';
comment on column ${iol_schema}.icms_doc_library.inputdate is '登记日期';
comment on column ${iol_schema}.icms_doc_library.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_doc_library.updateuserid is '更新人';
comment on column ${iol_schema}.icms_doc_library.updatedate is '更新日期';
comment on column ${iol_schema}.icms_doc_library.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_doc_library.olddocno is '迁移前文档编号';
comment on column ${iol_schema}.icms_doc_library.migtflag is '';
comment on column ${iol_schema}.icms_doc_library.start_dt is '开始时间';
comment on column ${iol_schema}.icms_doc_library.end_dt is '结束时间';
comment on column ${iol_schema}.icms_doc_library.id_mark is '增删标志';
comment on column ${iol_schema}.icms_doc_library.etl_timestamp is 'ETL处理时间戳';
