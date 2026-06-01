/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t3b_case
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
drop table ${iol_schema}.amls_t3b_case_ex purge;
alter table ${iol_schema}.amls_t3b_case add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t3b_case;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t3b_case_ex nologging
compress
as
select * from ${iol_schema}.amls_t3b_case where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t3b_case_ex(
    case_id -- 案例编号
    ,stat_dt -- 数据日期
    ,org_id -- 甄别机构
    ,case_dt -- 案例日期
    ,case_kind -- 案例种类：AML0061
    ,cust_id -- 主客户编号
    ,cust_name -- 主客户名称
    ,cust_type -- 主客户类型
    ,flow_id -- 流程ID ：AML0111
    ,post_id -- 当前岗位：AML0110
    ,node_id -- 当前节点：AML0112
    ,case_sts -- 案例状态：AML0022
    ,is_del -- 是否排除
    ,is_sys_del -- 是否系统排除
    ,create_mode -- 创建方式：AML0024
    ,invalid_dt -- 正常案例失效日期
    ,is_local_curr -- 本外币标志
    ,susp_lvl -- 报送方向：AML0026
    ,take_action -- 采取措施：AML1020
    ,crime_type -- 涉罪类型：t1f_susp_actn_code
    ,trig_point -- 可疑交易报告触发点：AML0028
    ,is_valid -- 是否通过验证：AML0042
    ,due_dt -- 处理期限
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,fin_act_desc -- 资金交易及客户行为情况
    ,other_desc -- 疑点分析
    ,is_follow -- 是否跟踪
    ,eme_lvl -- 报告紧急程度：AML0140
    ,is_free_trade -- 是否自贸区案例  0否   1是
    ,rpt_num -- 报送次数标志
    ,is_continue -- 是否接续案例(0为否，1为是)
    ,init_case -- 首次案例号
    ,init_report -- 首次报告号
    ,p_case_id -- 父案例编号
    ,score -- 总分值
    ,level_name -- 可疑度
    ,score_des -- 甄别理由
    ,mirs -- 补正标识
    ,init_msg -- 首次报文
    ,fill_man -- 填报人
    ,busi_prod -- 业务产品-报表使用
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    case_id -- 案例编号
    ,stat_dt -- 数据日期
    ,org_id -- 甄别机构
    ,case_dt -- 案例日期
    ,case_kind -- 案例种类：AML0061
    ,cust_id -- 主客户编号
    ,cust_name -- 主客户名称
    ,cust_type -- 主客户类型
    ,flow_id -- 流程ID ：AML0111
    ,post_id -- 当前岗位：AML0110
    ,node_id -- 当前节点：AML0112
    ,case_sts -- 案例状态：AML0022
    ,is_del -- 是否排除
    ,is_sys_del -- 是否系统排除
    ,create_mode -- 创建方式：AML0024
    ,invalid_dt -- 正常案例失效日期
    ,is_local_curr -- 本外币标志
    ,susp_lvl -- 报送方向：AML0026
    ,take_action -- 采取措施：AML1020
    ,crime_type -- 涉罪类型：t1f_susp_actn_code
    ,trig_point -- 可疑交易报告触发点：AML0028
    ,is_valid -- 是否通过验证：AML0042
    ,due_dt -- 处理期限
    ,create_tm -- 创建时间
    ,creator -- 创建人
    ,modify_tm -- 修改时间
    ,modifier -- 修改人
    ,fin_act_desc -- 资金交易及客户行为情况
    ,other_desc -- 疑点分析
    ,is_follow -- 是否跟踪
    ,eme_lvl -- 报告紧急程度：AML0140
    ,is_free_trade -- 是否自贸区案例  0否   1是
    ,rpt_num -- 报送次数标志
    ,is_continue -- 是否接续案例(0为否，1为是)
    ,init_case -- 首次案例号
    ,init_report -- 首次报告号
    ,p_case_id -- 父案例编号
    ,score -- 总分值
    ,level_name -- 可疑度
    ,score_des -- 甄别理由
    ,mirs -- 补正标识
    ,init_msg -- 首次报文
    ,fill_man -- 填报人
    ,busi_prod -- 业务产品-报表使用
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t3b_case
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t3b_case exchange partition p_${batch_date} with table ${iol_schema}.amls_t3b_case_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t3b_case to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t3b_case_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t3b_case',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);