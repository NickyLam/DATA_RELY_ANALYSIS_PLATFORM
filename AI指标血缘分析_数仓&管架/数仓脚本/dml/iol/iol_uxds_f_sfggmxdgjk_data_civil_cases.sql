/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_sfggmxdgjk_data_civil_cases
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
drop table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases_ex purge;
alter table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,n_laay_tree -- 立案案由详细
    ,n_jaay -- 结案案由
    ,n_ssdw -- 诉讼地位
    ,n_jabdje_gj -- 结案标的金额估计
    ,n_jaay_tree -- 结案案由详细
    ,n_jabdje_gj_level -- 结案标的金额估计等级
    ,c_gkws_glah -- 相关案件号
    ,n_pj_victory -- 胜诉估计
    ,n_ssdw_ys -- 一审诉讼地位
    ,c_gkws_dsr -- 当事人
    ,n_qsbdje_gj_level -- 起诉标的金额估计等级
    ,n_jafs -- 结案方式
    ,n_jbfy_cj -- 法院所属层级
    ,n_qsbdje -- 起诉标的金额
    ,n_slcx -- 案件进展阶段
    ,n_ajjzjd -- 所属地域
    ,n_qsbdje_gj -- 起诉标的金额估计
    ,n_jbfy -- 经办法院
    ,c_gkws_id -- 公开文书ID
    ,c_ah_hx -- 后续案号
    ,d_jarq -- 结案时间
    ,n_jabdje_level -- 结案标的金额等级
    ,c_slfsxx -- 审理方式信息
    ,cases -- 关联标签
    ,c_ah -- 案号
    ,n_qsbdje_level -- 起诉标的金额等级
    ,c_gkws_pjjg -- 判决结果
    ,c_ssdy -- 审理程序
    ,n_laay_tag -- 立案案由标签
    ,n_jabdje -- 结案标的金额
    ,n_jaay_tag -- 结案案由标签
    ,n_ajbs -- 案件标识
    ,c_ah_ys -- 原审案号
    ,n_ajlx -- 案件类型
    ,n_laay -- 立案案由
    ,d_larq -- 立案时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,n_laay_tree -- 立案案由详细
    ,n_jaay -- 结案案由
    ,n_ssdw -- 诉讼地位
    ,n_jabdje_gj -- 结案标的金额估计
    ,n_jaay_tree -- 结案案由详细
    ,n_jabdje_gj_level -- 结案标的金额估计等级
    ,c_gkws_glah -- 相关案件号
    ,n_pj_victory -- 胜诉估计
    ,n_ssdw_ys -- 一审诉讼地位
    ,c_gkws_dsr -- 当事人
    ,n_qsbdje_gj_level -- 起诉标的金额估计等级
    ,n_jafs -- 结案方式
    ,n_jbfy_cj -- 法院所属层级
    ,n_qsbdje -- 起诉标的金额
    ,n_slcx -- 案件进展阶段
    ,n_ajjzjd -- 所属地域
    ,n_qsbdje_gj -- 起诉标的金额估计
    ,n_jbfy -- 经办法院
    ,c_gkws_id -- 公开文书ID
    ,c_ah_hx -- 后续案号
    ,d_jarq -- 结案时间
    ,n_jabdje_level -- 结案标的金额等级
    ,c_slfsxx -- 审理方式信息
    ,cases -- 关联标签
    ,c_ah -- 案号
    ,n_qsbdje_level -- 起诉标的金额等级
    ,c_gkws_pjjg -- 判决结果
    ,c_ssdy -- 审理程序
    ,n_laay_tag -- 立案案由标签
    ,n_jabdje -- 结案标的金额
    ,n_jaay_tag -- 结案案由标签
    ,n_ajbs -- 案件标识
    ,c_ah_ys -- 原审案号
    ,n_ajlx -- 案件类型
    ,n_laay -- 立案案由
    ,d_larq -- 立案时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_sfggmxdgjk_data_civil_cases
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil_cases_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_sfggmxdgjk_data_civil_cases',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);