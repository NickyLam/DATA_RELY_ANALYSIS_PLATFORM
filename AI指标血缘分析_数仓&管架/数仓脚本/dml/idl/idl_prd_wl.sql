/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_prd_wl
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
--alter table ${idl_schema}.prd_wl drop partition p_${last_date};
alter table ${idl_schema}.prd_wl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.prd_wl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.prd_wl (
    etl_dt  -- 数据日期
    ,prod_id  -- 产品编号
    ,lp_id  -- 法人编号
    ,loan_prod_id  -- 贷款产品编号
    ,prod_cls_id  -- 产品分类编号
    ,cap_acct_id  -- 资金账户编号
    ,return_acct_id  -- 回款账户编号
    ,deflt_chn_id  -- 默认渠道编号
    ,org_id  -- 机构编号
    ,prod_attr_cd  -- 产品属性代码
    ,user_group_id  -- 用户组编号
    ,min_loan_tenor  -- 最小贷款期限
    ,max_loan_tenor  -- 最大贷款期限
    ,single_loan_lolmi_amt  -- 单笔贷款下限金额
    ,single_loan_uplmi_amt  -- 单笔贷款上限金额
    ,min_crdt_lmt  -- 最小授信额度
    ,max_crdt_lmt  -- 最大授信额度
    ,exec_uplmi_mon_int_rat  -- 执行上限月利率
    ,exec_lolmi_mon_int_rat  -- 执行下限月利率
    ,sp_check_ratio  -- 抽检比例
    ,grace_days  -- 宽限天数
    ,auto_apv_flg  -- 自动审批标志
    ,auto_distr_flg  -- 自动放款标志
    ,aval_status_flg  -- 可用状态标志
    ,sp_check_swi_flg  -- 抽检开关标志
    ,loan_mode_cd  -- 贷款模式代码
    ,tenor_type_cd  -- 期限类型代码
    ,int_rat_ped_cd  -- 利率周期代码
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'')  -- 贷款产品编号
    ,replace(replace(t1.prod_cls_id,chr(13),''),chr(10),'')  -- 产品分类编号
    ,replace(replace(t1.cap_acct_id,chr(13),''),chr(10),'')  -- 资金账户编号
    ,replace(replace(t1.return_acct_id,chr(13),''),chr(10),'')  -- 回款账户编号
    ,replace(replace(t1.deflt_chn_id,chr(13),''),chr(10),'')  -- 默认渠道编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'')  -- 产品属性代码
    ,replace(replace(t1.user_group_id,chr(13),''),chr(10),'')  -- 用户组编号
    ,t1.min_loan_tenor  -- 最小贷款期限
    ,t1.max_loan_tenor  -- 最大贷款期限
    ,t1.single_loan_lolmi_amt  -- 单笔贷款下限金额
    ,t1.single_loan_uplmi_amt  -- 单笔贷款上限金额
    ,t1.min_crdt_lmt  -- 最小授信额度
    ,t1.max_crdt_lmt  -- 最大授信额度
    ,t1.exec_uplmi_mon_int_rat  -- 执行上限月利率
    ,t1.exec_lolmi_mon_int_rat  -- 执行下限月利率
    ,t1.sp_check_ratio  -- 抽检比例
    ,t1.grace_days  -- 宽限天数
    ,replace(replace(t1.auto_apv_flg,chr(13),''),chr(10),'')  -- 自动审批标志
    ,replace(replace(t1.auto_distr_flg,chr(13),''),chr(10),'')  -- 自动放款标志
    ,replace(replace(t1.aval_status_flg,chr(13),''),chr(10),'')  -- 可用状态标志
    ,replace(replace(t1.sp_check_swi_flg,chr(13),''),chr(10),'')  -- 抽检开关标志
    ,replace(replace(t1.loan_mode_cd,chr(13),''),chr(10),'')  -- 贷款模式代码
    ,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'')  -- 期限类型代码
    ,replace(replace(t1.int_rat_ped_cd,chr(13),''),chr(10),'')  -- 利率周期代码
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码
from ${iml_schema}.prd_wl t1    --网贷产品
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'prd_wl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);