/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tk_user_role_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tk_user_role_data
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tk_user_role_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tk_user_role_data(
    serialno varchar2(64) -- 流水号
    ,userid varchar2(64) -- 用户编号
    ,username varchar2(200) -- 用户名称
    ,orgid varchar2(64) -- 机构编号
    ,roleid varchar2(4000) -- 角色编号
    ,inputdate date -- 数据时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_tk_user_role_data to ${iml_schema};
grant select on ${iol_schema}.icms_tk_user_role_data to ${icl_schema};
grant select on ${iol_schema}.icms_tk_user_role_data to ${idl_schema};
grant select on ${iol_schema}.icms_tk_user_role_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tk_user_role_data is '推送经营平台用户角色中间表';
comment on column ${iol_schema}.icms_tk_user_role_data.serialno is '流水号';
comment on column ${iol_schema}.icms_tk_user_role_data.userid is '用户编号';
comment on column ${iol_schema}.icms_tk_user_role_data.username is '用户名称';
comment on column ${iol_schema}.icms_tk_user_role_data.orgid is '机构编号';
comment on column ${iol_schema}.icms_tk_user_role_data.roleid is '角色编号';
comment on column ${iol_schema}.icms_tk_user_role_data.inputdate is '数据时间';
comment on column ${iol_schema}.icms_tk_user_role_data.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tk_user_role_data.etl_timestamp is 'ETL处理时间戳';
