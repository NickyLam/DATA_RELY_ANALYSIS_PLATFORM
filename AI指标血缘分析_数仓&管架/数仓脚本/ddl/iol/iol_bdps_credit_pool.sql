/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_credit_pool
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_credit_pool
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_credit_pool purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_credit_pool(
    id number(22) -- 
    ,cust_id number(22) -- 
    ,manager_id number(22) -- 
    ,depart_id number(22) -- 
    ,collztn_credit_no varchar2(45) -- 
    ,valid_flag varchar2(2) -- 
    ,branch_id_opt number(22) -- 
    ,credit_start_date varchar2(12) -- 
    ,credit_end_date varchar2(12) -- 
    ,max_impawn_amount number(18,2) -- 
    ,max_impawn_rate number(11,8) -- 
    ,is_use_group varchar2(2) -- 
    ,max_group_amount number(18,2) -- 
    ,use_group_type varchar2(2) -- 
    ,is_allow_collect varchar2(2) -- 
    ,is_auto_collect varchar2(2) -- 
    ,collect_to_group varchar2(2) -- 
    ,collect_plan varchar2(2) -- 
    ,keep_exposure number(18,2) -- 
    ,allow_subcom_use varchar2(2) -- 
    ,max_subcom_amount number(18,2) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,lock_flag varchar2(2) -- 
    ,lock_id number(22) -- 
    ,group_flag varchar2(2) -- 
    ,collect_time varchar2(2) -- 
    ,fixed_time varchar2(9) -- 
    ,is_allow_nocollztn varchar2(2) -- 
    ,is_allow_ele_nocollztn varchar2(2) -- 
    ,warn_amount number(18,2) -- 额度预警阀值
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
grant select on ${iol_schema}.bdps_credit_pool to ${iml_schema};
grant select on ${iol_schema}.bdps_credit_pool to ${icl_schema};
grant select on ${iol_schema}.bdps_credit_pool to ${idl_schema};
grant select on ${iol_schema}.bdps_credit_pool to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_credit_pool is '额度池表';
comment on column ${iol_schema}.bdps_credit_pool.id is '';
comment on column ${iol_schema}.bdps_credit_pool.cust_id is '';
comment on column ${iol_schema}.bdps_credit_pool.manager_id is '';
comment on column ${iol_schema}.bdps_credit_pool.depart_id is '';
comment on column ${iol_schema}.bdps_credit_pool.collztn_credit_no is '';
comment on column ${iol_schema}.bdps_credit_pool.valid_flag is '';
comment on column ${iol_schema}.bdps_credit_pool.branch_id_opt is '';
comment on column ${iol_schema}.bdps_credit_pool.credit_start_date is '';
comment on column ${iol_schema}.bdps_credit_pool.credit_end_date is '';
comment on column ${iol_schema}.bdps_credit_pool.max_impawn_amount is '';
comment on column ${iol_schema}.bdps_credit_pool.max_impawn_rate is '';
comment on column ${iol_schema}.bdps_credit_pool.is_use_group is '';
comment on column ${iol_schema}.bdps_credit_pool.max_group_amount is '';
comment on column ${iol_schema}.bdps_credit_pool.use_group_type is '';
comment on column ${iol_schema}.bdps_credit_pool.is_allow_collect is '';
comment on column ${iol_schema}.bdps_credit_pool.is_auto_collect is '';
comment on column ${iol_schema}.bdps_credit_pool.collect_to_group is '';
comment on column ${iol_schema}.bdps_credit_pool.collect_plan is '';
comment on column ${iol_schema}.bdps_credit_pool.keep_exposure is '';
comment on column ${iol_schema}.bdps_credit_pool.allow_subcom_use is '';
comment on column ${iol_schema}.bdps_credit_pool.max_subcom_amount is '';
comment on column ${iol_schema}.bdps_credit_pool.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_credit_pool.last_upd_time is '';
comment on column ${iol_schema}.bdps_credit_pool.lock_flag is '';
comment on column ${iol_schema}.bdps_credit_pool.lock_id is '';
comment on column ${iol_schema}.bdps_credit_pool.group_flag is '';
comment on column ${iol_schema}.bdps_credit_pool.collect_time is '';
comment on column ${iol_schema}.bdps_credit_pool.fixed_time is '';
comment on column ${iol_schema}.bdps_credit_pool.is_allow_nocollztn is '';
comment on column ${iol_schema}.bdps_credit_pool.is_allow_ele_nocollztn is '';
comment on column ${iol_schema}.bdps_credit_pool.warn_amount is '额度预警阀值';
comment on column ${iol_schema}.bdps_credit_pool.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_credit_pool.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_credit_pool.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_credit_pool.etl_timestamp is 'ETL处理时间戳';
