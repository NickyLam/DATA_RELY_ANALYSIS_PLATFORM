/*
purpose:    应用集市层-贷款综合授信信息：包括我行的所有贷款授信信息,数据来源包含好贷系统、好易贷系统、综合信贷系统。。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd idl_dmm_loan_syn_crdt_info
createdate: 20200326
logs:       20250513 陈伟峰 新增模型
            20250526 陈伟峰 新增字段【担保贷标志】、【产品类型】
            20250819 陈伟峰 调整综合信贷一组逻辑，过滤华兴好易贷&好企贷
            20251107 陈伟峰 新增字段【子产品名称】
            20260227 陈伟峰 调整易贷部分字段【授信额度】加工逻辑，取AP_APPLY.APPR_FINAL_AMT
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${idl_schema}.dmm_loan_syn_crdt_info drop partition p_${retain_day};
alter table ${idl_schema}.dmm_loan_syn_crdt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create temp table
--drop table ${idl_schema}.tmp_dmm_loan_syn_crdt_info_01 purge;

-- 2.1 create temporary table dmm_loan_syn_crdt_info_ex
whenever sqlerror continue none ;
drop table ${idl_schema}.dmm_loan_syn_crdt_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_loan_syn_crdt_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${idl_schema}.dmm_loan_syn_crdt_info where 0=1;

-- 2.2 insert into data to temporary table dmm_loan_syn_crdt_info_ex
--第一组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dmm_loan_syn_crdt_info_ex(
     etl_dt                                    --数据日期
     ,lp_id                                    --法人编号
     ,sys_src_idf                              --系统来源标识
     ,crdt_id                                  --授信编号
     ,cust_id                                  --客户编号
     ,cust_name                                --客户名称
     ,lmt_bus_flg                              --额度业务标志
     ,loan_distr_type_cd                       --贷款发放类型代码
     ,happ_dt                                  --发生日期
     ,lmt_bus_curr_cd                          --额度业务币种代码
     ,crdt_lmt                                 --授信额度
     ,prod_id                                  --产品编号
     ,sub_prod_name                            --子产品名称
     ,tenor_mon                                --期限(月)
     ,lmt_bus_begin_day                        --额度业务起始日
     ,lmt_bus_exp_day                          --额度业务到期日
     ,is_circl_lmt                             --是否循环(额度)
     ,risk_type_lmt                            --风险类型(额度)
     ,loan_dir_indus                           --贷款投向行业
     ,usage                                   --用途
     ,main_guar_way                            --主担保方式
     ,apv_status                               --审批状态
     ,oper_org                                 --经办机构
     ,oper_dt                                  --经办日期
     ,rgstrat                                  --登记人
     ,rgst_org                                 --登记机构
     ,rgst_dt                                  --登记日期
     ,updater                                  --更新人
     ,update_org                               --更新机构
     ,update_dt                                --更新日期
     ,belong_strip_line                        --所属条线
     ,loan_usage                               --贷款用途
     ,lmt_open_amt                             --额度敞口金额
     ,guar_lon_flg                             --担保贷标志
     ,prod_type                                --产品类型
     ,job_cd                                   --任务代码
     ,etl_timestamp                            --数据处理时间
  )
select
       to_date('${batch_date}','yyyymmdd')                               --数据日期
       ,'9999'                                                             --法人编号
       ,'ICMS1'                                                            --系统来源标识
       ,t1.serialno                                                        --授信编号
       ,t1.customerid                                                      --客户编号
       ,t1.customername                                                    --客户名称
       ,t1.businessflag                                                    --额度业务标志
       ,t1.occurtype                                                       --贷款发放类型代码
       ,t1.occurdate                                                       --发生日期
       ,t1.currency                                                        --额度业务币种代码
       ,t1.businesssum                                                     --授信额度
       ,t1.productid                                                       --产品编号
       ,t1.subproductname                                                  --子产品名称
       ,t1.termmonth                                                       --期限(月)
       ,t1.startdate                                                       --额度业务起始日
       ,t1.maturity                                                        --额度业务到期日
       ,t1.iscycle                                                         --是否循环(额度)
       ,t1.risktype                                                        --风险类型(额度)
       ,t1.nationalindustrytype                                            --贷款投向行业
       ,t1.purpose                                                         --用途
       ,t1.vouchtype                                                       --主担保方式
       ,t1.approvestatus                                                   --审批状态
       ,t1.operateorgid                                                    --经办机构
       ,t1.operatedate                                                     --经办日期
       ,t1.inputuserid                                                     --登记人
       ,t1.inputorgid                                                      --登记机构
       ,t1.inputdate                                                       --登记日期
       ,t1.updateuserid                                                    --更新人
       ,t1.updateorgid                                                     --更新机构
       ,t1.updatedate                                                      --更新日期
       ,t1.belongdept                                                      --所属条线
       ,t1.loanusetype                                                     --贷款用途
       ,t1.totalsum                                                        --额度敞口金额
       ,nvl(trim(t3.ishxdanbaoloan),'-')                                 --担保贷标志
       ,''                                                                 --产品类型
       ,'icmsf1'                                                           --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
from ${iol_schema}.icms_business_apply t1
inner join ${iol_schema}.icms_customer_info t2
on t1.customerid=t2.customerid
and t2.customertype  in（'1' ,'2')
and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.icms_ba_cl_info t3
on t1.serialno = t3.serialno
and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
where  t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
and not exists (select 1 from ${iol_schema}.icms_hqd_ipc_legalperson_app t   --好企贷IPC法人版
                 where t.baserialno=t1.serialno 
               )
and t1.productid not in ('201010300035','201010300040','201020100059','201020100060','201020100054') 
;
commit;

-- 2.2 insert into data to temporary table dmm_loan_syn_crdt_info_ex
--第二组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dmm_loan_syn_crdt_info_ex(
     etl_dt                                   --数据日期
     ,lp_id                                   --法人编号
     ,sys_src_idf                             --系统来源标识
     ,crdt_id                                 --授信编号
     ,cust_id                                 --客户编号
     ,cust_name                               --客户名称
     ,lmt_bus_flg                             --额度业务标志
     ,loan_distr_type_cd                      --贷款发放类型代码
     ,happ_dt                                 --发生日期
     ,lmt_bus_curr_cd                         --额度业务币种代码
     ,crdt_lmt                                --授信额度
     ,prod_id                                 --产品编号
     ,sub_prod_name                           --子产品名称
     ,tenor_mon                               --期限(月)
     ,lmt_bus_begin_day                       --额度业务起始日
     ,lmt_bus_exp_day                         --额度业务到期日
     ,is_circl_lmt                            --是否循环(额度)
     ,risk_type_lmt                           --风险类型(额度)
     ,loan_dir_indus                          --贷款投向行业
     ,usage                                  --用途
     ,main_guar_way                           --主担保方式
     ,apv_status                              --审批状态
     ,oper_org                                --经办机构
     ,oper_dt                                 --经办日期
     ,rgstrat                                 --登记人
     ,rgst_org                                --登记机构
     ,rgst_dt                                 --登记日期
     ,updater                                 --更新人
     ,update_org                              --更新机构
     ,update_dt                               --更新日期
     ,belong_strip_line                       --所属条线
     ,loan_usage                              --贷款用途
     ,lmt_open_amt                            --额度敞口金额
     ,guar_lon_flg                            --担保贷标志
     ,prod_type                               --产品类型
     ,job_cd                                  --任务代码
     ,etl_timestamp                           --数据处理时间
  )
select
       to_date('${batch_date}','yyyymmdd')                                              --数据日期
       ,'9999'                                                                            --法人编号
       ,'PCLS'                                                                            --系统来源标识
       ,t1.appl_no                                                                        --授信编号
       ,t1.user_no                                                                        --客户编号
       ,nvl(t2.customername,t1.cust_name_encryptx)                                       --客户名称
       ,''                                                                                --额度业务标志
       ,''                                                                                --贷款发放类型代
       ,t1.date_finished                                                                  --发生日期
       ,''                                                                                --额度业务币种代
       ,t1.appr_final_amt                                                                 --授信额度
       ,decode(t1.product_code,'YXYD40','201010300040','HXZYJLRD','201010300035',t1.product_code)  --产品编号
       ,''                                                                                --子产品名称
       , ''                                                                               --期限(月)
       ,''                                                                                --额度业务起始日
       , ''                                                                               --额度业务到期日
       ,''                                                                                --是否循环(额度)
       ,''                                                                                --风险类型(额度)
       ,''                                                                                --贷款投向行业
       ,t1.purpose_no                                                                     --用途
       , ''                                                                               --主担保方式
       ,decode(t1.state,'APS','Accept','ARJ','Refused','APR','Approving','APM','ZrgApproving',t1.state)           --审批状态
       ,t1.org_no                                                                         --经办机构
       ,t1.date_finished                                                                  --经办日期
       ,t1.created_by                                                                     --登记人
       ,t1.org_no                                                                         --登记机构
       ,t1.date_created                                                                   --登记日期
       ,t1.updated_by                                                                     --更新人
       ,''                                                                                --更新机构
       ,t1.date_updated                                                                   --更新日期
       ,''                                                                                --所属条线
       ,''                                                                                --贷款用途
       ,''                                                                                --额度敞口金额
       ,'-'                                                                               --担保贷标志
       ,''                                                                                --产品类型
       ,'pclsf1'                                                                          --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                   --数据处理时间
from ${iol_schema}.pcls_ap_apply t1
left join ${iol_schema}.icms_customer_info t2
on t1.user_no=t2.customerid
and t2.customertype  in（'1' ,'2')
and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.2 insert into data to temporary table dmm_loan_syn_crdt_info_ex
--第三组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dmm_loan_syn_crdt_info_ex(
     etl_dt                                --数据日期
     ,lp_id                                --法人编号
     ,sys_src_idf                          --系统来源标识
     ,crdt_id                              --授信编号
     ,cust_id                              --客户编号
     ,cust_name                            --客户名称
     ,lmt_bus_flg                          --额度业务标志
     ,loan_distr_type_cd                   --贷款发放类型代码
     ,happ_dt                              --发生日期
     ,lmt_bus_curr_cd                      --额度业务币种代码
     ,crdt_lmt                             --授信额度
     ,prod_id                              --产品编号
     ,sub_prod_name                        --子产品名称
     ,tenor_mon                            --期限(月)
     ,lmt_bus_begin_day                    --额度业务起始日
     ,lmt_bus_exp_day                      --额度业务到期日
     ,is_circl_lmt                         --是否循环(额度)
     ,risk_type_lmt                        --风险类型(额度)
     ,loan_dir_indus                       --贷款投向行业
     ,usage                               --用途
     ,main_guar_way                        --主担保方式
     ,apv_status                           --审批状态
     ,oper_org                             --经办机构
     ,oper_dt                              --经办日期
     ,rgstrat                              --登记人
     ,rgst_org                             --登记机构
     ,rgst_dt                              --登记日期
     ,updater                              --更新人
     ,update_org                           --更新机构
     ,update_dt                            --更新日期
     ,belong_strip_line                    --所属条线
     ,loan_usage                           --贷款用途
     ,lmt_open_amt                         --额度敞口金额
     ,guar_lon_flg                         --担保贷标志
     ,prod_type                            --产品类型
     ,job_cd                               --任务代码
     ,etl_timestamp                        --数据处理时间
  )
select
       to_date('${batch_date}','yyyymmdd')                               --数据日期
       ,'9999'                                                             --法人编号
       ,'HGLS'                                                             --系统来源标识
       ,t1.req_id                                                          --授信编号
       ,t1.biz_cust_no                                                     --客户编号
       ,t1.cust_name                                                       --客户名称
       , ''                                                                --额度业务标志
       ,t1.loan_apply_type                                                 --贷款发放类型代码
       ,t1.req_date                                                        --发生日期
       ,'CNY'                                                              --额度业务币种代码
       ,t1.comprehensive_money                                             --授信额度
       ,t4.prd_num                                                         --产品编号
       ,''                                                                 --子产品名称
       , ''                                                                --期限(月)
       ,''--t2.credit_beg_date                                             --额度业务起始日
       ,''--t2.credit_end_date                                             --额度业务到期日
       ,t1.is_revolving_loan                                               --是否循环(额度)
       ,''  --t3.type                                                      --风险类型(额度)
       ,''                                                                 --贷款投向行业
       ,t1.loan_use_other                                                  --用途
       , ''                                                                --主担保方式
       ,t1.audit_status                                                    --审批状态
       ,t5.org_num                                                         --经办机构
       ,t1.audit_date                                                      --经办日期
       ,t1.transator_id                                                    --登记人
       ,t5.org_num                                                         --登记机构
       ,t1.req_date                                                        --登记日期
       ,t1.change_product_user_id                                          --更新人
       ,''                                                                 --更新机构
       ,t1.update_date                                                     --更新日期
       , ''                                                                --所属条线
       ,t1.loan_use                                                        --贷款用途
       ,t1.comprehensive_money                                             --额度敞口金额
       ,'-'                                                                --担保贷标志
       ,t1.prd_type                                                        --产品类型
       ,'hglsf1'                                                           --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
from ${iol_schema}.hgls_loan_req t1
/*left join ${iol_schema}.hgls_loan_borrow_info t2  --loan_id ='6000440'
on t1.req_id=t2.loan_id
and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
and t2.isdel = 0
/* left join ${iol_schema}.hgls_model_micro_risk_info t3  --loan_id ='6000440'
on t1.req_id=t3.loan_id
and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t3.end_dt > to_date('${batch_date}', 'yyyymmdd') */
left join ${iol_schema}.hgls_product_info t4
on t1.prod_code=t4.code
and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
and t4.isdel = 0
left join ${iol_schema}.hgls_loan_branch_website t5
on t1.home_branch=t5.code
and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
and t5.isdel = 0
inner join ${iol_schema}.icms_customer_info t6
on t1.biz_cust_no=t6.customerid
and t6.customertype  in（'1' ,'2')
and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
where  t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.2 insert into data to temporary table dmm_loan_syn_crdt_info_ex
--第四组（共四组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.dmm_loan_syn_crdt_info_ex(
     etl_dt                                 --数据日期
     ,lp_id                                 --法人编号
     ,sys_src_idf                           --系统来源标识
     ,crdt_id                               --授信编号
     ,cust_id                               --客户编号
     ,cust_name                             --客户名称
     ,lmt_bus_flg                           --额度业务标志
     ,loan_distr_type_cd                    --贷款发放类型代码
     ,happ_dt                               --发生日期
     ,lmt_bus_curr_cd                       --额度业务币种代码
     ,crdt_lmt                              --授信额度
     ,prod_id                               --产品编号
     ,sub_prod_name                         --子产品名称
     ,tenor_mon                             --期限(月)
     ,lmt_bus_begin_day                     --额度业务起始日
     ,lmt_bus_exp_day                       --额度业务到期日
     ,is_circl_lmt                          --是否循环(额度)
     ,risk_type_lmt                         --风险类型(额度)
     ,loan_dir_indus                        --贷款投向行业
     ,usage                                --用途
     ,main_guar_way                         --主担保方式
     ,apv_status                            --审批状态
     ,oper_org                              --经办机构
     ,oper_dt                               --经办日期
     ,rgstrat                               --登记人
     ,rgst_org                              --登记机构
     ,rgst_dt                               --登记日期
     ,updater                               --更新人
     ,update_org                            --更新机构
     ,update_dt                             --更新日期
     ,belong_strip_line                     --所属条线
     ,loan_usage                            --贷款用途
     ,lmt_open_amt                          --额度敞口金额
     ,guar_lon_flg                          --担保贷标志
     ,prod_type                             --产品类型
     ,job_cd                                --任务代码
     ,etl_timestamp                         --数据处理时间
  )
select
       to_date('${batch_date}','yyyymmdd')                             --数据日期
       ,'9999'                                                           --法人编号
       ,'ICMS2'                                                          --系统来源标识
       ,t1.serialno                                                      --授信编号
       ,t1.customerid                                                    --客户编号
       ,t1.customername                                                  --客户名称
       ,''                                                               --额度业务标志
       ,t1.loantype                                                      --贷款发放类型代码
       ,t1.occurdate                                                     --发生日期
       , 'CNY'                                                           --额度业务币种代码
       ,t1.loanapplamt                                                   --授信额度
       ,t1.productid                                                     --产品编号
       ,''                                                               --子产品名称
       ,t1.loanapplyterm                                                 --期限(月)
       ,t1.authostrdate                                                  --额度业务起始日
       ,t1.authoenddate                                                  --额度业务到期日
       , ''                                                              --是否循环(额度)
       ,t1.creditscorelevel                                              --风险类型(额度)
       ,''                                                               --贷款投向行业
       ,''                                                               --用途
       , ''                                                              --主担保方式
       ,t1.approvestatus                                                 --审批状态
       ,t1.inputorgid                                                    --经办机构
       ,t1.inputdate                                                     --经办日期
       ,t1.inputuserid                                                   --登记人
       ,t1.inputorgid                                                    --登记机构
       ,t1.inputdate                                                     --登记日期
       ,t1.updateuserid                                                  --更新人
       ,t1.updateorgid                                                   --更新机构
       , ''                                                              --更新日期
       ,''                                                               --所属条线
       ,''                                                               --贷款用途
       ,''                                                               --额度敞口金额
       ,'-'                                                              --担保贷标志
       ,''                                                               --产品类型
       ,'icmsf1'                                                         --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
from ${iol_schema}.icms_one_click_input t1
inner join ${iol_schema}.icms_customer_info t2
on t1.customerid=t2.customerid
and t2.customertype  in（'1' ,'2')
and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where trim(t1.baserialno) is null    --只取失败的，成功的在第一组综合信贷中已经有数据
and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${idl_schema}.dmm_loan_syn_crdt_info exchange partition p_${batch_date} with table ${idl_schema}.dmm_loan_syn_crdt_info_ex;

-- 3.1 drop ex table
drop table ${idl_schema}.dmm_loan_syn_crdt_info_ex purge;

-- 3.2 drop temp table

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'dmm_loan_syn_crdt_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);