/*
Purpose:  共性加工层-债券基本信息
Author:   Sunline
Usage:   python $ETL_HOME/script/main.py yyyymmdd icl_cmm_bond_basic_info
CreateDate: 20190808
Logs:		  周沁晖 20200627	1、调整第一组T1表过滤条件
                          2、增加第二组同业系统债券基本信息
                          3、增加字段【债券分类名称、发行人代码、票面面值、期限、资产化类型代码、资产类型编号、计价方式代码、数据来源系统标识】
                          4、主键字段增加【资产类型编号、债券市场类型代码】
          周沁晖 20200828 调整第一组T6表的过滤条件（改为状态表）
					陈伟峰 20200911 调整第一组资金系统债券基本信息中的字段【债券类型代码】的取数口径
					陈伟峰 20210615 增加字段【托管机构编号】
                          调整字段【票面利率】的取数口径，调整第二组（同业）字段【债券类型代码】的取数口径
          陈伟峰 20210619 增加字段【管理模式代码】
          陈伟峰 20210626 增加字段【发行人客户编号】
          陈伟峰 20210706 增加字段【永续债标志】
          何桐金 20210708 调整第二组T5表过滤条件，增加int_rat_flow_id = (select t.cash_accid from ttrd_acc_cash_ext_map t where t.cash_ext_accid = '3080');
          何桐金 20210830 调整PRD_BOND_FAIR_PRICE算法，从全量拉链改为增量拉链
	        陈伟峰 20210831 调整【上次重定价日期-LAST_REVAL_DT】、【下次重定价日期-NEXT_REVAL_DT】取数逻辑
	        陈伟峰 20211111 调整资金系统字段【托管机构编号】的取数口径
	        陈伟峰 20220305 新增字段【发行地区代码、发行主体所属国家地区代码、实际经营地国别代码】
	        陈伟峰 20220407 新增字段【源付息周期代码】
	        陈伟峰 20220907 调整资金部分TBS_VS_CPTYS表关联条件，从T7.ISSUER_ID = T10.KEY_SRC 改为T7.ISSUER_ID = T10.REF_ISSUER_ID
          温旺清 20221230 增加ref_cap_cntpty_cls 关联逻辑，加入 super_cls_id in ('2','11')，拆借仅有这两个分类，其他不是
          温旺清 20230307 新增字段【地方政府债分类代码】
	        陈伟峰 20230727 调整资金部分发行人客户号取数逻辑
	        徐子豪 20231031 新增字段【产品当期总余额、持有档次当期余额、STC标志、优先档次标志】,调整【TBS_VS_CPTYS.ISLINK_SRC是否连接电子证书】限制条件打Y
	        徐子豪 20231124 新增字段【房地产债券类型名称】
	        饶雅   20240221 新增字段【不可撤销担保标志】
			周文龙 20260407 修改临时表的创建规则

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_bond_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_bond_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bond_basic_info_ex purge;

drop table ${icl_schema}.tmp_cmm_bond_basic_info_01 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_02 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_03 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_04 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_041 purge;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bond_basic_info_01
nologging
compress ${option_switch} for query high
as
select
  bond_id
  ,reval_dt
  ,effect_dt
  ,invalid_dt
  ,reval_int_rat
  ,rn
from
(select
  bond_id
  ,reval_dt
  ,effect_dt
  ,invalid_dt
  ,reval_int_rat
  ,row_number() over(partition by bond_id order by to_number(seq_num) desc) as rn
from ${iml_schema}.prd_bond_int_rat_reval_info
where create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and job_cd = 'ctmsf1'
  and reval_dt <=to_date('${batch_date}', 'yyyymmdd')
)
where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_bond_basic_info_02
nologging
compress ${option_switch} for query high
as
select
  bond_id
  ,reval_dt
  ,rn
from
(
select
  bond_id
  ,reval_dt
  ,row_number() over(partition by bond_id order by to_number(seq_num) asc) as rn
from ${iml_schema}.prd_bond_int_rat_reval_info
where create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and job_cd = 'ctmsf1'
  and reval_dt >to_date('${batch_date}', 'yyyymmdd')
)
where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_bond_basic_info_03
nologging
compress ${option_switch} for query high
as
select
  bond_id
  ,pay_dt
  ,rn
from
(
select
  bond_id
  ,pay_dt
  ,row_number() over(partition by bond_id order by to_number(seq_num) desc) as rn
from ${iml_schema}.prd_bond_rpp_int_plan
where create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and job_cd = 'ctmsf1'
  and pay_dt <= to_date('${batch_date}','yyyymmdd')
)
where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_bond_basic_info_04
nologging
compress ${option_switch} for query high
as
select
   bond_id
   ,pay_dt
   ,pric_amt
   ,int_amt
   ,rn
from (
select
   bond_id
   ,pay_dt
   ,pric_amt
   ,int_amt
   ,row_number() over(partition by bond_id order by to_number(seq_num) asc) as rn
from ${iml_schema}.prd_bond_rpp_int_plan
where create_dt <= to_date('${batch_date}', 'yyyymmdd')
  and job_cd = 'ctmsf1'
  and pay_dt > to_date('${batch_date}','yyyymmdd')
)
where rn = 1
;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_bond_basic_info_041
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

create table ${icl_schema}.cmm_bond_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_bond_basic_info where 0=1;


--第一组（共二组）资金债券
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bond_basic_info_ex(
  etl_dt         								-- 数据日期
  ,lp_id         								-- 法人编号
  ,bond_id         							-- 债券编号
  ,asset_type_id		 						-- 资产类型编号
  ,bond_name         						-- 债券名称
  ,bond_abbr         						-- 债券简称
  ,bond_type_cd        					-- 债券类型代码
  ,bond_cls_name			 					-- 债券分类名称
  ,trust_org_id                 -- 托管机构编号
  ,mgmt_mode_cd                 -- 管理模式代码
  ,issuer_cust_id               -- 发行人客户编号
  ,issuer_cd 					 					-- 发行人代码
  ,issuer_name         					-- 发行人名称
  ,issue_main_belong_cty_rg_cd  -- 发行主体所属国家地区代码
  ,issue_rg_cd                  -- 发行地区代码
  ,actl_mang_land_nation_cd     -- 实际经营地国别代码
  ,curr_cd         							-- 币种代码
  ,issue_corp        						-- 发行单位
  ,issue_price         					-- 发行价格
  ,issue_int_rat        				-- 发行利率
  ,issue_size        						-- 发行规模
  ,fac_val_int_rat         			-- 票面利率
  ,fac_val								 			-- 票面面值
  ,int_rat_adj_way_cd        		-- 利率调整方式代码
  ,base_rat_id         					-- 基准利率编号
  ,int_rat_float_point         	-- 利率浮动点数
  ,int_rat_float_dir_cd        	-- 利率浮动方向代码
  ,int_rat_float_uplmi         	-- 利率浮动上限
  ,int_rat_float_lolmi         	-- 利率浮动下限
  ,int_accr_base_cd        			-- 计息基准代码
  ,int_accr_curr_cd        			-- 计息币种代码
  ,int_accr_ped_cd         			-- 计息周期代码
  ,pay_int_ped_cd        				-- 付息周期代码
  ,src_pay_int_ped_cd           -- 源付息周期代码
  ,comp_int_ped_cd        	 		-- 复利周期代码
  ,reval_ped_cd        					-- 重定价周期代码
  ,fir_reval_dt        					-- 首次重定价日期
  ,reval_way_cd        					-- 重定价方式代码
  ,last_reval_dt         				-- 上次重定价日期
  ,next_reval_dt         				-- 下次重定价日期
  ,reval_start_dt        				-- 重定价开始日期
  ,reval_end_dt        					-- 重定价结束日期
  ,reval_int_rat         				-- 重定价利率
  ,exp_yld_rat         					-- 到期收益率
  ,issue_dt        							-- 发行日期
  ,value_dt        							-- 起息日期
  ,exp_dt       	 							-- 到期日期
  ,tenor					 							-- 期限
  ,list_dt         							-- 上市日期
  ,fir_pay_int_dt        				-- 首次付息日期
  ,last_pay_int_dt         			-- 上次付息日期
  ,next_pay_int_dt         			-- 下次付息日期
  ,next_rpp_amt        					-- 下次还本金额
  ,next_pay_int_amt        			-- 下次付息金额
  ,prod_currt_tot_bal           -- 产品当期总余额
  ,hold_level_currt_bal         -- 持有档次当期余额
  ,stop_circlt_dt        				-- 停止流通日期
  ,tranbl_bond_flg         			-- 可转换债券标志
  ,discnt_debt_vch_flg         	-- 贴现债券标志
  ,acru_int_flg        					-- 应计利息标志
  ,subtn_bond_flg               -- 永续债标志
  ,stc_flg                      -- STC标志
  ,prior_level_flg              -- 优先档次标志
  ,irevbl_guar_flg              -- 不可撤销担保标志
  ,ex_choice_type_cd         		-- 行权选择类型代码
  ,bond_market_type_cd         	-- 债券市场类型代码
  ,guar_type_cd        					-- 担保类型代码
  ,guartor_name        					-- 担保人名称
  ,inpwned_ratio         				-- 可质押比例
  ,caption_type_cd       				-- 资产化类型代码
  ,valuation_way_cd      				-- 计价方式代码
  ,loc_gov_cls_cd               -- 地方政府债分类代码
  ,estate_bond_type_name        -- 房地产债券类型名称
  ,data_src_sys_idf      				-- 数据来源系统标识
  ,job_cd
  ,etl_timestamp                -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                        -- 数据日期
  ,t1.lp_id                                                   -- 法人编号
  ,t1.bond_id                          as bond_id             -- 债券编号
  ,nvl(t8.asset_type_id, 'SPT_BD')		 as asset_type_id				-- 资产类型编号
  ,t1.bond_name                        as bond_name           -- 债券名称
  ,t1.bond_abbr                        as bond_abbr           -- 债券简称
  ,t1.bond_type_cd                     as bond_type_cd        -- 债券类型代码
  ,decode(t1.init_bond_type_cd,'1','国债',
  														 '4','企业债',
  														 '5','央行票据',
  														 '6','短期融资券、证券公司短期融资券',
  														 '7','次级债',
  														 '8','政策性银行',
  														 '9','商业银行',
  														 'C','非银行金融债',
  														 'D','国营企业',
  														 'E','公司债',
  														 'F','国际机构、外国主权政府人民币债券、外国地方政府人民币债券',
  														 'G','项目收益债券',
  														 'H','项目收益票据',
  														 'I','分离债',
  														 'J','绿色债务融资工具',
  														 'K','信用联结票据',
  														 'L','资产支持债券、资产支持票据',
  														 'M','地方政府债',
  														 'N','中期票据',
  														 'O','超短期融资券',
  														 'P','集合票据',
  														 'Q','政府支持机构债',
  														 'U','混合资本债',
  														 'W','同业存单',
  														 'X','二级资本工具','')					-- 债券分类名称
  ,nvl(t9.trust_org_cd,(case when t11.circ_market ='0' then '02'
                              when t11.circ_market ='1' then '11'
                              when t11.circ_market ='2' then '12' 	
                              when t11.circ_market ='3' then '04'
                              else '00' end))                    
                                       as trust_org_id        --托管机构编号
  ,'01'                                as mgmt_mode_cd        -- 管理模式代码
  ,t10.cust_id                         as issuer_cust_id      -- 发行人客户编号
	,t7.issuer_id												 as issuer_cd						-- 发行人代码
  ,t1.issuer_name                      as issuer_name         -- 发行人名称
  ,t9.issue_main_belong_cty_rg_cd      as issue_main_belong_cty_rg_cd        -- 发行主体所属国家地区代码
  ,t9.issue_rg_cd                      as issue_rg_cd                        -- 发行地区代码
  ,t9.actl_mang_land_cty_rg_cd         as actl_mang_land_nation_cd           -- 实际经营地国别代码
  ,t1.pric_curr_cd                     as curr_cd             -- 币种代码
  ,t1.issue_corp                       as issue_corp          -- 发行单位
  ,t1.issue_price                      as issue_price         -- 发行价格
  ,t1.issue_int_rat                    as issue_int_rat       -- 发行利率
  ,t1.issue_amt                        as issue_size          -- 发行规模
  ,decode(t1.discnt_debt_flg, '0', t1.fac_val_int_rat, t1.issue_int_rat) as fac_val_int_rat     -- 票面利率
  ,t1.issue_amt												 as fac_val							-- 票面面值
  ,t1.int_rat_type_cd                  as int_rat_adj_way_cd  -- 利率调整方式代码
  ,t1.base_rat_id                      as base_rat_id         -- 基准利率编号
  ,t1.int_rat_float_point              as int_rat_float_point -- 利率浮动点数
  ,t1.float_dir_cd                     as int_rat_float_dir_cd-- 利率浮动方向代码
  ,t1.int_rat_float_uplmi              as int_rat_float_uplmi -- 利率浮动上限
  ,t1.int_rat_float_lolmi              as int_rat_float_lolmi -- 利率浮动下限
  ,t1.int_accr_base_cd                 as int_accr_base_cd    -- 计息基准代码
  ,t1.int_curr_cd                      as int_accr_curr_cd    -- 计息币种代码
  ,t1.int_accr_freq                    as int_accr_ped_cd     -- 计息周期代码
  ,t1.pay_int_freq                     as pay_int_ped_cd      -- 付息周期代码
  ,t1.pay_int_freq                     as src_pay_int_ped_cd  -- 源付息周期代码
  ,t1.comp_int_freq                    as comp_int_ped_cd     -- 复利周期代码
  ,t1.int_rat_reset_freq               as reval_ped_cd        -- 重定价周期代码
  ,t1.fir_int_rat_reset_dt             as fir_reval_dt        -- 首次重定价日期
  ,t1.int_rat_reset_way_cd             as reval_way_cd        -- 重定价方式代码
  ,t2.reval_dt                         as last_reval_dt       -- 上次重定价日期
  ,t3.reval_dt                         as next_reval_dt       -- 下次重定价日期
  ,t2.effect_dt                        as reval_start_dt      -- 重定价开始日期
  ,t2.invalid_dt                       as reval_end_dt        -- 重定价结束日期
  ,t2.reval_int_rat                    as reval_int_rat       -- 重定价利率
  ,t6.exp_yld_rat                      as exp_yld_rat         -- 到期收益率
  ,t1.issue_dt                         as issue_dt            -- 发行日期
  ,t1.value_dt                         as value_dt            -- 起息日期
  ,t1.exp_dt                           as exp_dt              -- 到期日期
  ,nvl(t1.init_tenor, 0) || nvl(trim(t1.init_tenor_type_cd), 'D')-- 期限
  ,t1.list_tran_dt                     as list_dt             -- 上市日期
  ,t1.fir_pay_int_dt                   as fir_pay_int_dt      -- 首次付息日期
  ,t4.pay_dt                           as last_pay_int_dt     -- 上次付息日期
  ,t5.pay_dt                           as next_pay_int_dt     -- 下次付息日期
  ,t5.pric_amt                         as next_rpp_amt        -- 下次还本金额
  ,t5.int_amt                          as next_pay_int_amt    -- 下次付息金额
  ,'0'                                 as prod_currt_tot_bal  -- 产品当期总余额
  ,'0'                                 as hold_level_currt_bal  -- 持有档次当期余额
  ,t1.stop_tran_dt                     as stop_circlt_dt      -- 停止流通日期
  ,t1.tranbl_flg                       as tranbl_bond_flg     -- 可转换债券标志
  ,t1.discnt_debt_flg                  as discnt_debt_vch_flg -- 贴现债券标志
  ,t1.acru_int_flg                     as acru_int_flg        -- 应计利息标志
  ,t9.subtn_bond_flg                   as subtn_bond_flg      -- 永续债标志
  ,t9.stc_flg                          as stc_flg             -- STC标志
  ,t9.prior_level_flg                  as prior_level_flg     -- 优先档次标志
  ,t9.irevbl_guar_flg                  as irevbl_guar_flg     -- 不可撤销担保标志
  ,t1.choice_type_cd                   as ex_choice_type_cd   -- 行权选择类型代码
  ,t1.market_type_cd                   as bond_market_type_cd -- 债券市场类型代码
  ,t1.guara_type_cd                    as guar_type_cd        -- 担保类型代码
  ,t1.guartor_name                     as guartor_name        -- 担保人名称
  ,t1.inpwn_ratio                      as inpwned_ratio       -- 可质押比例
  ,''										               as caption_type_cd			-- 资产化类型代码
  ,'CP'									               as valuation_way_cd		-- 计价方式代码
  ,t9.loc_gov_cls_cd                   as loc_gov_cls_cd      -- 地方政府债分类代码
  ,''                                  as estate_bond_type_name -- 房地产债券类型名称
  ,'CTMS'															 as data_src_sys_idf		-- 数据来源系统标识
  ,t1.job_cd
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.prd_bond_basic_info t1
  left join ${icl_schema}.tmp_cmm_bond_basic_info_01 t2
    on t1.bond_id = t2.bond_id
--   and t2.reval_dt <= to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_bond_basic_info_02 t3
    on t1.bond_id = t3.bond_id
--   and t3.reval_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_bond_basic_info_03 t4
    on t1.bond_id = t4.bond_id
--   and t4.pay_dt <= to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_bond_basic_info_04 t5
    on t1.bond_id = t5.bond_id
--   and t5.pay_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_bond_basic_info_041 t6
    on t1.bond_id = t6.bond_id
  left join ${iml_schema}.pty_bond_issuer_info t7
  	on t1.issuer_name = t7.cn_name
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'ctmsf1'
   and t7.id_mark <> 'D'
  left join ${iml_schema}.prd_ibank_bond t8
  	on t1.bond_id = t8.fin_instm_id
   and t8.market_type_id = 'X_CNBD'
   and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ibmsf1'
   and t8.id_mark <> 'D'
  left join ${iml_schema}.prd_bond_ext_info t9
    on t1.bond_id = t9.bond_id
   and t9.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.job_cd = 'ctmsf1'
   and t9.id_mark <> 'D'
   left join ${iml_schema}.pty_cap_cntpty_info t10
    on t7.issuer_id = t10.issuer_id
   and t10.elec_cert_flg ='Y'
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ctmsf1'
   and t10.id_mark <> 'D'
   left join ${iol_schema}.ctms_tbs_v_security_extra_info t11
    on t1.bond_id = t11.security_code
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t11.end_dt > to_date('${batch_date}','yyyymmdd')
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t1.market_type_cd not in ('01', '02')
  and t1.job_cd = 'ctmsf1'
  and t1.id_mark <> 'D'
;
commit;

--第二组（共二组）同业债券
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_bond_basic_info_ex(
  etl_dt         								-- 数据日期
  ,lp_id         								-- 法人编号
  ,bond_id         							-- 债券编号
  ,asset_type_id		 						-- 资产类型编号
  ,bond_name         						-- 债券名称
  ,bond_abbr         						-- 债券简称
  ,bond_type_cd        					-- 债券类型代码
  ,bond_cls_name			 					-- 债券分类名称
  ,trust_org_id                 -- 托管机构编号
  ,mgmt_mode_cd                 -- 管理模式代码
  ,issuer_cust_id               -- 发行人客户编号
  ,issuer_cd 					 					-- 发行人代码
  ,issuer_name         					-- 发行人名称
  ,issue_main_belong_cty_rg_cd  -- 发行主体所属国家地区代码
  ,issue_rg_cd                  -- 发行地区代码
  ,actl_mang_land_nation_cd     -- 实际经营地国别代码
  ,curr_cd         							-- 币种代码
  ,issue_corp        						-- 发行单位
  ,issue_price         					-- 发行价格
  ,issue_int_rat        				-- 发行利率
  ,issue_size        						-- 发行规模
  ,fac_val_int_rat         			-- 票面利率
  ,fac_val								 			-- 票面面值
  ,int_rat_adj_way_cd        		-- 利率调整方式代码
  ,base_rat_id         					-- 基准利率编号
  ,int_rat_float_point         	-- 利率浮动点数
  ,int_rat_float_dir_cd        	-- 利率浮动方向代码
  ,int_rat_float_uplmi         	-- 利率浮动上限
  ,int_rat_float_lolmi         	-- 利率浮动下限
  ,int_accr_base_cd        			-- 计息基准代码
  ,int_accr_curr_cd        			-- 计息币种代码
  ,int_accr_ped_cd         			-- 计息周期代码
  ,pay_int_ped_cd        				-- 付息周期代码
  ,src_pay_int_ped_cd           -- 源付息周期代码
  ,comp_int_ped_cd        	 		-- 复利周期代码
  ,reval_ped_cd        					-- 重定价周期代码
  ,fir_reval_dt        					-- 首次重定价日期
  ,reval_way_cd        					-- 重定价方式代码
  ,last_reval_dt         				-- 上次重定价日期
  ,next_reval_dt         				-- 下次重定价日期
  ,reval_start_dt        				-- 重定价开始日期
  ,reval_end_dt        					-- 重定价结束日期
  ,reval_int_rat         				-- 重定价利率
  ,exp_yld_rat         					-- 到期收益率
  ,issue_dt        							-- 发行日期
  ,value_dt        							-- 起息日期
  ,exp_dt       	 							-- 到期日期
  ,tenor					 							-- 期限
  ,list_dt         							-- 上市日期
  ,fir_pay_int_dt        				-- 首次付息日期
  ,last_pay_int_dt         			-- 上次付息日期
  ,next_pay_int_dt         			-- 下次付息日期
  ,next_rpp_amt        					-- 下次还本金额
  ,next_pay_int_amt        			-- 下次付息金额
  ,prod_currt_tot_bal           -- 产品当期总余额
  ,hold_level_currt_bal         -- 持有档次当期余额
  ,stop_circlt_dt        				-- 停止流通日期
  ,tranbl_bond_flg         			-- 可转换债券标志
  ,discnt_debt_vch_flg         	-- 贴现债券标志
  ,acru_int_flg        					-- 应计利息标志
  ,subtn_bond_flg               -- 永续债标志
  ,stc_flg                      -- STC标志
  ,prior_level_flg              -- 优先档次标志
  ,irevbl_guar_flg              -- 不可撤销担保标志
  ,ex_choice_type_cd         		-- 行权选择类型代码
  ,bond_market_type_cd         	-- 债券市场类型代码
  ,guar_type_cd        					-- 担保类型代码
  ,guartor_name        					-- 担保人名称
  ,inpwned_ratio         				-- 可质押比例
  ,caption_type_cd       				-- 资产化类型代码
  ,valuation_way_cd      				-- 计价方式代码
  ,loc_gov_cls_cd               -- 地方政府债分类代码
  ,estate_bond_type_name        -- 房地产债券类型名称
  ,data_src_sys_idf      				-- 数据来源系统标识
  ,job_cd
  ,etl_timestamp                -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                        -- 数据日期
  ,t1.lp_id                                                   -- 法人编号
  ,t1.fin_instm_id     											   								-- 债券编号
  ,t1.asset_type_id     																			-- 资产类型编号
  ,t1.bond_fname											   											-- 债券名称
  ,t1.bond_name     											   									-- 债券简称
  ,t4.p_class_ext											                        -- 债券类型代码
  ,t1.prod_cls_name              															-- 债券分类名称
  ,t1.trust_market_id                                         -- 托管机构编号
  ,t1.mgmt_mode_cd                                            -- 管理模式代码
  ,t6.cust_id                                                 -- 发行人客户编号
	,t1.issuer_id            																		-- 发行人代码
  ,t1.issuer_name             											   				-- 发行人名称
  ,''                                                         -- 发行主体所属国家地区代码
  ,''                                                         -- 发行地区代码
  ,''                                                         -- 实际经营地国别代码
  ,t1.curr_cd             											   						-- 币种代码
  ,''              																						-- 发行单位
  ,t1.issue_price        											   							-- 发行价格
  ,t1.init_int_rat       											   							-- 发行利率
  ,t1.actl_issue_size											   									-- 发行规模
  ,decode(t1.coupon_type_cd, '2', t5.actl_int_rat, t1.fac_val_int_rat)  -- 票面利率
  ,t1.bond_fac_val          																	-- 票面面值
  ,t1.int_rat_adj_way_cd        											   			-- 利率调整方式代码
  ,t1.base_rat_id         											   						-- 基准利率编号
  ,t1.fac_val_int_rat             											   		-- 利率浮动点数
  ,''											                                    -- 利率浮动方向代码
  ,t1.init_uplmi_int_rat  											   						-- 利率浮动上限
  ,t1.init_lolmi_int_rat											   							-- 利率浮动下限
  ,t1.int_accr_base_cd  											   							-- 计息基准代码
  ,t1.curr_cd    											   											-- 计息币种代码
  ,t1.int_accr_ped_cd 											   								-- 计息周期代码
  ,t1.pay_int_ped_cd  											   								-- 付息周期代码
  ,t1.src_pay_int_ped_cd  		    					   								-- 付息周期代码
  ,''											                                    -- 复利周期代码
  ,t1.int_rat_adj_ped_cd		                                  -- 重定价周期代码
  ,''											                                    -- 首次重定价日期
  ,''											                                    -- 重定价方式代码
  ,''											                                    -- 上次重定价日期
  ,''											                                    -- 下次重定价日期
  ,''											                                    -- 重定价开始日期
  ,''											                                    -- 重定价结束日期
  ,''											                                    -- 重定价利率
  ,''											                                    -- 到期收益率
  ,t1.issue_dt  											   											-- 发行日期
  ,t1.value_dt  											   											-- 起息日期
  ,t1.exp_dt    											   											-- 到期日期
  ,t1.tenor_cd        																				-- 期限
  ,t1.list_dt   											   											-- 上市日期
  ,t1.fir_pay_int_dt											   									-- 首次付息日期
  ,''											                                    -- 上次付息日期
  ,''											                                    -- 下次付息日期
  ,t2.amount								                                  -- 下次还本金额
  ,''											                                    -- 下次付息金额
  ,t1.prod_currt_tot_bal_bilon                                -- 产品当期总余额
  ,t1.hold_level_currt_bal_bilon                              -- 持有档次当期余额
  ,''											                                    -- 停止流通日期
  ,case when substr(t1.contn_weight_type_cd, 4,1) = '1' then '1' else '0' end	-- 可转换债券标志
  ,decode(t3.issue_mode_cd, '2', '1', '0')										-- 贴现债券标志
  ,'1'											  								 								-- 应计利息标志
  ,''                                                         -- 永续债标志
  ,t1.stc_flg                                                 -- STC标志
  ,t1.prior_level_flg                                         -- 优先档次标志
  ,''                                                         -- 不可撤销担保标志
  ,case when substr(t1.contn_weight_type_cd, 1,1) = '1' then '5'
        when substr(t1.contn_weight_type_cd, 2,1) = '1' then '3'
        when substr(t1.contn_weight_type_cd, 3,1) = '1' then '6'
        when substr(t1.contn_weight_type_cd, 4,1) = '1' then '7'
        else '-' end											   							   	-- 行权选择类型代码
  ,t1.market_type_id											   									-- 债券市场类型代码
  ,''											                                    -- 担保类型代码
  ,t1.guartor_name											   										-- 担保人名称
  ,''											                                    -- 可质押比例
  ,t1.caption_type_cd																					-- 资产化类型代码
  ,''		  									                                  -- 计价方式代码
  ,''                                                                             -- 地方政府债分类代码
  ,t1.estate_bond_name                                        -- 房地产债券类型名称
  ,'IBMS'																											-- 数据来源系统标识
  ,t1.job_cd
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.prd_ibank_bond t1
  left join ${iol_schema}.ibms_ttrd_capital_repay_plan t2
  	on t1.fin_instm_id = t2.i_code
   and t1.asset_type_id = t2.a_type
   and t1.market_type_id = t2.m_type
   and t2.repay_date > to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd')
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iml_schema}.prd_fin_instm t3
  	on t1.fin_instm_id = t3.fin_instm_id
   and t1.asset_type_id = t3.asset_type_id
   and t1.market_type_id = t3.market_type_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
   left join ${iol_schema}.ibms_trpt_tbnd_ext t4
    on t1.fin_instm_id = t4.i_code
   and t1.asset_type_id = t4.a_type
   and t1.market_type_id = t4.m_type
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join
           (select a.fin_instm_id,a.asset_type_id,a.market_type_id,a.actl_int_rat
              from ${iml_schema}.prd_int_accr_dtl a
             left join ${iol_schema}.ibms_ttrd_acc_cash_ext_map t
            	  on a.int_rat_flow_id = t.cash_accid
             where a.start_dt <= to_date('${batch_date}','yyyymmdd')
 	             and a.end_dt > to_date('${batch_date}','yyyymmdd')
 	             and a.job_cd ='ibmsf1'
               and a.int_accr_start_dt <=to_date('${batch_date}','yyyymmdd')
               and a.int_accr_end_dt >to_date('${batch_date}','yyyymmdd')
               and t.cash_ext_accid = '3080'
           ) t5
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.market_type_id
  left join ${iml_schema}.pty_ibank_cntpty_info t6
    on t1.issuer_id = t6.src_party_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
	and t1.market_type_id <> 'X_CNBD'
	and t1.id_mark <> 'D'
  and t1.job_cd = 'ibmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_bond_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_bond_basic_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_bond_basic_info_ex purge;

drop table ${icl_schema}.tmp_cmm_bond_basic_info_01 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_02 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_03 purge;
drop table ${icl_schema}.tmp_cmm_bond_basic_info_04 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_bond_basic_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
