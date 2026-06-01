/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_row
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_row
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_row purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_row(
    rowno number(22) -- 行号
    ,sheetno varchar2(64) -- 报表号
    ,inputuserid varchar2(32) -- 登记人
    ,valueone varchar2(25) -- 值一
    ,rowname varchar2(160) -- 行名称
    ,standardvalue number(24,6) -- 标准值
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,subjectno varchar2(32) -- 科目
    ,valuetwo varchar2(25) -- 值二
    ,inputdate date -- 登记日期登记日期时间
    ,inputorgid varchar2(32) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,valuefour number(24,6) -- 列4值
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,valuethree number(24,6) -- 列3值
    ,displayorder varchar2(32) -- 显示次序
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
grant select on ${iol_schema}.icms_fina_row to ${iml_schema};
grant select on ${iol_schema}.icms_fina_row to ${icl_schema};
grant select on ${iol_schema}.icms_fina_row to ${idl_schema};
grant select on ${iol_schema}.icms_fina_row to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_row is '财报行数据财报数据 原表名: report_data';
comment on column ${iol_schema}.icms_fina_row.rowno is '行号';
comment on column ${iol_schema}.icms_fina_row.sheetno is '报表号';
comment on column ${iol_schema}.icms_fina_row.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_row.valueone is '值一';
comment on column ${iol_schema}.icms_fina_row.rowname is '行名称';
comment on column ${iol_schema}.icms_fina_row.standardvalue is '标准值';
comment on column ${iol_schema}.icms_fina_row.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_fina_row.subjectno is '科目';
comment on column ${iol_schema}.icms_fina_row.valuetwo is '值二';
comment on column ${iol_schema}.icms_fina_row.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_row.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_row.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_row.valuefour is '列4值';
comment on column ${iol_schema}.icms_fina_row.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_row.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_row.valuethree is '列3值';
comment on column ${iol_schema}.icms_fina_row.displayorder is '显示次序';
comment on column ${iol_schema}.icms_fina_row.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_row.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_row.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_row.etl_timestamp is 'ETL处理时间戳';
