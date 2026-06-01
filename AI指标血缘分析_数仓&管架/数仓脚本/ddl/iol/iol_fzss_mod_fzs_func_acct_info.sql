/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_func_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_func_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_func_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_func_acct_info(
    corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,func_acct_no varchar2(40) -- 账户号
    ,func_acct_name varchar2(256) -- 账户名
    ,acct_type varchar2(2) -- 账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]
    ,acct_status varchar2(2) -- 账户状态 [枚举: 0-正常,1-销户,]
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
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
grant select on ${iol_schema}.fzss_mod_fzs_func_acct_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_func_acct_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_func_acct_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_func_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_func_acct_info is '平台功能账户信息表';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.func_acct_no is '账户号';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.func_acct_name is '账户名';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.acct_type is '账户性质 [枚举: 01-红包,02-垫资,03-挂账,04-待清算,05-实时清算垫资功能户,09-其他]';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.acct_status is '账户状态 [枚举: 0-正常,1-销户,]';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_func_acct_info.etl_timestamp is 'ETL处理时间戳';
