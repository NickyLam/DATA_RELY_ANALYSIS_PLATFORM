/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_points_pool_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_points_pool_result
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_points_pool_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_points_pool_result(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(32) -- 借据号
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_dt varchar2(20) -- 数据日期
    ,pd varchar2(20) -- 违约率PD
    ,pd_ci_1 varchar2(20) -- -95%CI(PD)
    ,pd_ci_2 varchar2(20) -- +95%CI(PD)
    ,lgd varchar2(20) -- 违约损失率LGD
    ,lgd_ci_1 varchar2(20) -- 95%CI-(LGD)
    ,lgd_ci_2 varchar2(20) -- 95%CI+(LGD)
    ,pool_type varchar2(5) -- 分池模型类型
    ,mode_type varchar2(5) -- 评分模型类型
    ,pd_logical_deteil varchar2(100) -- PD逻辑描述
    ,lgd_logical_deteil varchar2(100) -- LGD逻辑描述
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
grant select on ${iol_schema}.rcds_ir_points_pool_result to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_points_pool_result to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_points_pool_result to ${idl_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_points_pool_result is '零售分池结果表';
comment on column ${iol_schema}.rcds_ir_points_pool_result.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_points_pool_result.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_points_pool_result.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_points_pool_result.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_points_pool_result.pd is '违约率PD';
comment on column ${iol_schema}.rcds_ir_points_pool_result.pd_ci_1 is '-95%CI(PD)';
comment on column ${iol_schema}.rcds_ir_points_pool_result.pd_ci_2 is '+95%CI(PD)';
comment on column ${iol_schema}.rcds_ir_points_pool_result.lgd is '违约损失率LGD';
comment on column ${iol_schema}.rcds_ir_points_pool_result.lgd_ci_1 is '95%CI-(LGD)';
comment on column ${iol_schema}.rcds_ir_points_pool_result.lgd_ci_2 is '95%CI+(LGD)';
comment on column ${iol_schema}.rcds_ir_points_pool_result.pool_type is '分池模型类型';
comment on column ${iol_schema}.rcds_ir_points_pool_result.mode_type is '评分模型类型';
comment on column ${iol_schema}.rcds_ir_points_pool_result.pd_logical_deteil is 'PD逻辑描述';
comment on column ${iol_schema}.rcds_ir_points_pool_result.lgd_logical_deteil is 'LGD逻辑描述';
comment on column ${iol_schema}.rcds_ir_points_pool_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rcds_ir_points_pool_result.etl_timestamp is 'ETL处理时间戳';
