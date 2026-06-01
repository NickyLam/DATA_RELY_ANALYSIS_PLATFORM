/*
Purpose:    共性加工层-资管同业拆借表:数据来源于资管系统（FAMS）,是资管产品资产端投资数据（同业拆借）
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_am_ib_lend
Createdate: 20190822
Logs:       20210201 周沁晖 新增字段【账套编号】【理财产品编号】【理财产品名称】【资产三分类代码】
            20210220 陈伟峰 调整字段【起息日期、到期日期、交易金额、应计利息】的取数逻辑
                            调整主键字段【数据日期、法人编号、业务编号、账套编号、资管产品编号、资产三分类代码】
                            增加字段【金融产品类型代码、理财产品收益类型代码】
            20210305 陈伟峰 调整字段【资管产品名称、资产名称】的取数口径
            20210318 陈伟峰 增加字段【信贷出账流水号】
            20211012 陈伟峰 增加字段【标准产品编号】
            20230907 徐子豪 修复【产品名称历史】关联逻辑,修改重复关联表别名。
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_am_ib_lend drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_ib_lend add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_ib_lend_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_ib_lend_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_am_ib_lend where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_am_ib_lend_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,bus_id                  --业务编号
    ,acct_set_id             --账套编号
    ,am_prod_id              --资管产品编号
    ,am_prod_name            --资管产品名称
    ,std_prod_id             --标准产品编号
    ,am_prod_prft_type_cd    --资管产品收益类型代码
    ,asset_id                --资产编号
    ,asset_name              --资产名称
    ,asset_thd_cls_cd        --资产三分类代码
    ,cntpty_id               --交易对手编号
    ,cntpty_name             --交易对手名称
    ,asset_type_cd           --资产类型代码
    ,indus_type_cd           --行业类型代码
    ,cntpty_type_id          --交易对手类型编号
    ,int_accr_base_cd        --计息基准代码
    ,tran_dir_cd             --交易方向代码
    ,tran_dt                 --交易日期
    ,value_dt                --起息日期
    ,exp_dt                  --到期日期
    ,exec_int_rat            --执行利率
    ,tenor                   --期限
    ,curr_cd                 --币种代码
    ,tran_amt                --交易金额
    ,exp_amt                 --到期金额
    ,acru_int                --应计利息
    ,tran_fee                --交易费用
    ,tran_tax                --交易税金
    ,tran_comm               --交易佣金
    ,currt_bal               --当期余额
    ,td_acru_int             --当日应计利息
    ,currt_acru_int          --当期应计利息
    ,dealer_id               --交易员编号
    ,cntpty_dealer_id        --对方交易员编号
    ,onl_tran_flg            --线上交易标志
    ,bag_id                  --成交编号
    ,tran_id                 --交易编号
    ,crdt_out_acct_flow_num  --信贷出账流水号
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select to_date('${batch_date}','yyyymmdd') as etl_dt              --数据日期
      ,t1.lp_id                            as lp_id               --法人编号
      ,t1.acct_dtl_id                      as bus_id              --业务编号
      ,t1.sob_id                           as sob_id              --账套编号
      ,t3.src_prod_id                      as am_prod_id          --资管产品编号
      ,nvl(trim(t9.prod_name),t3.prod_abbr) as am_prod_name       --资管产品名称
      ,t2.std_prod_id                      as std_prod_id         --标准产品编号
      ,t7.profit_flag                      as am_prod_prft_type_cd--资管产品收益类型代码
      ,t1.fin_prod_id                      as asset_id            --资产编号
      ,nvl(trim(t8.prod_name),t2.prod_abbr)  as asset_name        --资产名称
      ,t1.invest_aim_cd                    as asset_thd_cls_cd    --资产三分类代码
      ,t5.counter_id                       as cntpty_id           --交易对手编号
      ,t5.counter_name                     as cntpty_name         --交易对手名称
      ,t1.prod_cate_cd                     as asset_type_cd       --资产类型代码
      ,t6.proj_invest_industry             as indus_type_cd       --行业类型代码
      ,t5.counter_type                     as cntpty_type_id      --交易对手类型代码
      ,t4.int_accr_base_cd                 as int_accr_base_cd    --计息基准代码
      ,t1.prod_cate_cd                     as tran_dir_cd         --交易方向代码
      ,t1.enter_acct_dt                    as tran_dt             --交易日期
      ,t4.value_dt                         as value_dt            --起息日期
      ,t4.exp_dt                           as exp_dt              --到期日期
      ,t1.provi_int_rat                    as exec_int_rat        --拆借利率
      ,t4.tenor_days                       as tenor               --期限
      ,t1.curr_cd                          as curr_cd             --币种代码
      ,t4.exp_pric                         as tran_amt            --交易金额
      ,t4.exp_amt                          as exp_amt             --到期结算金额
      ,t1.td_acm_acru_int_bal              as acru_int            --应计利息
      ,0                                   as tran_fee            --交易费用
      ,0                                   as tran_tax            --交易税金
      ,0                                   as tran_comm           --交易佣金
      ,t1.curr_post_amt                    as currt_bal           --计提头寸
      ,t1.td_happ_acru_int                 as td_acru_int         --当日应计利息 （通过计提产生） =当日区间累计应计利息余额-(昨日区间累计应计利息余额-当日新增待付）-（当日变动的应计利息额-当日调整的应计利息+当日结转) （如果今天是区间起始日则直接用当日区间累计应计利息余额,不用做差）
      ,t1.td_acm_acru_int_bal              as currt_acru_int      --当日累计应计利息收入 当日累计应计利息收入 =昨日累计应计利息收入+今日发生-今日调整
      ,''                                  as dealer_id           --本方交易员编号
      ,''                                  as cntpty_dealer_id    --对方交易员编号
      ,''                                  as onl_tran_flg        --线上标志
      ,t4.cont_id                          as bag_id              --成交编号
      ,t1.proc_order_id                    as tran_id             --交易编号
      ,t10.out_acct_flow_num               as crdt_out_acct_flow_num    --信贷出账流水号
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.fin_am_stat_analy_acct_dtl t1
left join ${iml_schema}.prd_am_invest_underly_prod t2 -- 资管产品
  on t1.fin_prod_id = t2.src_prod_id
 and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.id_mark <> 'D'
 and t2.job_cd = 'famsf2'
left join ${iml_schema}.PRD_NAME_H t8
  on t2.prod_id=t8.prod_id
 and t8.prod_name_type_cd='01'
 and t8.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t8.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t8.job_cd ='famsf2'
left join ${iml_schema}.prd_am_finc_prod t3 -- 理财产品
  on (t1.sob_id = t3.src_prod_id or t1.sob_id = t3.super_prod_id or t1.sob_id = t3.finc_prod_id)
 and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.prod_cate_cd = 'F16'
 and t3.id_mark <> 'D'
 and t3.job_cd = 'famsf2'
left join ${iml_schema}.PRD_NAME_H t9
  on t3.prod_id=t9.prod_id
 and t9.prod_name_type_cd='01'
 and t9.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt >to_date('${batch_date}', 'yyyymmdd')
 and t9.job_cd ='famsf2'
left join ${iml_schema}.prd_am_tran_class_fin_prod t4
  on t1.fin_prod_id = t4.fin_prod_id
 and to_char(t4.update_tm,'yyyymmdd') = '${batch_date}'
 and t4.job_cd = 'famsi2'
left join ${iol_schema}.fams_mst_counter_party t5
  on t4.cntpty_id = t5.counter_id
 and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_pa_fin_product t6
  on t1.fin_prod_id = t6.finprod_id
 and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.fams_fin_product_add t7
  on t3.src_prod_id = t7.finprod_id
 and t7.start_dt <=to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt >to_date('${batch_date}', 'yyyymmdd')
left join (select t.*,
                  (row_number() over(partition by t.fin_prod_id, t.cntpty_id order by t.tran_dt desc)) rn
             from ${iml_schema}.evt_am_fin_prod_tran_h t
            where t.start_dt <=to_date('${batch_date}', 'yyyymmdd')
              and t.end_dt >to_date('${batch_date}', 'yyyymmdd')
              and t.job_cd='famsf2') t10
  on t1.sob_id = t10.cntpty_id
 and t1.fin_prod_id = t10.fin_prod_id
 and t10.rn =1
where t1.enter_acct_dt = to_date('${batch_date}', 'yyyymmdd')
 and t1.prod_cate_cd in ('F08', 'F09')
 and t1.job_cd = 'famsi2'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_am_ib_lend exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_ib_lend_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_am_ib_lend_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_am_ib_lend', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);