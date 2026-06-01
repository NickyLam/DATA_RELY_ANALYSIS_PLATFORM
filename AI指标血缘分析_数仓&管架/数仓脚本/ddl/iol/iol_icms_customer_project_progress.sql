/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_project_progress
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_project_progress
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_project_progress purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_progress(
    serialno varchar2(64) -- 流水号
    ,inspectionuser varchar2(64) -- 督查提起人
    ,remark varchar2(1000) -- 备注
    ,inputuserid varchar2(64) -- 登记人
    ,investedsum number(24,6) -- 已投资金额
    ,uptodate date -- 调查日期
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,projectstatus varchar2(2000) -- 项目进展情况
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,projectno varchar2(64) -- 项目编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,updatedate date -- 更新日期
    ,projectplan varchar2(64) -- 项目计划
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
grant select on ${iol_schema}.icms_customer_project_progress to ${iml_schema};
grant select on ${iol_schema}.icms_customer_project_progress to ${icl_schema};
grant select on ${iol_schema}.icms_customer_project_progress to ${idl_schema};
grant select on ${iol_schema}.icms_customer_project_progress to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_project_progress is '项目进展情况项目进展情况';
comment on column ${iol_schema}.icms_customer_project_progress.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_project_progress.inspectionuser is '督查提起人';
comment on column ${iol_schema}.icms_customer_project_progress.remark is '备注';
comment on column ${iol_schema}.icms_customer_project_progress.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_project_progress.investedsum is '已投资金额';
comment on column ${iol_schema}.icms_customer_project_progress.uptodate is '调查日期';
comment on column ${iol_schema}.icms_customer_project_progress.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_project_progress.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_project_progress.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_project_progress.projectstatus is '项目进展情况';
comment on column ${iol_schema}.icms_customer_project_progress.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_project_progress.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_project_progress.projectno is '项目编号';
comment on column ${iol_schema}.icms_customer_project_progress.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_project_progress.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_project_progress.projectplan is '项目计划';
comment on column ${iol_schema}.icms_customer_project_progress.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_project_progress.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_project_progress.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_project_progress.etl_timestamp is 'ETL处理时间戳';
