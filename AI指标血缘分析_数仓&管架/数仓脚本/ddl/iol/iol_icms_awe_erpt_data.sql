/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_awe_erpt_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_awe_erpt_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_awe_erpt_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_data(
    serialno varchar2(32) -- 流水号字段
    ,relativeserialno varchar2(32) -- 对象编号
    ,treeno varchar2(32) -- 排序号
    ,docid varchar2(32) -- 文档编号
    ,dirid varchar2(32) -- 目录编号
    ,dirname varchar2(200) -- 目录名称
    ,guarantyno varchar2(32) -- 关联担保号
    ,htmldata varchar2(4000) -- 内容
    ,contentlength number(38,0) -- 长度
    ,userid varchar2(32) -- 登记人
    ,orgid varchar2(32) -- 登记机构
    ,inputdate varchar2(10) -- 登记日期
    ,updatedate varchar2(10) -- 更新日期
    ,score varchar2(32) -- 评分
    ,scoredesc varchar2(1000) -- 评分描述
    ,saved varchar2(1) -- 保存标志
    ,migtflag varchar2(80) -- 迁移标志
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
grant select on ${iol_schema}.icms_awe_erpt_data to ${iml_schema};
grant select on ${iol_schema}.icms_awe_erpt_data to ${icl_schema};
grant select on ${iol_schema}.icms_awe_erpt_data to ${idl_schema};
grant select on ${iol_schema}.icms_awe_erpt_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_awe_erpt_data is '格式化文档内容;格式化文档内容';
comment on column ${iol_schema}.icms_awe_erpt_data.serialno is '流水号字段';
comment on column ${iol_schema}.icms_awe_erpt_data.relativeserialno is '对象编号';
comment on column ${iol_schema}.icms_awe_erpt_data.treeno is '排序号';
comment on column ${iol_schema}.icms_awe_erpt_data.docid is '文档编号';
comment on column ${iol_schema}.icms_awe_erpt_data.dirid is '目录编号';
comment on column ${iol_schema}.icms_awe_erpt_data.dirname is '目录名称';
comment on column ${iol_schema}.icms_awe_erpt_data.guarantyno is '关联担保号';
comment on column ${iol_schema}.icms_awe_erpt_data.htmldata is '内容';
comment on column ${iol_schema}.icms_awe_erpt_data.contentlength is '长度';
comment on column ${iol_schema}.icms_awe_erpt_data.userid is '登记人';
comment on column ${iol_schema}.icms_awe_erpt_data.orgid is '登记机构';
comment on column ${iol_schema}.icms_awe_erpt_data.inputdate is '登记日期';
comment on column ${iol_schema}.icms_awe_erpt_data.updatedate is '更新日期';
comment on column ${iol_schema}.icms_awe_erpt_data.score is '评分';
comment on column ${iol_schema}.icms_awe_erpt_data.scoredesc is '评分描述';
comment on column ${iol_schema}.icms_awe_erpt_data.saved is '保存标志';
comment on column ${iol_schema}.icms_awe_erpt_data.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_awe_erpt_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_awe_erpt_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_awe_erpt_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_awe_erpt_data.etl_timestamp is 'ETL处理时间戳';
