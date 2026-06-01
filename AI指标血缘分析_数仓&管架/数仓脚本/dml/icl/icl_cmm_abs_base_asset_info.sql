/*
Purpose:    共性加工层-资产证券化基础资产信息：包括我行资产证券化业务基础资产信息，数据来源于资产证券化系统ABSS。
可通过合同编号关联资产证券化转让合同信息，借据编号关联对公借据、零售借据信息。
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_abs_base_asset_info
Createdate: 20191025
Logs:       20220405 陈伟峰 新增模型
            20220607 李森辉 修改取数来源
            20221229 温旺清 新增字段【客户编号】
*/


set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_abs_base_asset_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_abs_base_asset_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_abs_base_asset_info_ex purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_abs_base_asset_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_abs_base_asset_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_abs_base_asset_info_ex(
    etl_dt                                       --数据日期
    ,lp_id                                       --法人编号
    ,base_asset_id                               --基础资产编号
    ,cust_id                                     --客户编号
    ,dubil_id                                    --借据编号
    ,cont_id                                     --合同编号
    ,loan_cont_id                                --贷款合同编号
    ,asset_pool_id                               --资产池编号
    ,curr_cd                                     --币种代码
    ,loan_amt                                    --贷款金额
    ,bad_debt_amt                                --坏账金额
    ,ovdue_amt                                   --逾期金额
    ,loan_bal                                    --贷款余额
    ,idle_amt                                    --呆滞金额
    ,rpbl_int                                    --应还利息
    ,asset_status_cd                             --资产状态代码
    ,tran_cosdetn                                --转让对价
    ,pkg_belong_hxb_int                          --封包时归属我行利息
    ,pkg_pric_bal                                --封包时本金余额
    ,pkg_asset_bal                               --封包时资产余额
    ,pkg_belong_hxb_int_rat                      --封包时归属我行利率
    ,redem_belong_hxb_int                        --赎回时归属我行利息
    ,redem_belong_trust_int                      --赎回时归属信托利息
    ,redem_cosdetn                               --赎回对价
    ,redem_belong_trust_pric                     --赎回时归属信托本金
    ,redem_cosdetn_pric                          --赎回对价本金
    ,redem_cosdetn_int                           --赎回对价利息
    ,pkg_bf_int_recvbl_bal                       --封包前应收利息余额
    ,pkg_post_int_recvbl_tot                     --封包后应收利息总额
    ,pkg_post_int_recvbl_bal                     --封包后应收利息余额
    ,rtn_pkg_post_int_recvbl                     --已归还封包后应收利息
    ,tran_loan_int_tot                           --转让贷款利息总额
    ,recvbl_acct_id                              --收款账户编号
    ,recvbl_acct_name                            --收款账户名称
    ,recvbl_acct_belong_org_id                   --收款账户所属机构编号
--    ,cntpty_id                                   --交易对手编号
--    ,cntpty_name                                 --交易对手名称
--    ,cntpty_acct_num                             --交易对手账号
--    ,cntpty_open_bank_name                       --交易对手开户行名称
    ,job_cd
    ,etl_timestamp                               --etl处理时间戳
)
select
     to_date('${batch_date}','yyyymmdd')         --数据日期             
    ,t1.lp_id                                    --法人编号             
    ,t1.base_asset_id                            --基础资产编号 
    ,t1.cust_id                                  --客户编号 	
    ,t1.dubil_id                                 --借据编号             
    ,t3.tran_contr_id                            --合同编号             
    ,t1.loan_cont_id                             --贷款合同编号           
    ,t2.asset_pool_id                            --资产池编号            
    ,t1.curr_cd                                  --币种代码             
    ,t1.loan_amt                                 --贷款金额             
    ,t1.bad_debt_amt                             --坏账金额             
    ,t1.ovdue_amt                                --逾期金额             
    ,t1.loan_bal                                 --贷款余额             
    ,t1.idle_amt                                 --呆滞金额             
    ,t1.rpbl_int                                 --应还利息
    ,t1.asset_status_cd                          --资产状态代码           
    ,t1.tran_cosdetn                             --转让对价             
    ,t1.pkg_belong_hxb_int                       --封包时归属我行利息     
    ,t1.pkg_pric_bal                             --封包时本金余额         
    ,t1.pkg_asset_bal                            --封包时资产余额         
    ,t1.pkg_belong_hxb_int_rat                   --封包时归属我行利率     
    ,t1.redem_belong_hxb_int                     --赎回时归属我行利息     
    ,t1.redem_belong_trust_int                   --赎回时归属信托利息     
    ,t1.redem_cosdetn                            --赎回对价             
    ,t1.redem_belong_trust_pric                  --赎回时归属信托本金     
    ,t1.redem_cosdetn_pric                       --赎回对价本金           
    ,t1.redem_cosdetn_int                        --赎回对价利息           
    ,t1.bf_pkg_int_recvbl_bal                    --封包前应收利息余额     
    ,t1.after_pkg_int_recvbl_tot                 --封包后应收利息总额     
    ,t1.after_pkg_int_recvbl_bal                 --封包后应收利息余额     
    ,t1.after_rtn_pkg_int_recvbl                 --已归还封包后应收利息   
    ,t1.tran_loan_int_tot                        --转让贷款利息总额       
    ,t4.recvbl_acct_id                           --收款账户编号           
    ,t4.recvbl_acct_name                         --收款账户名称           
    ,t4.coll_acct_belong_org_id                  --收款账户所属机构编号   
--    ,t6.prtcptr_id                               --交易对手编号           
--    ,t6.prtcptr_name                             --交易对手名称           
--    ,t5.acct_id                                  --交易对手账号           
--    ,t5.acct_open_bank_name                      --交易对手开户行名称
    ,t1.job_cd                              
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_secu_base_asset_h t1	
  left join ${iml_schema}.agt_asset_pool_base_rela_h t2	
    on t1.base_asset_id=t2.base_asset_id
   and t2.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd='abssf1'
   and t2.obj_type = 'jbo.abs.ABS_ASSET_INFO'
   and trim(t2.parent_asset_pool_id) is null
  left join ${iml_schema}.prd_abs_prod_info_h t3	
    on t2.asset_pool_id=t3.asset_pool_id
   and t3.prod_status_cd not in('01','11','31','51')
   and t3.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd='abssf1'
  left join ${iml_schema}.agt_asset_pool_info_h t4	
    on t2.asset_pool_id=t4.asset_pool_id
   and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd='abssf1'
  /* left join ${iml_schema}.prd_acct_rela_h t5	
    on t3.abs_prod_id = t5.prod_id 
   and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd='abssf1'
  left join ${iml_schema}.pty_abs_prtcptr_info_h t6 	
    on t5.acct_owner_id = t6.party_id 
   and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd='abssf1' */
 where t1.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt >to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd='abssf1'
   and t1.asset_status_cd not in('00','10')
   and trim(t1.src_cust_id) is not null;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_abs_base_asset_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_abs_base_asset_info_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_abs_base_asset_info_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_abs_base_asset_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
