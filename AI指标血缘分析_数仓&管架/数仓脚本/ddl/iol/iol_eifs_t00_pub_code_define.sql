/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t00_pub_code_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t00_pub_code_define
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t00_pub_code_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t00_pub_code_define(
    code_no varchar2(15) -- 代码编号
    ,code_name varchar2(120) -- 中文名称
    ,code_value varchar2(45) -- 代码值
    ,code_desc varchar2(750) -- 中文说明
    ,valid_flag varchar2(2) -- 有效标志
    ,code_id varchar2(60) -- 代码ID
    ,code_sort number(8) -- 代码排序
    ,parent_id varchar2(60) -- 父代码ID
    ,sub_code varchar2(15) -- 子类码值
    ,description varchar2(300) -- 描述
    ,init_user_id varchar2(60) -- 创建人用户ID
    ,init_user_postn_id varchar2(60) -- 创建人用户岗位ID
    ,update_user_id varchar2(60) -- 更新人用户ID
    ,update_user_postn_id varchar2(60) -- 更新人用户岗位ID
    ,created_ts timestamp -- 进入ECIF的时间
    ,last_updated_ts timestamp -- 最新更新时间
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
grant select on ${iol_schema}.eifs_t00_pub_code_define to ${iml_schema};
grant select on ${iol_schema}.eifs_t00_pub_code_define to ${icl_schema};
grant select on ${iol_schema}.eifs_t00_pub_code_define to ${idl_schema};
grant select on ${iol_schema}.eifs_t00_pub_code_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t00_pub_code_define is '';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_no is '代码编号';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_name is '中文名称';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_value is '代码值';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_desc is '中文说明';
comment on column ${iol_schema}.eifs_t00_pub_code_define.valid_flag is '有效标志';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_id is '代码ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.code_sort is '代码排序';
comment on column ${iol_schema}.eifs_t00_pub_code_define.parent_id is '父代码ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.sub_code is '子类码值';
comment on column ${iol_schema}.eifs_t00_pub_code_define.description is '描述';
comment on column ${iol_schema}.eifs_t00_pub_code_define.init_user_id is '创建人用户ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.init_user_postn_id is '创建人用户岗位ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.update_user_id is '更新人用户ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.update_user_postn_id is '更新人用户岗位ID';
comment on column ${iol_schema}.eifs_t00_pub_code_define.created_ts is '进入ECIF的时间';
comment on column ${iol_schema}.eifs_t00_pub_code_define.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t00_pub_code_define.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.eifs_t00_pub_code_define.etl_timestamp is 'ETL处理时间戳';
