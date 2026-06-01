/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_int_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_int_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_int_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_int_type(
    company varchar2(20) -- 法人
    ,int_tax_flag varchar2(3) -- 利率类型税率类型标志
    ,int_tax_type varchar2(5) -- 利率税率类型
    ,int_tax_type_desc varchar2(50) -- 利率税率类型描述
    ,prod_grp varchar2(3) -- 产品组
    ,rate_ladder varchar2(1) -- 利息计算模型
    ,tax_ladder varchar2(1) -- 税率计算模型
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
grant select on ${iol_schema}.ncbs_mb_int_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_int_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_int_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_int_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_int_type is '利率税率类型表';
comment on column ${iol_schema}.ncbs_mb_int_type.company is '法人';
comment on column ${iol_schema}.ncbs_mb_int_type.int_tax_flag is '利率类型税率类型标志';
comment on column ${iol_schema}.ncbs_mb_int_type.int_tax_type is '利率税率类型';
comment on column ${iol_schema}.ncbs_mb_int_type.int_tax_type_desc is '利率税率类型描述';
comment on column ${iol_schema}.ncbs_mb_int_type.prod_grp is '产品组';
comment on column ${iol_schema}.ncbs_mb_int_type.rate_ladder is '利息计算模型';
comment on column ${iol_schema}.ncbs_mb_int_type.tax_ladder is '税率计算模型';
comment on column ${iol_schema}.ncbs_mb_int_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_int_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_int_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_int_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_int_type.etl_timestamp is 'ETL处理时间戳';
