/*
Purpose:    共性加工层-联合网贷借据信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_unite_wl_dubil_info_morning
Createdate: 20190814
Logs:       20250908 谢  宁 新增凌晨批次脚本
            20251222 陈伟峰 新增对公微业贷203050100002
           20251215 陈伟峰 调整字节贷款、分期乐的【表内利息、表外利息】加工逻辑，使用逾期利息余额+罚息余额 先加处理，口径提供者：信贷陈婷
           20251224 陈伟峰 调整微业贷出资比例加工逻辑
            
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_unite_wl_dubil_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_unite_wl_dubil_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_dubil_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_unite_wl_dubil_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_dubil_info where 0=1
;
commit;

-- 第一组（共二组）微业贷
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
   ,intnal_loan_type_cd                  --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始总期数
   ,tot_perds	                         --总期数
   ,curr_issue_perds	                 --本期期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')   -- 数据日期
   ,t1.lp_id                             -- 法人编号
   ,t1.dubil_id                          -- 借据编号
   ,t1.dubil_id                          -- 核心借据编号
   ,t1.cont_id                           -- 合同编号
   ,t1.prod_id                           -- 标准产品编号
   ,t1.prod_id                           -- 产品编号
   ,t1.cust_id                           -- 客户编号
   ,case when t1.prod_id='201020100063' then '13030202' 
           else '13030101'  end       -- 科目编号(公司流动资金贷款)
   ,''                                   -- 会计类别代码
   ,t1.distr_acct_id                     -- 入账账号
   ,t1.repay_num_id                      -- 还款账号
   ,''                                   -- 关联协议编号**
   ,t1.out_acct_flow_num                 -- 关联申请流水号**
   ,t1.curr_cd                           -- 币种代码
   ,t1.prod_id                           -- 业务品种编号
   ,'00'                                 -- 贷款类型代码
   ,t1.prod_cls_cd                       -- 行内贷款类型代码
   ,t1.asset_thd_cls_cd                  -- 资产三分类代码
   ,case when t1.loan_status_cd = '0' then '1' 
         when t1.loan_status_cd in ('2','4','3') then '6'
	else '0' end                         -- 借据状态代码
   ,t1.loan_usage_cd                     -- 贷款用途代码
   ,t2.indus_subclass_cd                 -- 投向行业代码
   ,case when ${iml_schema}.dateformat_max2(t2.payoff_dt) <> ${iml_schema}.dateformat_max2('') then 'CLEAR'
         when t1.loan_status_cd = '1' then 'OVD'
         else 'NORMAL' end               -- 合同状态代码
   ,'00'                                 -- 贷款四级分类代码
   ,t1.level5_cls_cd                     -- 贷款五级分类代码
   ,case when t2.ovdue_days = 0 then '15'
         when t2.ovdue_days >= 1 and t2.ovdue_days <= 59  then '21'
         when t2.ovdue_days >= 60 and t2.ovdue_days <= 89 then '22'
         when t2.ovdue_days >= 90 and t2.ovdue_days <= 120 then '30'
         when t2.ovdue_days >= 121 and t2.ovdue_days <= 180 then '40'
         when t2.ovdue_days >= 181 then '50'
         else '90' end                   -- 贷款十级分类代码
   ,'11'                                 -- 贷款十二级分类代码
   ,''                                   -- 应计非应计代码
   ,t1.repay_way_cd                      -- 还款方式代码
   ,t1.int_set_way_cd                    -- 结息方式代码
   ,t1.int_accr_way_cd                   -- 计息方式代码
   ,decode(t1.int_rat_adj_way_cd,'7','0','1') -- 利率调整方式代码
   ,decode(t1.int_rat_adj_way_cd,'0','N','O') -- 利率调整周期单位代码
   ,'0'                                  -- 利率调整周期频率
   ,t1.base_rat_type_cd                  -- 利率基准类型代码
   ,decode(t1.int_rat_float_way_cd,'0','0','1','2','2','2','3','0','4','1','5','1','-')  -- 利率浮动方式代码
   ,'-'                                  -- 利率浮动方向代码
   ,t1.int_rat_flo_val                   -- 利率浮动值
   ,t2.repay_freq_cd                     -- 本金还款频率代码
   ,t2.repay_freq_cd                     -- 利息还款频率代码
   ,t2.guar_way_cd                       -- 担保方式代码
   ,'07'                                 -- 客户性质代码
   ,''                                   -- 入账账号类型
   ,t1.distr_org_name                    -- 入账账户开户银行名称
   ,''                                   -- 还款账号类型
   ,t1.repay_org_id                      -- 还款账户开户银行编号
   ,t1.repay_org_name                    -- 还款账户开户机构名称
   ,''                                   -- 内部结转标志
   ,'1'                                  -- 境内外标志
   ,t1.white_list_cust_flg               -- 白户标 志
   ,''                                   -- 农户标志
   ,''                                   -- 涉农标志
   ,t2.int_accr_flg                      -- 计息标志
   ,'1'                                  -- 复息标志
   ,case when t1.loan_status_cd = '1' then '1' else '0' end -- 逾期标志
   ,case when t1.loan_status_cd = '5' then '1' else '0' end -- 核销标志
   ,case when t1.prod_id = '201020100063' then '0'
         when t8.cust_id is not null and t8.nmal_amt <= 100000000 and t6.belong_indus_acct like 'P%' then '1'
         when t7.cust_id is not null and t7.nmal_amt <= 100000000 then '1' else '0' end   -- 人行普惠贷款标志**
   ,''                                   -- 债权直转标志
   ,t2.regroup_loan_flg                  -- 重组标志
   ,''                                   -- 重组贷款类型代码
   ,t2.regroup_dt                        -- 重组日期
   ,t1.effect_dt                         -- 开户日期
   ,t1.effect_dt                         -- 放款日期
   ,t1.effect_dt                         -- 原始放款日期
   ,t1.value_dt                          -- 起息日期
   ,t1.exp_dt                            -- 到期日期
   ,t1.exp_dt                            -- 原始到期日期
   ,t2.payoff_dt                         -- 结清日期
   ,null                                 -- 上次还款日期
   ,null                                 -- 下次还款日期
   ,t1.effect_dt                         -- 当前利率生效日期
   ,null                                 -- 下次利率调整日期
   ,t1.rgst_teller_id                    -- 客户经理编号
   ,t1.rgst_org_id                       -- 开户机构编号
   ,t1.rgst_org_id                       -- 管理机构编号
   ,t1.fin_org_id                        -- 账务机构编号
   ,t1.loan_tenor                        -- 原始总期数
   ,t1.loan_tenor                        -- 总期数
   ,t2.curr_perds                        -- 本期期数
   ,t4.term                              -- 剩余期数
   ,t4.ovdterm                           -- 逾期期数
   ,t2.ovdue_days                        -- 本金逾期天数
   ,t2.ovdue_days                        -- 利息逾期天数
   ,t2.grace_period                      -- 宽限期天数
   ,0                                    -- 分期手续费费率
   ,t1.base_rat                          -- 基准利率
   ,t1.loan_int_rat                      -- 执行利率
   ,t1.ovdue_int_rat                     -- 逾期利率
   ,(t1.loan_int_rat /360)               -- 每日执行利率
   ,0                                    -- 固收利率
   ,nvl(t1.loan_amt,0)                   -- 合同金额
   ,nvl(t1.loan_amt,0)                   -- 借据金额
   ,nvl(t1.loan_amt,0)                   -- 放款金额
   ,nvl(t1.loan_amt,0)                   -- 原始放款金额
   ,nvl(t9.participantratio,1)           -- 银行出资比例
   ,nvl(t1.td_acru_int,0)                -- 当日应计利息
   ,nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) -- 当期应计利息
   ,nvl(t1.loan_bal,0) - nvl(t2.ovdue_pric,0)  -- 正常本金
   ,nvl(t2.ovdue_pric,0)                 -- 逾期本金
   ,case when t2.ovdue_days > 90 then nvl(t2.ovdue_pric,0) else 0 end  -- 呆滞本金
   ,0                                    -- 呆账本金
   ,0                                    -- 核销本金
   ,nvl(t2.int_recvbl,0)                 -- 正常利息
   ,nvl(t2.ovdue_int,0)                  -- 逾期利息
   ,0                                    -- 核销利息
   ,nvl(t4.rpbl_pric_pnlt,0)             -- 逾期本金罚息
   ,nvl(t4.rpbl_int_pnlt,0)              -- 逾期利息罚息
   ,nvl(t1.recvbl_over_int,0)            -- 应收欠息
   ,nvl(t1.recvbl_acru_pnlt,0)           -- 应收应计罚息
   ,nvl(t1.recvbl_pnlt,0)                -- 应收罚息
   ,0                                    -- 应收费用
   ,case when t2.ovdue_days < 90 then nvl(t1.recvbl_over_int,0) else 0 end -- 表内欠息余额
   ,case when t2.ovdue_days >= 90  then nvl(t1.recvbl_over_int,0) else 0 end -- 表外欠息余额
   ,case when t2.ovdue_days < 90 then nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表内利息
   ,case when t2.ovdue_days >= 90  then nvl(t2.int_recvbl,0) + nvl(t2.ovdue_int,0) +  nvl(t4.rpbl_pric_pnlt,0) + nvl(t4.rpbl_int_pnlt,0) else 0 end -- 表外利息
  ,t4.ljys      -- 累计应收未收利息金额
   ,nvl(t3.reppay,0)                                     -- 已偿还正常本金
   ,nvl(t3.oreppay,0)                                    -- 已偿还逾期本金
   ,nvl(t3.reipay,0)                                     -- 已偿还正常利息
   ,nvl(t3.oreipay,0)                                    -- 已偿还逾期利息
   ,nvl(t3.repppay,0)                                    -- 已偿还逾期本金罚息
   ,0                                                    -- 已偿还逾期利息罚息
   ,0                                                    -- 已偿还费用
   ,nvl(t1.loan_bal,0)                                   -- 本金余额
   ,nvl(t1.loan_bal,0)                                   -- 当期余额
   ,nvl(t1.loan_bal,0) * nvl(t5.convt_cny_exch_rat, 1)   -- 折本币当期余额
   ,t1.job_cd                                            -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
 from ${iml_schema}.agt_wyd_dubil_h t1
 left join ${iml_schema}.agt_wyd_dubil_attach_info t2
   on t1.dubil_id = t2.dubil_id
  and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd ='icmsf1'
 left join (select dubil_id
                   ,sum(case when REPAY_TYPE_CD in ('01','05','06') then nvl(repay_pric,0) else 0 end ) as reppay --正常本金
                   ,sum(case when REPAY_TYPE_CD = '03' then nvl(repay_pric,0) else 0 end ) as oreppay             --逾期本金
                   ,sum(case when REPAY_TYPE_CD in ('01','05','06') then nvl(repay_int,0) else 0 end) as reipay   --正常利息
                   ,sum(case when REPAY_TYPE_CD = '03' then nvl(repay_int,0) else 0 end) as oreipay               --逾期利息
                   ,sum(case when REPAY_TYPE_CD = '03' then nvl(repay_pnlt,0) else 0 end) as repppay              --本金罚息
              from ${iml_schema}.evt_wyd_repay_dtl
			  where etl_dt <= to_date('${batch_date}', 'yyyymmdd')
			    and job_cd ='icmsi1'
              group by dubil_id ) t3
   on t1.dubil_id = t3.dubil_id
  left join (select dubil_id
                    ,sum(case when CURRT_ALDY_PAYOFF_FLG <> '1' then 1 else 0 end) as term
					,sum(case when PRIC_STATUS_CD = '10' then 1 else 0 end) as ovdterm
					,sum(RPBL_PRIC_PNLT) as RPBL_PRIC_PNLT
					,sum(RPBL_INT_PNLT) as RPBL_INT_PNLT
					,sum(case when to_date('${batch_date}', 'yyyymmdd') >= exp_dt - 1 then nvl(rpbl_int,0) - nvl(paid_int,0) else 0 end) as ljys
               from ${iml_schema}.agt_wyd_repay_plan
			   where etl_dt = to_date('${batch_date}', 'yyyymmdd')
			     and job_cd ='icmsf1'
			   group by dubil_id
            ) t4
   on t1.dubil_id = t4.dubil_id
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
   on t5.curr_cd = 'CNY'
  and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t5.job_cd ='ncbsf1'
  LEFT JOIN (select t1.cust_num, t2.belong_indus_acct
               from ${iol_schema}.eifs_t00_party_pub_info t1
             left join ${iol_schema}.eifs_t01_corp_cust_info t2
               on t1.party_id = t2.party_id
              and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
            ) t6
   on t1.cust_id = t6.cust_num
  left join (select t1.cust_id,sum(t1.nmal_amt) as nmal_amt
             from (
             select t1.cust_id,sum(t1.crdt_lmt)as nmal_amt
               from ${iml_schema}.agt_wyd_lmt_h t1
               left join ${iml_schema}.agt_wyd_out_acct_appl t2
                 on t1.cust_id = t2.cust_id
                and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                and t2.corp_size_cd in ('3','4')
              where t1.lmt_status_cd = '2'
                and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              group by t1.cust_id
             union all
             select cust_id, sum(nmal_amt) as nmal_amt
               from ${iml_schema}.agt_crdt_lmt_info_h
              where lmt_prod_id not in '10000000001' --去掉单一最高授信额度
                and (status_cd = 'Effective' or crdt_nmal_bal > 0) --额度有效或有余额
                and substr(lmt_prod_id, 1, 7) = '1000101' --公司客户自用额度
                and job_cd = 'icmsf1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
              group by cust_id
              ) t1 group by t1.cust_id
            ) t7
   on t7.cust_id = t1.cust_id
   left join (select t1.cust_id,sum(t1.nmal_amt) as nmal_amt
             from (
             select t1.cust_id,sum(t1.crdt_lmt) as nmal_amt
               from ${iml_schema}.agt_wyd_lmt_h t1
               left join ${iml_schema}.agt_wyd_out_acct_appl t2
                 on t1.cust_id = t2.cust_id
                and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               -- and t2.corp_size_cd in ('3','4')
              where t1.lmt_status_cd = '2'
                and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              group by t1.cust_id
             union all
             select cust_id, sum(nmal_amt) as nmal_amt
               from ${iml_schema}.agt_crdt_lmt_info_h
              where lmt_prod_id not in '10000000001' --去掉单一最高授信额度
                and (status_cd = 'Effective' or crdt_nmal_bal > 0) --额度有效或有余额
                and substr(lmt_prod_id, 1, 7) = '1000101' --公司客户自用额度
                and job_cd = 'icmsf1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
              group by cust_id
              ) t1 group by t1.cust_id
            ) t8
   on t8.cust_id = t1.cust_id
 left join ${iol_schema}.icms_wyd_loan t9  
   on t1.dubil_id=t9.lendingref
  and t9.etl_dt =to_date('${batch_date}', 'yyyymmdd')
where 1 = 1
  and t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t2.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
  and t1.prod_id in ('201020100063','203050100002') --微业贷3.0\对公微业贷
;
commit;


-- 第二组（共两组）分期乐
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_ex(
   etl_dt	                             --数据日期
   ,lp_id	                             --法人编号
   ,dubil_id	                         --借据编号
   ,core_dubil_id                        --核心借据编号
   ,cont_id	                             --合同编号
   ,std_prod_id                          --标准产品编号
   ,prod_id	                             --产品编号
   ,cust_id	                             --客户编号
   ,subj_id	                             --科目编号
   ,acctnt_cate_cd                       --会计类别代码
   ,enter_acct_acct_num	                 --入账账号
   ,repay_num	                         --还款账号
   ,rela_agt_id	                         --关联协议编号
   ,rela_appl_flow_num                   --关联申请流水号
   ,curr_cd	                             --币种代码
   ,bus_breed_id	                     --业务品种编号
   ,loan_type_cd	                     --贷款类型代码
	,intnal_loan_type_cd                  --行内贷款类型代码
   ,asset_thd_cls_cd			         --资产三分类代码
   ,dubil_status_cd	                     --借据状态代码
   ,loan_usage_cd	                     --贷款用途代码
   ,dir_indus_cd	                     --投向行业代码
   ,cont_status_cd	                     --合同状态代码
   ,loan_level4_cls_cd	                 --贷款四级分类代码
   ,loan_level5_cls_cd	                 --贷款五级分类代码
   ,loan_level10_cls_cd	                 --贷款十级分类代码
   ,loan_level12_cls_cd	                 --贷款十二级分类代码
   ,acru_non_acru_cd	                 --应计非应计代码
   ,repay_way_cd	                     --还款方式代码
   ,int_set_way_cd	                     --结息方式代码
   ,int_accr_way_cd	                     --计息方式代码
   ,int_rat_adj_way_cd	                 --利率调整方式代码
   ,int_rat_adj_ped_corp_cd	             --利率调整周期单位代码
   ,int_rat_adj_ped_freq	             --利率调整周期频率
   ,int_rat_base_type_cd	             --利率基准类型代码
   ,int_rat_float_way_cd                 --利率浮动方式代码
   ,int_rat_float_dir_cd                 --利率浮动方向代码
   ,int_rat_flo_val                      --利率浮动值
   ,pric_repay_freq_cd	                 --本金还款周期频率
   ,int_repay_freq_cd	                 --利息还款周期频率
   ,guar_way_cd	                         --担保方式代码
   ,cust_char_cd                         --客户性质代码
   ,enter_acct_acct_num_type             --入账账号类型
   ,enter_acct_bank_name                 --入账账户开户银行名称
   ,repay_num_type	                     --还款账号类型
   ,repay_open_acct_bank_id              --还款账户开户银行编号
   ,repay_open_acct_org_name             --还款账户开户机构名称
   ,intnal_carr_flg	                     --内部结转标志
   ,dom_overs_flg	                     --境内外标志
   ,white_list_cust_flg                  --白户标志
   ,farm_flg                             --农户标志
   ,agclt_flg                            --涉农标志
   ,int_accr_flg	                     --计息标志
   ,comp_int_flg	                     --复息标志
   ,ovdue_flg	                         --逾期标志
   ,wrt_off_flg                          --核销标志
   ,pbc_inc_loan_flg                     --人行普惠贷款标志
   ,cred_rht_turn_flg                    --债权直转标志
   ,regroup_flg                          --重组标志
   ,regroup_loan_type_cd                 --重组贷款类型代码
   ,regroup_dt                           --重组日期
   ,open_acct_dt	                     --开户日期
   ,distr_dt	                         --放款日期
   ,init_distr_dt	                     --原始放款日期
   ,value_dt	                         --起息日期
   ,exp_dt	                             --到期日期
   ,init_exp_dt                          --原始到期日期
   ,payoff_dt	                         --结清日期
   ,last_repay_dt	                     --上次还款日期
   ,next_repay_dt	                     --下次还款日期
   ,curr_int_rat_effect_dt	             --当前利率生效日期
   ,next_int_rat_adj_dt	                 --下次利率调整日期
   ,cust_mgr_id	                         --客户经理编号
   ,open_acct_org_id	                 --开户机构编号
   ,mgmt_org_id	                         --管理机构编号
   ,acct_instit_id	                     --账务机构编号
   ,init_tot_perds                       --原始总期数
   ,tot_perds	                         --总期数
   ,curr_issue_perds	                 --本期期数
   ,surp_perds	                         --剩余期数
   ,ovdue_perds	                         --逾期期数
   ,pric_ovdue_days	                     --本金逾期天数
   ,int_ovdue_days	                     --利息逾期天数
   ,grace_period_days	                 --宽限期天数
   ,inst_comm_fee_rat	                 --分期手续费费率
   ,base_rat	                         --基准利率
   ,exec_int_rat	                     --执行利率
   ,ovdue_int_rat	                     --逾期利率
   ,daily_exec_int_rat	                 --每日执行利率
   ,int_rat                              --固收利率
   ,cont_amt	                         --合同金额
   ,dubil_amt	                         --借据金额
   ,distr_amt	                         --放款金额
   ,init_distr_amt	                     --原始放款金额
   ,bank_contri_ratio                    --银行出资比例
   ,td_acru_int	                         --当日应计利息
   ,currt_acru_int	                     --当期应计利息
   ,nomal_pric	                         --正常本金
   ,ovdue_pric	                         --逾期本金
   ,idle_pric                            --呆滞本金
   ,bad_debt_pric                        --呆账本金
   ,wrt_off_pric                         --核销本金
   ,nomal_int	                         --正常利息
   ,ovdue_int	                         --逾期利息
   ,wrt_off_int                          --核销利息
   ,ovdue_pric_pnlt	                     --逾期本金罚息
   ,ovdue_int_pnlt	                     --逾期利息罚息
   ,recvbl_over_int	                     --应收欠息
   ,recvbl_acru_pnlt	                 --应收应计罚息
   ,recvbl_pnlt	                         --应收罚息
   ,recvbl_fee	                         --应收费用
   ,in_bs_over_int_bal	                 --表内欠息余额
   ,off_bs_over_int_bal	                 --表外欠息余额
   ,in_bs_int	                         --表内利息
   ,off_bs_int	                         --表外利息
   ,acm_recvbl_uncol_int_amt	         --累计应收未收利息金额
   ,repaid_nomal_pric	                 --已偿还正常本金
   ,repaid_ovdue_pric	                 --已偿还逾期本金
   ,repaid_nomal_int	                 --已偿还正常利息
   ,repaid_ovdue_int	                 --已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	             --已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	             --已偿还逾期利息罚息
   ,repaid_fee	                         --已偿还费用
   ,pric_bal	                         --本金余额
   ,currt_bal	                         --当期余额
   ,cl_curr_currt_bal	                 --折本币当期余额
   ,job_cd                               --任务代码
   ,etl_timestamp                        --etl处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')                         --数据日期
    ,t1.lp_id                                                       --法人编号
    ,t1.dubil_id                                                    --借据编号
    ,t1.dubil_id                                                    --核心借据编号
    ,t1.cont_id                                                     --合同编号
    ,t1.prod_id                                                     --标准产品编号
    ,t1.prod_id                                                     --产品编号
    ,t1.cust_id                                                     --客户编号
    ,'13030203'                                                     --科目编号
    ,''                                                             --会计类别代码
    ,t1.enter_id                                                    --入账账号
    ,t1.repay_num_id                                                --还款账号
    ,t2.rela_cont_id                                                --关联协议编号
    ,t2.crdt_appl_id                                                --关联申请流水号
    ,t1.curr_cd                                                     --币种代码
    ,t1.prod_id                                                     --业务品种编号
    ,''                                                             --贷款类型代码
	 ,''                                            --行内贷款类型代码
    ,t1.asset_thd_cls_cd                                            --资产三分类代码
    ,decode(t1.loan_status_cd,'01','3','02','1','03','7','04','5','05','1','06','1','0')       --借据状态代码
    ,'019002'                                                       --贷款用途代码
    ,''                                                             --投向行业代码
    ,decode(t2.cont_status_cd,'2','NORMAL','4','CLEAR','-')      --合同状态代码
    ,''                                                             --贷款四级分类代码
    ,t1.loan_level5_cls_cd                                          --贷款五级分类代码
    ,''                                                             --贷款十级分类代码
    ,''                                                             --贷款十二级分类代码
    ,t1.acru_non_acru_idf_cd                                        --应计非应计代码
    ,t1.repay_way_cd                                                --还款方式代码
    ,'01'                                                           --结息方式代码
    ,t1.int_accr_way_cd                                             --计息方式代码
    ,decode(t1.int_rat_adj_way_cd,'7','0','1')                      --利率调整方式代码
    ,t1.int_rat_adj_ped_cd                                          --利率调整周期单位代码
    ,'0'                                                            --利率调整周期频率
    ,t1.base_rat_type_cd                                            --利率基准类型代码
    ,t1.int_rat_float_way_cd                                        --利率浮动方式代码
    ,'-'                                                            --利率浮动方向代码
    ,t1.float_range                                                 --利率浮动值
    ,t1.repay_ped_cd                                                --本金还款频率代码
    ,t1.repay_ped_cd                                                --利息还款频率代码
    ,t1.guar_way_cd                                                 --担保方式代码
    ,'-'                                                            --客户性质代码
    ,t1.enter_type_cd                                               --入账账号类型
    ,t4.recvbl_acct_open_bank_num                                   --入账账户开户银行名称
    ,t1.repay_num_type_cd                                           --还款账号类型
    ,''                                                             --还款账户开户银行编号
    ,''                                                             --还款账户开户机构名称
    ,'-'                                                            --内部结转标志
    ,'-'                                                            --境内外标志
    ,'-'                                                            --白户标志
    ,'-'                                                            --农户标志
    ,'-'                                                            --涉农标志
    ,'1'                                                            --计息标志
    ,'-'                                                            --复息标志
    ,'-'                                                            --逾期标志
    ,t1.wrt_off_status_cd                                           --核销标志
    ,''                                                             --人行普惠贷款标志
    ,'-'                                                            --债权直转标志
    ,'-'                                                            --重组标志
    ,''                                                             --重组贷款类型代码
    ,''                                                             --重组日期
    ,t1.effect_dt                                                   --开户日期
    ,t1.effect_dt                                                   --放款日期
    ,t1.effect_dt                                                   --原始放款日期
    ,t1.effect_dt                                                   --起息日期
    ,t1.exp_dt                                                      --到期日期
    ,t1.exp_dt                                                      --原始到期日期
    ,t1.payoff_dt                                                   --结清日期
    ,''                                                             --上次还款日期
    ,''                                                             --下次还款日期
    ,t1.effect_dt                                                   --当前利率生效日期
    ,''                                                             --下次利率调整日期
    ,t1.rgst_teller_id                                              --客户经理编号
    ,t1.rgst_org_id                                                 --开户机构编号
    ,t1.mgmt_org_id                                                 --管理机构编号
    ,t1.acct_instit_id                                              --账务机构编号
    ,t1.tot_perds                                                   --原始总期数
    ,t1.tot_perds                                                   --总期数
    ,t1.curr_perds                                                  --本期期数
    ,t1.tot_perds-t1.curr_perds                                     --剩余期数
    ,''                                                             --逾期期数
    ,0                                                              --本金逾期天数
    ,0                                                              --利息逾期天数
    ,t1.grace_period                                                --宽限期天数
    ,0                                                              --分期手续费费率
    ,t1.base_rat                                                    --基准利率
    ,t1.exec_int_rat                                                --执行利率
    ,t1.ovdue_int_rat                                               --逾期利率
    ,t1.exec_int_rat                                                --每日执行利率
    ,0                                                              --固收利率
    ,nvl(t2.cont_amt,0)                                           --合同金额
    ,t1.dubil_amt                                                   --借据金额
    ,t1.dubil_amt                                                   --放款金额
    ,t1.dubil_amt                                                   --原始放款金额
    ,t1.bank_contri_ratio                                           --银行出资比例
    ,t1.td_provi_int                                                --当日应计利息
    ,t1.currt_int_bal                                               --当期应计利息
    ,t1.nomal_pric_bal                                              --正常本金
    ,t1.ovdue_pric_bal                                              --逾期本金
    ,0                                                              --呆滞本金
    ,0                                                              --呆账本金
    ,0                                                              --核销本金
    ,t1.currt_int_bal                                               --正常利息
    ,t1.ovdue_int_bal                                               --逾期利息
    ,0                                                              --核销利息
    ,t1.recvbl_pnlt                                                 --逾期本金罚息
    ,0                                                              --逾期利息罚息
    ,0                                                              --应收欠息
    ,t1.recvbl_pnlt                                                 --应收应计罚息
    ,t1.recvbl_pnlt                                                 --应收罚息
    ,0                                                              --应收费用
    ,t1.currt_int_bal+t1.ovdue_int_bal                              --表内欠息余额
    ,0                                                              --表外欠息余额
    ,t1.ovdue_int_bal+t1.pnlt_bal                                   --表内利息
    ,0                                                              --表外利息
    ,t1.currt_int_bal+t1.ovdue_int_bal                              --累计应收未收利息金额
    ,t1.paid_pric                                                   --已偿还正常本金
    ,0                                                               --已偿还逾期本金
    ,t1.paid_int                                                    --已偿还正常利息
    ,0                                                               --已偿还逾期利息
    ,t1.paid_pnlt                                                   --已偿还逾期本金罚息
    ,0                                                               --已偿还逾期利息罚息
    ,0                                                               --已偿还费用
    ,t1.nomal_pric_bal+t1.ovdue_pric_bal                            --本金余额
    ,t1.nomal_pric_bal+t1.ovdue_pric_bal                            --当期余额
    ,(t1.nomal_pric_bal+t1.ovdue_pric_bal) * nvl(t3.convt_cny_exch_rat, 1)          --折本币当期余额
    ,t1.job_cd                                                          --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --etl处理时间戳
 from ${iml_schema}.agt_lx_dubil_info_h t1
 left join ${iml_schema}.agt_lx_loan_cont_info_h t2
   on t1.cont_id = t2.cont_id
  and t2.cont_type_cd = '02' --业务合同
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t2.job_cd ='icmsf1'
 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
   on t3.curr_cd = 'CNY'
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t3.job_cd ='ncbsf1'
 left join ${iml_schema}.agt_lx_out_acct_appl T4		
    on t1.dubil_id = t4.dubil_id	
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd ='icmsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  and t1.job_cd ='icmsf1'
  and t1.payoff_dt >= trunc(to_date('${batch_date}', 'yyyymmdd'), 'yyyy')
;
commit;

whenever sqlerror continue none;
drop table ${icl_schema}.cmm_unite_wl_dubil_info_ex_02 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_unite_wl_dubil_info_ex_02
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_unite_wl_dubil_info where 0=1
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_unite_wl_dubil_info_ex_02(
   etl_dt	                                -- 数据日期
   ,lp_id	                                -- 法人编号
   ,dubil_id	                            -- 借据编号
   ,core_dubil_id                           -- 核心借据编号
   ,cont_id	                                -- 合同编号
   ,std_prod_id                             -- 标准产品编号
   ,prod_id	                                -- 产品编号
   ,cust_id	                                -- 客户编号
   ,subj_id	                                -- 科目编号
   ,acctnt_cate_cd                          -- 会计类别代码
   ,enter_acct_acct_num	                    -- 入账账号
   ,repay_num	                            -- 还款账号
   ,rela_agt_id	                            -- 关联协议编号
   ,rela_appl_flow_num                      -- 关联申请流水号
   ,curr_cd	                                -- 币种代码
   ,bus_breed_id	                        -- 业务品种编号
   ,loan_type_cd	                        -- 贷款类型代码
   ,intnal_loan_type_cd                     -- 行内贷款类型代码
   ,asset_thd_cls_cd                        -- 资产三分类代码
   ,dubil_status_cd	                        -- 借据状态代码
   ,loan_usage_cd	                        -- 贷款用途代码
   ,dir_indus_cd	                        -- 投向行业代码
   ,cont_status_cd	                        -- 合同状态代码
   ,loan_level4_cls_cd	                    -- 贷款四级分类代码
   ,loan_level5_cls_cd	                    -- 贷款五级分类代码
   ,loan_level10_cls_cd	                    -- 贷款十级分类代码
   ,loan_level12_cls_cd	                    -- 贷款十二级分类代码
   ,acru_non_acru_cd	                    -- 应计非应计代码
   ,repay_way_cd	                        -- 还款方式代码
   ,int_set_way_cd	                        -- 结息方式代码
   ,int_accr_way_cd	                        -- 计息方式代码
   ,int_rat_adj_way_cd	                    -- 利率调整方式代码
   ,int_rat_adj_ped_corp_cd	                -- 利率调整周期单位代码
   ,int_rat_adj_ped_freq	                -- 利率调整周期频率
   ,int_rat_base_type_cd	                -- 利率基准类型代码
   ,int_rat_float_way_cd                    -- 利率浮动方式代码
   ,int_rat_float_dir_cd                    -- 利率浮动方向代码
   ,int_rat_flo_val                         -- 利率浮动值
   ,pric_repay_freq_cd	                    -- 本金还款周期频率
   ,int_repay_freq_cd	                    -- 利息还款周期频率
   ,guar_way_cd	                            -- 担保方式代码
   ,cust_char_cd                            -- 客户性质代码
   ,enter_acct_acct_num_type	            -- 入账账号类型
   ,enter_acct_bank_name                    -- 入账账户开户银行名称
   ,repay_num_type	                        -- 还款账号类型
   ,repay_open_acct_bank_id                 -- 还款账户开户银行编号
   ,repay_open_acct_org_name                -- 还款账户开户机构名称
   ,intnal_carr_flg	                        -- 内部结转标志
   ,dom_overs_flg	                        -- 境内外标志
   ,white_list_cust_flg                     -- 白户标志
   ,farm_flg                                -- 农户标志
   ,agclt_flg                               -- 涉农标志
   ,int_accr_flg	                        -- 计息标志
   ,comp_int_flg	                        -- 复息标志
   ,ovdue_flg	                            -- 逾期标志
   ,wrt_off_flg                             -- 核销标志
   ,pbc_inc_loan_flg                        -- 人行普惠贷款标志
   ,cred_rht_turn_flg                       -- 债权直转标志
   ,regroup_flg                             -- 重组标志
   ,regroup_loan_type_cd                    -- 重组贷款类型代码
   ,regroup_dt                              -- 重组日期
   ,open_acct_dt	                        -- 开户日期
   ,distr_dt	                            -- 放款日期
   ,init_distr_dt	                        -- 原始放款日期
   ,value_dt	                            -- 起息日期
   ,exp_dt	                                -- 到期日期
   ,init_exp_dt                             -- 原始到期日期
   ,payoff_dt	                            -- 结清日期
   ,last_repay_dt	                        -- 上次还款日期
   ,next_repay_dt	                        -- 下次还款日期
   ,curr_int_rat_effect_dt	                -- 当前利率生效日期
   ,next_int_rat_adj_dt	                    -- 下次利率调整日期
   ,cust_mgr_id	                            -- 客户经理编号
   ,open_acct_org_id	                    -- 开户机构编号
   ,mgmt_org_id	                            -- 管理机构编号
   ,acct_instit_id	                        -- 账务机构编号
   ,init_tot_perds                          -- 原始总期数
   ,tot_perds	                            -- 总期数
   ,curr_issue_perds	                    -- 本期期数
   ,surp_perds	                            -- 剩余期数
   ,ovdue_perds	                            -- 逾期期数
   ,pric_ovdue_flg                          -- 本金逾期标志
   ,int_ovdue_flg                           -- 利息逾期标志
   ,pric_ovdue_days	                        -- 本金逾期天数
   ,int_ovdue_days	                        -- 利息逾期天数
   ,grace_period_days	                    -- 宽限期天数
   ,inst_comm_fee_rat	                    -- 分期手续费费率
   ,base_rat	                            -- 基准利率
   ,exec_int_rat	                        -- 执行利率
   ,ovdue_int_rat	                        -- 逾期利率
   ,daily_exec_int_rat	                    -- 每日执行利率
   ,int_rat                                 -- 固收利率
   ,cont_amt	                            -- 合同金额
   ,dubil_amt	                            -- 借据金额
   ,distr_amt	                            -- 放款金额
   ,init_distr_amt	                        -- 原始放款金额
   ,bank_contri_ratio                       -- 银行出资比例
   ,td_acru_int	                            -- 当日应计利息
   ,currt_acru_int	                        -- 当期应计利息
   ,nomal_pric	                            -- 正常本金
   ,ovdue_pric	                            -- 逾期本金
   ,idle_pric                               -- 呆滞本金
   ,bad_debt_pric						    -- 呆账本金
   ,wrt_off_pric						    -- 核销本金
   ,nomal_int	                            -- 正常利息
   ,ovdue_int	                            -- 逾期利息
   ,wrt_off_int                             -- 核销利息
   ,ovdue_pric_pnlt	                        -- 逾期本金罚息
   ,ovdue_int_pnlt	                        -- 逾期利息罚息
   ,recvbl_over_int	                        -- 应收欠息
   ,recvbl_acru_pnlt	                    -- 应收应计罚息
   ,recvbl_pnlt	                            -- 应收罚息
   ,recvbl_fee	                            -- 应收费用
   ,in_bs_over_int_bal	                    -- 表内欠息余额
   ,off_bs_over_int_bal	                    -- 表外欠息余额
   ,in_bs_int	                            -- 表内利息
   ,off_bs_int	                            -- 表外利息
   ,acm_recvbl_uncol_int_amt	            -- 累计应收未收利息金额
   ,repaid_nomal_pric	                    -- 已偿还正常本金
   ,repaid_ovdue_pric	                    -- 已偿还逾期本金
   ,repaid_nomal_int	                    -- 已偿还正常利息
   ,repaid_ovdue_int	                    -- 已偿还逾期利息
   ,repaid_ovdue_pric_pnlt	                -- 已偿还逾期本金罚息
   ,repaid_ovdue_int_pnlt	                -- 已偿还逾期利息罚息
   ,repaid_fee	                            -- 已偿还费用
   ,pric_bal	                            -- 本金余额
   ,currt_bal	                            -- 当期余额
   ,cl_curr_currt_bal	                    -- 折本币当期余额
   ,ear_d_bal	                            -- 日初余额
   ,ear_m_bal	                            -- 月初余额
   ,ear_s_bal	                            -- 季初余额
   ,ear_y_bal	                            -- 年初余额
   ,y_acm_bal	                            -- 年累计余额
   ,s_acm_bal	                            -- 季累计余额
   ,m_acm_bal	                            -- 月累计余额
   ,cl_curr_ear_d_bal	                    -- 折本币日初余额
   ,cl_curr_ear_m_bal	                    -- 折本币月初余额
   ,cl_curr_ear_s_bal	                    -- 折本币季初余额
   ,cl_curr_ear_y_bal	                    -- 折本币年初余额
   ,cl_curr_y_acm_bal	                    -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal	                -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal	                -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal	                -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal	                -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal	                    -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal	                -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal	                -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal	                -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal	                    -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal	                -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal	                -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal	                -- 折本币年初月累计余额
   ,y_avg_bal        	                    -- 年日均余额
   ,q_avg_bal        	                    -- 季日均余额
   ,m_avg_bal        	                    -- 月日均余额
   ,cl_curr_y_avg_bal	                    -- 折本币年日均余额
   ,cl_curr_q_avg_bal	                    -- 折本币季日均余额
   ,cl_curr_m_avg_bal	                    -- 折本币月日均余额
   ,job_cd                                  -- 任务代码
   ,etl_timestamp                           -- etl处理时间戳
)
select
	t1.etl_dt	                                -- 数据日期
   ,t1.lp_id	                                -- 法人编号
   ,t1.dubil_id	                                -- 借据编号
   ,t1.core_dubil_id                            -- 核心借据编号
   ,t1.cont_id	                                -- 合同编号
   ,t1.std_prod_id                              -- 标准产品编号
   ,t1.prod_id	                                -- 产品编号
   ,t1.cust_id	                                -- 客户编号
   ,t1.subj_id	                                -- 科目编号
   ,t1.acctnt_cate_cd                           -- 会计类别代码
   ,t1.enter_acct_acct_num	                    -- 入账账号
   ,t1.repay_num	                            -- 还款账号
   ,t1.rela_agt_id	                            -- 关联协议编号
   ,t1.rela_appl_flow_num                       -- 关联申请流水号
   ,t1.curr_cd	                                -- 币种代码
   ,t1.bus_breed_id	                            -- 业务品种编号
   ,t1.loan_type_cd	                            -- 贷款类型代码
   ,t1.intnal_loan_type_cd                      -- 行内贷款类型代码
   ,t1.asset_thd_cls_cd	                        -- 资产三分类代码
   ,t1.dubil_status_cd	                        -- 借据状态代码
   ,t1.loan_usage_cd	                        -- 贷款用途代码
   ,t1.dir_indus_cd	                            -- 投向行业代码
   ,t1.cont_status_cd	                        -- 合同状态代码
   ,t1.loan_level4_cls_cd	                    -- 贷款四级分类代码
   ,t1.loan_level5_cls_cd	                    -- 贷款五级分类代码
   ,t1.loan_level10_cls_cd	                    -- 贷款十级分类代码
   ,t1.loan_level12_cls_cd	                    -- 贷款十二级分类代码
   ,t1.acru_non_acru_cd	                        -- 应计非应计代码
   ,t1.repay_way_cd	                            -- 还款方式代码
   ,t1.int_set_way_cd	                        -- 结息方式代码
   ,t1.int_accr_way_cd	                        -- 计息方式代码
   ,t1.int_rat_adj_way_cd                       -- 利率调整方式代码
   ,t1.int_rat_adj_ped_corp_cd	                -- 利率调整周期单位代码
   ,t1.int_rat_adj_ped_freq	                    -- 利率调整周期频率
   ,t1.int_rat_base_type_cd	                    -- 利率基准类型代码
   ,t1.int_rat_float_way_cd                     -- 利率浮动方式代码
   ,t1.int_rat_float_dir_cd                     -- 利率浮动方向代码
   ,t1.int_rat_flo_val                          -- 利率浮动值
   ,t1.pric_repay_freq_cd	                    -- 本金还款频率代码
   ,t1.int_repay_freq_cd	                    -- 利息还款频率代码
   ,t1.guar_way_cd	                            -- 担保方式代码
   ,t1.cust_char_cd                             -- 客户性质代码
   ,t1.enter_acct_acct_num_type	                -- 入账账号类型
   ,t1.enter_acct_bank_name                     -- 入账账户开户银行名称
   ,t1.repay_num_type	                        -- 还款账号类型
   ,t1.repay_open_acct_bank_id                  -- 还款账户开户银行编号
   ,t1.repay_open_acct_org_name                 -- 还款账户开户机构名称
   ,t1.intnal_carr_flg	                        -- 内部结转标志
   ,t1.dom_overs_flg	                        -- 境内外标志
   ,t1.white_list_cust_flg                      -- 白户标志
   ,t1.farm_flg                                 -- 农户标志
   ,t1.agclt_flg                                -- 涉农标志
   ,t1.int_accr_flg	                            -- 计息标志
   ,t1.comp_int_flg	                            -- 复息标志
   ,t1.ovdue_flg	                            -- 逾期标志
   ,t1.wrt_off_flg                              -- 核销标志
   ,t1.pbc_inc_loan_flg                         -- 人行普惠贷款标志
   ,t1.cred_rht_turn_flg                        -- 债权直转标志
   ,t1.regroup_flg                              -- 重组标志
   ,t1.regroup_loan_type_cd                     -- 重组贷款类型代码
   ,t1.regroup_dt                               -- 重组日期
   ,t1.open_acct_dt	                            -- 开户日期
   ,t1.distr_dt	                                -- 放款日期
   ,t1.init_distr_dt	                        -- 原始放款日期
   ,t1.value_dt	                                -- 起息日期
   ,t1.exp_dt	                                -- 到期日期
   ,t1.init_exp_dt                              -- 原始到期日期
   ,t1.payoff_dt	                            -- 结清日期
   ,t1.last_repay_dt	                        -- 上次还款日期
   ,t1.next_repay_dt	                        -- 下次还款日期
   ,t1.curr_int_rat_effect_dt	                -- 当前利率生效日期
   ,t1.next_int_rat_adj_dt	                    -- 下次利率调整日期
   ,t1.cust_mgr_id	                            -- 客户经理编号
   ,t1.open_acct_org_id	                        -- 开户机构编号
   ,t1.mgmt_org_id	                            -- 管理机构编号
   ,t1.acct_instit_id	                        -- 账务机构编号
   ,t1.init_tot_perds                           -- 原始总期数
   ,t1.tot_perds	                            -- 总期数
   ,t1.curr_issue_perds	                        -- 本期期数
   ,t1.surp_perds	                            -- 剩余期数
   ,t1.ovdue_perds	                            -- 逾期期数
   ,(case when t1.pric_ovdue_days	> 0 then '1' else '0' end) -- 本金逾期标志
   ,(case when t1.int_ovdue_days  > 0 then '1' else '0' end) -- 利息逾期标志
   ,t1.pric_ovdue_days	                        -- 本金逾期天数
   ,t1.int_ovdue_days	                        -- 利息逾期天数
   ,t1.grace_period_days	                    -- 宽限期天数
   ,t1.inst_comm_fee_rat	                    -- 分期手续费费率
   ,t1.base_rat                                 -- 基准利率
   ,t1.exec_int_rat	                            -- 执行利率
   ,t1.ovdue_int_rat                            -- 逾期利率
   ,t1.daily_exec_int_rat                       -- 每日执行利率
   ,t1.int_rat                                  -- 固收利率
   ,t1.cont_amt	                                -- 合同金额
   ,t1.dubil_amt	                            -- 借据金额
   ,t1.distr_amt	                            -- 放款金额
   ,t1.init_distr_amt	                        -- 原始放款金额
   ,t1.bank_contri_ratio                        -- 银行出资比例
   ,t1.td_acru_int	                            -- 当日应计利息
   ,t1.currt_acru_int	                        -- 当期应计利息
   ,t1.nomal_pric	                            -- 正常本金
   ,t1.ovdue_pric	                            -- 逾期本金
   ,t1.idle_pric								-- 呆滞本金
   ,t1.bad_debt_pric                            -- 呆账本金
   ,t1.wrt_off_pric                             -- 核销本金
   ,t1.nomal_int	                            -- 正常利息
   ,t1.ovdue_int	                            -- 逾期利息
   ,t1.wrt_off_int                              -- 核销利息
   ,t1.ovdue_pric_pnlt	                        -- 逾期本金罚息
   ,t1.ovdue_int_pnlt	                        -- 逾期利息罚息
   ,t1.recvbl_over_int	                        -- 应收欠息
   ,t1.recvbl_acru_pnlt	                        -- 应收应计罚息
   ,t1.recvbl_pnlt	                            -- 应收罚息
   ,t1.recvbl_fee	                            -- 应收费用
   ,t1.in_bs_over_int_bal	                    -- 表内欠息余额
   ,t1.off_bs_over_int_bal	                    -- 表外欠息余额
   ,t1.in_bs_int	                            -- 表内利息
   ,t1.off_bs_int	                            -- 表外利息
   ,t1.acm_recvbl_uncol_int_amt	                -- 累计应收未收利息金额
   ,t1.repaid_nomal_pric	                    -- 已偿还正常本金
   ,t1.repaid_ovdue_pric	                    -- 已偿还逾期本金
   ,t1.repaid_nomal_int	                        -- 已偿还正常利息
   ,t1.repaid_ovdue_int	                        -- 已偿还逾期利息
   ,t1.repaid_ovdue_pric_pnlt	                -- 已偿还逾期本金罚息
   ,t1.repaid_ovdue_int_pnlt	                -- 已偿还逾期利息罚息
   ,t1.repaid_fee	                            -- 已偿还费用
   ,t1.pric_bal	                                -- 本金余额
   ,case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end                                       -- 当期余额
   ,(case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1)	   -- 折本币当期余额
   ,nvl(t2.currt_bal,0)                         -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.currt_bal,0) else nvl(t2.ear_m_bal,0) end                                                                            -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.currt_bal,0) else nvl(t2.ear_s_bal,0) end                                                  -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.currt_bal,0) else nvl(t2.ear_y_bal,0) end                                                                          -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end) else nvl(t2.y_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end                                                                    -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end) else nvl(t2.s_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end                                            -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end) else nvl(t2.m_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end                                                                     -- 月累计余额
   ,nvl(t2.cl_curr_currt_bal,0)                                                                                                                                                   -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_currt_bal,0) else nvl(t2.cl_curr_ear_m_bal,0) end                                                              -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_currt_bal,0) else nvl(t2.cl_curr_ear_s_bal,0) end                                    -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_currt_bal,0) else nvl(t2.cl_curr_ear_y_bal,0) end                                                            -- 折本币年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end                           -- 折本币年累计余额
   ,nvl(t2.cl_curr_y_acm_bal,0)                                                                                                                                                    -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_y_acm_bal,0) else nvl(t2.cl_curr_ear_m_y_acm_bal,0) end                                             -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_y_acm_bal,0) else nvl(t2.cl_curr_ear_s_y_acm_bal,0) end                   -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_y_acm_bal,0) else nvl(t2.cl_curr_ear_y_y_acm_bal,0) end                                           -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end   -- 折本币季累计余额
   ,nvl(t2.cl_curr_s_acm_bal,0)                                                                                                                                                    -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_s_acm_bal,0) else nvl(t2.cl_curr_ear_s_s_acm_bal,0) end                   -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_s_acm_bal,0) else nvl(t2.cl_curr_ear_y_s_acm_bal,0) end                                           -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end                            -- 折本币月累计余额
   ,nvl(t2.cl_curr_m_acm_bal,0)                                                                                                                                                   -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_m_acm_bal,0) else nvl(t2.cl_curr_ear_m_m_acm_bal,0) end                                           -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_m_acm_bal,0) else nvl(t2.cl_curr_ear_y_m_acm_bal,0) end                                         -- 折本币年初月累计余额
   ,(case when substr('${batch_date}',5,4) = '0101' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  else nvl(t2.y_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) 							-- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  else nvl(t2.s_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)    -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  else nvl(t2.m_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  end) / to_number(substr('${batch_date}', 7, 2)) 																					-- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal,0) + (case when t1.wrt_off_flg = '1' then 0 else nvl(t1.currt_bal,0) end)  * nvl(t3.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,t1.job_cd                                    -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')
from ${icl_schema}.cmm_unite_wl_dubil_info_ex t1
left join ${icl_schema}.cmm_unite_wl_dubil_info t2
  on t1.dubil_id = t2.dubil_id
 and t1.lp_id = t2.lp_id
 and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
  on t3.curr_cd = t1.curr_cd
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.id_mark <> 'D'
 and t3.job_cd = 'ncbsf1'
;
commit;

delete from ${icl_schema}.cmm_icl_batch_jnl  where etl_dt = to_date('${batch_date}', 'yyyymmdd') and tab_name = 'cmm_unite_wl_dubil_info_morning';
commit;
whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_icl_batch_jnl(
      etl_dt	                       -- 数据日期
     ,tab_name                         -- 表名
	 ,batch_status                     -- 跑批状态
	 ,batch_tm                         -- 跑批时间
	 ,etl_timestamp                    -- etl处理时间
)
select
   to_date('${batch_date}', 'yyyymmdd')                               -- 跑批日期
   ,'cmm_unite_wl_dubil_info_morning'
   ,1                                                                 -- 跑批状态
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 跑批时间
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间
from dual;
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_unite_wl_dubil_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_unite_wl_dubil_info_ex_02;

-- 3.1 drop ex table


drop table ${icl_schema}.cmm_unite_wl_dubil_info_ex purge;
drop table ${icl_schema}.cmm_unite_wl_dubil_info_ex_02 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_unite_wl_dubil_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);