/*
Purpose:    共性加工层-商业汇票承兑信息表，包括我行开立及承兑的汇票业务信息，数据来源于票据系统的票据模块
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bill_acpt_info
Createdate: 20191025
Logs:       20201106 周沁晖 调整t3表,ref_bill_info_para ----> agt_bill_info
            20220905 温旺清 新增字段【票据编号】
            20230104 温旺清 1、修改【job_cd】取数逻辑
                            2、修改第二组结清标志的取数逻辑
                            3、修改第一组主表的过滤条件 t1.h_data_flg = 'system' -> t1.h_data_flg <> 'system_ht'
            20230821 徐子豪 新增字段【承兑状态代码】
            20241012 陈伟峰 新增字段【敞口类型代码、敞口金额】
            20241012 谢  宁 新增字段【承兑协议批次编号】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bill_acpt_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bill_acpt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bill_acpt_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bill_acpt_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_bill_acpt_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_acpt_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bus_id                                --业务编号
    ,batch_id                              --批次编号
    ,acpt_agt_batch_id                     --承兑协议批次编号
    ,bill_entry_id                         --票据记账编号
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,cust_id                               --客户编号
    ,bill_med_cd                           --票据介质代码
    ,bill_kind_cd                          --票据类型代码
    ,appl_dt                               --申请日期
    ,recv_dt                               --签收日期
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,dir_indus_name                        --投向行业名称
    ,main_guar_way_cd                      --主担保方式代码
    ,drawer_name                           --出票人名称
    ,drawer_cate_cd                        --出票人类别代码
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,recver_cust_id                        --收款人客户编号
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,repay_num                             --还款账号
    ,entry_dt                              --记账日期
    ,revo_dt                               --撤销日期
    ,bus_flow_num                          --业务流水号
    ,margin_ratio                          --保证金比例
    ,comm_fee_ratio                        --手续费比例
    ,entry_status_cd                       --记账状态代码
    ,draw_status_cd                        --出票状态代码
    ,bill_acpt_status_cd                   --承兑状态代码
    ,tranbl_flg                            --可转让标志
    ,uncond_pay_flg                        --无条件支付标志
    ,curr_cd                               --币种代码
    ,open_type_cd                          --敞口类型代码
    ,open_amt                              --敞口金额
    ,fac_val_amt                           --票面金额
    ,payoff_flg                            --结清标志
    ,lmt_ocup_amt                          --额度占用金额
    ,lmt_ocup_status_cd                    --额度占用状态代码
    ,comm_fee                              --手续费
    ,todos                                 --工本费
    ,acpt_fee                              --承兑费
    ,mgmt_fee                              --管理费
    ,accptor_crdt_level_cd                 --承兑人信用等级代码
    ,accptor_rating_exp_dt                 --承兑人评级到期日期
    ,issue_org_id                          --签发机构编号
    ,enter_acct_org_id                     --入账机构编号
    ,cust_mgr_id                           --客户经理编号
    ,dept_id                               --部门编号
    ,operr_id                              --操作员编号
    ,group_open_flg                        --集团代开标志
    ,group_name                            --集团名称
    ,group_id                              --集团编号
    ,group_open_drawer_name                --集团代开出票人名称
    ,group_open_drawer_cust_no             --集团代开出票人客户号
    ,rela_party_que_rest_cd                --关联方查询结果代码
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')       as etl_dt                   --数据日期
   ,t1.lp_id                                  as lp_id                    --法人编号
   ,t1.acpt_dtl_id                            as bus_id                   --业务编号
   ,t1.batch_id                               as batch_id                 --批次编号
   ,t2.acpt_batch_id                          as acpt_agt_batch_id        --承兑协议批次编号
   ,t1.crdt_out_acct_flow_num                 as bill_entry_id            --票据记账编号
   ,t1.bill_id                                as bill_id                  --票据编号
   ,t3.bill_num                               as bill_num                 --票据号码
   ,t1.bill_pkg_intrv_id                      as bill_sub_intrv_id        --子票据区间号码
   ,t2.drawer_cust_id                         as cust_id                  --客户编号
   ,t2.bill_med_cd                            as bill_med_cd              --票据介质代码
   ,t2.bill_type_cd                           as bill_kind_cd             --票据类型代码
   ,t2.appl_draw_dt                           as appl_dt                  --申请日期
   ,t1.recv_dt                                as recv_dt                  --签收日期
   ,t3.draw_dt                                as draw_dt                  --出票日期
   ,t3.fac_val_exp_dt                         as exp_dt                   --到期日期
   ,t2.actl_dir_indus_name                    as dir_indus_name           --投向行业名称
   ,''                                        as main_guar_way_cd         --主担保方式代码
   ,t3.drawer_name                            as drawer_name              --出票人名称
   ,t3.drawer_cate_cd                         as drawer_cate_cd           --出票人类别代码
   ,t2.drawer_acct_num                        as drawer_acct_num          --出票人账号
   ,t3.drawer_open_bank_num                   as drawer_open_bank_no      --出票人开户行行号
   ,t2.drawer_bank_name                       as drawer_open_bank_name    --出票人开户行名称
   ,t3.accptor_name                           as accptor_name             --承兑人名称
   ,t3.accptor_acct_num                       as accptor_acct_num         --承兑人账号
   ,t3.accptor_open_bank_num                  as accptor_open_bank_no     --承兑人开户行行号
   ,t3.accptor_open_bank_name                 as accptor_open_bank_name   --承兑人开户行名称
   ,''                                        as recver_cust_id           --收款人客户编号  源表BDMS_DRAFT_INFO中PAYEE_ID无数据，未入模型
   ,t3.recver_name                            as recver_name              --收款人名称
   ,t3.recver_acct_num                        as recver_acct_num          --收款人账号
   ,t3.recver_open_bank_num                   as recver_open_bank_no      --收款人开户行行号
   ,t3.recver_open_bank_name                  as recver_open_bank_name    --收款人开户行名称
   ,t2.fst_repay_acct_id                      as repay_num                --还款账号
   ,t1.entry_dt                               as entry_dt                 --记账日期
   ,t1.revo_dt                                as revo_dt                  --撤销日期
   ,''                                        as bus_flow_num             --业务流水号
   ,t2.margin_ratio                           as margin_ratio             --保证金比例
   ,t2.comm_fee_ratio                         as comm_fee_ratio           --手续费比例
   ,t1.entry_status_cd                        as entry_status_cd          --记账状态代码
   ,t1.draw_status_cd                         as draw_status_cd           --出票状态代码
   ,t1.bill_acpt_proc_status_cd               as bill_acpt_status_cd      --承兑状态代码
   ,decode(t3.pbc_tranbl_flg,'EM00','1','0')  as tranbl_flg               --可转让标志
   ,t1.exp_uncond_pay_entr_cd                 as uncond_pay_flg           --无条件支付标志
   ,'CNY'                                     as curr_cd                  --币种代码
   ,t2.open_type_cd                           as open_type_cd             --敞口类型代码
   ,nvl(t2.open_amt,0)                        as open_amt                 --敞口金额
   ,t3.bill_amt                               as fac_val_amt              --票面金额
   ,t1.payoff_flg                             as payoff_flg               --结清标志
   ,t1.lmt_deduct_amt                         as lmt_ocup_amt             --额度占用金额
   ,''                                        as lmt_ocup_status_cd       --额度占用状态代码
   ,t1.comm_fee                               as comm_fee                 --手续费
   ,t1.todos                                  as todos                    --工本费
   ,t2.acpt_fee                               as acpt_fee                 --承兑费
   ,t2.mgmt_fee                               as mgmt_fee                 --管理费
   ,''                                        as accptor_crdt_level_cd    --承兑人信用等级代码(我行信用等级)
   ,''                                        as accptor_rating_exp_dt    --承兑人评级到期日期(我行评级到期日期)
   ,t2.org_id                                 as issue_org_id             --签发机构编号
   ,t2.enter_acct_org_id                      as enter_acct_org_id        --入账机构编号
   ,t2.cust_mgr_id                            as cust_mgr_id              --客户经理编号
   ,t2.dept_id                                as dept_id                  --部门编号
   ,t2.operr_id                               as operr_id                 --操作员编号
   ,''                                        as group_open_flg           --集团代开标志
   ,''                                        as group_name               --集团名称
   ,''                                        as group_id                 --集团编号
   ,''                                        as group_open_drawer_name   --集团代开出票人名称
   ,''                                        as group_open_drawer_cust_no--集团代开出票人客户号
   ,t2.rela_party_que_rest_cd                 as rela_party_que_rest_cd   --关联方查询结果代码
   ,t1.job_cd  as job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')       --数据处理时间
  from ${iml_schema}.agt_bill_acpt_dtl t1 --票据承兑明细
  left join ${iml_schema}.agt_bill_acpt_batch t2 --票据承兑批次
    on t1.batch_id = t2.batch_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_bill_info t3 --票据ECDS交易信息
    on t1.bill_id = t3.bill_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'bdmsf1'
   and t3.id_mark <> 'D'
  /*left join ${iml_schema}.pty_cust t4--客户
    on t2.drawer_cust_id = t4.cust_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'bdmsf1'
   and t4.id_mark <> 'D'*/
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   and t1.src_table_name = 'bdms_bms_accept_details'
   and t1.h_data_flg <> 'system_ht'
;
commit;

insert /*+ append */ into ${icl_schema}.cmm_bill_acpt_info_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,bus_id                                --业务编号
    ,batch_id                              --批次编号
    ,acpt_agt_batch_id                     --承兑协议批次编号
    ,bill_entry_id                         --票据记账编号 
    ,bill_id                               --票据编号
    ,bill_num                              --票据号码
    ,bill_sub_intrv_id                     --子票据区间号码
    ,cust_id                               --客户编号
    ,bill_med_cd                           --票据介质代码
    ,bill_kind_cd                          --票据类型代码
    ,appl_dt                               --申请日期
    ,recv_dt                               --签收日期
    ,draw_dt                               --出票日期
    ,exp_dt                                --到期日期
    ,dir_indus_name                        --投向行业名称
    ,main_guar_way_cd                      --主担保方式代码
    ,drawer_name                           --出票人名称
    ,drawer_cate_cd                        --出票人类别代码
    ,drawer_acct_num                       --出票人账号
    ,drawer_open_bank_no                   --出票人开户行行号
    ,drawer_open_bank_name                 --出票人开户行名称
    ,accptor_name                          --承兑人名称
    ,accptor_acct_num                      --承兑人账号
    ,accptor_open_bank_no                  --承兑人开户行行号
    ,accptor_open_bank_name                --承兑人开户行名称
    ,recver_cust_id                        --收款人客户编号
    ,recver_name                           --收款人名称
    ,recver_acct_num                       --收款人账号
    ,recver_open_bank_no                   --收款人开户行行号
    ,recver_open_bank_name                 --收款人开户行名称
    ,repay_num                             --还款账号
    ,entry_dt                              --记账日期
    ,revo_dt                               --撤销日期
    ,bus_flow_num                          --业务流水号
    ,margin_ratio                          --保证金比例
    ,comm_fee_ratio                        --手续费比例
    ,entry_status_cd                       --记账状态代码
    ,draw_status_cd                        --出票状态代码
    ,bill_acpt_status_cd                   --承兑状态代码
    ,tranbl_flg                            --可转让标志
    ,uncond_pay_flg                        --无条件支付标志
    ,curr_cd                               --币种代码
    ,open_type_cd                          --敞口类型代码
    ,open_amt                              --敞口金额
    ,fac_val_amt                           --票面金额
    ,payoff_flg                            --结清标志
    ,lmt_ocup_amt                          --额度占用金额
    ,lmt_ocup_status_cd                    --额度占用状态代码
    ,comm_fee                              --手续费
    ,todos                                 --工本费
    ,acpt_fee                              --承兑费
    ,mgmt_fee                              --管理费
    ,accptor_crdt_level_cd                 --承兑人信用等级代码
    ,accptor_rating_exp_dt                 --承兑人评级到期日期
    ,issue_org_id                          --签发机构编号
    ,enter_acct_org_id                     --入账机构编号
    ,cust_mgr_id                           --客户经理编号
    ,dept_id                               --部门编号
    ,operr_id                              --操作员编号
    ,group_open_flg                        --集团代开标志
    ,group_name                            --集团名称
    ,group_id                              --集团编号
    ,group_open_drawer_name                --集团代开出票人名称
    ,group_open_drawer_cust_no             --集团代开出票人客户号
    ,rela_party_que_rest_cd                --关联方查询结果代码
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')       as etl_dt                   --数据日期
   ,t1.lp_id                                  as lp_id                    --法人编号
   ,t1.acpt_dtl_id                            as bus_id                   --业务编号
   ,t1.batch_id                               as batch_id                 --批次编号
   ,t2.acpt_batch_id                          as acpt_agt_batch_id        --承兑协议批次编号
   ,t1.crdt_out_acct_flow_num                 as bill_entry_id            --票据记账编号
   ,t1.bill_id                                as bill_id                  --票据编号
   ,t3.bill_num                               as bill_num                 --票据号码
   ,t1.bill_pkg_intrv_id                      as bill_sub_intrv_id        --子票据区间号码
   ,t2.drawer_cust_id                         as cust_id                  --客户编号
   ,t2.bill_med_cd                            as bill_med_cd              --票据介质代码
   ,t2.bill_type_cd                           as bill_kind_cd             --票据类型代码
   ,t2.appl_draw_dt                           as appl_dt                  --申请日期
   ,t1.recv_dt                                as recv_dt                  --签收日期
   ,t3.draw_dt                                as draw_dt                  --出票日期
   ,t3.exp_dt                                 as exp_dt                   --到期日期
   ,t2.actl_dir_indus_name                    as dir_indus_name           --投向行业名称
   ,''                                        as main_guar_way_cd         --主担保方式代码
   ,t3.drawer_name                            as drawer_name              --出票人名称
   ,'RC01'                                    as drawer_cate_cd           --出票人类别代码*
   ,t2.drawer_acct_num                        as drawer_acct_num          --出票人账号
   ,t3.drawer_open_bank_no                    as drawer_open_bank_no      --出票人开户行行号
   ,t2.drawer_bank_name                       as drawer_open_bank_name    --出票人开户行名称
   ,t3.accptor_name                           as accptor_name             --承兑人名称
   ,t3.accptor_acct_num                       as accptor_acct_num         --承兑人账号
   ,t3.accptor_open_bank_no                   as accptor_open_bank_no     --承兑人开户行行号
   ,t3.accptor_open_bank_name                 as accptor_open_bank_name   --承兑人开户行名称
   ,''                                        as recver_cust_id           --收款人客户编号  源表BDMS_DRAFT_INFO中PAYEE_ID无数据，未入模型
   ,t3.recver_name                            as recver_name              --收款人名称
   ,t3.recver_acct_num                        as recver_acct_num          --收款人账号
   ,t3.recver_open_bank_no                    as recver_open_bank_no      --收款人开户行行号
   ,t3.recver_open_bank_name                  as recver_open_bank_name    --收款人开户行名称
   ,''                                        as repay_num                --还款账号
   ,t1.entry_dt                               as entry_dt                 --记账日期
   ,t1.revo_dt                                as revo_dt                  --撤销日期
   ,''                                        as bus_flow_num             --业务流水号
   ,t2.margin_ratio                           as margin_ratio             --保证金比例
   ,t2.comm_fee_ratio                         as comm_fee_ratio           --手续费比例
   ,t1.entry_status_cd                        as entry_status_cd          --记账状态代码
   ,t1.draw_status_cd                         as draw_status_cd           --出票状态代码
   ,t1.bill_acpt_proc_status_cd               as bill_acpt_status_cd      --承兑状态代码
   ,decode(t3.tran_cd,'01','1','0')           as tranbl_flg               --可转让标志
   ,t1.exp_uncond_pay_entr_cd                 as uncond_pay_flg           --无条件支付标志
   ,'CNY'                                     as curr_cd                  --币种代码
   ,t2.open_type_cd                           as open_type_cd             --敞口类型代码
   ,nvl(t2.open_amt,0)                        as open_amt                 --敞口金额
   ,t3.bill_amt                               as fac_val_amt              --票面金额
   ,nvl(trim(t3.payoff_flg),'0')              as payoff_flg               --结清标志
   ,t1.lmt_deduct_amt                         as lmt_ocup_amt             --额度占用金额
   ,''                                        as lmt_ocup_status_cd       --额度占用状态代码
   ,t1.comm_fee                               as comm_fee                 --手续费
   ,t1.todos                                  as todos                    --工本费
   ,t2.acpt_fee                               as acpt_fee                 --承兑费
   ,t2.mgmt_fee                               as mgmt_fee                 --管理费
   ,''                                        as accptor_crdt_level_cd    --承兑人信用等级代码(我行信用等级)
   ,null                                      as accptor_rating_exp_dt    --承兑人评级到期日期(我行评级到期日期)
   ,t2.org_id                                 as issue_org_id             --签发机构编号
   ,t2.enter_acct_org_id                      as enter_acct_org_id        --入账机构编号
   ,t2.cust_mgr_id                            as cust_mgr_id              --客户经理编号
   ,t2.dept_id                                as dept_id                  --部门编号
   ,t2.operr_id                               as operr_id                 --操作员编号
   ,''                                        as group_open_flg           --集团代开标志
   ,''                                        as group_name               --集团名称
   ,''                                        as group_id                 --集团编号  
   ,''                                        as group_open_drawer_name   --集团代开出票人名称
   ,''                                        as group_open_drawer_cust_no--集团代开出票人客户号
   ,t2.rela_party_que_rest_cd                 as rela_party_que_rest_cd   --关联方查询结果代码
   ,t1.job_cd                                 as job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
  from ${iml_schema}.agt_bill_acpt_dtl t1 --票据承兑明细
  left join ${iml_schema}.agt_bill_acpt_batch t2 --票据承兑批次
    on t1.batch_id = t2.batch_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.ref_rgst_cter_bill_info_para t3  --上海票交所交易信息
    on t1.bill_id = t3.rgst_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'bdmsf1'
  /*left join ${iml_schema}.pty_cust t4--客户
    on t2.drawer_cust_id = t4.cust_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'bdmsf1'
   and t4.id_mark <> 'D'*/
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   and t1.src_table_name = 'bdms_cpes_accept_details'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_bill_acpt_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bill_acpt_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bill_acpt_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bill_acpt_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);