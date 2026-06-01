/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_bank_executed
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_bank_executed
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_bank_executed purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_bank_executed(
    executeno varchar2(64) -- 我行被执行编号
    ,inputuserid varchar2(64) -- 录入人
    ,updatedate date -- 更新日期
    ,caseno varchar2(64) -- 关联案件编号
    ,updateuserid varchar2(64) -- 更新人
    ,executecourt varchar2(160) -- 执行法院
    ,inputorgid varchar2(64) -- 录入机构
    ,excuteduserid varchar2(64) -- 执行对象编号
    ,executeprocess varchar2(4000) -- 执行过程
    ,inputdate date -- 录入日期
    ,updateorgid varchar2(64) -- 更新机构
    ,applyexecuterid varchar2(64) -- 申请执行人编号
    ,executeflag varchar2(12) -- 执行状态
    ,applyexecutername varchar2(160) -- 申请执行人名称
    ,directjudgetel varchar2(36) -- 承办法官联系方式
    ,directjudgeid varchar2(64) -- 承办法官编号
    ,caseprogramstage varchar2(36) -- 案件阶段
    ,excutedusername varchar2(160) -- 执行对象名称
    ,directjudgename varchar2(160) -- 承办法官名称
    ,executecaseno varchar2(64) -- 执行案号
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
grant select on ${iol_schema}.icms_ap_bank_executed to ${iml_schema};
grant select on ${iol_schema}.icms_ap_bank_executed to ${icl_schema};
grant select on ${iol_schema}.icms_ap_bank_executed to ${idl_schema};
grant select on ${iol_schema}.icms_ap_bank_executed to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_bank_executed is '我行被执行信息表';
comment on column ${iol_schema}.icms_ap_bank_executed.executeno is '我行被执行编号';
comment on column ${iol_schema}.icms_ap_bank_executed.inputuserid is '录入人';
comment on column ${iol_schema}.icms_ap_bank_executed.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_bank_executed.caseno is '关联案件编号';
comment on column ${iol_schema}.icms_ap_bank_executed.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_bank_executed.executecourt is '执行法院';
comment on column ${iol_schema}.icms_ap_bank_executed.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_ap_bank_executed.excuteduserid is '执行对象编号';
comment on column ${iol_schema}.icms_ap_bank_executed.executeprocess is '执行过程';
comment on column ${iol_schema}.icms_ap_bank_executed.inputdate is '录入日期';
comment on column ${iol_schema}.icms_ap_bank_executed.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_bank_executed.applyexecuterid is '申请执行人编号';
comment on column ${iol_schema}.icms_ap_bank_executed.executeflag is '执行状态';
comment on column ${iol_schema}.icms_ap_bank_executed.applyexecutername is '申请执行人名称';
comment on column ${iol_schema}.icms_ap_bank_executed.directjudgetel is '承办法官联系方式';
comment on column ${iol_schema}.icms_ap_bank_executed.directjudgeid is '承办法官编号';
comment on column ${iol_schema}.icms_ap_bank_executed.caseprogramstage is '案件阶段';
comment on column ${iol_schema}.icms_ap_bank_executed.excutedusername is '执行对象名称';
comment on column ${iol_schema}.icms_ap_bank_executed.directjudgename is '承办法官名称';
comment on column ${iol_schema}.icms_ap_bank_executed.executecaseno is '执行案号';
comment on column ${iol_schema}.icms_ap_bank_executed.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_bank_executed.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_bank_executed.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_bank_executed.etl_timestamp is 'ETL处理时间戳';
