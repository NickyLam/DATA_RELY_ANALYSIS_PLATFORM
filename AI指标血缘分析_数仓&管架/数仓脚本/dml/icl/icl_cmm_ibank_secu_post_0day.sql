/*
Purpose: 共性加工层-同业证券持仓
Author: Sunline
Usage: python $ETL_HOME/script/main.py 20200930 icl_cmm_ibank_secu_post
Createdate: 20191025
Logs: fuxx add column 'issuer_id','issuer_name' 20191108
	  20200424 周沁晖 1、调整资产四分类代码 acctnt_cls_cd ——> asset_four_cls_cd
	  20200627 周沁晖 调整字段【科目编号】的取数逻辑（15032101科目）
	  20200724 陈伟峰 增加【标准产品编号】字段
	  20200828 周沁晖 增加字段【对象编号、当日净值、利息科目编号、利息调整科目编号、资产三分类代码】
	  		          调整字段【科目编号】取数口径
	  20200828 陈伟峰 增加字段【交易金额】、【首次结算日期】
	  20200925 陈伟峰 修改发行人编号增加取值来源
	  20201017 陈伟峰 修改资产三分类取数源表
	  20201021 陈伟峰 修改利息科目、利息调整科目取值字段
	  20201027 翟若平 调整tmp_cmm_ibank_secu_post_01过滤条件
	  20201209 陈伟峰 增加字段【应计利息收入科目编号、摊销利息收入科目编号、公允价值变动损益科目编号、价差损益科目编号、应收利息、公允价值变动损益、价差损益、应计利息收入、摊销利息收入】，调整字段【应计利息】取数口径,调整口径【净价成本】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_secu_post drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_secu_post add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


whenever sqlerror continue none;
drop table ${icl_schema}.cmm_ibank_secu_post_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_secu_post_01 purge;

-- 2.1 insert into ex table
create table ${icl_schema}.cmm_ibank_secu_post_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_ibank_secu_post where 0=1;

/* --2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_secu_post_01(
		subj_id1 varchar2(100)
		,subj_id2 varchar2(100)
		,subj_id3 varchar2(100)
		,subj_id3 varchar2(100)
		,acctg_obj_id varchar2(100)
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_ibank_secu_post_01(
		subj_id1
		,subj_id2
		,subj_id3
		,acctg_obj_id
)
select max(case when gzb_type = '1' then subj_code else null end) as subj_id1,
			 max(case when gzb_type = '2' then subj_code else null end) as subj_id2,
			 max(case when gzb_type = '3' then subj_code else null end) as subj_id3,
			 acctg_obj_id
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type
  				from iol.ibms_ttrd_bookkeeping_obj_acctg a
  				left join iol.ibms_ttrd_accounting_entry_def b
  				  on a.subj_code = b.acting_code
  				 and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  				 and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
  			 where b.gzb_type in ('1','2','3')
  			   and replace(a.beg_date, '-', '') = '${batch_date}' -- 20201027 翟若平 新增
  			)group by acctg_obj_id;
commit; */

 --2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_secu_post_01 as 
select acctg_obj_id as obj_id,
       max(org_id) as org_id,            -- 机构编号
       max(decode(gzb_type, '1', subj_code, '9', subj_code, '')) as subj_id,     -- 科目编号
       max(decode(gzb_type, '3', subj_code, '')) as int_subj_id,                 -- 利息科目编号
       max(decode(gzb_type, '2', subj_code, '')) as int_adj_subj_id,             -- 利息调整科目编号
       max(decode(gzb_type, '5.1.1', subj_code, '')) as acru_int_inco_subj_id,   -- 应计利息收入科目编号
       max(decode(gzb_type, '5.1.2', subj_code, '5.1', subj_code, '')) as amort_int_income_subj_id,-- 摊销利息收入科目编号
       max(decode(gzb_type, '5.3', subj_code, '')) as evha_val_chag_pl_subj_id,  -- 公允价值变动损益科目编号
       max(decode(gzb_type, '5.2.1', subj_code, '')) as spd_pl_subj_id           -- 价差损益科目编号
  from (select distinct a.subj_code, a.acctg_obj_id, b.gzb_type, a.subj_org_id as org_id
          from ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg a
          left join ${iol_schema}.ibms_ttrd_accounting_entry_def b
            on a.subj_code = b.acting_code
           and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
         where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
           and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
		       and replace(a.beg_date, '-', '') = '${batch_date}') -- 20201027 翟若平 新增
 group by acctg_obj_id;
commit; 

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_secu_post_ex(
  etl_dt                 				-- 数据日期
  ,lp_id                 				-- 法人编号
  ,ext_secu_acct_id      				-- 外部证券账户编号
  ,intnal_secu_acct_id   				-- 内部证券账户编号
  ,fin_instm_id          				-- 金融工具编号
  ,asset_type_id         				-- 资产类型编号
  ,std_prod_id           				-- 标准产品编号
  ,market_type_id        				-- 市场类型编号
  ,bus_id                				-- 业务编号
  ,obj_id							    -- 对象编号
  ,prod_type_cd          				-- 产品类型代码
  ,asset_type_name       				-- 资产类型名称
  ,level5_cls_cd         				-- 五级分类代码
  ,subj_id               				-- 科目编号
  ,int_subj_id    		   				-- 利息科目编号  
  ,int_adj_subj_id		   				-- 利息调整科目编号
  ,acru_int_inco_subj_id                -- 应计利息收入科目编号
  ,amort_int_income_subj_id             -- 摊销利息收入科目编号
  ,evha_val_chag_pl_subj_id             -- 公允价值变动损益科目编号
  ,spd_pl_subj_id                       -- 价差损益科目编号
  ,acct_name             				-- 账户名称
  ,tran_market_id        				-- 交易市场编号
  ,exchg_acct_id         				-- 交易所账户编号
  ,issuer_id             				-- 发行人编号
  ,issuer_name           				-- 发行人名称
  ,stl_site_id           				-- 结算场所编号
  ,stl_site_name         				-- 结算场所名称
  ,tran_num              				-- 交易号
  ,extra_dimen_cd        				-- 额外维度代码
  ,curr_cd               				-- 币种代码
  ,actl_qtty             				-- 实际数量
  ,actl_bal              				-- 实际余额
  ,net_price_cost        				-- 净价成本
  ,acru_int              				-- 应计利息
  ,int_recvbl                           -- 应收利息
  ,int_cost              				-- 利息成本
  ,evha_val_chag         				-- 公允价值变动
  ,recvbl_uncol_bal      				-- 应收未收余额
  ,recvbl_uncol_net_price_cost          -- 应收未收净价成本
  ,recvbl_uncol_acru_int                -- 应收未收应计利息
  ,int_adj_amt                          -- 利息调整金额
  ,actl_int_rat                         -- 实际利率
  ,invest_yld_rat                       -- 投资收益率
  ,open_yld_rat                         -- 开仓收益率
  ,td_nv					            -- 当日净值
  ,amort_dt                             -- 摊销日期
  ,fir_stl_dt                           -- 首次结算日期
  ,stl_dt                               -- 结算日期
  ,open_dt                              -- 开仓日期
  ,last_update_dt                       -- 上次更新日期
  ,cap_type_cd                          -- 资金类型代码
  ,asset_four_cls_cd                    -- 资产四分类代码
  ,asset_thd_cls_cd			            -- 资产三分类代码
  ,belong_org_id                        -- 所属机构编号
  ,tran_amt                             -- 交易金额
  ,evha_val_chag_pl                     -- 公允价值变动损益
  ,spd_pl                               -- 价差损益
  ,acru_int_inco                        -- 应计利息收入
  ,amort_int_inco                       -- 摊销利息收入
  ,job_cd                               
  ,etl_timestamp                        -- etl处理时间戳
)
select
  to_date('${batch_date}', 'yyyymmdd')  -- 数据日期
  ,t1.lp_id                             -- 法人编号
  ,t1.ext_vch_acct_id                   -- 外部证券账户编号
  ,t1.intnal_vch_acct_id                -- 内部证券账户编号
  ,t1.fin_instm_id                      -- 金融工具编号
  ,t1.asset_type_id                     -- 资产类型编号
  ,t1.std_prod_id                       -- 标准产品编号
  ,t1.market_type_id                    -- 市场类型编号
  ,t1.tran_num                          -- 业务编号
  ,t1.obj_id			                -- 对象编号
  ,t4.prod_type_cd                      -- 产品类型代码
  ,t4.prod_cls                          -- 资产类型名称
  ,nvl(trim(t5.level5_cls_cd),'90')     -- 五级分类代码
  ,case when t4.prod_type_cd in ('0170') and t4.prod_cls = '票据资管计划（非保本）' and '${batch_date}' < '20201231' then '15032201'
        when t9.subj_id is not null then t9.subj_id
        else 
  (case when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国债')       and t2.acctnt_cls_cd  in ('116') then '1101011101'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('央行票据')   and t2.acctnt_cls_cd  in ('116') then '1101011201'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd  in ('116') then '1101011301'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('116') then '1101011401'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('116') then '1101011601'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd  in ('116') then '1101011701'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and t2.acctnt_cls_cd in ('116') then '1101011801'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国债')       and t2.acctnt_cls_cd  in ('118') then '15011101'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('央行票据')   and t2.acctnt_cls_cd  in ('118') then '15011201'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd  in ('118') then '15011301'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('118') then '15011401'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('118') then '15011601'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd  in ('118') then '15011701'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and t2.acctnt_cls_cd in ('118') then '15011801'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国债')       and t2.acctnt_cls_cd  in ('117') then '15031101'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('央行票据')   and t2.acctnt_cls_cd  in ('117') then '15031201'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('政策银行债') and t2.acctnt_cls_cd  in ('117') then '15031301'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('商业银行债','商业银行次级债券','保险公司债','证券公司债','证券公司短期融资券','其它金融机构债','资产支持证券-金融债') and t2.acctnt_cls_cd in ('117') then '15031401'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('资产支持证券-企业债','一般企业债','集合企业债','一般公司债','私募债') and t2.acctnt_cls_cd in ('117') then '15031601'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('地方政府债') and t2.acctnt_cls_cd  in ('117') then '15031701'
        when t4.prod_type_cd in ('1100','0000') and t4.prod_cls in ('国际机构债','政府支持机构债','其他债券') and  t2.acctnt_cls_cd in ('117') then '15031801'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('同业理财(保本)')                         then '15131001'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('同业理财(非保本)')                      then '15131011'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('有追索权的保理（金租公司租赁资产转让）') then '15131001'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('北金所债权融资计划','类信贷-私募债')     then '15130701'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('券商固定收益集合资管计划','券商固定收益定向资管计划') and t2.acct_name like '%投资其它_可供%' then '15039901'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('券商固定收益凭证','券商固定收益集合资管计划','券商固定收益定向资管计划','保险资管计划','交易所公司债(含企业债)','银行间债券','类信贷-资管计划','交易所资产支持证券(ABS)')   then '15130911'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('集合信托计划(保本)','单一信托计划/信托收益权(保本)','银登中心信贷资产流转项目-ABS(保本)','银登中心信贷资产流转项目-非标项目(保本)','Pre—ABS项目(ABS前端融资)(保本)') then '15130801'
        when t4.prod_type_cd in ('0170') and t4.prod_cls in ('集合信托计划(非保本)','单一信托计划/信托收益权(非保本)','银登中心信贷资产流转项目-ABS(非保本)','银登中心信贷资产流转项目-非标项目(非保本)','Pre—ABS项目(ABS前端融资)(非保本)','类信贷-信托计划') then '15130811'
        --when t4.prod_type_cd in ('0170') and t4.prod_cls in ('券商固定收益集合资管计划','券商固定收益定向资管计划') and t2.acct_name LIKE '%投资其它_可供%' then '15039901' --modify by fuxx 20191122 15039901科目需要放在15130911上面
        when t4.prod_type_cd in ('0703') and t4.prod_cls in ('债券基金')     then '1503190201'
        when t4.prod_type_cd in ('0706') and t4.prod_cls in ('货币基金')    then '1503190301'
        when t4.prod_type_cd in ('0000') and t4.prod_cls in ('同业存单')     then '25020301'
        when t4.prod_type_cd in ('0706') and t4.prod_cls in ('股权投资')     then '15032401'
        when t4.prod_type_cd in ('0706') and t4.prod_cls in ('理财产品')     then '15032301'
        when t4.prod_type_cd in ('0706') and t4.prod_cls in ('信托计划') and t1.extra_dimen_cd = 'L' then '15032101'
        when t4.prod_type_cd in ('0706') and t4.prod_cls in ('资产管理计划') then '15032201'
        when t4.prod_type_cd in ('0700') and t4.prod_cls in ('股权投资')     then '15032401'
        when t4.prod_type_cd in ('0700') and t4.prod_cls in ('理财产品')     then '15032301'
        when t4.prod_type_cd in ('0700') and t4.prod_cls in ('信托计划') and t7.cls_name in ('可供出售类', '可供出售-MA')  and t1.extra_dimen_cd = 'L' then '15032101'
        when t4.prod_type_cd in ('0700') and t4.prod_cls in ('资产管理计划') then '15032201'
   end ) end                 			 -- 科目编号
  ,t9.int_subj_id						 -- 利息科目编号  
  ,t9.int_adj_subj_id	        		 -- 利息调整科目编号
  ,t9.acru_int_inco_subj_id              -- 应计利息收入科目编号
  ,t9.amort_int_income_subj_id           -- 摊销利息收入科目编号
  ,t9.evha_val_chag_pl_subj_id           -- 公允价值变动损益科目编号
  ,t9.spd_pl_subj_id                     -- 价差损益科目编号
  --,t3.acct_name                        -- 账户名称 --modify by fuxx 20191122 账户名称需要从内部证券账户取
  ,t2.acct_name                          -- 账户名称
  ,t3.tran_market_id                     -- 交易市场编号
  ,t3.exchg_acct_id                      -- 交易所账户编号
  ,nvl(t6.issuer_id,t4.issuer_id)        -- 发行人编号
  ,t6.issuer_name                        -- 发行人名称
  ,t3.stl_site_id                        -- 结算场所编号
  ,t3.stl_site_name                      -- 结算场所名称
  ,t1.tran_num                           -- 交易号
  ,t1.extra_dimen_cd                     -- 额外维度代码
  ,t1.curr_cd                            -- 币种代码
  ,t1.actl_qtty                          -- 实际数量
  ,t1.actl_bal                           -- 实际余额
  ,nvl(t1.net_price_cost,0) + nvl(t1.recvbl_uncol_bal,0)              -- 净价成本
  ,case when t4.src_pay_int_ped_cd = '0D' then t1.acru_int + t1.recvbl_uncol_acru_int else 0 end  -- 应计利息
  ,case when t4.src_pay_int_ped_cd <> '0D' then t1.acru_int + t1.recvbl_uncol_acru_int else 0 end --应收利息
  ,t1.int_cost                           -- 利息成本
  ,t1.evha_val_chag                      -- 公允价值变动
  ,t1.recvbl_uncol_bal                   -- 应收未收余额
  ,t1.recvbl_uncol_net_price_cost        -- 应收未收净价成本
  ,t1.recvbl_uncol_acru_int              -- 应收未收应计利息
  ,t1.int_adj_amt                        -- 利息调整金额
  ,t1.actl_int_rat                       -- 实际利率
  ,t1.invest_yld_rat                     -- 投资收益率
  ,t1.open_yld_rat                       -- 开仓收益率
  ,t8.f_unitnav						     -- 当日净值
  ,t1.amort_dt                           -- 摊销日期
  ,t5.stl_dt                             -- 首次结算日期
  ,t1.stl_dt                             -- 结算日期
  ,t1.open_dt                            -- 开仓日期
  ,t1.last_update_dt                     -- 上次更新日期
  ,t2.cap_type_cd                        -- 资金类型代码
  ,t2.asset_four_cls_cd    		         -- 资产四分类代码
  ,t1.asset_thd_cls_cd  				 -- 资产三分类
  ,nvl(t2.belong_org_id, t9.org_id)      -- 所属机构编号
  ,t5.tran_amt                           -- 交易金额
  ,t1.fair_val_pl                        -- 公允价值变动损益
  ,t1.bs_pl                              -- 价差损益
  ,(case when ${batch_date} <= '20201231' then t1.int_income - t1.amort_int_income 
         else (t1.acru_int_inco + t1.at_pre_recv_int_income) 
         end)                            -- 应计利息收入
  ,t1.amort_int_income                   -- 摊销利息收入
  ,t1.job_cd
  ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1 --证券账户核算余额历史
  left join ${iml_schema}.agt_intnal_secu_acct t2 --内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.job_cd = 'ibmsf1'
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.job_cd = 'ibmsf1'
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.id_mark <> 'D'
  left join ${iml_schema}.prd_fin_instm t4 --金融工具表
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.job_cd = 'ibmsf1'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.id_mark <> 'D'
  /*left join ${iml_schema}.evt_ibank_tran t5 --同业交易表
    on t1.tran_num = t5.intnal_tran_num
   and t5.job_cd = 'ibmsi1'*/
   left join (select fin_instm_id
                     ,asset_type_id
                     ,tran_market_id
                     ,level5_cls_cd
                     ,stl_dt
					 ,tran_amt
                     ,row_number() over(partition by fin_instm_id,asset_type_id,tran_market_id order by stl_dt) as rn
                from ${iml_schema}.evt_ibank_tran
               where job_cd = 'ibmsi1'
                ) t5
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.tran_market_id
   and t5.rn = 1
 --inner join ${iml_schema}.prd_ibank_bond t6 --同业债券
  left join ${iml_schema}.prd_ibank_bond t6 --同业债券 modify by fuxx 20191108
    on t1.fin_instm_id = t6.fin_instm_id
   and t1.asset_type_id = t6.asset_type_id
   and t1.market_type_id = t6.market_type_id
   and t6.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsf1'
   and t6.id_mark <> 'D'
  left join ${iml_schema}.ref_ibank_acctnt_type_cd t7
  	on t7.cls_id = t2.acctnt_cls_cd
   and t7.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'ibmsf1'
   and t7.id_mark <> 'D' 
  left join ${iol_schema}.ibms_tfnd_nav t8
  	on t1.fin_instm_id = t8.i_code
   and t1.asset_type_id = t8.a_type
   and t1.market_type_id = t8.m_type
   and replace(t8.beg_date, '-', '') <= '${batch_date}'
   and replace(t8.end_date, '-', '') > '${batch_date}'
   and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t8.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.tmp_cmm_ibank_secu_post_01 t9
  	on t1.obj_id = t9.obj_id
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_secu_post exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_secu_post_ex
;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_secu_post_ex purge;
--drop table ${icl_schema}.tmp_cmm_ibank_secu_post_01 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_secu_post',partname => 'p_${batch_date}',granularity => 'PARTITION', degree => 8, cascade => true);
