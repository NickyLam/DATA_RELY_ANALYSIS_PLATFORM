/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_bill_center_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_cmm_bill_center_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_bill_center_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_bill_center_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_bill_center_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bill_id  -- 票据编号
    ,bill_num  -- 票据号码
    ,bill_med_cd  -- 票据介质代码
    ,bill_type_cd  -- 票据类型代码
    ,draw_dt  -- 出票日期
    ,exp_dt  -- 到期日期
    ,curr_cd  -- 币种代码
    ,fac_val_amt  -- 票面金额
    ,drawer_name  -- 出票人名称
    ,drawer_acct_num  -- 出票人账号
    ,drawer_open_bank_no  -- 出票人开户行行号
    ,drawer_open_bank_name  -- 出票人开户行名称
    ,recver_name  -- 收款人名称
    ,recver_acct_num  -- 收款人账号
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,pay_bank_bank_no  -- 付款行行号
    ,pay_bank_name  -- 付款行名称
    ,pay_org_id  -- 付款机构编号
    ,pay_cfm_org_id  -- 付款确认机构编号
    ,accptor_name  -- 承兑人名称
    ,accptor_acct_num  -- 承兑人账号
    ,accptor_open_bank_no  -- 承兑人开户行行号
    ,accptor_open_bank_name  -- 承兑人开户行名称
    ,holder_org_id  -- 持票人机构编号
    ,holder_org_name  -- 持票人机构名称
    ,endors_cnt  -- 背书次数
    ,lock_flg  -- 锁定标志
    ,loss_flg  -- 挂失标志
    ,hxb_acpt_flg  -- 我行承兑标志
    ,pay_cfm_flg  -- 付款确认标志
    ,payoff_flg  -- 结清标志
    ,recs_flg  -- 追偿标志
    ,risk_status_cd  -- 风险状态代码
    ,bill_src_cd  -- 票据来源代码
    ,bill_status_cd  -- 票据状态代码
    ,belong_org_id  -- 所属机构编号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
    ,data_src_cd    -- 数据来源代码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bill_id,chr(13),''),chr(10),'')  -- 票据编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'')  -- 票据类型代码
    ,t1.draw_dt  -- 出票日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.fac_val_amt  -- 票面金额
    ,replace(replace(t1.drawer_name,chr(13),''),chr(10),'')  -- 出票人名称
    ,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'')  -- 出票人账号
    ,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'')  -- 出票人开户行行号
    ,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'')  -- 出票人开户行名称
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.pay_bank_bank_no,chr(13),''),chr(10),'')  -- 付款行行号
    ,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'')  -- 付款行名称
    ,replace(replace(t1.pay_org_id,chr(13),''),chr(10),'')  -- 付款机构编号
    ,replace(replace(t1.pay_cfm_org_id,chr(13),''),chr(10),'')  -- 付款确认机构编号
    ,replace(replace(t1.accptor_name,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'')  -- 承兑人账号
    ,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'')  -- 承兑人开户行行号
    ,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.holder_org_id,chr(13),''),chr(10),'')  -- 持票人机构编号
    ,replace(replace(t1.holder_org_name,chr(13),''),chr(10),'')  -- 持票人机构名称
    ,t1.endors_cnt  -- 背书次数
    ,replace(replace(t1.lock_flg,chr(13),''),chr(10),'')  -- 锁定标志
    ,replace(replace(t1.loss_flg,chr(13),''),chr(10),'')  -- 挂失标志
    ,replace(replace(t1.hxb_acpt_flg,chr(13),''),chr(10),'')  -- 我行承兑标志
    ,replace(replace(t1.pay_cfm_flg,chr(13),''),chr(10),'')  -- 付款确认标志
    ,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'')  -- 结清标志
    ,replace(replace(t1.recs_flg,chr(13),''),chr(10),'')  -- 追偿标志
    ,replace(replace(t1.risk_status_cd,chr(13),''),chr(10),'')  -- 风险状态代码
    ,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'')  -- 票据来源代码
    ,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'')  -- 票据状态代码
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
    ,data_src_cd    -- 数据来源代码
from ${icl_schema}.cmm_bill_center_info t1    --票据中心信息
  where t1.etl_dt= to_date('${batch_date}','yyyymmdd'); 
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_bill_center_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);