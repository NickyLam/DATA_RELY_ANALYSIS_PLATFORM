/*
Purpose:    共性加工层-票据转贴现信息
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20220928 icl_cmm_bill_discount_info
Createdate: 20220505
Logs:      新票据创建脚本
           20230104 温旺清 修改第一组主表的过滤条件h_data_flg = 'system' -> h_data_flg <> 'system_ht'
           20230214 温旺清 增加字段【贴现人名称】
           20230410 陈伟峰 调整第一组字段【贴现日期】加工逻辑，增加iml.dateformat_min处理
           20230530 陈伟峰 调整bdms_htes_draft_his_info表数据范围，增加“ET05”数据
           20230602 陈伟峰 调整bdms_htes_draft_his_info表数据范围，增加 req_account <> '0' and rcv_account ='0'
           20230714 徐子豪 新增字段【交易对手机构编号】
           20230731 陈伟峰 调整【利息调整金额】加工逻辑，补充计提日期为空的部分利息，当总摊销利息非常小时，票据系统不登记计提日期
           20231030 徐子豪 新增字段【首次买入来源代码、首次交易对手客户编号、首次交易对手名称、首次交易对手联行号】
	       20240112 陈伟峰 调整字段加工逻辑【利息调整余额】
	       20240222 饶雅   新增字段 【源交易方向代码】
	       20240306 陈伟峰 新增字段【价差损益科目编号、价差损益】
	       20240814 陈伟峰 调整价差损益加工逻辑，增加'NTE0026', 'NTE0027', 'SM611204', 'SM611205'
	       20240920 陈伟峰 新增字段【利息收入科目编号】
	       20241206	谢宁   调整本金科目取数逻辑增加兜底条件
	       20250813 陈伟峰 调整余额加工逻辑，当票据状态为结清S14时，余额为0
	       20251105 谢宁    新增字段【经办人编号】
	       20260109 陈伟峰 调整【CURRT_BAL当期余额】加工逻辑，当交易方向为TDD02系统内卖断时余额取为0
                           调整【SUBJ_ID科目编号】加工逻辑，修复系统内转贴现和非系统内转贴现科目映射有误的问题
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bill_discount_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bill_discount_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bill_discount_info_ex purge;
drop table ${icl_schema}.cmm_bill_discount_info_ex01 purge;

whenever sqlerror exit sql.sqlcode;
-- 2.1 insert into ex table
create table ${icl_schema}.cmm_bill_discount_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bill_discount_info where 0=1;

create table ${icl_schema}.cmm_bill_discount_info_ex01 as
select t1.id,
      'BDMX' systid,
      t2.acct_branch_no brchcd,
      case when t2.inner_flag = '1' and t2.busi_type = 'BT01' and T2.trade_direct in ( 'TDD01','TDD02') then 'TYJE006' --银行承兑汇票转贴现面值系统外
           when t2.inner_flag = '0' and t2.busi_type = 'BT01' and t2.trade_direct in ( 'TDD01','TDD02') then 'BDMX003' --银行承兑汇票转贴现面值系统内
           when T2.busi_type in ('BT03', 'BT02') and t2.trade_direct in ('CRD02', 'CRD01') then 'TYJE001' --卖出回购票据_买断式
 --          else t6.sub_no end
           else ' ' end as pric_amt_type,
      case when t2.inner_flag = '1' and t2.busi_type = 'BT01' and t2.trade_direct = 'TDD01' then 'BDMX001' --银行承兑汇票转贴现利息调整系统外
           when t2.inner_flag = '0' and t2.busi_type = 'BT01' and t2.trade_direct = 'TDD01' then 'BDMX004' --银行承兑汇票转贴现利息调整系统内
           else ''
           end as int_amt_type
     ,t5.sub_no as spd_pl_amt_type  --价差调整金额类型
     ,t5.spd_pl as spd_pl  --价差调整
     ,t3.prod_code prod_id
     ,t4.base_prod_id  base_prod_id
 from ${iol_schema}.bdms_cpes_quote_details t1
inner join ${iol_schema}.bdms_cpes_quote_contract t2
   on t2.id = t1.contract_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.bdms_meta_deposit_define t3
   on t2.product_no = t3.product_no
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.prd_prod_catlg_h t4
   on t3.prod_code=t4.prod_id
  and t4.job_cd = 'ncbsf1'
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join (select a.sub_no,a.contract_id,a.detail_id,
                    sum(decode(a.dr_cr, 'D', -a.amount, a.amount)) as spd_pl
               from ${iol_schema}.bdms_bms_trade_detail a
              where a.sub_no in ('BDMX005', 'BDMX002','NTE0026', 'NTE0027', 'SM611204', 'SM611205')
                and trunc(create_time) >=to_date('${year_start}', 'yyyymmdd') and trunc(create_time) <=to_date('${batch_date}', 'yyyymmdd')
              group by a.sub_no,a.contract_id,a.detail_id) t5
   on t5.contract_id=t1.contract_id 
  and t5.detail_id =t1.id
 left join (select t6.contract_id as contract_id
                  ,t6.detail_id   as detail_id
                  ,t6.sub_no as sub_no
                  ,row_number() over(partition by t6.contract_id,t6.detail_id order by t6.etl_dt desc) as rn
              from ${iol_schema}.bdms_bms_trade_detail t6
             where t6.sub_no in ('BDMX003', 'TYJE006','TYJE001')
           )t6
   on t6.contract_id = t1.contract_id
  and t6.detail_id = t1.id
  and t6.rn = 1
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
union all  -- 匿名点击 买入返售票据_质押式 本金CAPTAL
select T1.id,
      'BDMX' systid,
      t2.brh_no brchcd,
      case when t2.busi_type in ('BT02') and t2.trade_direct in ('CRD01', 'CRD02')
           then 'TYJE001' --卖出回购票据_买断式
           else '' end pric_amt_type,
      '' int_amt_type,
      t5.sub_no as spd_pl_amt_type,  --价差调整金额类型
      t5.spd_pl as spd_pl,  --价差调整
      t3.prod_code prod_id,
      t4.base_prod_id  base_prod_id
 from ${iol_schema}.bdms_cpes_anoclick_details t1
inner join ${iol_schema}.bdms_cpes_anoclick_match_contract t2
   on t2.id = t1.match_contract_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.bdms_meta_deposit_define t3
   on t2.product_no = t3.product_no
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.prd_prod_catlg_h t4
   on t3.prod_code=t4.prod_id
  and t4.job_cd = 'ncbsf1'
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join (select a.sub_no,a.contract_id,a.detail_id,
                    sum(decode(a.dr_cr, 'D', -a.amount, a.amount)) as spd_pl
               from ${iol_schema}.bdms_bms_trade_detail a
              where a.sub_no in ('BDMX005', 'BDMX002','NTE0026', 'NTE0027', 'SM611204', 'SM611205')
                and trunc(create_time) >=to_date('${year_start}', 'yyyymmdd') and trunc(create_time) <=to_date('${batch_date}', 'yyyymmdd')
              group by a.sub_no,a.contract_id,a.detail_id) t5
   on t5.contract_id=t1.match_contract_id 
  and t5.detail_id =t1.id
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
union all -- 点击成交 票面captal -- bt01 银行承兑汇票转贴现
select t1.id,
      'BDMX' systid,
      t2.busi_branch_no brchcd,
      case when t2.busi_type in ('BT01') and t2.trade_direct in ('TDD01') then 'TYJE006' --卖出回购票据_买断式
           else '' end pric_amt_type,
      case when t2.busi_type in ('BT01') and t2.trade_direct in ('TDD01') then 'BDMX001' --银行承兑汇票转贴现利息调整系统内
           else '' end int_amt_type,
      t5.sub_no as spd_pl_amt_type,  --价差调整金额类型
      t5.spd_pl as spd_pl,  --价差调整
      t3.prod_code prod_id,
      t4.base_prod_id  base_prod_id
 from ${iol_schema}.bdms_cpes_click_deal_details t1
inner join ${iol_schema}.bdms_cpes_click_deal_contract t2
   on t2.id = t1.contract_id
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.bdms_meta_deposit_define t3
 on t2.product_no = t3.product_no
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.prd_prod_catlg_h t4
   on t3.prod_code=t4.prod_id
  and t4.job_cd = 'ncbsf1'
  and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join (select a.sub_no,a.contract_id,a.detail_id,
                    sum(decode(a.dr_cr, 'D', -a.amount, a.amount)) as spd_pl
               from ${iol_schema}.bdms_bms_trade_detail a
              where a.sub_no in ('BDMX005', 'BDMX002','NTE0026', 'NTE0027', 'SM611204', 'SM611205')
                and trunc(create_time) >=to_date('${year_start}', 'yyyymmdd') and trunc(create_time) <=to_date('${batch_date}', 'yyyymmdd')
              group by a.sub_no,a.contract_id,a.detail_id) t5
   on t5.contract_id=t1.contract_id 
  and t5.detail_id =t1.id
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

--第一组上海票交所转贴现
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_discount_info_ex(
   etl_dt	                                   --数据日期
  ,lp_id	                                   --法人编号
  ,bus_id                                    --业务编号
  ,batch_id                                  --批次编号
  ,std_prod_id                               --标准产品编号
  ,bill_id                                   --票据编号
  ,bill_num                                  --票据号码
  ,bill_sub_intrv_id                         --票据子区间号
  ,subj_id                                   --科目编号
  ,int_adj_subj_id                           --利息调整科目编号
  ,spd_pl_subj_id                            --价差损益科目编号
  ,int_income_subj_id                        --利息收入科目编号
  ,cont_id                                   --合同编号
  ,ctr_nt_id	                               --成交单编号
  ,exp_repo_agt_id                           --到期回购协议编号
  ,bill_cont_id                              --票据合同编号
  ,bill_prod_id                              --票据产品编号
  ,bill_med_cd                               --票据介质代码
  ,bill_kind_cd                              --票据种类代码
  ,draw_dt                                   --出票日期
  ,exp_dt                                    --到期日期
  ,actl_exp_dt                               --实际到期日期
  ,appl_dt                                   --申请日期
  ,bus_dt                                    --业务日期
  ,stl_dt                                    --结算日期
  ,repo_dt                                   --回购日期
  ,actl_repo_dt                              --实际回购日期
  ,curr_cd                                   --币种代码
  ,fac_val_amt                               --票面金额
  ,stl_amt                                   --结算金额
  ,repo_amt                                  --回购金额
  ,int_amt                                   --利息金额
  ,repo_int_amt                              --回购利息金额
  ,discnt_int_rat                            --贴现利率
  ,redem_int_rat                             --赎回利率
  ,currt_bal                                 --当期余额
  ,int_adj_bal                               --利息调整余额
  ,td_acru_int                               --当日应计利息
  ,currt_acru_int                            --当期应计利息
  ,spd_pl                                    --价差损益	
  ,bus_type_cd                               --业务类型代码
  ,asset_thd_cls_cd                          --资产三分类代码
  ,tran_dir_cd                               --交易方向代码
  ,src_tran_dir_cd                           --源交易方向代码
  ,discnt_dt                                 --贴现日期
  ,discnt_ps_unify_soci_crdt_cd_cert         --贴现人统一社会信用代码证
  ,discnt_ps_name                            --贴现人名称
  ,cntpty_id                                 --交易对手编号
  ,cntpty_name                               --交易对手名称
  ,cntpty_bank_no                            --交易对手行号
  ,cntpty_cate_cd                            --交易对手类别代码
  ,cntpty_type_cd                            --交易对手类型代码
  ,cntpty_org_id                             --交易对手机构编号
  ,hxb_acpt_flg                              --我行承兑标志
  ,bill_src_cd                               --票据来源代码
  ,sys_in_flg                                --系统内标志
  ,quot_way_cd                               --报价方式代码
  ,stl_way_cd                                --结算方式代码
  ,lock_flg                                  --锁定标志
  ,hold_days                                 --持票天数
  ,defer_days                                --顺延天数
  ,valid_flg                                 --有效标志
  ,bus_status_cd                             --业务状态代码
  ,entry_status_cd                           --记账状态代码
  ,lmt_id                                    --额度编号
  ,lmt_status_cd                             --额度状态代码
  ,operr_id                                  --经办人编号
  ,cust_mgr_id                               --客户经理编号
  ,dept_id                                   --部门编号
  ,bus_org_id                                --业务机构编号
  ,acct_instit_id                            --账务机构编号
  ,bf_cntpty_flg			                 --前交易对手标志
  ,bf_cntpty_name                            --前交易对手名称
  ,bf_cntpty_type_cd                         --前交易对手类型代码
  ,fir_buy_src_cd                            --首次买入来源代码
  ,fir_cntpty_cust_id                        --首次交易对手客户编号
  ,fir_cntpty_name                           --首次交易对手名称
  ,fir_cntpty_ibank_no                       --首次交易对手联行号
  ,job_cd                                    --任务代码
  ,etl_timestamp                             --etl处理时间戳
)
select
   to_date('${batch_date}', 'yyyymmdd')   as etl_dt                               -- 数据日期
  ,t1.lp_id                               as lp_id                                -- 法人编号
  ,t1.discount_dtl_id                     as bus_id                               -- 业务编号
  ,t1.cont_id                             as batch_id                             -- 批次编号
  ,t8.prod_id                             as std_prod_id                          -- 标准产品编号
  ,t1.bill_id                             as bill_id                              -- 票据编号
  ,t3.bill_num                            as bill_num                             -- 票据号码
  ,t1.bill_sub_intrv_id                   as bill_sub_intrv_id                    -- 票据子区间号
  ,pric.itemcd                            as subj_id                              -- 科目编号
  ,int_adj.itemcd                         as int_adj_subj_id                      -- 利息调整科目编号
  ,spd_adj.itemcd                         as spd_pl_subj_id                       -- 价差损益科目编号
  ,t13.int_bal_pay_subj_id                as int_income_subj_id                   -- 利息收入科目编号
  ,t2.cont_id                             as cont_id                              -- 合同编号
  ,t2.ctr_nt_id	                          as ctr_nt_id                            -- 成交单编号
  ,t11.cont_id                            as exp_repo_agt_id                      -- 到期回购协议编号
  ,t2.cont_id						      as bill_cont_id                         -- 票据合同编号
  ,t2.prod_id                             as bill_prod_id                         -- 票据产品编号
  ,t2.bill_med_cd                         as bill_med_cd                          -- 票据介质代码
  ,t2.bill_type_cd                        as bill_kind_cd                         -- 票据类型代码
  ,t3.draw_dt                             as draw_dt                              -- 出票日期
  ,t1.bill_exp_dt                         as exp_dt                               -- 到期日期
  ,t1.actl_exp_dt                         as actl_exp_dt                          -- 实际到期日期
  ,t2.appl_dt                             as appl_dt                              -- 申请日期
  ,t2.bus_dt                              as bus_dt                               -- 业务日期
  ,t2.stl_dt                              as stl_dt                               -- 结算日期
  ,t2.exp_stl_dt                          as repo_dt                              -- 到期结算日期
  ,t11.bus_dt                             as actl_repo_dt                         -- 实际回购日期
  ,'CNY'                                  as curr_cd                              -- 币种代码
  ,t1.bill_amt                            as fac_val_amt                          -- 票面金额
  ,t1.stl_amt                             as stl_amt                              -- 结算金额
  ,t1.exp_stl_amt                         as repo_amt                             -- 回购金额
  ,t1.int_paybl                           as int_amt                              -- 利息金额
  ,t1.exp_int_paybl                       as repo_int_amt                         -- 回购利息金额
  ,t2.int_rat                             as discnt_int_rat                       -- 利率
  ,t2.exp_int_rat				                  as redem_int_rat                        -- 赎回利率
  ,case when t3.bill_status_cd='S14' then 0
          when t2.trade_direct in('TDD02') then 0
          when (t6.dtl_id is not null
               or (t3.bill_status_cd in  ('S01', 'S06', 'S07')
                  and t1.cont_id not in (select batch_id
                                           from ${iml_schema}.agt_discount_repo_exp_info
                                          where create_dt <= to_date('${batch_date}', 'yyyymmdd')
                                            and entry_status_cd = '03'
                                            and id_mark<>'D'
                                            and job_cd ='bdmsf1' )))
              or (t1.actl_exp_dt <= to_date('${batch_date}', 'yyyymmdd') and t3.bill_status_cd in ('S01', 'S40', 'S31', 'S33')
                  and t3.bill_src_cd = 'SR005' and t3.payoff_flg ='0' and t3.recs_flg in ('1', '2')
                  and t10.bill_num is not null )  --and t12.bill_num is null
         then (case when t2.trade_direct in('TDD01') then t1.bill_amt else t1.stl_amt end)
         else 0 end                        as currt_bal                           -- 当期余额
  ,nvl(t9.int_adj_bal,0)                   as int_adj_bal                         -- 利息调整余额
  ,coalesce(t6.td_provi_int,0)             as td_acru_int                         -- 当日应计利息
  ,coalesce(t6.provied_int,0)              as currt_acru_int                      -- 当期应计利息
  ,tmp.spd_pl                              as spd_pl                              -- 价差损益	
  ,t2.bus_type_cd                          as bus_type_cd                         -- 业务类型代码
  ,t2.asset_thd_cls_cd		                 as asset_thd_cls_cd                    -- 资产三分类代码
  ,t2.tran_dir_cd                          as tran_dir_cd                         -- 交易方向代码
  ,t2.trade_direct                         as src_tran_dir_cd                     -- 源交易方向代码
  ,t12.buss_occ_dt                         as discnt_dt                           -- 贴现日期
  ,t12.req_cert_no                         as discnt_ps_unify_soci_crdt_cd_cert   -- 贴现人统一社会信用代码证
  ,t12.req_name                            as discnt_ps_name                      -- 贴现人名称
  ,t2.cust_id                              as cntpty_id                           -- 交易对手编号
  ,t2.cust_name                            as cntpty_name                         -- 交易对手名称
  ,t2.cust_belong_bank_no                  as cntpty_bank_no                      -- 交易对手行号
  ,t2.org_cate_cd                          as cntpty_cate_cd                      -- 交易对手类别代码
  ,t2.org_lev_cd                           as cntpty_type_cd                      -- 交易对手类型代码
  ,t2.mem_org_cd                           as cntpty_org_id                       -- 交易对手机构编号
  ,t3.hxb_acpt_flg                         as hxb_acpt_flg                        -- 我行承兑标志
  ,t3.bill_src_cd                          as bill_src_cd                         -- 票据来源代码
  ,t2.sys_in_flg                           as sys_in_flg                          -- 系统内标志
  ,''                                      as quot_way_cd                         -- 报价方式代码 源系统该字段无数据，字段未入模型
  ,t2.stl_way_cd                           as stl_way_cd                          -- 结算方式代码
  ,t3.lock_flg                             as lock_flg                            -- 锁定标志
  ,t2.hold_tenor                           as hold_days                           -- 持票天数
  ,t1.actl_exp_dt - t1.bill_exp_dt         as defer_days                          -- 实际到期日期 - 票据到期日期 顺延天数
  ,t1.valid_flg                            as valid_flg                           -- 有效标志
  ,t1.proc_status_cd                       as bus_status_cd                       -- 业务状态代码
  ,t7.entry_status_cd                      as entry_status_cd                     -- 记账状态代码
  ,''                                      as lmt_id                              -- 额度编号 源系统该字段无数据，字段未入模型
  ,t1.lmt_ocup_status_cd                   as lmt_status_cd                       -- 额度状态代码
  ,t2.creator_id                           as operr_id                            -- 经办人编号
  ,case when t40.emply_id is null then t2.cust_mgr_id                                
        else t40.emply_id end              as cust_mgr_id                         -- 客户经理编号
  ,t2.dept_id                              as dept_id                             -- 部门编号
  ,t2.bus_org_id                           as bus_org_id                          -- 业务机构编号
  ,t2.acct_instit_id                       as acct_instit_id                      -- 账务机构编号
  ,case when t2.tran_dir_cd = '01' then '1'	else '0' end						as bf_cntpty_flg      --前交易对手标志
  ,case when t2.tran_dir_cd = '01' then t2.cust_name else null end  as bf_cntpty_name     --前交易对手名称
  ,case when t2.tran_dir_cd = '01' then '25'else null end						as bf_cntpty_type_cd  --前交易对手类型代码
  ,t1.fir_buy_src_cd                       as fir_buy_src_cd                      -- 首次买入来源代码
  ,t1.fir_cntpty_cust_id                   as fir_cntpty_cust_id                  -- 首次交易对手客户编号
  ,t1.fir_cntpty_name                      as fir_cntpty_name                     -- 首次交易对手名称
  ,t1.fir_cntpty_ibank_no                  as fir_cntpty_ibank_no                 -- 首次交易对手联行号
  ,t1.job_cd                               as job_cd                              -- 任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                -- etl处理时间戳
  from ${iml_schema}.agt_bill_discount_dtl t1 --票据转贴现明细
  left join (select  t1.batch_id
                    ,t1.prod_id
                    ,t1.bill_med_cd
                    ,t1.bill_type_cd
                    ,t1.appl_dt
                    ,t1.bus_dt
                    ,t1.stl_dt
                    ,t1.exp_stl_dt
                    ,t1.int_rat
                    ,t1.bus_type_cd
                    ,t1.tran_dir_cd
                    ,t4.trade_direct
                    ,t3.cust_id
                    ,t1.cust_name
                    ,t1.cust_belong_bank_no
                    ,t1.sys_in_flg
                    ,t1.stl_way_cd
                    ,t1.hold_tenor
                    ,t1.cust_mgr_id
                    ,t1.dept_id
                    ,t1.bus_org_id
                    ,t1.acct_instit_id
                    ,t2.org_cate_cd      --机构类别代码
                    ,t2.org_lev_cd       --机构级别代码
                    ,t1.asset_thd_cls_cd --资产三分类代码
                    ,t1.cont_id
                    ,t1.exp_int_rat
                    ,t1.ctr_nt_id	       --成交单编号
                    ,t2.mem_org_cd
					,t1.creator_id as creator_id
               from ${iml_schema}.agt_bill_discount_batch t1 --票据转贴现批次
               left join ${iml_schema}.pty_cpes_mem t2 --票交所会员
               	 on t1.cust_belong_org_id = t2.mem_org_cd
                and t2.job_cd = 'bdmsf1'
                and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t2.id_mark <> 'D'
               left join ${iml_schema}.pty_cust_org_rela_h t3 --cust_mem_brh_rel rel
                 on t3.org_id =t1.cust_belong_org_id
                and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  	            and t3.job_cd = 'bdmsf1'
  	           left join ${iol_schema}.bdms_cpes_quote_contract t4
  	             on t1.batch_id=t4.id
                and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  	          where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
	              and t1.job_cd = 'bdmsf1'
	              and t1.id_mark <> 'D'
                ) t2
  	on t1.cont_id = t2.batch_id
	left join (select t1.rgst_id
                   ,t1.draw_dt
                   ,t1.lock_flg
                   ,t1.bill_src_cd
                   ,t1.hxb_acpt_flg
                   ,t1.bill_status_cd
                   ,t1.discnt_dt
                   ,t1.bill_num
                   ,t1.recs_flg
                   ,t1.payoff_flg
                   ,t1.exp_dt
	             from ${iml_schema}.ref_rgst_cter_bill_info_para t1 --登记中心票据信息参数
  	          where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  	            and t1.job_cd = 'bdmsf1'
	             ) t3
     	  on t1.bill_id = t3.rgst_id
	 left join (select t1.dtl_id
	                  ,t1.batch_id
	                  ,t1.bill_id
	                  ,t1.provied_int --已计提利息
	                  ,t1.surp_int --剩余利息
	                  ,t2.td_provi_int --当日计提利息
					          ,t1.provi_dt
	              from ${iml_schema}.agt_cpes_provi_h t1 --票交所计提历史
	              left join ${iml_schema}.evt_cpes_provi_dtl t2 --票交所计提明细事件
	                on t1.provi_mtbl_id = t2.provi_mtbl_id
	               and t2.entry_sucs_flg = '1' --记账成功标志
	               and t2.entry_dt = to_date('${batch_date}', 'yyyymmdd') --记账日期
	               and t2.job_cd = 'bdmsi1'
	             where t1.job_cd = 'bdmsf1'
	             	 and t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
  	             and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
	             ) t6
     on t1.discount_dtl_id = t6.dtl_id
    and t1.cont_id = t6.batch_id
    and t1.bill_id = t6.bill_id
   left join (select t1.agt_id,t1.agt_status_cd as entry_status_cd
                from ${iml_schema}.agt_status_h t1
               where t1.agt_status_type_cd = 'CD1426'
                 and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                 and t1.job_cd = 'bdmsf1' ) t7
     on t1.agt_id = t7.agt_id
  left join ${iml_schema}.agt_prod_rela_h t8
    on t1.agt_id = t8.agt_id
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   and t8.job_cd = 'bdmsf1'
  left join ${icl_schema}.cmm_bill_discount_info_ex01 tmp
    on t1.discount_dtl_id=tmp.id
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) pric
    on tmp.pric_amt_type = pric.trprcd
   and tmp.base_prod_id = pric.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) int_adj
    on tmp.int_amt_type = int_adj.trprcd
   and tmp.base_prod_id = int_adj.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) spd_adj
    on tmp.spd_pl_amt_type = spd_adj.trprcd
   and tmp.base_prod_id = spd_adj.prodp1
  left join ${iml_schema}.pty_teller_info_h t40
    on t2.cust_mgr_id = t40.teller_id
   and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t40.job_cd ='ncbsf1'
  left join ${iml_schema}.agt_discount_repo_exp_info t11
    on t2.batch_id = t11.batch_id
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <>'D'
   and t11.job_cd ='bdmsf1'
  left join ${iml_schema}.evt_rgst_cter_bill_ccution t10 --${iol_schema}.bdms_dpc_draft_trans_info tr1
    on t10.agt_dtl_id = t1.discount_dtl_id
   and t10.agt_id = t1.cont_id
   and t10.job_cd='bdmsf1'
   and t10.rgst_id in (select max(tr.rgst_id) as tr_id
                         from ${iml_schema}.agt_bill_discount_dtl t--${iol_schema}.bdms_cpes_quote_details   t,
                             ,${iml_schema}.ref_rgst_cter_bill_info_para di --${iol_schema}.bdms_dpc_draft_info       di,
                             ,${iml_schema}.evt_rgst_cter_bill_ccution tr --${iol_schema}.bdms_dpc_draft_trans_info tr
                        where t.bill_id = di.rgst_id
                          and tr.tran_dir_cd = '01'  --买入
                          and tr.tran_status_cd = 'TS0002'   --完成
                          and di.rgst_id = tr.bill_id
                          and t.create_dt <=to_date('${batch_date}', 'yyyymmdd')
                          and t.job_cd='bdmsf1'
                          and t.id_mark<>'D'
                          and di.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                          and di.end_dt >to_date('${batch_date}', 'yyyymmdd')
                          and di.job_cd='bdmsf1'
                          and tr.job_cd ='bdmsf1'
                          and di.bill_src_cd = 'SR005'
                        group by tr.bill_num)
	 and t10.start_dt <=to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt >to_date('${batch_date}', 'yyyymmdd')
  left join (select bill_num
                   ,req_name
                   ,req_cert_no
                   ,buss_occ_dt
                   ,row_number() over(partition by bill_num order by id desc) rn
               from (select id,
                            draft_number bill_num,
                            req_name,
                            req_cert_no as req_cert_no,
                            ${iml_schema}.dateformat_min(buss_occ_dt)  as buss_occ_dt
                       from ${iol_schema}.bdms_htes_draft_his_info
                      where msg_type in ('08','ET05')
                        and req_account <> '0'
                        and rcv_account ='0'
                      union all
                     select to_char(id),
                            electric_draft_id bill_num,
                            req_name,
                            req_brch_code as req_cert_no, --请求方组织机构代码
                            ${iml_schema}.dateformat_min(sign_date) as buss_occ_dt -- 业务发生日期
                       from ${iol_schema}.bdms_bms_endrsmt_info
                      where trans_no like 'E011_02%'
                        and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and end_dt > to_date('${batch_date}', 'yyyymmdd'))
                )t12
    on t3.bill_num  = t12.bill_num
   and t12.rn=1
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.dtl_id               as detail_id
                   ,t1.batch_id             as contract_id
                   ,t2.td_provi_int         as td_acru_int      --当日应计利息
                   ,t1.surp_int             as int_adj_bal      --利息调整余额
                   ,t1.provied_int          as currt_acru_int   --当期应计利息
              from ${iml_schema}.agt_cpes_provi_h t1
              left join ${iml_schema}.evt_cpes_provi_dtl t2
                on t1.provi_mtbl_id = t2.provi_mtbl_id 
               and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               and t2.job_cd = 'bdmsi1'
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 --              and t1.provi_bus_type_cd ='01'
               and t1.provi_status_cd in ('02','03')
               and t1.job_cd = 'bdmsf1') t9
     on t1.discount_dtl_id = t9.detail_id
    and t1.cont_id = t9.contract_id
    and t1.bill_id = t9.bill_id
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t13
    on t8.prod_id = t13.sellbl_prod_id			
   and t13.bus_type_cd = 'BDMX'	
   and t13.etl_dt = to_date('${batch_date}', 'yyyymmdd') 
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t1.job_cd = 'bdmsf1'
	and t1.id_mark <> 'D'
;
commit;
--点击成交
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_discount_info_ex(
   etl_dt	                                       --数据日期
  ,lp_id	                                       --法人编号
  ,bus_id                                        --业务编号
  ,batch_id                                      --批次编号
  ,std_prod_id                                   --标准产品编号
  ,bill_id                                       --票据编号
  ,bill_num                                      --票据号码
  ,bill_sub_intrv_id                             --票据子区间号
  ,subj_id                                       --科目编号
  ,int_adj_subj_id                               --利息调整科目编号
  ,spd_pl_subj_id                                --价差损益科目编号
  ,int_income_subj_id                            --利息收入科目编号
  ,cont_id                                       --合同编号
  ,ctr_nt_id	                                   --成交单编号
  ,exp_repo_agt_id                               --到期回购协议编号
  ,bill_cont_id                                  --票据合同编号
  ,bill_prod_id                                  --票据产品编号
  ,bill_med_cd                                   --票据介质代码
  ,bill_kind_cd                                  --票据种类代码
  ,draw_dt                                       --出票日期
  ,exp_dt                                        --到期日期
  ,actl_exp_dt                                   --实际到期日期
  ,appl_dt                                       --申请日期
  ,bus_dt                                        --业务日期
  ,stl_dt                                        --结算日期
  ,repo_dt                                       --回购日期
  ,actl_repo_dt                                  --实际回购日期
  ,curr_cd                                       --币种代码
  ,fac_val_amt                                   --票面金额
  ,stl_amt                                       --结算金额
  ,repo_amt                                      --回购金额
  ,int_amt                                       --利息金额
  ,repo_int_amt                                  --回购利息金额
  ,discnt_int_rat                                --贴现利率
  ,redem_int_rat                                 --赎回利率
  ,currt_bal                                     --当期余额
  ,int_adj_bal                                   --利息调整余额
  ,td_acru_int                                   --当日应计利息
  ,currt_acru_int                                --当期应计利息
  ,spd_pl                                        --价差损益	
  ,bus_type_cd                                   --业务类型代码
  ,asset_thd_cls_cd                              --资产三分类代码
  ,tran_dir_cd                                   --交易方向代码
  ,src_tran_dir_cd                               --源交易方向代码
  ,discnt_dt                                     --贴现日期
  ,discnt_ps_unify_soci_crdt_cd_cert             --贴现人统一社会信用代码证
  ,discnt_ps_name                                --贴现人名称
  ,cntpty_id                                     --交易对手编号
  ,cntpty_name                                   --交易对手名称
  ,cntpty_bank_no                                --交易对手行号
  ,cntpty_cate_cd                                --交易对手类别代码
  ,cntpty_type_cd                                --交易对手类型代码
  ,cntpty_org_id                                 --交易对手机构编号
  ,hxb_acpt_flg                                  --我行承兑标志
  ,bill_src_cd                                   --票据来源代码
  ,sys_in_flg                                    --系统内标志
  ,quot_way_cd                                   --报价方式代码
  ,stl_way_cd                                    --结算方式代码
  ,lock_flg                                      --锁定标志
  ,hold_days                                     --持票天数
  ,defer_days                                    --顺延天数
  ,valid_flg                                     --有效标志
  ,bus_status_cd                                 --业务状态代码
  ,entry_status_cd                               --记账状态代码
  ,lmt_id                                        --额度编号
  ,lmt_status_cd                                 --额度状态代码
  ,operr_id                                      --经办人编号
  ,cust_mgr_id                                   --客户经理编号
  ,dept_id                                       --部门编号
  ,bus_org_id                                    --业务机构编号
  ,acct_instit_id                                --账务机构编号
  ,bf_cntpty_flg			                           --前交易对手标志
  ,bf_cntpty_name                                --前交易对手名称
  ,bf_cntpty_type_cd                             --前交易对手类型代码
  ,fir_buy_src_cd                                --首次买入来源代码
  ,fir_cntpty_cust_id                            --首次交易对手客户编号
  ,fir_cntpty_name                               --首次交易对手名称
  ,fir_cntpty_ibank_no                           --首次交易对手联行号
  ,job_cd                                        --任务代码
  ,etl_timestamp                                 --etl处理时间戳
)
select
  to_date('${batch_date}', 'yyyymmdd')    as etl_dt                                     -- 数据日期
  ,t1.lp_id                               as lp_id                                      -- 法人编号
  ,t1.dtl_ser_num                         as bus_id                                     -- 业务编号
  ,t1.batch_ser_num                       as batch_id                                   -- 批次编号
  ,t2.std_prod_id                         as std_prod_id                                -- 标准产品编号
  ,t1.bill_ser_num                        as bill_id                                    -- 票据编号
  ,t3.bill_num                            as bill_num                                   -- 票据号码
  ,t3.bill_sub_intrv_id                   as bill_sub_intrv_id                          -- 票据子区间号
  ,pric.itemcd                            as subj_id                                    -- 科目编号
  ,int_adj.itemcd                         as int_adj_subj_id                            -- 利息调整科目编号
  ,spd_adj.itemcd                         as spd_pl_subj_id                             -- 价差损益科目编号
  ,t13.int_bal_pay_subj_id                as int_income_subj_id                         -- 利息收入科目编号
  ,t2.batch_id                            as cont_id                                    -- 合同编号
  ,t1.ctr_nt_id                           as ctr_nt_id	                                -- 成交单编号
  ,null                                   as exp_repo_agt_id                            -- 到期回购协议编号
  ,t2.batch_id                            as bill_cont_id                               -- 票据合同编号
  ,t2.prod_id                             as bill_prod_id                               -- 票据产品编号
  ,t2.bill_attr_cd                        as bill_med_cd                                -- 票据介质代码
  ,t2.bill_type_cd                        as bill_kind_cd                               -- 票据种类代码
  ,t3.draw_dt                             as draw_dt                                    -- 出票日期
  ,t1.bill_exp_dt                         as exp_dt                                     -- 到期日期
  ,t1.actl_exp_dt                         as actl_exp_dt                                -- 实际到期日期
  ,'2999-12-31'                           as appl_dt                                    -- 申请日期
  ,t2.bus_dt                              as bus_dt                                     -- 业务日期
  ,t2.stl_dt                              as stl_dt                                     -- 结算日期
  ,'2999-12-31'                           as repo_dt                                    -- 回购日期
  ,'2999-12-31'                           as actl_repo_dt                               -- 实际回购日期
  ,'CNY'                                  as curr_cd                                    -- 币种代码
  ,case when t3.bill_status_cd<>'S14'                                                   
        then t1.fac_val_amt                                                             
   else 0 end                             as fac_val_amt                                -- 票面金额
  ,t1.stl_amt                             as stl_amt                                    -- 结算金额
  ,0                                      as repo_amt                                   -- 回购金额
  ,t1.int_paybl                           as int_amt                                    -- 利息金额
  ,0                                      as repo_int_amt                               -- 回购利息金额
  ,t2.discnt_int_rat                      as discnt_int_rat                             -- 贴现利率
  ,0                                      as redem_int_rat                              -- 赎回利率
  ,case when t3.bill_status_cd<>'S14'                                                   
        then t1.fac_val_amt                                                             
   else 0 end                             as currt_bal                                  --当期余额
  ,nvl(t9.int_adj_bal,0)                  as int_adj_bal                                --利息调整余额
  ,t6.td_provi_int                        as td_acru_int                                --当日应计利息
  ,t6.provied_int                         as currt_acru_int                             --当期应计利息
  ,tmp.spd_pl                             as spd_pl                                     --价差损益	
  ,t2.bus_type_cd                         as bus_type_cd                                --业务类型代码
  ,t2.asset_thd_cls_cd                    as asset_thd_cls_cd                           --资产三分类代码
  ,t2.tran_dir_cd                         as tran_dir_cd                                --交易方向代码
  ,t11.trade_direct                       as src_tran_dir_cd                            --源交易方向代码
  ,null                                   as discnt_dt                                  --贴现日期
  ,t7.unify_soci_crdt_cd                  as discnt_ps_unify_soci_crdt_cd_cert          --贴现人统一社会信用代码证
  ,t7.org_cate_cd                         as discnt_ps_name                             --贴现人名称
  ,t2.cntpty_org_cd                       as cntpty_id                                  --交易对手编号
  ,t7.org_cn_fname                        as cntpty_name                                --交易对手名称
  ,t7.wdraw_acct_lg_pay_sys_bank_no       as cntpty_bank_no                             --交易对手行号
  ,t7.org_cate_cd                         as cntpty_cate_cd                             --交易对手类别代码
  ,t2.cntpty_type_cd                      as cntpty_type_cd                             --交易对手类型代码
  ,t7.mem_org_cd                          as cntpty_org_id                              --交易对手机构编号
  ,t3.hxb_acpt_flg                        as hxb_acpt_flg                               --我行承兑标志
  ,t3.bill_src_cd                         as bill_src_cd                                --票据来源代码
  ,'1'                                    as sys_in_flg                                 --系统内标志
  ,''                                     as quot_way_cd                                --报价方式代码
  ,t2.stl_way_cd                          as stl_way_cd                                 --结算方式代码
  ,t3.lock_flg                            as lock_flg                                   --锁定标志
  ,t8.hold_days                           as hold_days                                  --持票天数
  ,nvl(to_date(t1.actl_exp_dt, 'yyyymmdd') - to_date(t1.bill_exp_dt, 'yyyymmdd'),0)   as defer_days         --顺延天数
  ,t1.valid_flg                           as valid_flg                                  --有效标志
  ,t2.msg_proc_status_cd                  as bus_status_cd                              --业务状态代码
  ,t1.entry_status_cd                     as entry_status_cd                            --记账状态代码
  ,''                                     as lmt_id                                     --额度编号
  ,t2.ibank_crdt_lmt_ocup_status_cd       as lmt_status_cd                              --额度状态代码
  ,'' as operr_id                                      --经办人编号
  ,t2.cust_mgr_id                         as cust_mgr_id                                --客户经理编号
  ,t2.dept_id                             as dept_id                                    --部门编号
  ,t2.bus_org_id                          as bus_org_id                                 --业务机构编号
  ,t10.fin_org_id                         as acct_instit_id                             --账务机构编号
  ,null                                   as bf_cntpty_flg			                        --前交易对手标志
  ,null                                   as bf_cntpty_name                             --前交易对手名称
  ,null                                   as bf_cntpty_type_cd                          --前交易对手类型代码
  ,t1.fir_buy_src_cd                      as fir_buy_src_cd                             --首次买入来源代码
  ,t1.fir_cntpty_cust_id                  as fir_cntpty_cust_id                         --首次交易对手客户编号
  ,t1.fir_cntpty_name                     as fir_cntpty_name                            --首次交易对手名称
  ,t1.fir_cntpty_ibank_no                 as fir_cntpty_ibank_no                        --首次交易对手联行号
  ,t1.job_cd                                                      as job_cd             --任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')as etl_timestamp      --etl处理时间戳
  from ${iml_schema}.evt_bill_discount_click_bag_dtl t1
  left join ${iml_schema}.evt_bill_discount_click_bag_batch t2
    on t1.batch_ser_num = t2.batch_ser_num
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsi1'
  left join (select t1.rgst_id
                   ,t1.draw_dt
                   ,t1.lock_flg
                   ,t1.bill_src_cd
                   ,t1.hxb_acpt_flg
                   ,t1.bill_status_cd
                   ,t1.discnt_dt
                   ,t1.bill_num
                   ,t1.recs_flg
                   ,t1.payoff_flg
                   ,t1.exp_dt
                   ,t1.bill_sub_intrv_id
	             from ${iml_schema}.ref_rgst_cter_bill_info_para t1 --登记中心票据信息参数
  	          where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  	            and t1.job_cd = 'bdmsf1'
	             ) t3
	  on t1.bill_ser_num = t3.rgst_id
  left join ${icl_schema}.cmm_bill_discount_info_ex01 tmp
    on t1.dtl_ser_num=tmp.id
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) pric
    on tmp.pric_amt_type = pric.trprcd
   and tmp.base_prod_id = pric.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) int_adj
    on tmp.int_amt_type = int_adj.trprcd
   and tmp.base_prod_id = int_adj.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) spd_adj
    on tmp.spd_pl_amt_type = spd_adj.trprcd
   and tmp.base_prod_id = spd_adj.prodp1
  left join (select t1.dtl_id
	                  ,t1.batch_id
	                  ,t1.bill_id
	                  ,t1.provied_int  --已计提利息
	                  ,t1.surp_int     --剩余利息
	                  ,t2.td_provi_int --当日计提利息
					          ,t1.provi_dt
	              from ${iml_schema}.agt_cpes_provi_h t1 --票交所计提历史
	              left join ${iml_schema}.evt_cpes_provi_dtl t2 --票交所计提明细事件
	                on t1.provi_mtbl_id = t2.provi_mtbl_id
	               and t2.entry_sucs_flg = '1' --记账成功标志
	               and t2.entry_dt = to_date('${batch_date}', 'yyyymmdd') --记账日期
	               and t2.job_cd = 'bdmsi1'
	             where t1.job_cd = 'bdmsf1'
	             	 and t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
  	             and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
	             ) t6
    on t1.dtl_ser_num = t6.dtl_id
   and t2.batch_ser_num = t6.batch_id
   and t3.rgst_id = t6.bill_id
  left join ${iml_schema}.pty_cpes_mem t7
    on t2.cntpty_org_cd = t7.mem_org_cd
   and t7.create_dt<= to_date('${batch_date}', 'yyyymmdd')
   and t7.id_mark <> 'D'
   and t7.job_cd ='bdmsf1'
  left join (select t1.bill_id  as bill_id
                   ,t1.dtl_id   as dtl_id
                   ,t1.batch_id as batch_id
                   ,t2.days     as hold_days
               from iml.agt_cpes_provi_h t1
               left join (select t2.provi_mtbl_id,count(1) as days
                            from iml.evt_cpes_provi_dtl t2
                           where t2.entry_sucs_flg = '1'
                             and t2.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
                           group by t2.provi_mtbl_id) t2
                    on t1.provi_mtbl_id = t2.provi_mtbl_id
              where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 	             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')) t8
    on t1.dtl_ser_num = t8.dtl_id
   and t2.batch_ser_num = t8.batch_id
   and t3.rgst_id = t8.bill_id
  left join ${iml_schema}.evt_bill_entry t10
    on t10.cont_id = t2.batch_ser_num
   and t10.bill_id = t3.rgst_id
   and t10.prod_id = t2.prod_id
   and t10.bus_id  = t1.dtl_ser_num
   and t10.etl_Dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.h_data_flg <> 'system_ht'
   and t10.job_cd = 'bdmsi1'
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.dtl_id               as detail_id
                   ,t1.batch_id             as contract_id
                   ,t2.td_provi_int         as td_acru_int      --当日应计利息
                   ,t1.surp_int             as int_adj_bal      --利息调整余额
                   ,t1.provied_int          as currt_acru_int   --当期应计利息
              from ${iml_schema}.agt_cpes_provi_h t1
              left join ${iml_schema}.evt_cpes_provi_dtl t2
                on t1.provi_mtbl_id = t2.provi_mtbl_id 
               and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               and t2.job_cd = 'bdmsi1'
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 --              and t1.provi_bus_type_cd ='01'
               and t1.provi_status_cd in ('02','03')
               and t1.job_cd = 'bdmsf1') t9
    on t1.dtl_ser_num = t9.detail_id
   and t2.batch_ser_num = t9.contract_id
   and t3.rgst_id = t9.bill_id
  left join ${iol_schema}.bdms_cpes_click_deal_contract t11
   on t1.batch_ser_num = t11.id
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t13
    on t2.std_prod_id = t13.sellbl_prod_id			
   and t13.bus_type_cd = 'BDMX'	
   and t13.etl_dt = to_date('${batch_date}', 'yyyymmdd') 
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsi1';
commit;
--匿名点击成交

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_discount_info_ex(
   etl_dt	                                   --数据日期
  ,lp_id	                                   --法人编号
  ,bus_id                                    --业务编号
  ,batch_id                                  --批次编号
  ,std_prod_id                               --标准产品编号
  ,bill_id                                   --票据编号
  ,bill_num                                  --票据号码
  ,bill_sub_intrv_id                         --票据子区间号
  ,subj_id                                   --科目编号
  ,int_adj_subj_id                           --利息调整科目编号
  ,spd_pl_subj_id                            --价差损益科目编号
  ,int_income_subj_id                        --利息收入科目编号
  ,cont_id                                   --合同编号
  ,ctr_nt_id	                               --成交单编号
  ,exp_repo_agt_id                           --到期回购协议编号
  ,bill_cont_id                              --票据合同编号
  ,bill_prod_id                              --票据产品编号
  ,bill_med_cd                               --票据介质代码
  ,bill_kind_cd                              --票据种类代码
  ,draw_dt                                   --出票日期
  ,exp_dt                                    --到期日期
  ,actl_exp_dt                               --实际到期日期
  ,appl_dt                                   --申请日期
  ,bus_dt                                    --业务日期
  ,stl_dt                                    --结算日期
  ,repo_dt                                   --回购日期
  ,actl_repo_dt                              --实际回购日期
  ,curr_cd                                   --币种代码
  ,fac_val_amt                               --票面金额
  ,stl_amt                                   --结算金额
  ,repo_amt                                  --回购金额
  ,int_amt                                   --利息金额
  ,repo_int_amt                              --回购利息金额
  ,discnt_int_rat                            --贴现利率
  ,redem_int_rat                             --赎回利率
  ,currt_bal                                 --当期余额
  ,int_adj_bal                               --利息调整余额
  ,td_acru_int                               --当日应计利息
  ,currt_acru_int                            --当期应计利息
  ,spd_pl                                    --价差损益	
  ,bus_type_cd                               --业务类型代码
  ,asset_thd_cls_cd                          --资产三分类代码
  ,tran_dir_cd                               --交易方向代码
  ,src_tran_dir_cd                           --源交易方向代码
  ,discnt_dt                                 --贴现日期
  ,discnt_ps_unify_soci_crdt_cd_cert         --贴现人统一社会信用代码证
  ,discnt_ps_name                            --贴现人名称
  ,cntpty_id                                 --交易对手编号
  ,cntpty_name                               --交易对手名称
  ,cntpty_bank_no                            --交易对手行号
  ,cntpty_cate_cd                            --交易对手类别代码
  ,cntpty_type_cd                            --交易对手类型代码
  ,cntpty_org_id                             --交易对手机构编号
  ,hxb_acpt_flg                              --我行承兑标志
  ,bill_src_cd                               --票据来源代码
  ,sys_in_flg                                --系统内标志
  ,quot_way_cd                               --报价方式代码
  ,stl_way_cd                                --结算方式代码
  ,lock_flg                                  --锁定标志
  ,hold_days                                 --持票天数
  ,defer_days                                --顺延天数
  ,valid_flg                                 --有效标志
  ,bus_status_cd                             --业务状态代码
  ,entry_status_cd                           --记账状态代码
  ,lmt_id                                    --额度编号
  ,lmt_status_cd                             --额度状态代码
  ,operr_id                                      --经办人编号
  ,cust_mgr_id                               --客户经理编号
  ,dept_id                                   --部门编号
  ,bus_org_id                                --业务机构编号
  ,acct_instit_id                            --账务机构编号
  ,bf_cntpty_flg			                       --前交易对手标志
  ,bf_cntpty_name                            --前交易对手名称
  ,bf_cntpty_type_cd                         --前交易对手类型代码
  ,fir_buy_src_cd                            --首次买入来源代码
  ,fir_cntpty_cust_id                        --首次交易对手客户编号
  ,fir_cntpty_name                           --首次交易对手名称
  ,fir_cntpty_ibank_no                       --首次交易对手联行号
  ,job_cd                                    --任务代码
  ,etl_timestamp                             --etl处理时间戳
)
select
  to_date('${batch_date}', 'yyyymmdd')    as etl_dt                                    --数据日期
  ,t1.lp_id                               as lp_id                                     --法人编号
  ,t1.match_dtl_ser_num                   as bus_id                                    --业务编号
  ,t1.match_batch_ser_num                 as batch_id                                  --批次编号
  ,t2.std_prod_id                         as std_prod_id                               --标准产品编号
  ,t1.bill_ser_num                        as bill_id                                   --票据编号
  ,t3.bill_num                            as bill_num                                  --票据号码
  ,t3.bill_sub_intrv_id                   as bill_sub_intrv_id                         --票据子区间号
  ,pric.itemcd                            as subj_id                                   --科目编号
  ,int_adj.itemcd                         as int_adj_subj_id                           --利息调整科目编号
  ,spd_adj.itemcd                         as spd_pl_subj_id                            -- 价差损益科目编号
  ,t13.int_bal_pay_subj_id                as int_income_subj_id                        -- 利息收入科目编号
  ,t2.match_batch_id                      as cont_id                                   --合同编号
  ,t2.ctr_nt_id                           as ctr_nt_id	                               --成交单编号
  ,null                                   as exp_repo_agt_id                           --到期回购协议编号
  ,t2.match_batch_id                      as bill_cont_id                              --票据合同编号
  ,t2.prod_id                             as bill_prod_id                              --票据产品编号
  ,t2.bill_attr_cd                        as bill_med_cd                               --票据介质代码
  ,t2.bill_type_cd                        as bill_kind_cd                              --票据种类代码
  ,t3.draw_dt                             as draw_dt                                   --出票日期
  ,t1.bill_exp_dt                         as exp_dt                                    --到期日期
  ,t1.actl_exp_dt                         as actl_exp_dt                               --实际到期日期
  ,'0001-01-01'                           as appl_dt                                   --申请日期
  ,t2.bag_tm                              as bus_dt                                    --业务日期
  ,t2.fst_stl_dt                          as stl_dt                                    --结算日期
  ,'0001-01-01'                           as repo_dt                                   --回购日期
  ,'0001-01-01'                           as actl_repo_dt                              --实际回购日期
  ,'CNY'                                  as curr_cd                                   --币种代码
  ,case when t3.bill_status_cd<>'S14' then t1.fac_val_amt else 0 end  as fac_val_amt   --票面金额
  ,t1.stl_amt                             as stl_amt                                   --结算金额
  ,null                                   as repo_amt                                  --回购金额
  ,t1.int_paybl                           as int_amt                                   --利息金额
  ,null                                   as repo_int_amt                              --回购利息金额
  ,t2.repo_int_rat                        as discnt_int_rat                            --贴现利率
  ,0                                      as redem_int_rat                             --赎回利率
  ,t1.fac_val_amt                         as currt_bal                                 --当期余额
  ,nvl(t9.int_adj_bal,0)                  as int_adj_bal                               --利息调整余额
  ,t6.td_provi_int                        as td_acru_int                               --当日应计利息
  ,t6.provied_int                         as currt_acru_int                            --当期应计利息
  ,tmp.spd_pl                             as spd_pl                                    -- 价差损益	
  ,t2.bus_type_cd                         as bus_type_cd                               --业务类型代码
  ,null                                   as asset_thd_cls_cd                          --资产三分类代码
  ,t2.tran_dir_cd                         as tran_dir_cd                               --交易方向代码
  ,t11.trade_direct                       as src_tran_dir_cd                           --源交易方向代码
  ,trunc(t2.bag_tm)                       as discnt_dt                                 --贴现日期
  ,t7.unify_soci_crdt_cd                                as discnt_ps_unify_soci_crdt_cd_cert --贴现人统一社会信用代码证
  ,t7.org_cate_cd                                       as discnt_ps_name             --贴现人名称
  ,t2.cntpty_org_id                                     as cntpty_id                  --交易对手编号
  ,t7.org_cn_fname                                      as cntpty_name                --交易对手名称
  ,t7.wdraw_acct_lg_pay_sys_bank_no                     as cntpty_bank_no             --交易对手行号
  ,t7.org_cate_cd                                       as cntpty_cate_cd             --交易对手类别代码
  ,t2.crdt_main_type_cd                                 as cntpty_type_cd             --交易对手类型代码
  ,t7.mem_org_cd                                        as cntpty_org_id              --交易对手机构编号
  ,t3.hxb_acpt_flg                                      as hxb_acpt_flg               --我行承兑标志
  ,t3.bill_src_cd                                       as bill_src_cd                --票据来源代码
  ,'1'                                                  as sys_in_flg                 --系统内标志
  ,''                                                   as quot_way_cd                --报价方式代码
  ,t2.stl_way_cd                                        as stl_way_cd                 --结算方式代码
  ,t3.lock_flg                                          as lock_flg                   --锁定标志
  ,t8.hold_days                                         as hold_days                  --持票天数
  ,nvl(to_date(t1.bill_exp_dt, 'yyyymmdd') - to_date(t1.actl_exp_dt, 'yyyymmdd'), 0)    as defer_days         --顺延天数
  ,t1.valid_flg                                         as valid_flg                  --有效标志
  ,t2.msg_status_cd                                     as bus_status_cd              --业务状态代码
  ,case when t1.entry_status_cd = '01' then '0'                                       
        when t1.entry_status_cd = '03' then '2' end     as entry_status_cd            --记账状态代码
  ,''                                                   as lmt_id                     --额度编号
  ,t2.ibank_crdt_lmt_ocup_status_cd                     as lmt_status_cd              --额度状态代码
   ,'' as operr_id                                      --经办人编号
  ,t2.cust_mgr_id                                       as cust_mgr_id                --客户经理编号
  ,t2.dept_id                                           as dept_id                    --部门编号
  ,t2.bus_org_id                                        as bus_org_id                 --业务机构编号
  ,t10.fin_org_id                                       as acct_instit_id             --账务机构编号
  ,null                                                 as bf_cntpty_flg			        --前交易对手标志
  ,null                                                 as bf_cntpty_name             --前交易对手名称
  ,null                                                 as bf_cntpty_type_cd          --前交易对手类型代码
  ,t1.fir_buy_src_cd                                    as fir_buy_src_cd             --首次买入来源代码
  ,t1.fir_cntpty_cust_id                                as fir_cntpty_cust_id         --首次交易对手客户编号
  ,t1.fir_cntpty_name                                   as fir_cntpty_name            --首次交易对手名称
  ,t1.fir_cntpty_ibank_no                               as fir_cntpty_ibank_no        --首次交易对手联行号
  ,t1.job_cd                                            as job_cd                     --任务代码
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --etl处理时间戳
  from ${iml_schema}.evt_anony_click_draw_bill_dtl t1
  left join ${iml_schema}.evt_anony_click_match_batch t2
         on t1.match_batch_ser_num=t2.match_batch_ser_num
        and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
        and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
        and t2.job_cd = 'bdmsi1'
  left join (select t1.rgst_id
                   ,t1.draw_dt
                   ,t1.lock_flg
                   ,t1.bill_src_cd
                   ,t1.hxb_acpt_flg
                   ,t1.bill_status_cd
                   ,t1.discnt_dt
                   ,t1.bill_num
                   ,t1.recs_flg
                   ,t1.payoff_flg
                   ,t1.exp_dt
                   ,t1.bill_sub_intrv_id
	             from ${iml_schema}.ref_rgst_cter_bill_info_para t1 --登记中心票据信息参数
  	          where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  	            and t1.job_cd = 'bdmsf1'
	             ) t3
	  on t1.bill_ser_num = t3.rgst_id
  left join ${icl_schema}.cmm_bill_discount_info_ex01 tmp
    on t1.match_dtl_ser_num=tmp.id
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) pric
    on tmp.pric_amt_type = pric.trprcd
   and tmp.base_prod_id = pric.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) int_adj
    on tmp.int_amt_type = int_adj.trprcd
   and tmp.base_prod_id = int_adj.prodp1
  left join (select sdp.prodp1, sd.trprcd, sd.itemcd
               from ${iol_schema}.tgls_sys_dtit sd
               left join ${iol_schema}.tgls_sys_dtit_map sdp
                 on sd.typecd = sdp.dtitcd
                and sd.stacid = sdp.stacid
                and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
              where sd.module = 'BDMX'
                and sd.stacid = 2
                and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')) spd_adj
    on tmp.spd_pl_amt_type = spd_adj.trprcd
   and tmp.base_prod_id = spd_adj.prodp1
  left join (select t1.dtl_id
	                 ,t1.batch_id
	                 ,t1.bill_id
	                 ,t1.provied_int  --已计提利息
	                 ,t1.surp_int     --剩余利息
	                 ,t2.td_provi_int --当日计提利息
					         ,t1.provi_dt
	             from ${iml_schema}.agt_cpes_provi_h t1 --票交所计提历史
	             left join ${iml_schema}.evt_cpes_provi_dtl t2 --票交所计提明细事件
	               on t1.provi_mtbl_id = t2.provi_mtbl_id
	              and t2.entry_sucs_flg = '1' --记账成功标志
	              and t2.entry_dt = to_date('${batch_date}', 'yyyymmdd') --记账日期
	              and t2.job_cd = 'bdmsi1'
	            where t1.job_cd = 'bdmsf1'
	            	 and t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
  	            and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  	            and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
	            ) t6
    on t1.match_dtl_ser_num = t6.dtl_id
   and t2.match_batch_ser_num = t6.batch_id
   and t3.rgst_id = t6.bill_id
  left join ${iml_schema}.pty_cpes_mem t7
    on t2.cntpty_org_id = t7.mem_org_cd
   and t7.create_dt<= to_date('${batch_date}', 'yyyymmdd')
   and t7.id_mark <> 'D'
   and t7.job_cd ='bdmsf1'
  left join (select t1.bill_id  as bill_id
                   ,t1.dtl_id   as dtl_id
                   ,t1.batch_id as batch_id
                   ,t2.days     as hold_days
              from ${iml_schema}.agt_cpes_provi_h t1
              left join (select t2.provi_mtbl_id,count(1) as days
                           from ${iml_schema}.evt_cpes_provi_dtl t2
                          where t2.entry_sucs_flg = '1'
                            and t2.entry_dt <= to_date('${batch_date}', 'yyyymmdd')
                          group by t2.provi_mtbl_id) t2
                    on t1.provi_mtbl_id = t2.provi_mtbl_id
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')) t8
    on t1.match_dtl_ser_num = t8.dtl_id
   and t2.match_batch_ser_num = t8.batch_id
   and t3.rgst_id = t8.bill_id
  left join ${iml_schema}.evt_bill_entry t10
    on t10.cont_id = t2.match_batch_ser_num
   and t10.bill_id = t3.rgst_id
   and t10.prod_id = t2.prod_id
   and t10.bus_id  = t1.match_dtl_ser_num
   and t10.etl_Dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.h_data_flg <> 'system_ht'
   and t10.job_cd = 'bdmsi1'
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.dtl_id               as detail_id
                   ,t1.batch_id             as contract_id
                   ,t2.td_provi_int         as td_acru_int      --当日应计利息
                   ,t1.surp_int             as int_adj_bal      --利息调整余额
                   ,t1.provied_int          as currt_acru_int   --当期应计利息
              from ${iml_schema}.agt_cpes_provi_h t1
              left join ${iml_schema}.evt_cpes_provi_dtl t2
                on t1.provi_mtbl_id = t2.provi_mtbl_id 
               and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               and t2.job_cd = 'bdmsi1'
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 --              and t1.provi_bus_type_cd ='01'
               and t1.provi_status_cd in ('02','03')
               and t1.job_cd = 'bdmsf1') t9
    on t1.match_dtl_ser_num = t9.detail_id
   and t2.match_batch_ser_num = t9.contract_id
   and t3.rgst_id = t9.bill_id
   left join ${iol_schema}.bdms_cpes_anoclick_match_contract t11
   on t1.match_batch_ser_num=t11.id
   and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t13
    on t2.std_prod_id = t13.sellbl_prod_id			
   and t13.bus_type_cd = 'BDMX'	
   and t13.etl_dt = to_date('${batch_date}', 'yyyymmdd') 
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsi1';
commit;
-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_bill_discount_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bill_discount_info_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bill_discount_info_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bill_discount_info',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
