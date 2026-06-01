/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_bonus_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_bonus_plan
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_bonus_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan(
    pk_bonus_plan number(22,0) -- 主键
    ,cust_id varchar2(90) -- 客户号
    ,bonus_plan_type varchar2(6) -- 积分类型
    ,total_bonus number(14,0) -- 总积分
    ,valid_bonus number(14,0) -- 可用积分
    ,apply_bonus number(14,0) -- 已用积分
    ,expire_bonus number(14,0) -- 过期积分
    ,freeze_bonus number(14,0) -- 冻结积分
    ,created_by varchar2(60) -- 创建人
    ,create_time varchar2(60) -- 创建时间
    ,updated_by varchar2(60) -- 更新人
    ,update_time varchar2(60) -- 更新时间
    ,del_flag number(22,0) -- 逻辑删除标志（0-正常，1-删除）
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
grant select on ${iol_schema}.pbms_tbl_bonus_plan to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_bonus_plan is '客户总账户表';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.pk_bonus_plan is '主键';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.bonus_plan_type is '积分类型';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.total_bonus is '总积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.valid_bonus is '可用积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.apply_bonus is '已用积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.expire_bonus is '过期积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.freeze_bonus is '冻结积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.created_by is '创建人';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.updated_by is '更新人';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.update_time is '更新时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.del_flag is '逻辑删除标志（0-正常，1-删除）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_bonus_plan.etl_timestamp is 'ETL处理时间戳';
