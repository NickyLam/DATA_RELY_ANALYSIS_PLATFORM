/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_city
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_city
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_city purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_city(
    country varchar2(3) -- 国家
    ,city varchar2(6) -- 行政区划(城市)
    ,city_desc varchar2(50) -- 城市描述
    ,city_tel varchar2(5) -- 电话区号
    ,company varchar2(20) -- 法人
    ,postal_code varchar2(10) -- 邮政编码
    ,state varchar2(6) -- 行政区划(省、州)
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,attached_to varchar2(12) -- 所属上级
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
grant select on ${iol_schema}.ncbs_fm_city to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_city to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_city to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_city to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_city is '城市代码表';
comment on column ${iol_schema}.ncbs_fm_city.country is '国家';
comment on column ${iol_schema}.ncbs_fm_city.city is '行政区划(城市)';
comment on column ${iol_schema}.ncbs_fm_city.city_desc is '城市描述';
comment on column ${iol_schema}.ncbs_fm_city.city_tel is '电话区号';
comment on column ${iol_schema}.ncbs_fm_city.company is '法人';
comment on column ${iol_schema}.ncbs_fm_city.postal_code is '邮政编码';
comment on column ${iol_schema}.ncbs_fm_city.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_city.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_city.attached_to is '所属上级';
comment on column ${iol_schema}.ncbs_fm_city.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_city.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_city.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_city.etl_timestamp is 'ETL处理时间戳';
