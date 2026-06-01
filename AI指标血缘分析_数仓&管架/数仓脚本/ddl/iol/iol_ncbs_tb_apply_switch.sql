/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_apply_switch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_apply_switch
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_apply_switch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_apply_switch(
    branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,apply_type varchar2(1) -- 预约申请类型
    ,company varchar2(20) -- 法人
    ,cv_flag varchar2(1) -- 现金/凭证标志
    ,tb_switch_state varchar2(1) -- 开关状态
    ,end_date date -- 结束日期
    ,last_update_date date -- 上次更新日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_user_id varchar2(8) -- 上一柜员id
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
grant select on ${iol_schema}.ncbs_tb_apply_switch to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_apply_switch to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_apply_switch to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_apply_switch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_apply_switch is '预约申请开关表';
comment on column ${iol_schema}.ncbs_tb_apply_switch.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_apply_switch.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_apply_switch.apply_type is '预约申请类型';
comment on column ${iol_schema}.ncbs_tb_apply_switch.company is '法人';
comment on column ${iol_schema}.ncbs_tb_apply_switch.cv_flag is '现金/凭证标志';
comment on column ${iol_schema}.ncbs_tb_apply_switch.tb_switch_state is '开关状态';
comment on column ${iol_schema}.ncbs_tb_apply_switch.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_tb_apply_switch.last_update_date is '上次更新日期';
comment on column ${iol_schema}.ncbs_tb_apply_switch.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_tb_apply_switch.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_apply_switch.last_user_id is '上一柜员id';
comment on column ${iol_schema}.ncbs_tb_apply_switch.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_apply_switch.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_apply_switch.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_apply_switch.etl_timestamp is 'ETL处理时间戳';
