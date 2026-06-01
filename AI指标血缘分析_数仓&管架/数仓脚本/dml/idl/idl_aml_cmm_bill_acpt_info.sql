/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_bill_acpt_info
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
alter table ${idl_schema}.aml_cmm_bill_acpt_info drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_bill_acpt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_bill_acpt_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_bill_acpt_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,bus_id  -- 业务编号
    ,batch_id  -- 批次编号
    ,bill_num  -- 票据号码
    ,cust_id  -- 客户编号
    ,bill_med_cd  -- 票据介质代码
    ,bill_kind_cd  -- 票据种类代码
    ,appl_dt  -- 申请日期
    ,recv_dt  -- 签收日期
    ,draw_dt  -- 出票日期
    ,exp_dt  -- 到期日期
    ,dir_indus_name  -- 投向行业名称
    ,main_guar_way_cd  -- 主担保方式代码
    ,drawer_name  -- 出票人名称
    ,drawer_cate_cd  -- 出票人类别代码
    ,drawer_acct_num  -- 出票人账号
    ,drawer_open_bank_no  -- 出票人开户行行号
    ,drawer_open_bank_name  -- 出票人开户行名称
    ,accptor_name  -- 承兑人名称
    ,accptor_acct_num  -- 承兑人账号
    ,accptor_open_bank_no  -- 承兑人开户行行号
    ,accptor_open_bank_name  -- 承兑人开户行名称
    ,recver_cust_id  -- 收款人客户编号
    ,recver_name  -- 收款人名称
    ,recver_acct_num  -- 收款人账号
    ,recver_open_bank_no  -- 收款人开户行行号
    ,recver_open_bank_name  -- 收款人开户行名称
    ,repay_num  -- 还款账号
    ,entry_dt  -- 记账日期
    ,revo_dt  -- 撤销日期
    ,bus_flow_num  -- 业务流水号
    ,margin_ratio  -- 保证金比例
    ,comm_fee_ratio  -- 手续费比例
    ,entry_status_cd  -- 记账状态代码
    ,draw_status_cd  -- 出票状态代码
    ,tranbl_flg  -- 可转让标志
    ,uncond_pay_flg  -- 无条件支付标志
    ,curr_cd  -- 币种代码
    ,fac_val_amt  -- 票面金额
    ,payoff_flg  -- 结清标志
    ,lmt_ocup_amt  -- 额度占用金额
    ,lmt_ocup_status_cd  -- 额度占用状态代码
    ,comm_fee  -- 手续费
    ,todos  -- 工本费
    ,acpt_fee  -- 承兑费
    ,mgmt_fee  -- 管理费
    ,accptor_crdt_level_cd  -- 承兑人信用等级代码
    ,accptor_rating_exp_dt  -- 承兑人评级到期日期
    ,issue_org_id  -- 签发机构编号
    ,enter_acct_org_id  -- 入账机构编号
    ,cust_mgr_id  -- 客户经理编号
    ,dept_id  -- 部门编号
    ,operr_id  -- 操作员编号
    ,group_open_flg  -- 集团代开标志
    ,group_name  -- 集团名称
    ,group_id  -- 集团编号
    ,group_open_drawer_name  -- 集团代开出票人名称
    ,group_open_drawer_cust_no  -- 集团代开出票人客户号
    ,job_cd  -- 任务代码
)
select
    t1.etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.batch_id,chr(13),''),chr(10),'')  -- 批次编号
    ,replace(replace(t1.bill_num,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'')  -- 票据介质代码
    ,replace(replace(t1.bill_kind_cd,chr(13),''),chr(10),'')  -- 票据种类代码
    ,t1.appl_dt  -- 申请日期
    ,t1.recv_dt  -- 签收日期
    ,t1.draw_dt  -- 出票日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.dir_indus_name,chr(13),''),chr(10),'')  -- 投向行业名称
    ,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'')  -- 主担保方式代码
    ,replace(replace(t1.drawer_name,chr(13),''),chr(10),'')  -- 出票人名称
    ,replace(replace(t1.drawer_cate_cd,chr(13),''),chr(10),'')  -- 出票人类别代码
    ,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'')  -- 出票人账号
    ,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'')  -- 出票人开户行行号
    ,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'')  -- 出票人开户行名称
    ,replace(replace(t1.accptor_name,chr(13),''),chr(10),'')  -- 承兑人名称
    ,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'')  -- 承兑人账号
    ,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'')  -- 承兑人开户行行号
    ,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'')  -- 承兑人开户行名称
    ,replace(replace(t1.recver_cust_id,chr(13),''),chr(10),'')  -- 收款人客户编号
    ,replace(replace(t1.recver_name,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.repay_num,chr(13),''),chr(10),'')  -- 还款账号
    ,t1.entry_dt  -- 记账日期
    ,t1.revo_dt  -- 撤销日期
    ,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'')  -- 业务流水号
    ,t1.margin_ratio  -- 保证金比例
    ,t1.comm_fee_ratio  -- 手续费比例
    ,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'')  -- 记账状态代码
    ,replace(replace(t1.draw_status_cd,chr(13),''),chr(10),'')  -- 出票状态代码
    ,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'')  -- 可转让标志
    ,replace(replace(t1.uncond_pay_flg,chr(13),''),chr(10),'')  -- 无条件支付标志
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.fac_val_amt  -- 票面金额
    ,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'')  -- 结清标志
    ,t1.lmt_ocup_amt  -- 额度占用金额
    ,replace(replace(t1.lmt_ocup_status_cd,chr(13),''),chr(10),'')  -- 额度占用状态代码
    ,t1.comm_fee  -- 手续费
    ,t1.todos  -- 工本费
    ,t1.acpt_fee  -- 承兑费
    ,t1.mgmt_fee  -- 管理费
    ,replace(replace(t1.accptor_crdt_level_cd,chr(13),''),chr(10),'')  -- 承兑人信用等级代码
    ,t1.accptor_rating_exp_dt  -- 承兑人评级到期日期
    ,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'')  -- 签发机构编号
    ,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'')  -- 入账机构编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.dept_id,chr(13),''),chr(10),'')  -- 部门编号
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.group_open_flg,chr(13),''),chr(10),'')  -- 集团代开标志
    ,replace(replace(t1.group_name,chr(13),''),chr(10),'')  -- 集团名称
    ,replace(replace(t1.group_id,chr(13),''),chr(10),'')  -- 集团编号
    ,replace(replace(t1.group_open_drawer_name,chr(13),''),chr(10),'')  -- 集团代开出票人名称
    ,replace(replace(t1.group_open_drawer_cust_no,chr(13),''),chr(10),'')  -- 集团代开出票人客户号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
from ${icl_schema}.cmm_bill_acpt_info t1    --票据承兑信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_bill_acpt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);