/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_cus_indiv_apply
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
drop table ${iol_schema}.heps_cus_indiv_apply_ex purge;
alter table ${iol_schema}.heps_cus_indiv_apply add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_cus_indiv_apply truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_cus_indiv_apply_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_cus_indiv_apply where 0=1;

insert /*+ append */ into ${iol_schema}.heps_cus_indiv_apply_ex(
    flow_no -- 业务流水号
    ,cus_id -- 客户代码
    ,cus_name -- 客户姓名
    ,indiv_sex -- 性别
    ,cert_type -- 证件类型
    ,cert_code -- 证件号码
    ,indiv_brt_place -- 籍贯
    ,indiv_heal_st -- 健康状况
    ,indiv_mar_st -- 婚姻状况
    ,indiv_rsd_addr -- 居住地址
    ,indiv_rsd_st -- 居住状况
    ,indiv_rsd_year -- 居住年限
    ,phone -- 联系电话
    ,indiv_com_name -- 工作单位
    ,indiv_com_addr -- 单位地址
    ,main_brid -- 主管机构
    ,cust_mgr -- 客户经理编号
    ,indiv_sps_name -- 配偶姓名
    ,indiv_sps_id_typ -- 配偶证件类型
    ,indiv_sps_id_code -- 配偶证件号码
    ,loan_amount -- 申请额度
    ,loan_term -- 申请期数
    ,cert_st_time -- 证件起始日
    ,cert_ed_time -- 证件到期日
    ,create_time -- 创建时间
    ,update_time -- 更新时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    flow_no -- 业务流水号
    ,cus_id -- 客户代码
    ,cus_name -- 客户姓名
    ,indiv_sex -- 性别
    ,cert_type -- 证件类型
    ,cert_code -- 证件号码
    ,indiv_brt_place -- 籍贯
    ,indiv_heal_st -- 健康状况
    ,indiv_mar_st -- 婚姻状况
    ,indiv_rsd_addr -- 居住地址
    ,indiv_rsd_st -- 居住状况
    ,indiv_rsd_year -- 居住年限
    ,phone -- 联系电话
    ,indiv_com_name -- 工作单位
    ,indiv_com_addr -- 单位地址
    ,main_brid -- 主管机构
    ,cust_mgr -- 客户经理编号
    ,indiv_sps_name -- 配偶姓名
    ,indiv_sps_id_typ -- 配偶证件类型
    ,indiv_sps_id_code -- 配偶证件号码
    ,loan_amount -- 申请额度
    ,loan_term -- 申请期数
    ,cert_st_time -- 证件起始日
    ,cert_ed_time -- 证件到期日
    ,create_time -- 创建时间
    ,update_time -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_cus_indiv_apply
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_cus_indiv_apply exchange partition p_${batch_date} with table ${iol_schema}.heps_cus_indiv_apply_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_cus_indiv_apply to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_cus_indiv_apply_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_cus_indiv_apply',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);