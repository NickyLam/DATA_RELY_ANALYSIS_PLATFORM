/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_hgls_loan_req_audit
CreateDate: 20250516
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.hgls_loan_req_audit drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.hgls_loan_req_audit add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.hgls_loan_req_audit (
etl_dt  --数据日期
,audit_id  --主键id
,loan_id  --进件id
,approver_user_id  --审批人id
,approver_user_name  --审批人名字
,daily_rate  --日利率（百分之一）
,fnl_store  --综合授信评分
,repayment_period  --最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
,repayment_kind  --还款方式
,auth_money  --授信金额
,rank  --评级（a-f）
,audit_status  --audit_status
,history_audit_status  --是否历史审批0否，1是
,repulse_reason  --审批打回原因
,audit_date  --申请日期
,need_escort  --是否需要陪调客户经理
,credit_guaranty  --是否需要担保人
,inquiry_way  --调查方式；1，简单，2，一般，3，复杂
,credit_company  --是否需要上传征信
,pledge_type  --抵押分类
,assess_price  --评估价格
,year_rate  --年利率
,resolution  --信息复合会办决议
,remark  --会办决议备注
,custom_capital  --是否自定义本金
,allow_one_sign  --是否允许单签
,loan_proof  --放款凭证
,mark  --模型标记信息
,biz_type  --业务类型，0主借人1配偶
,model_frequency  --监测周期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,t1.audit_id as audit_id --主键id
,t1.loan_id as loan_id --进件id
,t1.approver_user_id as approver_user_id --审批人id
,replace(replace(t1.approver_user_name,chr(13),''),chr(10),'') as approver_user_name --审批人名字
,t1.daily_rate as daily_rate --日利率（百分之一）
,t1.fnl_store as fnl_store --综合授信评分
,replace(replace(t1.repayment_period,chr(13),''),chr(10),'') as repayment_period --最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
,replace(replace(t1.repayment_kind,chr(13),''),chr(10),'') as repayment_kind --还款方式
,t1.auth_money as auth_money --授信金额
,replace(replace(t1.rank,chr(13),''),chr(10),'') as rank --评级（a-f）
,replace(replace(t1.audit_status,chr(13),''),chr(10),'') as audit_status --audit_status
,t1.history_audit_status as history_audit_status --是否历史审批0否，1是
,replace(replace(t1.repulse_reason,chr(13),''),chr(10),'') as repulse_reason --审批打回原因
,t1.audit_date as audit_date --申请日期
,t1.need_escort as need_escort --是否需要陪调客户经理
,t1.credit_guaranty as credit_guaranty --是否需要担保人
,replace(replace(t1.inquiry_way,chr(13),''),chr(10),'') as inquiry_way --调查方式；1，简单，2，一般，3，复杂
,t1.credit_company as credit_company --是否需要上传征信
,replace(replace(t1.pledge_type,chr(13),''),chr(10),'') as pledge_type --抵押分类
,t1.assess_price as assess_price --评估价格
,t1.year_rate as year_rate --年利率
,replace(replace(t1.resolution,chr(13),''),chr(10),'') as resolution --信息复合会办决议
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --会办决议备注
,replace(replace(t1.custom_capital,chr(13),''),chr(10),'') as custom_capital --是否自定义本金
,t1.allow_one_sign as allow_one_sign --是否允许单签
,replace(replace(t1.loan_proof,chr(13),''),chr(10),'') as loan_proof --放款凭证
,replace(replace(t1.mark,chr(13),''),chr(10),'') as mark --模型标记信息
,t1.biz_type as biz_type --业务类型，0主借人1配偶
,t1.model_frequency as model_frequency --监测周期
from ${iol_schema}.hgls_loan_req_audit t1    --进件审批表
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'hgls_loan_req_audit',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
