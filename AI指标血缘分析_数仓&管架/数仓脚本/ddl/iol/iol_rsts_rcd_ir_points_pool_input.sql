/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_points_pool_input
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_points_pool_input
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_points_pool_input purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_points_pool_input(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(32) -- 借据号
    ,var0001 varchar2(8) -- 账龄
    ,var0308 number(18,4) -- 过去3个月还款率平均值
    ,a_grade varchar2(6) -- 申请评分
    ,bc_grade varchar2(6) -- 行为评分
    ,overdue_flag varchar2(1) -- 历史是否曾经逾期过
    ,var0202 number(18,4) -- 过去3个月还款金额的平均值
    ,var0430 number -- 过去6个月内最长连续未逾期月数
    ,var0407 number -- 过去12个月是否曾经发生逾期
    ,valid_gender_cd varchar2(1) -- 性别
    ,default_flag varchar2(1) -- 是否违约
    ,var0309 number(18,4) -- 过去6个月实际还款率的平均值
    ,var0305 number(18,4) -- 过去3个月实际还款率最大值
    ,var0002 number(18,4) -- 当前贷款余额占贷款金额的百分比
    ,age number -- 年龄
    ,ghb_emp_flg varchar2(1) -- 是否本行员工
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_dt varchar2(20) -- 数据日期
    ,pool_type varchar2(150) -- 分池模型
    ,mode_type varchar2(150) -- 评分模型类型
    ,loan_total_bal number(17,2) -- 贷款余额
    ,pdsum number(17,2) -- 风险暴露金额
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_assis_flag varchar2(1) -- 是否助贷
    ,distr_dt varchar2(12) -- 放款日期
    ,bond_item_status_cd varchar2(10) -- 借据状态
    ,level5_class_cd varchar2(40) -- 五级分类
    ,ovdue_days varchar2(10) -- 本金或利息逾期天数
    ,guar_way_cd varchar2(10) -- 主担保方式
    ,birth_dt varchar2(12) -- 出生日期
    ,edu_degree_cd varchar2(10) -- 教育程度
    ,corp_char_cd varchar2(10) -- 单位性质
    ,resdnt_situ_cd varchar2(10) -- 现住房状况
    ,marriage_status_cd varchar2(10) -- 婚姻状态
    ,indv_mon_in number(17,2) -- 认定月收入
    ,loan_biz_type varchar2(60) -- 贷款业务品种
    ,valid_flg varchar2(10) -- 贷款产品状态
    ,loan_biz_type_flag varchar2(2) -- 例外池状态
    ,loan_biz_type_name varchar2(80) -- 贷款业务品种名称
    ,serial_no varchar2(100) -- 业务流水号
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
grant select on ${iol_schema}.rsts_rcd_ir_points_pool_input to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_points_pool_input to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_points_pool_input to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_points_pool_input to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_points_pool_input is '分池入参表';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0001 is '账龄';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0308 is '过去3个月还款率平均值';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.a_grade is '申请评分';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.bc_grade is '行为评分';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.overdue_flag is '历史是否曾经逾期过';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0202 is '过去3个月还款金额的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0430 is '过去6个月内最长连续未逾期月数';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0407 is '过去12个月是否曾经发生逾期';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.valid_gender_cd is '性别';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.default_flag is '是否违约';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0309 is '过去6个月实际还款率的平均值';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0305 is '过去3个月实际还款率最大值';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.var0002 is '当前贷款余额占贷款金额的百分比';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.age is '年龄';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.ghb_emp_flg is '是否本行员工';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.pool_type is '分池模型';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.mode_type is '评分模型类型';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.pdsum is '风险暴露金额';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_assis_flag is '是否助贷';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.distr_dt is '放款日期';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.bond_item_status_cd is '借据状态';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.level5_class_cd is '五级分类';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.ovdue_days is '本金或利息逾期天数';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.guar_way_cd is '主担保方式';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.birth_dt is '出生日期';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.edu_degree_cd is '教育程度';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.corp_char_cd is '单位性质';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.resdnt_situ_cd is '现住房状况';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.marriage_status_cd is '婚姻状态';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.indv_mon_in is '认定月收入';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_biz_type is '贷款业务品种';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.valid_flg is '贷款产品状态';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_biz_type_flag is '例外池状态';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.loan_biz_type_name is '贷款业务品种名称';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.serial_no is '业务流水号';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_points_pool_input.etl_timestamp is 'ETL处理时间戳';
