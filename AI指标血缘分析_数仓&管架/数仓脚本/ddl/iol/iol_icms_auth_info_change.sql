/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_auth_info_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_auth_info_change
whenever sqlerror continue none;
drop table ${iol_schema}.icms_auth_info_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_auth_info_change(
    serialno varchar2(64) -- 流水号
    ,ruleid varchar2(64) -- 规则编号
    ,occurdate date -- 变更时间
    ,changecontext varchar2(4000) -- 变更内容
    ,customerid varchar2(64) -- 变更人
    ,occurtype varchar2(16) -- 变更类型
    ,programid varchar2(64) -- 方案编号
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
grant select on ${iol_schema}.icms_auth_info_change to ${iml_schema};
grant select on ${iol_schema}.icms_auth_info_change to ${icl_schema};
grant select on ${iol_schema}.icms_auth_info_change to ${idl_schema};
grant select on ${iol_schema}.icms_auth_info_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_auth_info_change is '授权方案变更记录';
comment on column ${iol_schema}.icms_auth_info_change.serialno is '流水号';
comment on column ${iol_schema}.icms_auth_info_change.ruleid is '规则编号';
comment on column ${iol_schema}.icms_auth_info_change.occurdate is '变更时间';
comment on column ${iol_schema}.icms_auth_info_change.changecontext is '变更内容';
comment on column ${iol_schema}.icms_auth_info_change.customerid is '变更人';
comment on column ${iol_schema}.icms_auth_info_change.occurtype is '变更类型';
comment on column ${iol_schema}.icms_auth_info_change.programid is '方案编号';
comment on column ${iol_schema}.icms_auth_info_change.start_dt is '开始时间';
comment on column ${iol_schema}.icms_auth_info_change.end_dt is '结束时间';
comment on column ${iol_schema}.icms_auth_info_change.id_mark is '增删标志';
comment on column ${iol_schema}.icms_auth_info_change.etl_timestamp is 'ETL处理时间戳';
