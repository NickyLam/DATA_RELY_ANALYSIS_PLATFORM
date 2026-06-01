/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tm_cust_limit_o
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tm_cust_limit_o
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tm_cust_limit_o purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tm_cust_limit_o(
    org varchar2(12) -- 机构号
    ,custlimitid number(20) -- 客户额度id
    ,limitcategory varchar2(40) -- 额度种类
    ,limittype varchar2(1) -- 额度类型
    ,creditlimit number(13) -- 信用额度
    ,jpaversion number(38,0) -- 乐观锁版本号
    ,lastmodifieddatetime date -- 修改时间
    ,createddatetime date -- 创建时间
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
grant select on ${iol_schema}.icms_tm_cust_limit_o to ${iml_schema};
grant select on ${iol_schema}.icms_tm_cust_limit_o to ${icl_schema};
grant select on ${iol_schema}.icms_tm_cust_limit_o to ${idl_schema};
grant select on ${iol_schema}.icms_tm_cust_limit_o to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tm_cust_limit_o is '微粒贷自定义额度信息表-授权';
comment on column ${iol_schema}.icms_tm_cust_limit_o.org is '机构号';
comment on column ${iol_schema}.icms_tm_cust_limit_o.custlimitid is '客户额度id';
comment on column ${iol_schema}.icms_tm_cust_limit_o.limitcategory is '额度种类';
comment on column ${iol_schema}.icms_tm_cust_limit_o.limittype is '额度类型';
comment on column ${iol_schema}.icms_tm_cust_limit_o.creditlimit is '信用额度';
comment on column ${iol_schema}.icms_tm_cust_limit_o.jpaversion is '乐观锁版本号';
comment on column ${iol_schema}.icms_tm_cust_limit_o.lastmodifieddatetime is '修改时间';
comment on column ${iol_schema}.icms_tm_cust_limit_o.createddatetime is '创建时间';
comment on column ${iol_schema}.icms_tm_cust_limit_o.start_dt is '开始时间';
comment on column ${iol_schema}.icms_tm_cust_limit_o.end_dt is '结束时间';
comment on column ${iol_schema}.icms_tm_cust_limit_o.id_mark is '增删标志';
comment on column ${iol_schema}.icms_tm_cust_limit_o.etl_timestamp is 'ETL处理时间戳';
