/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_s_task
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
drop table ${iol_schema}.heps_s_task_ex purge;
alter table ${iol_schema}.heps_s_task add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_s_task truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_s_task_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_s_task where 0=1;

insert /*+ append */ into ${iol_schema}.heps_s_task_ex(
    task_id -- 任务id
    ,customer_id -- 客户id
    ,flow_id -- 业务流水号
    ,actor_no -- 负责人编号
    ,title -- 任务标题
    ,official_valuation -- 房屋估值
    ,plot_name -- 楼盘名称
    ,house_location -- 定位
    ,customer_name -- 客户姓名
    ,customer_mobile -- 客户电话
    ,application_time -- 申请时间
    ,task_status -- 任务状态：00初审中，01待分配，02待下户核验/待补充资料，03待面谈面签，04终审中，05审核通过，06审核拒绝，07退回，08初审不通过，09状态未名 10终止
    ,loan_type -- 贷款类型 0华兴快贷 1赎楼贷
    ,cus_card_no -- 客户证件号
    ,house_area -- 房屋面积
    ,house_level -- 楼层
    ,high_loan_limit -- 最高可贷额度
    ,task_source -- 1客户手机进件 2客户经理发起
    ,orgid -- 机构号
    ,remark -- 备注
    ,purpors -- 贷款用途 01经营 02消费
    ,actor_name -- 客户经理名称
    ,trial_time -- 初审时间
    ,id_type -- 证件类型
    ,pro_name -- 产品名称
    ,devision_id -- 行政区域编码
    ,plot_number -- 楼盘编号
    ,approval_limit -- 授信额度
    ,city_area_code -- 城市编码
    ,city_name -- 城市名称
    ,area_name -- 区域名称
    ,is_tag -- 
    ,ser_no -- 赎楼贷业务流水号
    ,zj_actor_no -- 质检员编号
    ,first_flow_id -- 初审流水号
    ,pro_id -- 产品编号
    ,actor_orgid -- 客户经理账务机构号
    ,customer_no -- 客户号
    ,source_company -- 地推渠道来源
    ,xh_actor_no -- 下户核验员编号
    ,xh_actor_name -- 下户核验员姓名
    ,developers -- 经纬度
    ,flowable_tag -- 
    ,flowable_instance_id -- 
    ,is_offline_sign -- 是否提提放保线下签字；1-是2-否
    ,update_time -- 最近更新时间
    ,entr_pay_id -- 受托支付编号
    ,pay_seq -- 支付序列
    ,pro_flow_no -- 产品流程编号
    ,amount_type -- 申请金额类型
    ,house_type -- 房产类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    task_id -- 任务id
    ,customer_id -- 客户id
    ,flow_id -- 业务流水号
    ,actor_no -- 负责人编号
    ,title -- 任务标题
    ,official_valuation -- 房屋估值
    ,plot_name -- 楼盘名称
    ,house_location -- 定位
    ,customer_name -- 客户姓名
    ,customer_mobile -- 客户电话
    ,application_time -- 申请时间
    ,task_status -- 任务状态：00初审中，01待分配，02待下户核验/待补充资料，03待面谈面签，04终审中，05审核通过，06审核拒绝，07退回，08初审不通过，09状态未名 10终止
    ,loan_type -- 贷款类型 0华兴快贷 1赎楼贷
    ,cus_card_no -- 客户证件号
    ,house_area -- 房屋面积
    ,house_level -- 楼层
    ,high_loan_limit -- 最高可贷额度
    ,task_source -- 1客户手机进件 2客户经理发起
    ,orgid -- 机构号
    ,remark -- 备注
    ,purpors -- 贷款用途 01经营 02消费
    ,actor_name -- 客户经理名称
    ,trial_time -- 初审时间
    ,id_type -- 证件类型
    ,pro_name -- 产品名称
    ,devision_id -- 行政区域编码
    ,plot_number -- 楼盘编号
    ,approval_limit -- 授信额度
    ,city_area_code -- 城市编码
    ,city_name -- 城市名称
    ,area_name -- 区域名称
    ,is_tag -- 
    ,ser_no -- 赎楼贷业务流水号
    ,zj_actor_no -- 质检员编号
    ,first_flow_id -- 初审流水号
    ,pro_id -- 产品编号
    ,actor_orgid -- 客户经理账务机构号
    ,customer_no -- 客户号
    ,source_company -- 地推渠道来源
    ,xh_actor_no -- 下户核验员编号
    ,xh_actor_name -- 下户核验员姓名
    ,developers -- 经纬度
    ,flowable_tag -- 
    ,flowable_instance_id -- 
    ,is_offline_sign -- 是否提提放保线下签字；1-是2-否
    ,update_time -- 最近更新时间
    ,entr_pay_id -- 受托支付编号
    ,pay_seq -- 支付序列
    ,pro_flow_no -- 产品流程编号
    ,amount_type -- 申请金额类型
    ,house_type -- 房产类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_s_task
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_s_task exchange partition p_${batch_date} with table ${iol_schema}.heps_s_task_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_s_task to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_s_task_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_s_task',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);