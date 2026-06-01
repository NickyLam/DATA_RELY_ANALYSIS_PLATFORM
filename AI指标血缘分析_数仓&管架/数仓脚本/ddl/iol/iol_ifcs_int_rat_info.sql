/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_int_rat_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_int_rat_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_int_rat_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_int_rat_info(
    int_rat_type varchar2(12) -- 利率类别
    ,dep_term_cd varchar2(15) -- 期限代码
    ,curr_cd varchar2(15) -- 货币符号
    ,effect_dt varchar2(12) -- 生效日期
    ,invalid_dt varchar2(12) -- 失效日期
    ,int_rat_status varchar2(2) -- 状态
    ,base_rat number(11,7) -- 基准利率
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
grant select on ${iol_schema}.ifcs_int_rat_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_int_rat_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_int_rat_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_int_rat_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_int_rat_info is '利率表';
comment on column ${iol_schema}.ifcs_int_rat_info.int_rat_type is '利率类别';
comment on column ${iol_schema}.ifcs_int_rat_info.dep_term_cd is '期限代码';
comment on column ${iol_schema}.ifcs_int_rat_info.curr_cd is '货币符号';
comment on column ${iol_schema}.ifcs_int_rat_info.effect_dt is '生效日期';
comment on column ${iol_schema}.ifcs_int_rat_info.invalid_dt is '失效日期';
comment on column ${iol_schema}.ifcs_int_rat_info.int_rat_status is '状态';
comment on column ${iol_schema}.ifcs_int_rat_info.base_rat is '基准利率';
comment on column ${iol_schema}.ifcs_int_rat_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_int_rat_info.etl_timestamp is 'ETL处理时间戳';
