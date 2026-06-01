/*
Purpose:    共性加工层-同业非标投资表:数据来源于同业系统（IBMS）,包括所有同业账户持有的应收账款类投资
                                 备注：TTRD_CASHLB还存在P_TYEP IN（'0134'，'0135'）
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py 20200531 icl_cmm_ibank_non_std_invest
Createdate: 20191025
Logs:
            20191206 翟若平 增加“类信贷标志”、“ABS标志”
            20191220 翟若平 调整付息周期代码的取数逻辑pay_int_ped_corp_cd -> pay_int_ped_freq || pay_int_ped_corp_cd
            20200424 周沁晖 1、调整资产四分类代码 acctnt_cls_cd ——> asset_four_cls_cd
			      20200724 陈伟峰 增加'标准产品编号'字段
			      20200828 周沁晖 增加字段【交易金额、对象编号、实际数量、公允价值变动、净值产品标志、基准利率、利差、基准利率倍数、当日净值、账面余额、资产三分类代码、底层债券代码、底层债券名称、底层实际融资人名称、底层持仓面额、底层实际融资人客户编号、底层中债估价全价、底层中债估价净价】
							              调整字段【科目编号】取数逻辑
							              增加字段【利息调整金额、底层债券标志、底层实际融资人所属集团、底层实际融资人客户性质、利息科目编号、利息调整科目编号】
							              拆分成两组，其中字段【国家代码、字段转存标志赋空】，第二组T5表改成IBMS_TTRD_INSTRUMENT
			      20200828 陈伟峰 增加字段【应收利息、当期余额】，调整字段【应计利息】的取数口径,修改 ibms_ttrd_blc_secu_obj算法变更技术字段
			      20200925 陈伟峰 增加字段【底层估价修正久期、底层基点价值、底层估价凸性、底层募集方式代码】，调整字段【ABS标志】取数口径
				    20201017 陈伟峰 修改资产三分类取数源表
				    20201021 陈伟峰 修改利息科目、利息调整科目取值字段
			      20201027 翟若平 调整tmp_cmm_ibank_secu_post_01过滤条件
			      20201106 周沁晖 整合原t9、t10表为tmp_cmm_ibank_non_std_invest_02,t17为tmp_cmm_ibank_non_std_invest_03,调整第一组t4表过滤条件为t4.asset_type_name not in ('北金所债权融资计划','私募债','类信贷-私募债')
			      20201127 周沁晖 T9.UND_STATUS <> '2' -> T9.UND_STATUS = '1'
			      
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_ibank_non_std_invest drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ibank_non_std_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ibank_non_std_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_03 purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ibank_non_std_invest_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_ibank_non_std_invest where 0=1;

--2.2 insert into tmp table
create table ${icl_schema}.tmp_cmm_ibank_non_std_invest_01(
		subj_id1 varchar2(100)
		,subj_id2 varchar2(100)
		,subj_id3 varchar2(100)
		,acctg_obj_id varchar2(100)
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_ibank_non_std_invest_01(
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
commit;


create table ${icl_schema}.tmp_cmm_ibank_non_std_invest_02(
		i_code varchar2(50)
		,a_type varchar2(50)
		,m_type varchar2(50)
		,u_i_code varchar2(50)
		,u_i_name varchar2(225)
		,a_class varchar2(10)
		,amount number(31,4)
		,parent_id varchar2(50)
		,u_m_type varchar2(225)
		,full_price_amt number(18,6)
		,net_price_amt number(30,8)
		,estim_coret_duran number(18,6)
		,estim_cvty number(18,6)
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_ibank_non_std_invest_02(
		i_code
		,a_type
		,m_type
		,u_i_code
		,u_i_name
		,a_class
		,amount
		,parent_id
		,u_m_type
		,full_price_amt
		,net_price_amt
		,estim_coret_duran
		,estim_cvty
)
select t9.i_code,
       t9.a_type,
       t9.m_type,
       substr(t9.u_i_code,1,instr(t9.u_i_code||'.','.')-1) as u_i_code,
       t9.u_i_name,
       t9.a_class,
       t9.amount,
       t9.parent_id,
       (case when substr(t9.u_i_code,instr(t9.u_i_code||'.','.')+1)= 'SZ' then 'XSHE' else 'XSHG' end) as u_m_type,
       t10.full_price_amt,
       t10.net_price_amt,
       t10.estim_coret_duran,
       t10.estim_cvty
  from ${iol_schema}.ibms_ttrd_und_asset t9
  left join ${iml_schema}.prd_ibank_bond_evltion t10
  	on t10.fin_instm_id = substr(t9.u_i_code, 1, instr(t9.u_i_code || '.', '.') - 1) 
   and (substr(t9.u_i_code, instr(t9.u_i_code || '.', '.') + 1) is null 
    or decode(t10.market_type_id,'XSHG','SH','XSHE','SZ','X_CNBD','IB', t10.market_type_id) = substr(t9.u_i_code, instr(t9.u_i_code || '.', '.') + 1))
   and t10.effect_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t10.invalid_dt > to_date('${batch_date}', 'yyyymmdd')
   and t10.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.job_cd = 'ibmsf1'
   and t10.id_mark <> 'D' 
 where t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t9.und_status = '1' ;
  
commit;



create table ${icl_schema}.tmp_cmm_ibank_non_std_invest_03(
		i_code varchar2(50)
		,a_type varchar2(50)
		,m_type varchar2(50)
		,cp number(32,8)
)
nologging
compress ${option_switch} for query high
;
insert into ${icl_schema}.tmp_cmm_ibank_non_std_invest_03(
		i_code
		,a_type
		,m_type
		,cp
)
select i_code,
       a_type,
       m_type,
       sum(volume) as cp
  from (select a1.secu_acct_id,
             a1.i_code,
             a1.a_type,
             a1.m_type,
             a1.volume,
             a1.trade_grp_id
        from iol.ibms_ttrd_blc_secu_obj a1
        left join iol.ibms_ttrd_blc_secu_obj b
          on a1.p_obj_id = b.obj_id
         and replace(b.beg_date,'-','') = '${batch_date}'
        left join iol.ibms_ttrd_instrument c
          on b.i_code = c.i_code
         and b.a_type = c.a_type
         and b.m_type = c.m_type
         and c.start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and c.end_dt > to_date('${batch_date}', 'yyyymmdd')
       where a1.set_date = '1900-01-01'
         and a1.blc_type not in ('231', '232', '241', '242')
         and (c.p_type is null or c.p_type <> '2000')
         and replace(a1.beg_date,'-','') <= '${batch_date}') a
         group by a.i_code, a.a_type, a.m_type;
commit;
-- 第一组：同业非标投资（非净值型产品）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_non_std_invest_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,ext_secu_acct_id                      --外部证券账户编号
    ,intnal_secu_acct_id                   --内部证券账户编号
    ,fin_instm_id                          --金融工具编号
    ,asset_type_id                         --资产类型编号
	  ,std_prod_id                           --标准产品编号
    ,market_type_id                        --市场类型编号
    ,bus_id                                --业务编号
    ,obj_id								                 --对象编号
    ,prod_type_cd                          --产品类型代码
    ,asset_type_name                       --资产类型名称
    ,class_crdt_flg                        --类信贷标志
    ,abs_flg                               --ABS标志
    ,level5_cls_cd                         --五级分类代码
    ,acct_name                             --账户名称
    ,subj_id                               --科目编号
    ,int_subj_id					 	               --利息科目编号  
    ,int_adj_subj_id			 		             --利息调整科目编号
    ,tran_market_id                        --交易市场编号
    ,exchg_acct_id                         --交易所账户编号
    ,cntpty_id                             --交易对手编号
    ,cntpty_name                           --交易对手名称
    ,cntpty_cls_descb                      --交易对手分类描述
    ,bank_flg                              --银行标志
    ,cty_cd                                --国家代码
    ,value_dt                              --起息日期
    ,exp_dt                                --到期日期
    ,tenor_cd                              --期限代码
    ,int_accr_base_cd                      --计息基准代码
    ,int_rat_adj_way_cd                    --利率调整方式代码
    ,apv_odd_no                            --审批单号
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,fac_val_int_rat                       --票面利率
    ,pay_int_ped_cd                        --付息周期代码
    ,auto_redt_flg                         --自动转存标志
    ,actl_qtty							               --实际数量
    ,actl_bal                              --实际余额
    ,pric_bal                              --本金余额
    ,acru_int                              --应计利息
	  ,int_recvbl                            --应收利息
    ,recvbl_uncol_pric                     --应收未收本金
    ,recvbl_uncol_int                      --应收未收利息
    ,int_adj_amt						               --利息调整金额
    ,evha_val_chag						             --公允价值变动
    ,nv_prod_flg  						             --净值产品标志
    ,base_rat     						             --基准利率  
    ,spd          						             --利差    
    ,base_rat_mult						             --基准利率倍数
    ,td_nv        						             --当日净值  
    ,book_bal     						             --账面余额 
    ,curr_bal                              --当前余额
    ,last_update_dt                        --上次更新日期
    ,cap_type_cd                           --资金类型代码
    ,asset_four_cls_cd                     --资产四分类代码
    ,asset_thd_cls_cd					             --资产三分类代码
    ,belong_org_id                         --所属机构编号 
    ,uder_bond_cd               		       --底层债券代码     
    ,uder_bond_name             		       --底层债券名称 
    ,uder_bond_flg						             --底层债券标志    
    ,uder_actl_finer_name       		       --底层实际融资人名称  
    ,uder_post_denom            		       --底层持仓面额     
    ,uder_actl_finer_cust_id    		       --底层实际融资人客户编号
    ,uder_actl_finer_group		 		         --底层实际融资人所属集团
    ,uder_actl_finer_cust_char   		       --底层实际融资人客户性质
	  ,uder_coll_way_cd                      --底层募集方式代码
    ,uder_cbond_estim_full_price		       --底层中债估价全价   
    ,uder_cbond_estim_net_price 		       --底层中债估价净价
    ,uder_csecu_full_price_evltion         --底层中证全价估值
    ,uder_csecu_net_price_evltion          --底层中证净价估值
    ,uder_csecu_coret_duran                --底层中证修正久期
    ,uder_csecu_bp_val                     --底层中证基点价值
    ,uder_csecu_estim_cvty                 --底层中证估价凸性
    ,uder_estim_coret_duran                --底层估价修正久期
    ,uder_bp_val                           --底层基点价值
    ,uder_estim_cvty                       --底层估价凸性
    ,tran_amt 							               --交易金额   
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt                    --数据日期
      ,'9999'                                 as lp_id                     --法人编号
      ,t1.ext_vch_acct_id                     as ext_secu_acct_id          --外部券账户编号
      ,t1.intnal_vch_acct_id                  as intnal_secu_acct_id       --内部券账户编号
      ,t1.fin_instm_id                        as fin_instm_id              --金融工具编号
      ,t1.asset_type_id                       as asset_type_id             --资产类型编号
	    ,t1.std_prod_id                         as std_prod_id               --标准产品编号
      ,t1.market_type_id                      as market_type_id            --市场类型编号
      ,t1.tran_num                            as bus_id                    --交易号
      ,t1.obj_id							                as obj_id					           --对象编号
      ,t4.prod_type_cd                        as prod_type_cd              --产品类型代码
      ,t4.asset_type_name                     as asset_type_name           --资产类型名称
      ,(case when t4.asset_type_name like '%类信贷%' 
	         then '1' else '0' end)             as class_crdt_flg            --类信贷标志
      ,decode(t13.is_asset_base_securities, '1', '1', '0')  as abs_flg     --ABS标志
      ,t6.level5_cls_cd                       as level5_cls_cd             --五级分类代码
      --,t3.acct_name                           as acct_name               --账户名称 modify by fuxx 20191122
      ,t2.acct_name                           as acct_name                 --账户名称
      ,case when t4.prod_type_cd in ('0170') and t4.asset_type_name = '票据资管计划（非保本）' and '${batch_date}' < '20201231' then '15032201'
            when t14.subj_id1 is not null then t14.subj_id1
            else 
       (case 
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('同业理财(保本)') then '15131001'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('同业理财(非保本)') then '15131011'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('有追索权的保理（金租公司租赁资产转让）') then '15131001'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('北金所债权融资计划','类信贷-私募债') then '15130701'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('券商固定收益集合资管计划','券商固定收益定向资管计划') and t2.acct_name like '%投资其它_可供%' then '15039901'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('券商固定收益凭证','券商固定收益集合资管计划','券商固定收益定向资管计划','保险资管计划','交易所公司债(含企业债)','银行间债券','类信贷-资管计划','交易所资产支持证券(ABS)') then '15130911'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('集合信托计划(保本)','单一信托计划/信托收益权(保本)','银登中心信贷资产流转项目-ABS(保本)','银登中心信贷资产流转项目-非标项目(保本)','Pre—ABS项目(ABS前端融资)(保本)') then '15130801'
				when t4.prod_type_cd in ('0170') and t4.asset_type_name IN ('集合信托计划(非保本)','单一信托计划/信托收益权(非保本)','银登中心信贷资产流转项目-ABS(非保本)','银登中心信贷资产流转项目-非标项目(非保本)','Pre—ABS项目(ABS前端融资)(非保本)','类信贷-信托计划') then '15130811'
				when t4.prod_type_cd in ('0703') and t4.asset_type_name IN ('债券基金') then '1503190201'
				when t4.prod_type_cd in ('0700') and t4.asset_type_name IN ('股权投资') then '15032401'
				when t4.prod_type_cd in ('0700') and t4.asset_type_name IN ('理财产品') then '15032301'
				when t4.prod_type_cd in ('0700') and t4.asset_type_name IN ('信托计划') and t8.cls_name in ('可供出售类', '可供出售-MA') and t1.extra_dimen_cd = 'L' then '15032101'
				when t4.prod_type_cd in ('0700') and t4.asset_type_name IN ('资产管理计划') then '15032201'
			end) end                  as subj_id             		--科目编号
      ,t14.subj_id3							as int_subj_id      			--利息科目编号  
      ,t14.subj_id2						  as int_adj_subj_id  			--利息调整科目编号
      ,t3.tran_market_id                      as tran_market_id             --交易市场编号
      ,t3.exchg_acct_id                       as exchg_acct_id              --交易所账户编号
      ,t6.cntpty_id                           as cntpty_id                  --交易对手编号
      ,t6.cntpty_name                         as cntpty_name                --交易对手名称
      ,t5.cust_cls_name                       as cntpty_cls_descb           --客户分类名称
      ,case when substr(t5.cust_cls_name,1,2）= '银行' 
	        then '1' else '0' end             as bank_flg                   --银行标志
      ,t4.cty_cd                              as cty_cd                     --国家代码
      ,t4.value_dt                            as value_dt                   --起息日期
      ,t4.exp_dt                              as exp_dt                     --到期日期
      --,t4.tenor                               as tenor_cd                 --期限代码
      ,t4.tenor||'D'                          as tenor_cd                   --期限代码 modify by fuxx 20191108 拼上期限单位作为期限代码
      ,t4.int_accr_base_cd                    as int_accr_base_cd           --计息基准代码
      ,t4.int_rat_adj_way_cd                  as int_rat_adj_way_cd         --利率调整方式代码 1－固定利率；2－浮动利率；3－零息票利率
      ,trim(t6.apv_odd_no)                    as apv_odd_no                 --审批单号
      ,t4.curr_cd                             as curr_cd                    --币种代码
      ,t4.corp_fac_val                        as fac_val_amt                --单位面值
      ,t4.fac_val_int_rat                     as fac_val_int_rat            --票面利率
      ,t4.pay_int_ped_freq || t4.pay_int_ped_corp_cd  as pay_int_ped_cd     --付息周期代码
      ,t4.auto_redt_flg                       as auto_redt_flg              --自动转存标志
      ,t1.actl_qtty 						  as actl_qtty					--实际数量
      ,t1.actl_bal                            as actl_bal                   --实际余额
      ,t1.net_price_cost                      as pric_bal                   --净价成本
	    ,case when t4.src_pay_int_ped_cd = '0D' 
	          then t1.acru_int + t1.recvbl_uncol_acru_int 
	          else 0 end                        as int_recvbl                 --应计利息
      ,case when t4.src_pay_int_ped_cd <> '0D' 
	          then t1.acru_int + t1.recvbl_uncol_acru_int 
	          else 0 end                        as acru_int                   --应收利息
      ,t1.recvbl_uncol_net_price_cost         as recvbl_uncol_pric          --应收未收净价成本
      ,t1.recvbl_uncol_acru_int               as recvbl_uncol_int           --应收未收应计利息
      ,t1.int_adj_amt						              as int_adj_amt				        --利息调整金额
      ,t1.evha_val_chag 					            as evha_val_chag				      --公允价值变动
      ,case when '${batch_date}' < '20201231'
            then '0'
	    else (case when t4.prod_type_cd = '0170' and t4.asset_type_name like '%票据资管%'
                       then '1'
                  else '0' end) end                                                    as nv_prod_flg				      --净值产品标志 
      ,t12.ad_fixingrate 					            as base_rat     				      --基准利率
      ,t12.ad_spread     					            as spd          				      --利差
      ,t12.ad_multiplier 					            as base_rat_mult				      --基准利率倍数
      ,t7.unit_nav							              as td_nv						          --当日净值
      ,t1.net_price_cost + t1.recvbl_uncol_net_price_cost + t1.int_adj_amt + decode(t5.src_pay_int_ped_cd, '0D', t1.recvbl_uncol_acru_int + t1.acru_int,0) + t1.evha_val_chag as book_bal --账面余额
	    ,t17.cp                                 as curr_bal                   --当前余额
      ,t1.last_update_dt                      as last_update_dt             --上次更新日期
      ,t2.cap_type_cd                         as cap_type_cd                --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t2.asset_four_cls_cd                   as asset_four_cls_cd          --资产四分类代码 1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      ,t1.asset_thd_cls_cd  				          as asset_thd_cls_cd			      --资产三分类代码
      ,t2.belong_org_id                       as belong_org_id              --所属机构编号
      ,t9.u_i_code							              as uder_bond_cd  				      --底层债券代码
      ,t9.u_i_name							              as uder_bond_name				      --底层债券名称
      ,decode(t9.a_class, '3', '1', '6', '1', '0') as uder_bond_flg			    --底层债券标志  
      ,t13.final_use_comp					            as uder_actl_finer_name 		  --底层实际融资人名称
      ,t9.amount							                as uder_post_denom			      --底层持仓面额
      ,t13.actual_financier_id				        as uder_actl_finer_cust_id	  --底层实际融资人客户编号
      ,t13.parent_group    					          as uder_actl_finer_group 		  --底层实际融资人所属集团
      ,t13.financier_nature					          as uder_actl_finer_cust_char  --底层实际融资人客户性质
	    ,trim(t13.raise_way)                    as uder_coll_way_cd           --底层募集方式代码
      ,t9.full_price_amt 					            as uder_cbond_estim_full_price--底层中债估价全价
      ,t9.net_price_amt  					            as uder_cbond_estim_net_price --底层中债估价净价
      ,t18.dirty_price                        as uder_csecu_full_price_evltion   --底层中证全价估值
      ,t18.price                              as uder_csecu_net_price_evltion    --底层中证净价估值
      ,t18.mk_duration                        as uder_csecu_coret_duran          --底层中证修正久期
      ,t18.mk_mdvbp                           as uder_csecu_bp_val               --底层中证基点价值
      ,t18.mk_convexity                       as uder_csecu_estim_cvty           --底层中证估价凸性
      ,t9.estim_coret_duran                   as uder_estim_coret_duran     --底层估价修正久期
      ,t9.full_price_amt*t9.amount/100*t9.estim_coret_duran/10000 as uder_bp_val     --底层基点价值
      ,t9.estim_cvty                          as uder_estim_cvty            --底层估价凸性
      ,t6.tran_amt							              as tran_amt 					        --交易金额
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1  --证券账户核算余额历史
  left join ${iml_schema}.agt_intnal_secu_acct t2 --内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
 inner join ${iml_schema}.prd_ibank_cap_ld_fin_instm t4 --同业资金借贷金融工具
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.prod_type_cd = '0170'
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
  left join ${iml_schema}.prd_fin_instm t5 --金融工具表
    on t1.fin_instm_id = t5.fin_instm_id
   and t1.asset_type_id = t5.asset_type_id
   and t1.market_type_id = t5.market_type_id
   and t5.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.job_cd = 'ibmsf1'
   and t5.id_mark <> 'D'
  left join ${iml_schema}.evt_ibank_tran t6 --同业交易表
    on t1.tran_num = t6.intnal_tran_num
   --and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsi1'
  left join (select en.i_code, en.a_type, en.m_type, en.beg_date, en.end_date, en.unit_nav
 						   from ${iol_schema}.ibms_ttrd_equity_nav en
 						  where to_date(en.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(en.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and en.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and en.end_dt > to_date('${batch_date}', 'yyyymmdd')
						  union
 						 select tn.i_code, tn.a_type, tn.m_type, tn.beg_date, tn.end_date, tn.f_unitnav as unit_nav
 						   from ${iol_schema}.ibms_tfnd_nav tn
 						  where to_date(tn.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(tn.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and tn.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and tn.end_dt > to_date('${batch_date}', 'yyyymmdd')) t7
 	  on t1.fin_instm_id = t7.i_code
 	 and t1.asset_type_id = t7.a_type
 	 and t1.market_type_id = t7.m_type
 	left join ${iml_schema}.ref_ibank_acctnt_type_cd t8
 		on t8.cls_id = t2.acctnt_cls_cd
 	 and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ibmsf1'
   and t8.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_02 t9
  	on t1.fin_instm_id = t9.i_code
   and t1.asset_type_id = t9.a_type
   and t1.market_type_id = t9.m_type
  left join ${iml_schema}.pty_ibank_cntpty_info t11
  	on t11.src_party_id = t9.parent_id
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'ibmsf1'
   and t11.id_mark <> 'D' 
  left join ${iol_schema}.ibms_tbsi_accrualdetail t12
  	on t1.fin_instm_id = t12.i_code
   and t1.asset_type_id = t12.a_type
   and t1.market_type_id = t12.m_type
   and to_char(to_date(t12.ad_startdate,'yyyy-mm-dd'),'yyyymmdd') <= '${batch_date}'
   and to_char(to_date(t12.ad_enddate,'yyyy-mm-dd'),'yyyymmdd') > '${batch_date}'
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t13
 	  on t1.fin_instm_id = t13.i_code
 	 and t1.asset_type_id = t13.a_type
 	 and t1.market_type_id = t13.m_type
 	 and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_01 t14
 	  on t1.obj_id = t14.acctg_obj_id
	left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_03 t17
	  on t1.fin_instm_id = t17.i_code  
	 and t1.asset_type_id = t17.a_type 
	 and t1.market_type_id = t17.m_type
	left join (select me.*,
                    row_number() over(partition by  me.i_code,me.a_type,me.m_type order by me.beg_date desc ) rn
               from ${iol_schema}.ibms_tbnd_manual_eval me
              where to_date(me.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')) t18
    on t9.u_i_code = t18.i_code
   and t9.u_m_type = t18.m_type
   and t18.rn = 1
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
;

commit;

-- 第二组：同业非标投资（净值型产品）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ibank_non_std_invest_ex(
     etl_dt                                --数据日期
    ,lp_id                                 --法人编号
    ,ext_secu_acct_id                      --外部证券账户编号
    ,intnal_secu_acct_id                   --内部证券账户编号
    ,fin_instm_id                          --金融工具编号
    ,asset_type_id                         --资产类型编号
	  ,std_prod_id                           --标准产品编号
    ,market_type_id                        --市场类型编号
    ,bus_id                                --业务编号
    ,obj_id								                 --对象编号
    ,prod_type_cd                          --产品类型代码
    ,asset_type_name                       --资产类型名称
    ,class_crdt_flg                        --类信贷标志
    ,abs_flg                               --ABS标志
    ,level5_cls_cd                         --五级分类代码
    ,acct_name                             --账户名称
    ,subj_id                               --科目编号
    ,int_subj_id					 	               --利息科目编号  
    ,int_adj_subj_id			 		             --利息调整科目编号
    ,tran_market_id                        --交易市场编号
    ,exchg_acct_id                         --交易所账户编号
    ,cntpty_id                             --交易对手编号
    ,cntpty_name                           --交易对手名称
    ,cntpty_cls_descb                      --交易对手分类描述
    ,bank_flg                              --银行标志
    ,cty_cd                                --国家代码
    ,value_dt                              --起息日期
    ,exp_dt                                --到期日期
    ,tenor_cd                              --期限代码
    ,int_accr_base_cd                      --计息基准代码
    ,int_rat_adj_way_cd                    --利率调整方式代码
    ,apv_odd_no                            --审批单号
    ,curr_cd                               --币种代码
    ,fac_val_amt                           --票面金额
    ,fac_val_int_rat                       --票面利率
    ,pay_int_ped_cd                        --付息周期代码
    ,auto_redt_flg                         --自动转存标志
    ,actl_qtty							               --实际数量
    ,actl_bal                              --实际余额
    ,pric_bal                              --本金余额
    ,acru_int                              --应计利息
	  ,int_recvbl                            --应收利息
    ,recvbl_uncol_pric                     --应收未收本金
    ,recvbl_uncol_int                      --应收未收利息
    ,int_adj_amt						               --利息调整金额
    ,evha_val_chag						             --公允价值变动
    ,nv_prod_flg  						             --净值产品标志
    ,base_rat     						             --基准利率  
    ,spd          						             --利差    
    ,base_rat_mult						             --基准利率倍数
    ,td_nv        						             --当日净值  
    ,book_bal     						             --账面余额 
    ,curr_bal                              --当前余额
    ,last_update_dt                        --上次更新日期
    ,cap_type_cd                           --资金类型代码
    ,asset_four_cls_cd                     --资产四分类代码
    ,asset_thd_cls_cd					             --资产三分类代码
    ,belong_org_id                         --所属机构编号 
    ,uder_bond_cd               		       --底层债券代码     
    ,uder_bond_name             		       --底层债券名称 
    ,uder_bond_flg						             --底层债券标志    
    ,uder_actl_finer_name       		       --底层实际融资人名称  
    ,uder_post_denom            		       --底层持仓面额     
    ,uder_actl_finer_cust_id    		       --底层实际融资人客户编号
    ,uder_actl_finer_group		 		         --底层实际融资人所属集团
    ,uder_actl_finer_cust_char   		       --底层实际融资人客户性质
	  ,uder_coll_way_cd                      --底层募集方式代码
    ,uder_cbond_estim_full_price		       --底层中债估价全价   
    ,uder_cbond_estim_net_price 		       --底层中债估价净价
    ,uder_csecu_full_price_evltion         --底层中证全价估值
    ,uder_csecu_net_price_evltion          --底层中证净价估值
    ,uder_csecu_coret_duran                --底层中证修正久期
    ,uder_csecu_bp_val                     --底层中证基点价值
    ,uder_csecu_estim_cvty                 --底层中证估价凸性
    ,uder_estim_coret_duran                --底层估价修正久期
    ,uder_bp_val                           --底层基点价值
    ,uder_estim_cvty                       --底层估价凸性
    ,tran_amt 							               --交易金额   
    ,job_cd
    ,etl_timestamp                         --数据处理时间
)
select to_date('${batch_date}','yyyymmdd')    as etl_dt                    --数据日期
      ,'9999'                                 as lp_id                     --法人编号
      ,t1.ext_vch_acct_id                     as ext_secu_acct_id          --外部券账户编号
      ,t1.intnal_vch_acct_id                  as intnal_secu_acct_id       --内部券账户编号
      ,t1.fin_instm_id                        as fin_instm_id              --金融工具编号
      ,t1.asset_type_id                       as asset_type_id             --资产类型编号
	    ,t1.std_prod_id                         as std_prod_id               --标准产品编号
      ,t1.market_type_id                      as market_type_id            --市场类型编号
      ,t1.tran_num                            as bus_id                    --交易号
      ,t1.obj_id							                as obj_id		                 --对象编号
      ,t4.prod_type_cd                        as prod_type_cd              --产品类型代码
      ,t4.prod_cls                            as asset_type_name           --资产类型名称
      ,(case when t4.prod_cls like '%类信贷%' 
	           then '1' else '0' end)           as class_crdt_flg            --类信贷标志
      ,decode(t13.is_asset_base_securities, '1', '1', '0')  as abs_flg     --ABS标志
      ,t6.level5_cls_cd                       as level5_cls_cd             --五级分类代码
      --,t3.acct_name                           as acct_name               --账户名称 modify by fuxx 20191122
      ,t2.acct_name                           as acct_name                 --账户名称
      ,case when t4.prod_type_cd in ('0170') and t4.prod_cls = '票据资管计划（非保本）' and '${batch_date}' < '20201231' then '15032201'
            when t14.subj_id1 is not null then t14.subj_id1
            else 
       (case 
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('同业理财(保本)') then '15131001'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('同业理财(非保本)') then '15131011'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('有追索权的保理（金租公司租赁资产转让）') then '15131001'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('北金所债权融资计划','类信贷-私募债') then '15130701'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('券商固定收益凭证','券商固定收益集合资管计划','券商固定收益定向资管计划','保险资管计划','交易所公司债(含企业债)','银行间债券','类信贷-资管计划','交易所资产支持证券(ABS)') then '15130911'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('集合信托计划(保本)','单一信托计划/信托收益权(保本)','银登中心信贷资产流转项目-ABS(保本)','银登中心信贷资产流转项目-非标项目(保本)','Pre—ABS项目(ABS前端融资)(保本)') then '15130801'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('集合信托计划(非保本)','单一信托计划/信托收益权(非保本)','银登中心信贷资产流转项目-ABS(非保本)','银登中心信贷资产流转项目-非标项目(非保本)','Pre—ABS项目(ABS前端融资)(非保本)','类信贷-信托计划') then '15130811'
				when t4.prod_type_cd in ('0170') and t4.prod_cls IN ('券商固定收益集合资管计划','券商固定收益定向资管计划') and t3.acct_name like '%投资其它_可供%' then '15039901'
				when t4.prod_type_cd in ('0703') and t4.prod_cls IN ('债券基金') then '1503190201'
				when t4.prod_type_cd in ('0700') and t4.prod_cls IN ('股权投资') then '15032401'
				when t4.prod_type_cd in ('0700') and t4.prod_cls IN ('理财产品') then '15032301'
				when t4.prod_type_cd in ('0700') and t4.prod_cls IN ('信托计划') and t8.cls_name in ('可供出售类', '可供出售-MA') and t1.extra_dimen_cd = 'L' then '15032101'
				when t4.prod_type_cd in ('0700') and t4.prod_cls IN ('资产管理计划') then '15032201'
			  end) end                      as subj_id             		            --科目编号
      ,t14.subj_id3							      as int_subj_id      			            --利息科目编号  
      ,t14.subj_id2							      as int_adj_subj_id  			            --利息调整科目编号
      ,t3.tran_market_id                      as tran_market_id             --交易市场编号
      ,t3.exchg_acct_id                       as exchg_acct_id              --交易所账户编号
      ,t6.cntpty_id                           as cntpty_id                  --交易对手编号
      ,t6.cntpty_name                         as cntpty_name                --交易对手名称
      ,t4.cust_cls_name                       as cntpty_cls_descb           --客户分类名称
      ,case when substr(t4.cust_cls_name,1,2）= '银行' 
	          then '1' else '0' end             as bank_flg                   --银行标志
      ,''                                     as cty_cd                     --国家代码
      ,t4.value_dt                            as value_dt                   --起息日期
      ,t4.exp_dt                              as exp_dt                     --到期日期
      --,t4.tenor                               as tenor_cd                 --期限代码
      ,t4.tenor||'D'                          as tenor_cd                   --期限代码 modify by fuxx 20191108 拼上期限单位作为期限代码
      ,t4.int_accr_base_cd                    as int_accr_base_cd           --计息基准代码
      ,t4.coupon_type_cd                      as int_rat_adj_way_cd         --利率调整方式代码 1－固定利率；2－浮动利率；3－零息票利率
      ,trim(t6.apv_odd_no)                    as apv_odd_no                 --审批单号
      ,t4.curr_cd                             as curr_cd                    --币种代码
      ,t4.issue_denom                         as fac_val_amt                --单位面值
      ,t4.fac_val_int_rat                     as fac_val_int_rat            --票面利率
      ,t4.pay_int_ped_freq || t4.pay_int_ped_corp_cd  as pay_int_ped_cd     --付息周期代码
      ,''                                     as auto_redt_flg              --自动转存标志
      ,t1.actl_qtty 						              as actl_qtty					--实际数量
      ,t1.actl_bal                            as actl_bal                   --实际余额
      ,t1.net_price_cost                      as pric_bal                   --净价成本
	    ,case when t4.src_pay_int_ped_cd = '0D' 
	          then t1.acru_int + t1.recvbl_uncol_acru_int 
	          else 0 end                        as int_recvbl                 --应计利息
      ,case when t4.src_pay_int_ped_cd <> '0D' 
	          then t1.acru_int + t1.recvbl_uncol_acru_int 
	          else 0 end                        as acru_int                   --应收利息
      ,t1.recvbl_uncol_net_price_cost         as recvbl_uncol_pric          --应收未收净价成本
      ,t1.recvbl_uncol_acru_int               as recvbl_uncol_int           --应收未收应计利息
      ,t1.int_adj_amt						              as int_adj_amt				        --利息调整金额
      ,t1.evha_val_chag 					            as evha_val_chag			        --公允价值变动
      ,'1'    								                as nv_prod_flg				        --净值产品标志
      ,t12.ad_fixingrate 					            as base_rat     			        --基准利率
      ,t12.ad_spread     					            as spd          			        --利差
      ,t12.ad_multiplier 					            as base_rat_mult			        --基准利率倍数
      ,t7.unit_nav							              as td_nv						          --当日净值
      ,t1.net_price_cost + t1.recvbl_uncol_net_price_cost + t1.int_adj_amt + decode(t4.src_pay_int_ped_cd, '0D', t1.recvbl_uncol_acru_int + t1.acru_int,0) + t1.evha_val_chag as book_bal --账面余额
	    ,t17.cp                                 as curr_bal                   --当前余额
      ,t1.last_update_dt                      as last_update_dt             --上次更新日期
      ,t2.cap_type_cd                         as cap_type_cd                --资金类型代码 0自有资产（自营业务）、1客户资产（代客、理财）
      ,t2.asset_four_cls_cd                   as asset_four_cls_cd          --资产四分类代码 1:交易类;2:可供出售类;3:持有到期类;4:应收款项类;5:理财销售类
      ,t1.asset_thd_cls_cd  				          as asset_thd_cls_cd			      --资产三分类代码
      ,t2.belong_org_id                       as belong_org_id              --所属机构编号
      ,t9.u_i_code							              as uder_bond_cd  				      --底层债券代码
      ,t9.u_i_name						                as uder_bond_name				      --底层债券名称
      ,decode(t9.a_class, '3', '1', '6', '1', '0') as uder_bond_flg		      --底层债券标志
      ,t13.final_use_comp					            as uder_actl_finer_name 		  --底层实际融资人名称
      ,t9.amount							                as uder_post_denom			      --底层持仓面额
      ,t13.actual_financier_id				        as uder_actl_finer_cust_id	  --底层实际融资人客户编号
      ,t13.parent_group    					          as uder_actl_finer_group 		  --底层实际融资人所属集团
      ,t13.financier_nature					          as uder_actl_finer_cust_char  --底层实际融资人客户性质
	    ,trim(t13.raise_way)                    as uder_coll_way_cd           --底层募集方式代码
      ,t9.full_price_amt 				            as uder_cbond_estim_full_price  --底层中债估价全价
      ,t9.net_price_amt  				            as uder_cbond_estim_net_price   --底层中债估价净价
      ,''                                    as uder_csecu_full_price_evltion   --底层中证全价估值
      ,''                                    as uder_csecu_net_price_evltion    --底层中证净价估值
      ,''                                    as uder_csecu_coret_duran          --底层中证修正久期
      ,''                                    as uder_csecu_bp_val               --底层中证基点价值
      ,''                                    as uder_csecu_estim_cvty           --底层中证估价凸性
      ,t9.estim_coret_duran                  as uder_estim_coret_duran          --底层估价修正久期
      ,t9.full_price_amt*t9.amount/100*t9.estim_coret_duran/10000 as uder_bp_val     --底层基点价值
      ,t9.estim_cvty                         as uder_estim_cvty            --底层估价凸性
      ,t6.tran_amt						                as tran_amt   				        --交易金额
      ,t1.job_cd
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
  from ${iml_schema}.agt_secu_acct_accti_bal_h t1  --证券账户核算余额历史
  left join ${iml_schema}.agt_intnal_secu_acct t2 --内部证券账户
    on t1.intnal_vch_acct_id = t2.acct_id
   and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'ibmsf1'
   and t2.id_mark <> 'D'
  left join ${iml_schema}.agt_ext_secu_acct t3 --外部证券账户
    on t1.ext_vch_acct_id = t3.acct_id
   and t3.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.job_cd = 'ibmsf1'
   and t3.id_mark <> 'D'
 inner join ${iml_schema}.prd_fin_instm t4 --金融工具表
    on t1.fin_instm_id = t4.fin_instm_id
   and t1.asset_type_id = t4.asset_type_id
   and t1.market_type_id = t4.market_type_id
   and t4.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.job_cd = 'ibmsf1'
   and t4.id_mark <> 'D'
  left join ${iml_schema}.evt_ibank_tran t6 --同业交易表
    on t1.tran_num = t6.intnal_tran_num
   --and t6.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t6.job_cd = 'ibmsi1'
  left join (select en.i_code, en.a_type, en.m_type, en.beg_date, en.end_date, en.unit_nav
 						   from ${iol_schema}.ibms_ttrd_equity_nav en
 						  where to_date(en.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(en.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and en.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and en.end_dt > to_date('${batch_date}', 'yyyymmdd')
						 	union
 						 select tn.i_code, tn.a_type, tn.m_type, tn.beg_date, tn.end_date, tn.f_unitnav as unit_nav
 						   from ${iol_schema}.ibms_tfnd_nav tn
 						  where to_date(tn.beg_date,'yyyy-mm-dd') <= to_date('${batch_date}', 'yyyymmdd')
 						    and to_date(tn.end_date,'yyyy-mm-dd') > to_date('${batch_date}', 'yyyymmdd')
 						    and tn.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 						    and tn.end_dt > to_date('${batch_date}', 'yyyymmdd')) t7
 		on t1.fin_instm_id = t7.i_code
 	 and t1.asset_type_id = t7.a_type
 	 and t1.market_type_id = t7.m_type
 	left join ${iml_schema}.ref_ibank_acctnt_type_cd t8
 		on t8.cls_id = t2.acctnt_cls_cd
 	 and t8.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.job_cd = 'ibmsf1'
   and t8.id_mark <> 'D'
  left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_02 t9
  	on t1.fin_instm_id = t9.i_code
   and t1.asset_type_id = t9.a_type
   and t1.market_type_id = t9.m_type
  left join ${iml_schema}.pty_ibank_cntpty_info t11
  	on t11.src_party_id = t9.parent_id
   and t11.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t11.job_cd = 'ibmsf1'
   and t11.id_mark <> 'D' 
  left join ${iol_schema}.ibms_tbsi_accrualdetail t12
  	on t1.fin_instm_id = t12.i_code
   and t1.asset_type_id = t12.a_type
   and t1.market_type_id = t12.m_type
   and to_char(to_date(t12.ad_startdate,'yyyy-mm-dd'),'yyyymmdd') <= '${batch_date}'
   and to_char(to_date(t12.ad_enddate,'yyyy-mm-dd'),'yyyymmdd') > '${batch_date}'
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${iol_schema}.ibms_ttrd_cashlb_manage_ele t13
 	  on t1.fin_instm_id = t13.i_code
 	 and t1.asset_type_id = t13.a_type
 	 and t1.market_type_id = t13.m_type
 	 and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_01 t14
 	  on t1.obj_id = t14.acctg_obj_id
	left join ${icl_schema}.tmp_cmm_ibank_non_std_invest_03 t17
	  on t1.fin_instm_id = t17.i_code  
	 and t1.asset_type_id = t17.a_type 
	 and t1.market_type_id = t17.m_type
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'ibmsf1'
   and (t4.prod_type_cd = '0700' or t4.prod_cls = '债券基金')
;

commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_ibank_non_std_invest exchange partition p_${batch_date} with table ${icl_schema}.cmm_ibank_non_std_invest_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_ibank_non_std_invest_ex purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_01 purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_02 purge;
drop table ${icl_schema}.tmp_cmm_ibank_non_std_invest_03 purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ibank_non_std_invest', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);