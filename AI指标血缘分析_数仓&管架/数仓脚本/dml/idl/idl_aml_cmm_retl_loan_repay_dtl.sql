/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_cmm_retl_loan_repay_dtl
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
alter table ${idl_schema}.aml_cmm_retl_loan_repay_dtl drop partition p_${last_date};
alter table ${idl_schema}.aml_cmm_retl_loan_repay_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_cmm_retl_loan_repay_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_cmm_retl_loan_repay_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,dubil_id  -- 借据编号
    ,cont_id  -- 合同编号
    ,cust_id  -- 客户编号
    ,repay_acct_id  -- 还款账户编号
    ,repay_flow_id  -- 还款流水编号
    ,repay_dt  -- 还款日期
    ,repaybl_dt  -- 应还款日期
    ,repay_perds  -- 还款期数
    ,repay_sub_perds  -- 还款子期数
    ,adv_repay_flg  -- 提前还款标志
    ,ovdue_repay_flg  -- 逾期还款标志
    ,comp_repay_flg  -- 代偿还款标志
    ,bf_repay_status_cd  -- 还款前还款状态代码
    ,repay_post_repay_status_cd  -- 还款后还款状态代码
    ,acru_non_acru_cd  -- 应计非应计代码
    ,tran_cd  -- 交易代码
    ,curr_cd  -- 币种代码
    ,dtl_seq_num  -- 明细序号
    ,repay_evt_cd  -- 还款事件代码
    ,repay_evt_descb  -- 还款事件描述
    ,currt_repay_recvbl_acru_int  -- 当期还款应收应计利息
    ,currt_repay_coll_acru_int  -- 当期还款催收应计利息
    ,currt_repay_recvbl_over_int  -- 当期还款应收欠息
    ,currt_repay_coll_over_int  -- 当期还款催收欠息
    ,currt_repay_recvbl_acru_pnlt  -- 当期还款应收应计罚息
    ,currt_repay_coll_acru_pnlt  -- 当期还款催收应计罚息
    ,currt_repay_recvbl_pnlt  -- 当期还款应收罚息
    ,currt_repay_coll_pnlt  -- 当期还款催收罚息
    ,currt_repay_acru_comp_int  -- 当期还款应计复息
    ,currt_repay_recvbl_comp_int  -- 当期还款应收复息
    ,currt_fine  -- 当期罚金
    ,currt_wrt_off_int  -- 当期核销利息
    ,curr_nomal_pric_bal  -- 当前正常本金余额
    ,currt_repay_pric  -- 当期还款本金
    ,currt_repay_int  -- 当期还款利息
    ,currt_repay_pnlt  -- 当期还款罚息
    ,currt_repay_comp_int  -- 当期还款复利
    ,currt_repay_fee  -- 当期还款费用
    ,unbd_int  -- 未入账利息
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.dubil_id,chr(13),''),chr(10),'')  -- 借据编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'')  -- 还款账户编号
    ,replace(replace(t1.repay_flow_id,chr(13),''),chr(10),'')  -- 还款流水编号
    ,t1.repay_dt  -- 还款日期
    ,t1.repaybl_dt  -- 应还款日期
    ,t1.repay_perds  -- 还款期数
    ,t1.repay_sub_perds  -- 还款子期数
    ,replace(replace(t1.adv_repay_flg,chr(13),''),chr(10),'')  -- 提前还款标志
    ,replace(replace(t1.ovdue_repay_flg,chr(13),''),chr(10),'')  -- 逾期还款标志
    ,replace(replace(t1.comp_repay_flg,chr(13),''),chr(10),'')  -- 代偿还款标志
    ,replace(replace(t1.bf_repay_status_cd,chr(13),''),chr(10),'')  -- 还款前还款状态代码
    ,replace(replace(t1.repay_post_repay_status_cd,chr(13),''),chr(10),'')  -- 还款后还款状态代码
    ,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'')  -- 应计非应计代码
    ,replace(replace(t1.tran_cd,chr(13),''),chr(10),'')  -- 交易代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.dtl_seq_num,chr(13),''),chr(10),'')  -- 明细序号
    ,replace(replace(t1.repay_evt_cd,chr(13),''),chr(10),'')  -- 还款事件代码
    ,replace(replace(t1.repay_evt_descb,chr(13),''),chr(10),'')  -- 还款事件描述
    ,t1.currt_repay_recvbl_acru_int  -- 当期还款应收应计利息
    ,t1.currt_repay_coll_acru_int  -- 当期还款催收应计利息
    ,t1.currt_repay_recvbl_over_int  -- 当期还款应收欠息
    ,t1.currt_repay_coll_over_int  -- 当期还款催收欠息
    ,t1.currt_repay_recvbl_acru_pnlt  -- 当期还款应收应计罚息
    ,t1.currt_repay_coll_acru_pnlt  -- 当期还款催收应计罚息
    ,t1.currt_repay_recvbl_pnlt  -- 当期还款应收罚息
    ,t1.currt_repay_coll_pnlt  -- 当期还款催收罚息
    ,t1.currt_repay_acru_comp_int  -- 当期还款应计复息
    ,t1.currt_repay_recvbl_comp_int  -- 当期还款应收复息
    ,t1.currt_fine  -- 当期罚金
    ,t1.currt_wrt_off_int  -- 当期核销利息
    ,t1.curr_nomal_pric_bal  -- 当前正常本金余额
    ,t1.currt_repay_pric  -- 当期还款本金
    ,t1.currt_repay_int  -- 当期还款利息
    ,t1.currt_repay_pnlt  -- 当期还款罚息
    ,t1.currt_repay_comp_int  -- 当期还款复利
    ,t1.currt_repay_fee  -- 当期还款费用
    ,t1.unbd_int  -- 未入账利息
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_retl_loan_repay_dtl t1    --零售贷款还款明细
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_cmm_retl_loan_repay_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);