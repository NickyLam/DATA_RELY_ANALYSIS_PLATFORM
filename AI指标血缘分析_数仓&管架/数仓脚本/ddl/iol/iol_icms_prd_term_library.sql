/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_term_library
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_term_library
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_term_library purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_term_library(
    termid varchar2(64) -- 条款编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,valueclass varchar2(400) -- 取值逻辑
    ,inputuserid varchar2(64) -- 登记人
    ,sortno varchar2(64) -- 排序号
    ,updatedate date -- 更新日期
    ,inputdate date -- 登记日期
    ,inputtype varchar2(64) -- 输入类型
    ,inputorgid varchar2(64) -- 登记机构
    ,fromcode varchar2(64) -- 码值
    ,remark varchar2(2000) -- 备注
    ,updateuserid varchar2(64) -- 更新人
    ,termname varchar2(160) -- 条款名称
    ,termtype varchar2(64) -- 条款种类
    ,isinuse varchar2(2) -- 是否使用
    ,updateorgid varchar2(64) -- 更新机构
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
grant select on ${iol_schema}.icms_prd_term_library to ${iml_schema};
grant select on ${iol_schema}.icms_prd_term_library to ${icl_schema};
grant select on ${iol_schema}.icms_prd_term_library to ${idl_schema};
grant select on ${iol_schema}.icms_prd_term_library to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_term_library is '产品条款库产品条款库';
comment on column ${iol_schema}.icms_prd_term_library.termid is '条款编号';
comment on column ${iol_schema}.icms_prd_term_library.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_term_library.valueclass is '取值逻辑';
comment on column ${iol_schema}.icms_prd_term_library.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_term_library.sortno is '排序号';
comment on column ${iol_schema}.icms_prd_term_library.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_term_library.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_term_library.inputtype is '输入类型';
comment on column ${iol_schema}.icms_prd_term_library.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_term_library.fromcode is '码值';
comment on column ${iol_schema}.icms_prd_term_library.remark is '备注';
comment on column ${iol_schema}.icms_prd_term_library.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_term_library.termname is '条款名称';
comment on column ${iol_schema}.icms_prd_term_library.termtype is '条款种类';
comment on column ${iol_schema}.icms_prd_term_library.isinuse is '是否使用';
comment on column ${iol_schema}.icms_prd_term_library.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_term_library.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_term_library.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_term_library.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_term_library.etl_timestamp is 'ETL处理时间戳';
