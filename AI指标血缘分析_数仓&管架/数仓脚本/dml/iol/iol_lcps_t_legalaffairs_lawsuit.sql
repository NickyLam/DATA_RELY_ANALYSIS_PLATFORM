/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lcps_t_legalaffairs_lawsuit
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
drop table ${iol_schema}.lcps_t_legalaffairs_lawsuit_ex purge;
alter table ${iol_schema}.lcps_t_legalaffairs_lawsuit add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.lcps_t_legalaffairs_lawsuit;

-- 2.3 insert data to ex table
create table ${iol_schema}.lcps_t_legalaffairs_lawsuit_ex nologging
compress
as
select * from ${iol_schema}.lcps_t_legalaffairs_lawsuit where 0=1;

insert /*+ append */ into ${iol_schema}.lcps_t_legalaffairs_lawsuit_ex(
    id -- 编号
    ,involve_code -- 涉诉单位
    ,service_type -- 业务类型
    ,handling_by -- 经办客户经理
    ,case_type -- 案件分类
    ,indict_by -- 起诉(仲裁申请)/被诉(仲裁被申请)/第三人
    ,opposite_by -- 相对人(第三人)名称
    ,brief -- 案由
    ,involve_amount -- 诉讼/仲裁涉案金额(万元)
    ,judicial_code -- 受诉司法机关、仲裁机构
    ,file_date -- 立案日期
    ,case_stage -- 案件阶段
    ,trial_result -- 审理结果
    ,trial_date -- 终审日期(终审裁决书日期)
    ,compulsion_date -- 申请强制执行日期
    ,execute_date -- 终结本案本次执日期
    ,execute_result -- 执行结果
    ,end_date -- 清偿完毕日期(终结执行日期)
    ,verification -- 是否已核销
    ,transfer -- 是否已债权转让
    ,entrust -- 是否委托律师
    ,lawyer_code -- 律师事务所
    ,lawsuit_amount -- 诉讼费用(万元)
    ,withdraw_amount -- 收回金额(万元)
    ,case_typ -- 案件类型
    ,trial_status -- 审理状态
    ,case_name -- 案件名称
    ,case_num -- 审批号
    ,case_no -- 案号
    ,case_code -- 案件编号
    ,status -- 状态（0正常 1删除 2停用）
    ,create_by -- 创建者
    ,create_date -- 创建时间
    ,update_by -- 更新者
    ,update_date -- 更新时间
    ,remarks -- 备注信息
    ,corp_code -- 租户代码
    ,corp_name -- 租户名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 编号
    ,involve_code -- 涉诉单位
    ,service_type -- 业务类型
    ,handling_by -- 经办客户经理
    ,case_type -- 案件分类
    ,indict_by -- 起诉(仲裁申请)/被诉(仲裁被申请)/第三人
    ,opposite_by -- 相对人(第三人)名称
    ,brief -- 案由
    ,involve_amount -- 诉讼/仲裁涉案金额(万元)
    ,judicial_code -- 受诉司法机关、仲裁机构
    ,file_date -- 立案日期
    ,case_stage -- 案件阶段
    ,trial_result -- 审理结果
    ,trial_date -- 终审日期(终审裁决书日期)
    ,compulsion_date -- 申请强制执行日期
    ,execute_date -- 终结本案本次执日期
    ,execute_result -- 执行结果
    ,end_date -- 清偿完毕日期(终结执行日期)
    ,verification -- 是否已核销
    ,transfer -- 是否已债权转让
    ,entrust -- 是否委托律师
    ,lawyer_code -- 律师事务所
    ,lawsuit_amount -- 诉讼费用(万元)
    ,withdraw_amount -- 收回金额(万元)
    ,case_typ -- 案件类型
    ,trial_status -- 审理状态
    ,case_name -- 案件名称
    ,case_num -- 审批号
    ,case_no -- 案号
    ,case_code -- 案件编号
    ,status -- 状态（0正常 1删除 2停用）
    ,create_by -- 创建者
    ,create_date -- 创建时间
    ,update_by -- 更新者
    ,update_date -- 更新时间
    ,remarks -- 备注信息
    ,corp_code -- 租户代码
    ,corp_name -- 租户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.lcps_t_legalaffairs_lawsuit
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.lcps_t_legalaffairs_lawsuit exchange partition p_${batch_date} with table ${iol_schema}.lcps_t_legalaffairs_lawsuit_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lcps_t_legalaffairs_lawsuit to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.lcps_t_legalaffairs_lawsuit_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lcps_t_legalaffairs_lawsuit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);