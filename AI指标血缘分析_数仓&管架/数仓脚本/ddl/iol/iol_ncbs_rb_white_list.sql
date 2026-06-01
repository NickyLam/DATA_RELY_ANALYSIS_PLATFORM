/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_white_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_white_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_white_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_white_list(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,effect_flag varchar2(1) -- 是否生效标志
    ,source_type varchar2(6) -- 渠道编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_acct_no varchar2(50) -- 实际账号
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
grant select on ${iol_schema}.ncbs_rb_white_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_white_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_white_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_white_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_white_list is '白名单';
comment on column ${iol_schema}.ncbs_rb_white_list.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_white_list.company is '法人';
comment on column ${iol_schema}.ncbs_rb_white_list.effect_flag is '是否生效标志';
comment on column ${iol_schema}.ncbs_rb_white_list.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_white_list.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_white_list.actual_acct_no is '实际账号';
comment on column ${iol_schema}.ncbs_rb_white_list.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_white_list.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_white_list.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_white_list.etl_timestamp is 'ETL处理时间戳';
