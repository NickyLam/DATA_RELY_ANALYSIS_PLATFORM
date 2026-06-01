/*
Purpose:    共性加工层-银承账户信息，包括所有的银行承兑汇票和商业承兑汇票，通过协议编号可以关联保证金账号，但允许一个协议编号对应多个保证金账号；如果产生垫款，可以根据垫款借据编号关联对公贷款借据信息表获取相关的借据信息。数据来源于票据系统和综合信贷系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220630 icl_cmm_ba_acct_info
Createdate: 20190729
Logs:
            20200110 翟若平 调整iml.ref_cny_fori_exch_mdl_p_h表取数口径.
            20200627 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
            20210104 陈伟峰 调整agt_dep_acct算法
            20211022 陈伟峰 调整【当期余额】加工逻辑
            20220627 李森辉 调整取数数据源，由原核心系统调整为综合信贷系统和票据系统
            20221020 陈伟峰 调整第一组 字段【出票日期、保证金比例、保证金金额】的加工口径
            20221027 陈伟峰 调整字段【保证金比例、保证金金额、保证金账号、保证金币种】的加工口径
            20221220 陈伟峰 调整上日表关联条件，增加投产日期前后区分判断
            20230206 陈伟峰 调整基数字段加工逻辑，加入投产日关联字段判断逻辑
            20230313 温旺清 置空字段【垫款标志、垫款借据编号、垫款执行利率、垫款利率上浮比例、垫款金额
            20230508 谢  宁 新增【票据记账编号、承兑借据编号】
            20230509 陈伟峰 调整第一组余额加工口径，加入bill_acpt_proc_status_cd=‘15’的情况
            20231107 徐子豪 新增字段【客户编号】
            20240123 陈伟峰 修改字段【当期余额】加工逻辑
            20240723 陈伟峰 调整bdms_htes_draft_info、bdms_dpc_draft_info增加迁移标志过滤
            20241012 陈伟峰 新增字段【敞口类型代码、敞口金额】
            20250704 陈伟峰 调整【当期余额】加工逻辑，过滤备款成功的记录不统计余额
            20250811 陈伟峰 新增字段【调整存款收益标志】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ba_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ba_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ba_acct_info_ex01 purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_ba_acct_info_ex01
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ba_acct_info where 0=1;

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ba_acct_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_ba_acct_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ba_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ba_acct_info_ex01(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,acct_id                      -- 账户编号
       ,bill_num                     -- 票据号码
       ,bill_entry_id                -- 票据记账编号
       ,acpt_dubil_id                -- 承兑借据编号
       ,acpt_org_id                  -- 承兑机构编号
       ,stl_acct_num                 -- 结算账号
       ,cust_id                      -- 客户编号
       ,subj_id                      -- 科目编号
       ,std_prod_id                  -- 标准产品编号
       ,bill_med_cd                  -- 票据介质代码
       ,bill_type_cd                 -- 票据类型代码
       ,margin_acct_num              -- 保证金账号
       ,margin_dep_term              -- 保证金存期
       ,draw_dt                      -- 出票日期
       ,close_dt                     -- 关闭日期
       ,close_flow                   -- 关闭流水
       ,exp_dt                       -- 到期日期
       ,bill_status                  -- 票据状态
       ,close_way                    -- 关闭方式
       ,pymc_acct_num                -- 备款账号
       ,pymc_dt                      -- 备款日期
       ,pymc_flow                    -- 备款流水
       ,pymc_way                     -- 备款方式
       ,adj_dep_prft_flg             -- 调整存款收益标志
       ,advc_flg                     -- 垫款标志
       ,advc_dubil_id                -- 垫款借据编号
       ,advc_exec_int_rat            -- 垫款执行利率
       ,advc_int_rat_cu_ratio        -- 垫款利率上浮比例
       ,int_rat_base_type_cd         -- 利率基准类型代码
       ,open_type_cd                 -- 敞口类型代码
       ,open_amt                     -- 敞口金额
       ,fac_val_curr                 -- 票面币种
       ,margin_curr                  -- 保证金币种
       ,margin_ratio                 -- 保证金比例
       ,margin_amt                   -- 保证金金额
       ,advc_amt                     -- 垫款金额
       ,comm_fee                     -- 手续费
       ,fac_val_amt                  -- 票面金额
       ,currt_bal                    -- 当期余额
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- ETL处理时间戳
)
select to_date('${batch_date}','yyyymmdd')          -- 数据日期
       ,t1.lp_id                                    -- 法人编号
       ,t3.bill_id                                  -- 账户编号
       ,t3.bill_num                                 -- 票据号码
       ,t2.run_code                                 -- 票据记账编号
       ,t10.dubil_id                                -- 承兑借据编号
       ,t1.org_id                                   -- 承兑机构编号
       ,t1.drawer_acct_num                          -- 结算账号
       ,t1.drawer_cust_id                           -- 客户编号
       ,nvl(t6.pric_subj_id, '71020101')            -- 科目编号
       ,mdd.prod_code                               -- 标准产品编号
       ,t1.bill_med_cd                              -- 票据介质代码
       ,t1.bill_type_cd                             -- 票据类型代码
       ,t17.acct_id                                 -- 保证金账号
       ,t1.margin_tenor_type_cd                     -- 保证金存期
       ,t3.draw_dt                                  -- 出票日期
       ,null                                        -- 关闭日期
       ,''                                          -- 关闭流水
       ,t3.fac_val_exp_dt                           -- 到期日期
       ,t3.bill_status_cd                           -- 票据状态
       ,''                                          -- 关闭方式
       ,''                                          -- 备款账号
       ,null                                        -- 备款日期
       ,''                                          -- 备款流水
       ,''                                          -- 备款方式
       ,t1.adj_dep_prft_flg                         -- 调整存款收益标志
       ,''                                          -- 垫款标志
       ,''                                          -- 垫款借据编号
       ,''                                          -- 垫款执行利率
       ,''                                          -- 垫款利率上浮比例
       ,t10.base_rat_type_cd                        -- 利率基准类型代码
       ,t1.open_type_cd                             -- 敞口类型代码
       ,nvl(t1.open_amt,0)                          -- 敞口金额
       ,NVL(t7.curr_cd,'CNY')                       -- 票面币种
       ,t16.crcycd                                  -- 保证金币种  t7.bailcurrency 待入模
       ,(t15.margin_amt/t3.bill_amt) *100           -- 保证金比例
       ,t15.margin_amt                              -- 保证金金额
       ,''                                          -- 垫款金额
       ,t2.charge                                   -- 手续费
       ,t3.bill_amt                                 -- 票面金额
       ,case when t2.accept_status in ('04','05','06','12','15') and
                  t12.draft_number is null and
                  t13.draft_number is null and
                  substr(t14.store_status, 3, 3) = '010' and substr(t14.store_status, 10, 2) = '20' and
                  ((t3.role_src_cd <>'02' and t14.reserve3 is not null) or (t3.role_src_cd is null and substr(t14.store_status, 3, 3) <> '020')) 
                 and t18.draft_number is null    --20250626新增备款成功记录 
               then t3.bill_amt
            else 0
        end as currt_bal                             -- 当期余额
       ,t1.job_cd                                    -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                      -- etl处理时间戳
  from ${iml_schema}.agt_bill_acpt_batch t1
/* inner join ${iml_schema}.agt_bill_acpt_dtl t2
    on t1.batch_id = t2.batch_id
   and t2.entry_status_cd = '03'
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd = 'bdmsf1'*/  --M层快照表，状态不准确，调整成O层
 inner join ${iol_schema}.bdms_bms_accept_details t2
    on t1.batch_id=t2.contract_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.account_flag ='2'
 inner join ${iml_schema}.agt_bill_info t3
    on t2.draft_id = t3.bill_id
   and t3.create_dt<=to_date('${batch_date}','yyyymmdd')
   and t3.id_mark <> 'D'
   and t3.job_cd ='bdmsf1'
   and t3.bill_status_cd <> '99'
  /*left join ${iml_schema}.agt_prod_rela_h t4
    on t2.agt_id = t4.agt_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'bdmsf1'*/
  left join ${iol_schema}.bdms_bms_accept_contract bac
    on t1.batch_id = bac.id
   and bac.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and bac.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.bdms_meta_deposit_define mdd
    on bac.prod_no = mdd.product_no
   and mdd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mdd.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t6
    on mdd.prod_code = t6.sellbl_prod_id
   and t6.bus_type_cd = 'BDMX'
   and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_cont_info_h t7
    on t1.acpt_agt_id = t7.cont_id
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h r
    on nvl(trim(t2.run_code),t2.draft_id) = nvl(trim(r.bill_uniq_ind_no),' ')
   and r.start_dt <= to_date('${batch_date}','yyyymmdd')
   and r.end_dt > to_date('${batch_date}','yyyymmdd')
   and r.job_cd = 'icmsf1'
   and trim(r.bill_uniq_ind_no) is not null
  left join ${iml_schema}.agt_loan_dubil_info_h t10
    on r.out_acct_flow_num = t10.rela_out_acct_flow_num
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'icmsf1'
  left join (select distinct bi.draft_number
               from ${iol_schema}.bdms_bms_draft_centre_info bi,
                    ${iol_schema}.bdms_bms_draft_centre_trans trans
              where bi.trans_id = trans.id
                and trans.status in ('E020_02_20', 'E021_02_20', 'E023_02_20', 'E023_04_20')
                and bi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and bi.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and trans.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and trans.end_dt > to_date('${batch_date}', 'yyyymmdd')
             ) t12
    on t3.bill_num = t12.draft_number
  left join (select distinct hdi.draft_number
               from ${iol_schema}.bdms_htes_draft_info hdi
              where hdi.status in ('ST08','CS06')
                and hdi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and hdi.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and hdi.migrate_flag <>'1'
             ) t13
    on t3.bill_num = t13.draft_number
  left join ${iol_schema}.bdms_bms_draft_centre_info t14
    on t3.bill_id = t14.id
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.agt_loan_out_acct_appl_h t15
    on t10.rela_out_acct_flow_num=t15.out_acct_flow_num
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'icmsf1'
   left join (select putoutno,grteac,subaccount,crcycd,row_number() over( partition by putoutno order by serialno desc  ) rn
                from ${iol_schema}.icms_deposit_apply_info
               where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and end_dt > to_date('${batch_date}', 'yyyymmdd')) t16
    on t16.putoutno=t15.out_acct_flow_num
   and t16.rn=1
   left join ${iml_schema}.agt_dep_acct_info_h t17
   on t17.cust_acct_num=t16.grteac
   and t17.sub_acct_num=t16.subaccount
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t17.job_cd = 'ncbsf1'
  left join (select distinct draft_number from ${iol_schema}.bdms_bail_repayment_info
                where reserve_status='1') t18
     on t3.bill_num= t18.draft_number
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
--   and t2.src_table_name = 'bdms_bms_accept_details'
;
commit;

insert /*+ append */ into ${icl_schema}.cmm_ba_acct_info_ex01(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,acct_id                      -- 账户编号
       ,bill_num                     -- 票据号码
       ,bill_entry_id                -- 票据记账编号
       ,acpt_dubil_id                -- 承兑借据编号
       ,acpt_org_id                  -- 承兑机构编号
       ,stl_acct_num                 -- 结算账号
       ,cust_id                      -- 客户编号
       ,subj_id                      -- 科目编号
       ,std_prod_id                  -- 标准产品编号
       ,bill_med_cd                  -- 票据介质代码
       ,bill_type_cd                 -- 票据类型代码
       ,margin_acct_num              -- 保证金账号
       ,margin_dep_term              -- 保证金存期
       ,draw_dt                      -- 出票日期
       ,close_dt                     -- 关闭日期
       ,close_flow                   -- 关闭流水
       ,exp_dt                       -- 到期日期
       ,bill_status                  -- 票据状态
       ,close_way                    -- 关闭方式
       ,pymc_acct_num                -- 备款账号
       ,pymc_dt                      -- 备款日期
       ,pymc_flow                    -- 备款流水
       ,pymc_way                     -- 备款方式
       ,adj_dep_prft_flg             -- 调整存款收益标志
       ,advc_flg                     -- 垫款标志
       ,advc_dubil_id                -- 垫款借据编号
       ,advc_exec_int_rat            -- 垫款执行利率
       ,advc_int_rat_cu_ratio        -- 垫款利率上浮比例
       ,int_rat_base_type_cd         -- 利率基准类型代码
       ,open_type_cd                 -- 敞口类型代码
       ,open_amt                     -- 敞口金额
       ,fac_val_curr                 -- 票面币种
       ,margin_curr                  -- 保证金币种
       ,margin_ratio                 -- 保证金比例
       ,margin_amt                   -- 保证金金额
       ,advc_amt                     -- 垫款金额
       ,comm_fee                     -- 手续费
       ,fac_val_amt                  -- 票面金额
       ,currt_bal                    -- 当期余额
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- ETL处理时间戳
)
select to_date('${batch_date}','yyyymmdd')          -- 数据日期
       ,t1.lp_id                                    -- 法人编号
       ,t3.rgst_id                                  -- 账户编号
       ,t3.bill_num                                 -- 票据号码
       ,t2.run_code                                 -- 票据记账编号
       ,t10.dubil_id                                -- 承兑借据编号
       ,t1.org_id                                   -- 承兑机构编号
       ,t1.drawer_acct_num                          -- 结算账号
       ,t1.drawer_cust_id                           -- 客户编号
       ,nvl(t6.pric_subj_id, '71020101')            -- 科目编号
       ,mdd.prod_code                               -- 产品编号
       ,t1.bill_med_cd                              -- 票据介质代码
       ,t1.bill_type_cd                             -- 票据类型代码
       ,t17.acct_id                                 -- 保证金账号
       ,t1.margin_tenor_type_cd                     -- 保证金存期
       ,t1.appl_draw_dt                             -- 出票日期
       ,null                                        -- 关闭日期
       ,''                                          -- 关闭流水
       ,t3.exp_dt                                   -- 到期日期
       ,t3.bill_status_cd                           -- 票据状态
       ,''                                          -- 关闭方式
       ,''                                          -- 备款账号
       ,null                                        -- 备款日期
       ,''                                          -- 备款流水
       ,''                                          -- 备款方式
       ,t1.adj_dep_prft_flg                         -- 调整存款收益标志
	     ,case when t11.dubil_id is not null then '1' else '0' end        -- 垫款标志
	     ,t11.dubil_id                                -- 垫款借据编号
	     ,t11.ovdue_int_rat                           -- 垫款执行利率
	     ,t11.ovdue_int_rat_flo_val                   -- 垫款利率上浮比例
	     ,t10.base_rat_type_cd                        -- 利率基准类型代码
       ,t1.open_type_cd                             -- 敞口类型代码
       ,nvl(t1.open_amt,0)                          -- 敞口金额
       ,nvl(t7.curr_cd,'CNY')                       -- 票面币种
       ,t16.crcycd                                  -- 保证金币种  t7.bailcurrency 待入模
       ,(t15.margin_amt/t3.bill_amt) *100           -- 保证金比例
       ,t15.margin_amt                              -- 保证金金额
       ,t11.dubil_amt                               -- 垫款金额
       ,t2.charge                                   -- 手续费
       ,t3.bill_amt                                 -- 票面金额
       ,case when t2.accept_status in ('04','05','06','15') and
                  t12.draft_number is null and
                  t18.draft_number is null    --20250626新增备款成功记录 
                  and nvl(t3.bill_amt, 0) - nvl(t13.draft_amount, 0) > 0 then nvl(t3.bill_amt, 0) - nvl(t13.draft_amount, 0)
             else 0
         end as currt_bal                           -- 当期余额
       ,t1.job_cd                                   -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- etl处理时间戳
  from ${iml_schema}.agt_bill_acpt_batch t1
/* inner join ${iml_schema}.agt_bill_acpt_dtl t2
    on t1.batch_id = t2.batch_id
   and t2.entry_status_cd = '03'
   and t2.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.id_mark <> 'D'
   and t2.job_cd = 'bdmsf1'  */   --M层快照表，状态不准确，调整成O层
 inner join ${iol_schema}.bdms_cpes_accept_details t2
    on t1.batch_id=t2.contract_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.account_status ='2'
 inner join ${iml_schema}.ref_rgst_cter_bill_info_para t3
    on t2.draft_id = t3.rgst_id
   and t3.start_dt<= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd ='bdmsf1'
  /*left join ${iml_schema}.agt_prod_rela_h t4
    on t2.agt_id = t4.agt_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'bdmsf1'*/
  left join ${iol_schema}.bdms_cpes_accept_contract cac
    on t1.batch_id = cac.id
   and cac.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and cac.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.bdms_meta_deposit_define mdd
    on cac.product_no = mdd.product_no
   and mdd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and mdd.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t6
    on mdd.prod_code = t6.sellbl_prod_id
   and t6.bus_type_cd = 'BDMX'
   and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_cont_info_h t7
    on t1.acpt_agt_id = t7.cont_id
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h r
    on nvl(trim(t2.run_code),t2.draft_id) = nvl(trim(r.bill_uniq_ind_no),' ')
   and r.start_dt <= to_date('${batch_date}','yyyymmdd')
   and r.end_dt > to_date('${batch_date}','yyyymmdd')
   and r.job_cd = 'icmsf1'
   and trim(r.bill_uniq_ind_no) is not null
  left join ${iml_schema}.agt_loan_dubil_info_h t10
    on r.out_acct_flow_num = t10.rela_out_acct_flow_num
   and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   and t10.job_cd = 'icmsf1'
  left join ${iml_schema}.agt_loan_dubil_info_h t11 --借据信息表(垫款)
    on t10.dubil_id = t11.init_dubil_id
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'icmsf1'
  left join (select distinct bi.draft_number
              from ${iol_schema}.bdms_dpc_draft_info bi
             where bi.status = 'S14'
               and bi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and bi.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and bi.migrate_flag <>'1'
             ) t12
    on t3.bill_num = t12.draft_number
  left join (select hdi.draft_number, sum(hdi.draft_amount) as draft_amount
               from ${iol_schema}.bdms_htes_draft_info hdi
              where hdi.status in ('ST08','CS06')
                and hdi.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and hdi.end_dt > to_date('${batch_date}', 'yyyymmdd')
              group by hdi.draft_number
              ) t13
    on t3.bill_num = t13.draft_number
  left join ${iml_schema}.agt_loan_out_acct_appl_h t15
    on t10.rela_out_acct_flow_num=t15.out_acct_flow_num
   and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t15.job_cd = 'icmsf1'
  left join (select putoutno,grteac,subaccount,crcycd,row_number() over( partition by putoutno order by serialno desc  ) rn
               from ${iol_schema}.icms_deposit_apply_info
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')) t16
   on t16.putoutno=t15.out_acct_flow_num
  and t16.rn=1
 left join iml.agt_dep_acct_info_h t17
   on t17.cust_acct_num=t16.grteac
  and t17.sub_acct_num=t16.subaccount
  and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t17.job_cd = 'ncbsf1'
 left join (select distinct draft_number from ${iol_schema}.bdms_bail_repayment_info
               where reserve_status='1') t18
    on t3.bill_num= t18.draft_number
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   --and t2.src_table_name = 'bdms_cpes_accept_details'
;
commit;

insert /*+ append */ into ${icl_schema}.cmm_ba_acct_info_ex(
       etl_dt                        -- 数据日期
       ,lp_id                        -- 法人编号
       ,acct_id                      -- 账户编号
       ,bill_num                     -- 票据号码
       ,bill_entry_id                -- 票据记账编号
       ,acpt_dubil_id                -- 承兑借据编号
       ,acpt_org_id                  -- 承兑机构编号
       ,stl_acct_num                 -- 结算账号
       ,cust_id                      -- 客户编号
       ,subj_id                      -- 科目编号
       ,std_prod_id                  -- 标准产品编号
       ,bill_med_cd                  -- 票据介质代码
       ,bill_type_cd                 -- 票据类型代码
       ,margin_acct_num              -- 保证金账号
       ,margin_dep_term              -- 保证金存期
       ,draw_dt                      -- 出票日期
       ,close_dt                     -- 关闭日期
       ,close_flow                   -- 关闭流水
       ,exp_dt                       -- 到期日期
       ,bill_status                  -- 票据状态
       ,close_way                    -- 关闭方式
       ,pymc_acct_num                -- 备款账号
       ,pymc_dt                      -- 备款日期
       ,pymc_flow                    -- 备款流水
       ,pymc_way                     -- 备款方式
       ,adj_dep_prft_flg             -- 调整存款收益标志
       ,advc_flg                     -- 垫款标志
       ,advc_dubil_id                -- 垫款借据编号
       ,advc_exec_int_rat            -- 垫款执行利率
       ,advc_int_rat_cu_ratio        -- 垫款利率上浮比例
       ,int_rat_base_type_cd         -- 利率基准类型代码
       ,open_type_cd                 -- 敞口类型代码
       ,open_amt                     -- 敞口金额
       ,fac_val_curr                 -- 票面币种
       ,margin_curr                  -- 保证金币种
       ,margin_ratio                 -- 保证金比例
       ,margin_amt                   -- 保证金金额
       ,advc_amt                     -- 垫款金额
       ,comm_fee                     -- 手续费
       ,fac_val_amt                  -- 票面金额
       ,currt_bal                    -- 当期余额
       ,cl_curr_currt_bal            -- 折本币当期余额
       ,ear_d_bal                    -- 日初余额
       ,ear_m_bal                    -- 月初余额
       ,ear_s_bal                    -- 季初余额
       ,ear_y_bal                    -- 年初余额
       ,y_acm_bal                    -- 年累计余额
       ,s_acm_bal                    -- 季累计余额
       ,m_acm_bal                    -- 月累计余额
       ,cl_curr_ear_d_bal            -- 折本币日初余额
       ,cl_curr_ear_m_bal            -- 折本币月初余额
       ,cl_curr_ear_s_bal            -- 折本币季初余额
       ,cl_curr_ear_y_bal            -- 折本币年初余额
       ,cl_curr_y_acm_bal            -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal      -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal      -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal      -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal      -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal            -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal      -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal      -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal      -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal            -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal      -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal      -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal      -- 折本币年初月累计余额
       ,y_avg_bal                    -- 年日均余额
       ,q_avg_bal                    -- 季日均余额
       ,m_avg_bal                    -- 月日均余额
       ,cl_curr_y_avg_bal            -- 折本币年日均余额
       ,cl_curr_q_avg_bal            -- 折本币季日均余额
       ,cl_curr_m_avg_bal            -- 折本币月日均余额
       ,job_cd                       -- 任务代码
       ,etl_timestamp                -- ETL处理时间戳
)
select t1.etl_dt                        -- 数据日期
       ,t1.lp_id                        -- 法人编号
       ,t1.acct_id                      -- 账户编号
       ,t1.bill_num                     -- 票据号码
       ,t1.bill_entry_id                -- 票据记账编号
       ,t1.acpt_dubil_id                -- 承兑借据编号
       ,t1.acpt_org_id                  -- 承兑机构编号
       ,t1.stl_acct_num                 -- 结算账号
       ,t1.cust_id                      -- 客户编号
       ,t1.subj_id                      -- 科目编号
       ,t1.std_prod_id                  -- 标准产品编号
       ,t1.bill_med_cd                  -- 票据介质代码
       ,t1.bill_type_cd                 -- 票据类型代码
       ,t1.margin_acct_num              -- 保证金账号
       ,t1.margin_dep_term              -- 保证金存期
       ,t1.draw_dt                      -- 出票日期
       ,t1.close_dt                     -- 关闭日期
       ,t1.close_flow                   -- 关闭流水
       ,t1.exp_dt                       -- 到期日期
       ,t1.bill_status                  -- 票据状态
       ,t1.close_way                    -- 关闭方式
       ,t1.pymc_acct_num                -- 备款账号
       ,t1.pymc_dt                      -- 备款日期
       ,t1.pymc_flow                    -- 备款流水
       ,t1.pymc_way                     -- 备款方式
       ,t1.adj_dep_prft_flg             -- 调整存款收益标志
       ,t1.advc_flg                     -- 垫款标志
       ,t1.advc_dubil_id                -- 垫款借据编号
       ,t1.advc_exec_int_rat            -- 垫款执行利率
       ,t1.advc_int_rat_cu_ratio        -- 垫款利率上浮比例
       ,t1.int_rat_base_type_cd         -- 利率基准类型代码
       ,t1.open_type_cd                 -- 敞口类型代码
       ,t1.open_amt                     -- 敞口金额
       ,t1.fac_val_curr                 -- 票面币种
       ,t1.margin_curr                  -- 保证金币种
       ,t1.margin_ratio                 -- 保证金比例
       ,t1.margin_amt                   -- 保证金金额
       ,t1.advc_amt                     -- 垫款金额
       ,t1.comm_fee                     -- 手续费
       ,t1.fac_val_amt                  -- 票面金额
       ,t1.currt_bal                    -- 当期余额
       ,t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1)                                                                                            -- 折本币当期余额
       ,coalesce(t9.currt_bal,t9_1.currt_bal, 0)                                                                                                                    -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t9.currt_bal,t9_1.currt_bal, 0) else coalesce(t9.ear_m_bal,t9_1.ear_m_bal, 0) end                                    -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t9.currt_bal,t9_1.currt_bal, 0) else coalesce(t9.ear_s_bal,t9_1.ear_s_bal, 0) end          -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t9.currt_bal,t9_1.currt_bal, 0) else coalesce(t9.ear_y_bal,t9_1.ear_y_bal, 0) end                                  -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else coalesce(t9.y_acm_bal,t9_1.y_acm_bal, 0) + t1.currt_bal end                           -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else coalesce(t9.s_acm_bal,t9_1.s_acm_bal, 0) + t1.currt_bal end   -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else coalesce(t9.m_acm_bal,t9_1.m_acm_bal, 0) + t1.currt_bal end                             -- 月累计余额
       ,coalesce(t9.cl_curr_currt_bal,t9_1.cl_curr_currt_bal, 0)                                                                                                            -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t9.cl_curr_currt_bal,t9_1.cl_curr_currt_bal, 0) else coalesce(t9.cl_curr_ear_m_bal,t9_1.cl_curr_ear_m_bal, 0) end                    -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t9.cl_curr_currt_bal,t9_1.cl_curr_currt_bal, 0)
             else coalesce(t9.cl_curr_ear_s_bal,t9_1.cl_curr_ear_s_bal, 0) end                                                                                              -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t9.cl_curr_currt_bal,t9_1.cl_curr_currt_bal, 0) else coalesce(t9.cl_curr_ear_y_bal,t9_1.cl_curr_ear_y_bal, 0) end                  -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1)
             else coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end                                               -- 折本币年累计余额
       ,coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0)                                                                                                            -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) else coalesce(t9.cl_curr_ear_d_y_acm_bal,t9_1.cl_curr_ear_d_y_acm_bal, 0) end              -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0)
             else coalesce(t9.cl_curr_ear_d_y_acm_bal,t9_1.cl_curr_ear_d_y_acm_bal, 0) end                                                                                        -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) else coalesce(t9.cl_curr_ear_d_y_acm_bal,t9_1.cl_curr_ear_d_y_acm_bal, 0) end            -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1)
             else coalesce(t9.cl_curr_s_acm_bal,t9_1.cl_curr_s_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end                                               -- 折本币季累计余额
       ,coalesce(t9.cl_curr_s_acm_bal,t9_1.cl_curr_s_acm_bal, 0)                                                                                                            -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t9.cl_curr_s_acm_bal,t9_1.cl_curr_s_acm_bal, 0)
             else coalesce(t9.cl_curr_ear_s_s_acm_bal,t9_1.cl_curr_ear_s_s_acm_bal, 0) end                                                                                        -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t9.cl_curr_s_acm_bal,t9_1.cl_curr_s_acm_bal, 0) else coalesce(t9.cl_curr_ear_y_s_acm_bal,t9_1.cl_curr_ear_y_s_acm_bal, 0) end            -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1)
             else coalesce(t9.cl_curr_m_acm_bal,t9_1.cl_curr_m_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end                                               -- 折本币月累计余额
       ,coalesce(t9.cl_curr_m_acm_bal,t9_1.cl_curr_m_acm_bal, 0)                                                                                                            -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t9.cl_curr_m_acm_bal,t9_1.cl_curr_m_acm_bal, 0) else coalesce(t9.cl_curr_ear_m_m_acm_bal,t9_1.cl_curr_ear_m_m_acm_bal, 0) end              -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t9.cl_curr_m_acm_bal,t9_1.cl_curr_m_acm_bal, 0) else coalesce(t9.cl_curr_ear_y_m_acm_bal,t9_1.cl_curr_ear_y_m_acm_bal, 0) end            -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal else coalesce(t9.y_acm_bal,t9_1.y_acm_bal, 0) + t1.currt_bal end) /
           (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                        -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal else coalesce(t9.y_acm_bal,t9_1.y_acm_bal, 0) + t1.currt_bal end) /
           (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)                                        -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal else coalesce(t9.y_acm_bal,t9_1.y_acm_bal, 0) + t1.currt_bal end) /
           (to_number(substr('${batch_date}', 7, 2)))                                                                                           -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) else coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end) /
           (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                        -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) else coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end) /
           (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)                                        -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) else coalesce(t9.cl_curr_y_acm_bal,t9_1.cl_curr_y_acm_bal, 0) + t1.currt_bal * nvl(t8.convt_cny_exch_rat, 1) end) /
           (to_number(substr('${batch_date}', 7, 2)))                                                                                           -- 折本币月日均余额
       ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- etl处理时间戳
  from ${icl_schema}.cmm_ba_acct_info_ex01 t1
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t8
    on t1.fac_val_curr = t8.curr_cd
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_ba_acct_info t9
    on t9.bill_num = t1.bill_num
   and t9.lp_id = t1.lp_id
   and t9.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  <=to_date('20230502', 'yyyymmdd')  --新一代投产时0501为旧数据，0502为新数据，0502日前的数据关联前一日需使用票号关联(包括0502)，0503日后的数据需使用账号关联
  left join ${icl_schema}.cmm_ba_acct_info t9_1
    on t9_1.acct_id = t1.acct_id
   and t9_1.lp_id = t1.lp_id
   and t9_1.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  >to_date('20230502', 'yyyymmdd')
 where 1 = 1
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ba_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_ba_acct_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ba_acct_info_ex purge;
--drop table ${icl_schema}.cmm_ba_acct_info_ex01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ba_acct_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);