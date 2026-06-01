/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tailbox_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tailbox_plan
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tailbox_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tailbox_plan(
    branch varchar2(12) -- 机构编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,allot_id varchar2(50) -- 尾箱分配计划编号
    ,company varchar2(20) -- 法人
    ,plan_status varchar2(1) -- 计划状态
    ,end_date date -- 结束日期
    ,plan_date date -- 计划日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,allot_user_id varchar2(8) -- 尾箱分配计划创建柜员
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
grant select on ${iol_schema}.ncbs_tb_tailbox_plan to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tailbox_plan is '尾箱日分配计划表';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.allot_id is '尾箱分配计划编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.company is '法人';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.plan_status is '计划状态';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.plan_date is '计划日期';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.allot_user_id is '尾箱分配计划创建柜员';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_tailbox_plan.etl_timestamp is 'ETL处理时间戳';
