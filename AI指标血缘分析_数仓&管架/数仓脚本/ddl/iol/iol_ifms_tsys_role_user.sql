/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_role_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_role_user
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_role_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_role_user(
    user_code varchar2(48) -- 
    ,role_code varchar2(24) -- 
    ,right_flag varchar2(12) -- 
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
grant select on ${iol_schema}.ifms_tsys_role_user to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_role_user to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_role_user to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_role_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_role_user is '角色用户关系表';
comment on column ${iol_schema}.ifms_tsys_role_user.user_code is '';
comment on column ${iol_schema}.ifms_tsys_role_user.role_code is '';
comment on column ${iol_schema}.ifms_tsys_role_user.right_flag is '';
comment on column ${iol_schema}.ifms_tsys_role_user.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifms_tsys_role_user.etl_timestamp is 'ETL处理时间戳';
