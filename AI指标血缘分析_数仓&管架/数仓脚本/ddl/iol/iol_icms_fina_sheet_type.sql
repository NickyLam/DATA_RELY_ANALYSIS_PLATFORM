/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_sheet_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_sheet_type
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_sheet_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_sheet_type(
    reporttypeno varchar2(32) -- 财报类型编号
    ,sheettype varchar2(18) -- 报表类型
    ,available varchar2(1) -- 可用
    ,remark varchar2(500) -- 描述
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期登记日期时间
    ,inputuserid varchar2(32) -- 登记人
    ,sheetname varchar2(80) -- 报表名
    ,inputorgid varchar2(32) -- 登记机构
    ,sortno number(22) -- 排序号
    ,updateorgid varchar2(32) -- 更新机构
    ,updateuserid varchar2(32) -- 更新人
    ,header varchar2(500) -- 表头
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
grant select on ${iol_schema}.icms_fina_sheet_type to ${iml_schema};
grant select on ${iol_schema}.icms_fina_sheet_type to ${icl_schema};
grant select on ${iol_schema}.icms_fina_sheet_type to ${idl_schema};
grant select on ${iol_schema}.icms_fina_sheet_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_sheet_type is '报表类别财报目录   原表名 report_catalog';
comment on column ${iol_schema}.icms_fina_sheet_type.reporttypeno is '财报类型编号';
comment on column ${iol_schema}.icms_fina_sheet_type.sheettype is '报表类型';
comment on column ${iol_schema}.icms_fina_sheet_type.available is '可用';
comment on column ${iol_schema}.icms_fina_sheet_type.remark is '描述';
comment on column ${iol_schema}.icms_fina_sheet_type.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_sheet_type.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_sheet_type.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_sheet_type.sheetname is '报表名';
comment on column ${iol_schema}.icms_fina_sheet_type.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_sheet_type.sortno is '排序号';
comment on column ${iol_schema}.icms_fina_sheet_type.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_sheet_type.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_sheet_type.header is '表头';
comment on column ${iol_schema}.icms_fina_sheet_type.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_sheet_type.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_sheet_type.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_sheet_type.etl_timestamp is 'ETL处理时间戳';
