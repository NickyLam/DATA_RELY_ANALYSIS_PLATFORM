/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_rating_reversal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_rating_reversal
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_rating_reversal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_rating_reversal(
    uuid varchar2(64) -- 指标加工明细ID
    ,serial_no varchar2(128) -- 评级流水号
    ,cust_no varchar2(64) -- 客户编号
    ,cust_name varchar2(256) -- 客户名称
    ,machine_rating varchar2(12) -- 机评等级
    ,rating_model varchar2(256) -- 评级模型
    ,reversal_time date -- 推翻时间
    ,is_final_rating number(4,0) -- 是否最终认定评级
    ,reversal_reason varchar2(4000) -- 评级推翻原因
    ,reversal_rating varchar2(12) -- 推翻后评级等级
    ,reversal_cust_no varchar2(64) -- 推翻人用户ID
    ,reversal_cust_name varchar2(256) -- 推翻人名称
    ,reversal_cust_post varchar2(64) -- 推翻人岗位
    ,reversal_cust_dept varchar2(64) -- 推翻人部门
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
grant select on ${iol_schema}.rsts_cpr_rating_reversal to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_rating_reversal to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_reversal to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_reversal to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_rating_reversal is '评级推翻表';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.uuid is '指标加工明细ID';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.cust_no is '客户编号';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.cust_name is '客户名称';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.machine_rating is '机评等级';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.rating_model is '评级模型';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_time is '推翻时间';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.is_final_rating is '是否最终认定评级';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_reason is '评级推翻原因';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_rating is '推翻后评级等级';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_cust_no is '推翻人用户ID';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_cust_name is '推翻人名称';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_cust_post is '推翻人岗位';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.reversal_cust_dept is '推翻人部门';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.start_dt is '开始时间';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.end_dt is '结束时间';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.id_mark is '增删标志';
comment on column ${iol_schema}.rsts_cpr_rating_reversal.etl_timestamp is 'ETL处理时间戳';
