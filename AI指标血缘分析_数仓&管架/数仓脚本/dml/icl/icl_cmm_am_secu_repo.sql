/*
Purpose:    共性加工层-资管证券回购表:数据来源于资管系统（FAMS）,包括所有资管账户持有的债券回购业务（含债券、票据）
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_am_secu_repo
Createdate: 20190822
Logs:       20200327 翟若平 增加字段[标准产品编号]
            20210224 陈伟峰 新增字段【账套编号、资管产品编号、资管产品名称、资管产品收益类型代码、资产编号、资产名称、科目编号、资产三分类代码、资产类型代码、利率调整方式代码、应计利息】
                            重新映射成新资管2.0系统的表
                            调整主键字段【数据日期、法人编号、业务编号、账套编号、资管产品编号、资产三分类代码】
                            调整字段长度【交易员名称：VARCHAR2(500)、质押物名称组合：VARCHAR2(4000)、交易对手类型代码：VARCHAR2(60)、投组名称：VARCHAR(500)】
            20210305 陈伟峰 新增字段【质押债券类型组合】
                            调整字段【质押比例、质押物价值、质押物面值、质押物编号组合、质押物名称组合、资管产品名称、资产名称】的取数口径
                            调整字段【质押比例、质押物价值、质押物面值、质押物编号组合、质押物名称组合】的字段长度
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
--alter table ${icl_schema}.cmm_am_secu_repo drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_secu_repo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_secu_repo_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_secu_repo_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_am_secu_repo where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_am_secu_repo_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,bus_id                  --业务编号
    ,repo_type_cd            --回购类型代码
	  ,acct_set_id             --账套编号
    ,am_prod_id              --资管产品编号
    ,am_prod_name            --资管产品名称
    ,std_prod_id             --标准产品编号
	  ,am_prod_prft_type_cd    --资管产品收益类型代码
	  ,asset_id                --资产编号
	  ,asset_name              --资产名称
	  ,asset_thd_cls_cd        --资产三分类代码
	  ,subj_id                 --科目编号
    ,cntpty_id               --交易对手编号
    ,cntpty_name             --交易对手名称
	  ,asset_type_cd           --资产类型代码
    ,indus_type_cd           --行业类型代码
    ,cntpty_type_cd          --交易对手类型代码
    ,portf_id                --投组编号
    ,portf_name              --投组名称
    ,tran_dir_cd             --交易方向代码
    ,tran_dt                 --交易日期
    ,value_dt                --起息日期
    ,exp_dt                  --到期日期
    ,tenor                   --期限
    ,tran_amt                --交易金额
    ,exp_stl_amt             --到期结算金额
	  ,acru_int                --应计利息
    ,int_accr_base_cd        --计息基准代码
	  ,int_rat_adj_way_cd      --利率调整方式代码
    ,curr_cd                 --币种代码
    ,repo_int_rat            --回购利率
    ,bond_fac_val            --债券面值
    ,inpwn_ratio             --质押比例
    ,pledge_val              --质押物价值
    ,pledge_fac_val          --质押物面值
    ,pledge_id_comb          --质押物编号组合
    ,pledge_name_comb        --质押物名称组合
    ,inpwn_bond_type_comb    --质押债券类型组合
    ,currt_bal               --当期余额
    ,td_acru_int             --当日应计利息
    ,currt_acru_int          --当期应计利息
    ,fst_stl_way_cd          --首期结算方式代码
    ,exp_stl_way_cd          --到期结算方式代码
    ,dealer_id               --交易员编号
    ,dealer_name             --交易员名称
    ,tran_id                 --交易编号
    ,bag_id                  --成交编号
    ,onl_flg                 --线上标志
    ,crdt_out_acct_flow_num  --信贷出账流水号
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')         as etl_dt           --数据日期
      ,t1.lp_id                                    as lp_id            --法人编号
      ,t1.acct_dtl_id                              as bus_id           --业务编号
      ,decode(t1.prod_cate_cd, 'F02', 'N', 'F03', 'N', 'F04', 'B', 'F05', 'B')   as repo_type_cd     --回购类型代码
      ,t1.sob_id                                   as acct_set_id      --账套编号
      ,t3.src_prod_id                              as am_prod_id       --资管产品编号
      ,nvl(trim(t12.prod_name),t3.prod_abbr)       as am_prod_name     --资管产品名称
      ,t2.std_prod_id                              as std_prod_id      --标准产品编号
      ,t7.profit_flag                              as am_prod_prft_type_cd     --资管产品收益类型代码
      ,t1.fin_prod_id                              as asset_id         --资产编号
      ,nvl(trim(t11.prod_name),t2.prod_abbr)       as asset_name       --资产名称
      ,t1.invest_aim_cd                            as asset_thd_cls_cd --资产三分类代码
      ,case when t7.profit_flag in ('01','02') and t1.prod_cate_cd = 'F02'
	          then '21120102' --质押式正回购  保本,质押式,正回购
            when t7.profit_flag in ('01','02') and t1.prod_cate_cd = 'F03'
		        then '1401020102'  --质押式逆回购 保本,质押式,逆回购
            when t7.profit_flag in ('01','02') and t1.prod_cate_cd = 'F04'
		        then '21120101' ---买断式正回购  保本,买断式,正回购
            when t7.profit_flag in ('01','02') and t1.prod_cate_cd = 'F05'
		        then '1401020101'  ---买断式逆回购 保本,买断式,逆回购
            else '-' end                           as subj_id          --科目编号
      ,t5.counter_id                               as cntpty_id        --交易对手编号
      ,t5.counter_name                             as cntpty_name      --交易对手名称
      ,t1.prod_cate_cd                             as asset_type_cd    --资产类型代码
      ,t6.proj_invest_industry                     as indus_type_cd    --行业类型代码
      ,t5.counter_type                             as cntpty_type_cd   --交易对手类型代码
      ,t7.portfolio_id                             as portf_id         --投组编号
      ,t12.prod_name                               as portf_name       --投组名称
      ,decode(t1.prod_cate_cd, 'F02', 'RS', 'F03', 'RB', 'F04', 'RS', 'F05', 'RB')                       as tran_dir_cd  --交易方向代码
      ,case when t9.tran_dt=to_date('19000101', 'yyyymmdd') then t1.enter_acct_dt else t9.tran_dt end    as tran_dt      --交易日期
      ,t4.value_dt                                 as value_dt         --起息日期
      ,t4.exp_dt                                   as exp_dt           --到期日期
      ,t4.tenor_days                               as tenor            --期限
      ,t4.exp_pric                                 as tran_amt         --交易金额
      ,t4.exp_amt                                  as exp_stl_amt      --到期结算金额
      ,t1.td_acm_acru_int_bal                      as acru_int         --应计利息
      ,t4.int_accr_base_cd                         as int_accr_base_cd --计息基准代码
      ,t4.int_rat_type_cd                          as int_rat_adj_way_cd --利率调整方式代码
      ,t1.curr_cd                                  as curr_cd          --币种代码
      ,t1.provi_int_rat                            as repo_int_rat     --回购利率
      ,t1.curr_post_amt                            as bond_fac_val     --债券面值
      ,t8.inpwn_ratio                              as inpwn_ratio      --质押比例
      ,t8.pledge_val                               as pledge_val       --质押物价值
      ,t8.pledge_fac_val                           as pledge_fac_val   --质押物面值
      ,t8.pledge_id_comb                           as pledge_id_comb   --质押物编号组合
      ,t8.pledge_name_comb                         as pledge_name_comb --质押物名称组合
      ,t8.pledge_finprod_type                      as inpwn_bond_type_comb  --质押债券类型组合
      ,t1.curr_post_amt                            as currt_bal        --当期余额
      ,t1.td_happ_acru_int                         as td_acru_int      --当日应计利息
      ,t1.td_acm_acru_int_bal                      as currt_acru_int   --当期应计利息
      ,t4.exp_stl_way_cd                           as fst_stl_way_cd   --首期结算方式代码
      ,t4.exp_stl_way_cd                           as exp_stl_way_cd   --到期结算方式代码
      ,t9.dealer_name                              as dealer_id        --交易员编号
      ,t10.real_name                               as dealer_name      --交易员名称
      ,t9.tran_id                                  as tran_id          --交易编号
      ,t9.tran_id                                  as bag_id           --成交编号
      ,'ON'                                        as onl_flg          --线上标志
      ,t9.out_acct_flow_num                        as crdt_out_acct_flow_num     --信贷出账流水号
      ,t1.job_cd                                   as job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    as etl_timestamp    --数据处理时间
from ${iml_schema}.fin_am_stat_analy_acct_dtl t1 --fams_bok_stat_det_posiiton t1
left join ${iml_schema}.prd_am_invest_underly_prod  t2 --fams_fin_product t2
  on t1.fin_prod_id = t2.src_prod_id
 and t2.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd ='famsf2'
 and t2.id_mark <>'D'
left join ${iml_schema}.prd_name_h t11
  on t2.prod_id=t11.prod_id
 and t11.prod_name_type_cd='01'
 and t11.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t11.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t11.job_cd ='famsf2'
left join ${iml_schema}.prd_am_finc_prod  t3 --fams_fin_product t3
  on (t1.sob_id = t3.src_prod_id or t1.sob_id = t3.super_prod_id or t1.sob_id = t3.finc_prod_id)
 and t3.prod_cate_cd = 'F16'
 and t3.create_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd ='famsf2'
 and t3.id_mark <>'D'
left join ${iml_schema}.prd_name_h t12
  on t3.prod_id=t12.prod_id
 and t12.prod_name_type_cd='01'
 and t12.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t12.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t12.job_cd ='famsf2'
left join ${iml_schema}.prd_am_tran_class_fin_prod t4 --fams_fin_trade_product t4
  on t1.fin_prod_id = t4.fin_prod_id
 and t1.job_cd ='famsi2'
left join ${iol_schema}.fams_mst_counter_party t5
  on t4.cntpty_id = t5.counter_id
 and t5.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t5.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_pa_fin_product t6
  on t1.fin_prod_id = t6.finprod_id
 and t6.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_fin_product_add t7
  on t3.src_prod_id = t7.finprod_id
 and t7.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select dp.finprod_id,
                  listagg(nvl(dp.pledge_amt, 0), ',') within group(order by dp.pledge_finprod_id) as pledge_val ,
                  listagg(nvl(dp.pledge_face_value, 0) * nvl(dp.pledge_number, 0), ',') within group(order by dp.pledge_finprod_id) as pledge_fac_val,
                  listagg(dp.pledge_ratio * 100, ',') within group(order by dp.pledge_finprod_id) as inpwn_ratio,
                  listagg(trim(dp.pledge_finprod_id), ',') within group(order by dp.pledge_finprod_id) as pledge_id_comb,
                  listagg(nvl(trim(tp.finprod_name), trim(tp.finprod_abbr)), ',') within group(order by dp.pledge_finprod_id) as pledge_name_comb,
                  listagg(trim(fpt.bank_int_prod_level4_cls_cd), ',') within group(order by fpt.fin_prod_id) as pledge_finprod_type
             from ${iol_schema}.fams_fin_deal_pledge dp
             left join ${iol_schema}.fams_fin_product tp
               on dp.pledge_finprod_id = tp.finprod_id
              and tp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and tp.end_dt > to_date('${batch_date}', 'yyyymmdd')
             left join ${iml_schema}.prd_am_fin_prod_cls_h fpt --iol.fams_fin_product_type fpt
               on dp.pledge_finprod_id = fpt.fin_prod_id
              and fpt.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and fpt.end_dt > to_date('${batch_date}', 'yyyymmdd')
              and fpt.job_cd ='famsf2'
            where dp.start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and dp.end_dt > to_date('${batch_date}', 'yyyymmdd')
            group by dp.finprod_id) t8
  on t1.fin_prod_id = t8.finprod_id
left join ${iml_schema}.evt_am_fin_prod_tran_h t9--fams_trd_product_deal t9
  on t1.fin_prod_id = t9.tran_id
 and t9.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t9.job_cd ='famsf2'
left join ${iol_schema}.fams_sys_user t10
  on t9.dealer_name = t10.user_name
 and t10.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t10.end_dt >to_date('${batch_date}', 'yyyymmdd')
where t1.enter_acct_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.prod_cate_cd in ('F02', 'F03', 'F04', 'F05')
 and t1.job_cd ='famsi2'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_am_secu_repo exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_secu_repo_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_am_secu_repo_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_am_secu_repo', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);