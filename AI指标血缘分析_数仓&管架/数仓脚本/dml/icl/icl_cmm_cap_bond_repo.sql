/*
Purpose:    共性加工层-资金债券回购:数据来源于本币资金交易系统（CTMS）
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200630 icl_cmm_cap_bond_repo
Createdate: 20191025
Logs:       20200110 翟若平 增加字段[客户编号、记账机构编号]
		        20200624 周沁晖 增加字段【应收利息】
		        20200724 陈伟峰 修改t4表job_cd增加ctmsf2
		        20200724 周沁晖 增加字段【交易清算账户账号、交易清算银行行号】
		        20200828 周沁晖 增加字段【账面余额、到期净价】
		   	    	              调整字段【科目编号】取数逻辑，t8的关联条件
		        20200828 陈伟峰 REF_DC_SUBJ_MAP（本币科目映射）算法变更，去掉etl_dt
            20200925 周沁晖 增加字段【资产三分类代码】
	          20200925 陈伟峰 增加字段【当前余额】
		        20200925 陈伟峰 增加质押式回购、买断式回购、开放式回购主表的过滤条件【tran_status_cd in ('A','M')】
		        20201106 周沁晖 调整逻辑【当前余额】
		        20201111 陈伟峰 调整资产三分类取数逻辑，从agt_cap_asset_bal中直取
		        20201112 陈伟峰 修改记账机构的取值逻辑，从ref_dc_subj_map匹配科目取->从ctms_tbs_interface_portf_depart_mapping匹配交易账簿取
            20210621 陈伟峰 增加字段【应收利息科目编号、利息收入科目编号】
            20210623 何桐金 调整【记账机构编号】取数口径
            20211021 何桐金 新增字段【回购编号】
            20220404 陈伟峰 新增字段【清算类型代码、交易清算银行名称】
            20220409 陈伟峰 新增字段【账簿属性代码】
			20220519 1、调整临时表【T7-本币科目映射】的关联条件；
                     2、调整字段【科目编号、应收利息科目编号、利息收入科目编号】的取数口径
                     3、调整临时表T5的取数逻辑
            20230705 徐子豪 逻辑优化，剔除【清算账户信息表】ID_MARK加工条件。
            20240826 谢  宁 逻辑优化，修改【当前余额】字段。
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_bond_repo drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_bond_repo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bond_repo_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_bond_repo_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_cap_bond_repo where 0=1;

--第1组  --质押式（正回购、逆回购）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_bond_repo_ex(
     etl_dt              --数据日期
    ,lp_id               --法人编号
    ,bus_id              --业务编号
    ,repo_type_cd        --回购类型代码
    ,dept_id             --部门编号
    ,entry_org_id        --记账机构编号
    ,tran_acct_b_id      --交易账簿编号
    ,tran_acct_b_name    --交易账簿名称
    ,acct_b_attr_cd      --账簿属性代码
    ,std_prod_id         --标准产品编号
    ,asset_thd_cls_cd    --资产三分类代码
    ,cust_id             --客户编号
    ,cntpty_id           --交易对手编号
    ,cntpty_name         --交易对手名称
    ,portf_id            --投组编号
    ,portf_name          --投组名称
    ,subj_id             --科目编号
    ,int_recvbl_subj_id  --应收利息科目编号
    ,int_income_subj_id  --利息收入科目编号
    ,tran_dir_cd         --交易方向代码
    ,tran_dt             --交易日期
    ,value_dt            --起息日期
    ,exp_dt              --到期日期
    ,tenor               --期限
    ,tran_amt            --交易金额
    ,exp_stl_amt         --到期结算金额
    ,curr_cd             --币种代码
    ,repo_int_rat        --回购利率
    ,repo_id             --回购编号	
    ,bond_fac_val_comb   --债券面值组合
    ,inpwn_ratio_comb    --质押比例组合
    ,bond_id_comb        --债券编号组合
    ,bond_name_comb      --债券名称组合
    ,acru_int            --应计利息
    ,fst_stl_way_cd      --首期结算方式代码
    ,exp_stl_way_cd      --到期结算方式代码
    ,tran_fee            --交易费用
    ,tran_tax            --交易税金
    ,tran_comm           --交易佣金
    ,dealer_id           --交易员编号
    ,dealer_name         --交易员名称
    ,tran_id             --交易编号
    ,bag_id              --成交编号
    ,int_recvbl          --应收利息
    ,clear_type_cd       --清算类型代码
    ,tran_clear_acct_id  --交易清算账户编号
    ,tran_clear_bank_no	 --交易清算银行行号
    ,tran_clear_bank_name--交易清算银行名称
    ,book_bal	           --账面余额
    ,exp_net_price		   --到期净价
	  ,curr_bal            --当前余额
    ,job_cd              --任务代码
    ,etl_timestamp       --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')    --数据日期
    ,t1.lp_id                              --法人编号
    ,case when t1.tran_dir_cd = '01' then 'RZ_'||t1.bus_id else 'RN_'||t1.bus_id end  --业务编号 01 买入 02 卖出
    --,'01'                                --回购类型代码
    ,'N'                                   --回购类型代码 modify by fuxx 20191108 保持与代码表码值一致 B买断式 N质押式 K开放式
    ,t1.dept_id                            --部门编号
  --  ,t6.departmentid                       --记账机构编号
    ,t7.org_id                             --记账机构编号
    ,t1.acct_b_id                          --交易账簿编号
    ,t1.acct_b_name                        --交易账簿名称
    ,t11.acct_b_attr_cd                    --账簿属性代码
    ,t3.std_prod_id                        --标准产品编号
    ,nvl(t3.asset_thd_cls_cd,'AC')         --资产三分类代码
    ,t2.cust_id                            --客户编号
    ,t1.cntpty_id                          --交易对手编号
    ,t1.cntpty_name                        --交易对手名称
    ,t1.portf_id                           --投组编号
    ,t1.portf_name                         --投组名称
    ,t5.pric_subj_id                       --科目编号
	,t5.int_cost_subj_id                        --应收利息科目编号
    ,t5.int_income_subj_id                       --利息收入科目编号
    ,t1.tran_dir_cd                        --交易方向代码
    ,t1.fst_tran_dt                        --交易日期
    ,t1.fst_dlvy_dt                        --起息日期
    ,t1.exp_dlvy_dt                        --到期日期
    ,t1.repo_days                          --期限
    ,t1.fst_stl_amt                        --交易金额
    ,t1.exp_stl_amt                        --到期结算金额
    ,nvl(t10.pric_curr_cd,'CNY')           --币种代码
    ,t1.repo_int_rat                       --回购利率
    ,t1.repo_id                            --回购编号	
    ,t1.cert_face_tot_comb                 --债券面值组合
    ,t1.inpwn_ratio_comb                   --质押比例组合
    ,t1.bond_id_comb                       --债券编号组合
    ,t1.bond_name_comb                     --债券名称组合
    ,t1.acru_int                           --应计利息
    ,t1.fst_stl_way_cd                     --首期结算方式代码
    ,t1.exp_stl_way_cd                     --到期结算方式代码
    ,t1.fst_fee                            --交易费用
    ,t1.fst_tax                            --交易税金
    ,t1.fst_comm                           --交易佣金
    ,t1.dealer_id                          --交易员编号
    ,t1.dealer_name                        --交易员名称
    ,t1.tran_id                            --交易编号
    ,t1.bag_id                             --成交编号
    ,t3.int_cost                           --应收利息
    ,t1.clear_type_cd                      --清算类型代码
    ,t9.cash_acc_no                        --交易清算账户编号
    ,t9.cash_acc_bank_ex                   --交易清算银行行号
    ,t9.cash_acc_bank                      --交易清算银行名称
    ,(decode(t3.asset_type_name, '交易性金融资产', t3.net_price_cost, t3.hold_denom)+
	   (case when t10.discnt_debt_flg='0' 
			 and t10.int_rat_type_cd <> '3'  
			 and (t10.pay_int_freq <> '1Y'  or (t10.pay_int_freq = '1Y' and months_between(t10.exp_dt, t10.value_dt) > 12)) then 0 else t3.int_cost end)+
		t3.int_adj +t3.evha_val_chag)          --账面余额
    ,0			 						                   --到期净价
	  ,t3.hold_pos - t3.int_adj --t1.fst_stl_amt          --当前余额
    ,t1.job_cd                             --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
  from ${iml_schema}.agt_bond_pledge_type_repo t1 --债券质押式回购
 inner join ${iml_schema}.prd_bond_basic_info t10
 		on regexp_substr(t1.bond_id_comb, '[^,]+', 1) = t10.bond_id
 	 and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ctmsf1'
   and t10.id_mark <> 'D'
  left join ${iml_schema}.pty_cap_cntpty_info t2
    on t1.cntpty_id = t2.cntpty_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ctmsf1'
   and t2.id_mark <> 'D'
 left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t6
    on t1.acct_b_id =t6.keepfolder_id
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >to_date('${batch_date}','yyyymmdd')

/*   left join ${iml_schema}.agt_prod_rela_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd IN ('ctmsf1','ctmsf2') 
   and t4.id_mark <> 'D' */
  left join ${iml_schema}.agt_cap_asset_bal t3
  	on substr(t3.minor_asset_id, 4) = t1.bus_id
   and t3.stl_dt <= to_date('${batch_date}','yyyymmdd')
   --and t3.bus_cate_name = '逆回购'
   and t3.asset_type_name = '质押式回购'
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
 inner join (select dept_id,acct_b_id,minor_asset_id,main_asset_id,asset_type_name,bus_cate_name,max(asset_bal_id) as asset_bal_id,
                    max(pric_subj_id) as pric_subj_id,max(int_cost_subj_id) as int_cost_subj_id,max(int_income_subj_id) as int_income_subj_id
							 from ${iml_schema}.agt_cap_asset_bal
							where stl_dt <= to_date('${batch_date}','yyyymmdd')
							  and job_cd = 'ctmsf1'
							  and id_mark <> 'D'
							group by dept_id,acct_b_id,minor_asset_id, main_asset_id,asset_type_name, bus_cate_name) t5
	  on t3.asset_bal_id = t5.asset_bal_id
	 and t3.dept_id =t5.dept_id
   and t3.acct_b_id = t5.acct_b_id
   and t3.main_asset_id= t5.minor_asset_id
   and t3.asset_type_name = t5.asset_type_name
   and t3.bus_cate_name = t5.bus_cate_name
	left join ${iol_schema}.ctms_wtrade_tr_si t9
		on t1.dept_id = t9.aspclient_id
	 and t1.tran_dir_cd = decode(t9.bs,'B','01','S','02','00')
	 and t1.tran_id = t9.serial_number
	 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
	-- and t9.id_mark <> 'D'
 left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                      bus_dept_id
 --      row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where job_cd = 'ctmsf1'
            ) t7
	on 'N'||t5.pric_subj_id = t7.subj_id  -- N：新科目体系
	and nvl(decode(trim(t7.curr_cd),'-',null,t7.curr_cd), 'CNY') = 'CNY'
	and t6.departmentid = t7.bus_dept_id
--   and t7.rn = 1 	 
  left join ${iml_schema}.agt_acct_b t11
    on t1.acct_b_id = t11.acct_b_id
   and t11.job_cd = 'ctmsf1'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <> 'D'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'
   and ('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925')
;
commit;

--第2组  --买断式（正回购、逆回购）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_bond_repo_ex(
     etl_dt              --数据日期
    ,lp_id               --法人编号
    ,bus_id              --业务编号
    ,repo_type_cd        --回购类型代码
    ,dept_id             --部门编号
    ,entry_org_id        --记账机构编号
    ,tran_acct_b_id      --交易账簿编号
    ,tran_acct_b_name    --交易账簿名称
    ,acct_b_attr_cd      --账簿属性代码
    ,std_prod_id         --标准产品编号
    ,asset_thd_cls_cd    --资产三分类代码
    ,cust_id             --客户编号
    ,cntpty_id           --交易对手编号
    ,cntpty_name         --交易对手名称
    ,portf_id            --投组编号
    ,portf_name          --投组名称
    ,subj_id             --科目编号
    ,int_recvbl_subj_id  --应收利息科目编号
    ,int_income_subj_id  --利息收入科目编号
    ,tran_dir_cd         --交易方向代码
    ,tran_dt             --交易日期
    ,value_dt            --起息日期
    ,exp_dt              --到期日期
    ,tenor               --期限
    ,tran_amt            --交易金额
    ,exp_stl_amt         --到期结算金额
    ,curr_cd             --币种代码
    ,repo_int_rat        --回购利率
    ,repo_id             --回购编号	
    ,bond_fac_val_comb   --债券面值组合
    ,inpwn_ratio_comb    --质押比例组合
    ,bond_id_comb        --债券编号组合
    ,bond_name_comb      --债券名称组合
    ,acru_int            --应计利息
    ,fst_stl_way_cd      --首期结算方式代码
    ,exp_stl_way_cd      --到期结算方式代码
    ,tran_fee            --交易费用
    ,tran_tax            --交易税金
    ,tran_comm           --交易佣金
    ,dealer_id           --交易员编号
    ,dealer_name         --交易员名称
    ,tran_id             --交易编号
    ,bag_id              --成交编号
    ,int_recvbl			     --应收利息
    ,clear_type_cd       --清算类型代码
    ,tran_clear_acct_id  --交易清算账户编号
    ,tran_clear_bank_no	 --交易清算银行行号
    ,tran_clear_bank_name--交易清算银行名称
    ,book_bal			       --账面余额
    ,exp_net_price	  	 --到期净价
	  ,curr_bal            --当前余额
    ,job_cd              --任务代码
    ,etl_timestamp       --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')        --数据日期
    ,t1.lp_id                                  -- 法人编号
    ,case when t1.tran_dir_cd = '01' 
          then 'OZ_'||t1.bus_id 
          else 'ON_'||t1.bus_id 
          end                                  -- 业务编号
    --,'02'                                    -- 回购类型代码
    ,'B'                                       -- 回购类型代码
    ,t1.dept_id                                -- 部门编号
  --  ,t6.departmentid                           -- 记账机构编号
    ,t7.org_id                                 -- 记账机构编号
    ,t1.acct_b_id                              -- 交易账簿编号
    ,t1.acct_b_name                            -- 交易账簿名称
    ,t11.acct_b_attr_cd                        -- 账簿属性代码
    ,t3.std_prod_id                            -- 标准产品编号
    ,nvl(t3.asset_thd_cls_cd,'AC')             -- 资产三分类代码
    ,t2.cust_id                                -- 客户编号
    ,t1.cntpty_id                              -- 交易对手编号
    ,t1.cntpty_name                            -- 交易对手名称
    ,t1.portf_id                               -- 投组编号
    ,t1.portf_name                             -- 投组名称
    ,t5.pric_subj_id                       --科目编号
	,t5.int_cost_subj_id                        --应收利息科目编号
    ,t5.int_income_subj_id                       --利息收入科目编号
    ,t1.tran_dir_cd                            -- 交易方向代码
    ,t1.fst_tran_dt                            -- 交易日期
    ,t1.fst_dlvy_dt                            -- 起息日期
    ,t1.exp_dlvy_dt                            -- 到期日期
    ,t1.repo_days                              -- 期限
    ,t1.fst_stl_amt                            -- 交易金额
    ,t1.exp_stl_amt                            -- 到期结算金额
    ,nvl(t10.pric_curr_cd,'CNY')               -- 币种代码
    ,t1.repo_int_rat                           -- 回购利率
    ,t1.repo_id                                --回购编号	
    ,t1.cert_face_tot                          -- 债券面值
    ,0                                         -- 质押比例
    ,t1.bond_id                                -- 债券编号组合
    ,t1.bond_name                              -- 债券名称组合
    ,t1.acru_int                               -- 应计利息
    ,t1.fst_stl_way_cd                         -- 首期结算方式代码
    ,t1.exp_stl_way_cd                         -- 到期结算方式代码
    ,coalesce(t1.fst_fee,0) + coalesce(t1.exp_fee,0) -- 交易费用
    ,coalesce(t1.fst_tax,0) + coalesce(t1.exp_tax,0) -- 交易税金
    ,coalesce(t1.fst_comm,0) + coalesce(t1.exp_comm,0) -- 交易佣金
    ,t1.dealer_id                              -- 交易员编号
    ,t1.dealer_name                            -- 交易员名称
    ,t1.tran_id                                -- 交易编号
    ,t1.bag_id                                 -- 成交编号
    ,t3.int_cost							                 -- 应收利息
    ,t1.clear_type_cd                          -- 清算类型代码
    ,t9.cash_acc_no        					           -- 交易清算账户编号
    ,t9.cash_acc_bank_ex	 				             -- 交易清算银行行号
    ,t9.cash_acc_bank                          -- 交易清算银行名称
    ,(decode(t3.asset_type_name, '交易性金融资产', t3.net_price_cost, t3.hold_denom)
 				  + (case when t10.discnt_debt_flg='0' and t10.int_rat_type_cd <> '3'  and
            					(t10.pay_int_freq <> '1Y'  or (t10.pay_int_freq = '1Y' and 
               				months_between(t10.exp_dt, t10.value_dt) > 12))
          	 then 0 else t3.int_cost end)
  				+ t3.int_adj + t3.evha_val_chag)		 --账面余额
    ,t1.exp_net_price			 										 --到期净价
	  ,t3.hold_pos - t3.int_adj                               -- 当前余额 
	  /*t1.fst_stl_amt-(decode(t3.asset_type_name, '交易性金融资产', t3.net_price_cost, t3.hold_denom)
 				  + (case when t10.discnt_debt_flg='0' and t10.int_rat_type_cd <> '3'  and
            					(t10.pay_int_freq <> '1Y'  or (t10.pay_int_freq = '1Y' and 
               				months_between(t10.exp_dt, t10.value_dt) > 12))
          	 then 0 else t3.int_cost end)
  				+ t3.int_adj + t3.evha_val_chag)*/                            -- 当前余额
    ,t1.job_cd                                 -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --数据处理时间
  from ${iml_schema}.agt_bond_outrht_repo t1 --债券买断式回购
 inner join ${iml_schema}.prd_bond_basic_info t10
 		on t1.bond_id = t10.bond_id
 	 and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ctmsf1'
   and t10.id_mark <> 'D'
  left join ${iml_schema}.pty_cap_cntpty_info t2
    on t1.cntpty_id = t2.cntpty_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ctmsf1'
   and t2.id_mark <> 'D'
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t6
    on t1.acct_b_id =t6.keepfolder_id
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >to_date('${batch_date}','yyyymmdd')
/*   left join ${iml_schema}.agt_prod_rela_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd IN ('ctmsf1','ctmsf2') 
   and t4.id_mark <> 'D' */
  left join ${iml_schema}.agt_cap_asset_bal t3
  	on substr(t3.minor_asset_id, 4) = t1.bus_id
   and t3.stl_dt <= to_date('${batch_date}','yyyymmdd')
   --and t3.bus_cate_name = '逆回购'
   and t3.asset_type_name = '买断式回购'
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
 inner join (select dept_id,acct_b_id,minor_asset_id,main_asset_id,asset_type_name,bus_cate_name,max(asset_bal_id) as asset_bal_id,
                    max(pric_subj_id) as pric_subj_id,max(int_cost_subj_id) as int_cost_subj_id,max(int_income_subj_id) as int_income_subj_id
							 from ${iml_schema}.agt_cap_asset_bal
							where stl_dt <= to_date('${batch_date}','yyyymmdd')
							  and job_cd = 'ctmsf1'
							  and id_mark <> 'D'
							group by dept_id,acct_b_id,minor_asset_id, main_asset_id,asset_type_name, bus_cate_name) t5
	  on t3.asset_bal_id = t5.asset_bal_id  
	 and t3.dept_id =t5.dept_id
   and t3.acct_b_id = t5.acct_b_id
   and t3.main_asset_id= t5.minor_asset_id
   and t3.asset_type_name = t5.asset_type_name
   and t3.bus_cate_name = t5.bus_cate_name
	left join ${iol_schema}.ctms_wtrade_tr_si t9
		on t1.dept_id = t9.aspclient_id
	 and t1.tran_dir_cd = decode(t9.bs,'B','01','S','02','00')
	 and t1.tran_id = t9.serial_number
	 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
	-- and t9.id_mark <> 'D'
 left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                      bus_dept_id
 --                   row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where  job_cd = 'ctmsf1'
            )t7	
	on 'N'||t5.pric_subj_id = t7.subj_id  -- N：新科目体系
	and nvl(decode(trim(t7.curr_cd),'-',null,t7.curr_cd), 'CNY') = 'CNY'
	and t6.departmentid = t7.bus_dept_id
--   and t7.rn = 1	 
  left join ${iml_schema}.agt_acct_b t11
    on t1.acct_b_id = t11.acct_b_id
   and t11.job_cd = 'ctmsf1'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <> 'D'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'
   and ('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925')
;
commit;


--第3组  --开放式（正回购、逆回购）
--prompt 'aaaaa'
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_bond_repo_ex(
     etl_dt              --数据日期
    ,lp_id               --法人编号
    ,bus_id              --业务编号
    ,repo_type_cd        --回购类型代码
    ,dept_id             --部门编号
    ,entry_org_id        --记账机构编号
    ,tran_acct_b_id      --交易账簿编号
    ,tran_acct_b_name    --交易账簿名称
    ,acct_b_attr_cd      --账簿属性代码
    ,std_prod_id         --标准产品编号
    ,asset_thd_cls_cd    --资产三分类代码
    ,cust_id             --客户编号
    ,cntpty_id           --交易对手编号
    ,cntpty_name         --交易对手名称
    ,portf_id            --投组编号
    ,portf_name          --投组名称
    ,subj_id             --科目编号
    ,int_recvbl_subj_id  --应收利息科目编号
    ,int_income_subj_id  --利息收入科目编号
    ,tran_dir_cd         --交易方向代码
    ,tran_dt             --交易日期
    ,value_dt            --起息日期
    ,exp_dt              --到期日期
    ,tenor               --期限
    ,tran_amt            --交易金额
    ,exp_stl_amt         --到期结算金额
    ,curr_cd             --币种代码
    ,repo_int_rat        --回购利率
    ,repo_id             --回购编号	
    ,bond_fac_val_comb   --债券面值组合
    ,inpwn_ratio_comb    --质押比例组合
    ,bond_id_comb        --债券编号组合
    ,bond_name_comb      --债券名称组合
    ,acru_int            --应计利息
    ,fst_stl_way_cd      --首期结算方式代码
    ,exp_stl_way_cd      --到期结算方式代码
    ,tran_fee            --交易费用
    ,tran_tax            --交易税金
    ,tran_comm           --交易佣金
    ,dealer_id           --交易员编号
    ,dealer_name         --交易员名称
    ,tran_id             --交易编号
    ,bag_id              --成交编号
    ,int_recvbl			     --应收利息
    ,clear_type_cd       --清算类型代码
    ,tran_clear_acct_id  --交易清算账户编号
    ,tran_clear_bank_no	 --交易清算银行行号
    ,tran_clear_bank_name--交易清算银行名称
    ,book_bal			       --账面余额
    ,exp_net_price		   --到期净价
	  ,curr_bal            --当前余额
    ,job_cd              --任务代码
    ,etl_timestamp       --数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')                                                 --数据日期
    ,t1.lp_id                                                                           --法人编号
    ,case when t1.tran_dir_cd = '01' then 'OP_'||t1.bus_id else 'OP_'||t1.bus_id end    --业务编号
    --,'03'                                                                             --回购类型代码
    ,'K'                                                                                --回购类型代码
    ,t1.dept_id                                                                         --部门编号
  --,t6.departmentid                                                                    --记账机构编号
    ,t7.org_id                                                                          --记账机构编号
    ,t1.acct_b_id                                                                       --交易账簿编号
    ,t1.acct_b_name                                                                     --交易账簿名称
    ,t11.acct_b_attr_cd                                                                 --账簿属性代码
    ,t3.std_prod_id                                                                     --标准产品编号
    ,nvl(t3.asset_thd_cls_cd,'AC')                                                      --资产三分类代码
    ,t2.cust_id                                                                         --客户编号
    ,t1.cntpty_id                                                                       --交易对手编号
    ,t1.cntpty_name                                                                     --交易对手名称
    ,t1.portf_id                                                                        --投组编号
    ,t1.portf_name                                                                      --投组名称
    ,t5.pric_subj_id                       --科目编号
	,t5.int_cost_subj_id                        --应收利息科目编号
    ,t5.int_income_subj_id                       --利息收入科目编号
    ,t1.tran_dir_cd                                                                     --交易方向代码
    ,t1.tran_dt                                                                         --交易日期
    ,t1.fst_dlvy_dt                                                                     --起息日期
    ,t1.exp_dlvy_dt                                                                     --到期日期
    ,t1.exp_dlvy_dt - fst_dlvy_dt                                                       --期限
    ,t1.fst_amt                                                                         --交易金额
    ,t1.exp_amt                                                                         --到期结算金额
    ,t1.curr_cd                                                                         --币种代码
    ,0                                                                                  --回购利率
    ,''                                                                                 --回购编号	
    ,t1.cert_face_tot                                                                   --债券面值
    ,0                                                                                  --质押比例
    ,t1.bond_id                                                                         --债券编号组合
    ,t1.bond_name                                                                       --债券名称组合
    ,t1.acru_int                                                                        --应计利息
    ,t1.fst_dlvy_way_cd                                                                 --首期结算方式代码
    ,t1.exp_dlvy_way_cd                                                                 --到期结算方式代码
    ,coalesce(t1.fst_fee,0) + coalesce(t1.exp_fee,0)                                    --交易费用
    ,coalesce(t1.fst_tax,0) + coalesce(t1.exp_tax,0)                                    --交易税金
    ,coalesce(t1.fst_comm,0) + coalesce(t1.exp_comm,0)                                  --交易佣金
    ,t1.dealer_id                                                                       --交易员编号
    ,t1.dealer_name                                                                     --交易员名称
    ,t1.tran_id                                                                         --交易编号
    ,''                                                                                 --成交编号
    ,t3.int_cost					 													                                    --应收利息
    ,'00'                                                                               -- 清算类型代码
    ,t9.cash_acc_no        								 								                              --交易清算账户编号
    ,t9.cash_acc_bank_ex	 								 							                                --交易清算银行行号
    ,t9.cash_acc_bank                                                                   -- 交易清算银行名称
    ,(decode(t3.asset_type_name, '交易性金融资产', t3.net_price_cost, t3.hold_denom)
 		+ (case when t10.discnt_debt_flg='0' and t10.int_rat_type_cd <> '3'  and
            		(t10.pay_int_freq <> '1Y'  or (t10.pay_int_freq = '1Y' and 
               	months_between(t10.exp_dt, t10.value_dt) > 12))
          	then 0 else t3.int_cost end)
  	+ t3.int_adj + t3.evha_val_chag)		 								                                --账面余额
    ,t1.exp_net_price			 														                                  --到期净价
	  ,t3.hold_pos - t3.int_adj --t1.fst_amt                                              --当前余额
    ,t1.job_cd                                                                          --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                    --数据处理时间
  from ${iml_schema}.agt_bond_open_repo t1 --债券开放式回购
 inner join ${iml_schema}.prd_bond_basic_info t10
 		on t1.bond_id = t10.bond_id
 	 and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ctmsf1'
   and t10.id_mark <> 'D'
  left join ${iml_schema}.pty_cap_cntpty_info t2
    on t1.cntpty_id = t2.cntpty_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ctmsf1'
   and t2.id_mark <> 'D'
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t6
    on t1.acct_b_id =t6.keepfolder_id
   and t6.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t6.end_dt >to_date('${batch_date}','yyyymmdd')
/*   left join ${iml_schema}.agt_prod_rela_h t4
    on t1.agt_id = t4.agt_id
   and t1.lp_id = t4.lp_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd IN ('ctmsf1','ctmsf2') 
   and t4.id_mark <> 'D' */
  left join ${iml_schema}.agt_cap_asset_bal t3
  	on substr(t3.minor_asset_id, 4) = t1.bus_id
   and t3.stl_dt <= to_date('${batch_date}','yyyymmdd')
   --and t3.bus_cate_name = '逆回购'
   and t3.asset_type_name = '开放式回购'
   and t3.job_cd = 'ctmsf1'
   and t3.id_mark <> 'D'
 inner join (select dept_id,acct_b_id,minor_asset_id,main_asset_id,asset_type_name,bus_cate_name,max(asset_bal_id) as asset_bal_id,
                    max(pric_subj_id) as pric_subj_id,max(int_cost_subj_id) as int_cost_subj_id,max(int_income_subj_id) as int_income_subj_id
							 from ${iml_schema}.agt_cap_asset_bal
							where stl_dt <= to_date('${batch_date}','yyyymmdd')
							  and job_cd = 'ctmsf1'
							  and id_mark <> 'D'
							group by dept_id,acct_b_id,minor_asset_id, main_asset_id,asset_type_name, bus_cate_name) t5
	  on t3.asset_bal_id = t5.asset_bal_id
	 and t3.dept_id =t5.dept_id
   and t3.acct_b_id = t5.acct_b_id
   and t3.main_asset_id= t5.minor_asset_id
   and t3.asset_type_name = t5.asset_type_name
   and t3.bus_cate_name = t5.bus_cate_name
	left join ${iol_schema}.ctms_wtrade_tr_si t9
		on t1.dept_id = t9.aspclient_id
	 and t1.tran_dir_cd = decode(t9.bs,'B','01','S','02','00')
	 and t1.tran_id = t9.serial_number
	 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
	 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
	-- and t9.id_mark <> 'D'
	left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                      bus_dept_id
 --                   row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where  job_cd = 'ctmsf1'
            ) t7
	on 'N'||t5.pric_subj_id = t7.subj_id  -- N：新科目体系
	and nvl(decode(trim(t7.curr_cd),'-',null,t7.curr_cd), 'CNY') = 'CNY'
	and t6.departmentid = t7.bus_dept_id		
  left join ${iml_schema}.agt_acct_b t11
    on t1.acct_b_id = t11.acct_b_id
   and t11.job_cd = 'ctmsf1'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <> 'D'
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.id_mark <> 'D'
   and (('${batch_date}' > '20200925' and t1.tran_status_cd in ('A','M'))or('${batch_date}' <= '20200925'))
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_bond_repo exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_bond_repo_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_cap_bond_repo_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cap_bond_repo', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);