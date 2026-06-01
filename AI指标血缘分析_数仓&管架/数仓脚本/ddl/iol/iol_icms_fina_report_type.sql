/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_report_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_report_type
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_report_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_report_type(
    reporttypeno varchar2(32) -- 财报类型编号
    ,reporttypename varchar2(80) -- 财报类型名称
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,updateuserid varchar2(32) -- 更新人
    ,sortno varchar2(18) -- 排序号
    ,available varchar2(1) -- 可用
    ,inputdate date -- 登记日期登记日期时间
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(32) -- 更新机构
    ,remark varchar2(500) -- 备注
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
grant select on ${iol_schema}.icms_fina_report_type to ${iml_schema};
grant select on ${iol_schema}.icms_fina_report_type to ${icl_schema};
grant select on ${iol_schema}.icms_fina_report_type to ${idl_schema};
grant select on ${iol_schema}.icms_fina_report_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_report_type is '财务报表类型';
comment on column ${iol_schema}.icms_fina_report_type.reporttypeno is '财报类型编号';
comment on column ${iol_schema}.icms_fina_report_type.reporttypename is '财报类型名称';
comment on column ${iol_schema}.icms_fina_report_type.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_report_type.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_report_type.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_report_type.sortno is '排序号';
comment on column ${iol_schema}.icms_fina_report_type.available is '可用';
comment on column ${iol_schema}.icms_fina_report_type.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_report_type.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_report_type.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_report_type.remark is '备注';
comment on column ${iol_schema}.icms_fina_report_type.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_report_type.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_report_type.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_report_type.etl_timestamp is 'ETL处理时间戳';
