/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_prd_term_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_prd_term_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_prd_term_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_term_data(
    versionid varchar2(64) -- 版本编号
    ,componentid varchar2(64) -- 组件编号
    ,termid varchar2(64) -- 条款编号
    ,inputdate date -- 登记日期
    ,termvaluename varchar2(2000) -- 条款值名称
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,controltype varchar2(12) -- 控制类型
    ,updatedate date -- 更新日期
    ,inputuserid varchar2(64) -- 登记人
    ,termvaluetwo varchar2(4000) -- 条款右值
    ,controlscene varchar2(12) -- 控制场景
    ,termvalue varchar2(4000) -- 条款值
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_prd_term_data to ${iml_schema};
grant select on ${iol_schema}.icms_prd_term_data to ${icl_schema};
grant select on ${iol_schema}.icms_prd_term_data to ${idl_schema};
grant select on ${iol_schema}.icms_prd_term_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_prd_term_data is '产品条款数据';
comment on column ${iol_schema}.icms_prd_term_data.versionid is '版本编号';
comment on column ${iol_schema}.icms_prd_term_data.componentid is '组件编号';
comment on column ${iol_schema}.icms_prd_term_data.termid is '条款编号';
comment on column ${iol_schema}.icms_prd_term_data.inputdate is '登记日期';
comment on column ${iol_schema}.icms_prd_term_data.termvaluename is '条款值名称';
comment on column ${iol_schema}.icms_prd_term_data.updateuserid is '更新人';
comment on column ${iol_schema}.icms_prd_term_data.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_prd_term_data.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_prd_term_data.controltype is '控制类型';
comment on column ${iol_schema}.icms_prd_term_data.updatedate is '更新日期';
comment on column ${iol_schema}.icms_prd_term_data.inputuserid is '登记人';
comment on column ${iol_schema}.icms_prd_term_data.termvaluetwo is '条款右值';
comment on column ${iol_schema}.icms_prd_term_data.controlscene is '控制场景';
comment on column ${iol_schema}.icms_prd_term_data.termvalue is '条款值';
comment on column ${iol_schema}.icms_prd_term_data.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_prd_term_data.start_dt is '开始时间';
comment on column ${iol_schema}.icms_prd_term_data.end_dt is '结束时间';
comment on column ${iol_schema}.icms_prd_term_data.id_mark is '增删标志';
comment on column ${iol_schema}.icms_prd_term_data.etl_timestamp is 'ETL处理时间戳';
