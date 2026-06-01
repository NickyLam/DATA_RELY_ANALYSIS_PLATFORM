/*
Purpose:    共性加工层-资管非标投资表:数据来源于资管系统（FAMS）,包括所有资管账户持有的非标投资，即资管产品资产端的非标投资。
                                      备注：资管系统的每笔交易形成一笔资产
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_am_non_std_invest
Createdate: 20190822
Logs:       20210225 陈伟峰 1.新增字段【业务编号、账套编号、资管产品收益类型代码、资产收益类型代码、应计利息、到期收益率、公允价值变动、资产三分类代码、科目编号】
                            2.调整主键字段
            20210305 陈伟峰 新增字段【资管产品名称】、调整字段【资产计划名称】的取数口径
            20210318 陈伟峰 增加字段【信贷出账流水号】
            20211012 陈伟峰 增加字段【标准产品编号】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_am_non_std_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_non_std_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_non_std_invest_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_non_std_invest_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_am_non_std_invest where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_am_non_std_invest_ex(
     etl_dt                   --数据日期
    ,lp_id                    --法人编号
    ,bus_id                   --业务编号
    ,acct_set_id              --账套编号
    ,am_prod_id               --资管产品编号
    ,am_plan_id               --资管计划编号
    ,am_prod_name             --资管产品名称
    ,std_prod_id              --标准产品编号
    ,am_prod_prft_type_cd     --资管产品收益类型代码
    ,asset_plan_cd            --资产计划代码
    ,asset_plan_name          --资产计划名称
    ,asset_plan_kind_cd       --资产计划种类代码
    ,asset_prft_type_cd       --资产收益类型代码
    ,asset_thd_cls_cd         --资产三分类代码
    ,subj_id                  --科目编号
    ,risk_level_cd            --风险等级代码
    ,invest_way_cd            --投资方式代码
    ,gover_fin_plat_flg       --政府融资平台标志
    ,brkevn_flg               --保本标志
    ,sub_debt_flg             --次级债标志
    ,abs_flg                  --abs标志
    ,cont_id                  --合同编号
    ,fin_corp_id              --融资企业编号
    ,fin_corp_name            --融资企业名称
    ,indus_type_cd            --行业类型代码
    ,co_corp_id               --合作公司编号
    ,issue_dt                 --发行日期
    ,value_dt                 --起息日期
    ,exp_dt                   --到期日期
    ,tenor                    --期限
    ,base_rat_id              --基准利率编号
    ,int_accr_base_cd         --计息基准代码
    ,int_rat_adj_way_cd       --利率调整方式代码
    ,int_rat_float_point      --利率浮动点数
    ,rpp_freq                 --还本频率
    ,pay_int_freq             --付息频率
    ,pay_int_ped_cd           --付息周期代码
    ,fir_pay_int_dt           --首次付息日期
    ,last_pay_int_dt          --上次付息日期
    ,next_pay_int_dt          --下次付息日期
    ,holiday_rule_cd          --节假日规则代码
    ,cty_cd                   --国家代码
    ,curr_cd                  --币种代码
    ,cont_amt                 --合同金额
    ,base_rat                 --基准利率
    ,exec_int_rat             --执行利率
    ,hold_pos                 --持有仓位
    ,hold_fac_val             --持有面值
    ,pric_bal                 --本金余额
    ,td_acru_int              --当日应计利息
    ,currt_acru_int           --当期应计利息
    ,acru_int                 --应计利息
    ,actl_int_rat             --实际利率
    ,exp_yld_rat              --到期收益率
    ,evha_val_chag            --公允价值变动
    ,asset_four_cls_cd        --资产四分类代码
    ,open_dt                  --开仓日期
    ,recnt_tran_dt            --最近交易日期
    ,crdt_out_acct_flow_num   --信贷出账流水号
    ,job_cd
    ,etl_timestamp            --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')       as etl_dt                --数据日期
      ,'9999'                                    as lp_id                 --法人编号
      ,t1.acct_dtl_id                            as bus_id                --业务编号
      ,t1.sob_id                                 as acct_set_id           --账套编号
      ,t3.src_prod_id                            as am_prod_id            --资管产品编号
      ,t3.finc_prod_id                           as am_plan_id            --资管计划编号
      ,nvl(trim(t15.prod_name),trim(t3.prod_abbr)) as am_prod_name        --资管产品名称
      ,t2.std_prod_id                            as std_prod_id           --标准产品编号
      ,t13.profit_flag                           as am_prod_prft_type_cd  --资管产品收益类型代码
      ,t1.fin_prod_id                            as asset_plan_cd         --资产计划代码
      ,nvl(trim(t14.prod_name),trim(t2.prod_abbr))   as asset_plan_name       --资产计划名称
      ,t1.prod_cate_cd                           as asset_plan_kind_cd    --资产计划种类代码
      ,t4.profit_flag                            as asset_prft_type_cd    --资产收益类型代码
      ,t1.invest_aim_cd                          as asset_thd_cls_cd      --资产三分类代码
      ,case when (t13.profit_flag in ('01','02') or  t14.prod_name like '%（保本）%')
	          then '140105190301' else '' end      as subj_id               --科目编号
      ,t4.risk_level                             as risk_level_cd         --风险等级代码
      ,'-'                                       as invest_way_cd         --投资方式代码
      ,t7.is_gov                                 as gover_fin_plat_flg    --政府融资平台标志
      ,t2.brkevn_flg                             as brkevn_flg            --保本标志
      ,t4.is_sec_bond                            as sub_debt_flg          --次级债标志
      ,decode(t5.bank_int_prod_level5_cls_cd, '019', '1', '0')    as abs_flg               --abs标志
      ,''                                        as cont_id               --合同编号
      ,nvl(t2.finer_id, t2.issuer_id)            as fin_corp_id           --融资企业编号
      ,t6.customer_name                          as fin_corp_name         --融资企业名称
      ,t8.proj_invest_industry2                  as indus_type_cd         --行业类型代码
      ,''                                        as co_corp_id            --合作公司编号
      ,t2.issue_dt                               as issue_dt              --发行日期
      ,t2.value_dt                               as value_dt              --起息日期
      ,t2.exp_dt                                 as exp_dt                --到期日期
      ,t2.prod_tenor                             as tenor                 --期限
      ,t9.benchmark_id                           as base_rat_id           --基准利率编号
      ,t9.basis                                  as int_accr_base_cd      --计息基准代码
      ,t9.int_type                               as int_rat_adj_way_cd    --利率调整方式代码
      ,t9.spread_rate                            as int_rat_float_point   --利率浮动点数
      ,0                                         as rpp_freq              --还本频率
      ,t10.year_pay_int_cnt                      as pay_int_freq          --付息频率
      ,'Y'                                       as pay_int_ped_cd        --付息周期代码
      ,t12.a_adjust_plan_pay_dt                  as fir_pay_int_dt        --首次付息日期
      ,t10.a_adjust_plan_pay_dt                  as last_pay_int_dt       --上次付息日期
      ,t11.a_adjust_plan_pay_dt                  as next_pay_int_dt       --下次付息日期
      ,'-'                                       as holiday_rule_cd       --节假日规则代码
      ,'CHN'                                     as cty_cd                --国家代码
      ,t1.curr_cd                                as curr_cd               --币种代码
      ,t1.td_cost_tot                            as cont_amt              --合同金额
      ,t9.rate                                   as base_rat              --基准利率
      ,t1.provi_int_rat                          as exec_int_rat          --执行利率
      ,t1.curr_post_amt                          as hold_pos              --持有仓位
      ,t1.curr_post_amt                          as hold_fac_val          --持有面值
      ,t1.curr_post_amt                          as pric_bal              --本金余额
      ,t1.td_happ_acru_int                       as td_acru_int           --当日应计利息
      ,t1.td_acm_acru_int_bal                    as currt_acru_int        --当期应计利息
      ,t1.td_acm_acru_int_bal                    as acru_int              --应计利息
      ,t1.provi_int_rat                          as actl_int_rat          --实际利率
      ,(case when t1.day_amort_yld_rat = 0 or t1.day_amort_yld_rat is null
	           then t9.rate else t1.day_amort_yld_rat end) * 100      as exp_yld_rat           --到期收益率
      ,t1.td_acm_evha_val_chag                   as evha_val_chag         --公允价值变动
      ,'-'                                       as asset_four_cls_cd     --资产四分类代码
      ,t1.ext_evltion_dt                         as open_dt               --开仓日期
      ,t1.happ_dt                                as recnt_tran_dt         --最近交易日期
      ,t16.out_acct_flow_num                     as crdt_out_acct_flow_num  --信贷出账流水号
      ,t1.job_cd                                 as job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  as etl_timestamp         --数据处理时间
from ${iml_schema}.fin_am_stat_analy_acct_dtl t1 --fams_bok_stat_det_posiiton t1
left join ${iml_schema}.prd_am_invest_underly_prod  t2 --fams_fin_product t2
  on t1.fin_prod_id = t2.src_prod_id
 and t2.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd ='famsf2'
 and t2.id_mark <>'D'
left join ${iml_schema}.prd_name_h t14
  on t2.prod_id=t14.prod_id
 and t14.prod_name_type_cd='01'
 and t14.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t14.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t14.job_cd ='famsf2'
left join ${iml_schema}.prd_am_finc_prod  t3 --fams_fin_product t3
  on (t1.sob_id = t3.src_prod_id or t1.sob_id = t3.super_prod_id or t1.sob_id = t3.finc_prod_id)
 and t3.prod_cate_cd = 'F16'
 and t3.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd ='famsf2'
 and t3.id_mark <>'D'
left join ${iml_schema}.prd_name_h t15
  on t3.prod_id=t15.prod_id
 and t15.prod_name_type_cd='01'
 and t15.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t15.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t15.job_cd ='famsf2'
left join ${iol_schema}.fams_fin_product_add t4
  on t1.fin_prod_id = t4.finprod_id
 and t4.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t4.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.prd_am_fin_prod_cls_h  t5 --fams_fin_product_type t5
  on t1.fin_prod_id = t5.fin_prod_id
 and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t5.job_cd ='famsf2'
left join ${iol_schema}.fams_mst_customer_info t6
  on nvl(t2.finer_id, t2.issuer_id) = t6.customer_id
 and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_mst_customer_info_add t7
  on t6.customer_id = t7.customer_id
 and t7.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_pa_fin_product t8
  on t1.fin_prod_id = t8.finprod_id
 and t8.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t8.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select t.*
                  ,row_number() over(partition by t.finprod_id order by t.eff_date, t.cash_id desc) as rn
             from ${iol_schema}.fams_fin_rate_info t
            where t.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and t.end_dt >to_date('${batch_date}', 'yyyymmdd')
                )t9
  on t1.fin_prod_id = t9.finprod_id
 and t9.rn = 1
left join (select a.*
                  ,row_number() over(partition by a.fin_prod_id order by a.a_adjust_calc_end_dt desc) as rn
             from ${iml_schema}.prd_am_cashflow_plan_h a --fams_fin_cash_plan t10
            where a.a_adjust_plan_pay_dt <= to_date('${batch_date}', 'yyyymmdd')
              and a.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and a.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and a.job_cd ='famsf2') t10
  on t1.fin_prod_id = t10.fin_prod_id
 and t10.rn=1
left join (select b.*
                  ,row_number() over(partition by b.fin_prod_id order by b.a_adjust_calc_end_dt asc) as rn
             from ${iml_schema}.prd_am_cashflow_plan_h b --fams_fin_cash_plan t10
            where b.a_adjust_plan_pay_dt > to_date('${batch_date}', 'yyyymmdd')
              and b.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and b.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and b.job_cd ='famsf2') t11
  on t1.fin_prod_id = t11.fin_prod_id
 and t11.rn=1
left join (select c.*
                  ,row_number() over(partition by c.fin_prod_id order by c.a_adjust_calc_end_dt asc) as rn
             from ${iml_schema}.prd_am_cashflow_plan_h c --fams_fin_cash_plan t10
            where c.a_adjust_plan_pay_dt > to_date('${batch_date}', 'yyyymmdd')
              and c.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and c.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and c.job_cd ='famsf2') t12
  on t1.fin_prod_id = t12.fin_prod_id
 and t12.rn=1
left join ${iol_schema}.fams_fin_product_add t13
  on t3.src_prod_id = t13.finprod_id
 and t13.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t13.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select t.*,
                  (row_number() over(partition by t.fin_prod_id, t.cntpty_id order by t.tran_dt desc)) rn
             from ${iml_schema}.evt_am_fin_prod_tran_h t
            where t.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and t.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and t.job_cd='famsf2') t16
  on t1.fin_prod_id = t16.cntpty_id
 and t16.rn =1
where t1.enter_acct_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.prod_cate_cd in ('F17', 'F18')
 and t1.job_cd='famsi2'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_am_non_std_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_non_std_invest_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_am_non_std_invest_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_am_non_std_invest', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);