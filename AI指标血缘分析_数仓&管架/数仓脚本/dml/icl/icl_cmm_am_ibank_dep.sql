/*
Purpose:    共性加工层-资管同业存放表:数据来源于资金系统（FAMS）,包括资管产品资产端投资（存放同业）
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_am_ibank_dep
Createdate: 20190822
Logs:       20211107 何桐金 【evt_am_tran_provi】增加job_cd过滤条件

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_am_ibank_dep drop partition p_${retain_day};
alter table ${icl_schema}.cmm_am_ibank_dep add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_am_ibank_dep_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_am_ibank_dep_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_am_ibank_dep where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_am_ibank_dep_ex(
     etl_dt                  --数据日期
    ,lp_id                   --法人编号
    ,bus_id                  --业务编号
    ,am_prod_id              --资管产品编号
    ,am_prod_name            --资管产品名称
    ,cntpty_id               --交易对手编号
    ,cntpty_name             --交易对手名称
    ,indus_type_cd           --行业类型代码
    ,cntpty_type_id          --交易对手类型编号
    ,int_accr_base_cd        --计息基准代码
    ,int_rat_adj_way_cd      --利率调整方式代码
    ,int_rat_float_point     --利率浮动点数
    ,base_rat_id             --基准利率编号
    ,tran_dir_cd             --交易方向代码
    ,pay_int_freq            --付息频率
    ,int_rat_reset_freq      --利率重置频率
    ,holiday_rule_cd         --节假日规则代码
    ,tran_dt                 --交易日期
    ,value_dt                --起息日期
    ,exp_dt                  --到期日期
    ,exec_int_rat            --执行利率
    ,curr_cd                 --币种代码
    ,tran_amt                --交易金额
    ,exp_amt                 --到期金额
    ,acru_int                --应计利息
    ,currt_bal               --当期余额
    ,td_acru_int             --当日应计利息
    ,currt_acru_int          --当期应计利息
    ,dealer_id               --交易员编号
    ,cntpty_dealer_id        --对方交易员编号
    ,onl_tran_flg            --线上交易标志
    ,bag_id                  --成交编号
    ,tran_id                 --交易编号
    ,job_cd
    ,etl_timestamp           --数据处理时间
)
select to_date('${batch_date}','yyyymmdd') as etl_dt              --数据日期
      ,t1.lp_id                            as lp_id               --法人编号
      ,t1.agt_id                           as bus_id              --协议编号
      ,t1.ghb_acct_id                      as am_prod_id          --本方账户编号
      ,t3.prod_name                        as am_prod_name        --产品名称
      ,t1.cntpty_id                        as cntpty_id           --交易对手编号
      ,t2.cntpty_name                      as cntpty_name         --交易对手名称
      ,t2.indus_type_cd                    as indus_type_cd       --行业类型代码
      ,t1.cntpty_type_cd                   as cntpty_type_id      --交易对手类型代码 O为外部机构,I为内部机构,A为系统内账户,E为其他
      ,t1.int_accr_base_cd                 as int_accr_base_cd    --计息基准代码 计息基础,A/360,A/365
      ,t1.int_rat_adj_way_cd               as int_rat_adj_way_cd  --利率调整方式代码 利率类型 固定利率 FI 浮动利率 FL 人工利率 FP
      ,t1.int_rat_float_point              as int_rat_float_point --利率浮动点数 利率浮动点差，固定利率填0
      ,t1.hook_float_int_rat_cd            as base_rat_id         --挂钩浮动利率代码(挂钩利率代码 个人定期（整存整取）三个月 001 个人定期（整存整取）半年 002 个人定期（整存整取）一年 00)
      ,t1.tran_dir_cd                      as tran_dir_cd         --交易方向代码 DTB 同业存放 DFB 存放同业
      ,t1.pay_int_freq                     as pay_int_freq        --付息频率 1次 1 2次 2 4次 4
      ,t1.int_rat_reset_freq               as int_rat_reset_freq  --利率重置频率
      ,t1.holiday_rule_cd                  as holiday_rule_cd     --节假日规则代码 向前  P 向后  S 调整的向后 M
      ,t1.tran_dt                          as tran_dt             --交易日期
      ,t1.value_dt                         as value_dt            --起息日期
      ,t1.exp_dt                           as exp_dt              --到期日期
      ,t1.exec_int_rat                     as exec_int_rat        --执行利率 固定利率（当利率类型选择为固定利率或者人工利率有效)
      ,t1.curr_cd                          as curr_cd             --币种代码
      ,t1.pric_amt                         as tran_amt            --本金金额
      ,t1.fir_stl_amt                      as exp_amt             --首次结算金额 拆分/转仓首次结算金额=转仓本金 + 转仓区间利息
      ,t1.int_dlvy_amt                     as acru_int            --利息交割金额 利息交割金额（交易录入时为0,资产转移时计算,转出记负,转入记正）
      ,t4.provi_pos                        as currt_bal           --计提头寸 现金头寸和资产头寸的最小值
      ,t4.td_acru_int                      as td_acru_int         --当日应计利息 （通过计提产生） =当日区间累计应计利息余额-(昨日区间累计应计利息余额-当日新增待付）-（当日变动的应计利息额-当日调整的应计利息+当日结转) （如果今天是区间起始日则直接用当日区间累计应计利息余额,不用做差）
      ,t4.td_acm_acru_int_inco             as currt_acru_int      --当日累计应计利息收入 当日累计应计利息收入 =昨日累计应计利息收入+今日发生-今日调整
      ,t1.ghb_dealer_id                    as dealer_id           --本方交易员编号
      ,t1.cntpty_dealer_id                 as cntpty_dealer_id    --对方交易员编号
      ,'0'                                 as onl_tran_flg        --线上交易标志 存放同业无该字段
      ,t1.bus_id                           as bag_id              --业务编号
      ,t1.bus_id                           as tran_id             --业务编号
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_am_due_f_banks t1  --资管存放同业
  left join ${iml_schema}.pty_am_cntpty_info t2 --资管交易对手信息
    on t1.cntpty_id = t2.cntpty_abbr
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'famsf1'
  left join ${iml_schema}.prd_int_rat_type_am t3 --利率型资管产品
    on t1.ghb_acct_id = t3.user_prod_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   --and t3.valid_flg <> 'D' --删除
   and t3.valid_flg = 'E' --有效
   and t3.job_cd = 'famsf1'
  left join ${iml_schema}.evt_am_tran_provi t4 --资管交易计提事件
    on t1.tran_flow_num = t4.tran_flow_num
   and t1.bus_id = t4.bus_id
   and t1.ghb_acct_id = t4.prod_acct_id
   and t4.bus_module_id = '040507' --存放计提
   and t4.pos_type_cd = 'NOR' --NOR 正常 HIS 历史快照,倒起息时使用
   and t4.provi_dt = to_date('${batch_date}', 'yyyymmdd')  --计提日期
   and t4.job_cd = 'famsi1'
 where t1.tran_dt <= to_date('${batch_date}', 'yyyymmdd') --交易日期
   and t1.job_cd = 'famsf1'
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_am_ibank_dep exchange partition p_${batch_date} with table ${icl_schema}.cmm_am_ibank_dep_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_am_ibank_dep_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_am_ibank_dep', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);