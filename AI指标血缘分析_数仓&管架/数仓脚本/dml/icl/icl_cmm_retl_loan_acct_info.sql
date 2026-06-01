/*
Purpose:    共性加工层-零售贷款账户信息:包括所有的行内零售贷款账户信息，包含零售贷款、个人委托贷款等业务的账户信息，数据来源于新核心系统NCBS。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_retl_loan_acct_info
Createdate: 20190415
Logs:
            20220330 翟若平 1、新增字段【本金逾期日期、利息逾期日期、展期到期日期、资产转让日期】
                            2、新核心没有相关信息项而置空处理的字段
	                         【承诺贷款标志-PROMIS_LOAN_FLG、按一逾两呆核算标志-OOTS_ACCTI_FLG、贷款形态分科目核算标志-LOAN_MODAL_DG_SUBJ_ACCTI_FLG、
	                          周期性放款标志-PED_DISTR_FLG】
                            3、待新核心确认取数口径的字段
	                          【不规则还款方式代码-IRR_REPAY_WAY_CD、允许提前还款标志-ALLOW_ADV_REPAY_FLG、上次还款日期-LAST_REPAY_DT、应收应计利息-RECVBL_ACRU_INT、催收应计利息-COLL_ACRU_INT、应收应计罚息-RECVBL_ACRU_PNLT、催收应计罚息-COLL_ACRU_PNLT、
	                           应收罚息-RECVBL_PNLT、催收罚息-COLL_PNLT、应计复息-ACRU_COMP_INT、应收复息-RECVBL_COMP_INT、应计贴息-ACRU_INT_SUB、应收贴息-RECVBL_INT_SUB、待摊利息-AMORTED_INT、核销本金-WRT_OFF_PRIC、核销利息-WRT_OFF_INT、利息收入-INT_INCOME、核销垫付费余额-WRT_OFF_ADVC_FEE_BAL、核销垫付费金额-WRT_OFF_ADVC_FEE_AMT、应收罚金-RECVBL_FINE、罚金收入-FINE_INCO、
	                           准备金-RESV、应收欠息-RECVBL_OVER_INT、催收欠息-COLL_OVER_INT、已偿还本金-REPAID_PRIC、已偿还利息-REPAID_INT、已偿还罚息-REPAID_PNLT、已偿还复利-REPAID_COMP_INT、已偿还费用-REPAID_FEE、】
	          20220407 温旺清 1、新增字段【贴息标志、逾期计息方式代码、逾期罚息浮动方式代码】
            20220518 温旺清 1、修改T13的取数来源表：prd_prod_attr_info_h ->prd_prod_def_h
            20220606 温旺清 1、新增字段【贷款号】
            20220619 陈伟峰 1、调整字段【科目编号、原本金科目编号、表内利息科目编号、表外利息科目编号、利息收入科目编号、资产三分类代码、计息规则、利率调整方式代码、执行利率、利率浮动方式代码、利率调整周期单位代码、利率调整周期频率、利率浮动值、当前利率生效日期、下次利率调整日期、结息方式代码、计息方式代码、资产转让状态代码、资产转让日期、转让前应收利息、逾期标志、逾期利率、逾期利率浮动值、上次还款日期、应收应计利息、应收应计罚息、应计复息、待摊利息、应收罚金、应收欠息、催收欠息、表内利息、表外利息、累计应收未收利息金额、已偿还本金、已偿还利息、已偿还罚息、已偿还复利、本金余额、当期余额、折本币当期余额、逾期计息方式代码、逾期罚息浮动方式代码、余额积数相关字段】的加工口径
                            2、置空字段【利息收入调整科目编号-INT_INCOME_ADJ_SUBJ_ID、会计类别代码-ACCTNT_CATE_CD、衍生贷款标志-DERIV_LOAN_FLG、贴息标志-INT_SUB_FLG、不规则还款方式代码-IRR_REPAY_WAY_CD、冻结可放金额-FROZ_DISTRD_AMT、可发放金额-DISTRD_AMT、呆滞本金-IDLE_PRIC、呆账本金-BAD_DEBT_PRIC、贷款基金-LOAN_FUND、催收应计利息-COLL_ACRU_INT、催收应计罚息-COLL_ACRU_PNLT、催收罚息-COLL_PNLT、应计贴息-ACRU_INT_SUB、应收贴息-RECVBL_INT_SUB、核销垫付费余额-WRT_OFF_ADVC_FEE_BAL、核销垫付费金额-WRT_OFF_ADVC_FEE_AMT、罚金收入-FINE_INCO、准备金-RESV、已偿还费用-REPAID_FEE】
                            3、调整T20表的映射原表
            20220624 温旺清 1、调整字段【科目编号、原本金科目编号、表内利息科目编号、表外利息科目编号、利息收入科目编号】的加工口径
                            2、新增字段【应收未收利息科目编号、应收应付利息调整科目编号、应计已减值利息科目编
            20220722 温旺清	1、调整字段【贷款账户状态代码、应计非应计代码、核销标志、逾期标志、贷款形态代码】的加工口径；
                            2、调整T14临时表的加工逻辑【去掉ACCOUNTING_STATUS NOT IN ('ZHC', 'TER')】
            20220728 李森辉 1、调整【表内利息】加工逻辑
            20220729 翟若平 调整字段【放款日期】的加工口径
            20220817 李森辉 调整下次还款信息零售贷款的区分逻辑
	          20221008 黄俊杰 【逾期罚息浮动方式代码】,case when t28.int_rat_start_use_way_cd = 'N' then '0'
                                                          when t28.sub_acct_int_rat_float_ratio <> 0 then '1'
                                                          when t28.sub_acct_int_rat_float_point <> 0 then '2'
                                                          else '-'
                                                     end
		        									去掉 t28.int_rat_start_use_way_cd = 'N' then '0'                                                              --
            20221106 陈伟峰 1、调整【当日应计利息、当日利息收入、当日利息收入调整、当期应计利息、应收应计利息、催收应计利息、应收应计罚息、催收应计罚息、应计复息、应收欠息、催收欠息、表内利息、表外利息】加工口径
            20221108 曹永茂 调整【利率浮动方式代码、利率浮动值、逾期计息方式代码、逾期罚息浮动方式代码、逾期利率浮动值】的加工口径
            20221128 翟若平 调整字段【当日利息收入、当日利息收入调整】的加工口径
            20221201 温旺清 增加表agt_abs_cont_dtl_h 的过滤条件 t22.asset_acct_status_cd not in ('C','E')  --c:撤包 E:发行撤销
            20221220 陈伟峰 调整上日表关联条件，增加投产日期前后区分判断
            20221222 温旺清 调整 evt_repay_dtl 的算法
            20221228 温旺清 调整临时表T22（agt_abs_cont_dtl_h）的加工逻辑 增加条件【t.asset_acct_status_cd not in ('I','S')】过滤资产转让的业务
            20230118 陈伟峰 调整科目相关字段加工逻辑，tmp_cmm_retl_loan_acct_info_14表增加资金性质字段用于关联
            20230206 陈伟峰 调整基数字段加工逻辑，加入投产日关联字段判断逻辑
            20230208 陈伟峰 调整【复息标志】字段取值逻辑，原取值字段INT_PENALTY含义为是否收取复息，非复息标志
            20230214 陈伟峰 调整核算状态取值逻辑，优先取核算中台的核算状态
            20230314 温旺清 新增字段【出账号】
            20230323 陈伟峰 调整tmp_cmm_retl_loan_acct_info_14表关联逻辑，判断4开头的产品使用资金性质关联，非4开头的产品不使用资金性质关联
            20230526 陈伟峰 调整逾期天数及标志信息中的NCBS_CL_INVOICE_OD_DETAIL字段，使用END_DATE作为利息逾期日期
            20230608 陈伟峰 调整展期信息临时表的取数逻辑
            20230609 陈伟峰 过滤开户日期大于跑批日期的数据
			      20230615 陈伟峰 调整tgls_loan_busi_h表取数逻辑，增加tgls_loan_busi表数据，用于支持年批
			      20230720 陈伟峰 调整【本金逾期标志、利息逾期标志、本金逾期天数、利息逾期天数、首次逾期日期、本金逾期日期、利息逾期日期】取数逻辑
            20230830 徐子豪 新增字段【资产证券化标志、资产转让标志、宽限期利息】
            20231012 陈伟峰 调整【贷款期数】加工逻辑，过滤提前还款的999期次
            20231206 徐子豪 新增字段【原始到期日期】
            20231225 陈伟峰 调整临时表tmp_cmm_corp_loan_acct_info_08加工逻辑，增加or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')
            20231225 饶雅 调整部分基数字段加工逻辑 
            20240521 陈伟峰 调整evt_loan_acct_info_modif_oper_dtl取数条件，过滤跑批后数据
            20240626 饶雅 1、调整【当日利息收入】取数逻辑，增加减值转换金额的取数2、新增字段【首次展期到期日期期期】FIR_RENEW_EXP_DT
            20240724 陈伟峰 调整【核销垫付费金额】加工逻辑
            20240822 陈伟峰 新增字段【开户时间、销户时间】
            20241213 谢宁 调整【COMP_INT_FLG 复息标志】原取核心传送的信贷规则,通过根据产品是否允许计算复利来对贷款账户打标,现核心提供的取数口径是根据贷款账户是否登记计算复利来打标,因部分涉及产品项下不能打标而实际操作是能登记计算复利的,因此后者站在账户层面打标更为准确。
            20241216 谢宁 调整【不规则还款方式代码】原赋空值， ('5-按频率付息，任意本金','10-组合还款','15-自定义还款'),划为不规则还款。
            20241216 谢宁 调整【待摊利息】原赋空值，取数来源
            20241216 谢宁 调整【应收复息】取数来源
            20250106 陈伟峰 新增【网商贷-房抵贷】产品数据
            20250526 陈伟峰 调整【应收未收利息科目编号】加工逻辑，当发生资产证券化时，科目取表外科目
			20250702 陈  凭 调整【利率调整周期单位代码 INT_RAT_ADJ_PED_CORP_CD、利率调整周期频率 INT_RAT_ADJ_PED_FREQ】取数逻辑
            20250801 陈伟峰 调整资产转让逻辑，剔出封包数据
            20251029 陈伟峰 调整资产转让逻辑，【资产转让日期】从封包日期改为发行日期
            20251107 陈伟峰 优化展期信息取数逻辑
            20251127 陈伟峰 调整【逾期利率浮动值、利率浮动值】逻辑，当利率启用方式为随基准利率变更和按周期变更时，取核心利率浮动比例*基准利率或者利率浮动值，否则为0
            20251203 陈伟峰 调整【基准利率base_rat】取值逻辑，不取每日更新基准利率，改为取放款时间核心登记的利率
            20251226 陈伟峰 调整【逾期利率浮动值、利率浮动值】逻辑，去除判断利率启用方式为随基准利率变更和按周期变更的判断规则，直接取核心利率浮动比例*基准利率或者利率浮动值
			20260331 陈伟峰 调整第二组房抵贷的逾期天数，增加默认值0处理


*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_01 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_02 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_03 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_04 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_05 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_06 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_07 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_08 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_09 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_10 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_11 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_12 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_13 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_14 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_15 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_16 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_17 purge;
drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_18 purge;

-- 1.3 insert data to temp table
--1.3.1 获取账户结算信息(t3)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_01
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


--1.3.2 获取贷款发放信息（放款流水号、放款日期、发放方式代码等）(t4)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_02
nologging
compress ${option_switch} for query high
as
select
       cd.acct_id    -- 账户编号
       ,cd.distr_dt -- 放款日期
       ,cd.distr_way_cd --发放方式代码
       ,cd.seq_num   -- 序号
       ,row_number() over(partition by cd.acct_id order by cd.seq_num desc) rn
  from ${iml_schema}.evt_loan_distr_flow cd
where cd.job_cd = 'ncbsi1'
;

--1.3.3 获取展期信息（展期标志、展期次数、展期到期日等）(t7)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_03
nologging
compress ${option_switch} for query high
as
select modif_content_key_val
       ,coalesce(json_value(modif_bf_val, '$.maturityDate'),json_value(modif_bf_val, '$.matudt'),json_value(modif_bf_val, '$.DUE_DATE')) as modif_bf_val
       ,coalesce(json_value(modif_post_val, '$.maturityDate'),json_value(modif_post_val, '$.matudt'),json_value(modif_post_val, '$.DUE_DATE')) as modif_post_val
       ,row_number() over(partition by modif_content_key_val order by modif_dt desc) as rn  --最新变更日期
       ,count(1) over(partition by modif_content_key_val order by modif_dt asc) as renew_cnt
       ,modif_item
  from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
 where acct_modif_cate_cd in('MAT','MATE')  -- 期限变更
   and coalesce(json_value(modif_bf_val, '$.maturityDate'),json_value(modif_bf_val, '$.matudt'),json_value(modif_bf_val, '$.DUE_DATE')) <= coalesce(json_value(modif_post_val, '$.maturityDate'),json_value(modif_post_val, '$.matudt'),json_value(modif_post_val, '$.DUE_DATE'))
--   and modif_item = 'RPAY_DAT'
--   and acct_aldy_check_flg = '1'  -- 已复核
   and etl_dt <=to_date('${batch_date}','yyyymmdd')
   and job_cd = 'ncbsi1'
;

--1.3.4 获取转非应计信息（转非应计贷款日期等）(t11)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_04
nologging
compress ${option_switch} for query high
as
select modif_content_key_val
       ,modif_bf_val
	     ,modif_post_val
	     ,modif_dt
       ,row_number() over(partition by modif_content_key_val order by modif_dt desc) as rn
  from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
 where acct_modif_cate_cd = 'ATAS'
   and modif_post_val in ('FYJ', 'FY')
   and acct_aldy_check_flg = '1'
   and etl_dt <=to_date('${batch_date}','yyyymmdd')
   and job_cd = 'ncbsi1'
;

--1.3.5 获取基准利率信息（利率曲线类型代码、基准利率等）(t12)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_05
nologging
compress ${option_switch} for query high
as
select br.base_rat_id as base_rat_type_cd
       ,br.base_rat
       ,br.curr_cd
	     ,br.effect_dt
       ,row_number() over(partition by br.base_rat_id, br.curr_cd order by br.effect_dt desc) rn
  from ${iml_schema}.ref_base_rat_h br
 where br.job_cd = 'ncbsf1'
   and br.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and br.end_dt > to_date('${batch_date}', 'yyyymmdd')
;


--1.3.6 获取产品属性信息（预付利息摊销标志、收税标志、复利标志等）(t13)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_06
nologging
compress ${option_switch} for query high
as
select prod_id
       ,max(decode(attr_key, 'TAXABLE', attr_val, '')) As Taxable_Value               -- 收税标志
       ,max(decode(attr_key, 'ACR_AMORTIZE', attr_val, '')) as acr_amortize_value     -- 摊销标志
       ,max(decode(attr_key, 'INT_PENALTY', attr_val, '')) as int_penalty_value       -- 复利标志
       ,max(decode(attr_key, 'REVOLVE_YN', attr_val, '')) as revolve_yn_value         -- 循环标志标志
       ,max(decode(attr_key, 'BEFORE_INCOME', attr_val, '')) as before_income_value   -- 预收息标志
	     ,max(decode(attr_key, 'COMMITTED_FLAG', attr_val, '')) as committed_flag_value -- 承诺贷款标志
  from (select prod_id
               ,attr_key
               ,attr_val
               ,seq_num
               ,row_number() over(partition by prod_id, attr_key order by seq_num desc) rn
          from ${iml_schema}.prd_prod_def_h
         where prod_status_cd = '1'
           and trim(attr_key) is not null
		   and job_cd = 'ncbsf1'
           and start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and end_dt > to_date('${batch_date}', 'yyyymmdd'))
 group by prod_id
;

--1.3.7 获取逾期金额信息（逾期本金余额、逾期利息金额、逾期罚息金额、逾期复利金额等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_07
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

--1.3.8 获取贷款期数和还款计划逾期信息（本金逾期标志、利息逾期标志、当前逾期期数、本金逾期天数、利息逾期天数等）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_08
nologging
compress ${option_switch} for query high
as
select t1.acct_id
      ,nvl(sdp.pric_ovdue_flg,0) as pric_ovdue_flg        --本金逾期标志
      ,nvl(sdp.pric_ovdue_days,0) as pric_ovdue_days      --本金逾期天数
      ,sdp.pric_ovdue_dt                                  --本金逾期日期
      ,nvl(sdi.int_ovdue_flg,0) as int_ovdue_flg          --利息逾期标志
      ,nvl(sdi.int_ovdue_days,0) as int_ovdue_days        --利息逾期天数
      ,sdi.int_ovdue_dt                                   --利息逾期日期
      ,case when nvl(sdp.pric_ovdue_perds,0) > nvl(sdi.int_ovdue_perds,0) then sdp.pric_ovdue_perds else sdi.int_ovdue_perds end as curr_ovdue_perds  --当前逾期期数
      ,st.tot_perds                                       --贷款期数
   from ${iml_schema}.agt_loan_acct_info_h t1
   left join
      (select acct_id
             ,'1' as pric_ovdue_flg
             ,max(curr_pd) as pric_ovdue_perds
             ,max(to_date('${batch_date}', 'yyyymmdd') - int_set_dt + 1) as pric_ovdue_days
             ,min(int_set_dt) as pric_ovdue_dt
        from ${iml_schema}.agt_loan_repay_plan_dtl_h
       where amt_type_cd = 'PRI'
         and job_cd = 'ncbsf1'
         and grace_dt <= to_date('${batch_date}', 'yyyymmdd')
         and (full_amt_callbk_flg = '0' or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')))
         and start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and end_dt > to_date('${batch_date}', 'yyyymmdd')
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
               and job_cd = 'ncbsf1'
               and grace_dt <= to_date('${batch_date}', 'yyyymmdd')
               and (full_amt_callbk_flg = '0' or (full_amt_callbk_flg = '1' and  stl_dt > to_date('${batch_date}', 'yyyymmdd')))
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
             group by acct_id
/*             union all
             select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - value_dt + 1) as int_ovdue_days
                   ,min(value_dt) as int_ovdue_dt
              from ${iml_schema}.agt_loan_acct_pnlt_int_accr_h
             where int_cls_cd = 'ODP'
               and job_cd = 'ncbsf1'
               and ld_acm_provi_int > 0
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
             group by acct_id
             union all
             select acct_id
                   ,'1' as int_ovdue_flg
                   ,max(curr_pd) as int_ovdue_perds
                   ,max(to_date('${batch_date}', 'yyyymmdd') - value_dt + 1) as int_ovdue_days
                   ,min(value_dt) as int_ovdue_dt
              from ${iml_schema}.agt_loan_acct_comp_int_int_accr_h
             where int_cls_cd = 'ODI'
               and job_cd = 'ncbsf1'
               and ld_acm_provi_int > 0
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
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
       where job_cd = 'ncbsf1'
         and start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and end_dt > to_date('${batch_date}', 'yyyymmdd')
         and curr_pd <> '999'
       group by acct_id
      ) st
     on t1.acct_id = st.acct_id
  where t1.job_cd = 'ncbsf1'
    and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

--1.3.9 获取下次还款信息（本金的下次还款日期、下次还本金额）(t16)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_09
nologging
compress ${option_switch} for query high
as
select ca.acct_id
       ,sdp.int_set_dt as next_repay_dt
       ,sdp.plan_repay_amt as next_rpp_amt
  from ${iml_schema}.agt_loan_acct_info_h ca
  left join
  (select sdp1.acct_id
         ,sum(sdp1.plan_repay_amt) as plan_repay_amt
         ,max(sdp1.int_set_dt) as int_set_dt
    from ${iml_schema}.agt_loan_repay_plan_dtl_h sdp1
   where sdp1.amt_type_cd = 'PRI'
   and sdp1.job_cd = 'ncbsf1'
   and sdp1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and sdp1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and sdp1.int_set_dt in (select next_int_set_dt from ${iml_schema}.agt_loan_acct_int_dtl_h sdp2
                            where sdp2.job_cd = 'ncbsf1'
                              and sdp2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                              and sdp2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                              and sdp1.acct_id = sdp2.acct_id)
   group by sdp1.acct_id
   ) sdp
    on ca.acct_id = sdp.acct_id
 inner join ${iml_schema}.prd_loan_prod_info_h t4
    on ca.prod_id = t4.prod_id
   and t4.crdt_prod_cate_cd in ('2', '4')
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd ='icmsf1'
 where ca.job_cd = 'ncbsf1'
   and ca.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ca.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

--1.3.9 获取下次还款信息（利息的下次还款日期、下次还息金额等）(t33)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_10
nologging
compress ${option_switch} for query high
as
select ca.acct_id
       ,sdi.int_set_dt as next_repay_dt
       ,sdi.plan_repay_amt as next_repay_int_amt
  from ${iml_schema}.agt_loan_acct_info_h ca
  left join
  (select sdi1.acct_id
         ,sum(sdi1.plan_repay_amt) as plan_repay_amt
         ,max(sdi1.int_set_dt) as int_set_dt
    from ${iml_schema}.agt_loan_repay_plan_dtl_h sdi1
   where sdi1.amt_type_cd = 'INT'
   and sdi1.job_cd = 'ncbsf1'
   and sdi1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and sdi1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and sdi1.int_set_dt in (select next_int_set_dt from ${iml_schema}.agt_loan_acct_int_dtl_h sdi2
                            where sdi2.job_cd = 'ncbsf1'
                              and sdi2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                              and sdi2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                              and sdi1.acct_id = sdi2.acct_id)
   group by sdi1.acct_id
   ) sdi
    on ca.acct_id = sdi.acct_id
 inner join ${iml_schema}.prd_loan_prod_info_h t4
    on ca.prod_id = t4.prod_id
   and t4.crdt_prod_cate_cd in ('2', '4')
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd ='icmsf1'
 where ca.job_cd = 'ncbsf1'
   and ca.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and ca.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


-- 获取资产证券化金额明细（转让前应收利息）
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_11
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

-- 获取实际还款明细（已偿还本金、已偿还利息、已偿还罚息、已偿还复利、上一还款日期等）(t25)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_12
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
   and t1.bus_tran_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd='ncbsi1'
 group by t2.acct_id;
commit;

-- 获取已出单的应收罚息、催收罚息、和复息(t36)
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_13
nologging
compress ${option_switch} for query high
as
select t1.acct_id
       ,t1.amt_type_cd
       ,sum(t1.ld_doc_unpaid_amt) as ld_doc_unpaid_amt
  from ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl t1 --iol.ncbs_cl_invoice_od_detail
 where t1.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t1.bus_tran_dt <= to_date('${batch_date}', 'yyyymmdd')
   --and t1.doc_full_amt_callbk_flg = '0'
   and t1.job_cd='ncbsi1'
 group by t1.acct_id,t1.amt_type_cd;
commit;

--获取基础产品信息
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_15
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
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_14
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
    left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_15 pc2
      on sdp.base_prod_id = pc2.base_prod_id
   where sd.sob_id = 2
     and sd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and sd.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and sd.status_cd = '1'
     and sd.bus_type_cd iN ('LN','NCBS')
     and sd.job_cd = 'tglsf1'
   group by sdp.base_prod_id,sdp.prod_attr_cd,coalesce(pc1.sellbl_prod_id, pc2.sellbl_prod_id, sdp.base_prod_id);
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_16
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
          from ${iol_schema}.tgls_loan_busi_h t1
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

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_17
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
create table ${icl_schema}.tmp_cmm_retl_loan_acct_info_18
nologging
compress ${option_switch} for query high
as
select modif_content_key_val
       , min(modif_dt) as  modif_dt --首次展期到期日期期期期
  from ${iml_schema}.evt_loan_acct_info_modif_oper_dtl
 where acct_modif_cate_cd in('MAT','MATE')  -- 期限变更
   and job_cd = 'ncbsi1'
   and etl_dt <=to_date('${batch_date}','yyyymmdd')
group by modif_content_key_val
;

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_retl_loan_acct_info_ex purge;
-- 2.2 insert data to ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_acct_info where 0 = 1;


--第一组 核心贷款账户信息
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_acct_info_ex(
       etl_dt                              -- 数据日期
       ,lp_id                              -- 法人编号
       ,acct_id                            -- 账户编号
       ,acct_name                          -- 账户名称
       ,cust_id                            -- 客户编号
       ,cont_id                            -- 合同编号
       ,dubil_num                          -- 借据号
	   ,loan_num                           -- 贷款号
       ,out_acct_num                       -- 出账号
       ,loan_distr_acct_num                -- 贷款放款账号
       ,loan_repay_num                     -- 贷款还款账号
       ,std_prod_id                        -- 标准产品编号
       ,prod_id                            -- 产品编号
       ,subj_id                            -- 科目编号
       ,init_pric_subj_id                  -- 原本金科目编号
       ,in_bs_int_subj_id                  -- 表内利息科目编号
	     ,recvbl_uncol_int_subj_id           -- 应收未收利息科目编号
	     ,recvbl_int_paybl_adj_subj_id       -- 应收应付利息调整科目编号
       ,off_bs_int_subj_id                 -- 表外利息科目编号
	     ,acru_aldy_impam_int_subj_id        -- 应计已减值利息科目编号
       ,int_income_subj_id                 -- 利息收入科目编号
       ,int_income_adj_subj_id             -- 利息收入调整科目编号
       ,acctnt_cate_cd                     -- 会计类别代码
       ,bus_breed_id                       -- 业务品种编号
       ,asset_thd_cls_cd                   -- 资产三分类代码
       ,loan_modal_cd                      -- 贷款形态代码
       ,loan_acct_status_cd                -- 贷款账户状态代码
       ,unite_loan_cd                      -- 联合贷款代码
       ,priv_loan_flg                      -- 对私贷款标志
       ,promis_loan_flg                    -- 承诺贷款标志
       ,circl_loan_flg                     -- 循环贷款标志
       ,deriv_loan_flg                     -- 衍生贷款标志
       ,agent_loan_flg                     -- 代理贷款标志
       ,oots_accti_flg                     -- 按一逾两呆核算标志
       ,loan_modal_dg_subj_accti_flg       -- 贷款形态分科目核算标志
       ,loan_tenor                         -- 贷款期限
       ,loan_tenor_type_cd                 -- 贷款期限类型代码
       ,acru_non_acru_cd                   -- 应计非应计代码
       ,final_fin_dt                       -- 最后财务日期
       ,open_acct_teller_id                -- 开户柜员编号
       ,clos_acct_teller_id                -- 销户柜员编号
       ,open_acct_org_id                   -- 开户机构编号
       ,mgmt_org_id                        -- 管理机构编号
       ,acct_instit_id                     -- 账务机构编号
       ,open_acct_dt                       -- 开户日期
       ,open_acct_timestamp                -- 开户时间
       ,distr_dt                           -- 放款日期
       ,value_dt                           -- 起息日期
       ,exp_dt                             -- 到期日期
       ,init_exp_dt                        -- 原始到期日期
       ,clos_acct_dt                       -- 销户日期
       ,clos_acct_timestamp                -- 销户时间
	     ,int_sub_flg                        -- 贴息标志
       ,renew_flg                          -- 展期标志
       ,renew_cnt                          -- 展期次数
       ,fir_renew_exp_dt                   -- 首次展期到期日期期期期
       ,renew_exp_dt                       -- 展期到期日期
       ,int_accr_rule                      -- 计息规则
       ,int_accr_flg                       -- 计息标志
       ,comp_int_flg                       -- 复息标志
       ,pre_recv_int_way                   -- 预收息方式
       ,int_rat_adj_way_cd                 -- 利率调整方式代码
       ,int_rat_base_type_cd               -- 利率基准类型代码
       ,base_rat_id                        -- 基准利率编号
       ,base_rat                           -- 基准利率
       ,exec_int_rat                       -- 执行利率
       ,int_rat_float_way_cd               -- 利率浮动方式代码
       ,int_rat_adj_ped_corp_cd            -- 利率调整周期单位代码
       ,int_rat_adj_ped_freq               -- 利率调整周期频率
       ,int_rat_flo_val                    -- 利率浮动值
       ,curr_int_rat_effect_dt             -- 当前利率生效日期
       ,next_int_rat_adj_dt                -- 下次利率调整日期
       ,int_set_way_cd                     -- 结息方式代码
       ,int_accr_way_cd                    -- 计息方式代码
       ,ped_distr_flg                      -- 周期性放款标志
       ,distr_way_cd                       -- 放款方式代码
       ,repay_way_cd                       -- 还款方式代码
       ,irr_repay_way_cd                   -- 不规则还款方式代码
       ,repay_ped_corp_cd                  -- 还款周期单位代码
       ,repay_ped                          -- 还款周期
       ,allow_adv_repay_flg                -- 允许提前还款标志
       ,wrt_off_flg                        -- 核销标志
       ,abs_flg                            -- 资产证券化标志
       ,asset_tran_flg                     -- 资产转让标志
       ,asset_tran_status_cd               -- 资产转让状态代码
       ,asset_tran_dt                      -- 资产转让日期
       ,tran_bf_int_recvbl                 -- 转让前应收利息
       ,ovdue_flg                          -- 逾期标志
	     ,ovdue_int_accr_way_cd              -- 逾期计息方式代码
       ,ovdue_pnlt_float_way_cd            -- 逾期罚息浮动方式代码
       ,pric_ovdue_flg                     -- 本金逾期标志
       ,int_ovdue_flg                      -- 利息逾期标志
       ,curr_ovdue_perds                   -- 当前逾期期数
       ,pric_ovdue_days                    -- 本金逾期天数
       ,int_ovdue_days                     -- 利息逾期天数
       ,ovdue_pric_bal                     -- 逾期本金余额
       ,ovdue_int_amt                      -- 逾期利息金额
       ,ovdue_comp_int_amt                 -- 逾期复利金额
       ,fir_ovdue_dt                       -- 首次逾期日期
       ,pric_ovdue_dt                      -- 本金逾期日期
       ,int_ovdue_dt                       -- 利息逾期日期
       ,ovdue_int_rat                      -- 逾期利率
       ,ovdue_int_rat_flo_val              -- 逾期利率浮动值
       ,tot_perds                          -- 贷款期数
       ,curr_issue_perds                   -- 当前期数
       ,last_repay_dt                      -- 上次还款日期
       ,curr_cd                            -- 币种代码
       ,next_repay_dt                      -- 下次还款日期
       ,next_rpp_amt                       -- 下次还本金额
       ,next_repay_int_amt                 -- 下次还息金额
       ,cont_amt                           -- 合同金额
       ,dubil_amt                          -- 借据金额
       ,distr_amt                          -- 放款金额
       ,froz_distrd_amt                    -- 冻结可放金额
       ,distrd_amt                         -- 可发放金额
       ,td_acru_int                        -- 当日应计利息
       ,td_int_income                      -- 当日利息收入
       ,td_int_income_adj                  -- 当日利息收入调整
       ,currt_acru_int                     -- 当期应计利息
       ,nomal_pric                         -- 正常本金
       ,ovdue_pric                         -- 逾期本金
       ,grace_period_pric                  -- 宽限期本金
       ,grace_period_int                   -- 宽限期利息
       ,idle_pric                          -- 呆滞本金
       ,bad_debt_pric                      -- 呆账本金
       ,loan_fund                          -- 贷款基金
       ,recvbl_acru_int                    -- 应收应计利息
       ,coll_acru_int                      -- 催收应计利息
       ,recvbl_acru_pnlt                   -- 应收应计罚息
       ,coll_acru_pnlt                     -- 催收应计罚息
       ,recvbl_pnlt                        -- 应收罚息
       ,coll_pnlt                          -- 催收罚息
       ,acru_comp_int                      -- 应计复息
       ,recvbl_comp_int                    -- 应收复息
       ,acru_int_sub                       -- 应计贴息
       ,recvbl_int_sub                     -- 应收贴息
       ,amorted_int                        -- 待摊利息
       ,wrt_off_pric                       -- 核销本金
       ,wrt_off_int                        -- 核销利息
       ,int_income                         -- 利息收入
       ,wrt_off_advc_fee_bal               -- 核销垫付费余额
       ,wrt_off_advc_fee_amt               -- 核销垫付费金额
       ,recvbl_fine                        -- 应收罚金
       ,fine_inco                          -- 罚金收入
       ,resv                               -- 准备金
       ,recvbl_over_int                    -- 应收欠息
       ,coll_over_int                      -- 催收欠息
       ,in_bs_int                          -- 表内利息
       ,off_bs_int                         -- 表外利息
       ,acm_recvbl_uncol_int_amt           -- 累计应收未收利息金额
	     ,recvbl_uncol_int                   -- 应收未收利息
       ,int_recvbl                         -- 应收利息
       ,non_acru_int_recvbl                -- 非应计应收利息
       ,acru_aldy_impam_int                -- 应计已减值利息
       ,repaid_pric                        -- 已偿还本金
       ,repaid_int                         -- 已偿还利息
       ,repaid_pnlt                        -- 已偿还罚息
       ,repaid_comp_int                    -- 已偿还复利
       ,repaid_fee                         -- 已偿还费用
       ,pric_bal                           -- 本金余额
       ,currt_bal                          -- 当期余额
       ,cl_curr_currt_bal                  -- 折本币当期余额
       ,ear_d_bal                          -- 日初余额
       ,ear_m_bal                          -- 月初余额
       ,ear_s_bal                          -- 季初余额
       ,ear_y_bal                          -- 年初余额
       ,y_acm_bal                          -- 年累计余额
       ,s_acm_bal                          -- 季累计余额
       ,m_acm_bal                          -- 月累计余额
       ,cl_curr_ear_d_bal                  -- 折本币日初余额
       ,cl_curr_ear_m_bal                  -- 折本币月初余额
       ,cl_curr_ear_s_bal                  -- 折本币季初余额
       ,cl_curr_ear_y_bal                  -- 折本币年初余额
       ,cl_curr_y_acm_bal                  -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal            -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal            -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal            -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal            -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal                  -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal            -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal            -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal            -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal                  -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal            -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal            -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal            -- 折本币年初月累计余额
       ,y_avg_bal                          -- 年日均余额
       ,q_avg_bal                          -- 季日均余额
       ,m_avg_bal                          -- 月日均余额
       ,cl_curr_y_avg_bal                  -- 折本币年日均余额
       ,cl_curr_q_avg_bal                  -- 折本币季日均余额
       ,cl_curr_m_avg_bal                  -- 折本币月日均余额
       ,job_cd                             -- 任务代码
       ,etl_timestamp                      -- 数据处理时间
)
select
       to_date('${batch_date}','yyyymmdd')                                -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.acct_id                                                        -- 账户编号
       ,t1.acct_name                                                      -- 账户名称
       ,t1.cust_id                                                        -- 客户编号
       ,t34.cont_id                                                       -- 合同编号
       ,t1.dubil_id                                                       -- 借据号
       ,t1.loan_num                                                       -- 贷款号
       ,t1.distr_flow_num                                                 -- 出账号
       ,t3.pay_acct_no                                                    -- 贷款放款账号
       ,t3.rec_acct_no                                                    -- 贷款还款账号
       ,t1.prod_id                                                        -- 标准产品编号
       ,t1.camp_prod_id                                                   -- 产品编号
       ,(case when t22.asset_acct_status_cd = 'S' /*nvl(t40.abs_pric,0) <> 0*/ then nvl(t39.veripr_subjid,t39_1.veripr_subjid)
              else coalesce(trim(t39.normpr_subjid),trim(t39_1.normpr_subjid), trim(t39.reacin_subjid),trim(t39_1.reacin_subjid))
          end ) as subj_id                                                -- 科目编号
       ,coalesce(trim(t39.normpr_subjid),trim(t39_1.normpr_subjid), trim(t39.reacin_subjid),trim(t39_1.reacin_subjid)) as init_pric_subj_id -- 原本金科目编号
       ,nvl(t39.reinre_subjid,t39_1.reinre_subjid)                        -- 表内利息科目编号
       ,(case when t22.asset_acct_status_cd = 'S' /*nvl(t36.abs_pric,0) <> 0*/ then nvl(t39.accrin_subjid,t39_1.accrin_subjid）
              else nvl(t39.regicr_subjid,t39_1.regicr_subjid) end)                        -- 应收未收利息科目编号
       ,''                                                                -- 应收应付利息调整科目编号
       ,nvl(t39.reacci_subjid,t39_1.reacci_subjid)                        -- 表外利息科目编号
       ,nvl(t39.regcir_subjid,t39_1.regcir_subjid)                        -- 应计已减值利息科目编号
       ,nvl(t39.intein_subjid,t39_1.intein_subjid)                        -- 利息收入科目编号
       ,''                                                                -- 利息收入调整科目编号
       ,''                                                                -- 会计类别代码
       ,''                                                                -- 业务品种编号
       ,trim(t2.asset_thd_cls_cd)                                         -- 资产三分类代码
       ,nvl(trim(t40.init_loan_num),t1.accti_status_cd)                   -- 贷款形态代码
       ,case when t1.acct_status_modif_dt > to_date('${batch_date}', 'yyyymmdd')  then t1.last_acct_status_cd
             else t1.acct_status_cd
        end                                                               -- 贷款账户状态代码
       ,decode(t19.prod_cls_id, '2020101', '1', '0')                      -- 联合贷款代码
       ,t1.indv_bus_flg                                                   -- 对私贷款标志
       ,decode(t13.committed_flag_value, 'Y', '1', '0')                   -- 承诺贷款标志
       ,decode(t13.revolve_yn_value, 'Y', '1', '0')                       -- 循环贷款标志
       ,'0'                                                               -- 衍生贷款标志
       ,case when t1.prod_id like '6020301%' then '1' else '0' end        -- 代理贷款标志
       ,'0'                                                               -- 按一逾两呆核算标志
       ,'0'                                                               -- 贷款形态分科目核算标志
       ,t1.loan_tenor                                                     -- 贷款期限
       ,t1.tenor_type_cd                                                  -- 贷款期限类型代码
       ,case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then '0'
             when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY') then '1'
             when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('WRN') then '2'
             else '-'
        end                                                               -- 应计非应计代码
       ,t1.final_tran_dt                                                  -- 最后财务日期
       ,t1.open_acct_teller_id                                            -- 开户柜员编号
       ,t1.clos_acct_teller_id                                            -- 销户柜员编号
       ,t1.open_acct_org_id                                               -- 开户机构编号
       ,t1.mgmt_org_id                                                    -- 管理机构编号
       ,t1.open_acct_org_id                                               -- 账务机构编号
       ,t1.open_acct_dt                                                   -- 开户日期
       ,${iml_schema}.timeformat_max(t43.open_tran_timestamp)             -- 开户时间
       ,t1.open_acct_dt                                                   -- 放款日期
       ,t6.value_dt                                                       -- 起息日期
       ,t1.exp_dt                                                         -- 到期日期
       ,t1.init_exp_dt                                                    -- 原始到期日期
       ,t1.clos_acct_dt                                                   -- 销户日期
       ,${iml_schema}.timeformat_max(t43.close_tran_timestamp)            -- 销户时间
       ,'0'                                                               -- 贴息标志
       ,case when t7.modif_content_key_val is not null then '1' else '0' end  -- 展期标志
       ,nvl(t7.renew_cnt, 0)                                              -- 展期次数
       ,t44.modif_dt                                                      -- 首次展期到期日期期期期
       ,to_date(t7.modif_post_val,'yyyymmdd')                             -- 展期到期日期
       ,t24.int_accr_base_cd                                              -- 计息规则
       ,t1.int_accr_flg                                                   -- 计息标志
       ,t46.int_accr_flg                                                  -- 复息标志
       ,decode(t13.before_income_value, 'Y', '1', '0')                    -- 预收息方式
       ,case when t24.int_rat_start_use_way_cd = 'N' then '0'
             when t24.int_rat_start_use_way_cd in ('A', 'R', 'S', 'F') then '1'
             else '-' end                                                 -- 利率调整方式代码
       ,nvl(trim(t12.base_rat_type_cd),'2210')                            -- 利率基准类型代码
       ,t12.base_rat_type_cd                                              -- 基准利率编号
       ,nvl(t24.bank_int_int_rat, 0)                                       -- 基准利率
       ,nvl(t24.exec_int_rat, 0)                                          -- 执行利率
       ,case when trim(t24.sub_acct_int_rat_float_ratio) is not null then '1'
             when trim(t24.sub_acct_int_rat_float_point) is not null then '2'
             else '-' end                                                 -- 利率浮动方式代码
       ,case when t24.int_rat_start_use_way_cd = 'A' then 'D'
	         else nvl(trim(t29.eh_issue_corp_cd),'-')
        end                                			                     -- 利率调整周期单位代码
	  -- ,nvl(t29.eh_issue_corp_cd, '-')                                 -- 利率调整周期单位代码
	   ,case when t24.int_rat_start_use_way_cd = 'A' then  1
	         else nvl(t29.eh_issue_qtty, 0) 
        end                                                              -- 利率调整周期频率
      --  ,nvl(t29.eh_issue_qtty, 0)                                     -- 利率调整周期频率
       ,case when trim(t24.sub_acct_int_rat_float_ratio) is not null then to_number(trim(t24.sub_acct_int_rat_float_ratio)*nvl(t24.bank_int_int_rat, 0))
               else to_number(trim(t24.sub_acct_int_rat_float_point)) end  -- 利率浮动值
       ,nvl(t47.news_date,t24.last_int_rat_modif_dt)                      -- 当前利率生效日期
       ,t24.next_int_rat_modif_dt                                         -- 下次利率调整日期
       ,t24.int_set_freq_cd                                               -- 结息方式代码
       ,t24.int_accr_way_cd                                               -- 计息方式代码
       ,'0'                                                               -- 周期性放款标志
       ,t4.distr_way_cd                                                   -- 放款方式代码
       ,t1.repay_way_cd                                                   -- 还款方式代码
       ,case when t1.repay_way_cd in ('5','10','15') then t1.repay_way_cd else '' end  -- 不规则还款方式代码
       ,nvl(trim(t35.eh_issue_corp_cd),'-')                               -- 还款周期单位代码
       ,nvl(t35.eh_issue_qtty, 0)                                         -- 还款周期
       ,'1'                                                               -- 允许提前还款标志
       ,case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('WRN') then '1'
             else '0'
        end                                                               -- 核销标志
       ,t1.abs_flg                                                        -- 资产证券化标志
       ,t1.flg_cd                                                         -- 资产转让标志
       ,nvl(trim(t22.asset_acct_status_cd),'-')                           -- 资产转让状态代码
       ,t22.pkg_tran_dt                                                   -- 资产转让日期
       ,nvl(t23.pack_amt, 0)                                              -- 转让前应收利息
       ,case when nvl(trim(t40.acct_status_cd),t1.acct_status_cd) = 'C' then '0'
             when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC') then '0'
             when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY', 'YUQ','WRN') then '1'
             else ''
        end                                                                 -- 逾期标志
     	 ,case when t28.int_rat_start_use_way_cd = 'N' then '3'
             when trim(t28.sub_acct_int_rat_float_ratio) is not null then '2'
             when trim(t28.sub_acct_int_rat_float_point) is not null then '2'
             else '-'
        end                                                                 -- 逾期计息方式代码
       ,case when trim(t28.sub_acct_int_rat_float_ratio) is not null then '1'
             when trim(t28.sub_acct_int_rat_float_point) is not null then '2'
             else '-'
        end                                                                 -- 逾期罚息浮动方式代码
       ,case when nvl(t43.pri_due_days,0) >0 then '1' else '0' end          -- 本金逾期标志
       ,case when nvl(t43.int_due_days,0) >0 then '1' else '0' end          -- 利息逾期标志
       ,t15.curr_ovdue_perds                                                -- 当前逾期期数
       ,nvl(t43.pri_due_days, 0)                                            -- 本金逾期天数
       ,nvl(t43.int_due_days, 0)                                            -- 利息逾期天数
       ,nvl(t14.ovdue_pric_bal, 0)                                          -- 逾期本金余额
       ,nvl(t14.ovdue_int_amt, 0) /*+ nvl(t31.ld_acm_provi_int,0)+nvl(t31.ld_acm_int_adj,0) + nvl(t38.ld_acm_provi_int,0)+nvl(t38.ld_acm_int_adj,0) */                 -- 逾期利息金额
       ,nvl(t14.ovdue_comp_int_amt, 0) /*+ nvl(t38.ld_acm_provi_int,0)+nvl(t38.ld_acm_int_adj,0) */      -- 逾期复利金额
       ,case when decode(t43.pri_first_date,to_date('00010101', 'yyyymmdd'),to_date('29991231', 'yyyymmdd'),t43.pri_first_date) <= decode(t43.int_first_date,to_date('00010101', 'yyyymmdd'),to_date('29991231', 'yyyymmdd'),t43.int_first_date) 
             then t43.pri_first_date else t43.int_first_date end            -- 首次逾期日期
       ,t43.pri_first_date                                                  -- 本金逾期日期
       ,t43.int_first_date                                                  -- 利息逾期日期
       ,nvl(t28.exec_int_rat,0)                                             -- 逾期利率
       ,case when trim(t28.sub_acct_int_rat_float_ratio) is not null then to_number(trim(t28.sub_acct_int_rat_float_ratio)*nvl(t28.bank_int_int_rat,0))
               else to_number(trim(t28.sub_acct_int_rat_float_point)) end  -- 逾期利率浮动值
       ,nvl(t15.tot_perds,0)                                                -- 贷款期数
       ,t1.curr_pd                                                          -- 当前期数
       ,case when t25.acct_id is not null then t25.last_repay_dt else nvl(t27.last_repay_dt,t27_1.last_repay_dt) end                            -- 上次还款日期
       ,t1.curr_cd                                                          -- 币种代码
       ,case when nvl(t16.next_repay_dt, to_date('29991231', 'yyyymmdd')) <= nvl(t33.next_repay_dt, to_date('29991231', 'yyyymmdd'))
             then t16.next_repay_dt
             else t33.next_repay_dt
        end                                                                 -- 下次还款日期
       ,nvl(t16.next_rpp_amt,0)                                             -- 下次还本金额
       ,nvl(t33.next_repay_int_amt,0)                                       -- 下次还息金额
       ,nvl(t34.loan_sign_cont_amt,0)                                       -- 合同金额
       ,nvl(t17.distr_amt,0)                                                -- 借据金额
       ,nvl(t17.distr_amt,0)                                                -- 放款金额
       ,0                                                                   -- 冻结可放金额
       ,0                                                                   -- 可发放金额
       ,case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ')
             then nvl(t6.provi_day_provi_int,0)+nvl(t6.provi_day_int_adj_amt,0) + nvl(t31.provi_day_provi_int,0) + nvl(t31.provi_day_int_adj,0)
             else 0
        end                                                                 -- 当日应计利息
       ,t41.td_provi_int+t41.provi_amt_bal + nvl(t45.tran_amt ,0)           -- 当日利息收入
       ,nvl(t42.discnt_int,0)                                               -- 当日利息收入调整
       ,case when t1.prod_id = '602030100002' then 0
             else  case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t6.ld_acm_provi_int,0) + nvl(t6.ld_acm_int_adj_amt,0) + nvl(t31.ld_acm_provi_int,0)  + nvl(t31.ld_acm_int_adj,0)
                        else 0
                   end
        end                                                                 -- 当期应计利息
       ,case when t1.prod_id = '602030100002' then nvl(t17.ld_nomal_pric,0) + nvl(t17.ld_ovdue_pric,0)
             else nvl(t17.ld_nomal_pric,0)
        end                                                                 -- 正常本金
       ,decode(t1.prod_id,'602030100002',0,nvl(t17.ld_ovdue_pric,0))        -- 逾期本金
       ,decode(t1.prod_id,'602030100002',0,nvl(t17.ld_grace_period_pric,0)) -- 宽限期本金
       ,decode(t1.prod_id,'602030100002',0,nvl(t17.ld_grace_period_int,0))  -- 宽限期利息
       ,0                                                                   -- 呆滞本金
       ,0                                                                   -- 呆账本金
       ,0                                                                   -- 贷款基金
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t6.ld_acm_provi_int,0)+NVL(T6.ld_acm_int_adj_amt,0) else 0 end
        end                                                                -- 应收应计利息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t6.ld_acm_provi_int,0)+NVL(T6.ld_acm_int_adj_amt,0) else 0 end
        end                                                                -- 催收应计利息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t31.ld_acm_provi_int,0)+ NVL(T31.ld_acm_int_adj,0) else 0 end
        end                                                                -- 应收应计罚息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t31.ld_acm_provi_int,0)+ NVL(T31.ld_acm_int_adj,0) else 0 end
        end                                                                -- 催收应计罚息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t36.ld_doc_unpaid_amt,0) else 0 end
        end                                                                -- 应收罚息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t36.ld_doc_unpaid_amt,0) else 0 end
        end                                                                -- 催收罚息
       ,case when t1.prod_id = '602030100002' then 0
             else nvl(t38.ld_acm_provi_int,0) +NVL(T38.ld_acm_int_adj,0)
        end                                                                -- 应计复息
       ,case when t1.prod_id = '602030100002' then 0
             else nvl(t17.ld_ovdue_comp_int,0)
        end                                                                -- 应收复息
       ,0                                                                  -- 应计贴息
       ,0                                                                  -- 应收贴息
       ,t6.currt_acm_amorted_provi_amt                                     -- 待摊利息
       ,nvl(t40.wrtn_off_pric,0)                                           -- 核销本金
       ,nvl(t40.wrtn_off_int,0)                                            -- 核销利息
       ,decode(t1.prod_id,'602030100002',0,coalesce(t27.int_income,t27_1.int_income,0)+nvl(t25.repaid_int,0)+nvl(t25.repaid_pnlt,0)+nvl(t25.repaid_comp_int,0))              -- 利息收入
       ,0                                                                  -- 核销垫付费余额
       ,nvl(t40.wrtn_off_advc_money,0)                                     -- 核销垫付费金额
       ,0                                                                  -- 应收罚金
       ,0                                                                  -- 罚金收入
       ,0                                                                  -- 准备金
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t17.ld_ovdue_int,0) + nvl(t17.ld_grace_period_int,0) else 0 end
        end                                                                -- 应收欠息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t17.ld_ovdue_int,0) + nvl(t17.ld_grace_period_int,0) else 0 end
        end                                                                -- 催收欠息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('ZHC', 'YUQ') then nvl(t6.ld_acm_provi_int, 0) + nvl(t6.ld_acm_int_adj_amt,0) + nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_grace_period_int,0) + nvl(t17.ld_ovdue_pnlt, 0) + nvl(t17.ld_grace_period_pnlt,0) + nvl(t31.ld_acm_provi_int,0) + nvl(t31.ld_acm_int_adj,0)
                        else 0
                   end
         end                                                               -- 表内利息
       ,case when t1.prod_id = '602030100002' then 0
             else case when nvl(trim(t40.init_loan_num),t1.accti_status_cd) in ('FYJ', 'FY','WRN') then nvl(t6.ld_acm_provi_int, 0) + nvl(t6.ld_acm_int_adj_amt,0) + nvl(t17.ld_ovdue_int, 0) + nvl(t17.ld_grace_period_int,0) + nvl(t17.ld_ovdue_pnlt, 0) + nvl(t17.ld_grace_period_pnlt,0) + nvl(t31.ld_acm_provi_int,0) + nvl(t31.ld_acm_int_adj,0)
                       else 0
                  end
         end                                                               -- 表外利息
       ,case when t1.prod_id = '602030100002' then 0
             else nvl(t17.ld_ovdue_int,0) + nvl(t17.ld_grace_period_int,0) + nvl(t36.ld_doc_unpaid_amt,0) + nvl(t37.ld_doc_unpaid_amt,0)
        end                                                                                                    -- 累计应收未收利息金额
       ,nvl(t40.recvbl_uncol_int,0)                                                                            -- 应收未收利息_计量后
       ,nvl(t40.int_recvbl,0)                                                                                  -- 应收利息_计量后
       ,nvl(t40.non_acru_int_recvbl,0)                                                                         -- 非应计应收利息_计量后
       ,nvl(t40.acru_aldy_impam_int,0)                                                                         -- 应计已减值利息
       ,coalesce(t27.repaid_pric,t27_1.repaid_pric, 0) + nvl(t25.repaid_pric,0)                                -- 已偿还本金
       ,coalesce(t27.repaid_int,t27_1.repaid_int, 0) + nvl(t25.repaid_int,0)                                   -- 已偿还利息
       ,coalesce(t27.repaid_pnlt,t27_1.repaid_pnlt, 0) + nvl(t25.repaid_pnlt,0)                                -- 已偿还罚息
       ,coalesce(t27.repaid_comp_int,t27_1.repaid_comp_int, 0) + nvl(t25.repaid_comp_int,0)                    -- 已偿还复利
       ,0                                                                                                      -- 已偿还费用
       ,nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) + nvl(t40.wrtn_off_pric,0)             -- 本金余额
       ,nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0)                                        --当期余额
       ,(nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0)+ nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1)      --折本币当期余额
       ,coalesce(t27.currt_bal,t27_1.currt_bal,0)                                                              --日初余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.ear_m_bal,t27_1.ear_m_bal,0.0) end       --月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0)  else coalesce(t27.ear_s_bal,t27_1.ear_s_bal,0.0) end   --季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.ear_y_bal,t27_1.ear_y_bal,0.0) end     --年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.y_acm_bal,t27_1.y_acm_bal,0.0)+nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end          --年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.s_acm_bal,t27_1.s_acm_bal,0.0) + nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end       --季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.m_acm_bal,t27_1.m_acm_bal,0.0) + nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end               --月累计余额
       ,coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0)                                            --折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_m_bal, t27_1.cl_curr_ear_m_bal,0.0) end       --折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_s_bal,t27_1.cl_curr_ear_s_bal,0.0) end     --折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_currt_bal,t27_1.cl_curr_currt_bal,0.0) else coalesce(t27.cl_curr_ear_y_bal,t27_1.cl_curr_ear_y_bal,0.0) end      --折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal,0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end        --折本币年累计余额
       ,coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0)                                                                                                                                          -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_m_y_acm_bal,t27_1.cl_curr_ear_m_y_acm_bal, 0.0) end                                         -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_s_y_acm_bal,t27_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_y_acm_bal,t27_1.cl_curr_ear_y_y_acm_bal, 0.0) end                                       -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end   -- 折本币季累计余额
       ,coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0)                                                                                                                                          -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_s_y_acm_bal,t27_1.cl_curr_ear_s_y_acm_bal, 0.0) end               -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_s_acm_bal,t27_1.cl_curr_ear_y_s_acm_bal, 0.0) end                                       -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal,  0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end    -- 折本币月累计余额
       ,coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0)                                                                                                                                          -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_m_m_acm_bal,t27_1.cl_curr_ear_m_m_acm_bal, 0.0) end                                         -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) else coalesce(t27.cl_curr_ear_y_m_acm_bal,t27_1.cl_curr_ear_y_m_acm_bal, 0.0) end                                       -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.y_acm_bal,t27_1.y_acm_bal, 0.0) + nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.s_acm_bal,t27_1.s_acm_bal, 0.0) + nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) else coalesce(t27.m_acm_bal,t27_1.m_acm_bal, 0.0) + nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_y_acm_bal,t27_1.cl_curr_y_acm_bal, 0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_s_acm_bal,t27_1.cl_curr_s_acm_bal, 0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) else coalesce(t27.cl_curr_m_acm_bal,t27_1.cl_curr_m_acm_bal, 0.0) + (nvl(t40.nomal_pric,0)+nvl(t40.log_pric,0) + nvl(t40.abs_pric,0))*nvl(trim(t26.convt_cny_exch_rat),1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
	     ,t1.job_cd                                                          -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    -- 数据处理时间
  from ${iml_schema}.agt_loan_acct_info_h t1
  left join ${iml_schema}.agt_loan_dubil_info_h t2
    on t1.dubil_id = t2.dubil_id
   and t2.job_cd = 'icmsf1'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_01 t3
    on t1.acct_id = t3.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_02 t4
    on t1.acct_id = t4.acct_id
   and t4.rn = 1
  left join ${iml_schema}.agt_loan_cont_info_h t5
    on t2.rela_cont_id = t5.cont_id
   and t5.job_cd = 'icmsf1'
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.agt_loan_acct_int_dtl_h t6
    on t1.acct_id = t6.acct_id
   and t6.int_cls_cd = 'INT'
   and t6.job_cd = 'ncbsf1'
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_03 t7
    on t1.acct_id = t7.modif_content_key_val
   and t7.rn = 1
  left join ${iml_schema}.agt_loan_out_acct_appl_h t8
    on t2.rela_out_acct_flow_num = t8.out_acct_flow_num
   and t8.job_cd = 'icmsf1'
   and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_04 t11
    on t1.acct_id = t11.modif_content_key_val
   and t11.rn = 1
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_06 t13
    on t1.prod_id = t13.prod_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_07 t14
    on t1.acct_id = t14.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_08 t15
    on t1.acct_id = t15.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_09 t16
    on t1.acct_id = t16.acct_id
  left join ${iml_schema}.agt_loan_acct_bal_h t17
    on t1.acct_id = t17.acct_id
   and t17.job_cd = 'ncbsf1'
   and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select t1.*,row_number()over(partition by t1.acct_id order by t1.wrt_off_dt desc) as rn
          from  ${iml_schema}.agt_loan_acct_wrt_off_h t1
	       where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
             and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
             and t1.job_cd = 'ncbsf1') t18
    on t1.acct_id = t18.acct_id
	and t18.rn=1
  left join ${iml_schema}.prd_std_prod_info_h t19
    on t1.prod_id = t19.prod_id
   and t19.job_cd = 'ncbsf1'
   and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
/*  left join ${iml_schema}.agt_abs_cont_dtl_h t22
    on t1.acct_id = t22.acct_id
   and t22.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t22.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t22.job_cd ='ncbsf1'
   and t22.asset_acct_status_cd not in ('C','E', 'I')  -- P-封包、S-发行、C-撤包、E-发行撤销、B-赎回
   and exists (select 1 from ${iml_schema}.agt_abs_cont_h ctc
                where t22.asset_bag_cont_id = ctc.asset_bag_cont_id
                  and ctc.asset_bag_cont_status_cd in ('YP', 'YS', 'PB')
                  and ctc.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                  and ctc.end_dt > to_date('${batch_date}', 'yyyymmdd')
                  and ctc.job_cd ='ncbsf1')
*/
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_17 t22
    on t1.acct_id = t22.acct_id
   and t22.rn = 1
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_11 t23
    on t22.asset_bag_cont_dtl_seq_num = t23.asset_bag_cont_dtl_seq_num
  left join ${iml_schema}.agt_loan_acct_int_accr_cfg_h t24
    on t1.acct_id = t24.acct_id
   and t24.int_cls_cd = 'INT'
   and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t24.job_cd ='ncbsf1'
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_05 t12
    on t24.int_rat_type_cd = t12.base_rat_type_cd
   and t1.curr_cd = t12.curr_cd
   and t12.rn = 1
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_12 t25
    on t1.acct_id = t25.acct_id
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t26
    on t1.curr_cd = t26.curr_cd
   and t26.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t26.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t26.job_cd ='ncbsf1'
  left join ${icl_schema}.cmm_retl_loan_acct_info t27
    on t1.dubil_id = t27.dubil_num
   and t1.lp_id = t27.lp_id
   and t27.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
   and to_date('${batch_date}', 'yyyymmdd')  <=to_date('20230502', 'yyyymmdd')    --新一代投产时0501为旧数据，0502为新数据，0502日前的数据关联前一日需使用借据号关联(包括0502)，0503日后的数据需使用账号关联
  left join ${icl_schema}.cmm_retl_loan_acct_info t27_1
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
 inner join ${iml_schema}.prd_loan_prod_info_h t30
    on t1.prod_id = t30.prod_id
   and t30.crdt_prod_cate_cd in ('2', '4')
   and t30.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t30.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t30.job_cd ='icmsf1'
  left join (select acct_id,
                    sum(ld_acm_int_adj) as ld_acm_int_adj,
                    sum(ld_acm_provi_int) as ld_acm_provi_int,
                    sum(int_amt) as int_amt,
                    sum(provi_day_provi_int) as provi_day_provi_int,
                    sum(provi_day_int_adj) as provi_day_int_adj
              from ${iml_schema}.agt_loan_acct_pnlt_int_accr_h   --贷款账户罚息计息历史
             where int_cls_cd = 'ODP'
               and job_cd = 'ncbsf1'
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               group by acct_id) t31
    on t1.acct_id = t31.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_10 t33
    on t1.acct_id = t33.acct_id
  left join ${iml_schema}.agt_loan_acct_attach_info_h t34
    on t1.loan_num = t34.loan_num
   and t34.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t34.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t34.job_cd ='ncbsf1'
  left join ${iml_schema}.ref_ped_freq_para t35
    on t24.int_set_freq_cd = t35.ped_freq_cd
   and t35.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t35.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t35.job_cd ='ncbsf1'
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_13 t36
    on t1.acct_id = t36.acct_id
   and t36.amt_type_cd = 'ODP'
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_13 t37
    on t1.acct_id = t37.acct_id
   and t37.amt_type_cd = 'ODI'
  left join (select acct_id,
                    sum(ld_acm_int_adj) as ld_acm_int_adj,
                    sum(ld_acm_provi_int) as ld_acm_provi_int
              from ${iml_schema}.agt_loan_acct_comp_int_int_accr_h   --贷款账户复利计息历史
             where int_cls_cd = 'ODI'
               and job_cd = 'ncbsf1'
               and start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and end_dt > to_date('${batch_date}', 'yyyymmdd')
               group by acct_id) t38
    on t1.acct_id = t38.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_14 t39
    on t1.prod_id = t39.sellbl_prod_id
   and t1.prod_id like '4%'
   and nvl(decode(trim(t34.cap_char_cd),'0000','*',trim(t34.cap_char_cd)),'*') = nvl(trim(replace(t39.prod_attr_cd,'-',null)),'*')
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_14 t39_1
    on t1.prod_id = t39_1.sellbl_prod_id
   and t1.prod_id not like '4%'
  left join ${iml_schema}.evt_loan_sub_acct_measure_flow t40
    on t1.loan_num||t1.distr_flow_num = t40.core_loan_num
   and t40.job_cd = 'tglsi1'
   and t40.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join (select acct_id,
                    sum(td_provi_int) as td_provi_int,
                    sum(provi_amt_bal) as provi_amt_bal
              from ${iml_schema}.evt_loan_provi_flow   --贷款计提流水
             where job_cd = 'ncbsi1'
               and provi_dt =  to_date('${batch_date}', 'yyyymmdd')
               group by acct_id) t41
    on t1.acct_id = t41.acct_id
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_16 t42
    on t1.loan_num||t1.distr_flow_num = t42.core_loan_num
  left join ${iol_schema}.ncbs_cl_acct_attach t43
    on t1.acct_id = t43.internal_key
   and t43.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t43.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${icl_schema}.tmp_cmm_retl_loan_acct_info_18 t44
    on t1.acct_id = t44.modif_content_key_val
  left join ${iml_schema}.evt_accti_midgrod_acct_ety t45
    on  substr(t45.sorc_sys_flow_num, 6)=t1.loan_num || t1.distr_flow_num
   and t45.sob_id = '1'
   and substr(t45.memo_id, 1, 8) = 'NCBSCL15'
   and t45.tran_dt = to_date('${batch_date}','yyyymmdd')
   and t45.etl_dt =to_date('${batch_date}','yyyymmdd')
   and t45.job_cd ='tglsi1'
   and substr(t45.subj_id, 1, 4) in ('6011') --贷款利息收入
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
where t1.job_cd = 'ncbsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and decode(trim(t1.auto_revs_flg),NULL,'-',t1.auto_revs_flg) <> 'Y'   --剔除自动冲正的数据
   and t1.acct_aldy_check_flg <> '0'
   and t1.open_acct_dt <=to_date('${batch_date}', 'yyyymmdd')
;
commit;

--第二组 信贷房抵贷借据信息
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_acct_info_ex(
       etl_dt                              -- 数据日期
       ,lp_id                              -- 法人编号
       ,acct_id                            -- 账户编号
       ,acct_name                          -- 账户名称
       ,cust_id                            -- 客户编号
       ,cont_id                            -- 合同编号
       ,dubil_num                          -- 借据号
	     ,loan_num                           -- 贷款号
       ,out_acct_num                       -- 出账号
       ,loan_distr_acct_num                -- 贷款放款账号
       ,loan_repay_num                     -- 贷款还款账号
       ,std_prod_id                        -- 标准产品编号
       ,prod_id                            -- 产品编号
       ,subj_id                            -- 科目编号
       ,init_pric_subj_id                  -- 原本金科目编号
       ,in_bs_int_subj_id                  -- 表内利息科目编号
	     ,recvbl_uncol_int_subj_id           -- 应收未收利息科目编号
	     ,recvbl_int_paybl_adj_subj_id       -- 应收应付利息调整科目编号
       ,off_bs_int_subj_id                 -- 表外利息科目编号
	     ,acru_aldy_impam_int_subj_id        -- 应计已减值利息科目编号
       ,int_income_subj_id                 -- 利息收入科目编号
       ,int_income_adj_subj_id             -- 利息收入调整科目编号
       ,acctnt_cate_cd                     -- 会计类别代码
       ,bus_breed_id                       -- 业务品种编号
       ,asset_thd_cls_cd                   -- 资产三分类代码
       ,loan_modal_cd                      -- 贷款形态代码
       ,loan_acct_status_cd                -- 贷款账户状态代码
       ,unite_loan_cd                      -- 联合贷款代码
       ,priv_loan_flg                      -- 对私贷款标志
       ,promis_loan_flg                    -- 承诺贷款标志
       ,circl_loan_flg                     -- 循环贷款标志
       ,deriv_loan_flg                     -- 衍生贷款标志
       ,agent_loan_flg                     -- 代理贷款标志
       ,oots_accti_flg                     -- 按一逾两呆核算标志
       ,loan_modal_dg_subj_accti_flg       -- 贷款形态分科目核算标志
       ,loan_tenor                         -- 贷款期限
       ,loan_tenor_type_cd                 -- 贷款期限类型代码
       ,acru_non_acru_cd                   -- 应计非应计代码
       ,final_fin_dt                       -- 最后财务日期
       ,open_acct_teller_id                -- 开户柜员编号
       ,clos_acct_teller_id                -- 销户柜员编号
       ,open_acct_org_id                   -- 开户机构编号
       ,mgmt_org_id                        -- 管理机构编号
       ,acct_instit_id                     -- 账务机构编号
       ,open_acct_dt                       -- 开户日期
       ,open_acct_timestamp                -- 开户时间
       ,distr_dt                           -- 放款日期
       ,value_dt                           -- 起息日期
       ,exp_dt                             -- 到期日期
       ,init_exp_dt                        -- 原始到期日期
       ,clos_acct_dt                       -- 销户日期
       ,clos_acct_timestamp                -- 销户时间
	     ,int_sub_flg                        -- 贴息标志
       ,renew_flg                          -- 展期标志
       ,renew_cnt                          -- 展期次数
       ,fir_renew_exp_dt                   -- 首次展期到期日期期期期
       ,renew_exp_dt                       -- 展期到期日期
       ,int_accr_rule                      -- 计息规则
       ,int_accr_flg                       -- 计息标志
       ,comp_int_flg                       -- 复息标志
       ,pre_recv_int_way                   -- 预收息方式
       ,int_rat_adj_way_cd                 -- 利率调整方式代码
       ,int_rat_base_type_cd               -- 利率基准类型代码
       ,base_rat_id                        -- 基准利率编号
       ,base_rat                           -- 基准利率
       ,exec_int_rat                       -- 执行利率
       ,int_rat_float_way_cd               -- 利率浮动方式代码
       ,int_rat_adj_ped_corp_cd            -- 利率调整周期单位代码
       ,int_rat_adj_ped_freq               -- 利率调整周期频率
       ,int_rat_flo_val                    -- 利率浮动值
       ,curr_int_rat_effect_dt             -- 当前利率生效日期
       ,next_int_rat_adj_dt                -- 下次利率调整日期
       ,int_set_way_cd                     -- 结息方式代码
       ,int_accr_way_cd                    -- 计息方式代码
       ,ped_distr_flg                      -- 周期性放款标志
       ,distr_way_cd                       -- 放款方式代码
       ,repay_way_cd                       -- 还款方式代码
       ,irr_repay_way_cd                   -- 不规则还款方式代码
       ,repay_ped_corp_cd                  -- 还款周期单位代码
       ,repay_ped                          -- 还款周期
       ,allow_adv_repay_flg                -- 允许提前还款标志
       ,wrt_off_flg                        -- 核销标志
       ,abs_flg                            -- 资产证券化标志
       ,asset_tran_flg                     -- 资产转让标志
       ,asset_tran_status_cd               -- 资产转让状态代码
       ,asset_tran_dt                      -- 资产转让日期
       ,tran_bf_int_recvbl                 -- 转让前应收利息
       ,ovdue_flg                          -- 逾期标志
	     ,ovdue_int_accr_way_cd              -- 逾期计息方式代码
       ,ovdue_pnlt_float_way_cd            -- 逾期罚息浮动方式代码
       ,pric_ovdue_flg                     -- 本金逾期标志
       ,int_ovdue_flg                      -- 利息逾期标志
       ,curr_ovdue_perds                   -- 当前逾期期数
       ,pric_ovdue_days                    -- 本金逾期天数
       ,int_ovdue_days                     -- 利息逾期天数
       ,ovdue_pric_bal                     -- 逾期本金余额
       ,ovdue_int_amt                      -- 逾期利息金额
       ,ovdue_comp_int_amt                 -- 逾期复利金额
       ,fir_ovdue_dt                       -- 首次逾期日期
       ,pric_ovdue_dt                      -- 本金逾期日期
       ,int_ovdue_dt                       -- 利息逾期日期
       ,ovdue_int_rat                      -- 逾期利率
       ,ovdue_int_rat_flo_val              -- 逾期利率浮动值
       ,tot_perds                          -- 贷款期数
       ,curr_issue_perds                   -- 当前期数
       ,last_repay_dt                      -- 上次还款日期
       ,curr_cd                            -- 币种代码
       ,next_repay_dt                      -- 下次还款日期
       ,next_rpp_amt                       -- 下次还本金额
       ,next_repay_int_amt                 -- 下次还息金额
       ,cont_amt                           -- 合同金额
       ,dubil_amt                          -- 借据金额
       ,distr_amt                          -- 放款金额
       ,froz_distrd_amt                    -- 冻结可放金额
       ,distrd_amt                         -- 可发放金额
       ,td_acru_int                        -- 当日应计利息
       ,td_int_income                      -- 当日利息收入
       ,td_int_income_adj                  -- 当日利息收入调整
       ,currt_acru_int                     -- 当期应计利息
       ,nomal_pric                         -- 正常本金
       ,ovdue_pric                         -- 逾期本金
       ,grace_period_pric                  -- 宽限期本金
       ,grace_period_int                   -- 宽限期利息
       ,idle_pric                          -- 呆滞本金
       ,bad_debt_pric                      -- 呆账本金
       ,loan_fund                          -- 贷款基金
       ,recvbl_acru_int                    -- 应收应计利息
       ,coll_acru_int                      -- 催收应计利息
       ,recvbl_acru_pnlt                   -- 应收应计罚息
       ,coll_acru_pnlt                     -- 催收应计罚息
       ,recvbl_pnlt                        -- 应收罚息
       ,coll_pnlt                          -- 催收罚息
       ,acru_comp_int                      -- 应计复息
       ,recvbl_comp_int                    -- 应收复息
       ,acru_int_sub                       -- 应计贴息
       ,recvbl_int_sub                     -- 应收贴息
       ,amorted_int                        -- 待摊利息
       ,wrt_off_pric                       -- 核销本金
       ,wrt_off_int                        -- 核销利息
       ,int_income                         -- 利息收入
       ,wrt_off_advc_fee_bal               -- 核销垫付费余额
       ,wrt_off_advc_fee_amt               -- 核销垫付费金额
       ,recvbl_fine                        -- 应收罚金
       ,fine_inco                          -- 罚金收入
       ,resv                               -- 准备金
       ,recvbl_over_int                    -- 应收欠息
       ,coll_over_int                      -- 催收欠息
       ,in_bs_int                          -- 表内利息
       ,off_bs_int                         -- 表外利息
       ,acm_recvbl_uncol_int_amt           -- 累计应收未收利息金额
	     ,recvbl_uncol_int                   -- 应收未收利息
       ,int_recvbl                         -- 应收利息
       ,non_acru_int_recvbl                -- 非应计应收利息
       ,acru_aldy_impam_int                -- 应计已减值利息
       ,repaid_pric                        -- 已偿还本金
       ,repaid_int                         -- 已偿还利息
       ,repaid_pnlt                        -- 已偿还罚息
       ,repaid_comp_int                    -- 已偿还复利
       ,repaid_fee                         -- 已偿还费用
       ,pric_bal                           -- 本金余额
       ,currt_bal                          -- 当期余额
       ,cl_curr_currt_bal                  -- 折本币当期余额
       ,ear_d_bal                          -- 日初余额
       ,ear_m_bal                          -- 月初余额
       ,ear_s_bal                          -- 季初余额
       ,ear_y_bal                          -- 年初余额
       ,y_acm_bal                          -- 年累计余额
       ,s_acm_bal                          -- 季累计余额
       ,m_acm_bal                          -- 月累计余额
       ,cl_curr_ear_d_bal                  -- 折本币日初余额
       ,cl_curr_ear_m_bal                  -- 折本币月初余额
       ,cl_curr_ear_s_bal                  -- 折本币季初余额
       ,cl_curr_ear_y_bal                  -- 折本币年初余额
       ,cl_curr_y_acm_bal                  -- 折本币年累计余额
       ,cl_curr_ear_d_y_acm_bal            -- 折本币日初年累计余额
       ,cl_curr_ear_m_y_acm_bal            -- 折本币月初年累计余额
       ,cl_curr_ear_s_y_acm_bal            -- 折本币季初年累计余额
       ,cl_curr_ear_y_y_acm_bal            -- 折本币年初年累计余额
       ,cl_curr_s_acm_bal                  -- 折本币季累计余额
       ,cl_curr_ear_d_s_acm_bal            -- 折本币日初季累计余额
       ,cl_curr_ear_s_s_acm_bal            -- 折本币季初季累计余额
       ,cl_curr_ear_y_s_acm_bal            -- 折本币年初季累计余额
       ,cl_curr_m_acm_bal                  -- 折本币月累计余额
       ,cl_curr_ear_d_m_acm_bal            -- 折本币日初月累计余额
       ,cl_curr_ear_m_m_acm_bal            -- 折本币月初月累计余额
       ,cl_curr_ear_y_m_acm_bal            -- 折本币年初月累计余额
       ,y_avg_bal                          -- 年日均余额
       ,q_avg_bal                          -- 季日均余额
       ,m_avg_bal                          -- 月日均余额
       ,cl_curr_y_avg_bal                  -- 折本币年日均余额
       ,cl_curr_q_avg_bal                  -- 折本币季日均余额
       ,cl_curr_m_avg_bal                  -- 折本币月日均余额
       ,job_cd                             -- 任务代码
       ,etl_timestamp                      -- 数据处理时间
)
select
       to_date('${batch_date}','yyyymmdd')                               -- 数据日期
       ,t1.lp_id                                                         -- 法人编号
       ,t1.dubil_id	                                                     --	账户编号
       ,t1.cust_name	                                                   --	账户名称
       ,t1.cust_id	                                                     --	客户编号
       ,t1.rela_cont_id	                                                 --	合同编号
       ,t1.dubil_id	                                                     --	借据号
       ,''	                                                             --	贷款号
       ,t1.rela_out_acct_flow_num	                                       --	出账号
       ,t1.distr_acct_id	                                               --	贷款放款账号
       ,t1.repay_acct_id                                                 -- 贷款还款账号
       ,t1.prod_id                                                       -- 标准产品编号
       ,t1.prod_id                                                       -- 产品编号
       ,'13030202'                                                       -- 科目编号
       ,'13030202'                                                       -- 原本金科目编号
       ,''                                                               -- 表内利息科目编号
       ,''                                                               -- 应收未收利息科目编号
       ,''                                                               -- 应收应付利息调整科目编号
       ,''                                                               -- 表外利息科目编号
       ,''                                                               -- 应计已减值利息科目编号
       ,''                                                               -- 利息收入科目编号
       ,''                                                               -- 利息收入调整科目编号
       ,''                                                               -- 会计类别代码
       ,''                                                               -- 业务品种编号
       ,t1.asset_thd_cls_cd                                              -- 资产三分类代码
       ,decode(t1.dubil_status_cd,'A','ZHC','P','YUQ',' ')               -- 贷款形态代码
       ,t1.dubil_status_cd                                               -- 贷款账户状态代码
       ,'-'                                                              -- 联合贷款代码
       ,'1'                                                              -- 对私贷款标志
       ,'-'                                                              -- 承诺贷款标志
       ,'1'                                                              -- 循环贷款标志
       ,'-'                                                              -- 衍生贷款标志
       ,'0'                                                              -- 代理贷款标志
       ,'-'                                                              -- 按一逾两呆核算标志
       ,'-'                                                              -- 贷款形态分科目核算标志
       ,t1.mon_tenor                                                     -- 贷款期限
       ,''                                                               -- 贷款期限类型代码
       ,decode(t1.off_bs_flg,'1','0','2','1','-')                        -- 应计非应计代码
       ,''                                                               -- 最后财务日期
       ,t1.rgst_teller_id                                                -- 开户柜员编号
       ,''                                                               -- 销户柜员编号
       ,t1.rgst_org_id                                                -- 开户机构编号
       ,t1.rgst_org_id                                                   -- 管理机构编号
       ,t1.out_acct_org_id                                               -- 账务机构编号
       ,t1.distr_dt                                                      -- 开户日期
       ,t1.distr_dt                                                      -- 开户时间
       ,t1.distr_dt                                                      -- 放款日期
       ,t1.distr_dt                                                      -- 起息日期
       ,t1.apot_exp_dt                                                   -- 到期日期
       ,t1.apot_exp_dt                                                   -- 原始到期日期
       ,t1.termnt_dt                                                     -- 销户日期
       ,t1.termnt_dt                                                     -- 销户时间
       ,'-'                                                              -- 贴息标志
       ,''                                                               -- 展期标志
       ,''                                                               -- 展期次数
       ,''                                                               -- 首次展期到期日期期期
       ,''                                                               -- 展期到期日期
       ,'30/360'                                                         -- 计息规则
       ,decode(t1.int_accr_flg,'N','0','Y','1',' ','-',t1.int_accr_flg)  -- 计息标志
       ,t1.comp_int_flg                                                  -- 复息标志
       ,''                                                               -- 预收息方式
       ,case when t1.int_rat_adj_way_cd ='7' then '0' 
             when t1.int_rat_adj_way_cd ='-' then '-'  
             else '1' end                                                -- 利率调整方式代码
       ,t1.base_rat_type_cd                                              -- 利率基准类型代码
       ,'2231'                                                           -- 基准利率编号
       ,t1.base_rat                                                      -- 基准利率
       ,t1.exec_year_int_rat                                             -- 执行利率
       ,case when t1.int_rat_float_type_cd ='0' then '0' 
             else '-' end                                                -- 利率浮动方式代码
       ,decode(t1.int_rat_adj_way_cd, '3', 'Y', '4', 'M', '8', 'Q', '9', 'M', 'O')               -- 利率调整周期单位代码
       ,case when t1.int_rat_adj_way_cd in ('3', '4', '8') then 1
             when t1.int_rat_adj_way_cd in ('9') then 6
             else 0
             end                                                         -- 利率调整周期频率
       ,t1.int_rat_float_range                                           -- 利率浮动值
       ,''                                                               -- 当前利率生效日期
       ,''                                                               -- 下次利率调整日期
       ,'M1'                                                             -- 结息方式代码
       ,'-'                                                              -- 计息方式代码
       ,'0'                                                              -- 周期性放款标志
       ,'DD'                                                             -- 放款方式代码
       ,t1.repay_way_cd                                                  -- 还款方式代码
       ,''                                                               -- 不规则还款方式代码
       ,t1.repay_ped_cd                                                  -- 还款周期单位代码
       ,t1.repay_ped                                                     -- 还款周期
       ,''                                                               -- 允许提前还款标志
       ,decode(t1.bad_debt_wrt_off_status_cd,'Y','1','0')                -- 核销标志
       ,''                                                               -- 资产证券化标志
       ,''                                                               -- 资产转让标志
       ,''                                                               -- 资产转让状态代码
       ,''                                                               -- 资产转让日期
       ,''                                                               -- 转让前应收利息
       ,case when t1.ovdue_dt <> to_date('29991231','yyyymmdd') then 1 else 0 end             -- 逾期标志
       ,'1'                                                              -- 逾期计息方式代码
       ,'2'                                                              -- 逾期罚息浮动方式代码
       ,case when t3.prinovddays > 0 then '1' else '0' end               -- 本金逾期标志
       ,case when t3.intovddays > 0 then '1' else '0' end                -- 利息逾期标志
       ,t3.termno                                                        -- 当前逾期期数
       ,nvl(t3.prinovddays,0)                                            -- 本金逾期天数
       ,nvl(t3.intovddays,0)                                             -- 利息逾期天数
       ,t1.pric_ovdue_amt                                                -- 逾期本金余额
       ,t1.int_ovdue_amt                                                 -- 逾期利息金额
       ,0                                                                -- 逾期复利金额
       ,t1.fir_ovdue_dt                                                  -- 首次逾期日期
       ,t3.prin_ovdue_dt                                                 -- 本金逾期日期
       ,t3.int_ovdue_dt                                                  -- 利息逾期日期
       ,t1.ovdue_int_rat                                                 -- 逾期利率
       ,t1.ovdue_int_rat_flo_val                                         -- 逾期利率浮动值
       ,t1.loan_tot_perds                                                -- 贷款期数
       ,t1.loan_tot_perds-t1.surp_repay_perds                            -- 当前期数
       ,''                                                               -- 上次还款日期
       ,t1.curr_cd                                                       -- 币种代码
       ,''                                                               -- 下次还款日期
       ,0                                                                -- 下次还本金额
       ,0                                                                -- 下次还息金额
       ,t1.dubil_amt                                                     -- 合同金额
       ,t1.dubil_amt                                                     -- 借据金额
       ,t1.dubil_amt                                                     -- 放款金额
       ,0                                                                -- 冻结可放金额
       ,0                                                                -- 可发放金额
       ,nvl(t4.intamt, 0) + nvl(t4.ovdprinpnltamt,0) + nvl(t4.ovdintpnltamt,0)          --  当日应计利息
       ,0                                                                -- 当日利息收入
       ,0                                                                -- 当日利息收入调整
       ,t1.acru_int                                                      -- 当期应计利息
       ,t1.nomal_bal                                                     -- 正常本金
       ,t1.ovdue_bal                                                     -- 逾期本金
       ,0                                                                -- 宽限期本金
       ,0                                                                -- 宽限期利息
       ,0                                                                -- 呆滞本金
       ,0                                                                -- 呆账本金
       ,0                                                                -- 贷款基金
       ,t1.acru_int                                                      -- 应收应计利息
       ,t1.coll_acru_int                                                 -- 催收应计利息
       ,t1.acru_pnlt                                                     -- 应收应计罚息
       ,t1.coll_acru_pnlt                                                -- 催收应计罚息
       ,t1.recvbl_pnlt                                                   -- 应收罚息
       ,t1.coll_pnlt                                                     -- 催收罚息
       ,t1.acru_comp_int                                                 -- 应计复息
       ,t1.comp_int_bal                                                  -- 应收复息
       ,0                                                                -- 应计贴息
       ,0                                                                -- 应收贴息
       ,0                                                                -- 待摊利息
       ,t1.wrt_off_pric                                                  -- 核销本金
       ,t1.wrt_off_int                                                   -- 核销利息
       ,0                                                                -- 利息收入
       ,0                                                                -- 核销垫付费余额
       ,0                                                                -- 核销垫付费金额
       ,0                                                                -- 应收罚金
       ,0                                                                -- 罚金收入
       ,0                                                                -- 准备金
       ,t1.recvbl_over_int                                               -- 应收欠息
       ,t1.coll_over_int                                                 -- 催收欠息
       ,t1.in_bs_over_int_bal                                            -- 表内利息
       ,t1.off_bs_over_int_bal                                           -- 表外利息
       ,nvl(t2.intbal,0)+nvl(t2.ovdintbal,0)+nvl(t2.ovdprinpnltbal,0)+nvl(t2.ovdintpnltbal,0)     -- 累计应收未收利息金额
       ,nvl(t2.intbal,0)+nvl(t2.ovdintbal,0)+nvl(t2.ovdprinpnltbal,0)+nvl(t2.ovdintpnltbal,0)     -- 应收未收利息
       ,t1.int_bal                                                       -- 应收利息
       ,case when t1.off_bs_flg ='2' then t1.int_bal else 0 end          -- 非应计应收利息
       ,0                                                                -- 应计已减值利息
       ,t1.acm_rtn_pric                                                  -- 已偿还本金
       ,t1.acm_rtn_int                                                   -- 已偿还利息
       ,0                                                                -- 已偿还罚息
       ,0                                                                -- 已偿还复利
       ,0                                                                -- 已偿还费用
       ,t1.curr_bal                                                      -- 本金余额
       ,t1.curr_bal                                                      -- 当期余额
       ,t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1)                   -- 折本币当期余额
       ,coalesce(t6.currt_bal,0)                                                                                                                                                 -- 日初余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.ear_m_bal,0.0) end                                                                        -- 月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal  else coalesce(t6.ear_s_bal,0.0) end                                             -- 季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.ear_y_bal,0.0) end                                                                      -- 年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.y_acm_bal,0.0)+t1.curr_bal end                                                          -- 年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal else coalesce(t6.s_acm_bal,0.0) + t1.curr_bal end                                -- 季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.m_acm_bal,0.0) + t1.curr_bal end                                                          -- 月累计余额
       ,coalesce(t6.cl_curr_currt_bal,0.0)                                                                                                                                       -- 折本币日初余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_ear_m_bal,0.0) end                            -- 折本币月初余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_ear_s_bal,0.0) end   -- 折本币季初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_ear_y_bal,0.0) end                           -- 折本币年初余额
       ,case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_y_acm_bal,0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end                                                 -- 折本币年累计余额
       ,coalesce(t6.cl_curr_y_acm_bal, 0.0)                                                                                                                                                                                                             -- 折本币日初年累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_y_acm_bal, 0.0) end                                                                                                        -- 折本币月初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal, 0.0) end                                                                              -- 折本币季初年累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_y_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_y_acm_bal, 0.0) end                                                                                                      -- 折本币年初年累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_s_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end                        -- 折本币季累计余额
       ,coalesce(t6.cl_curr_s_acm_bal, 0.0)                                                                                                                                                                                                             -- 折本币日初季累计余额
       ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then coalesce(t6.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_s_y_acm_bal, 0.0) end                                                                              -- 折本币季初季累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_s_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_s_acm_bal, 0.0) end                                                                                                      -- 折本币年初季累计余额
       ,case when substr('${batch_date}',7,2) = '01' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_m_acm_bal,  0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end                                                 -- 折本币月累计余额
       ,coalesce(t6.cl_curr_m_acm_bal, 0.0)                                                                                                                                                                                                             -- 折本币日初月累计余额
       ,case when substr('${batch_date}',7,2) = '01' then coalesce(t6.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_m_m_acm_bal, 0.0) end                                                                                                        -- 折本币月初月累计余额
       ,case when substr('${batch_date}',5,4) = '0101' then coalesce(t6.cl_curr_m_acm_bal, 0.0) else coalesce(t6.cl_curr_ear_y_m_acm_bal, 0.0) end                                                                                                      -- 折本币年初月累计余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal else coalesce(t6.y_acm_bal, 0.0) + t1.curr_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                            -- 年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal else coalesce(t6.s_acm_bal, 0.0) + t1.curr_bal end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)    -- 季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.curr_bal else coalesce(t6.m_acm_bal, 0.0) + t1.curr_bal end) / to_number(substr('${batch_date}', 7, 2))                                                                                   -- 月日均余额
       ,(case when substr('${batch_date}',5,4) = '0101' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_y_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1)                                -- 折本币年日均余额
       ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_s_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1)        -- 折本币季日均余额
       ,(case when substr('${batch_date}',7,2) = '01' then t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) else coalesce(t6.cl_curr_m_acm_bal, 0.0) + t1.curr_bal*nvl(trim(t5.convt_cny_exch_rat),1) end) / to_number(substr('${batch_date}', 7, 2))                                                                                       -- 折本币月日均余额
       ,t1.job_cd                                                                                                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                                                         -- 数据处理时间
  from ${iml_schema}.agt_loan_dubil_info_h t1
  left join ${iol_schema}.icms_mybk_acc_loan t2
    on t1.dubil_id=t2.contractno
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select contractno,
                    min(termno)       as termno,                        -- 逾期期数
                    min(${iml_schema}.dateformat_max2(prinovddate)) as prin_ovdue_dt,                 -- 本金逾期日期
                    min(${iml_schema}.dateformat_max2(intovddate))  as int_ovdue_dt,                  -- 利息逾期日期
                    max(prinovddays)  as prinovddays,                   -- 本金逾期天数
                    max(intovddays)   as intovddays                     -- 利息逾期天数
               from ${iol_schema}.icms_mybk_repay_amort_plan
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and status='OVD'
              group by contractno)t3
    on t1.dubil_id = t3.contractno
  left join ${iol_schema}.icms_mybk_loan_int_calc t4
    on t1.dubil_id = t4.contractno
   and ${iml_schema}.dateformat_max2(t4.calcdate)= to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t5
    on t1.curr_cd = t5.curr_cd
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd ='ncbsf1'
 left join ${icl_schema}.cmm_retl_loan_acct_info t6
    on t1.dubil_id = t6.acct_id
   and t1.lp_id = t6.lp_id
   and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd') - 1
 where t1.job_cd = 'icmsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.prod_id ='201020100057'
;
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_acct_info_ex;


-- 3.1 drop ex table
drop table ${icl_schema}.cmm_retl_loan_acct_info_ex purge;
-- 3.2 drop temp table
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_05 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_07 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_08 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_09 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_10 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_11 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_12 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_13 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_14 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_15 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_16 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_17 purge;
--drop table ${icl_schema}.tmp_cmm_retl_loan_acct_info_18 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_retl_loan_acct_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);