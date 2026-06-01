/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol svss_svs_log_accadmlog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.svss_svs_log_accadmlog
whenever sqlerror continue none;
drop table ${iol_schema}.svss_svs_log_accadmlog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svss_svs_log_accadmlog(
    id varchar2(48) -- 主键ID
    ,operate_type number(22,0) -- 操作类型
    ,operate_code varchar2(48) -- 操作柜员号
    ,operate_date varchar2(48) -- 操作日期
    ,operate_time varchar2(48) -- 操作时间
    ,operate_org_no varchar2(48) -- 操作柜员的机构号
    ,memo varchar2(4000) -- 备注
    ,acc_no varchar2(48) -- 备操作的账户的账号
    ,acc_name varchar2(768) -- 户名
    ,auth_people_code varchar2(48) -- 授权人员
    ,auth_people_name varchar2(96) -- 授权人员姓名
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
grant select on ${iol_schema}.svss_svs_log_accadmlog to ${iml_schema};
grant select on ${iol_schema}.svss_svs_log_accadmlog to ${icl_schema};
grant select on ${iol_schema}.svss_svs_log_accadmlog to ${idl_schema};
grant select on ${iol_schema}.svss_svs_log_accadmlog to ${iel_schema};

-- comment
comment on table ${iol_schema}.svss_svs_log_accadmlog is '验印系统账户管理日志';
comment on column ${iol_schema}.svss_svs_log_accadmlog.id is '主键ID';
comment on column ${iol_schema}.svss_svs_log_accadmlog.operate_type is '操作类型';
comment on column ${iol_schema}.svss_svs_log_accadmlog.operate_code is '操作柜员号';
comment on column ${iol_schema}.svss_svs_log_accadmlog.operate_date is '操作日期';
comment on column ${iol_schema}.svss_svs_log_accadmlog.operate_time is '操作时间';
comment on column ${iol_schema}.svss_svs_log_accadmlog.operate_org_no is '操作柜员的机构号';
comment on column ${iol_schema}.svss_svs_log_accadmlog.memo is '备注';
comment on column ${iol_schema}.svss_svs_log_accadmlog.acc_no is '备操作的账户的账号';
comment on column ${iol_schema}.svss_svs_log_accadmlog.acc_name is '户名';
comment on column ${iol_schema}.svss_svs_log_accadmlog.auth_people_code is '授权人员';
comment on column ${iol_schema}.svss_svs_log_accadmlog.auth_people_name is '授权人员姓名';
comment on column ${iol_schema}.svss_svs_log_accadmlog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.svss_svs_log_accadmlog.etl_timestamp is 'ETL处理时间戳';
