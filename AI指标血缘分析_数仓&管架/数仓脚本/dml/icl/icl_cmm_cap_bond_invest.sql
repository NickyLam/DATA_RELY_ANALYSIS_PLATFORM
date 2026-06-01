/*
Purpose:    共性加工层-资金债券投资
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_cap_bond_invest
CreateDate: 20191025
Logs:       fuxx add column 'currt_bal' 20191108
            20200110 翟若平 增加字段[记账机构编号]
            20200327 翟若平 表T2.的分组条件变更[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE] -〉 [T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.ASSETTYPE]
            20200627 周沁晖 增加字段【应计利息、应收利息】
            				        表T2.的分组条件变更[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.ASSETTYPE] -〉[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.MAJORASSETCODE,T2.ASSETTYPE, T2.BUZTYPE]
            				        调整字段【币种代码】的取数逻辑
			      20200724 陈伟峰 增加字段【标准产品编号】
			      20200828 周沁晖 增加字段【发行人客户编号、资产三分类代码、中债全价估值、中债净价估值、估价修正久期、基点价值、估值凸性、估价收益率、账面余额】
			      				        增加字段【资产类型名称、业务类别名称、可转债编号】
			      				        调整字段【科目编号】取数逻辑
			      				        调整字段【基点价值口径（T9.DP * T1.HOLDPOSITION / 100 * T9.MDURATION / 10000 -》 T9.DP * T1.HOLDPOSITION / 100 * T9.CDC_MD / 10000）】
			      20200828 陈伟峰 REF_DC_SUBJ_MAP（本币科目映射）算法变更，去掉etl_dt
			      20200925 周沁晖 调整【资金债券投资】的字段【中债估值净价、中债估值全价】的取数口径
			      20201111 陈伟峰 调整资产三分类取数逻辑，从agt_cap_asset_bal中直取
			      20201112 陈伟峰 修改记账机构的取值逻辑，从ref_dc_subj_map匹配科目取->从ctms_tbs_interface_portf_depart_mapping匹配交易账簿取
			      20210619 陈伟峰 1、增加字段【应收利息科目编号、应计利息科目编号、利息调整科目编号、公允价值变动科目编号】
                            2、调整字段【债券编号】的取数口径
            20210623 何桐金 调整【记账机构编号】取数口径
            20210728 陈伟峰 调整【应收利息、应计利息】字段取值口径，‘1y’->‘1Y’
            20210818 陈伟峰 增加字段【自定义债券编号】，调整【债券编号】取值逻辑
            20210830 何桐金 调整PRD_BOND_FAIR_PRICE算法，从全量拉链改为增量拉链
            20211126 陈伟峰 增加字段【交易账簿名称】
            20220518 温旺清	1、调整临时表【T14-资金资产余额】的关联条件；
                            2、调整字段【科目编号、应收利息科目编号、应计利息科目编号、利息调整科目编号、公允价值变动科目编号】的取数口径
            20221220 饶雅   调整字段【ABS标志】加工逻辑，增加L1类型			
            20240117 陈伟峰 增加字段【公允价值变动损益_结转前】	
			20260407 周文龙 修改临时表的创建规则			

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_bond_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_bond_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bond_invest_ex purge;
drop table ${icl_schema}.cmm_cap_bond_invest_ex_02 purge;
drop table ${icl_schema}.tmp_cmm_cap_bond_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_cap_bond_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_cap_bond_invest_03 purge;


create table ${icl_schema}.tmp_cmm_cap_bond_invest_01
nologging
compress ${option_switch} for query high
as
select dept_id,acct_b_id,minor_asset_id,asset_type_name,max(asset_bal_id) as asset_bal_id
from ${iml_schema}.agt_cap_asset_bal
where stl_dt <= to_date('${batch_date}','yyyymmdd')
--and etl_dt = to_date('${batch_date}','yyyymmdd')
and job_cd = 'ctmsf1'
and id_mark <> 'D'
group by dept_id,acct_b_id,asset_type_name,bus_cate_name,main_asset_id,minor_asset_id
;
commit;

create table ${icl_schema}.tmp_cmm_cap_bond_invest_02
nologging
compress ${option_switch} for query high
as
select
   bond_id
   ,min(tran_dt) as min_tran_dt
   ,max(tran_dt) as max_tran_dt
from ${iml_schema}.agt_bond_tran
where tran_dt <= to_date('${batch_date}','yyyymmdd')
and job_cd = 'ctmsf1'
and tran_dir_cd = '01'
and id_mark <> 'D'
group by bond_id
;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_cap_bond_invest_03
nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by t.bond_id order by t.price_dt desc) rn
          from ${iml_schema}.prd_bond_fair_price t
         where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and t.end_dt > to_date('${batch_date}', 'yyyymmdd')
           and t.job_cd = 'ctmsi1'
       )
 where rn = 1
;
commit; 

-- create table cmm_cap_bond_invest_ex
create table ${icl_schema}.cmm_cap_bond_invest_ex nologging
compress
as select * from ${icl_schema}.cmm_cap_bond_invest where 0=1;

-- create table cmm_cap_bond_invest_ex_02
create table ${icl_schema}.cmm_cap_bond_invest_ex_02 nologging
compress
as select * from ${icl_schema}.cmm_cap_bond_invest where 0=1;

-- 2.1 insert data to ex table
whenever sqlerror exit sql.sqlcode;

insert /*+ append */ into ${icl_schema}.cmm_cap_bond_invest_ex(
   etl_dt                                  -- 数据日期
   ,lp_id                                  -- 法人编号
   ,bal_id                                 -- 余额编号
   ,bond_id                                -- 债券编号
   ,custm_bond_id                          -- 自定义债券编号
   ,tran_acct_b_id                         -- 交易账簿编号
   ,tran_acct_b_name                       -- 交易账簿名称
   ,std_prod_id                            -- 标准产品编号
   ,dept_id                                -- 部门编号
   ,entry_org_id                           -- 记账机构编号
   ,acct_attr_cd                           -- 账户属性代码
   ,asset_four_cls_cd                      -- 资产四分类代码
   ,asset_thd_cls_cd					             -- 资产三分类代码
   ,asset_type_name						             -- 资产类型名称
   ,bus_cate_name  						             -- 业务类别名称
   ,subj_id                                -- 科目编号
   ,int_recvbl_subj_id	                   -- 应收利息科目编号
   ,acru_int_subj_id	                     -- 应计利息科目编号
   ,int_adj_subj_id	                       -- 利息调整科目编号
   ,evha_val_chag_subj_id	                 -- 公允价值变动科目编号
   ,stl_dt                                 -- 结算日期
   ,bond_name                              -- 债券名称
   ,issuer_cust_id						             -- 发行人客户编号
   ,issuer_name                            -- 发行人名称
   ,guartor_name                           -- 担保人名称
   ,bond_type_cd                           -- 债券类型代码
   ,init_bond_type_cd                      -- 原债券类型代码
   ,convbl_bond_id						             -- 可转债编号
   ,discnt_debt_flg                        -- 贴现债标志
   ,convbl_bond_flg                        -- 可转债标志
   ,abs_flg                                -- abs标志
   ,strk_bal_flg                           -- 冲账标志
   ,curr_cd                                -- 币种代码
   ,hold_pos                               -- 持有仓位
   ,hold_fac_val                           -- 持有面值
   ,net_price_cost                         -- 净价成本
   ,currt_bal                              -- 当期余额
   ,int_adj_amt                            -- 利息调整金额
   ,evha_val_chag                          -- 公允价值变动
   ,int_cost                               -- 利息成本
   ,full_price_cost                        -- 全价成本
   ,impam_prep                             -- 减值准备
   ,spd_prft                               -- 价差收益
   ,amort_prft                             -- 摊销收益
   ,int_prft                               -- 利息收益
   ,evha_val_chag_pl                       -- 公允价值变动损益
   ,evha_val_chag_pl_carr_bf               -- 公允价值变动损益_结转前
   ,impam_loss                             -- 减值损失
   ,tran_fee                               -- 交易费用
   ,issue_dt                               -- 发行日期
   ,value_dt                               -- 起息日期
   ,exp_dt                                 -- 到期日期
   ,list_tran_dt                           -- 上市交易日期
   ,stop_circlt_dt                         -- 停止流通日期
   ,tenor                                  -- 期限
   ,tenor_type_cd                          -- 期限类型代码
   ,actl_int_rat                           -- 实际利率
   ,fac_val_int_rat                        -- 票面利率
   ,base_rat_id                            -- 基准利率编号
   ,int_rat_float_dir_cd                   -- 利率浮动方向代码
   ,int_rat_float_point                    -- 利率浮动点数
   ,int_accr_base_cd                       -- 计息基准代码
   ,int_rat_adj_way_cd                     -- 利率调整方式代码
   ,int_rat_reset_ped_cd                   -- 利率重置周期代码
   ,fir_int_rat_reset_dt                   -- 首次利率重置日期
   ,int_accr_ped_cd                        -- 计息周期代码
   ,fir_pay_int_dt                         -- 首次付息日期
   ,pay_int_ped_cd                         -- 付息周期代码
   ,td_acru_int                            -- 当日应计利息
   ,open_dt                                -- 开仓日期
   ,recnt_tran_dt                          -- 最近交易日期
   ,acru_int							                 -- 应计利息
   ,int_recvbl							               -- 应收利息
   ,cbond_full_price_evltion			         -- 中债全价估值
   ,cbond_net_price_evltion 			         -- 中债净价估值
   ,estim_coret_duran             	       -- 估价修正久期
   ,bp_val                  			         -- 基点价值
   ,estim_cvty              			         -- 估价凸性
   ,estim_yld_rat           			         -- 估价收益率
   ,book_bal                			         -- 账面余额
   ,job_cd                                 -- 任务代码
   ,etl_timestamp                          -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                -- 数据日期
   ,t1.lp_id                                          -- 法人编号
   ,t1.asset_bal_id                                   -- 余额编号
   ,t1.main_asset_id                                  -- 债券编号
   ,t12.extra_code                                    -- 自定义债券编号
   ,t1.acct_b_id                                      -- 交易账簿编号
   ,t13.keepfolder_name                               -- 交易账簿名称
   ,t1.std_prod_id                                    -- 标准产品编号
   ,t1.dept_id                                        -- 部门编号
  -- ,t13.departmentid                                  -- 记账机构编号
   ,t14.org_id                                        -- 记账机构编号
   ,t4.acct_b_attr_cd                                 -- 账户属性代码
   ,case when t1.asset_type_name = '交易性金融资产' then '1'
         when t1.asset_type_name = '可供出售金融资产' then '2'
         when t1.asset_type_name = '持有至到期投资' then '3'
         when t1.asset_type_name like '%长期股权投资%' then '4'
         when t1.asset_type_name like '%应收款项%' then '5'
          end                                         -- 资产四分类代码
   ,t1.asset_thd_cls_cd 	                            -- 资产三分类代码
	 ,t1.asset_type_name							                  -- 资产类型名称
	 ,t1.bus_cate_name								                  -- 业务类别名称
   ,t1.pric_subj_id                             --科目编号
   ,t1.int_cost_subj_id                         --应收利息科目编号
   ,t1.int_cost_subj_id                         --应计利息科目编号
   ,t1.int_adj_subj_id                          --利息调整科目编号
   ,t1.evha_val_chag_subj_id                    --公允价值变动科目编号
   ,t1.stl_dt                                          -- 结算日期
   ,t3.bond_name                                       -- 债券名称
   ,t11.cust_id										                     -- 发行人客户编号
   ,t3.issuer_name                                     -- 发行人名称
   ,t3.guartor_name                                    -- 担保人名称
   ,t3.bond_type_cd                                    -- 债券类型代码
   ,t3.init_bond_type_cd                               -- 原债券类型代码
   ,t3.convbl_bond_id								                   -- 可转债编号
   ,t3.discnt_debt_flg                                 -- 贴现债标志
   ,t3.tranbl_flg                                      -- 可转债标志
   ,case when t3.bond_type_cd in ('L','L1') then '1' else '0' end  -- ABS标志
   ,t1.strk_bal_flg                                    -- 冲账标志
   ,t3.pric_curr_cd					                           -- 币种代码
   ,coalesce(t1.hold_pos,0)                            -- 持有仓位
   ,coalesce(t1.hold_denom,0)                          -- 持有面值
   ,coalesce(t1.net_price_cost,0)                      -- 净价成本
   ,case when t1.asset_type_name in ('交易性金融资产') then coalesce(t1.net_price_cost,0)
         else coalesce(t1.hold_denom,0)
          end as currt_bal                             -- 当期余额
   ,t1.int_adj                                         -- 利息调整金额
   ,t1.evha_val_chag                                   -- 公允价值变动
   ,t1.int_cost                                        -- 利息成本
   ,t1.full_price_cost                                 -- 全价成本
   ,t1.impam_prep                                      -- 减值准备
   ,t1.spd_prft                                        -- 价差收益
   ,t1.amort_prft                                      -- 摊销收益
   ,t1.int_prft                                        -- 利息收益
   ,t1.evha_val_chag_pl                                -- 公允价值变动损益
   ,t16.evha_val_chag_pl                               -- 公允价值变动损益_结转前
   ,t1.impam_loss                                      -- 减值损失
   ,t1.tran_fee                                        -- 交易费用
   ,t3.issue_dt                                        -- 发行日期
   ,t3.value_dt                                        -- 起息日期
   ,t7.imp_dt                                          -- 到期日期
   ,t3.list_tran_dt                                    -- 上市交易日期
   ,t3.stop_tran_dt                                    -- 停止流通日期
   ,t3.init_tenor                                      -- 期限
   ,t3.init_tenor_type_cd                              -- 期限类型代码
   ,t1.actl_int_rat                                    -- 实际利率
   ,t3.fac_val_int_rat                                 -- 票面利率
   ,t3.base_rat_id                                     -- 基准利率编号
   ,t3.float_dir_cd                                    -- 利率浮动方向代码
   ,t3.int_rat_float_point                             -- 利率浮动点数
   ,t3.int_accr_base_cd                                -- 计息基准代码
   ,t3.int_rat_type_cd                                 -- 利率调整方式代码
   ,t3.int_rat_reset_freq                              -- 利率重置周期代码
   ,t3.fir_int_rat_reset_dt                            -- 首次利率重置日期
   ,t3.int_accr_freq                                   -- 计息周期代码
   ,t3.fir_pay_int_dt                                  -- 首次付息日期
   ,t3.pay_int_freq                                    -- 付息周期代码
   ,t6.today_provi_int                                 -- 当日应计利息
   ,t5.min_tran_dt       							                 -- 开仓日期
   ,t5.max_tran_dt       							                 -- 最近交易日期
   ,case when t3.discnt_debt_flg = '0' and t3.int_rat_type_cd <> '3' and (t3.pay_int_freq <> '1Y' or (t3.pay_int_freq = '1Y' and months_between(t3.exp_dt,t3.value_dt) > 12))
   			 then 0
         else t1.int_cost end							             -- 应计利息
   ,case when t3.discnt_debt_flg = '0' and t3.int_rat_type_cd <> '3' and (t3.pay_int_freq <> '1Y' or (t3.pay_int_freq = '1Y' and months_between(t3.exp_dt,t3.value_dt) > 12))
   			 then t1.int_cost
         else 0 end										                 -- 应收利息
   ,case when nvl(t9.full_price,0) <> 0 then t9.full_price
         when nvl(t15.market_full_price,0) <>0 then t15.market_full_price
         when trim(t12.extra_code) is not null then decode(t1.hold_pos,0,0, (decode(t1.asset_type_name,'交易性金融产',t1.net_price_cost,t1.hold_denom)+t1.int_adj+t1.evha_val_chag)/t1.hold_pos*100)
         else 0 end 									                 -- 中债全价估值
   ,case when nvl(t9.net_price,0) <> 0 then t9.net_price
         when nvl(t15.market_net_price,0) <>0 then t15.market_net_price 
         when trim(t12.extra_code) is not null then decode(t1.hold_pos,0,0, (decode(t1.asset_type_name,'交易性金融资产',t1.net_price_cost,t1.hold_denom)+t1.int_adj+t1.evha_val_chag+t1.int_cost)/t1.hold_pos*100)
         else 0 end  									                 -- 中债净价估值
   ,case when nvl(t9.estim_coret_duran,0) <> 0 then t9.estim_coret_duran
         else nvl(t15.coret_duran,0) 
         end										                       -- 估价修正久期
   ,case when nvl(t9.full_price * t1.hold_pos / 100 * t9.estim_coret_duran / 10000,0) <> 0 then t9.full_price * t1.hold_pos / 100 * t9.estim_coret_duran / 10000
         else nvl(abs(t15.pvbp),0)
         end                                           -- 基点价值
   ,case when nvl(t9.estim_cvty,0) <> 0 then t9.estim_cvty	
         else nvl(t15.cvty,0) 
         end							                             -- 估价凸性
   ,t9.estim_yld_rat    								           -- 估价收益率
   ,(decode(t1.asset_type_name, '交易性金融资产', t1.net_price_cost, t1.hold_denom)
  				+ (case when t3.discnt_debt_flg='0' and t3.int_rat_type_cd <> '3'  and
  				             (t3.pay_int_freq <> '1Y'  or (t3.pay_int_freq = '1Y' and
  				             months_between(t3.exp_dt,t3.value_dt) > 12))
  				        then 0 else t1.int_cost end)
  				+ t1.int_adj + t1.evha_val_chag)	           -- 账面余额
   ,t1.job_cd                                          -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iml_schema}.agt_cap_asset_bal t1
 inner join ${icl_schema}.tmp_cmm_cap_bond_invest_01 t2
    on t1.asset_bal_id = t2.asset_bal_id
  left join ${iml_schema}.prd_bond_basic_info t3
    on t1.minor_asset_id = t3.bond_id
   and t3.job_cd = 'ctmsf1'
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.id_mark <> 'D'
  left join ${iml_schema}.agt_acct_b t4
    on t1.acct_b_id = t4.acct_b_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ctmsf1'
   and t4.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_cap_bond_invest_02 t5
    on t1.minor_asset_id = t5.bond_id
  left join ${iml_schema}.evt_cap_provi t6 --资金计提事件
    on t1.minor_asset_id = t6.main_asset_id
   and t1.acct_b_id = t6.acct_b_id
   and t1.asset_type_name = t6.asset_type_name
   and t1.asset_bal_id=t6.init_asset_bal_id
   and t6.provi_dt = to_date('${batch_date}','yyyymmdd') --计提日期
   and t6.job_cd = 'ctmsi1'
  left join ${iml_schema}.prd_imp_dt_h t7
  	on t3.bond_id = t7.prd_id
   and t7.dt_type_cd = '46'
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   and t7.job_cd = 'ctmsf1'
  left join ${icl_schema}.tmp_cmm_cap_bond_invest_03 t9
  	on t1.main_asset_id = t9.bond_id
  /*left join ${iol_schema}.ctms_tbs_v_cdc_fp t91
  	on t1.main_asset_id = trim(t91.security_code)
   and t91.pricing_date = '${batch_date}'*/
  left join ${iml_schema}.pty_bond_issuer_info t10
  	on t3.issuer_name = t10.cn_name
   and t10.issuer_status_cd='1'
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ctmsf1'
   and t10.id_mark <> 'D'
  left join ${iml_schema}.pty_cap_cntpty_info t11
  	on t10.issuer_id = t11.issuer_id
   and t11.elec_cert_flg ='Y'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'ctmsf1'
   and t11.id_mark <> 'D'
  left join ${iol_schema}.ctms_tbs_security_extra_code t12
    on t1.main_asset_id = trim(t12.security_code)
   and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t13
    on t1.acct_b_id =t13.keepfolder_id
   and t13.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t13.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                    bus_dept_id
--                    row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where job_cd = 'ctmsf1'
            ) t14
    	on 'N'||t1.pric_subj_id = t14.subj_id  -- N：新科目体系
   and nvl(decode(trim(t14.curr_cd),'-',null,t14.curr_cd), 'CNY') = 'CNY'
   and t13.departmentid=t14.bus_dept_id
--   and t14.rn = 1 
left join ${iml_schema}.evt_bond_prft_risk_estim_dtl t15
    on t15.src_bond_id =t1.main_asset_id
   and t15.acct_b_id=t1.acct_b_id
   and t15.bond_cate_cd=t3.bond_type_cd
   and t15.job_cd ='ctmsi1'
   and t15.estim_dt = to_date('${batch_date}','yyyymmdd')
  left join (select dept_id
                   ,acct_b_id
                   ,minor_asset_id
                   ,asset_type_name
                   ,bus_cate_name
                   ,evha_val_chag_pl
                   ,asset_bal_id
                   ,row_number() over(partition by dept_id,acct_b_id,minor_asset_id,asset_type_name,bus_cate_name order by asset_bal_id desc ) as rn
               from ${iml_schema}.agt_cap_asset_bal
              where job_cd = 'ctmsf1'
                and create_dt <= to_date('${batch_date}','yyyymmdd')
                and id_mark <> 'D'
                and stl_dt <= to_date('${batch_date}','yyyymmdd')
                and stl_dt >= to_date('${year_start}','yyyymmdd')   --即每年的1月1号
                and bus_table_name <> 'CARRYOVERDEALS'  --剔除结转数据
               ) t16
    on t1.dept_id = t16.dept_id 
   and t1.acct_b_id = t16.acct_b_id 
   and t1.minor_asset_id = t16.minor_asset_id 
   and t1.asset_type_name = t16.asset_type_name 
   and t1.bus_cate_name = t16.bus_cate_name
   and t16.rn=1
 where t1.stl_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.bus_cate_name in ('现券')
    --and t1.etl_dt = to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'

;
commit;


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_bond_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_bond_invest_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bond_invest_ex purge;
drop table ${icl_schema}.cmm_cap_bond_invest_ex_02 purge;
drop table ${icl_schema}.tmp_cmm_cap_bond_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_cap_bond_invest_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cap_bond_invest',partname => 'p_${batch_date}', degree => 8, cascade => true);
