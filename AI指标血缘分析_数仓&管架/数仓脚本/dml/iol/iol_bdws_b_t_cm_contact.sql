/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_b_t_cm_contact
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
drop table ${iol_schema}.bdws_b_t_cm_contact_ex purge;
alter table ${iol_schema}.bdws_b_t_cm_contact add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_b_t_cm_contact truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_b_t_cm_contact_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_b_t_cm_contact where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_b_t_cm_contact_ex(
    contact_id -- ID
    ,cust_id -- 客户ID
    ,phone -- 手机号码
    ,contact_sts -- 是否有效
    ,contact_channel -- 联络渠道
    ,contact_type -- 联络类型
    ,contact_cont -- 服务内容
    ,contact_dt -- 联系日期
    ,cust_back -- 客户反馈
    ,int_prod -- 意向产品
    ,contact_name -- 联系人
    ,update_dt -- 待跟进日期
    ,send_tate -- 发送时间
    ,relation -- 客户关系类型
    ,nomal_behave -- 客户异常行为
    ,nom_cust_name -- 异常行为客户
    ,is_noble_metal -- 是否异常
    ,contact_address -- 地点
    ,notice_date -- 提醒时间
    ,flag -- 修改标志
    ,des -- 摘要
    ,task_id -- 任务ID
    ,update_cont -- 跟进内容
    ,create_user_id -- 创建人
    ,create_org_id -- 创建人机构
    ,remark -- 备注
    ,create_time -- 创建时间
    ,buy_amt -- 购买金额
    ,statr_time -- 开始时间
    ,end_time -- 结束时间
    ,update_time -- 更新维护时间
    ,cust_type -- 客户类型
    ,updater -- 维护人中文姓名
    ,updater_id -- 维护人ID
    ,wct_id -- 微信号
    ,concat_type -- 联系方式
    ,act_no -- 活动编号
    ,band_no -- 波段编号
    ,sign_in -- 签到记录 0:未签到 1：已签到
    ,lot_start_time -- 签到有效开始时间
    ,lot_end_time -- 签到有效结束时间
    ,lot_date -- 签到有效时间
    ,mkt_pro_type -- 营销产品类型
    ,yx_amt -- 意向金额
    ,is_gh -- 是否管户
    ,is_gg -- 是否共管
    ,leave_sts -- 审批状态
    ,yd_num -- 华兴云店联络次数
    ,load_date -- 数据日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    contact_id -- ID
    ,cust_id -- 客户ID
    ,phone -- 手机号码
    ,contact_sts -- 是否有效
    ,contact_channel -- 联络渠道
    ,contact_type -- 联络类型
    ,contact_cont -- 服务内容
    ,contact_dt -- 联系日期
    ,cust_back -- 客户反馈
    ,int_prod -- 意向产品
    ,contact_name -- 联系人
    ,update_dt -- 待跟进日期
    ,send_tate -- 发送时间
    ,relation -- 客户关系类型
    ,nomal_behave -- 客户异常行为
    ,nom_cust_name -- 异常行为客户
    ,is_noble_metal -- 是否异常
    ,contact_address -- 地点
    ,notice_date -- 提醒时间
    ,flag -- 修改标志
    ,des -- 摘要
    ,task_id -- 任务ID
    ,update_cont -- 跟进内容
    ,create_user_id -- 创建人
    ,create_org_id -- 创建人机构
    ,remark -- 备注
    ,create_time -- 创建时间
    ,buy_amt -- 购买金额
    ,statr_time -- 开始时间
    ,end_time -- 结束时间
    ,update_time -- 更新维护时间
    ,cust_type -- 客户类型
    ,updater -- 维护人中文姓名
    ,updater_id -- 维护人ID
    ,wct_id -- 微信号
    ,concat_type -- 联系方式
    ,act_no -- 活动编号
    ,band_no -- 波段编号
    ,sign_in -- 签到记录 0:未签到 1：已签到
    ,lot_start_time -- 签到有效开始时间
    ,lot_end_time -- 签到有效结束时间
    ,lot_date -- 签到有效时间
    ,mkt_pro_type -- 营销产品类型
    ,yx_amt -- 意向金额
    ,is_gh -- 是否管户
    ,is_gg -- 是否共管
    ,leave_sts -- 审批状态
    ,yd_num -- 华兴云店联络次数
    ,load_date -- 数据日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_b_t_cm_contact
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_b_t_cm_contact exchange partition p_${batch_date} with table ${iol_schema}.bdws_b_t_cm_contact_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_b_t_cm_contact to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_b_t_cm_contact_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_b_t_cm_contact',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);