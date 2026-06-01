/*
Purpose:  共性加工层-对公贷款账户信息：包括所有的行内对公贷款账户，包含传统的对公贷款、对公委托贷款、垫款、进出口押汇、福费廷、保理项下融资等业务的账户信息。数据来源于新核心系统CBSS，部分信息项来源于对公信贷系统CRSS。
Author:   Sunline
Usage:    python $ETL_HOME/script/main.py 20221112 icl_cmm_corp_loan_acct_info
Createdate: 20220326
Logs:       20220609 李森辉 新增字段【贷款号】
            20220624 温旺清 1、调整字段【科目编号、原本金科目编号、表内利息科目编号、表外利息科目编号、利息收入科目编号】的加工口径
                            2、新增字段【应收未收利息科目编号、应收应付利息调整科目编号、应计已减值利息科目编号】
		        20220722 温旺清	1、调整字段【贷款账户状态代码、应计非应计代码、核销标志、逾期标志】的加工口径；
                            2、调整T14临时表的加工逻辑【去掉ACCOUNTING_STATUS NOT IN ('ZHC', 'TER')】
            20220914 温旺清 1、调整字段【科目编号、原本金科目编号、表内利息科目编号、应收未收利息科目编号、表外利息科目编号、应计已减值利息科目编号、利息收入科目编号、核销本金、核销利息、表内利息、表外利息、累计应收未收利息金额、本金余额、当期余额、折本币当期余额及相关积数字段的加工口径】的加工口径
                            2、置空字段【应收应付利息调整科目编号-RECVBL_INT_PAYBL_ADJ_SUBJ_ID】
                            3、新增字段【应收未收利息、应收利息、非应计应收利息、应计已减值利息】
		        20221106 陈伟峰	1、调整【本金逾期标志,利息逾期标志,当前逾期期数,本金逾期天数,利息逾期天数,逾期本金余额,逾期利息金额,逾期复利金额,首次逾期日期,本金逾期日期,利息逾期日期,当日应计利息,当期应计利息,当日利息收入,当日利息收入调整,应收欠息,应收应计罚息,应收罚息,应计复息,应收复息,表内欠息余额,表外欠息余额,表内利息,表外利息】加工口径
		        20221108 曹永茂 调整【利率浮动方式代码、利率浮动值、逾期利率浮动值】的加工口径
            20221118 温旺清 新增字段【贷款形态代码 LOAN_MODAL_CD】
            20221128 翟若平 调整字段【当日利息收入、当日利息收入调整】的加工口径
            20221201 温旺清 增加表agt_abs_cont_dtl_h 的过滤条件 t22.asset_acct_status_cd not in ('C','E')  --c:撤包 E:发行撤销
            20221220 陈伟峰 调整上日表关联条件，增加投产日期前后区分判断
            20221222 温旺清 调整 evt_repay_dtl 的算法
            20230104 陈伟峰 调整字段【借据号】的加工口径，新增字段【核心借据号】
            20230118 陈伟峰 调整科目相关字段加工逻辑，tmp_cmm_corp_loan_acct_info_14表增加资金性质字段用于关联
            20230206 陈伟峰 调整基数字段加工逻辑，加入投产日关联字段判断逻辑
            20230214 陈伟峰 调整核算状态取值逻辑，优先取核算中台的核算状态
            20230310 陈伟峰	调整agt_loan_acct_info_h表dubil_id使用逻辑，增加银团贷款'203010400001','602060100002'拼接规则
            20230323 陈伟峰 调整tmp_cmm_corp_loan_acct_info_14表关联逻辑，判断4开头的产品使用资金性质关联，非4开头的产品不使用资金性质关联
            20230526 陈伟峰 调整逾期天数及标志信息中的NCBS_CL_INVOICE_OD_DETAIL字段，使用END_DATE作为利息逾期日期
            20230608 陈伟峰 调整展期信息临时表的取数逻辑
            20230609 陈伟峰 过滤开户日期大于跑批日期的数据
			      20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持年批
			      20230830 徐子豪 新增字段【资产证券化标志、资产转让标志、宽限期利息、当日税额收入】
            20231012 陈伟峰 调整【贷款期数】加工逻辑，过滤提前还款的999期次
            20231206 徐子豪 新增字段【原始到期日期】
            20231225 陈伟峰 调整临时表tmp_cmm_corp_loan_acct_info_08加工逻辑，增加or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')
            20231225 饶雅 调整部分基数字段加工逻辑 
            20240320 饶雅 调整【本金逾期标志、利息逾期标志、本金逾期天数、利息逾期天数、首次逾期日期、本金逾期日期、利息逾期日期】取数逻辑，参考零售贷款账户的逻辑。
            20240521 陈伟峰 调整evt_loan_acct_info_modif_oper_dtl取数条件，过滤跑批后数据
            20240617 饶雅  新增字段【价差损益科目编号】SPD_PL_SUBJ_ID、【当日价差损益】TD_SPD_PL
            20240521 陈伟峰 1、新增字段【首次展期到期日期期】FIR_RENEW_EXP_DT
                            2、新增字段【催收应计罚息】COLL_ACRU_PNLT
                            3、新增字段【催收罚息】COLL_PNLT
            20240719 陈伟峰 1、新增字段【核销垫付费金额】WRT_OFF_ADVC_FEE_AMT
            20240822 陈伟峰 新增字段【开户时间、销户时间】
            20241105 陈伟峰 调整prd_loan_prod_info_h关联方式，避免过滤集团委托贷款数据
            20241105 谢宁 调整【当日价差损益】取数逻辑，根据方向判断正负,福费廷转让价差损益科目正收益时记贷方正数，现在亏损记借方正数
            20241218 谢宁 调整【允许提前还款标志】【当前利率生效日期】【复息标志】取数逻辑
            20250526 陈伟峰 调整【应收未收利息科目编号】加工逻辑，当发生资产证券化时，科目取表外科目
			20250702 陈  凭 调整【利率调整周期单位代码 INT_RAT_ADJ_PED_CORP_CD、利率调整周期频率 INT_RAT_ADJ_PED_FREQ】取数逻辑
            20250801 陈伟峰 调整资产转让逻辑，剔出封包数据
            20251029 陈伟峰 调整资产转让逻辑，【资产转让日期】从封包日期改为发行日期
            20251107 陈伟峰 优化展期信息取数逻辑
            20251127 陈伟峰 调整【逾期利率浮动值、利率浮动值】逻辑，当利率启用方式为随基准利率变更和按周期变更时，取核心利率浮动比例*基准利率或者利率浮动值，否则为0
            20251203 陈伟峰 调整【基准利率base_rat】取值逻辑，不取每日更新基准利率，改为取放款时间核心登记的利率
            20251226 陈伟峰 调整【逾期利率浮动值、利率浮动值】逻辑，去除判断利率启用方式为随基准利率变更和按周期变更的判断规则，直接取核心利率浮动比例*基准利率或者利率浮动值

*/


set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter seesion force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_04 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_05 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_06 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_07 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_08 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_09 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_10 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_11 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_12 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_13 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_14 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_15 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_16 purge;
drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_17 purge;
commit;

-- 1.3 insert data to tmp table
-- 获取账户结算信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_01
nologging
compress ${option_switch} for query high
as
select acct_id
      ,pay_acct_no -- 付款账户
      ,nvl(rec_acct_no1,rec_acct_no2) as rec_acct_no -- 收款账户
      ,aut_acct_no -- 自动扣款账户
      ,wtr_acct_no -- 委托存款账户
      ,wts_acct_no -- 委托结算账户
 from
 (select acct_id
        ,max(decode(stl_acct_cls_cd, 'PAY', stl_cust_acct_num, '')) as pay_acct_no -- 付款账户
        ,max(case when evt_cate_id='DRW' and (stl_acct_cls_cd = 'REC' or stl_acct_cls_cd = 'AUT' ) and out_line_flg='1' then stl_cust_acct_num else '' end) as rec_acct_no1 -- 行内收款账户
        ,max(case when evt_cate_id='DRW' and (stl_acct_cls_cd = 'REC' or stl_acct_cls_cd = 'AUT' ) and out_line_flg='0' then stl_cust_acct_num else '' end) as rec_acct_no2 -- 行外收款账户
        ,max(decode(stl_acct_cls_cd, 'AUT', stl_cust_acct_num, '')) as aut_acct_no -- 自动扣款账户
        ,max(decode(stl_acct_cls_cd, 'WTR', stl_cust_acct_num, '')) as wtr_acct_no -- 委托存款账户
        ,max(decode(stl_acct_cls_cd, 'WTS', stl_cust_acct_num, '')) as wts_acct_no -- 委托结算账户
     from ${iml_schema}.agt_loan_acct_stl_info_h
    where job_cd = 'ncbsf1'
      and start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and end_dt > to_date('${batch_date}', 'yyyymmdd')
    group by acct_id
 )
;

-- 获取贷款发放信息（放款流水号、放款日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_02
nologging
compress ${option_switch} for query high
as
select t1.acct_id  as acct_id  -- 账户编号
       ,t1.tran_ref_no as tran_ref_no  -- 放款流水号
       ,t1.distr_dt as distr_dt  -- 放款日期
       ,t1.seq_num as seq_num  -- 序号
       ,row_number() over(partition by t1.acct_id order by t1.seq_num desc) as rn  -- 排序编号
  from ${iml_schema}.evt_loan_distr_flow t1
 where t1.etl_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd ='ncbsi1'
;

-- 获取展期信息（展期标志、展期次数、展期到期日期期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_03
nologging
compress ${option_switch} for query high
as
select modif_content_key_val
       ,loan_num
       ,coalesce(json_value(modif_bf_val, '$.maturityDate'),json_value(modif_bf_val, '$.matudt'),json_value(modif_bf_val, '$.DUE_DATE')) as modif_bf_val
       ,coalesce(json_value(modif_post_val, '$.maturityDate'),json_value(modif_post_val, '$.matudt'),json_value(modif_post_val, '$.DUE_DATE')) as modif_post_val
       ,row_number() over(partition by modif_content_key_val order by modif_dt desc) as rn  --最新变更日期
       ,count(1) over(partition by modif_content_key_val order by modif_dt asc) as renew_cnt
       ,modif_item
  from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
 where acct_modif_cate_cd in('MAT','MATE')  -- 期限变更
   and coalesce(json_value(modif_bf_val, '$.maturityDate'),json_value(modif_bf_val, '$.matudt'),json_value(modif_bf_val, '$.DUE_DATE')) <= coalesce(json_value(modif_post_val, '$.maturityDate'),json_value(modif_post_val, '$.matudt'),json_value(modif_post_val, '$.DUE_DATE'))
   --and modif_item = 'RPAY_DAT'
--   and acct_aldy_check_flg = '1'  -- 已复核
   and etl_dt <=to_date('${batch_date}','yyyymmdd')
   and job_cd = 'ncbsi1'
;

-- 获取转非应计信息（转非应计贷款日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_04
nologging
compress ${option_switch} for query high
as
select modif_content_key_val,
       modif_bf_val,
       modif_post_val,
       modif_dt,
       acct_aldy_check_flg,
       row_number() over(partition by modif_content_key_val order by modif_dt desc) as rn
  from (select t1.modif_content_key_val as modif_content_key_val,
               json_value(t1.modif_bf_val, '$.accountingStatus') as modif_bf_val,
               json_value(t1.modif_post_val, '$.accountingStatus') as modif_post_val,
               t1.modif_dt as modif_dt,
               t1.acct_aldy_check_flg,
               row_number() over(partition by t1.modif_content_key_val order by t1.modif_dt desc) as rn
          from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl t1
         where t1.acct_modif_cate_cd = 'ATAS'
           and t1.etl_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t1.job_cd = 'ncbsi1')
 where modif_post_val in ('FYJ', 'FY', 'WRN')
   and modif_bf_val not in ('FYJ', 'FY', 'WRN')
;

-- 获取基准利率信息（利率曲线类型代码、基准利率等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_05
nologging
compress ${option_switch} for query high
as
select t1.base_rat_id as base_rat_id
       ,t1.curr_cd as curr_cd
       ,t1.base_rat as base_rat
       ,row_number() over(partition by t1.base_rat_id, t1.curr_cd order by t1.effect_dt desc) rn
  from ${iml_schema}.ref_base_rat_h t1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
;

-- 获取产品属性信息（预付利息摊销标志、扣税标志、复息标志等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_06
nologging
compress ${option_switch} for query high
as
select t2.prod_id as prod_id  -- 产品编号
       ,max(decode(t2.attr_key, 'TAXABLE', t2.attr_val, '')) as taxable_value -- 收税标志
       ,max(decode(t2.attr_key, 'ACR_AMORTIZE', t2.attr_val, '')) as acr_amortize_value -- 摊销标志
       ,max(decode(t2.attr_key, 'INT_PENALTY', t2.attr_val, '')) as int_penalty_value -- 复利标志
  from (select t1.prod_id
               ,t1.attr_key
               ,t1.attr_val
               ,t1.seq_num
               ,row_number() over(partition by t1.prod_id, t1.attr_key order by t1.seq_num desc) rn
          from ${iml_schema}.prd_prod_def_h t1
         where t1.prod_status_cd = 'A'
           and trim(t1.attr_key) is not null
           and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
           and t1.job_cd ='ncbsf1') t2
 where t2.rn = 1
 group by t2.prod_id
;

-- 获取逾期金额信息（逾期本金余额、逾期利息金额、逾期罚息金额、逾期复利金额等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_07
nologging
compress ${option_switch} for query high
as
select t1.acct_id
       ,sum(nvl(t4.ld_ovdue_pric,0)) as ovdue_pric_bal
       ,sum(nvl(t4.ld_ovdue_int,0) + nvl(t4.ld_ovdue_pnlt,0) + nvl(t4.ld_ovdue_comp_int,0))  as ovdue_int_amt
       ,sum(nvl(t4.ld_ovdue_comp_int,0)) as ovdue_comp_int_amt
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_repay_plan_pd_h t4
    on t1.acct_id = t4.acct_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ncbsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and t4.exp_dt <= TO_DATE('${batch_date}', 'YYYYMMDD')
 group by t1.acct_id
;

-- 获取逾期天数及标志信息（本金逾期标志、本金逾期天数、本金逾期日期、利息逾期标志、利息逾期天数、利息逾期日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_08
nologging
compress ${option_switch} for query high
as
select t1.acct_id
      ,sdp.pric_ovdue_flg
      ,sdp.pric_ovdue_days
      ,sdp.pric_ovdue_dt
      ,sdi.int_ovdue_flg
      ,sdi.int_ovdue_days
      ,sdi.int_ovdue_dt
      ,case when nvl(sdp.pric_ovdue_perds,0) > nvl(sdi.int_ovdue_perds,0) then sdp.pric_ovdue_perds else sdi.int_ovdue_perds end as curr_ovdue_perds
      ,st.tot_perds
   from ${iml_schema}.agt_loan_acct_info_h t1
   left join
      (select acct_id
             ,'1' as pric_ovdue_flg
             ,max(curr_pd) as pric_ovdue_perds
             ,max(to_date('${batch_date}', 'yyyymmdd') - int_set_dt + 1) as pric_ovdue_days
             ,min(int_set_dt) as pric_ovdue_dt
        from ${iml_schema}.agt_loan_repay_plan_dtl_h
       where amt_type_cd = 'PRI'
         and grace_dt <= to_date('${batch_date}', 'yyyymmdd')
         and (full_amt_callbk_flg = '0' or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')))
         and start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and end_dt > to_date('${batch_date}', 'yyyymmdd')
         and job_cd = 'ncbsf1'
       group by acct_id
      ) sdp
     on t1.acct_id = sdp.acct_id
   left join
      (select acct_id
             ,max(int_ovdue_flg) as int_ovdue_flg
             ,max(int_ovdue_perds) as int_ovdue_perds
             ,max(int_ovdue_days) as int_ovdue_days
             ,min(int_ovdue_dt) as int_ovdue_dt
        from
           (select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - int_set_dt + 1) as int_ovdue_days
                   ,min(int_set_dt) as int_ovdue_dt
              from ${iml_schema}.agt_loan_repay_plan_dtl_h
             where amt_type_cd = 'INT'
               and grace_dt <= to_date('${batch_date}', 'yyyymmdd')
              and (full_amt_callbk_flg = '0' or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')))
 
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and job_cd = 'ncbsf1'
             group by acct_id
/*             union all
             select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - value_dt + 1) as int_ovdue_days
                   ,min(value_dt) as int_ovdue_dt
              from ${iml_schema}.agt_loan_acct_pnlt_int_accr_h
             where int_cls_cd = 'ODP'
               and ld_acm_provi_int > 0
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and job_cd = 'ncbsf1'
             group by acct_id
             union all
             select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - value_dt + 1) as int_ovdue_days
                   ,min(value_dt) as int_ovdue_dt
              from ${iml_schema}.agt_loan_acct_comp_int_int_accr_h
             where int_cls_cd = 'ODI'
               and ld_acm_provi_int > 0
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               and job_cd = 'ncbsf1'
             group by acct_id
*/
             union all
             select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - bus_invalid_dt + 1) as int_ovdue_days
                   ,min(bus_invalid_dt) as int_ovdue_dt
              from ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl
             where etl_dt = to_date('${batch_date}', 'yyyymmdd')
               and grace_dt <= to_date('${batch_date}', 'yyyymmdd')
               and ld_doc_unpaid_amt > 0
               and job_cd='ncbsi1'
             group by acct_id
             )
         group by acct_id
      ) sdi
     on t1.acct_id = sdi.acct_id
   left join
      (select acct_id
             ,max(curr_pd) as tot_perds
        from ${iml_schema}.agt_loan_repay_plan_dtl_h
       where start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and end_dt > to_date('${batch_date}', 'yyyymmdd')
         and job_cd = 'ncbsf1'
         and curr_pd <> '999'
       group by acct_id
      ) st
     on t1.acct_id = st.acct_id
  where t1.job_cd = 'ncbsf1'
    and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

-- 获取下次还款信息（本金的下次还款日期、下次还本金额）(t16)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_09
nologging
compress ${option_switch} for query high
as
select t1.acct_id
       ,t2.curr_pd
       ,max(t2.int_set_dt) as next_repay_dt
       ,sum(t2.plan_repay_amt) as next_rpp_amt
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_repay_plan_dtl_h t2
    on t1.agt_id = t2.agt_id
   and t2.amt_type_cd = 'PRI'
   and t2.value_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.int_set_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd ='ncbsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
 group by t1.acct_id,t2.curr_pd
;

-- 获取下次还款信息（利息的下次还款日期、下次还息金额等）(t33)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_10
nologging
compress ${option_switch} for query high
as
select t1.acct_id
       ,t2.curr_pd
       ,max(t2.int_set_dt) as next_repay_dt
       ,sum(t2.plan_repay_amt) as next_repay_int_amt
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_repay_plan_dtl_h t2
    on t1.agt_id = t2.agt_id
   and t2.amt_type_cd = 'INT'
   and t2.value_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.int_set_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd ='ncbsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
 group by t1.acct_id,t2.curr_pd
;

-- 获取资产证券化金额明细（转让前应收利息）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_11
nologging
compress ${option_switch} for query high
as
select t1.asset_bag_cont_dtl_seq_num
       ,sum(t1.pkg_day_tm_point_amt) as pack_amt
  from ${iml_schema}.agt_abs_amt_dtl_h t1
 where t1.amt_type_cd in ('INT', 'INTP', 'ODP', 'ODPP', 'ODI', 'ODIP')
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
 group by t1.asset_bag_cont_dtl_seq_num;
commit;

-- 获取实际还款明细（已偿还本金、已偿还利息、已偿还罚息、已偿还复利、上一还款日期等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_12
nologging
compress ${option_switch} for query high
as
select t2.acct_id
       ,sum(case when t2.amt_type_cd in ('PRI','PRD', 'OSL') then t2.callbk_pric else 0 end) as repaid_pric
       ,sum(case when t2.amt_type_cd in ('INT', 'INTP') then t2.callbk_pric else 0 end) as repaid_int
       ,sum(case when t2.amt_type_cd in ('ODP', 'ODPP') then t2.callbk_pric else 0 end) as repaid_pnlt
       ,sum(case when t2.amt_type_cd in ('ODIP', 'ODI') then t2.callbk_pric else 0 end) as repaid_comp_int
       ,max(t1.bus_tran_dt) as last_repay_dt
  from ${iml_schema}.evt_repay_flow t1 --iol.ncbs_cl_receipt cr
  inner join ${iml_schema}.evt_repay_dtl t2
    on t1.callbk_id = t2.callbk_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd='ncbsf1'
 where t1.revs_flg = '0'
   and t1.bus_tran_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd='ncbsi1'
 group by t2.acct_id;
commit;

--获取基础产品信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_13
nologging
compress ${option_switch} for query high
as
select pc2.base_prod_id,
       pc2.sellbl_prod_id
	  from ${iml_schema}.prd_prod_catlg_h pc2
   where 1=1
     and pc2.job_cd = 'ncbsf1'
     and pc2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and pc2.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and trim(pc2.sellbl_prod_id) is not null
     and not exists (select 1 from ${iol_schema}.tgls_pcmc_knp_para pkp
                      where pc2.sellbl_prod_id = pkp.paracd
                        and pkp.subscd = 'RB'
                        and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                        and pkp.paracd != '%'
                        and pkp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and pkp.end_dt > to_date('${batch_date}', 'yyyymmdd'));
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_14
nologging
compress ${option_switch} for query high
as
select sdp.base_prod_id,
       sdp.prod_attr_cd,
       coalesce(pc1.sellbl_prod_id, pc2.sellbl_prod_id, sdp.base_prod_id) as sellbl_prod_id,
       max(decode(sd.amt_type_cd, 'NCBS020', sd.subj_id, '')) as devaam_subjid,
       max(decode(sd.amt_type_cd, 'TYJE002', sd.subj_id, '')) as collpe_subjid,
       max(decode(sd.amt_type_cd, 'NCBS017', sd.subj_id, '')) as oppotr_subjid,
       max(decode(sd.amt_type_cd, 'NCBS013', sd.subj_id, '')) as reacci_subjid,
       max(decode(sd.amt_type_cd, 'TYJE004', sd.subj_id, '')) as intein_subjid,
       max(decode(sd.amt_type_cd, 'TYJE010', sd.subj_id, '')) as vataxm_subjid,
       max(decode(sd.amt_type_cd, 'NCBS018', sd.subj_id, '')) as normpr_subjid,
       max(decode(sd.amt_type_cd, 'NCBS011', sd.subj_id, '')) as regicr_subjid,
       max(decode(sd.amt_type_cd, 'NCBS016', sd.subj_id, '')) as acasil_subjid,
       max(decode(sd.amt_type_cd, 'NCBS012', sd.subj_id, '')) as regcir_subjid,
       max(decode(sd.amt_type_cd, 'DS', sd.subj_id, '')) as intead_subjid,
       max(decode(sd.amt_type_cd, 'BAL', sd.subj_id, '')) as reacin_subjid,
       max(decode(sd.amt_type_cd, 'TYJE003', sd.subj_id, '')) as reinre_subjid,
       max(decode(sd.amt_type_cd, 'NCBS021', sd.subj_id, '')) as acimii_subjid,
       max(decode(sd.amt_type_cd, 'NCBS014', sd.subj_id, '')) as accuto_subjid,
       max(decode(sd.amt_type_cd, 'NCBS015', sd.subj_id, '')) as regaci_subjid,
       max(decode(sd.amt_type_cd, 'NCBS025', sd.subj_id, '')) as veripr_subjid,
       max(decode(sd.amt_type_cd, 'NCBS022', sd.subj_id, '')) as accrin_subjid,
       max(decode(sd.amt_type_cd, 'NCBS023', sd.subj_id, '')) as ovdupr_subjid
    from ${iml_schema}.fin_accti_subj_rela_h sd
   inner join ${iml_schema}.fin_accti_prod_rela_info sdp
      on sd.accti_id = sdp.accti_id
     and sd.sob_id = sdp.sob_id
     and sdp.etl_dt = to_date('${batch_date}', 'yyyymmdd')
     and sdp.job_cd = 'tglsi1'
    left join ${iml_schema}.prd_prod_catlg_h pc1
      on sdp.base_prod_id = pc1.sellbl_prod_id
     and pc1.job_cd = 'ncbsf1'
     and pc1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and pc1.end_dt > to_date('${batch_date}', 'yyyymmdd')
    left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_13 pc2
      on sdp.base_prod_id = pc2.base_prod_id
   where sd.sob_id = 2
     and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and sd.status_cd = '1'
     and sd.bus_type_cd in ('LN','NCBS')
     and sd.job_cd = 'tglsf1'
   group by sdp.base_prod_id,sdp.prod_attr_cd,coalesce(pc1.sellbl_prod_id, pc2.sellbl_prod_id, sdp.base_prod_id);
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_15
nologging
compress ${option_switch} for query high
as
select chrexj as core_loan_num,            -- 核心借据号
       sum(numex2) as discnt_int,          -- 贴现利息
       sum(numex3) as recvbl_int,          -- 应收利息
       sum(numex4) as int_income,          -- 利息收入
       sum(numex5) as tax_amt,             -- 销项税额
       sum(numex6) as acru_aldy_impam_int, -- 应计已减值利息
       sum(numex7) as non_acru_int_recvbl, -- 非应计应收利息
       sum(numex8) as recvbl_uncol_int,    -- 应收未收利息
       sum(numex9) as wrt_off_int,         -- 已核销利息
       sum(numexa) as reimbursed_tax       -- 代垫增值税
  from (select chrexj,numex2,numex3,numex4,numex5,numex6,numex7,numex8,numex9,numexa
          from ${iol_schema}.tgls_loan_busi_h
         where etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and trandt = '${batch_date}'
           and status = '1'
         union all 
        select chrexj,numex2,numex3,numex4,numex5,numex6,numex7,numex8,numex9,numexa
          from ${iol_schema}.tgls_loan_busi t1
         where etl_dt = to_date('${batch_date}', 'yyyymmdd')
           and trandt = '${batch_date}'
           and status = '1'  
           and t1.stacid = 2         
           and not exists (select 1 from ${iol_schema}.tgls_loan_busi_h tt 
                            where tt.transq=t1.transq 
                              and tt.trandt=t1.trandt 
                              and tt.bsnssq=t1.bsnssq 
                              and tt.serino=t1.serino
                              and tt.stacid = 1
                              and tt.trandt = '${batch_date}'))
 group by chrexj
;
commit;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_16
nologging
compress ${option_switch} for query high
as
select acct_id
      ,t1.asset_bag_cont_dtl_seq_num
      ,t1.asset_acct_status_cd
      ,ctc.imp_blank_draw_dt as pkg_tran_dt
      ,row_number() over(partition by t1.acct_id order by t1.tran_tm desc) rn
  from ${iml_schema}.agt_abs_cont_dtl_h t1
 inner join ${iml_schema}.agt_abs_cont_h ctc 
    on t1.asset_bag_cont_id = ctc.asset_bag_cont_id
   and ctc.asset_bag_cont_status_cd in ('YP', 'YS', 'PB')
   and ctc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ctc.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and ctc.job_cd = 'ncbsf1'
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ncbsf1'
   and t1.asset_acct_status_cd not in ('C', 'E', 'I','P') -- P-封包、S-发行、C-撤包、E-发行撤销、B-赎回
;



whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_loan_acct_info_17
nologging
compress ${option_switch} for query high
as
select modif_content_key_val
       , min(modif_dt) as  modif_dt --首次展期到期日期期期
  from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
 where acct_modif_cate_cd in('MAT','MATE')  -- 期限变更
   and job_cd = 'ncbsi1'
   and etl_dt <=to_date('${batch_date}','yyyymmdd')
group by modif_content_key_val
;

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_acct_info_ex purge;

-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_loan_acct_info where 0 = 1;

-- 2.2 insert data to ex table

whenever sqlerror exit sql.sqlcode;
insert into ${icl_schema}.cmm_corp_loan_acct_info_ex(
       etl_dt                          -- 数据日期
       ,lp_id                          -- 法人编号
       ,acct_id                        -- 账户编号
       ,acct_name                      -- 账户名称
       ,cust_id                        -- 客户编号
       ,cont_id                        -- 合同编号
       ,dubil_num                      -- 借据号
       ,core_dubil_num                 -- 核心借据号
       ,loan_num                       -- 贷款号
       ,loan_distr_acct_num            -- 贷款放款账号
       ,loan_repay_num                 -- 贷款还款账号
       ,int_sub_ps_stl_acct_num        -- 贴息人结算账号
       ,entr_dep_acct_num              -- 委托存款账号
       ,csner_dep_acct_num             -- 委托人存款账号
       ,distr_flow_num                 -- 放款流水号
       ,inpwn_acct_num_id              -- 质押账号ID
       ,out_acct_num                   -- 出账号
       ,rela_bill_id                   -- 关联票证编号
       ,std_prod_id                    -- 标准产品编号
       ,prod_id                        -- 产品编号
       ,subj_id                        -- 科目编号
       ,init_pric_subj_id              -- 原本金科目编号
       ,int_subj_id                    -- 表内利息科目编号
	     ,recvbl_uncol_int_subj_id       -- 应收未收利息科目编号
	     ,recvbl_int_paybl_adj_subj_id   -- 应收应付利息调整科目编号
       ,off_bs_int_subj_id             -- 表外利息科目编号
	     ,acru_aldy_impam_int_subj_id    -- 应计已减值利息科目编号
       ,int_income_subj_id             -- 利息收入科目编号
       ,int_income_adj_subj_id         -- 利息收入调整科目编号
       ,spd_pl_subj_id                 -- 价差损益科目编号
       ,loan_modal_cd                  -- 贷款形态代码
       ,loan_acct_status_cd            -- 贷款账户状态代码
       ,loan_tenor                     -- 贷款期限
       ,loan_tenor_type_cd             -- 贷款期限类型代码
       ,loan_cate_cd                   -- 贷款类别代码
       ,asset_thd_cls_cd               -- 资产三分类代码
       ,belong_bus_strip_line_cd       -- 所属业务条线代码
       ,guar_way_cd                    -- 担保方式代码
       ,loan_usage_descb               -- 贷款用途描述
       ,acru_non_acru_cd               -- 应计非应计代码
       ,turn_non_acru_loan_dt          -- 转非应计贷款日期
       ,cust_mgr_id                    -- 客户经理编号
       ,open_acct_org_id               -- 开户机构编号
       ,mgmt_org_id                    -- 管理机构编号
       ,acct_instit_id                 -- 账务机构编号
       ,open_acct_dt                   -- 开户日期
       ,open_acct_timestamp            -- 开户时间
       ,distr_dt                       -- 放款日期
       ,value_dt                       -- 起息日期
       ,stop_accr_int_dt               -- 停息日期
       ,exp_dt                         -- 到期日期
       ,init_exp_dt                    -- 原始到期日期
       ,clos_acct_dt                   -- 销户日期
       ,clos_acct_timestamp            -- 销户时间
       ,int_sub_flg                    -- 贴息标志
       ,int_sub_ratio                  -- 贴息比例
       ,int_sub_exp_day                -- 贴息到期日
       ,entr_loan_comm_fee_coll_way    -- 委托贷款手续费收取方式
       ,entr_loan_comm_fee_coll_ratio  -- 委托贷款手续费收取比例
       ,entr_loan_comm_fee             -- 委托贷款手续费
       ,int_accr_flg                   -- 计息标志
       ,stop_accr_int_flg              -- 停息标志
       ,impam_flg                      -- 减值标志
       ,crdt_distr_repay_plan_flg      -- 信贷发放还款计划标志
       ,finc_prod_flg                  -- 理财产品标志
       ,prepay_int_amort_flg           -- 预付利息摊销标志
       ,pric_auto_deduct_flg           -- 本金自动扣收标志
       ,int_auto_deduct_flg            -- 利息自动扣收标志
       ,acpt_flg                       -- 承兑标志
       ,gover_fin_plat_loan_flg        -- 政府融资平台贷款标志
       ,tax_flg                        -- 扣税标志
       ,wrt_off_flg                    -- 核销标志
       ,renew_flg                      -- 展期标志
       ,renew_cnt                      -- 展期次数
       ,fir_renew_exp_dt               -- 首次展期到期日期期	
       ,renew_exp_day                  -- 展期到期日期期
       ,allow_adv_repay_flg            -- 允许提前还款标志
       ,repay_seq_no_cd                -- 还款次序代码
       ,adv_repay_way_cd               -- 提前还款方式代码
       ,margin_curr_cd                 -- 保证金币种代码
       ,int_rat_base_type_cd           -- 利率基准类型代码
       ,int_rat_curve_type_cd          -- 利率曲线类型代码
       ,base_rat                       -- 基准利率
       ,exec_int_rat                   -- 执行利率
       ,reval_way_cd                   -- 重定价方式代码
       ,comn_loan_int_set_way_cd       -- 普通贷款结息方式代码
       ,int_rat_adj_way_cd             -- 利率调整方式代码
       ,int_rat_float_way_cd           -- 利率浮动方式代码
       ,int_rat_adj_ped_corp_cd        -- 利率调整周期单位代码
       ,int_rat_adj_ped_freq           -- 利率调整周期频率
       ,int_rat_flo_val                -- 利率浮动值
       ,curr_int_rat_effect_dt         -- 当前利率生效日期
       ,next_int_rat_adj_dt            -- 下次利率调整日期
       ,comp_int_flg                   -- 复息标志
       ,int_set_way_cd                 -- 结息方式代码
       ,int_accr_way_cd                -- 计息方式代码
       ,repay_way_cd                   -- 还款方式代码
       ,repay_ped_corp_cd              -- 还款周期单位代码
       ,repay_ped                      -- 还款周期
       ,money_use_type                 -- 款项使用类型
       ,lmt_type                       -- 额度类型
       ,abs_flg                        -- 资产证券化标志
       ,asset_tran_flg                 -- 资产转让标志
       ,asset_tran_status_cd           -- 资产转让状态代码
       ,asset_tran_dt                  -- 资产转让日期
       ,tran_bf_int_recvbl             -- 转让前应收利息
       ,ovdue_flg                      -- 逾期标志
       ,pric_ovdue_flg                 -- 本金逾期标志
       ,int_ovdue_flg                  -- 利息逾期标志
       ,curr_ovdue_perds               -- 当前逾期期数
       ,pric_ovdue_days                -- 本金逾期天数
       ,int_ovdue_days                 -- 利息逾期天数
       ,ovdue_pric_bal                 -- 逾期本金余额
       ,ovdue_int_amt                  -- 逾期利息金额
       ,ovdue_comp_int_amt             -- 逾期复利金额
       ,fir_ovdue_dt                   -- 首次逾期日期
       ,pric_ovdue_dt                  -- 本金逾期日期
       ,int_ovdue_dt                   -- 利息逾期日期
       ,ovdue_int_rat                  -- 逾期利率
       ,ovdue_int_rat_flo_val          -- 逾期利率浮动值
       ,tot_perds                      -- 贷款期数
       ,curr_issue_perds               -- 当前期数
       ,last_repay_dt                  -- 上次还款日期
       ,next_repay_dt                  -- 下次还款日期
       ,curr_cd                        -- 币种代码
       ,next_rpp_amt                   -- 下次还本金额
       ,next_repay_int_amt             -- 下次还息金额
       ,td_acru_int                    -- 当日应计利息
       ,currt_acru_int                 -- 当期应计利息
       ,td_int_income                  -- 当日利息收入
       ,td_int_income_adj              -- 当日利息收入调整
       ,td_tax_income                  -- 当日税额收入
       ,td_spd_pl                      -- 当日价差损益
       ,cont_amt                       -- 合同金额
       ,dubil_amt                      -- 借据金额
       ,distr_amt                      -- 放款金额
       ,nomal_pric                     -- 正常本金
       ,ovdue_pric                     -- 逾期本金
       ,grace_period_pric              -- 宽限期本金
       ,grace_period_int               -- 宽限期利息
       ,idle_pric                      -- 呆滞本金
       ,bad_debt_pric                  -- 呆账本金
       ,recvbl_over_int                -- 应收欠息
       ,recvbl_acru_pnlt               -- 应收应计罚息
       ,coll_acru_pnlt                 -- 催收应计罚息
       ,recvbl_pnlt                    -- 应收罚息
       ,coll_pnlt                      -- 催收罚息
       ,acru_comp_int                  -- 应计复息
       ,recvbl_comp_int                -- 应收复息
       ,recvbl_fee                     -- 应收费用
       ,wrt_off_pric                   -- 核销本金
       ,wrt_off_int                    -- 核销利息
       ,in_bs_over_int_bal             -- 表内欠息余额
       ,off_bs_over_int_bal            -- 表外欠息余额
       ,in_bs_int                      -- 表内利息
       ,off_bs_int                     -- 表外利息
       ,acm_recvbl_uncol_int_amt       -- 累计应收未收利息金额
       ,recvbl_uncol_int               -- 应收未收利息
       ,int_recvbl                     -- 应收利息
       ,non_acru_int_recvbl            -- 非应计应收利息
       ,acru_aldy_impam_int            -- 应计已减值利息
       ,trade_fin_int_adj              -- 贸易融资利息调整
       ,repaid_pric                    -- 已偿还本金
       ,repaid_int                     -- 已偿还利息
       ,repaid_pnlt                    -- 已偿还罚息
       ,repaid_comp_int                -- 已偿还复利
       ,repaid_fee                     -- 已偿还费用
       ,wrt_off_advc_fee_amt           -- 核销垫付费金额
       ,pric_bal                       -- 本金余额
       ,currt_bal                      -- 当期余额
       ,cl_curr_currt_bal              -- 折本币当期余额
       ,ear_d_bal                      -- 日初余额
       ,ear_m_bal                      -- 月初余额
       ,ear_s_bal                      -- 季初余额
       ,ear_y_bal                      -- 年初余额
       ,y_acm_bal                      -- 年累计余额
       ,s_acm_bal                      -- 季累计余额
       ,m_acm_bal                      -- 月累计余额
       ,cl_curr_ear_d_bal              -- 折本币日初余额
       ,cl_curr_ear_m_bal              -- 折本币月初余额
       ,cl_curr_ear_s_bal              -- 折本币季初余额
       ,cl_curr_ear_y_bal              -- 折本币年初余额
       ,cl_curr_y_acm_bal              -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal        -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal        -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal        -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal        -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal              -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal        -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal        -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal        -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal              -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal        -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal        -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal        -- 折本币年初月累计余额
       ,y_avg_bal                      -- 年日均余额
       ,q_avg_bal                      -- 季日均余额
       ,m_avg_bal                      -- 月日均余额
       ,cl_curr_y_avg_bal              -- 折本币年日均余额
       ,cl_curr_q_avg_bal              -- 折本币季日均余额
       ,cl_curr_m_avg_bal              -- 折本币月日均余额
       ,job_cd                         -- 任务代码
       ,etl_timestamp                  -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')             -- 数据日期
       ,t1.lp_id                                       -- 法人编号
       ,t1.acct_id                                     -- 账户编号
       ,t1.acct_name                                   -- 账户名称
       ,t1.cust_id                                     -- 客户编号
       ,nvl(trim(t2.rela_cont_id), t34.cont_id)        -- 合同编号
       ,case when t1.prod_id in ('203010400001','602060100002')
             then t1.dubil_id||t1.distr_flow_num
             else t1.dubil_id
             end                                       -- 借据号
       ,t1.dubil_id                                    -- 核心借据号
       ,t1.loan_num                                    -- 贷款号
       ,t3.pay_acct_no                                 -- 贷款放款账号
       ,nvl(trim(t3.rec_acct_no), t3.aut_acct_no)      -- 贷款还款账号
       ,''                                             -- 贴息人结算账号
       ,t3.wtr_acct_no                                 -- 委托存款账号
       ,t3.wts_acct_no                                 -- 委托人存款账号
       ,t4.tran_ref_no                                 -- 放款流水号
       ,''                                             -- 质押账号ID
       ,t1.distr_flow_num                              -- 出账号
       ,''                                             -- 关联票证编号
       ,t1.prod_id                                     -- 标准产品编号
       ,t1.camp_prod_id                                -- 产品编号
       ,(case when t22.asset_acct_status_cd = 'S' /*nvl(t36.abs_pric,0) <> 0*/ then nvl(t37.veripr_subjid,t37_1.veripr_subjid）
              else coalesce(trim(t37.normpr_subjid),trim(t37_1.normpr_subjid), trim(t37.reacin_subjid),trim(t37_1.reacin_subjid))
              end ) as subj_id                         -- 科目编号
       ,coalesce(trim(t37.normpr_subjid),trim(t37_1.normpr_subjid), trim(t37.reacin_subjid),trim(t37_1.reacin_subjid)) as init_pric_subj_id -- 原本金科目编号
       ,nvl(t37.reinre_subjid,t37_1.reinre_subjid)                              -- 表内利息科目编号
       ,(case when t22.asset_acct_status_cd = 'S' /*nvl(t36.abs_pric,0) <> 0*/ then nvl(t37.accrin_subjid,t37_1.accrin_subjid）
              else nvl(t37.regicr_subjid,t37_1.regicr_subjid)  end)                             -- 应收未收利息科目编号
       ,''                                             -- 应收应付利息调整科目编号
       ,nvl(t37.reacci_subjid,t37_1.reacci_subjid)                              -- 表外利息科目编号
       ,nvl(t37.regcir_subjid,t37_1.regcir_subjid)                              -- 应计已减值利息科目编号
       ,nvl(t37.intein_subjid,t37_1.intein_subjid)                             -- 利息收入科目编号
       ,''                                             -- 利息收入调整科目编号
       ,t41.subj_id                                    -- 价差损益科目编号
       ,nvl(trim(t36.init_loan_num),t1.accti_status_cd) --贷款形态代码
       ,case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd') then t1.last_acct_status_cd
             else t1.acct_status_cd
        end                                            -- 贷款账户状态代码
       ,t1.loan_tenor                                  -- 贷款期限
       ,t1.tenor_type_cd                               -- 贷款期限类型代码
       ,''                                             -- 贷款类别代码
       ,trim(t2.asset_thd_cls_cd)                      -- 资产三分类代码
       ,t2.belong_strip_line_cd                        -- 所属业务条线代码
       ,nvl(trim(t5.main_guar_way_cd),'-')             -- 担保方式代码
       ,t5.usage_descb                                 -- 贷款用途描述
       ,case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then '0'
             when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY') then '1'
             when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('WRN') then '2'
             else '-'
        end                                            -- 应计非应计代码
       ,case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY', 'WRN') then t11.modif_dt
             else ${iml_schema}.dateformat_max2('')
        end                                            -- 转非应计贷款日期
       ,t1.cust_mgr_id                                 -- 客户经理编号
       ,t1.open_acct_org_id                            -- 开户机构编号
       ,t1.mgmt_org_id                                 -- 管理机构编号
       ,t1.open_acct_org_id                            -- 账务机构编号
       ,t1.open_acct_dt                                -- 开户日期
       ,${iml_schema}.timeformat_max(t40.open_tran_timestamp)    -- 开户时间
       ,t1.open_acct_dt                                -- 放款日期
       ,t6.value_dt                                    -- 起息日期
       ,null                                           -- 停息日期
       ,t1.exp_dt                                      -- 到期日期
       ,t1.init_exp_dt                                 -- 原始到期日期
       ,t1.clos_acct_dt                                -- 销户日期
       ,${iml_schema}.timeformat_max(t40.close_tran_timestamp)   -- 销户时间
       ,''                                             -- 贴息标志
       ,0                                              -- 贴息比例
       ,t1.int_sub_closing_dt                          -- 贴息到期日
       ,t8.comm_fee_collect_way_cd                     -- 委托贷款手续费收取方式
       ,t19.entr_loan_comm_fee_rat                     -- 委托贷款手续费收取比例
       ,nvl(t8.comm_fee_amt, 0)                        -- 委托贷款手续费
       ,decode(t1.int_accr_flg, '1', '1', '0')         -- 计息标志
       ,nvl(trim(t34.loan_stop_accr_int_flg),'-')      -- 停息标志
       ,'0'                                            -- 减值标志
       ,decode(t1.need_manual_input_repay_plan_flg, '1', '1', '0')  -- 信贷发放还款计划标志
       ,''                                             -- 理财产品标志
       ,case when t6.discnt_int <> 0 then '1' else '0' end  -- 预付利息摊销标志
--       ,decode(t13.acr_amortize_value, 'Y', '1', '0')  -- 预付利息摊销标志
--       ,case when trim(t3.aut_acct_no) is not null then '1' else '0' end  -- 本金自动扣收标志
--       ,case when trim(t3.aut_acct_no) is not null then '1' else '0' end  -- 利息自动扣收标志
       ,nvl(trim(t34.auto_payoff_flg),'-')             -- 本金自动扣收标志
       ,nvl(trim(t34.auto_payoff_flg),'-')             -- 利息自动扣收标志
       ,''                                             -- 承兑标志
       ,'0'                                            -- 政府融资平台贷款标志
       ,decode(t13.taxable_value, 'Y', '1', '0')       -- 扣税标志
       ,case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('WRN') then '1'
             else '0'
        end                                            -- 核销标志
       ,case when trim(t7.modif_content_key_val) is not null then '1' else '0' end  -- 展期标志
       ,nvl(t7.renew_cnt, 0)                            -- 展期次数
       ,t42.modif_dt                                    -- 首次展期到期日期期期
       ,to_date(t7.modif_post_val, 'yyyymmdd')          -- 展期到期日期期
       ,t34.repay_flg                                   -- 允许提前还款标志
       ,t1.loan_auto_repay_type_cd                      -- 还款次序代码
       ,'1'                                             -- 提前还款方式代码
       ,t1.curr_cd                                      -- 保证金币种代码
       ,nvl(trim(t12.base_rat_id),'2210')               -- 利率基准类型代码
       ,t12.base_rat_id                                 -- 利率曲线类型代码
       ,nvl(t24.bank_int_int_rat, 0)                            -- 基准利率
       ,nvl(t24.exec_int_rat, 0)                        -- 执行利率
       ,t24.int_rat_modif_ped_cd                        -- 重定价方式代码
       ,t24.int_set_freq_cd                             -- 普通贷款结息方式代码
       ,case when t24.int_rat_start_use_way_cd = 'N' then '0'
             when t24.int_rat_start_use_way_cd in ('A', 'R', 'S', 'F') then '1'
             else '-'
        end                                            -- 利率调整方式代码
       ,case when trim(t24.sub_acct_int_rat_float_ratio) is not null then '1'
             when trim(t24.sub_acct_int_rat_float_point) is not null then '2'
             else '-'
        end                                            -- 利率浮动方式代码
       ,case when t24.int_rat_start_use_way_cd = 'A' then 'D'
	         else nvl(t29.eh_issue_corp_cd, '-')
        end                                			   -- 利率调整周期单位代码
	  -- ,nvl(t29.eh_issue_corp_cd, '-')               -- 利率调整周期单位代码
	   ,case when t24.int_rat_start_use_way_cd = 'A' then  1
	         else nvl(t29.eh_issue_qtty, 0) 
        end                                            -- 利率调整周期频率
      --  ,nvl(t29.eh_issue_qtty, 0)                   -- 利率调整周期频率  
       ,case when trim(t24.sub_acct_int_rat_float_ratio) is not null then to_number(trim(t24.sub_acct_int_rat_float_ratio)*nvl(t24.bank_int_int_rat, 0))
               else to_number(trim(t24.sub_acct_int_rat_float_point)) end  -- 利率浮动值
       ,nvl(t47.news_date,t24.last_int_rat_modif_dt)   -- 当前利率生效日期
       ,t24.next_int_rat_modif_dt                      -- 下次利率调整日期
       ,nvl(trim(t46.int_accr_flg),'-')                -- 复息标志
       ,t24.int_set_freq_cd                            -- 结息方式代码
       ,nvl(trim(t24.int_accr_way_cd),'-')             -- 计息方式代码
       ,t1.repay_way_cd                                -- 还款方式代码
       ,nvl(trim(t35.eh_issue_corp_cd),'-')            -- 还款周期单位代码
       ,nvl(t35.eh_issue_qtty, 0)                      -- 还款周期
       ,''                                             -- 款项使用类型
       ,''                                             -- 额度类型
       ,t1.abs_flg                                     -- 资产证券化标志
       ,t1.flg_cd                                      -- 资产转让标志
       ,nvl(trim(t22.asset_acct_status_cd),'-')        -- 资产转让状态代码
       ,t22.pkg_tran_dt                                -- 资产转让日期
       ,nvl(t23.pack_amt, 0)                           -- 转让前应收利息
       ,case when nvl(trim(t36.acct_status_cd),t1.acct_status_cd) = 'C' then '0'
             when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC') then '0'
             when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY', 'YUQ','WRN') then '1'
             else ''
        end                                            -- 逾期标志
       ,case when nvl(t40.pri_due_days,0) >0 then '1' else '0' end   -- 本金逾期标志
       ,case when nvl(t40.int_due_days,0) >0 then '1' else '0' end   -- 利息逾期标志
       ,nvl(t15.curr_ovdue_perds, 0)                   -- 当前逾期期数
       ,nvl(t40.pri_due_days, 0)                       -- 本金逾期天数
       ,nvl(t40.int_due_days, 0)                       -- 利息逾期天数
       ,nvl(t14.ovdue_pric_bal, 0)                     -- 逾期本金余额
       ,nvl(t14.ovdue_int_amt, 0) /*+ nvl(t31.int_accrued_prev,0) + nvl(t38.int_accrued_prev,0)+nvl(t6.ld_acm_int_adj_amt,0)*/  -- 逾期利息金额
       ,case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('WRN') then 0
             else nvl(t14.ovdue_comp_int_amt, 0) /*+ nvl(t38.int_accrued_prev,0)+nvl(t38.ld_acm_int_adj_amt,0) */
        end                                            -- 逾期复利金额
       ,case when decode(t40.pri_first_date,to_date('00010101', 'yyyymmdd'),to_date('29991231', 'yyyymmdd'),t40.pri_first_date) <= decode(t40.int_first_date,to_date('00010101', 'yyyymmdd'),to_date('29991231', 'yyyymmdd'),t40.int_first_date) 
             then t40.pri_first_date 
             else t40.int_first_date end               -- 首次逾期日期                                           
       ,t40.pri_first_date                             -- 本金逾期日期
       ,t40.int_first_date                             -- 利息逾期日期
       ,nvl(t28.exec_int_rat, 0)                       -- 逾期利率
       ,case when trim(t28.sub_acct_int_rat_float_ratio) is not null then to_number(trim(t28.sub_acct_int_rat_float_ratio)*nvl(t28.bank_int_int_rat,0))
               else to_number(trim(t28.sub_acct_int_rat_float_point)) end  -- 逾期利率浮动值
       ,nvl(t15.tot_perds, 0)                          -- 贷款期数
       ,t1.curr_pd                                     -- 当前期数
       ,case when t25.acct_id is not null then t25.last_repay_dt else nvl(t27.last_repay_dt,t27_1.last_repay_dt) end                                          -- 上次还款日期
       ,least(t16.next_repay_dt,t33.next_repay_dt)     -- 下次还款日期
       ,t1.curr_cd                                     -- 币种代码
       ,nvl(t16.next_rpp_amt, 0)                       -- 下次还本金额
       ,nvl(t33.next_repay_int_amt, 0)                 -- 下次还息金额
       ,case when t1.prod_id like '6020301%' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ','WRN') then nvl(t6.provi_day_provi_int, 0) + nvl(t6.provi_day_int_adj_amt, 0) + nvl(t31.provi_day_provi_int,0) + nvl(t31.provi_day_int_adj,0)
                        else 0
                   end
        end                                            -- 当日应计利息
       ,case when t1.prod_id like '6020301%' then 0
             else  case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ','WRN') then nvl(t6.ld_acm_provi_int,0) + nvl(t6.ld_acm_int_adj_amt,0) + nvl(t31.int_accrued_prev,0) + nvl(t31.int_adj_prev,0)
                        else 0
                   end
        end                                             -- 当期应计利息
       ,nvl(t39.int_income, 0) + nvl(t39.tax_amt, 0)    -- 当日利息收入
       ,nvl(t39.discnt_int,0)                           -- 当日利息收入调整
       ,nvl(t39.tax_amt, 0)                             -- 当日税额收入
       ,case when t41.debit_crdt_dir_cd = 'D' then nvl(t41.tran_amt, 0) * -1  else nvl(t41.tran_amt, 0) end -- 当日价差损益
       ,nvl(t5.cont_amt, 0)                             -- 合同金额
       ,nvl(t17.distr_amt, 0)                           -- 借据金额
       ,nvl(t17.distr_amt, 0)                           -- 放款金额
       ,nvl(t17.ld_nomal_pric, 0)                       -- 正常本金
       ,case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('WRN') then 0
             else nvl(t17.ld_ovdue_pric,0)
        end                                             -- 逾期本金
       ,nvl(t17.ld_grace_period_pric,0)                 -- 宽限期本金
       ,nvl(t17.ld_grace_period_int,0)                  -- 宽限期利息
       ,0                                               -- 呆滞本金
       ,0                                               -- 呆账本金
       ,case when t1.prod_id like '6020301%' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) IN ('ZHC', 'YUQ') then nvl(t17.ld_ovdue_int,0)
                       else 0
                  end
        end                                             --应收欠息
       ,case when t1.prod_id like '6020301%' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) IN ('ZHC', 'YUQ') then nvl(t31.int_accrued_prev,0)+nvl(t31.int_adj_prev,0)
                       else 0
                  end
        end                                             --应收应计罚息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t31.int_accrued_prev,0)+ nvl(t31.int_adj_prev,0) else 0 end
        end                                             -- 催收应计罚息
       ,case when t1.prod_id LIKE '6020301%' THEN 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t17.ld_ovdue_pnlt, 0)
                       else 0
                  end
         end                                            -- 应收罚息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t17.ld_ovdue_pnlt,0) else 0 end
        end                                                                -- 催收罚息
       ,case when t1.prod_id like '6020301%' then 0 else nvl(t38.int_accrued_prev,0)+nvl(t38.int_adj_prev,0) end                       -- 应计复息
       ,case when t1.prod_id like '6020301%' then 0 else nvl(t17.ld_ovdue_comp_int, 0) end                  -- 应收复息
       ,0                                               -- 应收费用
       ,nvl(t36.wrtn_off_pric, 0)                       -- 核销本金
       ,nvl(t36.wrtn_off_int, 0)                        -- 核销利息
       ,case when t1.prod_id LIKE '6020301%' THEN 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_ovdue_pnlt, 0)
                       else 0
                  end
         end                                            -- 表内欠息余额
       ,case when t1.prod_id LIKE '6020301%' THEN 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY') then nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_ovdue_pnlt, 0)
                       else 0
                  end
         end                                            -- 表外欠息余额
       ,case when t1.prod_id like '6020301%' then 0
             when nvl(t6.discnt_int,0) <> 0 and nvl(t17.ld_nomal_pric,0) + nvl(t17.ld_ovdue_pric,0) - nvl(t18.ld_wrt_off_pric, 0) > 0 then nvl(t6.discnt_int,0) - nvl(t6.ld_acm_provi_int, 0)
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') and nvl(t6.discnt_int,0) = 0 then nvl(t6.ld_acm_provi_int, 0) + nvl(t6.ld_acm_int_adj_amt,0) + nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_ovdue_pnlt, 0) + nvl(t31.int_accrued_prev,0) + nvl(t31.int_adj_prev,0)
                       when nvl(trim(t36.init_loan_num),t1.accti_status_cd) = 'WRN' then nvl(t31.int_accrued_prev,0) + nvl(t31.int_adj_prev,0)
                      else 0
                  end
        end                                              -- 表内利息
       ,case when t1.prod_id like '6020301%' then 0
             else case when nvl(trim(t36.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY') then /*nvl(t6.ld_acm_provi_int, 0) + nvl(t6.ld_acm_int_adj_amt,0) + */nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_ovdue_pnlt, 0) + nvl(t17.ld_ovdue_comp_int, 0)
                       else 0
                   end
        end                                             -- 表外利息
--       ,nvl(t36.recvbl_uncol_int, 0) + nvl(t36.non_acru_int_recvbl, 0) + nvl(t36.acru_aldy_impam_int, 0)        -- 累计应收未收利息金额
       ,case when t1.prod_id like '6020301%' then 0
             else nvl(t17.ld_ovdue_int,0) + nvl(t17.ld_ovdue_pnlt, 0) + nvl(t17.ld_ovdue_comp_int, 0)
        end                                                                                                    -- 累计应收未收利息金额
       ,nvl(t36.recvbl_uncol_int, 0)                                                                            -- 应收未收利息_计量后
       ,nvl(t36.int_recvbl, 0)                                                                                  -- 应收利息_计量后
       ,nvl(t36.non_acru_int_recvbl, 0)                                                                         -- 非应计应收利息_计量后
       ,nvl(t36.acru_aldy_impam_int, 0)                                                                         -- 应计已减值利息
       ,nvl(t36.discnt_int, 0)                                                                                  -- 贸易融资利息调整
       ,nvl(t17.distr_amt, 0) - (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0) + nvl(t36.wrtn_off_pric, 0))     -- 已偿还本金
       ,nvl(t25.repaid_int, 0)                          -- 已偿还利息
       ,nvl(t25.repaid_pnlt, 0)                         -- 已偿还罚息
       ,nvl(t25.repaid_comp_int, 0)                     -- 已偿还复利
       ,0                                               -- 已偿还费用
       ,nvl(t36.wrtn_off_advc_money,0)                  -- 核销垫付费金额
       ,nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0) + nvl(t36.wrtn_off_pric, 0)           -- 本金余额
       ,nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)   --当期余额
       ,(nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) * nvl(trim(t26.convt_cny_exch_rat),1)      --折本币当期余额
       ,coalesce(t27.currt_bal,t27_1.currt_bal,0)                                                    --日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) else coalesce(t27.ear_m_bal,t27_1.ear_m_bal,0.0) end       --月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0)  else coalesce(t27.ear_s_bal,t27_1.ear_s_bal,0.0) end   --季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) else coalesce(t27.ear_y_bal,t27_1.ear_y_bal,0.0) end     --年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) else coalesce(t27.y_acm_bal,t27_1.y_acm_bal,0.0)+nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) end          --年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) else coalesce(t27.s_acm_bal,t27_1.s_acm_bal,0.0) + nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) end       --季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) else coalesce(t27.m_acm_bal,t27_1.m_acm_bal,0.0) + nvl((nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)),0) end               --月累计余额
       ,coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0)     --折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_m_bal,t27_1.cl_curr_ear_m_bal, 0.0) end       --折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_s_bal,t27_1.cl_curr_ear_s_bal,0.0) end     --折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_y_bal,t27_1.cl_curr_ear_y_bal,0.0) end      --折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal,0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end        --折本币年累计余额
       ,coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0)                                                                                                                                          -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_m_y_acm_bal,t27_1.cl_curr_ear_m_y_acm_bal, 0.0) end                                         -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_s_y_acm_bal,t27_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_y_acm_bal,t27_1.cl_curr_ear_y_y_acm_bal, 0.0) end                                       -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end   -- 折本币季累计余额
       ,coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0)                                                                                                                                          -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_s_y_acm_bal,t27_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_s_acm_bal,t27_1.cl_curr_ear_y_s_acm_bal, 0.0) end                                       -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end    -- 折本币月累计余额
       ,coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0)                                                                                                                                          -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_m_m_acm_bal,t27_1.cl_curr_ear_m_m_acm_bal, 0.0) end                                         -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_m_acm_bal,t27_1.cl_curr_ear_y_m_acm_bal, 0.0) end                                       -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) else coalesce(t27.y_acm_bal,t27_1.y_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) else coalesce(t27.s_acm_bal,t27_1.s_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) else coalesce(t27.m_acm_bal,t27_1.m_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0)) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) + (nvl(t36.nomal_pric, 0) + nvl(t36.log_pric, 0) + nvl(t36.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
       ,t1.job_cd  -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 数据处理时间
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_dubil_info_h t2
    on (case when t1.prod_id in ('203010400001','602060100002')
             then t1.dubil_id||t1.distr_flow_num
             else t1.dubil_id
             end) = t2.dubil_id
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd ='icmsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_01 t3
    on t1.acct_id = t3.acct_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_02 t4
    on t1.acct_id = t4.acct_id
   and t4.rn = 1
  left join ${iml_schema}.agt_loan_cont_info_h t5
    on t2.rela_cont_id = t5.cont_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd ='icmsf1'
  left join ${iml_schema}.agt_loan_acct_int_dtl_h t6
    on t1.agt_id = t6.agt_id
   and t6.int_cls_cd = 'INT'
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd ='ncbsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_03 t7
    on t1.acct_id = t7.modif_content_key_val
   -- t1.loan_num = t7.loan_num
   and t7.rn = 1
  left join ${iml_schema}.agt_loan_out_acct_appl_h t8
    on t2.rela_out_acct_flow_num = t8.out_acct_flow_num
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd ='icmsf1'
--  left join ${iml_schema}.agt_loan_int_rat_h t9
--    on t1.loan_num = t9.loan_num
--   and t9.int_cls_cd = 'INT'
--   and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
--   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
--   and t9.job_cd ='ncbsf1'
--  left join ${iml_schema}.agt_loan_int_rat_h t10
--    on t1.loan_num = t10.loan_num
--   and t10.int_cls_cd = 'ODP'
--   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
--   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
--   and t10.job_cd ='ncbsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_04 t11
    on t1.acct_id = t11.modif_content_key_val
   and t11.rn = 1
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_06 t13
    on t1.prod_id = t13.prod_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_07 t14
    on t1.acct_id = t14.acct_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_08 t15
    on t1.acct_id = t15.acct_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_09 t16
    on t1.acct_id = t16.acct_id
   and t1.curr_pd = t16.curr_pd
  left join ${iml_schema}.agt_loan_acct_bal_h t17
    on t1.agt_id = t17.agt_id
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t17.job_cd ='ncbsf1'
  left join (select t1.*,row_number()over(partition by t1.acct_id order by t1.wrt_off_dt desc) as rn
          from  ${iml_schema}.agt_loan_acct_wrt_off_h t1
	       where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and t1.job_cd = 'ncbsf1') t18
    on t1.agt_id = t18.agt_id
	and t18.rn=1
  left join ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h t19
    on t8.out_acct_flow_num = t19.out_acct_flow_num
   and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t19.job_cd ='icmsf1'
  left join ${iml_schema}.agt_loan_acct_attach_info_h t34
    on t1.loan_num = t34.loan_num
   and t34.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t34.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t34.job_cd ='ncbsf1'
--  left join ${icl_schema}.cmm_prod_and_subj_map_rela t21
--    on t1.prod_id = t21.sellbl_prod_id
--   and t21.bus_type_cd in ('NCBS', 'LN')
--   and t21.etl_dt = to_date('${batch_date}', 'yyyymmdd')
--   and nvl(decode(trim(t34.cap_char_cd),'0000','*',trim(t34.cap_char_cd)),'*') = nvl(trim(t21.accti_prod_attr_cd1),'*')
/*  left join ${iml_schema}.agt_abs_cont_dtl_h t22
    on t1.acct_id = t22.acct_id
   and t22.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t22.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t22.job_cd ='ncbsf1'
   and t22.asset_acct_status_cd not in ('C','E', 'I')  -- P-封包、S-发行、C-撤包、E-发行撤销、B-赎回销
   and exists (select 1 from ${iml_schema}.agt_abs_cont_h ctc
                where t22.asset_bag_cont_id = ctc.asset_bag_cont_id
                  and ctc.asset_bag_cont_status_cd in ('YP', 'YS', 'PB')
                  and ctc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and ctc.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and ctc.job_cd ='ncbsf1')
*/
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_16 t22
    on t1.acct_id = t22.acct_id
   and t22.rn = 1
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_11 t23
    on t22.asset_bag_cont_dtl_seq_num = t23.asset_bag_cont_dtl_seq_num
  left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h t24
    on t1.acct_id = t24.acct_id
   and t24.int_cls_cd = 'INT'
   and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t24.job_cd ='ncbsf1'
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_05 t12
    on t24.int_rat_type_cd = t12.base_rat_id
   and t1.curr_cd = t12.curr_cd
   and t12.rn = 1
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_12 t25
    on t1.acct_id = t25.acct_id
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t26
    on t1.curr_cd = t26.curr_cd
   and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t26.end_dt > to_date('${batch_date}','yyyymmdd')
   and t26.job_cd = 'ncbsf1'
  left join ${icl_schema}.cmm_corp_loan_acct_info t27
    on t1.dubil_id = t27.dubil_num
   and t1.lp_id = t27.lp_id
   and t27.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  <=to_date('20230502', 'yyyymmdd')    --新一代投产时0501为旧数据，0502为新数据，0502日前的数据关联前一日需使用借据号关联(包括0502)，0503日后的数据需使用账号关联
  left join ${icl_schema}.cmm_corp_loan_acct_info t27_1
    on t1.acct_id = t27_1.acct_id
   and t1.lp_id = t27_1.lp_id
   and t27_1.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  >to_date('20230502', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h t28
    on t1.acct_id = t28.acct_id
   and t28.int_cls_cd = 'ODP'
   and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t28.job_cd ='ncbsf1'
  left join ${iml_schema}.ref_ped_freq_para t29
    on t24.int_rat_modif_ped_cd = t29.ped_freq_cd
   and t29.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t29.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t29.job_cd ='ncbsf1'
 left join ${iml_schema}.prd_loan_prod_info_h t30
    on t1.prod_id = t30.prod_id
--   and t30.crdt_prod_cate_cd not in ('2','3','4')   --零售贷款,联合网贷,个人委托贷款
   and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t30.end_dt > to_date('${batch_date}','yyyymmdd')
   and t30.job_cd = 'icmsf1'
  left join (select acct_id,
       sum(ld_acm_provi_int) as int_accrued_prev,
       sum(int_amt) as int_amt,
       sum(ld_acm_int_adj) as int_adj_prev,
       sum(provi_day_provi_actl_amt) as provi_day_provi_actl_amt,
       sum(provi_day_provi_int) as provi_day_provi_int,
       sum(provi_day_int_adj) as provi_day_int_adj
              from ${iml_schema}.agt_loan_acct_pnlt_int_accr_h   --贷款账户罚息计息历史
             where int_cls_cd = 'ODP'
               and job_cd = 'ncbsf1'
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               group by acct_id) t31
    on t1.acct_id = t31.acct_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_10 t33
    on t1.acct_id = t33.acct_id
   and t1.curr_pd = t33.curr_pd
  left join ${iml_schema}.ref_ped_freq_para t35
    on t24.int_set_freq_cd = t35.ped_freq_cd
   and t35.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t35.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t35.job_cd ='ncbsf1'
  left join ${iml_schema}.evt_loan_sub_acct_measure_flow t36
    on t1.loan_num||t1.distr_flow_num = t36.core_loan_num
   and t36.job_cd = 'tglsi1'
   and t36.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_14 t37
    on t1.prod_id = t37.sellbl_prod_id
   and t1.prod_id like '4%'
   and nvl(decode(trim(t34.cap_char_cd),'0000','*',trim(t34.cap_char_cd)),'*') = nvl(trim(replace(t37.prod_attr_cd,'-',null)),'*')
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_14 t37_1
    on t1.prod_id = t37_1.sellbl_prod_id
   and t1.prod_id not like '4%'
  left join (select acct_id,
                    sum(ld_acm_int_adj) as int_adj_prev,
                    sum(ld_acm_provi_int) as int_accrued_prev
               from ${iml_schema}.agt_loan_acct_comp_int_int_accr_h   --贷款账户复利计息历史
              where int_cls_cd = 'ODI'
                and job_cd = 'ncbsf1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                group by acct_id) t38
    on t1.acct_id = t38.acct_id
  left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_15 t39
    on t1.loan_num||t1.distr_flow_num = t39.core_loan_num
 left join ${iol_schema}.ncbs_cl_acct_attach t40
    on t1.acct_id = t40.internal_key
   and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iml_schema}.evt_accti_midgrod_acct_ety  t41
   on t41.sorc_sys_dt = t36.tran_dt
   and t41.sorc_sys_flow_num = t36.tran_flow_num
   and t41.ova_flow_num = t36.ova_flow_num
   and t41.src_tran_flow_seq_num = t36.tran_flow_seq_num
   and t41.sob_id = '1'
   and t41.subj_id = '61110701'
   and t41.sellbl_prod_id IN ('203020300001','203020300002','203030600001','203030600002')
   and t41.etl_dt=to_date('${batch_date}', 'yyyymmdd')
   left join ${icl_schema}.tmp_cmm_corp_loan_acct_info_17 t42
   on t1.acct_id = t42.modif_content_key_val
   left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h t46
    on t1.acct_id = t46.acct_id
   and t46.int_cls_cd = 'ODI'
   and t46.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t46.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t46.job_cd ='ncbsf1'
   left join (
            select t.internal_key as acct_id
                  ,max(t.start_date)  as news_date
              from ${iol_schema}.ncbs_cl_int_split t
             where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
              group by t.internal_key
            ) t47
    on t1.acct_id = t47.acct_id
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd ='ncbsf1'
   and decode(trim(t1.auto_revs_flg),NULL,'-',t1.auto_revs_flg) <> 'Y'   --剔除自动冲正的数据
   and t1.acct_aldy_check_flg <> '0'
   and t1.open_acct_dt <=to_date('${batch_date}', 'yyyymmdd')
   and (t30.crdt_prod_cate_cd not in ('2','3','4') or t1.prod_id ='602030100003')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_acct_info_ex;

-- 3.1 drop ex table

--drop table ${icl_schema}.cmm_corp_loan_acct_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_07 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_08 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_09 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_10 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_11 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_12 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_13 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_14 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_15 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_16 purge;
--drop table ${icl_schema}.tmp_cmm_corp_loan_acct_info_17 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_corp_loan_acct_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

