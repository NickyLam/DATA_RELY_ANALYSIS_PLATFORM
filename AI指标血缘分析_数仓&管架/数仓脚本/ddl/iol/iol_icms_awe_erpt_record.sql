/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_awe_erpt_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_awe_erpt_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_awe_erpt_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_awe_erpt_record(
    serialno varchar2(32) -- 流水号字段
    ,attribute4 varchar2(80) -- 属性4
    ,updatedate varchar2(10) -- 更新日期
    ,attribute2 varchar2(80) -- 属性2
    ,attribute3 varchar2(80) -- 属性3
    ,attribute5 varchar2(80) -- 属性5
    ,objecttype varchar2(64) -- 对象类型
    ,objectno varchar2(32) -- 对象编号
    ,offlineversion number(22) -- 离线报告最新版本号
    ,savepath varchar2(500) -- 保存路径
    ,docid varchar2(32) -- 文档类型编号
    ,attribute1 varchar2(80) -- 属性1
    ,savedate varchar2(10) -- 生成报告日期
    ,orgid varchar2(32) -- 登记机构
    ,userid varchar2(32) -- 登记人
    ,inputdate varchar2(10) -- 登记日期
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
grant select on ${iol_schema}.icms_awe_erpt_record to ${iml_schema};
grant select on ${iol_schema}.icms_awe_erpt_record to ${icl_schema};
grant select on ${iol_schema}.icms_awe_erpt_record to ${idl_schema};
grant select on ${iol_schema}.icms_awe_erpt_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_awe_erpt_record is '格式化文档记录';
comment on column ${iol_schema}.icms_awe_erpt_record.serialno is '流水号字段';
comment on column ${iol_schema}.icms_awe_erpt_record.attribute4 is '属性4';
comment on column ${iol_schema}.icms_awe_erpt_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_awe_erpt_record.attribute2 is '属性2';
comment on column ${iol_schema}.icms_awe_erpt_record.attribute3 is '属性3';
comment on column ${iol_schema}.icms_awe_erpt_record.attribute5 is '属性5';
comment on column ${iol_schema}.icms_awe_erpt_record.objecttype is '对象类型';
comment on column ${iol_schema}.icms_awe_erpt_record.objectno is '对象编号';
comment on column ${iol_schema}.icms_awe_erpt_record.offlineversion is '离线报告最新版本号';
comment on column ${iol_schema}.icms_awe_erpt_record.savepath is '保存路径';
comment on column ${iol_schema}.icms_awe_erpt_record.docid is '文档类型编号';
comment on column ${iol_schema}.icms_awe_erpt_record.attribute1 is '属性1';
comment on column ${iol_schema}.icms_awe_erpt_record.savedate is '生成报告日期';
comment on column ${iol_schema}.icms_awe_erpt_record.orgid is '登记机构';
comment on column ${iol_schema}.icms_awe_erpt_record.userid is '登记人';
comment on column ${iol_schema}.icms_awe_erpt_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_awe_erpt_record.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_awe_erpt_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_awe_erpt_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_awe_erpt_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_awe_erpt_record.etl_timestamp is 'ETL处理时间戳';
