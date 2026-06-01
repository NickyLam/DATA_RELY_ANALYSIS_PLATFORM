/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_alarmstatus_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_alarmstatus_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_alarmstatus_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_alarmstatus_info(
    serialno varchar2(64) -- 流水号
    ,cleardataserialno varchar2(64) -- 信号解除关联DATA流水号
    ,signdescribe varchar2(1000) -- 预警描述
    ,alertapplyserialno varchar2(64) -- 关联预警生效申请流水
    ,updateorgid varchar2(64) -- 更新机构
    ,objecttype varchar2(32) -- 对象类型
    ,updatedate date -- 更新时间
    ,inputdate date -- 登记日期
    ,clearapplyserialno varchar2(64) -- 信号解除关联APPLY流水号
    ,effecttime date -- 信号生效时间
    ,effectdataserialno varchar2(64) -- 信号生效关联DATA流水号
    ,signid varchar2(64) -- 预警号
    ,status varchar2(4) -- 状态
    ,urgentalarm varchar2(4) -- 紧急预警
    ,updateuserid varchar2(64) -- 更新人
    ,cleartime date -- 信号解除时间
    ,objectno varchar2(64) -- 对象号
    ,effectapplyserialno varchar2(64) -- 信号生效关联APPLY流水号
    ,inputuserid varchar2(64) -- 登记人
    ,migtflag varchar2(80) -- 
    ,inputorgid varchar2(64) -- 登记机构
    ,relativeresolveno varchar2(64) -- 关联流水号
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
grant select on ${iol_schema}.icms_alarmstatus_info to ${iml_schema};
grant select on ${iol_schema}.icms_alarmstatus_info to ${icl_schema};
grant select on ${iol_schema}.icms_alarmstatus_info to ${idl_schema};
grant select on ${iol_schema}.icms_alarmstatus_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_alarmstatus_info is '风险预警结果';
comment on column ${iol_schema}.icms_alarmstatus_info.serialno is '流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.cleardataserialno is '信号解除关联DATA流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.signdescribe is '预警描述';
comment on column ${iol_schema}.icms_alarmstatus_info.alertapplyserialno is '关联预警生效申请流水';
comment on column ${iol_schema}.icms_alarmstatus_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_alarmstatus_info.objecttype is '对象类型';
comment on column ${iol_schema}.icms_alarmstatus_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_alarmstatus_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_alarmstatus_info.clearapplyserialno is '信号解除关联APPLY流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.effecttime is '信号生效时间';
comment on column ${iol_schema}.icms_alarmstatus_info.effectdataserialno is '信号生效关联DATA流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.signid is '预警号';
comment on column ${iol_schema}.icms_alarmstatus_info.status is '状态';
comment on column ${iol_schema}.icms_alarmstatus_info.urgentalarm is '紧急预警';
comment on column ${iol_schema}.icms_alarmstatus_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_alarmstatus_info.cleartime is '信号解除时间';
comment on column ${iol_schema}.icms_alarmstatus_info.objectno is '对象号';
comment on column ${iol_schema}.icms_alarmstatus_info.effectapplyserialno is '信号生效关联APPLY流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_alarmstatus_info.migtflag is '';
comment on column ${iol_schema}.icms_alarmstatus_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_alarmstatus_info.relativeresolveno is '关联流水号';
comment on column ${iol_schema}.icms_alarmstatus_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_alarmstatus_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_alarmstatus_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_alarmstatus_info.etl_timestamp is 'ETL处理时间戳';
