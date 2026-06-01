/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_points_pool_input
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_points_pool_input
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_points_pool_input purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_points_pool_input(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(32) -- 借据号
    ,var0001 varchar2(8) -- 账龄
    ,var0308 number(11,7) -- 过去3个月还款率平均值
    ,a_grade varchar2(6) -- 申请评分
    ,bc_grade varchar2(6) -- 行为评分
    ,overdue_flag varchar2(1) -- 历史是否曾经逾期过
    ,var0202 number(18,2) -- 过去3个月还款金额的平均值
    ,var0430 number(22) -- 过去6个月内最长连续未逾期月数
    ,var0407 number(22) -- 过去12个月是否曾经发生逾期
    ,valid_gender_cd varchar2(1) -- 性别
    ,default_flag varchar2(1) -- 是否违约
    ,var0309 number(11,7) -- 过去6个月实际还款率的平均值
    ,var0305 number(11,7) -- 过去3个月实际还款率最大值
    ,var0002 number(11,7) -- 当前贷款余额占贷款金额的百分比
    ,age number(22) -- 年龄
    ,ghb_emp_flg varchar2(1) -- 是否本行员工
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_dt varchar2(10) -- 数据日期
    ,pool_type varchar2(5) -- 分池模型
    ,mode_type varchar2(5) -- 评分模型类型
    ,loan_total_bal number(17,2) -- 贷款余额
    ,pdsum number(17,2) -- 风险暴露金额
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_assis_flag varchar2(1) -- 是否助贷
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_points_pool_input to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_points_pool_input to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_points_pool_input to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_points_pool_input to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_points_pool_input is '零售分池入参加工信息';
comment on column ${iol_schema}.rcds_ir_points_pool_input.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_points_pool_input.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0001 is '账龄';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0308 is '过去3个月还款率平均值';
comment on column ${iol_schema}.rcds_ir_points_pool_input.a_grade is '申请评分';
comment on column ${iol_schema}.rcds_ir_points_pool_input.bc_grade is '行为评分';
comment on column ${iol_schema}.rcds_ir_points_pool_input.overdue_flag is '历史是否曾经逾期过';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0202 is '过去3个月还款金额的平均值';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0430 is '过去6个月内最长连续未逾期月数';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0407 is '过去12个月是否曾经发生逾期';
comment on column ${iol_schema}.rcds_ir_points_pool_input.valid_gender_cd is '性别';
comment on column ${iol_schema}.rcds_ir_points_pool_input.default_flag is '是否违约';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0309 is '过去6个月实际还款率的平均值';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0305 is '过去3个月实际还款率最大值';
comment on column ${iol_schema}.rcds_ir_points_pool_input.var0002 is '当前贷款余额占贷款金额的百分比';
comment on column ${iol_schema}.rcds_ir_points_pool_input.age is '年龄';
comment on column ${iol_schema}.rcds_ir_points_pool_input.ghb_emp_flg is '是否本行员工';
comment on column ${iol_schema}.rcds_ir_points_pool_input.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_points_pool_input.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_points_pool_input.pool_type is '分池模型';
comment on column ${iol_schema}.rcds_ir_points_pool_input.mode_type is '评分模型类型';
comment on column ${iol_schema}.rcds_ir_points_pool_input.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rcds_ir_points_pool_input.pdsum is '风险暴露金额';
comment on column ${iol_schema}.rcds_ir_points_pool_input.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_points_pool_input.loan_assis_flag is '是否助贷';
comment on column ${iol_schema}.rcds_ir_points_pool_input.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_points_pool_input.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_points_pool_input.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_points_pool_input.etl_timestamp is 'ETL处理时间戳';
