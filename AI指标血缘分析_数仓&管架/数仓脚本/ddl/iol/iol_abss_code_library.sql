/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_code_library
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_code_library
whenever sqlerror continue none;
drop table ${iol_schema}.abss_code_library purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_code_library(
    codeno varchar2(48) -- 代码编号
    ,itemno varchar2(48) -- 项目编号
    ,itemname varchar2(375) -- 项目名
    ,bankno varchar2(48) -- 征信代码
    ,sortno varchar2(48) -- 排序号
    ,isinuse varchar2(27) -- 是否使用
    ,itemdescribe varchar2(1200) -- 项目描述
    ,itemattribute varchar2(1200) -- 项目属性
    ,relativecode varchar2(2400) -- 关联代码
    ,attribute1 varchar2(1200) -- 属性1
    ,attribute2 varchar2(375) -- 属性2
    ,attribute3 varchar2(375) -- 属性3
    ,attribute4 varchar2(375) -- 属性4
    ,attribute5 varchar2(375) -- 属性5
    ,attribute6 varchar2(375) -- 属性6
    ,attribute7 varchar2(375) -- 属性7
    ,attribute8 varchar2(375) -- 属性8
    ,inputuser varchar2(48) -- 登记人员
    ,inputorg varchar2(48) -- 登记机构
    ,inputtime varchar2(30) -- 登记时间
    ,updateuser varchar2(48) -- 更新人员
    ,updatetime varchar2(30) -- 更新时间
    ,remark varchar2(375) -- 备注
    ,helptext varchar2(375) -- 帮助文本
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
grant select on ${iol_schema}.abss_code_library to ${iml_schema};
grant select on ${iol_schema}.abss_code_library to ${icl_schema};
grant select on ${iol_schema}.abss_code_library to ${idl_schema};
grant select on ${iol_schema}.abss_code_library to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_code_library is '代码表';
comment on column ${iol_schema}.abss_code_library.codeno is '代码编号';
comment on column ${iol_schema}.abss_code_library.itemno is '项目编号';
comment on column ${iol_schema}.abss_code_library.itemname is '项目名';
comment on column ${iol_schema}.abss_code_library.bankno is '征信代码';
comment on column ${iol_schema}.abss_code_library.sortno is '排序号';
comment on column ${iol_schema}.abss_code_library.isinuse is '是否使用';
comment on column ${iol_schema}.abss_code_library.itemdescribe is '项目描述';
comment on column ${iol_schema}.abss_code_library.itemattribute is '项目属性';
comment on column ${iol_schema}.abss_code_library.relativecode is '关联代码';
comment on column ${iol_schema}.abss_code_library.attribute1 is '属性1';
comment on column ${iol_schema}.abss_code_library.attribute2 is '属性2';
comment on column ${iol_schema}.abss_code_library.attribute3 is '属性3';
comment on column ${iol_schema}.abss_code_library.attribute4 is '属性4';
comment on column ${iol_schema}.abss_code_library.attribute5 is '属性5';
comment on column ${iol_schema}.abss_code_library.attribute6 is '属性6';
comment on column ${iol_schema}.abss_code_library.attribute7 is '属性7';
comment on column ${iol_schema}.abss_code_library.attribute8 is '属性8';
comment on column ${iol_schema}.abss_code_library.inputuser is '登记人员';
comment on column ${iol_schema}.abss_code_library.inputorg is '登记机构';
comment on column ${iol_schema}.abss_code_library.inputtime is '登记时间';
comment on column ${iol_schema}.abss_code_library.updateuser is '更新人员';
comment on column ${iol_schema}.abss_code_library.updatetime is '更新时间';
comment on column ${iol_schema}.abss_code_library.remark is '备注';
comment on column ${iol_schema}.abss_code_library.helptext is '帮助文本';
comment on column ${iol_schema}.abss_code_library.start_dt is '开始时间';
comment on column ${iol_schema}.abss_code_library.end_dt is '结束时间';
comment on column ${iol_schema}.abss_code_library.id_mark is '增删标志';
comment on column ${iol_schema}.abss_code_library.etl_timestamp is 'ETL处理时间戳';
