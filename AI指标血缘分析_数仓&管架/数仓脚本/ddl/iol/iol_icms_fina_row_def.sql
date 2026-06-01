/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_row_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_row_def
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_row_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_row_def(
    rowno number(22) -- 行号
    ,reporttypeno varchar2(32) -- 财报类型编号
    ,sheettype varchar2(18) -- 报表类型
    ,defone varchar2(2000) -- 值一定义
    ,rowoption varchar2(500) -- 行选项
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期登记日期时间
    ,rowname varchar2(200) -- 行名称
    ,updatedate date -- 更新日期
    ,deftwo varchar2(2000) -- 值二定义
    ,updateuserid varchar2(32) -- 更新人
    ,subjectno varchar2(18) -- 科目
    ,updateorgid varchar2(32) -- 更新机构
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
grant select on ${iol_schema}.icms_fina_row_def to ${iml_schema};
grant select on ${iol_schema}.icms_fina_row_def to ${icl_schema};
grant select on ${iol_schema}.icms_fina_row_def to ${idl_schema};
grant select on ${iol_schema}.icms_fina_row_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_row_def is '财报行定义财报模型(描述行模型)原表名:report_model';
comment on column ${iol_schema}.icms_fina_row_def.rowno is '行号';
comment on column ${iol_schema}.icms_fina_row_def.reporttypeno is '财报类型编号';
comment on column ${iol_schema}.icms_fina_row_def.sheettype is '报表类型';
comment on column ${iol_schema}.icms_fina_row_def.defone is '值一定义';
comment on column ${iol_schema}.icms_fina_row_def.rowoption is '行选项';
comment on column ${iol_schema}.icms_fina_row_def.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_row_def.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_row_def.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_row_def.rowname is '行名称';
comment on column ${iol_schema}.icms_fina_row_def.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_row_def.deftwo is '值二定义';
comment on column ${iol_schema}.icms_fina_row_def.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_row_def.subjectno is '科目';
comment on column ${iol_schema}.icms_fina_row_def.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_row_def.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_row_def.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_row_def.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_row_def.etl_timestamp is 'ETL处理时间戳';
