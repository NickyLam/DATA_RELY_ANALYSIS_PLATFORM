/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_lc_doc_info
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
alter table ${idl_schema}.icrm_cmm_lc_doc_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_lc_doc_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_lc_doc_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_lc_doc_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,doc_agt_id  -- 单据协议编号
    ,doc_id  -- 单据编号
    ,lc_acct_id  -- 信用证账户编号
    ,commer_inv_no  -- 商业发票号码
    ,subj_id  -- 科目编号
    ,mx_lc_flg  -- 进出口信用证标志
    ,arrive_bill_flg  -- 到单标志
    ,acpt_flg  -- 承兑标志
    ,send_bill_dt  -- 寄单日期
    ,issue_dt  -- 开证日期
    ,wrtoff_dt  -- 注销日期
    ,acpt_dt  -- 承兑日期
    ,arrive_bill_dt  -- 到单日期
    ,pay_dt  -- 付款日期
    ,payer_id  -- 付款人编号
    ,cust_mgr_id  -- 客户经理编号
    ,oper_org_id  -- 经办机构编号
    ,pay_org_id  -- 付款机构编号
    ,sign_org_id  -- 签署机构编号
    ,acct_instit_id  -- 账务机构编号
    ,payer_name  -- 付款人名称
    ,doc_type_cd  -- 单据类型代码
    ,doc_status_cd  -- 单据状态代码
    ,curr_cd  -- 币种代码
    ,overs_deduct_amt  -- 国外扣费金额
    ,pay_amt  -- 付款金额
    ,lc_bal  -- 信用证余额
    ,cl_curr_lc_bal  -- 折本币信用证余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.doc_agt_id,chr(13),''),chr(10),'')  -- 单据协议编号
    ,replace(replace(t1.doc_id,chr(13),''),chr(10),'')  -- 单据编号
    ,replace(replace(t1.lc_acct_id,chr(13),''),chr(10),'')  -- 信用证账户编号
    ,replace(replace(t1.commer_inv_no,chr(13),''),chr(10),'')  -- 商业发票号码
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.mx_lc_flg,chr(13),''),chr(10),'')  -- 进出口信用证标志
    ,replace(replace(t1.arrive_bill_flg,chr(13),''),chr(10),'')  -- 到单标志
    ,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'')  -- 承兑标志
    ,t1.send_bill_dt  -- 寄单日期
    ,t1.issue_dt  -- 开证日期
    ,t1.wrtoff_dt  -- 注销日期
    ,t1.acpt_dt  -- 承兑日期
    ,t1.arrive_bill_dt  -- 到单日期
    ,t1.pay_dt  -- 付款日期
    ,replace(replace(t1.payer_id,chr(13),''),chr(10),'')  -- 付款人编号
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'')  -- 经办机构编号
    ,replace(replace(t1.pay_org_id,chr(13),''),chr(10),'')  -- 付款机构编号
    ,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'')  -- 签署机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,replace(replace(t1.payer_name,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.doc_type_cd,chr(13),''),chr(10),'')  -- 单据类型代码
    ,replace(replace(t1.doc_status_cd,chr(13),''),chr(10),'')  -- 单据状态代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.overs_deduct_amt  -- 国外扣费金额
    ,t1.pay_amt  -- 付款金额
    ,t1.lc_bal  -- 信用证余额
    ,t1.cl_curr_lc_bal  -- 折本币信用证余额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${icl_schema}.cmm_lc_doc_info t1    --信用证单据信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_lc_doc_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);