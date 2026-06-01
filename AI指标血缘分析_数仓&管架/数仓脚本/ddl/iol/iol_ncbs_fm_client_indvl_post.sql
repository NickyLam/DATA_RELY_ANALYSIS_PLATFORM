/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_client_indvl_post
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_client_indvl_post
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_client_indvl_post purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_client_indvl_post(
    company varchar2(20) -- 法人
    ,field_value varchar2(10) -- 取值范围
    ,meaning varchar2(200) -- 说明
    ,ref_lang varchar2(20) -- 参数语言
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,narrative1 varchar2(600) -- 备注
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
grant select on ${iol_schema}.ncbs_fm_client_indvl_post to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_client_indvl_post to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_client_indvl_post to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_client_indvl_post to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_client_indvl_post is '职位表';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.company is '法人';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.field_value is '取值范围';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.meaning is '说明';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.ref_lang is '参数语言';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.narrative1 is '备注';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_client_indvl_post.etl_timestamp is 'ETL处理时间戳';
