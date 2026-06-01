/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_dist_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_dist_code
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_dist_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_dist_code(
    city varchar2(6) -- 行政区划(城市)
    ,company varchar2(20) -- 法人
    ,dist_code varchar2(6) -- 发证机关地区代码
    ,dist_grade varchar2(10) -- 地区代码级别
    ,province varchar2(30) -- 省
    ,state varchar2(6) -- 行政区划(省、州)
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dist_name varchar2(200) -- 地区名称
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
grant select on ${iol_schema}.ncbs_fm_dist_code to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_dist_code to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_dist_code to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_dist_code to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_dist_code is '地区代码';
comment on column ${iol_schema}.ncbs_fm_dist_code.city is '行政区划(城市)';
comment on column ${iol_schema}.ncbs_fm_dist_code.company is '法人';
comment on column ${iol_schema}.ncbs_fm_dist_code.dist_code is '发证机关地区代码';
comment on column ${iol_schema}.ncbs_fm_dist_code.dist_grade is '地区代码级别';
comment on column ${iol_schema}.ncbs_fm_dist_code.province is '省';
comment on column ${iol_schema}.ncbs_fm_dist_code.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_dist_code.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_dist_code.dist_name is '地区名称';
comment on column ${iol_schema}.ncbs_fm_dist_code.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_dist_code.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_dist_code.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_dist_code.etl_timestamp is 'ETL处理时间戳';
