/*
Purpose:    应用集市层-建表脚本,此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_scfs_hdws_iml_agt_ln_ac_amt_info
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
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_amt_info drop partition p_${last_date};
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_amt_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_amt_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.scfs_hdws_iml_agt_ln_ac_amt_info (
     etl_dt                             --数据日期
    ,loan_acct_id                       --贷款账户编号
    ,loan_total_term                    --贷款总期数
    ,loan_new_term                      --贷款目前期数
    ,ccy_cd                             --币种代码
    ,loan_total_bal                     --贷款余额
    ,loan_bal                           --正常本金余额
    ,day_accr_int                       --日应计利息
    ,paid_prcp                          --已偿还本金
    ,paid_int                           --已偿还利息
    ,paid_pnlt                          --已偿还罚息
    ,paid_compd_int                     --已偿还复利
    ,paid_cost                          --已偿还费用
    ,aggr_rcvable_int_amt               --累计应收未收利息金额
    ,int_on_bs_bal                      --表内欠息余额
    ,int_off_bs_bal                     --表外欠息余额
    ,on_int                             --表内利息
    ,off_int                            --表外利息
    ,provn                              --准备金
    ,prev_adj_int_dt                    --上次调息日期
    ,next_adj_int_dt                    --下次调息日期
    ,next_stl_dt                        --下次结息日期
    ,actl_write_off_prcp                --实核本金
    ,actl_write_off_int                 --实核利息
    ,rcva_acr_intr                      --应收应计利息
    ,rcva_owe_int                       --应收欠息
    ,rcva_accr_pnlt                     --应收应计罚息
    ,rcva_pnlt                          --应收罚息
    ,accr_cmpd_intr                     --应计复息
    ,rcva_cmpd_intr                     --应收复息
    ,dun_acr_intr                       --催收应计利息
    ,dun_owe_int                        --催收欠息
    ,dun_accr_pnlt                      --催收应计罚息
    ,dun_pnlt                           --催收罚息
    ,data_src_cd                        --数据来源代码
    ,del_flg                            --删除标志
    ,pkg_bef_rcva_int_val               --封包前应收利息余额
    ,pkg_after_rcva_int_total_amt       --封包后应收利息总额
    ,pkg_after_rcva_int_bal             --封包后应收利息余额
    ,has_retn_pkg_after_rcva_int        --已归还封包后应收利息
    ,tfr_loan_int_total_amt             --转让贷款利息总额
    ,etl_task_name                      --ETL任务
    ,last_update_dt                     --最后更新时间
    ,job_cd                             --任务代码
    ,AGT_MODF                           --协议修饰符
    ,etl_timestamp                      --ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt                                         --数据日期
    ,loan_acct_id                                                                         --贷款账户编号
    ,loan_total_term                                                                      --贷款总期数
    ,loan_new_term                                                                        --贷款目前期数
    ,ccy_cd                                                                               --币种代码
    ,loan_total_bal                                                                       --贷款余额
    ,loan_bal                                                                             --正常本金余额
    ,day_accr_int                                                                         --日应计利息
    ,paid_prcp                                                                            --已偿还本金
    ,paid_int                                                                             --已偿还利息
    ,paid_pnlt                                                                            --已偿还罚息
    ,paid_compd_int                                                                       --已偿还复利
    ,paid_cost                                                                            --已偿还费用
    ,aggr_rcvable_int_amt                                                                 --累计应收未收利息金额
    ,int_on_bs_bal                                                                        --表内欠息余额
    ,int_off_bs_bal                                                                       --表外欠息余额
    ,on_int                                                                               --表内利息
    ,off_int                                                                              --表外利息
    ,provn                                                                                --准备金
    ,prev_adj_int_dt                                                                      --上次调息日期
    ,next_adj_int_dt                                                                      --下次调息日期
    ,next_stl_dt                                                                          --下次结息日期
    ,actl_write_off_prcp                                                                  --实核本金
    ,actl_write_off_int                                                                   --实核利息
    ,rcva_acr_intr                                                                        --应收应计利息
    ,rcva_owe_int                                                                         --应收欠息
    ,rcva_accr_pnlt                                                                       --应收应计罚息
    ,rcva_pnlt                                                                            --应收罚息
    ,accr_cmpd_intr                                                                       --应计复息
    ,rcva_cmpd_intr                                                                       --应收复息
    ,dun_acr_intr                                                                         --催收应计利息
    ,dun_owe_int                                                                          --催收欠息
    ,dun_accr_pnlt                                                                        --催收应计罚息
    ,dun_pnlt                                                                             --催收罚息
    ,data_src_cd                                                                          --数据来源代码
    ,del_flg                                                                              --删除标志
    ,pkg_bef_rcva_int_val                                                                 --封包前应收利息余额
    ,pkg_after_rcva_int_total_amt                                                         --封包后应收利息总额
    ,pkg_after_rcva_int_bal                                                               --封包后应收利息余额
    ,has_retn_pkg_after_rcva_int                                                          --已归还封包后应收利息
    ,tfr_loan_int_total_amt                                                               --转让贷款利息总额
    ,etl_task_name                                                                        --ETL任务
    ,last_update_dt                                                                       --最后更新时间
    ,job_cd                                                                               --任务代码
    ,AGT_MODF                                                                             --协议修饰符
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp     --ETL处理时间戳
from ${idl_schema}.hdws_iml_agt_ln_ac_amt_info t1    --贷款账户金额信息
where etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd in ('CRSS','CBSS');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'scfs_hdws_iml_agt_ln_ac_amt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);