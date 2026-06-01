/*
Purpose:    共性加工层-贷款产品信息：包括对公信贷类业务产品、额度产品和零售信贷类产品的基础参数、业务参数等产品定义信息，数据来源于综合信贷管理系统（ICMS）
Author:     Sunline/
Usage:      python $ETL_HOME/script/main.py 20221019 icl_cmm_loan_prod_info
Createdate: 20201106
            20220614 翟若平	新增模型
            20221213 温旺清 新增字段【征信宽限期】
Logs:
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_loan_prod_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_loan_prod_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_loan_prod_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_prod_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_loan_prod_info where 0=1;

--零售贷款产品
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_prod_info_ex(
     etl_dt                       -- 数据日期
     ,lp_id                       -- 法人编号
     ,prod_id                     -- 产品编号
     ,prod_name                   -- 产品名称
     ,super_prod_id               -- 上级产品编号
     ,lmt_prod_flg                -- 额度产品标志
     ,prod_status_cd              -- 产品状态代码
     ,in_out_tab_attr_cd          -- 表内外属性代码
     ,prod_effect_dt              -- 产品生效日期
     ,prod_invalid_dt             -- 产品失效日期
     ,prod_edit_id                -- 产品版本编号
     ,cust_type_comb_cd           -- 客户类型组合代码
     ,dom_overs_comb_cd           -- 境内境外组合代码
     ,curr_comb_cd                -- 币种组合代码
     ,repay_way_comb_cd           -- 还款方式组合代码
     ,guar_way_comb_cd            -- 担保方式组合代码
     ,acct_type_cd                -- 账户类型代码
     ,discnt_loan_type_cd         -- 贴现贷款类型代码
     ,repay_amt_ctrl_cd           -- 还款金额控制代码
     ,bf_col_int_flg              -- 前收息标志
     ,lont_loan_tenor             -- 最长贷款期限
     ,shortest_loan_tenor         -- 最短贷款期限
     ,subtn_deduct_flg            -- 持续扣款标志
     ,auto_callbk_flg             -- 自动回收标志
     ,circl_flg                   -- 循环标志
     ,bar_flg                     -- 随借随还标志
     ,int_accr_flg                -- 计息标志
     ,comp_int_flg                -- 复利标志
     ,pnlt_flg                    -- 罚息标志
     ,pnlt_comp_int_flg           -- 罚息的复利标志
     ,comp_int_comp_int_flg       -- 复利的复利标志
     ,renew_flg                   -- 展期标志
     ,max_renew_cnt               -- 最大展期次数
     ,soterm_flg                  -- 缩期标志
     ,max_soterm_cnt              -- 最大缩期次数
     ,grace_period_corp_cd        -- 宽限期单位代码
     ,grace_period                -- 宽限期
     ,crdtc_grace_period	        -- 征信宽限期
     ,sig_distr_flg               -- 单笔发放标志
     ,sig_distr_amt_ctrl_flg      -- 单次发放金额控制标志
     ,sig_distr_max_amt           -- 单次最大发放金额
     ,sig_distr_min_amt           -- 单次最小发放金额
     ,sel_sup_loan_flg            -- 自营贷款标志
     ,syn_loan_char_cd            -- 银团贷款性质代码
     ,int_rat_ped_cd              -- 利率周期代码
     ,lowt_exec_int_rat           -- 最低执行利率
     ,higt_exec_int_rat           -- 最高执行利率
     ,ovdue_int_rat_float_way_cd  -- 逾期利率浮动方式代码
     ,ovdue_int_rat_float_ratio   -- 逾期利率浮动比例
    ,job_cd                       --任务代码
    ,etl_timestamp                --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')      -- 数据日期
      ,t1.lp_id                                 -- 法人编号
      ,t1.prod_id                               -- 产品编号
      ,t1.prod_name                             -- 产品名称
      ,t1.super_prod_id                         -- 上级产品编号
      ,t1.lmt_prod_flg                          -- 额度产品标志
      ,t1.prod_status_cd                        -- 产品状态代码
      ,t1.off_bs_flg                            -- 表内外属性代码
      ,t1.prod_effect_dt                        -- 产品生效日期
      ,t1.prod_invalid_dt                       -- 产品失效日期
      ,t2.edit_id                               -- 产品版本编号
      ,t3.client_type                           -- 客户类型组合代码
      ,t3.inland_offshore                       -- 境内境外组合代码
      ,t3.ccy                                   -- 币种组合代码
      ,t3.sched_mode                            -- 还款方式组合代码
      ,t3.vouchtype                             -- 担保方式组合代码
      ,t3.before_income                         -- 账户类型代码
      ,t3.discounttype                          -- 贴现贷款类型代码
      ,t3.rec_amt_ctl                           -- 还款金额控制代码
      ,t3.acct_type                             -- 前收息标志
      ,t3.maxloanterm                           -- 最长贷款期限
      ,t3.minloanterm                           -- 最短贷款期限
      ,t3.hunting_status                        -- 持续扣款标志
      ,t3.backflag                              -- 自动回收标志
      ,t3.revolve_yn                            -- 循环标志
      ,t3.isloananytime                         -- 随借随还标志
      ,t3.iccycflag                             -- 计息标志
      ,t3.int_penalty                           -- 复利标志
      ,t3.pri_penalty                           -- 罚息标志
      ,t3.od_pri_penalty                        -- 罚息的复利标志
      ,t3.od_int_penalty                        -- 复利的复利标志
      ,t3.extend_flag                           -- 展期标志
      ,t3.max_extend_times                      -- 最大展期次数
      ,t3.shrink_flag                           -- 缩期标志
      ,t3.max_shrink_times                      -- 最大缩期次数
      ,t3.graceperiodwork                       -- 宽限期单位代码
      ,t3.graceperiod                           -- 宽限期
      ,t3.creditgraceperiod                     -- 征信宽限期
      ,t3.singlegrant                           -- 单笔发放标志
      ,t3.oncepaymentflag                       -- 单次发放金额控制标志
      ,t3.oncemaxpayment                        -- 单次最大发放金额
      ,t3.onceminpayment                        -- 单次最小发放金额
      ,t3.propietaryflag                        -- 自营贷款标志
      ,t3.syn_type                              -- 银团贷款性质代码
      ,t3.doyemo                                -- 利率周期代码
      ,t3.lowerexecuterate                      -- 最低执行利率
      ,t3.higherexecuterate                     -- 最高执行利率
      ,t3.overdueratefloattype                  -- 逾期利率浮动方式代码
      ,t3.overdueratefloat                      -- 逾期利率浮动比例
      ,t1.job_cd                                --任务代码
      ,systimestamp    --数据处理时间
  from ${iml_schema}.prd_loan_prod_info_h t1
  left join ${iml_schema}.prd_loan_prod_policy_edit_h t2
     on t1.prod_id = t2.prod_id
    and t2.edit_status_cd = '1'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'icmsf1'
  left join (select pvcc.edit_id,
                   max(decode(ptd.claus_id, 'CLIENT_TYPE', ptd.claus_val))          as client_type,                   -- 客户类型
                   max(decode(ptd.claus_id, 'INLAND_OFFSHORE', ptd.claus_val))      as inland_offshore,               -- 境内境外
                   max(decode(ptd.claus_id, 'ACCT_TYPE', ptd.claus_val))            as acct_type,                     -- 账户类型
                   max(decode(ptd.claus_id, 'BEFORE_INCOME', ptd.claus_val))        as before_income,                 -- 前收息标志
                   max(decode(ptd.claus_id, 'CCY', ptd.claus_val))                  as ccy,                           -- 币种
                   max(decode(ptd.claus_id, 'discountType', ptd.claus_val))         as discounttype,                  -- 贴现贷款类型
                   max(decode(ptd.claus_id, 'doyEmo', ptd.claus_val))               as doyemo,                        -- 利率周期代码
                   max(decode(ptd.claus_id, 'maxLoanTerm', ptd.claus_val))          as maxloanterm,                   -- 最长贷款期限
                   max(decode(ptd.claus_id, 'minLoanTerm', ptd.claus_val))          as minloanterm,                   -- 最短贷款期限
                   max(decode(ptd.claus_id, 'singleGrant', ptd.claus_val))          as singlegrant,                   -- 单笔发放
                   max(decode(ptd.claus_id, 'SCHED_MODE', ptd.claus_val))           as sched_mode,                    -- 贷款还款方式
                   max(decode(ptd.claus_id, 'HUNTING_STATUS', ptd.claus_val))       as hunting_status,                -- 持续扣款标志
                   max(decode(ptd.claus_id, 'backFlag', ptd.claus_val))             as backflag,                      -- 自动回收标志
                   max(decode(ptd.claus_id, 'REC_AMT_CTL', ptd.claus_val))          as rec_amt_ctl,                   -- 还款金额控制
                   max(decode(ptd.claus_id, 'icCycFlag', ptd.claus_val))            as iccycflag,                     -- 计息标志
                   max(decode(ptd.claus_id, 'INT_PENALTY', ptd.claus_val))          as int_penalty,                   -- 计息标志
                   max(decode(ptd.claus_id, 'PRI_PENALTY', ptd.claus_val))          as pri_penalty,                   -- 是否收罚息
                   max(decode(ptd.claus_id, 'OD_PRI_PENALTY', ptd.claus_val))       as od_pri_penalty,                -- 罚息的复利
                   max(decode(ptd.claus_id, 'OD_INT_PENALTY', ptd.claus_val))       as od_int_penalty,                -- 复利的复利
                   max(decode(ptd.claus_id, 'EXTEND_FLAG', ptd.claus_val))          as extend_flag,                   -- 是否允许展期
                   max(decode(ptd.claus_id, 'MAX_EXTEND_TIMES', ptd.claus_val))     as max_extend_times,              -- 最大展期次数
                   max(decode(ptd.claus_id, 'SHRINK_FLAG', ptd.claus_val))          as shrink_flag,                   -- 是否允许缩期
                   max(decode(ptd.claus_id, 'MAX_SHRINK_TIMES', ptd.claus_val))     as max_shrink_times,              -- 最大缩期次数
                   max(decode(ptd.claus_id, 'oncePaymentFlag', ptd.claus_val))      as oncepaymentflag,               -- 单次发放金额控制标志
                   max(decode(ptd.claus_id, 'onceMaxPayment', ptd.claus_val))       as oncemaxpayment,                -- 单次最大发放金额
                   max(decode(ptd.claus_id, 'onceMinPayment', ptd.claus_val))       as onceminpayment,                -- 单次最小发放金额
                   max(decode(ptd.claus_id, 'propietaryFlag', ptd.claus_val))       as propietaryflag,                -- 自营标志
                   max(decode(ptd.claus_id, 'SYN_TYPE', ptd.claus_val))             as syn_type,                      -- 银团贷款性质
                   max(decode(ptd.claus_id, 'asSetThreeTypeCd', ptd.claus_val))     as assetthreetypecd,              -- 业务模式
                   max(decode(ptd.claus_id, 'vouchType', ptd.claus_val))            as vouchtype,                     -- 可选担保方式
                   max(decode(ptd.claus_id, 'REVOLVE_YN', ptd.claus_val))           as revolve_yn,                    -- 是否循环
                   max(decode(ptd.claus_id, 'isLoanAnytime', ptd.claus_val))        as isloananytime,                 -- 是否随借随还
                   max(decode(ptd.claus_id, 'gracePeriodWork', ptd.claus_val))      as graceperiodwork,               -- 宽限期单位
                   max(decode(ptd.claus_id, 'gracePeriod', ptd.claus_val))          as graceperiod,                   -- 宽限期
                   max(decode(ptd.claus_id, 'creditGracePeriod', ptd.claus_val))    as creditgraceperiod,             -- 征信宽限期
                   max(decode(ptd.claus_id, 'lowerExecuteRate', ptd.claus_val))     as lowerexecuterate,              -- 最低执行利率（%）
                   max(decode(ptd.claus_id, 'higherExecuteRate', ptd.claus_val))    as higherexecuterate,             -- 最高执行利率（%）
                   max(decode(ptd.claus_id, 'overdueRateFloatType', ptd.claus_val)) as overdueratefloattype,          -- 逾期利率浮动方式
                   max(decode(ptd.claus_id, 'overdueRateFloat', ptd.claus_val))     as overdueratefloat               -- 逾期利率浮动比例（%）
              from ${iml_schema}.prd_loan_prod_policy_compnt_cfg_h pvcc
             inner join ${iml_schema}.prd_loan_prod_claus_data_h ptd
                on pvcc.claus_id = ptd.claus_id
               and pvcc.edit_id = ptd.edit_id
               and pvcc.compnt_id = ptd.compnt_id
               and ptd.start_dt <= to_date('${batch_date}','yyyymmdd')
               and ptd.end_dt > to_date('${batch_date}','yyyymmdd')
               and ptd.job_cd = 'icmsf1'
             where pvcc.start_dt <= to_date('${batch_date}','yyyymmdd')
               and pvcc.end_dt > to_date('${batch_date}','yyyymmdd')
               and pvcc.job_cd = 'icmsf1'
             group by pvcc.edit_id
        ) t3
    on t2.edit_id = t3.edit_id
  where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and substr(t1.prod_id, 1, 3) in ('201', '202')
  ;

commit;


--对公贷款产品（业务产品和额度产品）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_loan_prod_info_ex(
     etl_dt                       -- 数据日期
     ,lp_id                       -- 法人编号
     ,prod_id                     -- 产品编号
     ,prod_name                   -- 产品名称
     ,super_prod_id               -- 上级产品编号
     ,lmt_prod_flg                -- 额度产品标志
     ,prod_status_cd              -- 产品状态代码
     ,in_out_tab_attr_cd          -- 表内外属性代码
     ,prod_effect_dt              -- 产品生效日期
     ,prod_invalid_dt             -- 产品失效日期
     ,prod_edit_id                -- 产品版本编号
     ,cust_type_comb_cd           -- 客户类型组合代码
     ,dom_overs_comb_cd           -- 境内境外组合代码
     ,curr_comb_cd                -- 币种组合代码
     ,repay_way_comb_cd           -- 还款方式组合代码
     ,guar_way_comb_cd            -- 担保方式组合代码
     ,acct_type_cd                -- 账户类型代码
     ,discnt_loan_type_cd         -- 贴现贷款类型代码
     ,repay_amt_ctrl_cd           -- 还款金额控制代码
     ,bf_col_int_flg              -- 前收息标志
     ,lont_loan_tenor             -- 最长贷款期限
     ,shortest_loan_tenor         -- 最短贷款期限
     ,subtn_deduct_flg            -- 持续扣款标志
     ,auto_callbk_flg             -- 自动回收标志
     ,circl_flg                   -- 循环标志
     ,bar_flg                     -- 随借随还标志
     ,int_accr_flg                -- 计息标志
     ,comp_int_flg                -- 复利标志
     ,pnlt_flg                    -- 罚息标志
     ,pnlt_comp_int_flg           -- 罚息的复利标志
     ,comp_int_comp_int_flg       -- 复利的复利标志
     ,renew_flg                   -- 展期标志
     ,max_renew_cnt               -- 最大展期次数
     ,soterm_flg                  -- 缩期标志
     ,max_soterm_cnt              -- 最大缩期次数
     ,grace_period_corp_cd        -- 宽限期单位代码
     ,grace_period                -- 宽限期
	   ,crdtc_grace_period	      -- 征信宽限期
     ,sig_distr_flg               -- 单笔发放标志
     ,sig_distr_amt_ctrl_flg      -- 单次发放金额控制标志
     ,sig_distr_max_amt           -- 单次最大发放金额
     ,sig_distr_min_amt           -- 单次最小发放金额
     ,sel_sup_loan_flg            -- 自营贷款标志
     ,syn_loan_char_cd            -- 银团贷款性质代码
     ,int_rat_ped_cd              -- 利率周期代码
     ,lowt_exec_int_rat           -- 最低执行利率
     ,higt_exec_int_rat           -- 最高执行利率
     ,ovdue_int_rat_float_way_cd  -- 逾期利率浮动方式代码
     ,ovdue_int_rat_float_ratio   -- 逾期利率浮动比例
    ,job_cd                       --任务代码
    ,etl_timestamp                --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                       -- 数据日期
      ,t1.lp_id                                                  -- 法人编号
      ,t1.prod_id                                                -- 产品编号
      ,t1.prod_name                                              -- 产品名称
      ,t1.super_prod_id                                          -- 上级产品编号
      ,t1.lmt_prod_flg                                           -- 额度产品标志
      ,t1.prod_status_cd                                         -- 产品状态代码
      ,t1.off_bs_flg                                             -- 表内外属性代码
      ,t1.prod_effect_dt                                         -- 产品生效日期
      ,t1.prod_invalid_dt                                        -- 产品失效日期
      ,''                         as prod_edit_id                -- 产品版本编号
      ,t2.cust_type_cd            as cust_type_comb_cd           -- 客户类型组合代码
      ,t2.dom_overs_idf_cd        as dom_overs_comb_cd           -- 境内境外组合代码
      ,t2.curr_cd                 as curr_comb_cd                -- 币种组合代码
      ,t2.repay_way_cd            as repay_way_comb_cd           -- 还款方式组合代码
      ,t2.guar_way_cd             as guar_way_comb_cd            -- 担保方式组合代码
      ,t2.acct_type_cd            as acct_type_cd                -- 账户类型代码
      ,t2.discnt_loan_type_cd     as discnt_loan_type_cd         -- 贴现贷款类型代码
      ,t2.repay_amt_ctrl_flg      as repay_amt_ctrl_cd           -- 还款金额控制代码
      ,t2.adv_col_int_flg         as bf_col_int_flg              -- 前收息标志
      ,t2.lont_loan_mon_tenor     as lont_loan_tenor             -- 最长贷款期限
      ,t2.shortest_loan_mon_tenor as shortest_loan_tenor         -- 最短贷款期限
      ,t2.subtn_deduct_flg        as subtn_deduct_flg            -- 持续扣款标志
      ,t2.auto_callbk_flg         as auto_callbk_flg             -- 自动回收标志
      ,t2.circl_flg               as circl_flg                   -- 循环标志
      ,''                         as bar_flg                     -- 随借随还标志
      ,t2.int_accr_flg            as int_accr_flg                -- 计息标志
      ,t2.c_comp_int_flg          as comp_int_flg                -- 复利标志
      ,t2.c_pnlt_flg              as pnlt_flg                    -- 罚息标志
      ,t2.c_pnlt_comp_int_flg     as pnlt_comp_int_flg           -- 罚息的复利标志
      ,t2.c_comp_int_comp_int_flg as comp_int_comp_int_flg       -- 复利的复利标志
      ,t2.allow_renew_flg         as renew_flg                   -- 展期标志
      ,t2.max_renew_cnt           as max_renew_cnt               -- 最大展期次数
      ,t2.allow_soterm_flg        as soterm_flg                  -- 缩期标志
      ,t2.max_soterm_cnt          as max_soterm_cnt              -- 最大缩期次数
      ,'01'                       as grace_period_corp_cd        -- 宽限期单位代码
      ,t2.grace_days              as grace_period                -- 宽限期
      ,''                         as crdtc_grace_period          -- 征信宽限期
      ,t2.sig_distr_flg           as sig_distr_flg               -- 单笔发放标志
      ,t2.sig_distr_amt_ctrl_flg  as sig_distr_amt_ctrl_flg      -- 单次发放金额控制标志
      ,t2.sig_max_distr_amt       as sig_distr_max_amt           -- 单次最大发放金额
      ,t2.sig_min_distr_amt       as sig_distr_min_amt           -- 单次最小发放金额
      ,t2.sel_sup_flg             as sel_sup_loan_flg            -- 自营贷款标志
      ,t2.syn_loan_char_cd        as syn_loan_char_cd            -- 银团贷款性质代码
      ,'y'                        as int_rat_ped_cd              -- 利率周期代码
      ,t2.min_annual_int_rat      as lowt_exec_int_rat           -- 最低执行利率
      ,t2.max_annual_int_rat      as higt_exec_int_rat           -- 最高执行利率
      ,''                         as ovdue_int_rat_float_way_cd  -- 逾期利率浮动方式代码
      ,''                         as ovdue_int_rat_float_ratio   -- 逾期利率浮动比例
      ,t1.job_cd                                --任务代码
      ,systimestamp    --数据处理时间
  from ${iml_schema}.prd_loan_prod_info_h t1
  left join ${iml_schema}.prd_loan_prod_attach_info_h t2
     on t1.prod_id = t2.prod_id
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
    and t2.job_cd = 'icmsf1'
  where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'icmsf1'
  and substr(t1.prod_id, 1, 3) not in ('201', '202')
  ;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_loan_prod_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_loan_prod_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_loan_prod_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => 'icl',tabname => 'cmm_loan_prod_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);