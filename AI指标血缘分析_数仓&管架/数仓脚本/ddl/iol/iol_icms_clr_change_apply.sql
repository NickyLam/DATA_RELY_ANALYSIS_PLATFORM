/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_change_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_change_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_change_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_change_apply(
    serialno varchar2(192) -- 变更申请流水号
    ,changetype varchar2(96) -- 任务类型
    ,operatetype varchar2(96) -- 触发方式
    ,approvestatus varchar2(96) -- 审批状态
    ,inputuserid varchar2(192) -- 登记人
    ,inputorgid varchar2(192) -- 登记机构
    ,inputtime timestamp -- 登记时间
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
grant select on ${iol_schema}.icms_clr_change_apply to ${iml_schema};
grant select on ${iol_schema}.icms_clr_change_apply to ${icl_schema};
grant select on ${iol_schema}.icms_clr_change_apply to ${idl_schema};
grant select on ${iol_schema}.icms_clr_change_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_change_apply is '押品信息变更申请记录表';
comment on column ${iol_schema}.icms_clr_change_apply.serialno is '变更申请流水号';
comment on column ${iol_schema}.icms_clr_change_apply.changetype is '任务类型';
comment on column ${iol_schema}.icms_clr_change_apply.operatetype is '触发方式';
comment on column ${iol_schema}.icms_clr_change_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_clr_change_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_change_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_change_apply.inputtime is '登记时间';
comment on column ${iol_schema}.icms_clr_change_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_change_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_change_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_change_apply.etl_timestamp is 'ETL处理时间戳';
