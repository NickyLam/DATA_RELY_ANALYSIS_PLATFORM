/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_cust_limit_o
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_cust_limit_o
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_cust_limit_o purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_cust_limit_o(
    org varchar2(18) -- 机构号
    ,cust_limit_id number(20,0) -- 客户额度id
    ,limit_category varchar2(30) -- 额度种类
    ,limit_type varchar2(2) -- 额度类型
    ,credit_limit number(13,0) -- 信用额度
    ,jpa_version number(22) -- 乐观锁版本号
    ,last_modified_datetime date -- 修改时间
    ,created_datetime date -- 创建时间
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0ntm_cust_limit_o to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_cust_limit_o to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_cust_limit_o to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_cust_limit_o to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_cust_limit_o is '自定义额度信息表-授权';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.cust_limit_id is '客户额度id';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.limit_category is '额度种类';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.limit_type is '额度类型';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.credit_limit is '信用额度';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.created_datetime is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_cust_limit_o.etl_timestamp is 'ETL处理时间戳';
