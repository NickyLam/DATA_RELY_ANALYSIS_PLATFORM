/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_sheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_sheet
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_sheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_sheet(
    sheetno varchar2(64) -- 报表号
    ,reportscope varchar2(18) -- 报表口径(冗余)
    ,reportperiod varchar2(18) -- 报表周期(冗余)
    ,customerid varchar2(32) -- 客户编号(冗余)
    ,inputuserid varchar2(32) -- 登记人
    ,calculateerrorinfo varchar2(4000) -- 计算错误信息
    ,reportname varchar2(80) -- 报表名称
    ,sheettype varchar2(18) -- 报表类型
    ,accountingmonth varchar2(18) -- 会计月(冗余)
    ,inputorgid varchar2(32) -- 登记机构
    ,updateuserid varchar2(32) -- 更新人
    ,reportno varchar2(32) -- 财报号
    ,updatedate date -- 更新日期
    ,migtflag varchar2(80) -- 
    ,inputdate date -- 登记日期登记日期时间
    ,updateorgid varchar2(32) -- 更新机构
    ,reporttypeno varchar2(32) -- 财报类型编号
    ,deleteflag varchar2(1) -- 删除标志
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
grant select on ${iol_schema}.icms_fina_sheet to ${iml_schema};
grant select on ${iol_schema}.icms_fina_sheet to ${icl_schema};
grant select on ${iol_schema}.icms_fina_sheet to ${idl_schema};
grant select on ${iol_schema}.icms_fina_sheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_sheet is '财报表财报表 即一个表(如资产负债表),记录只能来自模型 原表名:report_record';
comment on column ${iol_schema}.icms_fina_sheet.sheetno is '报表号';
comment on column ${iol_schema}.icms_fina_sheet.reportscope is '报表口径(冗余)';
comment on column ${iol_schema}.icms_fina_sheet.reportperiod is '报表周期(冗余)';
comment on column ${iol_schema}.icms_fina_sheet.customerid is '客户编号(冗余)';
comment on column ${iol_schema}.icms_fina_sheet.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_sheet.calculateerrorinfo is '计算错误信息';
comment on column ${iol_schema}.icms_fina_sheet.reportname is '报表名称';
comment on column ${iol_schema}.icms_fina_sheet.sheettype is '报表类型';
comment on column ${iol_schema}.icms_fina_sheet.accountingmonth is '会计月(冗余)';
comment on column ${iol_schema}.icms_fina_sheet.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_sheet.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_sheet.reportno is '财报号';
comment on column ${iol_schema}.icms_fina_sheet.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_sheet.migtflag is '';
comment on column ${iol_schema}.icms_fina_sheet.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_sheet.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_sheet.reporttypeno is '财报类型编号';
comment on column ${iol_schema}.icms_fina_sheet.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_fina_sheet.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_sheet.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_sheet.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_sheet.etl_timestamp is 'ETL处理时间戳';
