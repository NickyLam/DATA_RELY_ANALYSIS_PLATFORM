/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_rating_update
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_rating_update
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_rating_update purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_rating_update(
    uuid varchar2(64) -- 指标加工明细ID
    ,serial_no varchar2(128) -- 评级流水号
    ,rating_type varchar2(32) -- 评级类型
    ,cust_no varchar2(64) -- 客户编号
    ,cust_name varchar2(256) -- 客户名称
    ,final_rating varchar2(12) -- 最终等级
    ,reporting_period varchar2(32) -- 使用财报期次
    ,reporting_type varchar2(32) -- 使用财报类型
    ,rating_effective_time varchar2(32) -- 评级生效时间
    ,rating_failure_time varchar2(32) -- 评级失效时间
    ,is_effective number(4,0) -- 是否有效
    ,last_serial_no varchar2(128) -- 上一次评级流水号
    ,inputs varchar2(4000) -- 评级记录入参
    ,outputs varchar2(4000) -- 评级记录出参
    ,is_success number(4,0) -- 是否成功(默认0，1成功，-1失败)
    ,create_time date -- 创建时间
    ,spend_time varchar2(12) -- 耗时
    ,describe varchar2(4000) -- 描述
    ,national_industry varchar2(32) -- 国标行业
    ,organization varchar2(256) -- 所属机构
    ,scene_flag number(4,0) -- 场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除
    ,reason varchar2(4000) -- 原因
    ,migration_time date -- 迁移时间
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
grant select on ${iol_schema}.rsts_cpr_rating_update to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_rating_update to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_update to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_update to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_rating_update is '评级更新主表';
comment on column ${iol_schema}.rsts_cpr_rating_update.uuid is '指标加工明细ID';
comment on column ${iol_schema}.rsts_cpr_rating_update.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_rating_update.rating_type is '评级类型';
comment on column ${iol_schema}.rsts_cpr_rating_update.cust_no is '客户编号';
comment on column ${iol_schema}.rsts_cpr_rating_update.cust_name is '客户名称';
comment on column ${iol_schema}.rsts_cpr_rating_update.final_rating is '最终等级';
comment on column ${iol_schema}.rsts_cpr_rating_update.reporting_period is '使用财报期次';
comment on column ${iol_schema}.rsts_cpr_rating_update.reporting_type is '使用财报类型';
comment on column ${iol_schema}.rsts_cpr_rating_update.rating_effective_time is '评级生效时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.rating_failure_time is '评级失效时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.is_effective is '是否有效';
comment on column ${iol_schema}.rsts_cpr_rating_update.last_serial_no is '上一次评级流水号';
comment on column ${iol_schema}.rsts_cpr_rating_update.inputs is '评级记录入参';
comment on column ${iol_schema}.rsts_cpr_rating_update.outputs is '评级记录出参';
comment on column ${iol_schema}.rsts_cpr_rating_update.is_success is '是否成功(默认0，1成功，-1失败)';
comment on column ${iol_schema}.rsts_cpr_rating_update.create_time is '创建时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.spend_time is '耗时';
comment on column ${iol_schema}.rsts_cpr_rating_update.describe is '描述';
comment on column ${iol_schema}.rsts_cpr_rating_update.national_industry is '国标行业';
comment on column ${iol_schema}.rsts_cpr_rating_update.organization is '所属机构';
comment on column ${iol_schema}.rsts_cpr_rating_update.scene_flag is '场景标识 0自动违约(写死)，1违约认定(人工二期)，2评级延期，3自动到期，4自动赋值（BBB等），5财报修改,6财报删除';
comment on column ${iol_schema}.rsts_cpr_rating_update.reason is '原因';
comment on column ${iol_schema}.rsts_cpr_rating_update.migration_time is '迁移时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.start_dt is '开始时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.end_dt is '结束时间';
comment on column ${iol_schema}.rsts_cpr_rating_update.id_mark is '增删标志';
comment on column ${iol_schema}.rsts_cpr_rating_update.etl_timestamp is 'ETL处理时间戳';
