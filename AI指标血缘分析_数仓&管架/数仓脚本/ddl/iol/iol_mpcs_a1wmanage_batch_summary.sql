/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1wmanage_batch_summary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1wmanage_batch_summary
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wmanage_batch_summary(
    branch_no varchar2(192) -- 机构编号不带_
    ,branch_id varchar2(768) -- 机构id带_的多级结构
    ,company_count number(38) -- 入驻公司总数
    ,employee_count number(38) -- 员工总数
    ,total_amount number(32,2) -- 发放工资总金额
    ,batch_count number(38) -- 发放工资总次数
    ,create_timestamp varchar2(144) -- 创建时间戳
    ,update_timestamp varchar2(144) -- 更新时间戳
    ,redis_update_time varchar2(114) -- redis更新同步的时间
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
grant select on ${iol_schema}.mpcs_a1wmanage_batch_summary to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1wmanage_batch_summary to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1wmanage_batch_summary to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1wmanage_batch_summary to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1wmanage_batch_summary is '批量汇总表';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.branch_no is '机构编号不带_';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.branch_id is '机构id带_的多级结构';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.company_count is '入驻公司总数';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.employee_count is '员工总数';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.total_amount is '发放工资总金额';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.batch_count is '发放工资总次数';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.redis_update_time is 'redis更新同步的时间';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1wmanage_batch_summary.etl_timestamp is 'ETL处理时间戳';
