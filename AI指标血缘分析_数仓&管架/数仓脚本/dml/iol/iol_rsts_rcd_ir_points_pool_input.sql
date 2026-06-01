/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_points_pool_input
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_rcd_ir_points_pool_input_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_points_pool_input add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_points_pool_input truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_points_pool_input_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_points_pool_input where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_points_pool_input_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,var0001 -- 账龄
    ,var0308 -- 过去3个月还款率平均值
    ,a_grade -- 申请评分
    ,bc_grade -- 行为评分
    ,overdue_flag -- 历史是否曾经逾期过
    ,var0202 -- 过去3个月还款金额的平均值
    ,var0430 -- 过去6个月内最长连续未逾期月数
    ,var0407 -- 过去12个月是否曾经发生逾期
    ,valid_gender_cd -- 性别
    ,default_flag -- 是否违约
    ,var0309 -- 过去6个月实际还款率的平均值
    ,var0305 -- 过去3个月实际还款率最大值
    ,var0002 -- 当前贷款余额占贷款金额的百分比
    ,age -- 年龄
    ,ghb_emp_flg -- 是否本行员工
    ,grade_key_id -- 申请评分流水号
    ,data_dt -- 数据日期
    ,pool_type -- 分池模型
    ,mode_type -- 评分模型类型
    ,loan_total_bal -- 贷款余额
    ,pdsum -- 风险暴露金额
    ,loan_biz_type_cd -- 业务品种代码
    ,loan_assis_flag -- 是否助贷
    ,distr_dt -- 放款日期
    ,bond_item_status_cd -- 借据状态
    ,level5_class_cd -- 五级分类
    ,ovdue_days -- 本金或利息逾期天数
    ,guar_way_cd -- 主担保方式
    ,birth_dt -- 出生日期
    ,edu_degree_cd -- 教育程度
    ,corp_char_cd -- 单位性质
    ,resdnt_situ_cd -- 现住房状况
    ,marriage_status_cd -- 婚姻状态
    ,indv_mon_in -- 认定月收入
    ,loan_biz_type -- 贷款业务品种
    ,valid_flg -- 贷款产品状态
    ,loan_biz_type_flag -- 例外池状态
    ,loan_biz_type_name -- 贷款业务品种名称
    ,serial_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,loan_no -- 借据号
    ,var0001 -- 账龄
    ,var0308 -- 过去3个月还款率平均值
    ,a_grade -- 申请评分
    ,bc_grade -- 行为评分
    ,overdue_flag -- 历史是否曾经逾期过
    ,var0202 -- 过去3个月还款金额的平均值
    ,var0430 -- 过去6个月内最长连续未逾期月数
    ,var0407 -- 过去12个月是否曾经发生逾期
    ,valid_gender_cd -- 性别
    ,default_flag -- 是否违约
    ,var0309 -- 过去6个月实际还款率的平均值
    ,var0305 -- 过去3个月实际还款率最大值
    ,var0002 -- 当前贷款余额占贷款金额的百分比
    ,age -- 年龄
    ,ghb_emp_flg -- 是否本行员工
    ,grade_key_id -- 申请评分流水号
    ,data_dt -- 数据日期
    ,pool_type -- 分池模型
    ,mode_type -- 评分模型类型
    ,loan_total_bal -- 贷款余额
    ,pdsum -- 风险暴露金额
    ,loan_biz_type_cd -- 业务品种代码
    ,loan_assis_flag -- 是否助贷
    ,distr_dt -- 放款日期
    ,bond_item_status_cd -- 借据状态
    ,level5_class_cd -- 五级分类
    ,ovdue_days -- 本金或利息逾期天数
    ,guar_way_cd -- 主担保方式
    ,birth_dt -- 出生日期
    ,edu_degree_cd -- 教育程度
    ,corp_char_cd -- 单位性质
    ,resdnt_situ_cd -- 现住房状况
    ,marriage_status_cd -- 婚姻状态
    ,indv_mon_in -- 认定月收入
    ,loan_biz_type -- 贷款业务品种
    ,valid_flg -- 贷款产品状态
    ,loan_biz_type_flag -- 例外池状态
    ,loan_biz_type_name -- 贷款业务品种名称
    ,serial_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_points_pool_input
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_points_pool_input exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_points_pool_input_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_points_pool_input to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_points_pool_input_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_points_pool_input',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);