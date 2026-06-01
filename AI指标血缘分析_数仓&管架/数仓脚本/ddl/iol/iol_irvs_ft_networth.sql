/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ft_networth
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ft_networth
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ft_networth purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ft_networth(
    networth_id varchar2(50) -- 净值id
    ,product_id varchar2(50) -- 产品id
    ,networth_time varchar2(24) -- 净值日期
    ,networth_cumulative number(20,8) -- 累计净值
    ,networth_unit number(20,8) -- 单位净值
    ,quotient number(20,2) -- 份额
    ,networth_cost number(20,2) -- 成本
    ,networth_marketvalue number(20,2) -- 市值
    ,created_by varchar2(100) -- 创建者
    ,updated_by varchar2(100) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.irvs_ft_networth to ${iml_schema};
grant select on ${iol_schema}.irvs_ft_networth to ${icl_schema};
grant select on ${iol_schema}.irvs_ft_networth to ${idl_schema};
grant select on ${iol_schema}.irvs_ft_networth to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ft_networth is '产品净值表';
comment on column ${iol_schema}.irvs_ft_networth.networth_id is '净值id';
comment on column ${iol_schema}.irvs_ft_networth.product_id is '产品id';
comment on column ${iol_schema}.irvs_ft_networth.networth_time is '净值日期';
comment on column ${iol_schema}.irvs_ft_networth.networth_cumulative is '累计净值';
comment on column ${iol_schema}.irvs_ft_networth.networth_unit is '单位净值';
comment on column ${iol_schema}.irvs_ft_networth.quotient is '份额';
comment on column ${iol_schema}.irvs_ft_networth.networth_cost is '成本';
comment on column ${iol_schema}.irvs_ft_networth.networth_marketvalue is '市值';
comment on column ${iol_schema}.irvs_ft_networth.created_by is '创建者';
comment on column ${iol_schema}.irvs_ft_networth.updated_by is '修改者';
comment on column ${iol_schema}.irvs_ft_networth.create_time is '创建时间';
comment on column ${iol_schema}.irvs_ft_networth.update_time is '修改时间';
comment on column ${iol_schema}.irvs_ft_networth.start_dt is '开始时间';
comment on column ${iol_schema}.irvs_ft_networth.end_dt is '结束时间';
comment on column ${iol_schema}.irvs_ft_networth.id_mark is '增删标志';
comment on column ${iol_schema}.irvs_ft_networth.etl_timestamp is 'ETL处理时间戳';
