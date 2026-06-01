/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_wrt_off_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_wrt_off_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_wrt_off_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_wrt_off_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,dubil_id  -- 借据编号
    ,cont_id  -- 合同编号
    ,std_prod_id  -- 标准产品编号
    ,cust_id  -- 客户编号
    ,belong_org_id  -- 所属机构编号
    ,appl_teller_id  -- 申请柜员编号
    ,fir_wrt_off_dt  -- 首次核销日期
    ,curr_cd  -- 币种代码
    ,actl_wrtoff_loan_pric  -- 实核贷款本金
    ,actl_wrtoff_in_bs_int  -- 实核表内利息
    ,actl_wrtoff_off_bs_int  -- 实核表外利息
    ,wrt_off_advc_money_amt  -- 核销垫付款项金额
    ,wrt_off_retra_pric  -- 核销收回本金
    ,wrt_off_retra_in_bs_int  -- 核销收回表内利息
    ,wrt_off_retra_off_bs_int  -- 核销收回表外利息
    ,wrt_off_retra_advc_fee  -- 核销收回垫付费用
    ,wrt_off_retra_cnt  -- 核销收回笔数
    ,all_retra_flg  -- 全部收回标志
    ,final_wrt_off_retra_dt  -- 最后核销收回日期
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id  -- 账户编号
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id  -- 借据编号
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id  -- 合同编号
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id  -- 标准产品编号
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id  -- 所属机构编号
    ,replace(replace(t.appl_teller_id,chr(13),''),chr(10),'') as appl_teller_id  -- 申请柜员编号
    ,t.fir_wrt_off_dt as fir_wrt_off_dt  -- 首次核销日期
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,t.actl_wrtoff_loan_pric as actl_wrtoff_loan_pric  -- 实核贷款本金
    ,t.actl_wrtoff_in_bs_int as actl_wrtoff_in_bs_int  -- 实核表内利息
    ,t.actl_wrtoff_off_bs_int as actl_wrtoff_off_bs_int  -- 实核表外利息
    ,t.wrt_off_advc_money_amt as wrt_off_advc_money_amt  -- 核销垫付款项金额
    ,t.wrt_off_retra_pric as wrt_off_retra_pric  -- 核销收回本金
    ,t.wrt_off_retra_in_bs_int as wrt_off_retra_in_bs_int  -- 核销收回表内利息
    ,t.wrt_off_retra_off_bs_int as wrt_off_retra_off_bs_int  -- 核销收回表外利息
    ,t.wrt_off_retra_advc_fee as wrt_off_retra_advc_fee  -- 核销收回垫付费用
    ,t.wrt_off_retra_cnt as wrt_off_retra_cnt  -- 核销收回笔数
    ,replace(replace(t.all_retra_flg,chr(13),''),chr(10),'') as all_retra_flg  -- 全部收回标志
    ,t.final_wrt_off_retra_dt as final_wrt_off_retra_dt  -- 最后核销收回日期
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_unite_wl_wrt_off_info t--联合网贷核销信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.crps_cmm_unite_wl_wrt_off_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_wrt_off_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);