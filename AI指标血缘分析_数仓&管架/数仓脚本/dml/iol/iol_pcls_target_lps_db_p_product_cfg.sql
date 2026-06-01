/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pcls_target_lps_db_p_product_cfg
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
drop table ${iol_schema}.pcls_target_lps_db_p_product_cfg_ex purge;
alter table ${iol_schema}.pcls_target_lps_db_p_product_cfg add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pcls_target_lps_db_p_product_cfg;

-- 2.3 insert data to ex table
create table ${iol_schema}.pcls_target_lps_db_p_product_cfg_ex nologging
compress
as
select * from ${iol_schema}.pcls_target_lps_db_p_product_cfg where 0=1;

insert /*+ append */ into ${iol_schema}.pcls_target_lps_db_p_product_cfg_ex(
    id -- 主键
    ,product_code -- 产品编号
    ,product_type -- XF-消费贷，JY-经营贷
    ,guarantee_type -- 担保方式，1.信用 -CREDIT，2.保证担保 - GUARANTEE，3.抵押担保 -PLEDGE，4.组合担保-COMBINATION
    ,raise_switch -- 是否允许提额，Y/N
    ,product_state -- 状态，上架-ON，下架-OFF，草稿-DRAFT，模板-TEMP， 删除-DELETED
    ,product_name -- 产品名称
    ,male_min_age -- 男性最小年龄
    ,male_max_age -- 男性最大年龄
    ,female_min_age -- 女性最小年龄
    ,female_max_age -- 女性最大年龄
    ,min_credit_amount -- 营销侧最小授信金额（万）
    ,max_credit_amount -- 营销侧最大授信金额（万）
    ,min_interest_rate -- 营销侧最小年利率（无%）
    ,max_interest_rate -- 营销侧最大年利率（无%）
    ,age_rule -- 年龄取值规则
    ,area_type -- 展业区域类型
    ,locate_mode -- 定位方式
    ,date_effective -- 生效时间
    ,date_expire -- 失效时间
    ,main_flag -- 主推产品
    ,hide_flag -- 是否隐藏
    ,date_created -- 创建时间
    ,created_by -- 创建人
    ,date_updated -- 修改时间
    ,updated_by -- 修改人
    ,extend_data -- 
    ,locate_check_rule -- 
    ,appl_cancel_switch -- 是否支持客户主动取消申请
    ,system_survey_switch -- 是否支持 系统触发尽调
    ,cust_identity_config -- 客户身份配置
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键
    ,product_code -- 产品编号
    ,product_type -- XF-消费贷，JY-经营贷
    ,guarantee_type -- 担保方式，1.信用 -CREDIT，2.保证担保 - GUARANTEE，3.抵押担保 -PLEDGE，4.组合担保-COMBINATION
    ,raise_switch -- 是否允许提额，Y/N
    ,product_state -- 状态，上架-ON，下架-OFF，草稿-DRAFT，模板-TEMP， 删除-DELETED
    ,product_name -- 产品名称
    ,male_min_age -- 男性最小年龄
    ,male_max_age -- 男性最大年龄
    ,female_min_age -- 女性最小年龄
    ,female_max_age -- 女性最大年龄
    ,min_credit_amount -- 营销侧最小授信金额（万）
    ,max_credit_amount -- 营销侧最大授信金额（万）
    ,min_interest_rate -- 营销侧最小年利率（无%）
    ,max_interest_rate -- 营销侧最大年利率（无%）
    ,age_rule -- 年龄取值规则
    ,area_type -- 展业区域类型
    ,locate_mode -- 定位方式
    ,date_effective -- 生效时间
    ,date_expire -- 失效时间
    ,main_flag -- 主推产品
    ,hide_flag -- 是否隐藏
    ,date_created -- 创建时间
    ,created_by -- 创建人
    ,date_updated -- 修改时间
    ,updated_by -- 修改人
    ,extend_data -- 
    ,locate_check_rule -- 
    ,appl_cancel_switch -- 是否支持客户主动取消申请
    ,system_survey_switch -- 是否支持 系统触发尽调
    ,cust_identity_config -- 客户身份配置
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pcls_target_lps_db_p_product_cfg
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pcls_target_lps_db_p_product_cfg exchange partition p_${batch_date} with table ${iol_schema}.pcls_target_lps_db_p_product_cfg_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pcls_target_lps_db_p_product_cfg to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pcls_target_lps_db_p_product_cfg_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pcls_target_lps_db_p_product_cfg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);