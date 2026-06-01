/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_log_auditinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_log_auditinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_log_auditinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_log_auditinfo(
    logid varchar2(64) -- 日志编号
    ,audittype varchar2(64) -- 审计类型
    ,runsql varchar2(1000) -- sql运行语句
    ,remark varchar2(1000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,username varchar2(160) -- 用户名称
    ,inputuserid varchar2(64) -- 登记人
    ,inputdate date -- 登记日期
    ,changeuserid varchar2(64) -- 替换用户编号
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,userid varchar2(64) -- 用户编号
    ,updateuserid varchar2(64) -- 更新人
    ,changeusername varchar2(160) -- 替换用户名称
    ,remark2 varchar2(1000) -- 备注2
    ,begintime varchar2(64) -- 开始时间
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
grant select on ${iol_schema}.icms_log_auditinfo to ${iml_schema};
grant select on ${iol_schema}.icms_log_auditinfo to ${icl_schema};
grant select on ${iol_schema}.icms_log_auditinfo to ${idl_schema};
grant select on ${iol_schema}.icms_log_auditinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_log_auditinfo is '安全选项变更日志表用户痕迹表';
comment on column ${iol_schema}.icms_log_auditinfo.logid is '日志编号';
comment on column ${iol_schema}.icms_log_auditinfo.audittype is '审计类型';
comment on column ${iol_schema}.icms_log_auditinfo.runsql is 'sql运行语句';
comment on column ${iol_schema}.icms_log_auditinfo.remark is '备注';
comment on column ${iol_schema}.icms_log_auditinfo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_log_auditinfo.username is '用户名称';
comment on column ${iol_schema}.icms_log_auditinfo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_log_auditinfo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_log_auditinfo.changeuserid is '替换用户编号';
comment on column ${iol_schema}.icms_log_auditinfo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_log_auditinfo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_log_auditinfo.userid is '用户编号';
comment on column ${iol_schema}.icms_log_auditinfo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_log_auditinfo.changeusername is '替换用户名称';
comment on column ${iol_schema}.icms_log_auditinfo.remark2 is '备注2';
comment on column ${iol_schema}.icms_log_auditinfo.begintime is '开始时间';
comment on column ${iol_schema}.icms_log_auditinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_log_auditinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_log_auditinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_log_auditinfo.etl_timestamp is 'ETL处理时间戳';
