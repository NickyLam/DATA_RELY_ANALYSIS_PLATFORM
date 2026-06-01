/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_t_match_info
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
drop table ${iol_schema}.alss_am_t_match_info_ex purge;
alter table ${iol_schema}.alss_am_t_match_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alss_am_t_match_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_t_match_info_ex nologging
compress
as
select * from ${iol_schema}.alss_am_t_match_info where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_t_match_info_ex(
    cust_no -- 客户号
    ,own_organ -- 开户上级机构
    ,organ_code -- 开户机构
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_type -- 账户性质
    ,licence_regist_num -- 营业执照(注册号)编号
    ,licence_social_num -- 营业执照（统一社会信用代码）编号
    ,other_credtype -- 是否为其他证件种类
    ,core_people -- 核心与人行账户管理系统比对
    ,core_business -- 核心与商事信息
    ,people_business -- 人行账户管理系统与商事信息
    ,suspend_info -- 久悬账户情况
    ,manage_state -- 经营状态
    ,abnormal_con -- 是否被列入企业异常名录
    ,illegal_breach -- 是否为严重违法失信企业
    ,last_inspect -- 最后年检年度
    ,check_dt -- 核查日期
    ,inspect_dt -- 年检日期
    ,etl_dt_ora -- 创建日期
    ,org_num -- 所属机构
    ,establish_dt -- 企业开立日期
    ,handle_flag -- 账户处示标示 1-是(已处置)
    ,core_proof -- 核心与验印系统比对
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_no -- 客户号
    ,own_organ -- 开户上级机构
    ,organ_code -- 开户机构
    ,acct_num -- 账号
    ,acct_name -- 账户名称
    ,acct_type -- 账户性质
    ,licence_regist_num -- 营业执照(注册号)编号
    ,licence_social_num -- 营业执照（统一社会信用代码）编号
    ,other_credtype -- 是否为其他证件种类
    ,core_people -- 核心与人行账户管理系统比对
    ,core_business -- 核心与商事信息
    ,people_business -- 人行账户管理系统与商事信息
    ,suspend_info -- 久悬账户情况
    ,manage_state -- 经营状态
    ,abnormal_con -- 是否被列入企业异常名录
    ,illegal_breach -- 是否为严重违法失信企业
    ,last_inspect -- 最后年检年度
    ,check_dt -- 核查日期
    ,inspect_dt -- 年检日期
    ,etl_dt_ora -- 创建日期
    ,org_num -- 所属机构
    ,establish_dt -- 企业开立日期
    ,handle_flag -- 账户处示标示 1-是(已处置)
    ,core_proof -- 核心与验印系统比对
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_t_match_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_t_match_info exchange partition p_${batch_date} with table ${iol_schema}.alss_am_t_match_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_t_match_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_t_match_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_t_match_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);