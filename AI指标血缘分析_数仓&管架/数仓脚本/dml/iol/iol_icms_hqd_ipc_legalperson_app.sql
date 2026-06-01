/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_hqd_ipc_legalperson_app
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
drop table ${iol_schema}.icms_hqd_ipc_legalperson_app_ex purge;
alter table ${iol_schema}.icms_hqd_ipc_legalperson_app add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_hqd_ipc_legalperson_app;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_hqd_ipc_legalperson_app_ex nologging
compress
as
select * from ${iol_schema}.icms_hqd_ipc_legalperson_app where 0=1;

insert /*+ append */ into ${iol_schema}.icms_hqd_ipc_legalperson_app_ex(
    serialno -- 流水号
    ,applyno -- 业务申请流水号
    ,baserialno -- 授信申请流水号
    ,approvestatus -- 审批状态
    ,occurtype -- 发生类型
    ,productid -- 产品编号
    ,productname -- 产品名称
    ,channel -- 渠道
    ,customerid -- 客户编号
    ,customername -- 客户名称
    ,currency -- 币种
    ,businesssum -- 贷款金额
    ,exposureamount -- 敞口金额
    ,loanusetype -- 贷款用途
    ,termmonth -- 期限(月)
    ,iscycle -- 是否循环
    ,vouchtype -- 主担保方式
    ,vouchtypeinner -- 担保方式（内部口径）
    ,evaluateresult -- 评估结果
    ,evaluatedate -- 评级认定日期
    ,evaluatematurity -- 评级到期日期
    ,oldcreditno -- 原申请流水号
    ,oldedcontractno -- 原额度合同流水号
    ,oldduebillno -- 原借据流水号
    ,compcreditimage -- 公司客户征信影像
    ,legalcreditimage -- 公司法人征信影像
    ,guarcreditimage -- 保证人征信影像
    ,remark -- 备注
    ,operateuserid -- 经办人
    ,operateorgid -- 经办机构
    ,operatedate -- 经办日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,repaytypes -- 还款方式列表
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流水号
    ,applyno -- 业务申请流水号
    ,baserialno -- 授信申请流水号
    ,approvestatus -- 审批状态
    ,occurtype -- 发生类型
    ,productid -- 产品编号
    ,productname -- 产品名称
    ,channel -- 渠道
    ,customerid -- 客户编号
    ,customername -- 客户名称
    ,currency -- 币种
    ,businesssum -- 贷款金额
    ,exposureamount -- 敞口金额
    ,loanusetype -- 贷款用途
    ,termmonth -- 期限(月)
    ,iscycle -- 是否循环
    ,vouchtype -- 主担保方式
    ,vouchtypeinner -- 担保方式（内部口径）
    ,evaluateresult -- 评估结果
    ,evaluatedate -- 评级认定日期
    ,evaluatematurity -- 评级到期日期
    ,oldcreditno -- 原申请流水号
    ,oldedcontractno -- 原额度合同流水号
    ,oldduebillno -- 原借据流水号
    ,compcreditimage -- 公司客户征信影像
    ,legalcreditimage -- 公司法人征信影像
    ,guarcreditimage -- 保证人征信影像
    ,remark -- 备注
    ,operateuserid -- 经办人
    ,operateorgid -- 经办机构
    ,operatedate -- 经办日期
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,inputdate -- 登记日期
    ,updateuserid -- 更新人
    ,updateorgid -- 更新机构
    ,updatedate -- 更新日期
    ,repaytypes -- 还款方式列表
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_hqd_ipc_legalperson_app
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_hqd_ipc_legalperson_app exchange partition p_${batch_date} with table ${iol_schema}.icms_hqd_ipc_legalperson_app_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_hqd_ipc_legalperson_app to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_hqd_ipc_legalperson_app_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_hqd_ipc_legalperson_app',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);