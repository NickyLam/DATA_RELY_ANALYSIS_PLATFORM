/*
Purpose:    应用集市层-建表脚本,此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_scfs_hdws_iml_agt_ln_ac_base_info
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
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_base_info drop partition p_${last_date};
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_base_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.scfs_hdws_iml_agt_ln_ac_base_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.scfs_hdws_iml_agt_ln_ac_base_info (
       etl_dt                          --数据日期
      ,data_src_cd                     --数据来源代码
      ,del_flg                         --删除标志
      ,loan_acct_id                    --贷款账户编号
      ,blng_pty_id                     --所属客户编号
      ,acct_name                       --账户名称
      ,prd_id                          --核算产品编号
      ,open_dt                         --开户日期
      ,loan_issue_dt                   --放款日期
      ,int_dt                          --起息日期
      ,trmi_dt                         --终止日期
      ,due_dt                          --到期日期
      ,open_org_id                     --开户机构编号
      ,mgmt_org_id                     --管理机构编号
      ,accting_org_id                  --账务机构编号
      ,pty_mgr_id                      --客户经理编号
      ,agt_status_cd                   --贷款账户状态代码
      ,accting_coa_id                  --会计科目编号
      ,term_corp_cd                    --期限单位代码
      ,loan_term                       --贷款期限
      ,ccy_cd                          --币种代码
      ,issue_amt                       --发放金额
      ,rate_base_typ_cd                --利率基准类型代码
      ,rate_base_val                   --利率基准值
      ,exec_rate                       --正常执行利率
      ,ovdue_exec_rate                 --逾期执行利率
      ,float_rate_flg                  --浮动利率标志
      ,rate_float_mode_cd              --利率浮动方式代码
      ,float_freq_cd                   --浮动频率代码
      ,rate_float_val                  --正常利率浮动值
      ,ovdue_rate_float                --逾期利率浮动值
      ,curr_rate_eff_day               --当前利率生效日
      ,next_rate_adj_day               --下一利率调整日
      ,loan_base_mon_day_qty           --贷款基准月天数
      ,loan_base_year_day_qty          --贷款基准年天数
      ,loan_compd_int_flg              --贷款复利标志
      ,loan_stl_mode_cd                --贷款结息方式代码
      ,loan_int_mode_cd                --贷款计息方式代码
      ,loan_calc_forml                 --贷款计算公式
      ,dd_acct_id                      --放款账户编号
      ,repay_mode_cd                   --还款方式代码
      ,repay_freq_cd                   --还款频率代码
      ,repay_acct_id                   --还款账户编号
      ,assoc_loan_contr_id             --贷款合同编号
      ,bil_acct_id                     --记账分户账编号
      ,assoc_bil_id                    --关联票证编号
      ,loan_assoc_marg_acct            --贷款关联保证金账号
      ,margin_ccy_cd                   --保证金币种代码
      ,margin_amt                      --保证金金额
      ,marg_ratio                      --保证金比例
      ,blng_biz_line_cd                --所属业务条线代码
      ,loan_biz_type_cd                --贷款业务品种代码
      ,sub_guar_mode_cd                --子担保方式代码
      ,loan_cate_cd                    --贷款类型代码
      ,gov_platf_loan_flg              --政府融资平台贷款标志
      ,acct_categ_cd                   --会计类别代码
      ,loan_flg                        --贷款标志
      ,acpt_flg                        --承兑标志
      ,bout_liqdt_flg                  --买断清收标志
      ,comm_invo_num                   --商业发票号码
      ,comm_inv_ccy_cd                 --商业发票币种代码
      ,comm_inv_amt                    --商业发票金额
      ,comm_inv_type_cd                --商业发票种类代码
      ,fft_type_cd                     --福费廷种类代码
      ,int_acct_id                     --利息科目编号
      ,write_off_flg                   --核销标志
      ,tran_flg                        --转让标志
      ,etl_task_name                   --ETL任务
      ,last_update_dt                  --最后更新时间
      ,job_cd                          --任务代码
      ,AGT_MODF                        --协议修饰符
      ,RELATIVE_DUEBILL_NO             --垫款借据原借据号
      ,etl_timestamp                   --ETL处理时间戳
)
select
       to_date('${batch_date}','yyyymmdd') as etl_dt                                       --数据日期
      ,t1.data_src_cd                                                                      --数据来源代码
      ,t1.del_flg                                                                          --删除标志
      ,t1.loan_acct_id                                                                     --贷款账户编号
      ,t1.blng_pty_id                                                                      --所属客户编号
      ,t1.acct_name                                                                        --账户名称
      ,t1.prd_id                                                                           --核算产品编号
      ,t1.open_dt                                                                          --开户日期
      ,t1.loan_issue_dt                                                                    --放款日期
      ,t1.int_dt                                                                           --起息日期
      ,t1.trmi_dt                                                                          --终止日期
      ,t1.due_dt                                                                           --到期日期
      ,t1.open_org_id                                                                      --开户机构编号
      ,t1.mgmt_org_id                                                                      --管理机构编号
      ,t1.accting_org_id                                                                   --账务机构编号
      ,t1.pty_mgr_id                                                                       --客户经理编号
      ,t1.agt_status_cd                                                                    --贷款账户状态代码
      ,t1.accting_coa_id                                                                   --会计科目编号
      ,t1.term_corp_cd                                                                     --期限单位代码
      ,t1.loan_term                                                                        --贷款期限
      ,t1.ccy_cd                                                                           --币种代码
      ,t1.issue_amt                                                                        --发放金额
      ,t1.rate_base_typ_cd                                                                 --利率基准类型代码
      ,t1.rate_base_val                                                                    --利率基准值
      ,t1.exec_rate                                                                        --正常执行利率
      ,t1.ovdue_exec_rate                                                                  --逾期执行利率
      ,t1.float_rate_flg                                                                   --浮动利率标志
      ,t1.rate_float_mode_cd                                                               --利率浮动方式代码
      ,t1.float_freq_cd                                                                    --浮动频率代码
      ,t1.rate_float_val                                                                   --正常利率浮动值
      ,t1.ovdue_rate_float                                                                 --逾期利率浮动值
      ,t1.curr_rate_eff_day                                                                --当前利率生效日
      ,t1.next_rate_adj_day                                                                --下一利率调整日
      ,t1.loan_base_mon_day_qty                                                            --贷款基准月天数
      ,t1.loan_base_year_day_qty                                                           --贷款基准年天数
      ,t1.loan_compd_int_flg                                                               --贷款复利标志
      ,t1.loan_stl_mode_cd                                                                 --贷款结息方式代码
      ,t1.loan_int_mode_cd                                                                 --贷款计息方式代码
      ,t1.loan_calc_forml                                                                  --贷款计算公式
      ,t1.dd_acct_id                                                                       --放款账户编号
      ,t1.repay_mode_cd                                                                    --还款方式代码
      ,t1.repay_freq_cd                                                                    --还款频率代码
      ,t1.repay_acct_id                                                                    --还款账户编号
      ,t1.assoc_loan_contr_id                                                              --贷款合同编号
      ,t1.bil_acct_id                                                                      --记账分户账编号
      ,t1.assoc_bil_id                                                                     --关联票证编号
      ,t1.loan_assoc_marg_acct                                                             --贷款关联保证金账号
      ,t1.margin_ccy_cd                                                                    --保证金币种代码
      ,t1.margin_amt                                                                       --保证金金额
      ,t1.marg_ratio                                                                       --保证金比例
      ,t1.blng_biz_line_cd                                                                 --所属业务条线代码
      ,t1.loan_biz_type_cd                                                                 --贷款业务品种代码
      ,t1.sub_guar_mode_cd                                                                 --子担保方式代码
      ,t1.loan_cate_cd                                                                     --贷款类型代码
      ,t1.gov_platf_loan_flg                                                               --政府融资平台贷款标志
      ,t1.acct_categ_cd                                                                    --会计类别代码
      ,t1.loan_flg                                                                         --贷款标志
      ,t1.acpt_flg                                                                         --承兑标志
      ,t1.bout_liqdt_flg                                                                   --买断清收标志
      ,t1.comm_invo_num                                                                    --商业发票号码
      ,t1.comm_inv_ccy_cd                                                                  --商业发票币种代码
      ,t1.comm_inv_amt                                                                     --商业发票金额
      ,t1.comm_inv_type_cd                                                                 --商业发票种类代码
      ,t1.fft_type_cd                                                                      --福费廷种类代码
      ,t1.int_acct_id                                                                      --利息科目编号
      ,t1.write_off_flg                                                                    --核销标志
      ,t1.tran_flg                                                                         --转让标志
      ,t1.etl_task_name                                                                    --ETL任务
      ,t1.last_update_dt                                                                   --最后更新时间
      ,t1.job_cd                                                                           --任务代码
      ,t1.AGT_MODF                                                                         --协议修饰符
      ,t1.RELATIVE_DUEBILL_NO                                                              --垫款借据原借据号
      ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp    --ETL处理时间戳
from ${idl_schema}.hdws_iml_agt_ln_ac_base_info t1    --贷款账户基本信息
where etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd in ('CRSS','CBSS');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'scfs_hdws_iml_agt_ln_ac_base_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);