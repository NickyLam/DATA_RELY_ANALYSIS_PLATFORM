/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rc_list_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rc_list_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rc_list_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_list_type(
    list_type varchar2(10) -- 名单类型代码
    ,company varchar2(20) -- 法人
    ,list_type_desc varchar2(200) -- 名单类型描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rc_list_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rc_list_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rc_list_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rc_list_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rc_list_type is '黑名单类型表';
comment on column ${iol_schema}.ncbs_rc_list_type.list_type is '名单类型代码';
comment on column ${iol_schema}.ncbs_rc_list_type.company is '法人';
comment on column ${iol_schema}.ncbs_rc_list_type.list_type_desc is '名单类型描述';
comment on column ${iol_schema}.ncbs_rc_list_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rc_list_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rc_list_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rc_list_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rc_list_type.etl_timestamp is 'ETL处理时间戳';
