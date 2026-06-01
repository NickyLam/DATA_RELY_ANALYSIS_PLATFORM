/*
Purpose:    共性加工层-外汇资金持仓
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_fx_cap_post
Createdate: 20191025
Logs:       20200110 翟若平 1、增加字段[记账机构编号]
            20200327 翟若平 表T2.的分组条件变更[T2.KEEPFOLDER_ID,T2.MINORASSETCODE] -〉 [T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.T1.BUZTYPE]
			      20200724 陈伟峰 增加字段[标准产品编号]
			      202009   周沁晖 增加字段【资产三分类代码】
			      20210122 周沁晖 增加字段【当期余额】
				  20220519 温旺清 1、调整临时表【T5】的关联条件；
                                  2、调整字段【科目编号】的取数口径
                                  3、新增字段【应收利息科目编号、利息调整科目编号、公允价值变动科目编号、利息收入科目编号、摊销收益科目编号、公允价值变动损益科目编号、价差收益科目编号】	
            20240125 饶雅 新增字段【余额明细编号】		
            20240710 陈伟峰 调整【持有仓位，当期余额】字段加工逻辑
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_fx_cap_post drop partition p_${retain_day};
alter table ${icl_schema}.cmm_fx_cap_post add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temp table
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_fx_cap_post_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_fx_cap_post_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_fx_cap_post where 0=1;

whenever sqlerror exit sql.sqlcode;

insert /*+ append */ into ${icl_schema}.cmm_fx_cap_post_ex(
   etl_dt              -- 数据日期
   ,lp_id              -- 法人编号
   ,bal_id             -- 余额编号
   ,bal_dtl_id         -- 余额明细编号
   ,entry_org_id       -- 记账机构编号
   ,tran_acct_b_id     -- 交易账簿编号
   ,asset_type_name    -- 资产类型名称
   ,bus_cate_name      -- 业务类别名称
   ,asset_thd_cls_cd   -- 资产三分类代码
   ,main_asset_id      -- 主资产编号
   ,minor_asset_id     -- 次资产编号
   ,std_prod_id        -- 标准产品编号
   ,subj_id                   --科目编号
   ,int_recvbl_subj_id           --应收利息科目编号
   ,int_adj_subj_id              --利息调整科目编号
   ,evha_val_chag_subj_id        --公允价值变动科目编号
   ,int_income_subj_id           --利息收入科目编号
   ,amort_prft_subj_id           --摊销收益科目编号
   ,evha_val_chag_pl_subj_id     --公允价值变动损益科目编号
   ,spd_prft_subj_id             --价差收益科目编号
   ,stl_dt             -- 结算日期
   ,hold_pos           -- 持有仓位
   ,hold_fac_val       -- 持有面值
   ,net_price_cost     -- 净价成本
   ,int_adj_amt        -- 利息调整金额
   ,evha_val_chag      -- 公允价值变动
   ,int_cost           -- 利息成本
   ,full_price_cost    -- 全价成本
   ,impam_prep         -- 减值准备
   ,spd_prft           -- 价差收益
   ,amort_prft         -- 摊销收益
   ,int_prft           -- 利息收益
   ,evha_val_chag_pl   -- 公允价值变动损益
   ,impam_loss         -- 减值损失
   ,tran_fee           -- 交易费用
   ,actl_int_rat       -- 实际利率
   ,value_dt           -- 起息日期
   ,exp_dt             -- 到期日期
   ,currt_bal          -- 当期余额
   ,happ_amt           -- 发生金额
   ,job_cd
   ,etl_timestamp      --etl处理时间戳
)
select
   to_date('${batch_date}', 'yyyymmdd')    -- 数据日期
   ,t1.lp_id                   -- 法人编号
   ,t1.asset_bal_id            -- 余额编号
   ,t1.bal_dtl_id              -- 余额明细编号
   ,t5.org_id                  -- 记账机构编号
   ,t1.acct_b_id               -- 交易账簿编号
   ,t1.asset_cate_name         -- 资产类型名称
   ,t1.bus_cate_name           -- 业务类别名称
   ,case when t1.asset_cate_name = '交易性金融资产' then 'FVTPL'
         when t1.asset_cate_name = '可供出售金融资产' then 'FVOCI'
    else 'AC' end              -- 资产三分类代码
   ,t1.main_asset_id           -- 主资产编号
   --,t1.minor_asset_id        -- 次资产编号
   ,t2.minor_asset_id          -- 次资产编号
   ,t1.std_prod_id              --标准产品编号
   ,t1.pric_subj_id               --科目编号
   ,t1.int_cost_subj_id           --应收利息科目编号
   ,t1.int_adj_subj_id            --利息调整科目编号
   ,t1.evha_val_chag_subj_id      --公允价值变动科目编号
   ,t1.int_income_subj_id         --利息收入科目编号
   ,t1.amort_prft_subj_id         --摊销收益科目编号
   ,t1.evha_val_chag_pl_subj_id   --公允价值变动损益科目编号
   ,t1.pric_subj_id            --价差收益科目编号
   ,t1.bus_dt                  -- 结算日期
   --,t1.hold_pos                -- 持有仓位
   ,t1.hold_pos                -- 持有仓位
   ,t1.hold_denom              -- 持有面值
   ,t1.net_price_cost          -- 净价成本
   ,t1.int_adj                 -- 利息调整金额
   ,t1.evha_val_chag           -- 公允价值变动
   ,t1.int_cost                -- 利息成本
   ,t1.full_price_cost         -- 全价成本
   ,t1.impam_prep              -- 减值准备
   ,t1.spd_prft                -- 价差收益
   ,t1.amort_prft              -- 摊销收益
   ,t1.int_prft                -- 利息收益
   ,t1.evha_val_chag_pl        -- 公允价值变动损益
   ,t1.impam_loss              -- 减值损失
   ,t1.tran_fee                -- 交易费用
   ,t1.actl_int_rat            -- 实际利率
   ,t1.value_dt                -- 起息日期
   ,t1.exp_dt                  -- 到期日期
   ,abs(t1.hold_pos)           -- 当期余额
   ,t1.happ_amt                -- 发生金额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_fcurr_cap_asset_bal t1
 inner join (select acct_b_id
                   ,minor_asset_id
                   ,bus_cate_name
                   ,max(asset_bal_id) as asset_bal_id
				   --,pric_subj_id
               from ${iml_schema}.agt_fcurr_cap_asset_bal
              where bus_dt <= to_date('${batch_date}', 'yyyymmdd') --业务日期
                and job_cd = 'ctmsi1'
              group by acct_b_id,minor_asset_id,bus_cate_name
              ) t2
    on t1.asset_bal_id = t2.asset_bal_id
  left join ${iml_schema}.agt_fx_ib_lend t3 --外汇同业拆借
    on t1.main_asset_id = t3.bus_id
   and t3.tran_dt <= to_date('${batch_date}','yyyymmdd') --交易日期
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
   left join (select core_bus_id,
                    curr_cd,
                    core_org_id as org_id,
                    row_number() over(partition by core_bus_id, curr_cd order by core_bus_id, core_org_id ) rn
               from ${iml_schema}.ref_fcurr_subj_map 
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and job_cd = 'ctmsf1'
            ) t5
    on t1.pric_subj_id = t5.core_bus_id
   and substr(t1.asset_cate_name, 1, 3) = t5.curr_cd
   and t5.rn = 1
/* 2022-6-21 19:37:57：临时改用O层表IOL.CTMS_FBS_INTERFACE_ACCOUNT_MAPPING_V2
  left join (select t.accountingcode
                    ,t.core_accountingcode
                    ,t.crncy_code
                    ,t.core_org_id
                    ,row_number() over(partition by t.accountingcode, nvl(t.crncy_code, 'CNY') order by t.core_accountingcode, t.core_org_id) rn
               from ${iol_schema}.ctms_fbs_interface_account_mapping_v2 t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd')) t5
    on 'N'||t1.pric_subj_id = t5.accountingcode
   and substr(t1.asset_cate_name, 1, 3) = t5.crncy_code
   and t5.rn = 1*/
/*  left join (select aa.tran_flow_num, aa.exp_dt
               from ${iml_schema}.evt_fx_ib_lend_provi aa
              inner join (select tran_flow_num, max(provi_dt) as provi_dt
                           from ${iml_schema}.evt_fx_ib_lend_provi
                           where job_cd = 'ctmsi1'
                             and provi_dt <= to_date('${batch_date}', 'yyyymmdd')
                          group by tran_flow_num) bb
                 on aa.tran_flow_num = bb.tran_flow_num
                and aa.provi_dt = bb.provi_dt
              where aa.job_cd = 'ctmsi1'
                and aa.provi_dt <= to_date('${batch_date}', 'yyyymmdd')
                ) t7
    on t1.main_asset_id = t7.tran_flow_num
   and t7.exp_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.evt_fx_ib_lend_provi t7
    on t1.main_asset_id = t7.tran_flow_num
   and t7.provi_dt = to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'ctmsi1'
*/
 where t1.bus_dt <= to_date('${batch_date}', 'yyyymmdd') --业务日期
   and t1.job_cd = 'ctmsi1'
;

commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_fx_cap_post exchange partition p_${batch_date} with table ${icl_schema}.cmm_fx_cap_post_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_fx_cap_post_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_fx_cap_post',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
