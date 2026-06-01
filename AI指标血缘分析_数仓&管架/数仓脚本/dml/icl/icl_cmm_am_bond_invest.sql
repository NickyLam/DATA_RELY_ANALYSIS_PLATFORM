/*
Purpose:    共性加工层-资管债券投资表:数据来源于资管系统（FAMS）,包括所有资管账户持有的债券投资，即资管产品资产端的债券投资。
                                 备注：资管系统的每笔交易形成一笔资产
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_am_bond_invest
Createdate: 20190822
Logs:       20210220 陈伟峰 新增字段【账套编号、理财产品编号、理财产品名称、资产三分类代码、科目编号、计息方式代码、应收利息】
            20210224 陈伟峰 1.增加字段【资产类型代码、资管产品收益类型代码】
                            2.调整【资管产品编号、资管产品名称】顺序
                            3.修改字段名称 【理财产品编号】->【资产编号】，【理财产品名称】->【资产名称】
                            4.调整主键
            20210305 陈伟峰 调整字段【资管产品名称、资产名称】的取数口径
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
--alter table ${icl_schema}.cmm_am_bond_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_bond_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_bond_invest_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_bond_invest_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_am_bond_invest where 0=1;

whenever sqlerror exit sql.sqlcode;

insert /*+ append */ into ${icl_schema}.cmm_am_bond_invest_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,bus_id                  --业务编号
	  ,acct_set_id	           --账套编号
    ,am_prod_id 	           --资管产品编号
    ,am_prod_name 	         --资管产品名称
    ,std_prod_id             --标准产品编号
    ,am_prod_prft_type_cd    --资管产品收益类型代码
    ,asset_id                --资产编号
    ,asset_name              --资产名称
	  ,asset_thd_cls_cd	       --资产三分类代码
    ,bond_id                 --债券编号
    ,bond_name               --债券名称
	  ,subj_id	               --科目编号
    ,asset_type_cd           --资产类型代码
    ,tran_market_cd          --交易市场代码
    ,bond_type_cd            --债券类型代码
    ,brkevn_bond_flg         --保本债券标志
    ,convbl_bond_flg         --可转债标志
    ,sub_debt_flg            --次级债标志
    ,abs_flg                 --abs标志
    ,issuer_id               --发行人编号
    ,issuer_name             --发行人名称
    ,issue_dt                --发行日期
    ,value_dt                --起息日期
    ,exp_dt                  --到期日期
    ,tenor                   --期限
    ,base_rat_id             --基准利率编号
    ,int_accr_base_cd        --计息基准代码
	  ,int_accr_way_cd	       --计息方式代码
    ,int_rat_adj_way_cd      --利率调整方式代码
    ,int_rat_float_point     --利率浮动点数
    ,fir_pay_int_dt          --首次付息日期
    ,last_pay_int_dt         --上次付息日期
    ,next_pay_int_dt         --下次付息日期
    ,holiday_rule_cd         --节假日规则代码
    ,cty_cd                  --国家代码
    ,curr_cd                 --币种代码
    ,fac_val_amt             --票面金额
    ,fac_val_int_rat         --票面利率
    ,mk_pri_full_price       --市价全价
    ,mk_pri_net_price        --市价净价
    ,pay_int_freq            --付息频率
    ,pay_int_ped_cd          --付息周期代码
    ,int_accr_ped_cd         --计息周期代码
    ,reset_ped_cd            --重置周期代码
    ,hold_pos                --持有仓位
    ,hold_fac_val            --持有面值
    ,pric_bal                --本金余额
    ,acru_int                --应计利息
	  ,int_recvbl	             --应收利息
    ,int_adj_amt             --利息调整金额
    ,evha_val_chag           --公允价值变动
    ,actl_int_rat            --实际利率
    ,asset_four_cls_cd       --资产四分类代码
    ,open_dt                 --开仓日期
    ,tran_flow_num           --交易流水号
    ,crdt_out_acct_flow_num  --信贷出账流水号
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select
      to_date('${batch_date}','yyyymmdd')      as etl_dt              --数据日期
      , '9999'                                 as lp_id               --法人编号
      ,t1.acct_dtl_id                          as bus_id              --业务编号
      ,t1.sob_id                               as acct_set_id         --账套编号
      ,t3.src_prod_id                          as am_prod_id          --资管产品编号
      ,nvl(trim(t18.prod_name),t3.prod_abbr)   as am_prod_name        --资管产品名称
      ,t2.std_prod_id                          as std_prod_id         --标准产品编号
      ,nvl(t3.prft_type_cd, '00')              as am_prod_prft_type_cd--资管产品收益类型代码
      ,t1.fin_prod_id                          as asset_id            --资产编号
      ,nvl(trim(t17.prod_name),t2.prod_abbr)   as asset_name          --资产名称
      ,t1.invest_aim_cd                        as asset_thd_cls_cd    --资产三分类代码   cd2246-投资目的代码
      ,t7.seccode                              as bond_id             --债券编号
      ,t7.secfullname                          as bond_name           --债券名称
      ,get_fams_gl_account_id(trim(t21.src_code_val), '',nvl(decode(t3.prft_type_cd,'00','',t3.prft_type_cd), '01'))    as subj_id     --科目编号
      ,t1.prod_cate_cd                         as asset_type_cd       --资产类型代码
      ,t7.market                               as tran_market_cd      --交易市场代码
      ,t8.bank_int_prod_level4_cls_cd          as bond_type_cd        --债券类型代码
      ,t2.brkevn_flg                           as brkevn_bond_flg     --保本债券标志
      ,decode(t8.bank_int_prod_level5_cls_cd, '070', '1', '0')   as convbl_bond_flg     --可转债标志
      ,t9.is_sec_bond                          as sub_debt_flg        --次级债标志
      ,decode(t8.bank_int_prod_level5_cls_cd, '038', '1', '0')   as abs_flg             --abs标志
      ,t7.issuershort                          as issuer_id           --发行人编号
      ,t10.customer_name                       as issuer_name         --发行人名称
      ,t2.issue_dt                             as issue_dt            --发行日期
      ,t19.imp_dt                              as value_dt            --起息日期
      ,t20.imp_dt                              as exp_dt              --到期日期
      ,t2.prod_tenor                           as tenor               --期限
      ,t7.ratecode                             as base_rat_id         --基准利率编号
      ,t7.ratebasic                            as int_accr_base_cd    --计息基准代码
      ,t7.couponspecies                        as int_accr_way_cd     --计息方式代码
      ,t7.interestrate                         as int_rat_adj_way_cd  --利率调整方式代码
      ,t7.spreadrate_8                         as int_rat_float_point --利率浮动点数
      ,t7.firstrateday                         as fir_pay_int_dt      --首次付息日期
      ,t12.a_adjust_plan_pay_dt                as last_pay_int_dt     --上次付息日期
      ,t13.a_adjust_plan_pay_dt                as next_pay_int_dt     --下次付息日期
      ,t7.workdayrule                          as holiday_rule_cd     --节假日规则代码
      ,'CHN'                                   as cty_cd              --国家代码
      ,t2.issue_curr_cd                        as curr_cd             --币种代码
      ,nvl(t7.issueamt, 0) * nvl(t7.facevalue, 100) as fac_val_amt    --票面金额
      ,t7.paperir                              as fac_val_int_rat     --票面利率
      ,t14.price                               as mk_pri_full_price   --市价全价
      ,t14.netprice                            as mk_pri_net_price    --市价净价
      ,(case when t7.paycycle in ('06', '11') then 6
             when t7.paycycle in ('09') then 2
             when t7.paycycle in ('01', '02', '03', '04', '05', '12', '13', '14') then 1
             else 0 end)                       as pay_int_freq        --付息频率
      ,(case when t7.paycycle in ('01') then 'D'
             when t7.paycycle in ('02', '09') then 'W'
             when t7.paycycle in ('06', '11', '03', '12') then 'M'
             when t7.paycycle in ('04', '13') then 'Q'
             when t7.paycycle in ('05', '14') then 'Y'
             else 'D' end)                     as pay_int_ped_cd      --付息周期代码
      ,'-'                                     as int_accr_ped_cd     --计息周期代码
      ,'-'                                     as reset_ped_cd        --重置周期代码
      ,nvl(t1.curr_post_amt, 0)                as hold_pos            --持有仓位
      ,nvl(t1.curr_post_amt, 0) * nvl(t9.face_value, 0)    as hold_fac_val        --持有面值
      ,case when get_fams_gl_account_id(trim(t21.src_code_val), '', nvl(decode(t3.prft_type_cd,'00','',t3.prft_type_cd), '01')) = '1401052001'
            then nvl(t1.dc_td_cost_tot, 0) - nvl(t15.dc_dr_bal, 0)
            else nvl(t1.td_provi_lot, 0) * nvl(t9.face_value, 0)
            end                                as pric_bal            --本金余额
      ,case when t7.couponspecies in ('02', '04')
            then (case when get_fams_gl_account_id(trim(t21.src_code_val), '', nvl(decode(t3.prft_type_cd,'00','',t3.prft_type_cd), '01')) = '1401052001'
                       then nvl(t15.dc_dr_bal, 0)
                       else nvl(t1.td_acm_acru_int_bal, 0)
                       end)
            else 0 end                         as acru_int            --应计利息
      ,case when t7.couponspecies in ('02', '04')
            then 0
            else (case when get_fams_gl_account_id(trim(t21.src_code_val), '', nvl(decode(t3.prft_type_cd,'00','',t3.prft_type_cd), '01')) = '1401052001'
                       then nvl(t15.dc_dr_bal, 0)
                       else nvl(t1.td_acm_acru_int_bal, 0)
                        end)
            end                                as int_recvbl          --应收利息
      ,t15.dc_bal                              as int_adj_amt         --利息调整金额
      ,t1.td_acm_evha_val_chag                 as evha_val_chag       --公允价值变动
      ,t1.provi_int_rat                        as actl_int_rat        --实际利率
      ,'-'                                     as asset_four_cls_cd   --资产四分类代码
      ,t16.dlvy_dt                             as open_dt             --开仓日期
      ,t16.tran_id                             as tran_flow_num       --交易流水号
      ,t16.out_acct_flow_num                   as crdt_out_acct_flow_num    --信贷出账流水号
      ,t1.job_cd                               as job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --数据处理时间
from ${iml_schema}.fin_am_stat_analy_acct_dtl t1  --  fams_bok_stat_det_posiiton t1
left join ${iml_schema}.prd_am_invest_underly_prod  t2 --fams_fin_product t2
  on t1.fin_prod_id = t2.src_prod_id
 and t2.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd ='famsf2'
 and t2.id_mark <>'D'
left join ${iml_schema}.prd_name_h t17
  on t2.prod_id=t17.prod_id
 and t17.prod_name_type_cd='01'
 and t17.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t17.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t17.job_cd ='famsf2'
left join ${iml_schema}.prd_imp_dt_h t19
  on t2.prod_id =t19.prd_id
 and t19.dt_type_cd='31'
 and t19.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t19.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t19.job_cd ='famsf2'
left join ${iml_schema}.prd_imp_dt_h t20
  on t2.prod_id =t20.prd_id
 and t20.dt_type_cd='46'
 and t20.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t20.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t20.job_cd ='famsf2'
left join ${iml_schema}.prd_am_finc_prod  t3 --fams_fin_product t3
  on (t1.sob_id = t3.src_prod_id or t1.sob_id = t3.super_prod_id or t1.sob_id = t3.finc_prod_id)
 and t3.prod_cate_cd = 'F16'
 and t3.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd ='famsf2'
 and t3.id_mark <>'D'
left join ${iml_schema}.prd_name_h t18
  on t3.prod_id=t18.prod_id
 and t18.prod_name_type_cd='01'
 and t18.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t18.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t18.job_cd ='famsf2'
left join ${iol_schema}.fams_pa_fin_product t6  --暂无使用
  on t1.fin_prod_id = t6.finprod_id
 and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_interf_payhsrcsecinfo t7
  on t1.fin_prod_id = 'F01_' || t7.secid
 and t7.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.prd_am_fin_prod_cls_h t8 --fams_fin_product_type t8
  on t1.fin_prod_id = t8.fin_prod_id
 and t8.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t8.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t8.job_cd ='famsf2'
left join ${iol_schema}.fams_fin_product_add t9
  on t1.fin_prod_id = t9.finprod_id
 and t9.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_mst_customer_info t10
  on t7.issuershort = t10.customer_id
 and t10.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t10.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select t.*,
                  row_number() over(partition by t.src_prod_id order by t.cashflow_id desc) as rn
             from ${iml_schema}.prd_am_cashflow_info_h t  --fams_fin_cash_info t11
            where t.cashflow_sub_type_cd = '200'
              and t.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and t.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and t.job_cd ='famsf2') t11
  on t11.src_prod_id = t9.finprod_id
 and t11.rn=1
left join (select a.*,
                 row_number() over(partition by a.cashflow_id order by a.a_adjust_calc_end_dt desc) as rn
             from ${iml_schema}.prd_am_cashflow_plan_h a --fams_fin_cash_plan t12
            where a.a_adjust_plan_pay_dt <= to_date('${batch_date}', 'yyyymmdd')
              and a.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and a.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and a.job_cd ='famsf2') t12
  on t11.cashflow_id = t12.cashflow_id
 and t12.rn=1
left join (select b.*,
                 row_number() over(partition by b.cashflow_id order by b.a_adjust_calc_end_dt asc) as rn
             from ${iml_schema}.prd_am_cashflow_plan_h b  --fams_fin_cash_plan t13
            where b.a_adjust_plan_pay_dt > to_date('${batch_date}', 'yyyymmdd')
             and b.start_dt <=to_date('${batch_date}', 'yyyymmdd')
             and b.end_dt >to_date('${batch_date}', 'yyyymmdd')
             and b.job_cd ='famsf2') t13
  on t11.cashflow_id = t13.cashflow_id
 and t13.rn=1
left join (select c.*,
                 (row_number() over(partition by c.sec_id order by c.value_date asc)) as rn
           from iol.fams_mst_bond_valuation_info c
           where c.start_dt <=to_date('${batch_date}', 'yyyymmdd')
           and c.end_dt >to_date('${batch_date}', 'yyyymmdd'))t14
  on t7.secid = t14.sec_id
 and t14.rn=1
left join (select acct_pkg_id, substr(subj_id, length(super_subj_id) + 1) as fin_prod_id,
                  sum(nvl(dc_dr_bal, 0)) as dc_dr_bal, sum(nvl(dc_bal, 0)) as dc_bal
             from ${iml_schema}.fin_am_prod_intnal_subj_bal
            where (super_subj_id like '1102%02' or super_subj_id like '1104%02')
              and bal_dt = to_date('${batch_date}','yyyymmdd')
              and job_cd='famsi2'
            group by acct_pkg_id, substr(subj_id, length(super_subj_id) + 1)
            ) t15
  on t1.sob_id = t15.acct_pkg_id
 and t15.fin_prod_id = t1.fin_prod_id
left join (select d.*,
                row_number() over(partition by d.fin_prod_id, d.cntpty_id order by d.tran_dt desc) as rn
                from ${iml_schema}.evt_am_fin_prod_tran_h d --fams_trd_product_deal t16
                where d.start_dt <=to_date('${batch_date}', 'yyyymmdd')
                and d.end_dt >to_date('${batch_date}', 'yyyymmdd')
                and d.job_cd ='famsf2') t16
  on t1.sob_id = t16.cntpty_id
 and t1.fin_prod_id = t16.fin_prod_id
 and t16.rn=1
left join ${iml_schema}.ref_pub_cd_map t21
  on t21.src_tab_en_name = 'FAMS_FIN_PRODUCT_TYPE'
 and t21.src_field_en_name = 'TYPE_11'
 and t21.target_tab_field_en_name = 'BANK_INT_PROD_LEVEL4_CLS_CD'
 and t21.target_cd_val = t8.bank_int_prod_level4_cls_cd
where t1.job_cd='famsi2'
 and t1.enter_acct_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.prod_cate_cd in ('F01')
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_am_bond_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_bond_invest_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_am_bond_invest_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_am_bond_invest', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);