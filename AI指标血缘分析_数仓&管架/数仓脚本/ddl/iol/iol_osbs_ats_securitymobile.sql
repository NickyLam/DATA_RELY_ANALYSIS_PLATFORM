/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ats_securitymobile
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ats_securitymobile
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ats_securitymobile purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_securitymobile(
    asm_cstno varchar2(32) -- 统一客户号
    ,asm_userno varchar2(32) -- 用户顺序号
    ,asm_mobile varchar2(32) -- 安全手机号
    ,asm_create_date varchar2(14) -- 创建日期
    ,asm_update_date varchar2(14) -- 最后修改日期
    ,asm_state varchar2(1) -- 状态
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
grant select on ${iol_schema}.osbs_ats_securitymobile to ${iml_schema};
grant select on ${iol_schema}.osbs_ats_securitymobile to ${icl_schema};
grant select on ${iol_schema}.osbs_ats_securitymobile to ${idl_schema};

-- comment
comment on table ${iol_schema}.osbs_ats_securitymobile is '安全手机号表';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_cstno is '统一客户号';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_mobile is '安全手机号';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_create_date is '创建日期';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_update_date is '最后修改日期';
comment on column ${iol_schema}.osbs_ats_securitymobile.asm_state is '状态';
comment on column ${iol_schema}.osbs_ats_securitymobile.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.osbs_ats_securitymobile.etl_timestamp is 'ETL处理时间戳';
