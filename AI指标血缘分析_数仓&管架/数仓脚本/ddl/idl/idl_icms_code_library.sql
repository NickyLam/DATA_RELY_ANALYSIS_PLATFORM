/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_code_library
CreateDate: 20250527
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_code_library purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_code_library(
etl_dt date --数据日期
,attribute6 varchar2(1000) --属性6
,inputuser varchar2(64) --登记人
,attribute8 varchar2(1000) --属性8
,updatetime varchar2(64) --
,attribute3 varchar2(1000) --属性3
,helptext varchar2(1000) --帮助
,attribute9 varchar2(1000) --屬性9
,itemdescribe varchar2(2000) --项目描述
,updatedate date --更新日期
,remark varchar2(1000) --备注
,parentitemno varchar2(64) --关联上级编号
,inputorg varchar2(64) --登记机构
,attribute1 varchar2(2000) --属性1
,attribute7 varchar2(1000) --属性7
,inputdate date --登记日期
,attribute5 varchar2(1000) --属性5
,attribute4 varchar2(1000) --属性4
,codeno varchar2(64) --代码编号
,itemno varchar2(64) --代码项编号
,relativecode varchar2(4000) --关联代码
,sortno varchar2(64) --排序号
,isinuse varchar2(64) --是否使用
,mappingcode varchar2(20) --映射到其他系统的码值
,updateuser varchar2(64) --更新人
,updateorg varchar2(64) --更新机构
,bankno varchar2(64) --征信代码
,itemattribute varchar2(2000) --项目属性
,itemname varchar2(1000) --代码项名称
,attribute2 varchar2(1000) --属性2
,inputtime varchar2(64) --

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_code_library to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_code_library is '代码表代码库';
comment on column ${idl_schema}.icms_code_library.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_code_library.attribute6 is '属性6';
comment on column ${idl_schema}.icms_code_library.inputuser is '登记人';
comment on column ${idl_schema}.icms_code_library.attribute8 is '属性8';
comment on column ${idl_schema}.icms_code_library.updatetime is '';
comment on column ${idl_schema}.icms_code_library.attribute3 is '属性3';
comment on column ${idl_schema}.icms_code_library.helptext is '帮助';
comment on column ${idl_schema}.icms_code_library.attribute9 is '屬性9';
comment on column ${idl_schema}.icms_code_library.itemdescribe is '项目描述';
comment on column ${idl_schema}.icms_code_library.updatedate is '更新日期';
comment on column ${idl_schema}.icms_code_library.remark is '备注';
comment on column ${idl_schema}.icms_code_library.parentitemno is '关联上级编号';
comment on column ${idl_schema}.icms_code_library.inputorg is '登记机构';
comment on column ${idl_schema}.icms_code_library.attribute1 is '属性1';
comment on column ${idl_schema}.icms_code_library.attribute7 is '属性7';
comment on column ${idl_schema}.icms_code_library.inputdate is '登记日期';
comment on column ${idl_schema}.icms_code_library.attribute5 is '属性5';
comment on column ${idl_schema}.icms_code_library.attribute4 is '属性4';
comment on column ${idl_schema}.icms_code_library.codeno is '代码编号';
comment on column ${idl_schema}.icms_code_library.itemno is '代码项编号';
comment on column ${idl_schema}.icms_code_library.relativecode is '关联代码';
comment on column ${idl_schema}.icms_code_library.sortno is '排序号';
comment on column ${idl_schema}.icms_code_library.isinuse is '是否使用';
comment on column ${idl_schema}.icms_code_library.mappingcode is '映射到其他系统的码值';
comment on column ${idl_schema}.icms_code_library.updateuser is '更新人';
comment on column ${idl_schema}.icms_code_library.updateorg is '更新机构';
comment on column ${idl_schema}.icms_code_library.bankno is '征信代码';
comment on column ${idl_schema}.icms_code_library.itemattribute is '项目属性';
comment on column ${idl_schema}.icms_code_library.itemname is '代码项名称';
comment on column ${idl_schema}.icms_code_library.attribute2 is '属性2';
comment on column ${idl_schema}.icms_code_library.inputtime is '';

