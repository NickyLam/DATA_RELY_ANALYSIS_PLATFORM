/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_case_cust_cur
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
drop table ${iol_schema}.amls_t2a_case_cust_cur_ex purge;
alter table ${iol_schema}.amls_t2a_case_cust_cur add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t2a_case_cust_cur;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t2a_case_cust_cur_ex nologging
compress
as
select * from ${iol_schema}.amls_t2a_case_cust_cur where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t2a_case_cust_cur_ex(
    ctrl_cert_invalid_dt -- 实际控制人证件失效日期
    ,rsrv_04 -- 备用字段4
    ,oth_hold_cert_type -- 其他控股股东证件类型
    ,reg_fund_amt -- 注册资本
    ,legal_name -- 法定代表人名称
    ,addr -- 地址
    ,reg_fund_curr_cd -- 注册资本币种
    ,othr_ctct2 -- 其他联系方式2
    ,bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,ctrl_cert_no -- 实际控制人证件号码
    ,hold_cert_type -- 控股股东证件类型（参见[字典:AML0051]）
    ,bh_valid -- 大额验证（参见[字典:AML0041]）
    ,due_dt -- 补录到期日期
    ,tel2 -- 联系电话2
    ,othr_ctct -- 其他联系方式
    ,hold_name -- 控股股东名称
    ,modifier -- 修改人
    ,ctrl_name -- 实际控制人名称
    ,cust_id -- 客户编号
    ,legal_cert_type -- 法定代表人证件类型（参见[字典:AML0051]）
    ,rsrv_01 -- 备用字段1
    ,rsrv_02 -- 备用字段2
    ,cust_name -- 客户名称
    ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,creator -- 创建人
    ,ctrl_cert_type -- 实际控制人证件类型
    ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
    ,hold_cert_no -- 控股股东证件号码
    ,org_id -- 归属机构编号
    ,pbc_ocp -- PBC职业分类
    ,cust_type -- 客户类型（参见[字典:AML0030]）
    ,bs_indus -- 可疑报告涉及行业分类（参见[字典:AML0044]）
    ,addr2 -- 地址2
    ,pbc_indus -- PBC行业分类
    ,oth_cert_type -- 其他证件类型
    ,oth_ctrl_cert_type -- 其他实际控制人证件类型
    ,tel -- 联系电话
    ,oth_legal_cert_type -- 其他法人证件类型
    ,cert_type -- 证件类型（参见[字典:AML0050]）
    ,create_tm -- 创建时间
    ,modify_tm -- 修改时间
    ,oth_opr_cert_type -- 对手其他证件类型
    ,cert_no -- 证件号码
    ,cust_nat -- 国籍
    ,legal_cert_no -- 法定代表人证件号码
    ,rsrv_03 -- 备用字段3
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ctrl_cert_invalid_dt -- 实际控制人证件失效日期
    ,rsrv_04 -- 备用字段4
    ,oth_hold_cert_type -- 其他控股股东证件类型
    ,reg_fund_amt -- 注册资本
    ,legal_name -- 法定代表人名称
    ,addr -- 地址
    ,reg_fund_curr_cd -- 注册资本币种
    ,othr_ctct2 -- 其他联系方式2
    ,bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,ctrl_cert_no -- 实际控制人证件号码
    ,hold_cert_type -- 控股股东证件类型（参见[字典:AML0051]）
    ,bh_valid -- 大额验证（参见[字典:AML0041]）
    ,due_dt -- 补录到期日期
    ,tel2 -- 联系电话2
    ,othr_ctct -- 其他联系方式
    ,hold_name -- 控股股东名称
    ,modifier -- 修改人
    ,ctrl_name -- 实际控制人名称
    ,cust_id -- 客户编号
    ,legal_cert_type -- 法定代表人证件类型（参见[字典:AML0051]）
    ,rsrv_01 -- 备用字段1
    ,rsrv_02 -- 备用字段2
    ,cust_name -- 客户名称
    ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,creator -- 创建人
    ,ctrl_cert_type -- 实际控制人证件类型
    ,ctrl_cert_valid_dt -- 实际控制人证件生效日期
    ,hold_cert_no -- 控股股东证件号码
    ,org_id -- 归属机构编号
    ,pbc_ocp -- PBC职业分类
    ,cust_type -- 客户类型（参见[字典:AML0030]）
    ,bs_indus -- 可疑报告涉及行业分类（参见[字典:AML0044]）
    ,addr2 -- 地址2
    ,pbc_indus -- PBC行业分类
    ,oth_cert_type -- 其他证件类型
    ,oth_ctrl_cert_type -- 其他实际控制人证件类型
    ,tel -- 联系电话
    ,oth_legal_cert_type -- 其他法人证件类型
    ,cert_type -- 证件类型（参见[字典:AML0050]）
    ,create_tm -- 创建时间
    ,modify_tm -- 修改时间
    ,oth_opr_cert_type -- 对手其他证件类型
    ,cert_no -- 证件号码
    ,cust_nat -- 国籍
    ,legal_cert_no -- 法定代表人证件号码
    ,rsrv_03 -- 备用字段3
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t2a_case_cust_cur
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t2a_case_cust_cur exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_case_cust_cur_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_case_cust_cur to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t2a_case_cust_cur_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_case_cust_cur',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);