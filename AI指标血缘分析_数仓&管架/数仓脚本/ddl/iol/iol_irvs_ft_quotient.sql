/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ft_quotient
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ft_quotient
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ft_quotient purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ft_quotient(
    ecif_no varchar2(50) -- 委托人Id
    ,product_id varchar2(50) -- 产品id
    ,networth_id varchar2(50) -- 产品净值id
    ,quotient number(20,2) -- 份额
    ,created_by varchar2(100) -- 创建者
    ,updated_by varchar2(100) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.irvs_ft_quotient to ${iml_schema};
grant select on ${iol_schema}.irvs_ft_quotient to ${icl_schema};
grant select on ${iol_schema}.irvs_ft_quotient to ${idl_schema};
grant select on ${iol_schema}.irvs_ft_quotient to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ft_quotient is '份额表';
comment on column ${iol_schema}.irvs_ft_quotient.ecif_no is '委托人Id';
comment on column ${iol_schema}.irvs_ft_quotient.product_id is '产品id';
comment on column ${iol_schema}.irvs_ft_quotient.networth_id is '产品净值id';
comment on column ${iol_schema}.irvs_ft_quotient.quotient is '份额';
comment on column ${iol_schema}.irvs_ft_quotient.created_by is '创建者';
comment on column ${iol_schema}.irvs_ft_quotient.updated_by is '修改者';
comment on column ${iol_schema}.irvs_ft_quotient.create_time is '创建时间';
comment on column ${iol_schema}.irvs_ft_quotient.update_time is '修改时间';
comment on column ${iol_schema}.irvs_ft_quotient.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.irvs_ft_quotient.etl_timestamp is 'ETL处理时间戳';
