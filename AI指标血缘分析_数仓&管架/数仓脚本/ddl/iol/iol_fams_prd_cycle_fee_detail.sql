/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_prd_cycle_fee_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_prd_cycle_fee_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_prd_cycle_fee_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_prd_cycle_fee_detail(
    period_id varchar2(60) -- 期次代码
    ,finprod_id varchar2(60) -- 期次金融产品代码
    ,branch number(10) -- 分支序号
    ,fee_type varchar2(10) -- 费用类型
    ,trade_id varchar2(50) -- 交易编号
    ,p_finprod_id varchar2(50) -- 母金融产品代码
    ,status varchar2(10) -- 有效状态
    ,theory_amt number(30,2) -- 理论金额
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_prd_cycle_fee_detail to ${iml_schema};
grant select on ${iol_schema}.fams_prd_cycle_fee_detail to ${icl_schema};
grant select on ${iol_schema}.fams_prd_cycle_fee_detail to ${idl_schema};
grant select on ${iol_schema}.fams_prd_cycle_fee_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_prd_cycle_fee_detail is '周期性产品费用明细表';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.period_id is '期次代码';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.finprod_id is '期次金融产品代码';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.branch is '分支序号';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.fee_type is '费用类型';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.trade_id is '交易编号';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.p_finprod_id is '母金融产品代码';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.status is '有效状态';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.theory_amt is '理论金额';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.create_user is '创建人';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.create_dept is '创建部门';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.create_time is '创建时间';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.update_user is '更新人';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.update_time is '更新时间';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.start_dt is '开始时间';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.end_dt is '结束时间';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.id_mark is '增删标志';
comment on column ${iol_schema}.fams_prd_cycle_fee_detail.etl_timestamp is 'ETL处理时间戳';
