/*
Purpose:    共性加工层-资金业务持仓
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_cap_bus_post
CreateDate: 20191025
Logs:       20200110 翟若平 增加字段[记账机构编号]
            20200320 翟若平 表T2.的分组条件变更[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE] -〉 [T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.ASSETTYPE, T2.BUZTYPE]
            20200627 周沁晖 表T2.的分组条件变更[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.ASSETTYPE, T2.BUZTYPE] -〉[T2.ASPCLIENT_ID,T2.KEEPFOLDER_ID,T2.MINORASSETCODE,T2.MAJORASSETCODE,T2.ASSETTYPE, T2.BUZTYPE]
			      20200724 陈伟峰 增加标准产品编号字段取值
			      20200828 周沁晖 增加字段[资产三分类代码、资产类型名称]、调整字段【科目编号】取数逻辑
			      20200828 陈伟峰 REF_DC_SUBJ_MAP（本币科目映射）算法变更，去掉etl_dt
			      20200911 陈伟峰 增加字段[当前余额],调整T1表，增加条件(t1.main_asset_id = t1.minor_asset_id or t1.asset_type_name = '债券借贷')
				    20201111 陈伟峰 调整资产三分类取数逻辑，从agt_cap_asset_bal中直取
			      20201112 陈伟峰 修改记账机构的取值逻辑，从ref_dc_subj_map匹配科目取->从ctms_tbs_interface_portf_depart_mapping匹配交易账簿取
				    20201203 陈伟峰 调整债券编号取数逻辑，从prd_bond_basic_info表取（原本通过业务类型代码判断）
				    20210623 何桐金 调整【记账机构编号】取数口径
				    20211108 陈伟峰 新增字段【主资产编号】
				    20211129 陈伟峰 调整科目加工逻辑，加入（'Y','44010101')
					20220518 翟若平	1、调整临时表【T8-接口科目映射表】的关联条件；
                                    2、调整字段【科目编号】的取数口径
                                    3、新增字段【应收利息科目编号、利息调整科目编号、公允价值变动科目编号、利息收入科目编号、摊销收益科目编号、公允价值变动损益科目编号、价差收益科目编号、手续费收入、手续费支出】							
				    20221209 陈伟峰 调整【记账机构编号】取数口径
				    20230628 徐子豪 新增字段【账簿属性代码】
            20240117 陈伟峰 增加字段【公允价值变动损益_结转前】
            20240125 饶雅   增加字段【挂账科目编号】【挂账利息】【余额明细编号】	
            20240419 饶雅   新增字段【业务表名称】
            20240923 陈伟峰 调整【价差收益科目编号】取数逻辑，原取成了本金科目，现修正
			
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_cap_bus_post drop partition p_${retain_day};
alter table ${icl_schema}.cmm_cap_bus_post add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bus_post_ex purge;
drop table ${icl_schema}.tmp_cmm_cap_bus_post_01 purge;

whenever sqlerror exit sql.sqlcode;

create table ${icl_schema}.cmm_cap_bus_post_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_cap_bus_post where 0=1;
	 
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_cap_bus_post_ex(
   etl_dt                -- 数据日期
   ,lp_id                -- 法人编号
   ,bal_id               -- 余额编号
   ,bal_dtl_id           -- 余额明细编号
   ,asset_type_cd        -- 资产类型代码
   ,asset_id             -- 资产编号
   ,main_asset_id        -- 主资产编号
   ,tran_acct_b_id       -- 交易账簿编号
   ,acct_b_attr_cd       -- 账簿属性代码
   ,std_prod_id          -- 标准产品编号
   ,dept_id              -- 部门编号
   ,entry_org_id         -- 记账机构编号
   ,bus_table_name       -- 业务表名称
   ,bus_id               -- 业务编号
   ,subj_id              -- 科目编号
   ,int_recvbl_subj_id           --应收利息科目编号
   ,int_adj_subj_id              --利息调整科目编号
   ,evha_val_chag_subj_id        --公允价值变动科目编号
   ,int_income_subj_id           --利息收入科目编号
   ,amort_prft_subj_id           --摊销收益科目编号
   ,evha_val_chag_pl_subj_id     --公允价值变动损益科目编号
   ,spd_prft_subj_id             --价差收益科目编号
   ,on_acct_subj_id              -- 挂账科目编号
   ,stl_dt               -- 结算日期
   ,asset_type_name		   -- 资产类型名称
   ,bus_cate_name        -- 业务类别名称
   ,asset_thd_cls_cd	   -- 资产三分类代码
   ,strk_bal_flg         -- 冲账标志
   ,bond_id              -- 债券编号
   ,curr_cd              -- 币种代码
   ,hold_pos             -- 持有仓位
   ,hold_fac_val         -- 持有面值
   ,net_price_cost       -- 净价成本
   ,int_adj_amt          -- 利息调整金额
   ,evha_val_chag        -- 公允价值变动
   ,int_cost             -- 利息成本
   ,full_price_cost      -- 全价成本
   ,on_acct_int          -- 挂账利息
   ,impam_prep           -- 减值准备
   ,spd_prft             -- 价差收益
   ,amort_prft           -- 摊销收益
   ,int_prft             -- 利息收益
   ,evha_val_chag_pl     -- 公允价值变动损益
   ,evha_val_chag_pl_carr_bf    -- 公允价值变动损益_结转前
   ,impam_loss           -- 减值损失
   ,tran_fee             -- 交易费用
   ,comm_fee_inco        -- 手续费收入
   ,comm_fee_expns       -- 手续费支出
   ,actl_int_rat         -- 实际利率
   ,value_dt             -- 起息日期
   ,exp_dt               -- 到期日期
   ,happ_amt             -- 发生金额
   ,curr_bal             -- 当前余额
   ,job_cd
   ,etl_timestamp        -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')        -- 数据日期
   ,t1.lp_id                                  -- 法人编号
   ,t1.asset_bal_id                           -- 余额编号
   ,t1.bal_dtl_id                             -- 余额明细编号
   ,t3.asset_type_cd                          -- 资产类型代码
   ,t1.main_asset_id||'.'||t1.minor_asset_id as asset_id  -- 资产编号
   ,t1.main_asset_id                          -- 主资产编号
   ,t1.acct_b_id                              -- 交易账簿编号
   ,t11.acct_b_attr_cd                        -- 账簿属性代码
   ,t1.std_prod_id                            -- 标准产品编号
   ,t1.dept_id                                -- 部门编号
   ,t7.org_id                                 -- 记账机构编号
   ,t1.bus_table_name                         -- 业务表名称
   ,t2.minor_asset_id                         -- 业务编号
   ,t1.pric_subj_id             		          -- 科目编号  
   ,t1.int_cost_subj_id                       -- 应收利息科目编号
   ,t1.int_adj_subj_id                        -- 利息调整科目编号
   ,t1.evha_val_chag_subj_id                  -- 公允价值变动科目编号
   ,t1.int_income_subj_id                     -- 利息收入科目编号
   ,t1.amort_prft_subj_id                     -- 摊销收益科目编号
   ,t1.evha_val_chag_pl_subj_id               -- 公允价值变动损益科目编号
   ,t1.spd_prft_subj_id                       -- 价差收益科目编号
   ,t1.on_acct_subj_id                        -- 挂账科目编号
   ,t1.stl_dt                                 -- 结算日期
   ,t1.asset_type_name			                  -- 资产类型名称
   ,t1.bus_cate_name                          -- 业务类别名称
   ,nvl(t1.asset_thd_cls_cd,'AC')             -- 资产三分类代码
   ,t1.strk_bal_flg                           -- 冲账标志  
   ,t10.bond_id                               -- 债券编号 
   ,nvl(t10.pric_curr_cd,'CNY')               -- 币种代码  
   ,t1.hold_pos                               -- 持有仓位
   ,t1.hold_denom                             -- 持有面值
   ,t1.net_price_cost                         -- 净价成本
   ,t1.int_adj                                -- 利息调整金额
   ,t1.evha_val_chag                          -- 公允价值变动
   ,t1.int_cost                               -- 利息成本
   ,t1.full_price_cost                        -- 全价成本
   ,t1.on_acct_amt                            -- 挂账利息
   ,t1.impam_prep                             -- 减值准备
   ,t1.spd_prft                               -- 价差收益
   ,t1.amort_prft                             -- 摊销收益
   ,t1.int_prft                               -- 利息收益
   ,t1.evha_val_chag_pl                       -- 公允价值变动损益
   ,t12.evha_val_chag_pl                      -- 公允价值变动损益_结转前
   ,t1.impam_loss                             -- 减值损失
   ,t1.tran_fee                               -- 交易费用
   ,t1.comm_fee_inco                          -- 手续费收入
   ,t1.comm_fee_expns                         -- 手续费支出
   ,t1.actl_int_rat                           -- 实际利率
   ,t1.value_dt                               -- 起息日期
   ,t1.exp_dt                                 -- 到期日期
   ,t1.happ_amt                               -- 发生金额
   ,case when t1.asset_type_name in ('质押式回购', '买断式回购', '开放式回购') then t1.hold_pos - t1.int_adj
         when t1.asset_type_name = '交易性金融资产' and t1.bus_cate_name = '现券' then t1.net_price_cost
         when t1.asset_type_name = '可供出售金融资产' and t1.bus_cate_name = '现券' then t1.hold_denom
         when t1.asset_type_name = '持有至到期投资' and t1.bus_cate_name = '现券' then t1.hold_denom
         when t1.asset_type_name in ('拆借') then t1.hold_pos
         when t1.asset_type_name = '债券发行' then t1.hold_pos
         when t1.asset_type_name in ('债券借贷') then t1.hold_pos
	     when t1.asset_type_name = '交易性金融资产' and t1.bus_cate_name = '债券负债' then t1.net_price_cost
         else t1.hold_pos  end     -- 当前余额
   ,t1.job_cd
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_cap_asset_bal t1
 inner join (select dept_id
                   ,acct_b_id
                   ,minor_asset_id
                   ,asset_type_name
                   ,bus_cate_name
                   ,max(asset_bal_id) as asset_bal_id
              from ${iml_schema}.agt_cap_asset_bal
             where /*etl_dt = to_date('${batch_date}','yyyymmdd')
              and*/ job_cd = 'ctmsf1'
               and stl_dt <= to_date('${batch_date}','yyyymmdd')
             group by dept_id,acct_b_id,asset_type_name,bus_cate_name,main_asset_id,minor_asset_id
             ) t2
    on t1.asset_bal_id = t2.asset_bal_id
   and t1.dept_id = t2.dept_id
   and t1.acct_b_id = t2.acct_b_id
  left join ${iml_schema}.ref_asset_type_cd t3
    on t1.asset_type_name = t3.asset_type_abbr
   and t3.job_cd = 'ctmsf1'
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.ctms_tbs_interface_portf_depart_mapping t4
    on t1.acct_b_id =t4.keepfolder_id
   and t4.start_dt <=to_date('${batch_date}','yyyymmdd')
   and t4.end_dt >to_date('${batch_date}','yyyymmdd')
  left join (select subj_id,
                    curr_cd,
                    org_id as org_id,
                    bus_dept_id,
                    row_number() over(partition by subj_id, curr_cd order by core_bus_id, org_id ) rn
               from ${iml_schema}.ref_dc_subj_map 
              where job_cd = 'ctmsf1'
            ) t7
    on 'N'||t1.pric_subj_id = t7.subj_id  -- N：新科目体系
   and nvl(decode(trim(t7.curr_cd),'-',null,t7.curr_cd), 'CNY') = 'CNY'
   and t4.departmentid=t7.bus_dept_id 
--   and t7.rn = 1 
   left join ${iml_schema}.prd_bond_basic_info t10
    on t1.minor_asset_id = t10.bond_id
   and t10.job_cd = 'ctmsf1'
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.id_mark <> 'D'
   left join ${iml_schema}.agt_acct_b t11
    on t1.acct_b_id = t11.acct_b_id
   and t11.job_cd = 'ctmsf1'
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.id_mark <> 'D'
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
                ) t12
    on t1.dept_id = t12.dept_id 
   and t1.acct_b_id = t12.acct_b_id 
   and t1.minor_asset_id = t12.minor_asset_id 
   and t1.asset_type_name = t12.asset_type_name 
   and t1.bus_cate_name = t12.bus_cate_name
   and t12.rn=1
 where t1.stl_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'ctmsf1'
   and t1.create_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.id_mark <> 'D'
   and (t1.main_asset_id = t1.minor_asset_id or t1.asset_type_name = '债券借贷')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_cap_bus_post exchange partition p_${batch_date} with table ${icl_schema}.cmm_cap_bus_post_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_cap_bus_post_ex purge;
drop table ${icl_schema}.tmp_cmm_cap_bus_post_01 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_cap_bus_post',partname => 'p_${batch_date}', degree => 8, cascade => true);
