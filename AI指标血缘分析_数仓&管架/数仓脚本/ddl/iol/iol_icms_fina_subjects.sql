/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fina_subjects
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fina_subjects
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fina_subjects purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_subjects(
    subjectno varchar2(30) -- 科目编号
    ,primaryclass varchar2(80) -- 一级分类
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,auxiliaryaccounting varchar2(80) -- 辅助核算
    ,available varchar2(1) -- 可用
    ,remark varchar2(500) -- 备注
    ,foreigncurrency varchar2(32) -- 外币核算
    ,inputdate date -- 登记日期登记日期时间
    ,valuetype varchar2(32) -- 值类型
    ,direction varchar2(32) -- 方向
    ,secondaryclass varchar2(80) -- 二级分类
    ,transferending varchar2(6) -- 期末调汇
    ,updateuserid varchar2(32) -- 更新人
    ,inputuserid varchar2(32) -- 登记人
    ,subjectname varchar2(200) -- 科目名称
    ,inputorgid varchar2(32) -- 登记机构
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
grant select on ${iol_schema}.icms_fina_subjects to ${iml_schema};
grant select on ${iol_schema}.icms_fina_subjects to ${icl_schema};
grant select on ${iol_schema}.icms_fina_subjects to ${idl_schema};
grant select on ${iol_schema}.icms_fina_subjects to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fina_subjects is '财务科目 原表名:report_subjects';
comment on column ${iol_schema}.icms_fina_subjects.subjectno is '科目编号';
comment on column ${iol_schema}.icms_fina_subjects.primaryclass is '一级分类';
comment on column ${iol_schema}.icms_fina_subjects.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_fina_subjects.updatedate is '更新日期';
comment on column ${iol_schema}.icms_fina_subjects.auxiliaryaccounting is '辅助核算';
comment on column ${iol_schema}.icms_fina_subjects.available is '可用';
comment on column ${iol_schema}.icms_fina_subjects.remark is '备注';
comment on column ${iol_schema}.icms_fina_subjects.foreigncurrency is '外币核算';
comment on column ${iol_schema}.icms_fina_subjects.inputdate is '登记日期登记日期时间';
comment on column ${iol_schema}.icms_fina_subjects.valuetype is '值类型';
comment on column ${iol_schema}.icms_fina_subjects.direction is '方向';
comment on column ${iol_schema}.icms_fina_subjects.secondaryclass is '二级分类';
comment on column ${iol_schema}.icms_fina_subjects.transferending is '期末调汇';
comment on column ${iol_schema}.icms_fina_subjects.updateuserid is '更新人';
comment on column ${iol_schema}.icms_fina_subjects.inputuserid is '登记人';
comment on column ${iol_schema}.icms_fina_subjects.subjectname is '科目名称';
comment on column ${iol_schema}.icms_fina_subjects.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_fina_subjects.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fina_subjects.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fina_subjects.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fina_subjects.etl_timestamp is 'ETL处理时间戳';
