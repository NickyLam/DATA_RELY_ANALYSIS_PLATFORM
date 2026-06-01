/*
Purpose:    共性加工层-票据贴现信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20230521 icl_cmm_bill_discnt_info
Createdate: 20191025
Logs:fuxx   新票据2.0创建脚本
            20220627 温旺清 调整字段【科目编号、利息调整科目编号】的加工口径
		        20220826 温旺清 1、调整【票据状态代码】逻辑
                            2、第二组【申请日期】逻辑
            20230104 温旺清 修改第一组主表的过滤条件h_data_flg = 'system' -> h_data_flg <> 'system_ht'.
            20230524 陈伟峰 新增字段【业务细类编号】
            20230719 徐子豪 新增字段【结算日期、清算类型、结算方式】
		        20231121 陈伟峰 调整第二组【票据状态代码】逻辑，从agt_bill_info调整为bdms_draft_status，前者目前生产关联不出数据
		        20240112 陈伟峰 调整字段加工逻辑【利息调整余额】
		        20240617 饶雅 新增字段【业务归属机构编号】
		        20240723 陈伟峰 新增字段【贴现类型代码】
		        20240909 陈伟峰 新增字段【联动利率】
		        20240920 谢  宁 修改第二组当前余额逻辑
		        20240920 陈伟峰 新增字段【利息收入科目编号】
		        20241021 谢  宁 新增字段【付款行行号、付款行行名、收票人账号、收票人名称、收票人开户行号、收票人开户行名称、贴现协议号、贴现利率类型代码、付息方式代码、付息比例】
		        20250124 陈伟峰 调整字段【贴出人名称，贴出人组织机构代码，贴出人开户行行号】逻辑，新增取值
                20250409 陈伟峰 调整主表逻辑，过滤票据编号为空的数据

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bill_discnt_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bill_discnt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop tmp table
drop table ${icl_schema}.cmm_bill_discnt_info_ex purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_bill_discnt_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bill_discnt_info where 0=1;


whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bill_discnt_info_ex(
    etl_dt	                                                           -- 数据日期
   ,lp_id	                                                             -- 法人编号
   ,bus_id	                                                           -- 业务编号
   ,batch_id	                                                         -- 批次编号
   ,discnt_agt_no                                                      -- 贴现协议号
   ,bill_entry_id                                                      -- 票据记账编号
   ,std_prod_id                                                        -- 标准产品编号
   ,bill_id                                                            -- 票据编号
   ,bill_num	                                                         -- 票据号码
   ,bill_sub_intrv_id                                                  -- 子票据区间号码
   ,bus_subclass_id                                                    -- 业务细类编号
   ,subj_id                                                            -- 科目编号
   ,int_adj_subj_id                                                    -- 利息调整科目编号
   ,int_income_subj_id                                                 -- 利息收入科目编号
   ,cust_id	                                                           -- 客户编号
   ,cust_name	                                                         -- 客户名称
   ,bill_med_cd	                                                       -- 票据介质代码
   ,bill_kind_cd	                                                     -- 票据种类代码
   ,buy_prod_cd                                                        -- 买入产品代码
   ,discnt_bus_type_cd	                                               -- 贴现业务类型代码
   ,asset_thd_cls_cd                                                   -- 资产三分类
   ,discnt_type_cd                                                     -- 贴现类型代码
   ,sys_in_flg	                                                       -- 系统内标志
   ,city_wide_flg	                                                     -- 同城标志
   ,int_accr_flg	                                                     -- 计息标志
   ,appl_dt	                                                           -- 申请日期
   ,recv_dt	                                                           -- 签收日期
   ,value_dt	                                                         -- 起息日期
   ,revo_dt	                                                           -- 撤销日期
   ,draw_dt	                                                           -- 出票日期
   ,exp_dt	                                                           -- 到期日期
   ,stl_dt                                                             -- 结算日期
   ,stl_way_cd                                                         -- 结算方式代码
   ,clear_type_cd                                                      -- 清算类型代码
   ,dir_rher_name	                                                     -- 直接前手名称
   ,discnt_applit_acct_num	                                           -- 贴现申请人账号
   ,discnt_applit_bank_no	                                             -- 贴现申请人行号
   ,dscnt_props_cate_cd	                                               -- 贴出人类别代码
   ,dscnt_props_name	                                                 -- 贴出人名称
   ,dscnt_props_orgnz_cd	                                             -- 贴出人组织机构代码
   ,dscnt_props_acct_num	                                             -- 贴出人账号
   ,dscnt_props_open_bank_no	                                         -- 贴出人开户行行号
   ,dscnt_name	                                                       -- 贴入人名称
   ,dscnt_bank_no	                                                     -- 贴入人行号
   ,drawer_name	                                                       -- 出票人名称
   ,drawer_cate_cd	                                                   -- 出票人类别代码
   ,drawer_acct_num	                                                   -- 出票人账号
   ,drawer_open_bank_no	                                               -- 出票人开户行行号
   ,drawer_open_bank_name	                                             -- 出票人开户行名称
   ,accptor_name	                                                     -- 承兑人名称
   ,accptor_acct_num	                                                 -- 承兑人账号
   ,accptor_open_bank_no	                                             -- 承兑人开户行行号
   ,accptor_open_bank_name	                                           -- 承兑人开户行名称
   ,pay_bank_bank_no                                                   -- 付款行行号
   ,pay_bank_bank_name                                                 -- 付款行行名
   ,accept_ps_acct_num                                                 -- 收票人账号
   ,accept_ps_name                                                     -- 收票人名称
   ,accept_ps_open_bank_num                                            -- 收票人开户行号
   ,accept_ps_open_bank_name                                           -- 收票人开户行名称
   ,main_guar_way_cd	                                                 -- 主担保方式代码
   ,agent_discnt_flg	                                                 -- 代理贴现标志
   ,onl_discnt_flg	                                                   -- 在线贴现标志
   ,entry_status_cd	                                                   -- 记账状态代码
   ,entry_dt	                                                         -- 记账日期
   ,int_accr_exp_dt	                                                   -- 计息到期日期
   ,discnt_int_rat	                                                   -- 贴现利率
   ,int_rat_type_cd                                                    -- 贴现利率类型代码
   ,linkg_int_rat	                                                     -- 联动利率
   ,defer_days	                                                       -- 顺延天数
   ,int_accr_days	                                                     -- 计息天数
   ,pay_int_way_cd                                                     -- 付息方式代码
   ,adj_days                                                           -- 调整天数
   ,provi_type_cd                                                      -- 计提类型代码
   ,buy_way_cd                                                         -- 买入方式代码
   ,bill_bus_type_cd                                                   -- 票据业务类型代码
   ,bf_cntpty_type_cd                                                  -- 前交易对手类型代码
   ,bf_cntpty_name                                                     -- 前交易对手名称
   ,bf_cntpty_flg                                                      -- 前交易对手标志
   ,not_ngbl_flg	                                                     -- 不得转让标志
   ,hxb_acpt_flg	                                                     -- 我行承兑标志
   ,flash_discnt_flg                                                   -- 秒贴标志
   ,curr_cd	                                                           -- 币种代码
   ,fac_val_amt	                                                       -- 票面金额
   ,payoff_flg	                                                       -- 结清标志
   ,receipt_flg                                                        -- 小票标志
   ,bill_status_cd                                                     -- 票据状态代码
   ,discnt_status_cd	                                                 -- 贴现状态代码
   ,exp_status_cd                                                      -- 到期状态代码
   ,redcst_flg                                                         -- 再贴现标志
   ,currt_bal                                                          -- 当期余额
   ,int_adj_bal                                                        -- 利息调整余额
   ,td_acru_int                                                        -- 当日应计利息
   ,currt_acru_int                                                     -- 当期应计利息
   ,int_amt	                                                           -- 利息金额
   ,buyer_pay_int_amt	                                                 -- 买方付息金额
   ,pay_int_ratio                                                      -- 付息比例
   ,actl_amt	                                                         -- 实付金额
   ,risk_bear_fee	                                                     -- 风险承担费
   ,issue_org_id	                                                     -- 签发机构编号
   ,enter_acct_org_id	                                                 -- 入账机构编号
   ,bus_belong_org_id                                                  -- 业务归属机构编号
   ,cust_mgr_id	                                                       -- 客户经理编号
   ,dept_id	                                                           -- 部门编号
   ,operr_id	                                                         -- 操作员编号
   ,agent_name	                                                       -- 代理人名称
   ,drawer_crdt_level_cd	                                             -- 出票人信用等级代码
   ,drawer_rating_org_name	                                           -- 出票人评级机构名称
   ,drawer_rating_exp_dt	                                             -- 出票人评级到期日期
   ,rela_party_que_rest_cd                                             -- 关联方查询结果代码
   ,job_cd                                                             -- 任务代码
   ,etl_timestamp                                                      -- etl处理时间戳
)
select
   to_date('${batch_date}', 'yyyymmdd')	                 as etl_dt                   -- 数据日期
   ,t1.lp_id	                                           as lp_id                    -- 法人编号
   ,t1.buy_dtl_id	                                       as bus_id                   -- 业务编号
   ,t1.batch_id	                                         as batch_id                 -- 批次编号
   ,t2.discnt_agt_id                                     as discnt_agt_no            -- 贴现协议号
   ,t1.crdt_out_acct_flow_num                            as bill_entry_id            -- 票据记账编号
   ,t6.prod_id                                           as std_prod_id              -- 标准产品编号
   ,t1.bill_id                                           as bill_id                  -- 票据编号
   ,t3.bill_num	                                         as bill_num                 -- 票据号码
   ,t1.bill_sub_intrv_id                                 as bill_sub_intrv_id        -- 子票据区间号码
   ,t2.bus_type_id                                       as bus_subclass_id          -- 业务细类编号
   ,t10.pric_subj_id                                     as subj_id                  -- 科目编号*
   ,nvl(t10.recvbl_int_paybl_subj_id, t10.recvbl_int_paybl_adj_subj_id) as int_adj_subj_id     -- 利息调整科目编号*
   ,t10.int_bal_pay_subj_id                              as int_income_subj_id       -- 利息收入科目编号
   ,t2.cust_id	                                         as cust_id	                 -- 客户编号
   ,t2.cust_name	                                       as cust_name	               -- 客户名称
   ,t2.bill_med_cd	                                     as bill_med_cd	             -- 票据介质代码
   ,t2.bill_type_cd	                                     as bill_kind_cd	           -- 票据种类代码
   ,t2.buy_prod_cd                                       as buy_prod_cd              -- 买入产品代码
   ,t2.buy_type_cd	                                     as discnt_bus_type_cd       -- 贴现业务类型代码
   ,t2.asset_thd_cls_cd                                  as asset_thd_cls_cd         -- 资产三分类
   ,t2.bus_type_cd                                       as discnt_type_cd           -- 贴现类型代码
   ,nvl(trim(t2.sys_in_flg),'0')	                       as sys_in_flg	             -- 系统内标志
   ,nvl(trim(t1.city_wide_flg),'0')	                     as city_wide_flg	           -- 同城标志
   ,''	                                                 as int_accr_flg	           -- 计息标志
   ,t2.buy_dt	                                           as appl_dt	                 -- 申请日期*
   ,t1.recv_dt	                                         as recv_dt	                 -- 签收日期
   ,${iml_schema}.dateformat_max(t2.buy_dt)	             as value_dt	               -- 起息日期
   ,null                                                 as revo_dt	                 -- 撤销日期*
   ,${iml_schema}.dateformat_min(t3.draw_dt)	           as draw_dt	                 -- 出票日期
   ,${iml_schema}.dateformat_max(t3.fac_val_exp_dt)      as exp_dt	                 -- 到期日期
   ,t2.stl_dt                                            as stl_dt                   -- 结算日期
   ,t2.stl_way_cd                                        as stl_way_cd               -- 结算方式代码
   ,t2.clear_type_cd                                     as clear_type_cd            -- 清算类型代码
   ,t1.rher_name	                                       as dir_rher_name	           -- 直接前手名称
   ,t1.discnt_appl_enter_acct_num	                       as discnt_applit_acct_num	 -- 贴现申请人账号
   ,t1.discnt_appl_enter_acct_bk_no	                     as discnt_applit_bank_no	   -- 贴现申请人行号
   ,t1.dscnt_props_cate_cd	                             as dscnt_props_cate_cd	     -- 贴出人类别代码
   ,t1.dscnt_props_name	                                 as dscnt_props_name	       -- 贴出人名称
   ,t1.dscnt_props_orgnz_cd	                             as dscnt_props_orgnz_cd	   -- 贴出人组织机构代码
   ,t1.dscnt_props_acct_num	                             as dscnt_props_acct_num	   -- 贴出人账号
   ,t2.cust_open_bank_no	                             as dscnt_props_open_bank_no -- 贴出人开户行行号
   ,''	                                                 as dscnt_name	             -- 贴入人名称
   ,''	                                                 as dscnt_bank_no	           -- 贴入人行号
   ,t3.drawer_name	                                     as drawer_name	             -- 出票人名称
   ,nvl(trim(t3.drawer_cate_cd),'-')	                   as drawer_cate_cd	         -- 出票人类别代码
   ,t3.drawer_acct_num	                                 as drawer_acct_num	         -- 出票人账号
   ,t3.drawer_open_bank_num	                             as drawer_open_bank_no	     -- 出票人开户行行号
   ,t3.drawer_open_bank_name	                           as drawer_open_bank_name	   -- 出票人开户行名称
   ,t3.accptor_name	                                     as accptor_name	           -- 承兑人名称
   ,t3.accptor_acct_num	                                 as accptor_acct_num	       -- 承兑人账号
   ,t3.accptor_open_bank_num	                           as accptor_open_bank_no	   -- 承兑人开户行行号
   ,t3.accptor_open_bank_name	                           as accptor_open_bank_name	 -- 承兑人开户行名称
   ,t1.pay_bank_bank_no                                  as pay_bank_bank_no         -- 付款行行号
   ,t1.pay_bank_name                                     as pay_bank_bank_name       -- 付款行行名
   ,t1.accept_ps_acct_id                                 as accept_ps_acct_num       -- 收票人账号
   ,t1.accept_ps_name                                    as accept_ps_name           -- 收票人名称
   ,t1.accept_ps_open_bank_num                           as accept_ps_open_bank_num  -- 收票人开户行号
   ,t1.accept_ps_open_bank_name                          as accept_ps_open_bank_name -- 收票人开户行名称
   ,''                                                   as main_guar_way_cd	       -- 主担保方式代码
   ,''	                                                 as agent_discnt_flg	       -- 代理贴现标志
   ,''	                                                 as onl_discnt_flg	         -- 在线贴现标志
   ,t4.entry_status_cd	                                 as entry_status_cd	         -- 记账状态代码
   ,t1.entry_dt	                                         as entry_dt	               -- 记账日期
   ,t1.int_accr_exp_dt	                                 as int_accr_exp_dt	         -- 计息到期日期
   ,t2.int_rat	                                         as discnt_int_rat	         -- 贴现利率
   ,t2.int_rat_type_cd                                   as int_rat_type_cd          -- 贴现利率类型代码
   ,nvl(t2.link_int_rat,0)                               as link_int_rat             -- 联动利率
   ,t1.defer_days	                                       as defer_days	             -- 顺延天数
   ,t1.int_accr_days	                                   as int_accr_days	           -- 计息天数
   ,t2.pay_int_way_cd                                    as pay_int_way_cd           -- 付息方式代码
   ,case when t2.bill_med_cd = '2'  then (case when t1.city_wide_flg = '0' and t2.int_calc_defer_way_cd = '01' then 3
																				       when t1.city_wide_flg = '0' then 5
																				   else 0 end)
			   when t2.bill_med_cd = '1'  then t1.defer_days
		else (case when t1.city_wide_flg = '0' then (case when t1.defer_days = 0 then 0
          else t1.defer_days - 5 end)
    else t1.defer_days end)	end                          as adj_days                 -- 调整天数*
   ,t5.provi_type_cd                                     as provi_type_cd            -- 计提类型代码
   ,t1.buy_way_cd                                        as buy_way_cd               -- 买入方式代码
   ,t3.role_src_cd                                       as bill_bus_type_cd         -- 票据业务类型代码
   ,case when t3.role_src_cd = '02' and trim(t8.electric_draft_id) is not null then '21' else null end         as bf_cntpty_type_cd-- 前交易对手类型代码
   ,case when t3.role_src_cd = '02' and trim(t8.electric_draft_id) is not null then t8.req_name else null end  as bf_cntpty_name   -- 前交易对手名称
   ,case when t3.role_src_cd = '02' and trim(t8.electric_draft_id) is not null then '1' else '0' end           as bf_cntpty_flg    -- 前交易对手标志
   ,nvl(trim(t1.not_ngbl_flg),'0')	                     as not_ngbl_flg	           -- 不得转让标志
   ,nvl(trim(t3.hxb_acpt_flg),'0')                       as hxb_acpt_flg	           -- 我行承兑标志
   ,nvl(trim(t1.quick_discnt_flg),'0')                   as flash_discnt_flg         -- 秒贴标志
   ,'CNY'	                                               as curr_cd                  -- 币种代码
   ,t3.bill_amt	                                         as fac_val_amt	             -- 票面金额
   ,'0'	                                                 as payoff_flg	             -- 结清标志nvl(trim(t3.payoff_flg),'0')
   ,t3.receipt_flg                                       as receipt_flg              -- 小票标志
   ,t3.bill_status_cd                                    as bill_status_cd           -- 票据状态代码
   ,t4.buy_dtl_status_cd	                               as discnt_status_cd         -- 贴现状态代码
   ,null                                                 as exp_status_cd            -- 到期状态代码
   ,t3.redcst_flg                                        as redcst_flg               -- 再贴现标志
   ,case when ((t5.bill_id is not null and t7.vouch_status_cd <> '42')
                or t7.vouch_status_cd = '00'
                or (t7.vouch_status_cd = '30' and t3.fac_val_exp_dt <= to_date('${batch_date}', 'yyyymmdd')))
         then t3.bill_amt
		     else 0 end                                      as currt_bal                -- 当期余额
   ,nvl(t9.int_adj_bal,0)                                as int_adj_bal              -- 利息调整余额
   ,nvl(t5.td_acru_int, 0)                               as td_acru_int              -- 当日应计利息
   ,nvl(t5.currt_acru_int, 0)                            as currt_acru_int           -- 当期应计利息
   ,t1.int_amt	                                         as int_amt                  -- 利息金额
   ,t1.buyer_pay_int	                                   as buyer_pay_int_amt        -- 买方付息金额
   ,t2.pay_int_ratio           	                         as pay_int_ratio            -- 付息比例
   ,t1.actl_amt	                                         as actl_amt                 -- 实付金额
   ,''	                                                 as risk_bear_fee            -- 风险承担费
   ,t2.org_id	                                           as issue_org_id             -- 签发机构编号
   ,t2.enter_acct_org_id	                               as enter_acct_org_id        -- 入账机构编号
   ,t2.bus_belong_org_id                                 as bus_belong_org_id        -- 业务归属机构编号
   ,case when t40.emply_id is null
         then t2.cust_mgr_id
    else t40.emply_id end                                as cust_mgr_id              -- 客户经理编号
   ,t2.dept_id	                                         as dept_id                  -- 部门编号
   ,t2.operr_id	                                         as operr_id                 -- 操作员编号
   ,t2.agent_name	                                       as agent_name               -- 代理人名称
   ,''	                                                 as drawer_crdt_level_cd     -- 出票人信用等级代码
   ,''	                                                 as drawer_rating_org_name   -- 出票人评级机构名称
   ,null                                                 as drawer_rating_exp_dt     -- 出票人评级到期日期
   ,t2.rela_party_que_rest_cd                            as rela_party_que_rest_cd   -- 关联方查询结果代码
   ,'1'                                                  as job_cd                   -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                  -- etl处理时间戳
  from ${iml_schema}.agt_bill_discnt_dtl t1
  left join ${iml_schema}.agt_bill_discnt_batch t2
    on t1.batch_id = t2.batch_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_bill_info t3
    on t1.bill_id = t3.bill_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'bdmsf1'
   and t3.id_mark <> 'D'
  left join ${iml_schema}.agt_vouch_status_h t7
    on t3.vouch_id = t7.vouch_id
   and t7.vouch_status_type_cd = 'CD1489'
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'bdmsf1'
  left join (select t1.agt_id,t1.agt_status_cd as entry_status_cd,t2.agt_status_cd as buy_dtl_status_cd
               from ${iml_schema}.agt_status_h t1
              inner join ${iml_schema}.agt_status_h t2
                 on t1.agt_id = t2.agt_id
                and t2.agt_status_type_cd = 'CD1270'
                and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t2.job_cd = 'bdmsf1'
              where t1.agt_status_type_cd = 'CD1425'
                and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t1.job_cd = 'bdmsf1'
                 ) t4
    on t1.agt_id = t4.agt_id
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.provi_status_cd      as status_cd        --状态
                   ,ev.int_income_subj_id   as int_adj_subj_id  --借方科目
                   ,ev.td_provi_int         as td_acru_int      --日摊销额
                   ,t1.surp_int             as int_adj_bal      --计提利息余额
                   ,nvl(t1.interest,0) - nvl(t1.surp_int,0) as currt_acru_int--计提利息总额
                   ,t1.interest          as int_amt          --利息总额
             from ${iml_schema}.agt_cpes_provi_h t1
             inner join ${iml_schema}.evt_cpes_provi_dtl ev
                     on t1.provi_mtbl_id = ev.provi_mtbl_id
                    and ev.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                    and ev.job_cd = 'bdmsi1'
                  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                    and t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
                    and t1.provi_bus_type_cd ='01'
                    and t1.job_cd = 'bdmsf1'
            )t5
    on t1.bill_id = t5.bill_id
  left join ${iml_schema}.agt_prod_rela_h t6
    on t1.agt_id = t6.agt_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t10
    on t6.prod_id = t10.sellbl_prod_id
   and t10.bus_type_cd = 'BDMX'
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join (select  a.req_name
                    ,a.id
                    ,a.electric_draft_id
                    ,a.sign_date
                    ,row_number() over(partition by a.electric_draft_id order by a.id desc) as rn
               from ${iol_schema}.bdms_bms_endrsmt_info a
              where a.start_dt <= to_date('${batch_date}','yyyymmdd')
                and a.end_dt > to_date('${batch_date}','yyyymmdd')
                and a.trans_no='E010_02'
             )t8
    on t3.bill_num = t8.electric_draft_id
   and ${iml_schema}.dateformat_max(t8.sign_date) <= t2.buy_dt
   and t8.rn = 1
  left join ${iml_schema}.pty_teller_info_h t40
    on t2.cust_mgr_id = t40.teller_id
	 and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t40.job_cd ='ncbsf1'
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
               and t1.provi_bus_type_cd ='01'
               and t1.provi_status_cd in ('02','03')
               and t1.job_cd = 'bdmsf1') t9
    on t1.bill_id =t9.bill_id
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   and t1.src_table_name = 'bdms_bms_buy_details'
   and t1.h_data_flg <> 'system_ht'
   and trim(t1.bill_id) is not null
;
commit;

insert /*+ append */ into ${icl_schema}.cmm_bill_discnt_info_ex(
   etl_dt	                                                           -- 数据日期
   ,lp_id	                                                             -- 法人编号
   ,bus_id	                                                           -- 业务编号
   ,batch_id	                                                         -- 批次编号
   ,discnt_agt_no                                                      -- 贴现协议号
   ,bill_entry_id                                                      -- 票据记账编号
   ,std_prod_id                                                        -- 标准产品编号
   ,bill_id                                                            -- 票据编号
   ,bill_num	                                                         -- 票据号码
   ,bill_sub_intrv_id                                                  -- 子票据区间号码
   ,bus_subclass_id                                                    -- 业务细类编号
   ,subj_id                                                            -- 科目编号
   ,int_adj_subj_id                                                    -- 利息调整科目编号
   ,int_income_subj_id                                                 -- 利息收入科目编号
   ,cust_id	                                                           -- 客户编号
   ,cust_name	                                                         -- 客户名称
   ,bill_med_cd	                                                       -- 票据介质代码
   ,bill_kind_cd	                                                     -- 票据种类代码
   ,buy_prod_cd                                                        -- 买入产品代码
   ,discnt_bus_type_cd	                                               -- 贴现业务类型代码
   ,asset_thd_cls_cd                                                   -- 资产三分类
   ,discnt_type_cd                                                     -- 贴现类型代码
   ,sys_in_flg	                                                       -- 系统内标志
   ,city_wide_flg	                                                     -- 同城标志
   ,int_accr_flg	                                                     -- 计息标志
   ,appl_dt	                                                           -- 申请日期
   ,recv_dt	                                                           -- 签收日期
   ,value_dt	                                                         -- 起息日期
   ,revo_dt	                                                           -- 撤销日期
   ,draw_dt	                                                           -- 出票日期
   ,exp_dt	                                                           -- 到期日期
   ,stl_dt                                                             -- 结算日期
   ,stl_way_cd                                                         -- 结算方式代码
   ,clear_type_cd                                                      -- 清算类型代码
   ,dir_rher_name	                                                     -- 直接前手名称
   ,discnt_applit_acct_num	                                           -- 贴现申请人账号
   ,discnt_applit_bank_no	                                             -- 贴现申请人行号
   ,dscnt_props_cate_cd	                                               -- 贴出人类别代码
   ,dscnt_props_name	                                                 -- 贴出人名称
   ,dscnt_props_orgnz_cd	                                             -- 贴出人组织机构代码
   ,dscnt_props_acct_num	                                             -- 贴出人账号
   ,dscnt_props_open_bank_no	                                         -- 贴出人开户行行号
   ,dscnt_name	                                                       -- 贴入人名称
   ,dscnt_bank_no	                                                     -- 贴入人行号
   ,drawer_name	                                                       -- 出票人名称
   ,drawer_cate_cd	                                                   -- 出票人类别代码
   ,drawer_acct_num	                                                   -- 出票人账号
   ,drawer_open_bank_no	                                               -- 出票人开户行行号
   ,drawer_open_bank_name	                                             -- 出票人开户行名称
   ,accptor_name	                                                     -- 承兑人名称
   ,accptor_acct_num	                                                 -- 承兑人账号
   ,accptor_open_bank_no	                                             -- 承兑人开户行行号
   ,accptor_open_bank_name	                                           -- 承兑人开户行名称
   ,pay_bank_bank_no                                                   -- 付款行行号
   ,pay_bank_bank_name                                                 -- 付款行行名
   ,accept_ps_acct_num                                                 -- 收票人账号
   ,accept_ps_name                                                     -- 收票人名称
   ,accept_ps_open_bank_num                                            -- 收票人开户行号
   ,accept_ps_open_bank_name                                           -- 收票人开户行名称
   ,main_guar_way_cd	                                                 -- 主担保方式代码
   ,agent_discnt_flg	                                                 -- 代理贴现标志
   ,onl_discnt_flg	                                                   -- 在线贴现标志
   ,entry_status_cd	                                                   -- 记账状态代码
   ,entry_dt	                                                         -- 记账日期
   ,int_accr_exp_dt	                                                   -- 计息到期日期
   ,discnt_int_rat	                                                   -- 贴现利率
   ,int_rat_type_cd                                                    -- 贴现利率类型代码
   ,linkg_int_rat	                                                     -- 联动利率
   ,defer_days	                                                       -- 顺延天数
   ,int_accr_days	                                                     -- 计息天数
   ,pay_int_way_cd                                                     -- 付息方式代码
   ,adj_days                                                           -- 调整天数
   ,provi_type_cd                                                      -- 计提类型代码
   ,buy_way_cd                                                         -- 买入方式代码
   ,bill_bus_type_cd                                                   -- 票据业务类型代码
   ,bf_cntpty_type_cd                                                  -- 前交易对手类型代码
   ,bf_cntpty_name                                                     -- 前交易对手名称
   ,bf_cntpty_flg                                                      -- 前交易对手标志
   ,not_ngbl_flg	                                                     -- 不得转让标志
   ,hxb_acpt_flg	                                                     -- 我行承兑标志
   ,flash_discnt_flg                                                   -- 秒贴标志
   ,curr_cd	                                                           -- 币种代码
   ,fac_val_amt	                                                       -- 票面金额
   ,payoff_flg	                                                       -- 结清标志
   ,receipt_flg                                                        -- 小票标志
   ,bill_status_cd                                                     -- 票据状态代码
   ,discnt_status_cd	                                                 -- 贴现状态代码
   ,exp_status_cd                                                      -- 到期状态代码
   ,redcst_flg                                                         -- 再贴现标志
   ,currt_bal                                                          -- 当期余额
   ,int_adj_bal                                                        -- 利息调整余额
   ,td_acru_int                                                        -- 当日应计利息
   ,currt_acru_int                                                     -- 当期应计利息
   ,int_amt	                                                           -- 利息金额
   ,buyer_pay_int_amt	                                                 -- 买方付息金额
   ,pay_int_ratio                                                      -- 付息比例
   ,actl_amt	                                                         -- 实付金额
   ,risk_bear_fee	                                                     -- 风险承担费
   ,issue_org_id	                                                     -- 签发机构编号
   ,enter_acct_org_id	                                                 -- 入账机构编号
   ,bus_belong_org_id                                                  -- 业务归属机构编号
   ,cust_mgr_id	                                                       -- 客户经理编号
   ,dept_id	                                                           -- 部门编号
   ,operr_id	                                                         -- 操作员编号
   ,agent_name	                                                       -- 代理人名称
   ,drawer_crdt_level_cd	                                             -- 出票人信用等级代码
   ,drawer_rating_org_name	                                           -- 出票人评级机构名称
   ,drawer_rating_exp_dt	                                             -- 出票人评级到期日期
   ,rela_party_que_rest_cd                                             -- 关联方查询结果代码
   ,job_cd                                                             -- 任务代码
   ,etl_timestamp                                                      -- etl处理时间戳
)
select
   to_date('${batch_date}', 'yyyymmdd')	                 as etl_dt                   -- 数据日期
   ,t1.lp_id	                                           as lp_id                    -- 法人编号
   ,t1.buy_dtl_id	                                       as bus_id                   -- 业务编号
   ,t1.batch_id	                                         as batch_id                 -- 批次编号
   ,t2.discnt_agt_id                                     as discnt_agt_no            -- 贴现协议号
   ,t1.crdt_out_acct_flow_num                            as bill_entry_id            -- 票据记账编号
   ,t6.prod_id                                           as std_prod_id              -- 标准产品编号
   ,t1.bill_id                                           as bill_id                  -- 票据编号
   ,t3.bill_num	                                         as bill_num                 -- 票据号码
   ,t1.bill_sub_intrv_id                                 as bill_sub_intrv_id        -- 子票据区间号码
   ,t2.bus_type_id                                       as bus_subclass_id          -- 业务细类编号
   ,t10.pric_subj_id                                     as subj_id                  -- 科目编号*
   ,nvl(t10.recvbl_int_paybl_subj_id, t10.recvbl_int_paybl_adj_subj_id) as int_adj_subj_id -- 利息调整科目编号*
   ,t10.int_bal_pay_subj_id                              as int_income_subj_id       -- 利息收入科目编号
   ,t2.cust_id	                                         as cust_id	                 -- 客户编号
   ,t2.cust_name	                                       as cust_name	               -- 客户名称
   ,t2.bill_med_cd	                                     as bill_med_cd	             -- 票据介质代码
   ,t2.bill_type_cd	                                     as bill_kind_cd	           -- 票据种类代码
   ,t2.buy_prod_cd                                       as buy_prod_cd              -- 买入产品代码
   ,t2.buy_type_cd	                                     as discnt_bus_type_cd       -- 贴现业务类型代码
   ,t2.asset_thd_cls_cd                                  as asset_thd_cls_cd         -- 资产三分类
   ,t2.bus_type_cd                                       as discnt_type_cd           -- 贴现类型代码
   ,nvl(trim(t2.sys_in_flg),'0')	                       as sys_in_flg	             -- 系统内标志
   ,nvl(trim(t1.city_wide_flg),'0')	                     as city_wide_flg	           -- 同城标志
   ,''	                                                 as int_accr_flg	           -- 计息标志
   ,t2.buy_dt                                            as appl_dt	                 -- 申请日期
   ,t1.recv_dt	                                         as recv_dt	                 -- 签收日期
   ,${iml_schema}.dateformat_max(t2.buy_dt)	             as value_dt	               -- 起息日期
   ,null                                                 as revo_dt	                 -- 撤销日期*
   ,${iml_schema}.dateformat_min(t3.draw_dt)	           as draw_dt	                 -- 出票日期
   ,${iml_schema}.dateformat_max(t3.exp_dt)              as exp_dt	                 -- 到期日期
   ,t2.stl_dt                                            as stl_dt                   -- 结算日期
   ,t2.stl_way_cd                                        as stl_way_cd               -- 结算方式代码
   ,t2.clear_type_cd                                     as clear_type_cd            -- 清算类型代码
   ,t1.rher_name	                                       as dir_rher_name	           -- 直接前手名称
   ,t1.discnt_appl_enter_acct_num	                       as discnt_applit_acct_num	 -- 贴现申请人账号
   ,t1.discnt_appl_enter_acct_bk_no	                     as discnt_applit_bank_no	   -- 贴现申请人行号
   ,t1.dscnt_props_cate_cd	                             as dscnt_props_cate_cd	     -- 贴出人类别代码
   ,t2.cust_name	                                     as dscnt_props_name	       -- 贴出人名称
   ,t1.dscnt_props_orgnz_cd	                             as dscnt_props_orgnz_cd	   -- 贴出人组织机构代码
   ,t2.cust_open_acct_num	                             as dscnt_props_acct_num	   -- 贴出人账号
   ,t2.cust_open_bank_no	                             as dscnt_props_open_bank_no -- 贴出人开户行行号
   ,''	                                                 as dscnt_name	             -- 贴入人名称
   ,''	                                                 as dscnt_bank_no	           -- 贴入人行号
   ,t3.drawer_name	                                     as drawer_name	             -- 出票人名称
   ,'RC01'	                                             as drawer_cate_cd	         -- 出票人类别代码
   ,t3.drawer_acct_num	                                 as drawer_acct_num	         -- 出票人账号
   ,t3.drawer_open_bank_no                               as drawer_open_bank_no	     -- 出票人开户行行号
   ,t3.drawer_open_bank_name	                           as drawer_open_bank_name	   -- 出票人开户行名称
   ,t3.accptor_name	                                     as accptor_name	           -- 承兑人名称
   ,t3.accptor_acct_num	                                 as accptor_acct_num	       -- 承兑人账号
   ,t3.accptor_open_bank_no	                             as accptor_open_bank_no	   -- 承兑人开户行行号
   ,t3.accptor_open_bank_name	                           as accptor_open_bank_name	 -- 承兑人开户行名称
   ,t1.pay_bank_bank_no                                  as pay_bank_bank_no         -- 付款行行号
   ,t1.pay_bank_name                                     as pay_bank_bank_name       -- 付款行行名
   ,t1.accept_ps_acct_id                                 as accept_ps_acct_num       -- 收票人账号
   ,t1.accept_ps_name                                    as accept_ps_name           -- 收票人名称
   ,t1.accept_ps_open_bank_num                           as accept_ps_open_bank_num  -- 收票人开户行号
   ,t1.accept_ps_open_bank_name                          as accept_ps_open_bank_name -- 收票人开户行名称
   ,''                                                   as main_guar_way_cd	       -- 主担保方式代码
   ,''	                                                 as agent_discnt_flg	       -- 代理贴现标志
   ,''	                                                 as onl_discnt_flg	         -- 在线贴现标志
   ,t4.entry_status_cd	                                 as entry_status_cd	         -- 记账状态代码
   ,t1.entry_dt	                                         as entry_dt	               -- 记账日期
   ,t1.int_accr_exp_dt	                                 as int_accr_exp_dt	         -- 计息到期日期
   ,t2.int_rat	                                         as discnt_int_rat	         -- 贴现利率
   ,t2.int_rat_type_cd                                   as int_rat_type_cd          -- 贴现利率类型代码
   ,nvl(t2.link_int_rat,0)                               as link_int_rat             -- 联动利率
   ,t1.defer_days	                                       as defer_days	             -- 顺延天数
   ,t1.int_accr_days	                                   as int_accr_days	           -- 计息天数
   ,t2.pay_int_way_cd                                    as pay_int_way_cd           -- 付息方式代码
   ,case when t2.bill_med_cd = '2'  then (case when t1.city_wide_flg = '0' and t2.int_calc_defer_way_cd = '01' then 3
																				       when t1.city_wide_flg = '0' then 5
																				   else 0 end)
			   when t2.bill_med_cd = '1'  then t1.defer_days
		else (case when t1.city_wide_flg = '0' then (case when t1.defer_days = 0 then 0
          else t1.defer_days - 5 end)
    else t1.defer_days end)	end                          as adj_days                 -- 调整天数*
   ,t5.provi_type_cd                                     as provi_type_cd            -- 计提类型代码
   ,t1.buy_way_cd                                        as buy_way_cd               -- 买入方式代码
   ,t3.bill_src_cd                                       as bill_bus_type_cd         -- 票据业务类型代码
   ,case when t3.bill_src_cd = '02' and trim(t8.electric_draft_id) is not null then '21' else null end         as bf_cntpty_type_cd-- 前交易对手类型代码
   ,case when t3.bill_src_cd = '02' and trim(t8.electric_draft_id) is not null then t8.req_name else null end  as bf_cntpty_name   -- 前交易对手名称
   ,case when t3.bill_src_cd = '02' and trim(t8.electric_draft_id) is not null then '1' else '0' end           as bf_cntpty_flg    -- 前交易对手标志
   ,nvl(trim(t1.not_ngbl_flg),'0')	                     as not_ngbl_flg	           -- 不得转让标志
   ,nvl(trim(t3.hxb_acpt_flg),'0')                       as hxb_acpt_flg	           -- 我行承兑标志
   ,nvl(trim(t1.quick_discnt_flg),'0')                   as flash_discnt_flg         -- 秒贴标志
   ,'CNY'	                                               as curr_cd                  -- 币种代码
   ,t3.bill_amt	                                         as fac_val_amt	             -- 票面金额
   ,nvl(trim(t3.payoff_flg),'0')	                       as payoff_flg	             -- 结清标志nvl(trim(t3.payoff_flg),'0')
   ,t3.receipt_flg                                       as receipt_flg              -- 小票标志t3.receipt_flg
   ,p1.status                                            as bill_status_cd           -- 票据状态代码
   ,t4.buy_dtl_status_cd	                               as discnt_status_cd         -- 贴现状态代码
   ,null                                                 as exp_status_cd            -- 到期状态代码
   ,null                                                 as redcst_flg               -- 再贴现标志
   ,case when ((t5.bill_id is not null and p1.status  <> '42')
                or (p1.status  = '00' and t4.entry_status_cd = '03')
                or (p1.status  = '30' and t3.exp_dt <= to_date('${batch_date}', 'yyyymmdd')))
         then t3.bill_amt
		     else 0 end                                      as currt_bal                -- 当期余额
   ,nvl(t9.int_adj_bal,0)                                as int_adj_bal              -- 利息调整余额
   ,nvl(t5.td_acru_int, 0)                               as td_acru_int              -- 当日应计利息
   ,nvl(t5.currt_acru_int, 0)                            as currt_acru_int           -- 当期应计利息
   ,t1.int_amt	                                         as int_amt                  -- 利息金额
   ,t1.buyer_pay_int	                                   as buyer_pay_int_amt        -- 买方付息金额
   ,t2.pay_int_ratio           	                         as pay_int_ratio            -- 付息比例
   ,t1.actl_amt	                                         as actl_amt                 -- 实付金额
   ,''	                                                 as risk_bear_fee            -- 风险承担费
   ,t2.org_id	                                           as issue_org_id             -- 签发机构编号
   ,t2.enter_acct_org_id	                               as enter_acct_org_id        -- 入账机构编号
   ,t2.bus_belong_org_id	                               as enter_acct_org_id        -- 业务归属机构编号
   ,case when t40.emply_id is null
         then t2.cust_mgr_id
    else t40.emply_id end                                as cust_mgr_id              -- 客户经理编号
   ,t2.dept_id	                                         as dept_id                  -- 部门编号
   ,t2.operr_id	                                         as operr_id                 -- 操作员编号
   ,t2.agent_name	                                       as agent_name               -- 代理人名称
   ,''	                                                 as drawer_crdt_level_cd     -- 出票人信用等级代码
   ,''	                                                 as drawer_rating_org_name   -- 出票人评级机构名称
   ,null                                                 as drawer_rating_exp_dt     -- 出票人评级到期日期
   ,t2.rela_party_que_rest_cd                            as rela_party_que_rest_cd   -- 关联方查询结果代码
   ,'2'                                                  as job_cd                   -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                  -- etl处理时间戳
  from ${iml_schema}.agt_bill_discnt_dtl t1
  left join ${iml_schema}.agt_bill_discnt_batch t2
    on t1.batch_id = t2.batch_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'bdmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.ref_rgst_cter_bill_info_para t3
    on t1.bill_id = t3.rgst_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'bdmsf1'
  left join ${iol_schema}.bdms_draft_status p1
    on t3.rgst_id = p1.id
   and p1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and p1.end_dt   >  to_date('${batch_date}','yyyymmdd')
 /* left join ${iml_schema}.agt_vouch_status_h t7
    on t3.vouch_id = t7.vouch_id
   and t7.vouch_status_type_cd = 'CD1489'
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'bdmsf1'*/
  left join (select t1.agt_id,t1.agt_status_cd as entry_status_cd,t2.agt_status_cd as buy_dtl_status_cd
               from ${iml_schema}.agt_status_h t1
              inner join ${iml_schema}.agt_status_h t2
                 on t1.agt_id = t2.agt_id
                and t2.agt_status_type_cd = 'CD1270'
                and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t2.job_cd = 'bdmsf1'
              where t1.agt_status_type_cd = 'CD1425'
                and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t1.job_cd = 'bdmsf1'
                 ) t4
    on t1.agt_id = t4.agt_id
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.provi_status_cd      as status_cd        --状态
                   ,ev.int_income_subj_id   as int_adj_subj_id  --借方科目
                   ,ev.td_provi_int         as td_acru_int      --日摊销额
                   ,t1.surp_int             as int_adj_bal      --计提利息余额
                   ,nvl(t1.interest,0) - nvl(t1.surp_int,0) as currt_acru_int--计提利息总额
                   ,t1.interest          as int_amt          --利息总额
               from ${iml_schema}.agt_cpes_provi_h t1
              inner join ${iml_schema}.evt_cpes_provi_dtl ev
                 on t1.provi_mtbl_id = ev.provi_mtbl_id
                and ev.etl_dt = to_date('${batch_date}', 'yyyymmdd')
                and ev.job_cd = 'bdmsi1'
              where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and t1.provi_dt = to_date('${batch_date}', 'yyyymmdd')
                and t1.provi_bus_type_cd ='01'
                and t1.job_cd = 'bdmsf1'
              )t5
    on t1.bill_id = t5.bill_id
  left join ${iml_schema}.agt_prod_rela_h t6
    on t1.agt_id = t6.agt_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   and t6.job_cd = 'bdmsf1'
  left join ${icl_schema}.cmm_prod_and_subj_map_rela t10
    on t6.prod_id = t10.sellbl_prod_id
   and t10.bus_type_cd = 'BDMX'
   and t10.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  left join (select  a.req_name
                    ,a.id
                    ,a.electric_draft_id
                    ,a.sign_date
                    ,row_number() over(partition by a.electric_draft_id order by a.id desc) as rn
               from ${iol_schema}.bdms_bms_endrsmt_info a
              where a.start_dt <= to_date('${batch_date}','yyyymmdd')
                and a.end_dt > to_date('${batch_date}','yyyymmdd')
                and a.endrsmt_type = '03'
             )t8
    on t3.bill_num = t8.electric_draft_id
   and ${iml_schema}.dateformat_max(t8.sign_date) <= t2.buy_dt
   and t8.rn = 1
  left join ${iml_schema}.pty_teller_info_h t40
    on t2.cust_mgr_id = t40.teller_id
   and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t40.job_cd ='ncbsf1'
  left join ${iml_schema}.agt_bill_info t31
    on t1.bill_id = t31.bill_id
   and t31.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t31.job_cd = 'bdmsf1'
   and t31.id_mark <> 'D'
  left join (select t1.bill_id              as bill_id          --票据id
                   ,t1.provi_bus_type_cd    as provi_type_cd    --计提业务类型代码
                   ,t1.dtl_id               as detail_id
                   ,t1.batch_id             as contract_id
                   ,ev.td_provi_int         as td_acru_int      --当日应计利息
                   ,t1.surp_int             as int_adj_bal      --利息调整余额
                   ,t1.provied_int          as currt_acru_int   --当期应计利息
              from ${iml_schema}.agt_cpes_provi_h t1
              left join ${iml_schema}.evt_cpes_provi_dtl ev
                on t1.provi_mtbl_id = ev.provi_mtbl_id
               and ev.etl_dt = to_date('${batch_date}', 'yyyymmdd')
               and ev.job_cd = 'bdmsi1'
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and t1.provi_bus_type_cd ='01'
               and t1.provi_status_cd in ('02','03')
               and t1.job_cd = 'bdmsf1') t9
    on t1.bill_id =t9.bill_id
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'bdmsf1'
   and t1.id_mark <> 'D'
   and t1.src_table_name = 'bdms_cpes_buy_details'
   and trim(t1.bill_id) is not null
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_bill_discnt_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bill_discnt_info_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_bill_discnt_info_ex purge;


-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_bill_discnt_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);

