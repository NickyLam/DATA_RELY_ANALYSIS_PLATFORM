/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_tzbl_jbxx
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
drop table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_tzbl_jbxx where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_tzbl_jbxx_ex(
    key_id -- 主键
    ,data_dt -- 数据日期
    ,loan_no -- 借据号
    ,cust_id -- 客户证件号码
    ,cust_name -- 客户名称
    ,pty_typ_cd -- 客户类型代码
    ,pty_blng_indu_cd -- 客户所属行业代码
    ,pty_loc_cd -- 客户所在地代码
    ,non_resident_flg -- 非居民标志
    ,farmer_flg -- 农户标志
    ,indv_indu_com_acct_flg -- 个体工商户标志
    ,pty_status_cd -- 客户状态代码
    ,age -- 年龄
    ,valid_gender_cd -- 性别
    ,native_place_cd -- 籍贯代码
    ,nation_cd -- 国籍代码
    ,poli_face_cd -- 政治面貌代码
    ,marriage_status_cd -- 婚姻状况代码
    ,highest_edu_degree_cd -- 最高学历代码
    ,reside_status_cd -- 居住状况代码
    ,join_work_year -- 参加工作年限
    ,join_enterprise_year -- 加入现单位年限
    ,corp_blng_indu_cd -- 单位所属行业代码
    ,corp_prop_cd -- 单位性质代码
    ,profsn_title_cd -- 职称代码
    ,ghb_emp_flg -- 本行员工标志
    ,ghb_shrholder_flg -- 本行股东标志
    ,raise_cnt -- 供养人数
    ,family_anl_inc -- 家庭年收入
    ,family_mon_income -- 家庭月收入
    ,indv_mon_income -- 个人月收入
    ,indv_year_income -- 个人年收入
    ,blkl_pty_flg -- 黑名单客户标志
    ,crdt_pty_flg -- 授信客户标志
    ,small_eown_flg -- 小微企业主标志
    ,pty_level_cd -- 客户级别代码
    ,insd_and_otsd_flg -- 境内外标志
    ,work_stus -- 雇佣状态
    ,house_value -- 房产价值
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,cust_no -- 客户编码
    ,serial_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,data_dt -- 数据日期
    ,loan_no -- 借据号
    ,cust_id -- 客户证件号码
    ,cust_name -- 客户名称
    ,pty_typ_cd -- 客户类型代码
    ,pty_blng_indu_cd -- 客户所属行业代码
    ,pty_loc_cd -- 客户所在地代码
    ,non_resident_flg -- 非居民标志
    ,farmer_flg -- 农户标志
    ,indv_indu_com_acct_flg -- 个体工商户标志
    ,pty_status_cd -- 客户状态代码
    ,age -- 年龄
    ,valid_gender_cd -- 性别
    ,native_place_cd -- 籍贯代码
    ,nation_cd -- 国籍代码
    ,poli_face_cd -- 政治面貌代码
    ,marriage_status_cd -- 婚姻状况代码
    ,highest_edu_degree_cd -- 最高学历代码
    ,reside_status_cd -- 居住状况代码
    ,join_work_year -- 参加工作年限
    ,join_enterprise_year -- 加入现单位年限
    ,corp_blng_indu_cd -- 单位所属行业代码
    ,corp_prop_cd -- 单位性质代码
    ,profsn_title_cd -- 职称代码
    ,ghb_emp_flg -- 本行员工标志
    ,ghb_shrholder_flg -- 本行股东标志
    ,raise_cnt -- 供养人数
    ,family_anl_inc -- 家庭年收入
    ,family_mon_income -- 家庭月收入
    ,indv_mon_income -- 个人月收入
    ,indv_year_income -- 个人年收入
    ,blkl_pty_flg -- 黑名单客户标志
    ,crdt_pty_flg -- 授信客户标志
    ,small_eown_flg -- 小微企业主标志
    ,pty_level_cd -- 客户级别代码
    ,insd_and_otsd_flg -- 境内外标志
    ,work_stus -- 雇佣状态
    ,house_value -- 房产价值
    ,exc_id -- 执行清单表ID
    ,generated_time -- 生成时间
    ,partition_month -- 分区月份
    ,cust_no -- 客户编码
    ,serial_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_tzbl_jbxx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_tzbl_jbxx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_tzbl_jbxx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_tzbl_jbxx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);