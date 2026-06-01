/*
Purpose:    共性加工层-信用证账户信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_lc_acct_info
CreateDate: 20190808
Logs:       20200110 翟若平 调整iml.ref_cny_fori_exch_mdl_p_h表取数口径
						20200424 周沁晖 1、新增字段[受益人国家代码、货物描述、信用证支付类型代码、代开行名称]
						                2、调整字段【开证金额】的取数逻辑
						20200605 周沁晖 1、增加字段【可承兑余额】
						20200624 周沁晖 增加字段【年日均余额、季日均余额、月日均余额、折本币年日均余额、折本币季日均余额、折本币月日均余额】
						20200724 周沁晖 增加第二组（国内进口信用证）和第四组（国内出口信用证）
						20200828 周沁晖 增加字段【标准产品编号、开证行SWIFTCODE、开证行中文名称】、调整字段【开证行名称】取数口径
						20210329 周沁晖 调整国内信用证分组【业务品种编号】口径
						20210426 谢  宁	新增字段【可承兑总额】
						20211016 陈伟峰 调整进口信用证（国内），出口信用证（国内国际）有关角色为"INI"部分关联逻辑
						                调整【可承兑总额】加工逻辑
						20220428 翟若平	调整字段【标准产品编号、科目编号、折本币余额及相关折币积数字段】的取数口径
                        20220516 温旺清	调整【T16-fin_accti_subj_rela_h】临时表中的取数过滤条件，由ISB->ISBX
						20220624 温旺清 调整字段【科目编号】的加工口径
						20220805 温旺清 增加字段【开证行BIC、通知行BIC、代开行BIC、保兑行BIC、收款行BIC、付款行BIC、交易完成时间、折美元交易金额】
						20222826 温旺清 调整字段【受益人国家代码】的加工口径--ISBS_STB
						20220922 温旺清 新增字段【电子信用证标志】
					    20230413 翟若平 调整第三组【t2, t21, t7, t71】的相关逻辑，优化了第一、第二组的程序
					    20230601 陈伟峰 调整isbs_cbe表，去掉acc<>' '
					    20231113 徐子豪 新增字段【贸易类型代码】
					    20241021 陈伟峰 新增字段【对手客户编号】
					    20250402 陈凭   新增字段【复核柜员编号、复核柜员名称】
						20251016 谢 宁  新增字段【受益人开户行名称、受益人开户行账号】
						20260121 陈 凭  新增字段【质押类型代码】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_lc_acct_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_lc_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_lc_acct_info_ex purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_01 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_02 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_03 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_04 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_041 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_05 purge;
drop table ${icl_schema}.temp_cmm_lc_acct_info_06 purge;
drop table ${icl_schema}.cmm_lc_acct_info_ex_02 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_lc_acct_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_lc_acct_info where 0=1;

-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_01
nologging
compress ${option_switch} for query high
as
select brd.pntinr,
  		 sum(cbb.amt) bramt,
  		 cbb.cur brcur
  from ${iol_schema}.isbs_pte pte,
       ${iol_schema}.isbs_cbb cbb,
       ${iol_schema}.isbs_pts pts,
       ${iol_schema}.isbs_brd brd
 where pts.objtyp = 'BRD'
   and pts.objinr = brd.inr
   and brd.pnttyp = 'LID'
   and pts.rol = 'APL'
   and cbb.objtyp = 'PTE'
   and cbb.objinr = pte.inr
   and cbb.extid = 'AMT1'
   and pte.objtyp = 'PTS'
   and pte.objinr = pts.inr
   and pte.cbtpfx in ('AKZ', 'INT')
   and cbb.enddat > to_date('${batch_date}','yyyymmdd')
   and cbb.begdat <= to_date('${batch_date}','yyyymmdd')
   and cbb.start_dt <= to_date('${batch_date}','yyyymmdd')
   and cbb.end_dt > to_date('${batch_date}','yyyymmdd')
   and pte.start_dt <= to_date('${batch_date}','yyyymmdd')
   and pte.end_dt > to_date('${batch_date}','yyyymmdd')
   and pts.start_dt <= to_date('${batch_date}','yyyymmdd')
   and pts.end_dt > to_date('${batch_date}','yyyymmdd')
   and brd.start_dt <= to_date('${batch_date}','yyyymmdd')
   and brd.end_dt > to_date('${batch_date}','yyyymmdd')
 group by brd.pntinr, cbb.cur
 union all
select brd.pntinr,
  		 sum(cbb.amt) bramt,
  		 cbb.cur brcur
  from ${iol_schema}.isbs_pte pte,
       ${iol_schema}.isbs_cbb cbb,
       ${iol_schema}.isbs_pts pts,
       ${iol_schema}.isbs_brd brd
 where pts.objtyp = 'BRD'
   and pts.objinr = brd.inr
   and brd.pnttyp = 'LID'
   and pts.rol = 'INI'
   and cbb.objtyp = 'PTE'
   and cbb.objinr = pte.inr
   and cbb.extid = 'AMT1'
   and pte.objtyp = 'PTS'
   and pte.objinr = pts.inr
   and pte.cbtpfx in ('AKZ', 'INT')
   and cbb.enddat > to_date('${batch_date}','yyyymmdd')
   and cbb.begdat <= to_date('${batch_date}','yyyymmdd')
   and cbb.start_dt <= to_date('${batch_date}','yyyymmdd')
   and cbb.end_dt > to_date('${batch_date}','yyyymmdd')
   and pte.start_dt <= to_date('${batch_date}','yyyymmdd')
   and pte.end_dt > to_date('${batch_date}','yyyymmdd')
   and pts.start_dt <= to_date('${batch_date}','yyyymmdd')
   and pts.end_dt > to_date('${batch_date}','yyyymmdd')
   and brd.start_dt <= to_date('${batch_date}','yyyymmdd')
   and brd.end_dt > to_date('${batch_date}','yyyymmdd')
 group by brd.pntinr, cbb.cur;

-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_02
nologging
compress ${option_switch} for query high
as
select bdd.pntinr,
   									 sum(cbb.amt) bramt,
   									 cbb.cur brcur
 							 from ${iol_schema}.isbs_pte pte,
 							      ${iol_schema}.isbs_cbb cbb,
 							      ${iol_schema}.isbs_pts pts,
 							      ${iol_schema}.isbs_bdd bdd --modify by zqh
 							where pts.objtyp = 'BDD'
 							  and pts.objinr = bdd.inr
 							  and bdd.pnttyp = 'DID'
 							  and pts.rol = 'APL'
 							  and cbb.objtyp = 'PTE'
 							  and cbb.objinr = pte.inr
 							  and cbb.extid = 'AMT1'
 							  and pte.objtyp = 'PTS'
 							  and pte.objinr = pts.inr
 							  and pte.cbtpfx in ('AKZ', 'INT')
 							  and cbb.enddat > to_date('${batch_date}','yyyymmdd')
 							  and cbb.begdat <= to_date('${batch_date}','yyyymmdd')
 							  and cbb.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and cbb.end_dt > to_date('${batch_date}','yyyymmdd')
    						and pte.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and pte.end_dt > to_date('${batch_date}','yyyymmdd')
    						and pts.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and pts.end_dt > to_date('${batch_date}','yyyymmdd')
    						and bdd.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and bdd.end_dt > to_date('${batch_date}','yyyymmdd')
 							group by bdd.pntinr, cbb.cur
 union all
select bdd.pntinr,
   									 sum(cbb.amt) bramt,
   									 cbb.cur brcur
 							 from ${iol_schema}.isbs_pte pte,
 							      ${iol_schema}.isbs_cbb cbb,
 							      ${iol_schema}.isbs_pts pts,
 							      ${iol_schema}.isbs_bdd bdd --modify by zqh
 							where pts.objtyp = 'BDD'
 							  and pts.objinr = bdd.inr
 							  and bdd.pnttyp = 'DID'
 							  and pts.rol = 'INI'
 							  and cbb.objtyp = 'PTE'
 							  and cbb.objinr = pte.inr
 							  and cbb.extid = 'AMT1'
 							  and pte.objtyp = 'PTS'
 							  and pte.objinr = pts.inr
 							  and pte.cbtpfx in ('AKZ', 'INT')
 							  and cbb.enddat > to_date('${batch_date}','yyyymmdd')
 							  and cbb.begdat <= to_date('${batch_date}','yyyymmdd')
 							  and cbb.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and cbb.end_dt > to_date('${batch_date}','yyyymmdd')
    						and pte.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and pte.end_dt > to_date('${batch_date}','yyyymmdd')
    						and pts.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and pts.end_dt > to_date('${batch_date}','yyyymmdd')
    						and bdd.start_dt <= to_date('${batch_date}','yyyymmdd')
    						and bdd.end_dt > to_date('${batch_date}','yyyymmdd')
 							group by bdd.pntinr, cbb.cur;


-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_03
nologging
compress ${option_switch} for query high
as
select coalesce(trim(t3.sellbl_prod_id), t4.sellbl_prod_id,t2.base_prod_id) as prod_id,
       t1.amt_type_cd as amt_type_cd,
       t1.subj_id as pric_subj_id
  from ${iml_schema}.fin_accti_subj_rela_h t1
 inner join ${iml_schema}.fin_accti_prod_rela_info t2
    on t1.accti_id = t2.accti_id
   and t1.sob_id = t2.sob_id
   and t2.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   and t2.job_cd = 'tglsi1'
  left join ${iml_schema}.prd_prod_catlg_h	t3
    on t2.base_prod_id = t3.sellbl_prod_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   and t3.job_cd = 'ncbsf1'
  left join ${iml_schema}.prd_prod_catlg_h	t4
    on t2.base_prod_id = t4.base_prod_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   and t4.job_cd = 'ncbsf1'
   and trim(t4.sellbl_prod_id) is not null
   and t4.sellbl_prod_id not in (select distinct pkp.paracd
                                  from ${iol_schema}.tgls_pcmc_knp_para pkp
                                 where pkp.subscd = 'RB'
                                   and pkp.paratp = 'RB_NCBS_LOANP1_ASSIS1'
                                   and pkp.paracd != '%'
                                   and pkp.start_dt <= to_date('${batch_date}', 'YYYYMMDD')
                                   and pkp.end_dt > to_date('${batch_date}', 'YYYYMMDD')
                                )
 where t1.sob_id = 2
   and t1.job_cd = 'tglsf1'
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t1.bus_type_cd in ('NCBS', 'LN', 'BDMX', 'IFSX', 'ISBX')
   and t2.base_prod_id not like '5%'  --手续费
   and t1.bus_type_cd = 'ISBX'
   and t1.amt_type_cd in ('PRI', 'TYJE006', 'TYJE007', 'TYJE001', 'ISBX001', 'TYJE007', 'ISBX002','ISBX003', 'ISBX004', 'ISBX006', 'TYJE999', 'BAL')
 ;


-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_05
nologging
compress ${option_switch} for query high
as
select t1.inr, sum(nvl(trn.reloriamt, 0)) as acpty_tot
  from ${iol_schema}.isbs_lid t1
  left join ${iol_schema}.isbs_brd brd
    on brd.pntinr = t1.inr
   and brd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and brd.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_trn trn
    on trn.objtyp = 'BRD'
   and trn.objinr = brd.inr
   and trn.inifrm = 'BRTUDP'
   and trn.relflg = 'R'
   and trn.start_dt <= to_date('${batch_date}','yyyymmdd')
   and trn.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 group by t1.inr
;


--第一组（共四组）进口信用证（国际）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_acct_info_ex(
   etl_dt	                                                                -- 数据日期
   ,lp_id	                                                                -- 法人编号
   ,acct_id	                                                                -- 账户编号
   ,lc_id	                                                                -- 信用证编号
   ,issue_bank_lc_id	                                                    -- 开证行信用证编号
   ,std_prod_id							                                    -- 标准产品编号
   ,dubil_num	                                                            -- 借据号
   ,cust_id	                                                                -- 客户编号
   ,cpty_cust_id	                                                        -- 对手客户编号
   ,stl_acct_num	                                                        -- 结算帐号
   ,subj_id	                                                                -- 科目编号
   ,fwd_flg	                                                                -- 远期标志
   ,circl_flg	                                                            -- 循环标志
   ,mx_lc_flg	                                                            -- 进出口信用证标志
   ,elec_lc_flg                                                             -- 电子信用证标志
   ,lc_type_cd	                                                            -- 信用证类型代码
   ,lc_pay_type_cd   				                                        -- 信用证支付类型代码
   ,trade_type_cd                                                           -- 贸易类型代码
   ,issue_chn_cd	                                                        -- 开证渠道代码
   ,bus_breed_id	                                                        -- 业务品种编号
   ,lc_status_cd	                                                        -- 信用证状态代码
   ,issue_bank_cfm_status_cd	                                            -- 开证行保兑状态代码
   ,inpwn_type_cd                                                           -- 质押类型代码
   ,curr_cd	                                                                -- 币种代码
   ,oper_teller_id	                                                        -- 经办柜员编号
   ,check_teller_id                                                         -- 复核柜员编号
   ,check_teller_name                                                       -- 复核柜员名称
   ,sign_org_id	                                                            -- 签署机构编号
   ,mgmt_org_id	                                                            -- 管理机构编号
   ,acct_instit_id	                                                        -- 账务机构编号
   ,oper_org_id	                                                            -- 经办机构编号
   ,effect_dt	                                                            -- 生效日期
   ,wrtoff_dt	                                                            -- 注销日期
   ,issue_dt	                                                            -- 开证日期
   ,exp_dt	                                                                -- 到期日期
   ,cfm_dt	                                                                -- 保兑日期
   ,issue_bank_bic                                                          -- 开证行BIC
   ,issue_bank_name	                                                        -- 开证行名称
   ,issue_bank_cn_name					                                    -- 开证行中文名称
   ,issue_bank_swiftcode				                                    -- 开证行SWIFTCODE
   ,advise_bank_bic                                                         -- 通知行BIC
   ,advise_bank_name	                                                    -- 通知行名称
   ,applit_name	                                                            -- 申请人名称
   ,benefc_name	                                                            -- 受益人名称
   ,benefc_cty_cd                                                           -- 受益人国家代码
   ,benefc_open_bank_name                                                   -- 受益人开户行名称
   ,benefc_open_bank_acct_num                                               -- 受益人开户行账号
   ,cargo_descb                                                             -- 货物描述
   ,open_bk_bic                                                             -- 代开行BIC
   ,open_bank_name						                                    -- 代开行名称
   ,cfm_bank_bic                                                            -- 保兑行BIC
   ,recv_bank_bic                                                           -- 收款行BIC
   ,pay_bank_bic                                                            -- 付款行BIC
   ,tran_cmplt_tm                                                           -- 交易完成时间
   ,usd_tran_amt                                                            -- 折美元交易金额
   ,fwd_tenor	                                                            -- 远期期限
   ,comm_fee_rat	                                                        -- 手续费费率
   ,comm_fee_amt	                                                        -- 手续费金额
   ,lc_higt_lmt	                                                            -- 信用证最高限额
   ,issue_amt	                                                            -- 开证金额
   ,acpty_tot							                                    -- 可承兑总额
   ,acpty_bal							                                    -- 可承兑余额
   ,lc_bal	                                                                -- 信用证余额
   ,cl_curr_lc_bal	                                                        -- 折本币信用证余额
   ,job_cd                                                                  -- 任务代码
   ,etl_timestamp                                                           -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                      -- 数据日期
   ,'9999'                                                                  -- 法人编号
   ,t1.inr                    			                                    -- 账户编号
   ,t1.ownref                                                               -- 信用证编号
   ,t1.ownref                                                               -- 开证行信用证编号
   ,bp.pdtcod5							                                    -- 标准产品编号
   ,t1.fincod                                                               -- 借据号
   ,nvl(trim(t2.extkey), t12.extkey)                                        -- 客户编号
   ,t35.extkey	                                                            -- 对手客户编号
   ,t10.acc                                                                 -- 结算帐号
   ,t20.pric_subj_id                                                        -- 科目编号
   ,decode(t1.tenmaxday, 0, '0', '1')                                       -- 远期标志
   ,nvl(trim(t1.revflg), '0')                                               -- 循环标志
   ,'I'                                                                     -- 进出口信用证标志
   ,''                                                                      -- 电子信用证标志
   ,trim(t1.lcrtyp)                                                         -- 信用证类型代码
   ,t1.avbby  							                                                -- 信用证支付类型代码
   ,nvl(trim(t1.tadtyp),'-')                                                -- 贸易类型代码
   ,decode(trim(t1.isstyp), null, 'D', trim(t1.isstyp))                     -- 开证渠道代码
   ,decode(trim(t1.dflg), 'D', '1', '2')                                    -- 业务品种编号
   ,case when trim(t1.clsdat) = to_date('00010101','yyyymmdd') then '01'    
   			 else '02' end                                                      -- 信用证状态代码
   ,t1.cnfdet                                                               -- 开证行保兑状态代码
   ,decode(trim(t1.zytyp), null, '-','1','10','2','20','3','30',t1.zytyp)   -- 质押类型代码
   ,nvl(t6.cur,'CNY')                                                       -- 币种代码
   ,t1.ownusr                                                               -- 经办柜员编号
   ,nvl(trim(t36.usr),' ')                                                  -- 复核柜员编号
   ,nvl(trim(t36.nam),' ')                                                  -- 复核柜员名称
   ,t3.branch                                                               -- 签署机构编号
   ,t3.branch                                                               -- 管理机构编号
   ,t3.branch                                                               -- 账务机构编号
   ,t4.branch                                                               -- 经办机构编号
   ,t1.credat							                                                  -- 生效日期
   ,t1.clsdat							                                                  -- 注销日期(闭卷日期)
   ,t1.opndat							                                                  -- 开证日期
   ,t1.expdat							                                                  -- 到期日期
   ,t1.expdat							                                                  -- 保兑日期
   ,t23.bic                                                                 -- 开证行BIC
   ,t19.nam                                                                 -- 开证行名称
   ,t19.nam1							                                                  -- 开证行中文名称
   ,t19.extkey							                                                -- 开证行SWIFTCODE
   ,t25.bic                                                                 -- 通知行BIC
   ,t1.advnam                                                               -- 通知行名称
   ,t1.aplnam                                                               -- 申请人名称
   ,t1.bennam                                                               -- 受益人名称
   ,nvl(trim(t34.txt),t1.stacty)                                            -- 受益人国家代码
   ,trim(t35.issbaninf)                                                     -- 受益人开户行名称
   ,trim(t35.extact)                                                        -- 受益人开户行账号
   ,t13.lcrgod                                                              -- 货物描述
   ,t22.bic                                                                 -- 代开行BIC
   ,t14.nam								                                                  -- 代开行名称
   ,t27.bic                                                                 -- 保兑行BIC
   ,t30.bic                                                                 -- 收款行BIC
   ,t33.bic                                                                 -- 付款行BIC
   ,t5.cpldattim                                                            -- 交易完成时间
   ,decode(t5.reloricur, 'USD', t5.reloriamt, round(t5.relamt * t5.rat, 2)) -- 折美元交易金额
   ,t1.tenmaxday                                                            -- 远期期限
   ,nvl(t9.ratcal, 0)                                                       -- 手续费费率
   ,nvl(t9.xrfamt, 0)                                                       -- 手续费金额
   ,nvl(t6.amt, 0)                                                          -- 信用证最高限额
   ,nvl(t15.amt, 0)                                                         -- 开证金额
   ,trn5.acpty_tot  as acpty_tot                                            -- 可承兑总额
   ,nvl(t16.amt, 0) + nvl(t17.bramt, 0)	                                    -- 可承兑余额
   ,nvl(t8.amt, 0)                                                          -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                         -- 折本币信用证余额
   ,'isbsf1'                                                                -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')         -- etl处理时间戳
   from ${iol_schema}.isbs_lid t1
   left join ${icl_schema}.temp_cmm_lc_acct_info_05 trn5
     on t1.inr = trn5.inr
   left join ${iol_schema}.isbs_pts t2
     on t2.objinr = t1.inr
    and t2.objtyp = 'LID' and t2.rol='APL'  --申请人
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t35
     on t35.objinr = t1.inr
    and t35.objtyp = 'LID' and t35.rol='BEN'  --受益人
    and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t35.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t21
     on t21.objinr = t1.inr
    and t21.objtyp = 'LID' and t21.rol='INI'  --中间银行
    and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t21.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t3
     on t1.branchinr = t3.inr
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t4
     on t1.bchkeyinr = t4.inr
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join(select t.*,r.rat
	             from iol.isbs_trn t
              inner join iol.isbs_rat r
                 on r.mon = (select max(mon) from iol.isbs_rat where cur = 'CNY' and mon <= to_char(t.cpldattim, 'yyyymm'))
                and r.CUR = 'CNY'
                and r.start_dt <= to_date('${batch_date}','yyyymmdd')
                and r.end_dt > to_date('${batch_date}','yyyymmdd')
              where t.objtyp = 'LID' and t.inifrm in ( 'LITOPN','DITOPN') and t.relflg = 'R' and t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
            )t5
     on t5.objinr = t1.inr
   left join ${iol_schema}.isbs_cbe t6
     on t6.objinr = t1.inr and t6.trninr = t5.inr
    and t6.objtyp = 'LID' and T6.extid = 'AMT1' and t6.cbt = 'MAXAMT' and t6.amt>0
    and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pte t7
     on t7.objinr = t2.inr
    and t7.objtyp = 'PTS' and t7.extid like 'AVL%' and T7.subid='001' and T7.inr<>'00000277'
    and t7.start_dt <= to_date ('${batch_date}','yyyymmdd')
    and t7.end_dt > to_date ('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pte t71
     on t71.objinr = t21.inr
    and t71.objtyp = 'PTS' and t71.extid like 'AVL%' and T71.subid='001' and T71.inr<>'00000277'
    and t71.start_dt <= to_date ('${batch_date}','yyyymmdd')
    and t71.end_dt > to_date ('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t8
     on t8.objinr = nvl(t7.inr, t71.inr)
    and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
    and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join (select dontrninr, max(ratcal) as ratcal, sum(nvl(xrfamt, 0)) as xrfamt
   							from ${iol_schema}.isbs_fep
  						 where extkey like '%LIOPN%'
  						   and start_dt <= to_date('${batch_date}', 'yyyymmdd')
  						   and end_dt > to_date('${batch_date}', 'yyyymmdd')
  						 group by dontrninr) t9
     on t9.dontrninr=t5.inr
   left join ${iol_schema}.isbs_cbe t10
     on t10.inr=t8.cbeinr
    and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t10.end_dt > to_date('${batch_date}','yyyymmdd')
	 left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
     on nvl(t6.cur, 'CNY') = t11.curr_cd
    and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t11.end_dt > to_date('${batch_date}','yyyymmdd')
    and t11.job_cd = 'ncbsf1'
   left join ${iol_schema}.isbs_pty t12
     on t2.ptyinr = t12.inr
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_lit t13
     on t2.inr = t13.inr
    and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t14
   	 on t1.inr = t14.objinr
    and t14.objtyp = 'LID'
  	and t14.rol = 'AGE'
  	and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t15
     on t15.objinr = t1.inr
    and t15.objtyp = 'LID'
    and t15.extid = 'AMT1'
    and t15.cbc = 'NOMSUM'
    and to_char(t15.enddat, 'yyyy') = '2299'
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t16
   	 on t16.objinr = t1.inr
   	and t16.objtyp = 'LID'
   	and t16.extid = 'AMT1'
   	and t16.cbc = 'OPN'
   	and t16.enddat > to_date('${batch_date}','yyyymmdd')
    and t16.begdat <= to_date('${batch_date}','yyyymmdd')
    and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t16.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${icl_schema}.temp_cmm_lc_acct_info_01 t17
 	   on t17.pntinr = t1.inr
   left join ${iol_schema}.isbs_pts t18
 	   on t1.inr = t18.objinr
 	  and t18.objtyp = 'LID'
   	and t18.rol = 'ISS'
 	  and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t18.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pty t19
 	   on t18.ptyinr = t19.inr
 	  and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t19.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bus_pdt bp
     on t1.inr = bp.objinr
    and bp.objtyp = 'LID'
   left join ${icl_schema}.temp_cmm_lc_acct_info_03 t20
     on bp.pdtcod5 = t20.prod_id
    and bp.amttypcod = t20.amt_type_cd
   left join ${iol_schema}.isbs_pta t22
     on t14.ptainr = t22.inr
    and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t22.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t23
     on t18.ptainr = t23.inr
    and t23.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t23.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t24
     on t1.inr = t24.objinr
    and t24.objtyp = 'LID'
    and t24.rol = 'ADV'
    and t24.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t24.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t25
     on t24.ptainr = t25.inr
    and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t25.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t26
     on t1.inr = t26.objinr
    and t26.objtyp = 'LID'
    and t26.rol = 'CMB'
    and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t26.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t27
     on t26.ptainr = t27.inr
    and t27.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t27.end_dt > to_date('${batch_date}','yyyymmdd')
   left join(select * from
                 (select b.*,(row_number()over(partition by b.pntinr order by b.inr desc)) as rn
                    from iol.isbs_brd b )
                where rn=1) t28
     on t28.pntinr = t1.inr
    and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t28.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t29
     on t28.inr = t29.objinr
    and t29.objtyp = 'BRD'
    and t29.rol = 'PRB'
    and t29.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t29.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t30
     on nvl(trim(t29.ptainr), t24.ptainr) = t30.inr
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t32
     on t1.inr = t32.objinr
    and t32.objtyp = 'LID'
    and t32.rol = 'RMB'
    and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t32.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t33
     on nvl(trim(t32.ptainr), t18.ptainr) = t33.inr
    and t33.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t33.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_stb t34
     on t1.stacty = t34.cod
    and t34.tbl = 'CTYCOD'
    and t34.uil = 'EN'
   left join ${iol_schema}.isbs_trs t36
    on t5.inr = t36.objinr
   and t36.objtyp = 'TRN'
   and t36.sigidx = 'SG2' -- 复核人  
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
  where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_06
nologging
compress ${option_switch} for query high
as
select t1.inr, sum(nvl(trn.reloriamt, 0)) as acpty_tot
  from ${iol_schema}.isbs_did t1
  left join ${iol_schema}.isbs_bdd bdd
    on bdd.pntinr = t1.inr
   and bdd.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and bdd.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_trn trn
    on trn.objtyp = 'BDD'
   and trn.objinr = bdd.inr
   and trn.inifrm = 'BDTUDP'
   and trn.relflg = 'R'
   and trn.start_dt <= to_date('${batch_date}','yyyymmdd')
   and trn.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 group by t1.inr
;

--第二组（共四组）进口信用证（国内）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_acct_info_ex(
   etl_dt	                                                                  -- 数据日期
   ,lp_id	                                                                  -- 法人编号
   ,acct_id	                                                                  -- 账户编号
   ,lc_id	                                                                  -- 信用证编号
   ,issue_bank_lc_id	                                                      -- 开证行信用证编号
   ,std_prod_id						                                  	      -- 标准产品编号
   ,dubil_num	                                                              -- 借据号
   ,cust_id	                                                                  -- 客户编号
   ,cpty_cust_id	                                                          -- 对手客户编号
   ,stl_acct_num	                                                          -- 结算帐号
   ,subj_id	                                                                  -- 科目编号
   ,fwd_flg	                                                                  -- 远期标志
   ,circl_flg	                                                              -- 循环标志
   ,mx_lc_flg	                                                              -- 进出口信用证标志
   ,elec_lc_flg                                                               -- 电子信用证标志
   ,lc_type_cd	                                                              -- 信用证类型代码
   ,lc_pay_type_cd   				                                  	      -- 信用证支付类型代码
   ,trade_type_cd                                                             -- 贸易类型代码
   ,issue_chn_cd	                                                          -- 开证渠道代码
   ,bus_breed_id	                                                          -- 业务品种编号
   ,lc_status_cd	                                                          -- 信用证状态代码
   ,issue_bank_cfm_status_cd	                                              -- 开证行保兑状态代码
   ,inpwn_type_cd                                                           -- 质押类型代码
   ,curr_cd	                                                                  -- 币种代码
   ,oper_teller_id	                                                          -- 经办柜员编号
   ,check_teller_id                                                           -- 复核柜员编号
   ,check_teller_name                                                         -- 复核柜员名称
   ,sign_org_id	                                                              -- 签署机构编号
   ,mgmt_org_id	                                                              -- 管理机构编号
   ,acct_instit_id	                                                          -- 账务机构编号
   ,oper_org_id	                                                              -- 经办机构编号
   ,effect_dt	                                                              -- 生效日期
   ,wrtoff_dt	                                                              -- 注销日期
   ,issue_dt	                                                              -- 开证日期
   ,exp_dt	                                                                  -- 到期日期
   ,cfm_dt	                                                                  -- 保兑日期
   ,issue_bank_bic                                                            -- 开证行BIC
   ,issue_bank_name	                                                          -- 开证行名称
   ,issue_bank_cn_name				                                          -- 开证行中文名称
   ,issue_bank_swiftcode			                                          -- 开证行SWIFTCODE
   ,advise_bank_bic                                                           -- 通知行BIC
   ,advise_bank_name	                                                      -- 通知行名称
   ,applit_name	                                                              -- 申请人名称
   ,benefc_name	                                                              -- 受益人名称
   ,benefc_cty_cd                                                             -- 受益人国家代码
   ,benefc_open_bank_name                                                     -- 受益人开户行名称
   ,benefc_open_bank_acct_num                                                 -- 受益人开户行账号
   ,cargo_descb                                                               -- 货物描述
   ,open_bk_bic                                                               -- 代开行BIC
   ,open_bank_name					                                          -- 代开行名称
   ,cfm_bank_bic                                                              -- 保兑行BIC
   ,recv_bank_bic                                                             -- 收款行BIC
   ,pay_bank_bic                                                              -- 付款行BIC
   ,tran_cmplt_tm                                                             -- 交易完成时间
   ,usd_tran_amt                                                              -- 折美元交易金额
   ,fwd_tenor	                                                              -- 远期期限
   ,comm_fee_rat	                                                          -- 手续费费率
   ,comm_fee_amt	                                                          -- 手续费金额
   ,lc_higt_lmt	                                                              -- 信用证最高限额
   ,issue_amt	                                                              -- 开证金额
   ,acpty_tot                                                                 -- 可承兑总额
   ,acpty_bal						                                          -- 可承兑余额
   ,lc_bal	                                                                  -- 信用证余额
   ,cl_curr_lc_bal	                                                          -- 折本币信用证余额
   ,job_cd                                                                    -- 任务代码
   ,etl_timestamp                                                             -- etl处理时间戳
)                                                                             
select                                                                        
   to_date('${batch_date}','yyyymmdd')                                        -- 数据日期
   ,'9999'                                                                    -- 法人编号
   ,t1.inr              				                                      -- 账户编号
   ,t1.ownref                                                                 -- 信用证编号
   ,t1.ownref                                                                 -- 开证行信用证编号
   ,bp.pdtcod5							                                      -- 标准产品编号
   ,t1.fincod                                                                 -- 借据号
   ,nvl(trim(t2.extkey), t12.extkey)                                          -- 客户编号
   ,t35.extkey	                                                              -- 对手客户编号
   ,t10.acc                                                                   -- 结算帐号
   ,t20.pric_subj_id                                                          -- 科目编号
   ,decode(t1.tenmaxday, 0, '0', '1')                                         -- 远期标志
   ,nvl(trim(t1.revflg), '0')                                                 -- 循环标志
   ,'DI'                                                                      -- 进出口信用证标志
   ,decode(t1.elcflg,'Y','1','N','0','-')                                     -- 电子信用证标志
   ,trim(t1.lcrtyp)                                                           -- 信用证类型代码
   ,t1.avbby  							                                      -- 信用证支付类型代码
   ,nvl(trim(t1.tadtyp),'-')                                                  -- 贸易类型代码
   ,decode(trim(t1.isstyp), null, 'D', trim(t1.isstyp))                       -- 开证渠道代码
   ,'1'															              -- 业务品种编号
   ,case when trim(t1.clsdat) = to_date('00010101','yyyymmdd') then '01'
   			else '02' end                                                     -- 信用证状态代码
   ,t1.cnfdet                                                                 -- 开证行保兑状态代码
   ,decode(trim(t1.zytyp), null, '-','1','10','2','20','3','30',t1.zytyp)   -- 质押类型代码
   ,nvl(t6.cur,'CNY')                                                         -- 币种代码
   ,t1.ownusr                                                                 -- 经办柜员编号
   ,nvl(trim(t36.usr),' ')                                                    -- 复核柜员编号
   ,nvl(trim(t36.nam),' ')                                                    -- 复核柜员名称
   ,t3.branch                                                                 -- 签署机构编号
   ,t3.branch                                                                 -- 管理机构编号
   ,t3.branch                                                                 -- 账务机构编号
   ,t4.branch                                                                 -- 经办机构编号
   ,t1.credat							                                      -- 生效日期
   ,t1.clsdat							                                      -- 注销日期(闭卷日期)
   ,t1.opndat							                                      -- 开证日期
   ,t1.expdat							                                      -- 到期日期
   ,t1.expdat							                                      -- 保兑日期
   ,t23.bic                                                                   -- 开证行BIC
   ,t19.nam                                                                   -- 开证行名称
   ,t19.nam1							                                      -- 开证行中文名称
   ,t19.extkey							                                      -- 开证行SWIFTCODE
   ,t25.bic                                                                   -- 通知行BIC
   ,t1.advnam                                                                 -- 通知行名称
   ,t1.aplnam                                                                 -- 申请人名称
   ,t1.bennam                                                                 -- 受益人名称
   ,nvl(trim(t34.txt),t1.stacty)                                              -- 受益人国家代码
   ,trim(t35.issbaninf)                                                       -- 受益人开户行名称
   ,trim(t35.extact)                                                          -- 受益人开户行账号
   ,t13.lcrgod                                                                -- 货物描述
   ,t22.bic                                                                   -- 代开行BIC
   ,t14.nam								                                      -- 代开行名称
   ,t27.bic                                                                   -- 保兑行BIC
   ,t30.bic                                                                   -- 收款行BIC
   ,t33.bic                                                                   -- 付款行BIC
   ,t5.cpldattim                                                              -- 交易完成时间
   ,decode(t5.reloricur, 'USD', t5.reloriamt, round(t5.relamt * t5.rat, 2))   --折美元交易金额
   ,t1.tenmaxday                                                              -- 远期期限
   ,nvl(t9.ratcal, 0)                                                         -- 手续费费率
   ,nvl(t9.xrfamt, 0)                                                         -- 手续费金额
   ,nvl(t6.amt, 0)                                                            -- 信用证最高限额
   ,nvl(t15.amt, 0)                                                           -- 开证金额
   ,trn6.acpty_tot as acpty_tot                                               -- 可承兑付款总额
   ,nvl(t16.amt, 0) + nvl(t17.bramt, 0)	                                      -- 可承兑余额
   ,nvl(t8.amt, 0)                                                            -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                           -- 折本币信用证余额
   ,'isbsf1'                                                                  -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
   from ${iol_schema}.isbs_did t1  -- modify by zqh
   left join ${icl_schema}.temp_cmm_lc_acct_info_06 trn6
     on t1.inr = trn6.inr
   left join ${iol_schema}.isbs_pts t2
     on t2.objinr = t1.inr
    and t2.objtyp = 'DID' and t2.rol='APL'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t35
     on t35.objinr = t1.inr
    and t35.objtyp = 'DID' and t35.rol='BEN'  --受益人
    and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t35.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t21
     on t21.objinr = t1.inr
    and t21.objtyp = 'DID' and t2.rol='INI'
    and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t21.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t3
     on t1.branchinr = t3.inr
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t4
     on t1.bchkeyinr = t4.inr
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join(select t.*,r.rat
	             from ${iol_schema}.isbs_trn t
              inner join ${iol_schema}.isbs_rat r
                 on r.mon = (select max(mon) from iol.isbs_rat where cur = 'CNY' and mon <= to_char(t.cpldattim, 'yyyymm'))
                and r.CUR = 'CNY'
                and r.start_dt <= to_date('${batch_date}','yyyymmdd')
                and r.end_dt > to_date('${batch_date}','yyyymmdd')
              where t.objtyp = 'DID' and t.inifrm in ( 'LITOPN','DITOPN') and t.relflg = 'R' and t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
            )t5
     on t5.objinr = t1.inr
   left join ${iol_schema}.isbs_cbe t6
     on t6.objinr = t1.inr and t6.trninr = t5.inr
    and t6.objtyp = 'DID' and T6.extid = 'AMT1' and t6.cbt = 'MAXAMT' and t6.amt>0
    and t6.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t6.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pte t7
     on t7.objinr = t2.inr
    and t7.objtyp = 'PTS' and t7.extid like 'AVL%' and T7.subid='001' and T7.inr<>'00000277'
    and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pte t71
     on t71.objinr = t21.inr
    and t71.objtyp = 'PTS' and t71.extid like 'AVL%' and T71.subid='001' and T71.inr<>'00000277'
    and t71.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t71.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t8
     on t8.objinr = nvl(t7.inr,t71.inr)
    and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
    and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join (select dontrninr, max(ratcal) as ratcal, sum(nvl(xrfamt, 0)) as xrfamt
   							from ${iol_schema}.isbs_fep
  						 where extkey like '%LIOPN%'
  						   and start_dt <= to_date('${batch_date}', 'yyyymmdd')
  						   and end_dt > to_date('${batch_date}', 'yyyymmdd')
  						 group by dontrninr) t9
     on t9.dontrninr=t5.inr
   left join ${iol_schema}.isbs_cbe t10
     on t10.inr=t8.cbeinr
    and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
     on nvl(t6.cur, 'CNY') = t11.curr_cd
    --and t11.dt = to_date('${batch_date}','yyyymmdd')
    and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t11.end_dt > to_date('${batch_date}','yyyymmdd')
    and t11.job_cd = 'ncbsf1'
   left join ${iol_schema}.isbs_pty t12
     on t2.ptyinr = t12.inr
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t12.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_dit t13  --modify by zqh
     on t2.inr = t13.inr
    and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t13.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t14
   	 on t1.inr = t14.objinr
    and t14.objtyp = 'DID'
  	and t14.rol = 'AGE'
  	and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t15
     on t15.objinr = t1.inr
    and t15.objtyp = 'DID'
    and t15.extid = 'AMT1'
    and t15.cbc = 'NOMSUM'
    and to_char(t15.enddat, 'yyyy') = '2299'
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t16
   	 on t16.objinr = t1.inr
   	and t16.objtyp = 'DID'
   	and t16.extid = 'AMT1'
   	and t16.cbc = 'OPN'
   	and t16.enddat > to_date('${batch_date}','yyyymmdd')
    and t16.begdat <= to_date('${batch_date}','yyyymmdd')
    and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t16.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${icl_schema}.temp_cmm_lc_acct_info_02 t17
 		 on t17.pntinr = t1.inr
 	 left join ${iol_schema}.isbs_pts t18
 	 	 on t1.inr = t18.objinr
 	 	and t18.objtyp = 'DID'
 	 	and t18.rol = 'ISS'
 	 	and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t18.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pty t19
 	 	 on t18.ptyinr = t19.inr
 	 	and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t19.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bus_pdt bp
     on t1.inr = bp.objinr
    and bp.objtyp = 'DID'
   left join ${icl_schema}.temp_cmm_lc_acct_info_03 t20
     on bp.pdtcod5 = t20.prod_id
    and bp.amttypcod = t20.amt_type_cd
   left join ${iol_schema}.isbs_pta t22
     on t14.ptainr = t22.inr
    and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t22.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t23
     on t18.ptainr = t23.inr
    and t23.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t23.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t24
     on t1.inr = t24.objinr
    and t24.objtyp = 'DID'
    and t24.rol = 'ADV'
    and t24.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t24.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t25
     on t24.ptainr = t25.inr
    and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t25.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t26
     on t1.inr = t26.objinr
    and t26.objtyp = 'DID'
    and t26.rol = 'CMB'
    and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t26.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t27
     on t26.ptainr = t27.inr
    and t27.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t27.end_dt > to_date('${batch_date}','yyyymmdd')
   left join(select * from
                 (select b.*,(row_number()over(partition by b.pntinr order by b.inr desc)) as rn
                    from iol.isbs_brd b )
                where rn=1) t28
     on t28.pntinr = t1.inr
    and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t28.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t29
     on t28.inr = t29.objinr
    and t29.objtyp = 'BDD'
    and t29.rol = 'PRB'
    and t29.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t29.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t30
     on nvl(trim(t29.ptainr), t24.ptainr) = t30.inr
    and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t30.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pts t32
     on t1.inr = t32.objinr
    and t32.objtyp = 'DID'
    and t32.rol = 'RMB'
    and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t32.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_pta t33
     on nvl(trim(t32.ptainr), t18.ptainr) = t33.inr
    and t33.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t33.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_stb t34
   	 on t1.stacty=t34.cod
   	and t34.tbl='CTYCOD'
   	and t34.uil='EN'
   left join ${iol_schema}.isbs_trs t36
    on t5.inr = t36.objinr
   and t36.objtyp = 'TRN'
   and t36.sigidx = 'SG2' -- 复核人  
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
  where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

whenever sqlerror exit sql.sqlcode;
-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_04
nologging
compress ${option_switch} for query high
as
select t7.inr AS pte_inr, t2.*
  from ${iol_schema}.isbs_pts t2
 inner join ${iol_schema}.isbs_pte t7
   on t7.objinr = t2.inr
   and t7.objtyp = 'PTS' and t7.extid like 'AVS%' and t7.subid='002' and t7.inr <> '00000277'
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join ${iol_schema}.isbs_cbe t72
   on t72.inr =(select max(inr) from iol.isbs_cbe where objtyp='PTE' and objinr=t7.inr  and start_dt <= to_date('${batch_date}', 'yyyymmdd') and end_dt > to_date('${batch_date}', 'yyyymmdd'))
  and t72.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t72.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t2.objtyp = 'LED' and t2.rol='BEN'
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

whenever sqlerror exit sql.sqlcode;
-- 创建临时表
create table ${icl_schema}.temp_cmm_lc_acct_info_041
nologging
compress ${option_switch} for query high
as
select t71.inr AS pte_inr, t21.*
  from ${iol_schema}.isbs_pts t21
 inner join ${iol_schema}.isbs_pte t71
    on t71.objinr = t21.inr
   and t71.objtyp = 'PTS' and t71.extid like 'AVS%' and t71.subid='002' and t71.inr <> '00000277'
   and t71.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t71.end_dt > to_date('${batch_date}', 'yyyymmdd')
 inner join ${iol_schema}.isbs_cbe t73
    on t73.inr =(select max(inr) from iol.isbs_cbe where objtyp='PTE' and objinr=t71.inr  and start_dt <= to_date('${batch_date}', 'yyyymmdd') and end_dt > to_date('${batch_date}', 'yyyymmdd'))
   and t73.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t73.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t21.objtyp = 'LED' and t21.rol='INI'
   and t21.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
;

-- 第三组（共四组）出口信用证（国际）
insert /*+ append */ into ${icl_schema}.cmm_lc_acct_info_ex(
   etl_dt                                                                     -- 数据日期
   ,lp_id                                                                     -- 法人编号
   ,acct_id                                                                   -- 账户编号
   ,lc_id                                                                     -- 信用证编号
   ,issue_bank_lc_id                                                          -- 开证行信用证编号
   ,std_prod_id 				                                              -- 标准产品编号
   ,dubil_num                                                                 -- 借据号
   ,cust_id                                                                   -- 客户编号
   ,cpty_cust_id	                                                          -- 对手客户编号
   ,stl_acct_num                                                              -- 结算帐号
   ,subj_id                                                                   -- 科目编号
   ,fwd_flg                                                                   -- 远期标志
   ,circl_flg                                                                 -- 循环标志
   ,mx_lc_flg                                                                 -- 进出口信用证标志
   ,elec_lc_flg                                                               -- 电子信用证标志
   ,lc_type_cd                                                                -- 信用证类型代码
   ,lc_pay_type_cd   			                                              -- 信用证支付类型代码
   ,trade_type_cd                                                             -- 贸易类型代码
   ,issue_chn_cd                                                              -- 开证渠道代码
   ,bus_breed_id                                                              -- 业务品种编号
   ,lc_status_cd                                                              -- 信用证状态代码
   ,issue_bank_cfm_status_cd                                                  -- 开证行保兑状态代码
   ,inpwn_type_cd                                                             -- 质押类型代码
   ,curr_cd                                                                   -- 币种代码
   ,oper_teller_id                                                            -- 经办柜员编号
   ,check_teller_id                                                           -- 复核柜员编号
   ,check_teller_name                                                         -- 复核柜员名称
   ,sign_org_id                                                               -- 签署机构编号
   ,mgmt_org_id                                                               -- 管理机构编号
   ,acct_instit_id                                                            -- 账务机构编号
   ,oper_org_id                                                               -- 经办机构编号
   ,effect_dt                                                                 -- 生效日期
   ,wrtoff_dt                                                                 -- 注销日期
   ,issue_dt                                                                  -- 开证日期
   ,exp_dt                                                                    -- 到期日期
   ,cfm_dt                                                                    -- 保兑日期
   ,issue_bank_bic                                                            -- 开证行BIC
   ,issue_bank_name                                                           -- 开证行名称
   ,issue_bank_cn_name			                                              -- 开证行中文名称
   ,issue_bank_swiftcode		                                              -- 开证行SWIFTCODE
   ,advise_bank_bic                                                           -- 通知行BIC
   ,advise_bank_name                                                          -- 通知行名称
   ,applit_name                                                               -- 申请人名称
   ,benefc_name                                                               -- 受益人名称
   ,benefc_cty_cd                                                             -- 受益人国家代码
   ,benefc_open_bank_name                                                     -- 受益人开户行名称
   ,benefc_open_bank_acct_num                                                 -- 受益人开户行账号
   ,cargo_descb                                                               -- 货物描述
   ,open_bk_bic                                                               -- 代开行BIC
   ,open_bank_name                                                            -- 代开行名称
   ,cfm_bank_bic                                                              -- 保兑行BIC
   ,recv_bank_bic                                                             -- 收款行BIC
   ,pay_bank_bic                                                              -- 付款行BIC
   ,tran_cmplt_tm                                                             -- 交易完成时间
   ,usd_tran_amt                                                              -- 折美元交易金额
   ,fwd_tenor                                                                 -- 远期期限
   ,comm_fee_rat                                                              -- 手续费费率
   ,comm_fee_amt                                                              -- 手续费金额
   ,lc_higt_lmt                                                               -- 信用证最高限额
   ,issue_amt                                                                 -- 开证金额
   ,acpty_tot                                                                 -- 可承兑总额
   ,acpty_bal					                                              -- 可承兑余额
   ,lc_bal                                                                    -- 信用证余额
   ,cl_curr_lc_bal                                                            -- 折本币信用证余额
   ,job_cd                                                                    -- 任务代码
   ,etl_timestamp                                                             -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                        -- 数据日期
   ,'9999'                                                                    -- 法人编号
   ,t1.inr                   			                                      -- 账户编号
   ,t1.ownref                                                                 -- 信用证编号
   ,t1.issref                                                                 -- 开证行信用证编号
   ,bp.pdtcod5							                                      -- 标准产品编号
   ,''                                                                        -- 借据号
   ,nvl(trim(t2.extkey), t12.extkey)                                          -- 客户编号
   ,t35.extkey	                                                              -- 对手客户编号
   ,t10.acc                                                                   -- 结算帐号
   ,t20.pric_subj_id                                                          -- 科目编号
   ,decode(trim(t1.tenmaxday), 0, '0', '1')                                   -- 远期标志
   ,nvl(trim(t1.revflg), '0')                                                 -- 循环标志
   ,'O'                                                                       -- 进出口信用证标志
   ,''                                                                        -- 电子信用证标志
   ,trim(t1.lcrtyp)                                                           -- 信用证类型代码
   ,t1.avbby                                                                  -- 信用证支付类型代码
   ,'-'                                                                       -- 贸易类型代码
   ,'I'                                                                       -- 开证渠道代码
   ,decode(t1.dflg, 'D', '1', '2')                                            -- 业务品种编号
   ,case when trim(t1.clsdat) = to_date('00010101','yyyymmdd') then '01'         
   			else '02' end                                                         -- 信用证状态代码
   ,t1.cnfdet                  					                                      -- 开证行保兑状态代码
   ,''                                                                        -- 质押类型代码
   ,nvl(t6.cur, 'CNY')         					                                      -- 币种代码
   ,t1.ownusr                  					                                      -- 经办柜员编号
   ,nvl(trim(t36.usr),' ')                                                    -- 复核柜员编号
   ,nvl(trim(t36.NAM),' ')                                                    -- 复核柜员名称
   ,t3.branch                  					                                      -- 签署机构编号
   ,t3.branch                  					                                      -- 管理机构编号
   ,t3.branch                  					                                      -- 账务机构编号
   ,t4.branch                  					                                      -- 经办机构编号
   ,t1.credat            			 					                                      -- 生效日期
   ,t1.clsdat            			 					                                      -- 注销日期
   ,t1.opndat            			 					                                      -- 开证日期
   ,t1.expdat            			 					                                      -- 到期日期
   ,t1.cnfdat            			 					                                      -- 保兑日期
   ,t23.bic                                                                   -- 开证行BIC
   ,nvl(trim(t1.issnam), t17.nam) 	                                          -- 开证行名称
   ,t17.nam1							                                      -- 开证行中文名称
   ,t17.extkey							                                      -- 开证行SWIFTCODE
   ,t25.bic                                                                   -- 通知行BIC
   ,''                         					                              -- 通知行名称
   ,''                         					                              -- 申请人名称
   ,t1.bennam                  					                              -- 受益人名称
   ,nvl(trim(t34.txt),t1.stacty)				                              -- 受益人国家代码
   ,trim(t37.issbaninf)                                                       -- 受益人开户行名称
   ,trim(t37.extact)                                                          -- 受益人开户行账号
   ,t13.lcrgod                 			  		                              -- 货物描述
   ,t22.bic                                                                   -- 代开行BIC
   ,t14.nam										                              -- 代开行名称
   ,t27.bic                                                                   -- 保兑行BIC
   ,t30.bic                                                                   -- 收款行BIC
   ,t33.bic                                                                   -- 付款行BIC
   ,t5.cpldattim                                                              -- 交易完成时间
   ,decode(t5.reloricur, 'USD', t5.reloriamt, round(t5.relamt * t5.rat, 2))   -- 折美元交易金额
   ,t1.tenmaxday               					                              -- 远期期限
   ,nvl(t9.ratcal, 0)           				                              -- 手续费费率
   ,nvl(t9.xrfamt, 0)           				                              -- 手续费金额
   ,nvl(t6.amt, 0)              				                              -- 信用证最高限额
   ,nvl(t15.amt, 0)             				                              -- 开证金额
   ,0                                                                         -- 可承兑总额
   ,0		  									                              -- 可承兑余额
   ,nvl(t8.amt, 0)              			                                  -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                           -- 折本币信用证余额
   ,'isbsf1'                                                                  -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iol_schema}.isbs_led t1
  left join ${icl_schema}.temp_cmm_lc_acct_info_04 t2
 	  on t2.objinr = t1.inr
  left join ${iol_schema}.isbs_pts t35
    on t35.objinr = t1.inr
   and t35.objtyp = 'LED' and t35.rol='APL'  --申请人
   and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t35.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t37
    on t37.objinr = t1.inr
   and t37.objtyp = 'LED' and t37.rol='BEN'  --申请人
   and t37.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t37.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${icl_schema}.temp_cmm_lc_acct_info_041 t21
   	on t21.objinr = t1.inr
  left join ${iol_schema}.isbs_bch t3
   	on t1.branchinr = t3.inr
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_bch t4
    on t1.bchkeyinr = t4.inr
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join(select t.*,r.rat
              from ${iol_schema}.isbs_trn t
             inner join ${iol_schema}.isbs_rat r
                on r.mon = (select max(mon) from iol.isbs_rat where cur = 'CNY' and mon <= to_char(t.cpldattim, 'yyyymm'))
               and r.CUR = 'CNY'
               and r.start_dt <= to_date('${batch_date}','yyyymmdd')
               and r.end_dt > to_date('${batch_date}','yyyymmdd')
             where t.objtyp = 'LED' and t.inifrm in ( 'LETOPN','DETOPN') and t.relflg = 'R' and t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
           )t5
    on t5.objinr = t1.inr
  left join ${iol_schema}.isbs_cbe t6
  	on t6.objinr = t1.inr and t6.trninr = t5.inr
   and t6.objtyp = 'LED' and T6.extid = 'AMT1' and t6.cbt = 'MAXAMT' and t6.amt>0
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_cbb t8
  	on t8.objinr = nvl(t2.pte_inr, t21.pte_inr)
   and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
 	 and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select dontrninr, max(ratcal) as ratcal, sum(nvl(xrfamt, 0)) as xrfamt
               from ${iol_schema}.isbs_fep
    					where extkey like '%DEOPN%'
    					  and start_dt <= to_date('${batch_date}', 'yyyymmdd')
    					  and end_dt > to_date('${batch_date}', 'yyyymmdd')
    					group by dontrninr)t9
    on t9.dontrninr=t5.inr
  left join ${iol_schema}.isbs_cbe t10
  	on t10.inr=t8.cbeinr
   and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
    on nvl(t6.cur, 'CNY') = t11.curr_cd
     --and t11.dt = to_date('${batch_date}','yyyymmdd')
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'ncbsf1'
  left join ${iol_schema}.isbs_pty t12
    on t2.ptyinr = t12.inr
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_let t13
    on t1.inr = t13.inr
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t14
    on t1.inr = t14.objinr
   and t14.objtyp = 'LED'
   and t14.rol = 'AGE'
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_cbb t15
    on t15.objinr = t1.inr
   and t15.objtyp = 'LED'
   and t15.extid = 'AMT1'
   and t15.cbc = 'NOMSUM'
   and to_char(t15.enddat, 'yyyy') = '2299'
   and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t15.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t16
  	on t1.inr = t16.objinr
   and t16.objtyp = 'LED'
   and t16.rol = 'ISS'
   and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t16.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pty t17
  	on t16.ptyinr = t17.inr
   and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t17.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_bus_pdt bp
    on t1.inr = bp.objinr
   and bp.objtyp = 'LED'
  left join ${icl_schema}.temp_cmm_lc_acct_info_03 t20
    on bp.pdtcod5 = t20.prod_id
   and bp.amttypcod = t20.amt_type_cd
  left join ${iol_schema}.isbs_pta t22
    on t14.ptainr = t22.inr
   and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t22.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t23
    on t16.ptainr = t23.inr
   and t23.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t23.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t24
    on t1.inr = t24.objinr
   and t24.objtyp = 'LED'
   and t24.rol = 'ADV'
   and t24.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t24.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t25
    on t24.ptainr = t25.inr
   and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t25.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t26
    on t1.inr = t26.objinr
   and t26.objtyp = 'LED'
   and t26.rol = 'CMB'
   and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t26.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t27
    on t26.ptainr = t27.inr
   and t27.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t27.end_dt > to_date('${batch_date}','yyyymmdd')
  left join(select * from
                (select b.*,(row_number()over(partition by b.pntinr order by b.inr desc)) as rn
                   from iol.isbs_brd b )
               where rn=1) t28
    on t28.pntinr = t1.inr
   and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t28.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t29
    on t28.inr = t29.objinr
   and t29.objtyp = 'BED'
   and t29.rol = 'PRB'
   and t29.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t29.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t30
    on nvl(trim(t29.ptainr), t24.ptainr) = t30.inr
   and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t30.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t32
    on t1.inr = t32.objinr
   and t32.objtyp = 'LED'
   and t32.rol = 'RMB'
   and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t32.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t33
    on nvl(trim(t32.ptainr), t16.ptainr) = t33.inr
   and t33.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t33.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_stb t34
  	on t1.stacty=t34.cod
   and t34.tbl='CTYCOD'
   and t34.uil='EN'
   left join ${iol_schema}.isbs_trs t36
    on t5.inr = t36.objinr
   and t36.objtyp = 'TRN'
   and t36.sigidx = 'SG2' -- 复核人  
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and (t2.inr is not null or t21.inr is not null)
;
commit;


-- 第四组（共四组）出口信用证（国内）
insert /*+ append */ into ${icl_schema}.cmm_lc_acct_info_ex(
   etl_dt                                                                     -- 数据日期
   ,lp_id                                                                     -- 法人编号
   ,acct_id                                                                   -- 账户编号
   ,lc_id                                                                     -- 信用证编号
   ,issue_bank_lc_id                                                          -- 开证行信用证编号
   ,std_prod_id					                                              -- 标准产品编号
   ,dubil_num                                                                 -- 借据号
   ,cust_id                                                                   -- 客户编号
   ,cpty_cust_id	                                                          -- 对手客户编号
   ,stl_acct_num                                                              -- 结算帐号
   ,subj_id                                                                   -- 科目编号
   ,fwd_flg                                                                   -- 远期标志
   ,circl_flg                                                                 -- 循环标志
   ,mx_lc_flg                                                                 -- 进出口信用证标志
   ,elec_lc_flg                                                               -- 电子信用证标志
   ,lc_type_cd                                                                -- 信用证类型代码
   ,lc_pay_type_cd   			                                              -- 信用证支付类型代码
   ,trade_type_cd                                                             -- 贸易类型代码
   ,issue_chn_cd                                                              -- 开证渠道代码
   ,bus_breed_id                                                              -- 业务品种编号
   ,lc_status_cd                                                              -- 信用证状态代码
   ,issue_bank_cfm_status_cd                                                  -- 开证行保兑状态代码
   ,inpwn_type_cd                                                             -- 质押类型代码
   ,curr_cd                                                                   -- 币种代码
   ,oper_teller_id                                                            -- 经办柜员编号
   ,check_teller_id                                                           -- 复核柜员编号
   ,check_teller_name                                                         -- 复核柜员名称
   ,sign_org_id                                                               -- 签署机构编号
   ,mgmt_org_id                                                               -- 管理机构编号
   ,acct_instit_id                                                            -- 账务机构编号
   ,oper_org_id                                                               -- 经办机构编号
   ,effect_dt                                                                 -- 生效日期
   ,wrtoff_dt                                                                 -- 注销日期
   ,issue_dt                                                                  -- 开证日期
   ,exp_dt                                                                    -- 到期日期
   ,cfm_dt                                                                    -- 保兑日期
   ,issue_bank_bic                                                            -- 开证行BIC
   ,issue_bank_name                                                           -- 开证行名称
   ,issue_bank_cn_name			                                              -- 开证行中文名称
   ,issue_bank_swiftcode		                                              -- 开证行SWIFTCODE
   ,advise_bank_bic                                                           -- 通知行BIC
   ,advise_bank_name                                                          -- 通知行名称
   ,applit_name                                                               -- 申请人名称
   ,benefc_name                                                               -- 受益人名称
   ,benefc_cty_cd                                                             -- 受益人国家代码
   ,benefc_open_bank_name                                                     -- 受益人开户行名称
   ,benefc_open_bank_acct_num                                                 -- 受益人开户行账号
   ,cargo_descb                                                               -- 货物描述
   ,open_bk_bic                                                               -- 代开行BIC
   ,open_bank_name                                                            -- 代开行名称
   ,cfm_bank_bic                                                              -- 保兑行BIC
   ,recv_bank_bic                                                             -- 收款行BIC
   ,pay_bank_bic                                                              -- 付款行BIC
   ,tran_cmplt_tm                                                             -- 交易完成时间
   ,usd_tran_amt                                                              -- 折美元交易金额
   ,fwd_tenor                                                                 -- 远期期限
   ,comm_fee_rat                                                              -- 手续费费率
   ,comm_fee_amt                                                              -- 手续费金额
   ,lc_higt_lmt                                                               -- 信用证最高限额
   ,issue_amt                                                                 -- 开证金额
   ,acpty_tot                                                                 -- 可承兑总额
   ,acpty_bal					                                              -- 可承兑余额
   ,lc_bal                                                                    -- 信用证余额
   ,cl_curr_lc_bal                                                            -- 折本币信用证余额
   ,job_cd                                                                    -- 任务代码
   ,etl_timestamp                                                             -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                        --数据日期
   ,'9999'                                                                    --法人编号
   ,t1.inr                   			                                      --账户编号
   ,t1.ownref                                                                 --信用证编号
   ,t1.issref                                                                 --开证行信用证编号
   ,bp.pdtcod5                                                                --标准产品编号
   ,''                                                                        --借据号
   ,nvl(trim(t2.extkey), t12.extkey)                                          --客户编号
   ,t35.extkey	                                                              --对手客户编号
   ,t10.acc                                                                   --结算帐号
   ,t20.pric_subj_id                                                          --科目编号
   ,decode(trim(t1.tenmaxday), 0, '0', '1')                                   --远期标志
   ,nvl(trim(t1.revflg), '0')                                                 --循环标志
   ,'DO'                                                                      --进出口信用证标志
   ,decode(t1.elcflg,'Y','1','N','0','-')                                     --电子信用证标志
   ,trim(t1.lcrtyp)                                                           --信用证类型代码
   ,t1.avbby                                                                  --信用证支付类型代码
   ,nvl(trim(t1.tadtyp),'-')                                                  --贸易类型代码
   ,'I'                                                                       --开证渠道代码
   ,'1'									                                      --业务品种编号
   ,case when trim(t1.clsdat) = to_date('00010101','yyyymmdd') then '01'
   			else '02' end                                                     -- 信用证状态代码
   ,t1.cnfdet                  					                              -- 开证行保兑状态代码
   ,''                                                                -- 质押类型代码
   ,nvl(t6.cur, 'CNY')         					                              -- 币种代码
   ,t1.ownusr                  					                              -- 经办柜员编号
   ,nvl(trim(t36.usr),' ')                                                    -- 复核柜员编号
   ,nvl(trim(t36.NAM),' ')                                                    -- 复核柜员名称
   ,t3.branch                  					                              -- 签署机构编号
   ,t3.branch                  					                              -- 管理机构编号
   ,t3.branch                  					                              -- 账务机构编号
   ,t4.branch                  					                              -- 经办机构编号
   ,t1.credat            			 			                              -- 生效日期
   ,t1.clsdat            			 			                              -- 注销日期
   ,t1.opndat            			 			                              -- 开证日期
   ,t1.expdat            			 			                              -- 到期日期
   ,t1.cnfdat            			 			                              -- 保兑日期
   ,t23.bic                                                                   -- 开证行BIC
   ,nvl(trim(t1.issnam), t17.nam)                                             -- 开证行名称
   ,t17.nam1									                              -- 开证行中文名称
   ,t17.extkey									                              -- 开证行SWIFTCODE
   ,t25.bic                                                                   -- 通知行BIC
   ,''                         					                              -- 通知行名称
   ,''                         					                              -- 申请人名称
   ,t1.bennam                  					                              -- 受益人名称
   ,nvl(trim(t34.txt),t1.stacty)     		                                  -- 受益人国家代码
   ,trim(t2.issbaninf)                                                        -- 受益人开户行名称
   ,trim(t2.extact)                                                           -- 受益人开户行账号
   ,t13.lcrgod                 					                              -- 货物描述
   ,t22.bic                                                                   -- 代开行BIC
   ,t14.nam									                                  -- 代开行名称
   ,t27.bic                                                                   -- 保兑行BIC
   ,t30.bic                                                                   -- 收款行BIC
   ,t33.bic                                                                   -- 付款行BIC
   ,t5.cpldattim                                                              -- 交易完成时间
   ,decode(t5.reloricur, 'USD', t5.reloriamt, round(t5.relamt * t5.rat, 2))   -- 折美元交易金额
   ,t1.tenmaxday               					                              -- 远期期限
   ,nvl(t9.ratcal, 0)           				                              -- 手续费费率
   ,nvl(t9.xrfamt, 0)           				                              -- 手续费金额
   ,nvl(t6.amt, 0)              				                              -- 信用证最高限额
   ,nvl(t15.amt, 0)             				                              -- 开证金额
   ,0                                                                         -- 可承兑总额
   ,0		  										 					      -- 可承兑余额
   ,nvl(t8.amt, 0)              				                              -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                           -- 折本币信用证余额
   ,'isbsf1'                                                                  -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
  from ${iol_schema}.isbs_ded t1
  left join ${iol_schema}.isbs_pts t2
  	 on t2.objinr = t1.inr
  	and t2.objtyp = 'DED' and t2.rol='BEN'
  	and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_pts t35
     on t35.objinr = t1.inr
    and t35.objtyp = 'DED' and t35.rol='APL'  --申请人
    and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t35.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t21
  	 on t21.objinr = t1.inr
  	and t21.objtyp = 'DED' and t21.rol='INI'
  	and t21.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_bch t3
  	 on t1.branchinr = t3.inr
  	and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_bch t4
  	 on t1.bchkeyinr = t4.inr
  	and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join(select t.*,r.rat
              from ${iol_schema}.isbs_trn t
             inner join ${iol_schema}.isbs_rat r
                on r.mon = (select max(mon) from iol.isbs_rat where cur = 'CNY' and mon <= to_char(t.cpldattim, 'yyyymm'))
               and r.CUR = 'CNY'
               and r.start_dt <= to_date('${batch_date}','yyyymmdd')
               and r.end_dt > to_date('${batch_date}','yyyymmdd')
             where t.objtyp = 'DED' and t.inifrm in ( 'LETOPN','DETOPN') and t.relflg = 'R' and t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
           )t5
    on t5.objinr = t1.inr
  left join ${iol_schema}.isbs_cbe t6
  	 on t6.objinr = t1.inr and t6.trninr = t5.inr
  	and t6.objtyp = 'DED' and T6.extid = 'AMT1' and t6.cbt = 'MAXAMT' and t6.amt>0
  	and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_pte t7
  	 on t7.objinr = t2.inr
  	and t7.objtyp = 'PTS' and t7.extid like 'AVS%' and t7.subid='002' and t7.inr <> '00000277'
  	and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_pte t71
  	 on t71.objinr = t21.inr
  	and t71.objtyp = 'PTS' and t71.extid like 'AVS%' and t71.subid='002' and t71.inr <> '00000277'
  	and t71.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t71.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.isbs_cbb t8
  	 on t8.objinr = nvl(t7.inr,t71.inr)
  	and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
  	and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select dontrninr, max(ratcal) as ratcal, sum(nvl(xrfamt, 0)) as xrfamt
     				  from ${iol_schema}.isbs_fep
    				   where extkey like '%DEOPN%'
    				     and start_dt <= to_date('${batch_date}', 'yyyymmdd')
    				     and end_dt > to_date('${batch_date}', 'yyyymmdd')
    				   group by dontrninr)t9
    on t9.dontrninr=t5.inr
  left join ${iol_schema}.isbs_cbe t10
  	 on t10.inr=t8.cbeinr
  	and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
    on nvl(t6.cur, 'CNY') = t11.curr_cd
     --and t11.dt = to_date('${batch_date}','yyyymmdd')
   and t11.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t11.end_dt > to_date('${batch_date}','yyyymmdd')
   and t11.job_cd = 'ncbsf1'
  left join ${iol_schema}.isbs_pty t12
    on t2.ptyinr = t12.inr
   and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t12.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_det t13   --modify by zqh
    on t1.inr = t13.inr
   and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t13.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t14
    on t1.inr = t14.objinr
   and t14.objtyp = 'DED'
   and t14.rol = 'AGE'
   and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t14.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_cbb t15
    on t15.objinr = t1.inr
   and t15.objtyp = 'DED'
   and t15.extid = 'AMT1'
   and t15.cbc = 'NOMSUM'
   and to_char(t15.enddat, 'yyyy') = '2299'
   and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t15.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t16
  	 on t1.inr = t16.objinr
  	and t16.objtyp = 'DED'
  	and t16.rol = 'ISS'
  	and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t16.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pty t17
  	 on t16.ptyinr = t17.inr
  	and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t17.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_bus_pdt bp
    on t1.inr = bp.objinr
   and bp.objtyp = 'DED'
  left join ${icl_schema}.temp_cmm_lc_acct_info_03 t20
    on bp.pdtcod5 = t20.prod_id
   and bp.amttypcod = t20.amt_type_cd
   /*left join ${icl_schema}.cmm_prod_and_subj_map_rela t20
     on bp.pdtcod5 = t20.sellbl_prod_id
    and t20.bus_type_cd = 'ISBX'
    and t20.etl_dt = to_date('${batch_date}', 'yyyymmdd')
   */
  left join ${iol_schema}.isbs_pta t22
    on t14.ptainr = t22.inr
   and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t22.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t23
    on t16.ptainr = t23.inr
   and t23.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t23.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t24
    on t1.inr = t24.objinr
   and t24.objtyp = 'DED'
   and t24.rol = 'ADV'
   and t24.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t24.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t25
    on t24.ptainr = t25.inr
   and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t25.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t26
    on t1.inr = t26.objinr
   and t26.objtyp = 'DED'
   and t26.rol = 'CMB'
   and t26.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t26.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t27
    on t26.ptainr = t27.inr
   and t27.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t27.end_dt > to_date('${batch_date}','yyyymmdd')
  left join(select * from
                (select b.*,(row_number()over(partition by b.pntinr order by b.inr desc)) as rn
                   from iol.isbs_brd b )
               where rn=1) t28
    on t28.pntinr = t1.inr
   and t28.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t28.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t29
    on t28.inr = t29.objinr
   and t29.objtyp = 'BMD'
   and t29.rol = 'PRB'
   and t29.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t29.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t30
    on nvl(trim(t29.ptainr), t24.ptainr) = t30.inr
   and t30.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t30.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pts t32
    on t1.inr = t32.objinr
   and t32.objtyp = 'DED'
   and t32.rol = 'RMB'
   and t32.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t32.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_pta t33
    on nvl(trim(t32.ptainr), t16.ptainr) = t33.inr
   and t33.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t33.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.isbs_stb t34
  	 on t1.stacty=t34.cod
  	and t34.tbl='CTYCOD'
  	and t34.uil='EN'
   left join ${iol_schema}.isbs_trs t36
    on t5.inr = t36.objinr
   and t36.objtyp = 'TRN'
   and t36.sigidx = 'SG2' -- 复核人  
   and t36.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t36.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_lc_acct_info_ex_02
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_lc_acct_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_acct_info_ex_02(
   etl_dt                                 -- 数据日期
   ,lp_id                                 -- 法人编号
   ,acct_id                               -- 账户编号
   ,lc_id                                 -- 信用证编号
   ,issue_bank_lc_id                      -- 开证行信用证编号
   ,std_prod_id                           -- 标准产品编号
   ,dubil_num                             -- 借据号
   ,cust_id                               -- 客户编号
   ,cpty_cust_id	                      -- 对手客户编号
   ,stl_acct_num                          -- 结算帐号
   ,subj_id                               -- 科目编号
   ,fwd_flg                               -- 远期标志
   ,circl_flg                             -- 循环标志
   ,mx_lc_flg                             -- 进出口信用证标志
   ,elec_lc_flg                           -- 电子信用证标志
   ,lc_type_cd                            -- 信用证类型代码
   ,lc_pay_type_cd                        -- 信用证支付类型代码
   ,trade_type_cd                         -- 贸易类型代码
   ,issue_chn_cd                          -- 开证渠道代码
   ,bus_breed_id                          -- 业务品种编号
   ,lc_status_cd                          -- 信用证状态代码
   ,issue_bank_cfm_status_cd              -- 开证行保兑状态代码
   ,inpwn_type_cd                         -- 质押类型代码
   ,curr_cd                               -- 币种代码
   ,oper_teller_id                        -- 经办柜员编号
   ,check_teller_id                       -- 复核柜员编号
   ,check_teller_name                     -- 复核柜员名称
   ,sign_org_id                           -- 签署机构编号
   ,mgmt_org_id                           -- 管理机构编号
   ,acct_instit_id                        -- 账务机构编号
   ,oper_org_id                           -- 经办机构编号
   ,effect_dt                             -- 生效日期
   ,wrtoff_dt                             -- 注销日期
   ,issue_dt                              -- 开证日期
   ,exp_dt                                -- 到期日期
   ,cfm_dt                                -- 保兑日期
   ,issue_bank_bic                        -- 开证行BIC
   ,issue_bank_name                       -- 开证行名称
   ,issue_bank_cn_name                    -- 开证行中文名称
   ,issue_bank_swiftcode                  -- 开证行SWIFTCODE
   ,advise_bank_bic                       -- 通知行BIC
   ,advise_bank_name                      -- 通知行名称
   ,applit_name                           -- 申请人名称
   ,benefc_name                           -- 受益人名称
   ,benefc_cty_cd                         -- 受益人国家代码
   ,benefc_open_bank_name                 -- 受益人开户行名称
   ,benefc_open_bank_acct_num             -- 受益人开户行账号
   ,cargo_descb                           -- 货物描述
   ,open_bk_bic                           -- 代开行BIC
   ,open_bank_name                        -- 代开行名称
   ,cfm_bank_bic                          -- 保兑行BIC
   ,recv_bank_bic                         -- 收款行BIC
   ,pay_bank_bic                          -- 付款行BIC
   ,tran_cmplt_tm                         -- 交易完成时间
   ,usd_tran_amt                          -- 折美元交易金额
   ,fwd_tenor                             -- 远期期限
   ,comm_fee_rat                          -- 手续费费率
   ,comm_fee_amt                          -- 手续费金额
   ,lc_higt_lmt                           -- 信用证最高限额
   ,issue_amt                             -- 开证金额
   ,acpty_tot                             -- 可承兑总额
   ,acpty_bal                             -- 可承兑余额
   ,lc_bal                                -- 信用证余额
   ,cl_curr_lc_bal                        -- 折本币信用证余额
   ,ear_d_bal                             -- 日初余额
   ,ear_m_bal                             -- 月初余额
   ,ear_s_bal                             -- 季初余额
   ,ear_y_bal                             -- 年初余额
   ,y_acm_bal                             -- 年累计余额
   ,s_acm_bal                             -- 季累计余额
   ,m_acm_bal                             -- 月累计余额
   ,cl_curr_ear_d_bal                     -- 折本币日初余额
   ,cl_curr_ear_m_bal                     -- 折本币月初余额
   ,cl_curr_ear_s_bal                     -- 折本币季初余额
   ,cl_curr_ear_y_bal                     -- 折本币年初余额
   ,cl_curr_y_acm_bal                     -- 折本币年累计余额
   ,cl_curr_ear_d_y_acm_bal               -- 折本币日初年累计余额
   ,cl_curr_ear_m_y_acm_bal               -- 折本币月初年累计余额
   ,cl_curr_ear_s_y_acm_bal               -- 折本币季初年累计余额
   ,cl_curr_ear_y_y_acm_bal               -- 折本币年初年累计余额
   ,cl_curr_s_acm_bal                     -- 折本币季累计余额
   ,cl_curr_ear_d_s_acm_bal               -- 折本币日初季累计余额
   ,cl_curr_ear_s_s_acm_bal               -- 折本币季初季累计余额
   ,cl_curr_ear_y_s_acm_bal               -- 折本币年初季累计余额
   ,cl_curr_m_acm_bal                     -- 折本币月累计余额
   ,cl_curr_ear_d_m_acm_bal               -- 折本币日初月累计余额
   ,cl_curr_ear_m_m_acm_bal               -- 折本币月初月累计余额
   ,cl_curr_ear_y_m_acm_bal               -- 折本币年初月累计余额
   ,y_avg_bal                             -- 年日均余额
   ,q_avg_bal                             -- 季日均余额
   ,m_avg_bal                             -- 月日均余额
   ,cl_curr_y_avg_bal                     -- 折本币年日均余额
   ,cl_curr_q_avg_bal                     -- 折本币季日均余额
   ,cl_curr_m_avg_bal                     -- 折本币月日均余额
   ,job_cd                                -- 任务代码
   ,etl_timestamp                         -- etl处理时间戳
)
select
   t1.etl_dt                           -- 数据日期
   ,t1.lp_id                           -- 法人编号
   ,t1.acct_id                         -- 账户编号
   ,t1.lc_id                           -- 信用证编号
   ,t1.issue_bank_lc_id                -- 开证行信用证编号
   ,t1.std_prod_id                     -- 标准产品编号
   ,t1.dubil_num                       -- 借据号
   ,t1.cust_id                         -- 客户编号
   ,t1.cpty_cust_id	                   -- 对手客户编号
   ,t1.stl_acct_num                    -- 结算帐号
   ,t1.subj_id                         -- 科目编号
   ,t1.fwd_flg                         -- 远期标志
   ,t1.circl_flg                       -- 循环标志
   ,t1.mx_lc_flg                       -- 进出口信用证标志
   ,t1.elec_lc_flg                     -- 电子信用证标志
   ,t1.lc_type_cd                      -- 信用证类型代码
   ,t1.lc_pay_type_cd                  -- 信用证支付类型代码
   ,t1.trade_type_cd                   -- 贸易类型代码
   ,t1.issue_chn_cd                    -- 开证渠道代码
   ,t1.bus_breed_id                    -- 业务品种编号
   ,t1.lc_status_cd                    -- 信用证状态代码
   ,t1.issue_bank_cfm_status_cd        -- 开证行保兑状态代码
   ,t1.inpwn_type_cd                   -- 质押类型代码
   ,t1.curr_cd                         -- 币种代码
   ,t1.oper_teller_id                  -- 经办柜员编号
   ,t1.check_teller_id                 -- 复核柜员编号
   ,t1.check_teller_name               -- 复核柜员名称   
   ,t1.sign_org_id                     -- 签署机构编号
   ,t1.mgmt_org_id                     -- 管理机构编号
   ,t1.acct_instit_id                  -- 账务机构编号
   ,t1.oper_org_id                     -- 经办机构编号
   ,t1.effect_dt                       -- 生效日期
   ,t1.wrtoff_dt                       -- 注销日期
   ,t1.issue_dt                        -- 开证日期
   ,t1.exp_dt                          -- 到期日期
   ,t1.cfm_dt                          -- 保兑日期
   ,t1.issue_bank_bic                  -- 开证行BIC
   ,t1.issue_bank_name                 -- 开证行名称
   ,t1.issue_bank_cn_name              -- 开证行中文名称
   ,t1.issue_bank_swiftcode            -- 开证行SWIFTCODE
   ,t1.advise_bank_bic                 -- 通知行BIC
   ,t1.advise_bank_name                -- 通知行名称
   ,t1.applit_name                     -- 申请人名称
   ,t1.benefc_name                     -- 受益人名称
   ,t1.benefc_cty_cd                   -- 受益人国家代码
   ,t1.benefc_open_bank_name           -- 受益人开户行名称
   ,t1.benefc_open_bank_acct_num       -- 受益人开户行账号
   ,t1.cargo_descb                     -- 货物描述
   ,t1.open_bk_bic                     -- 代开行BIC
   ,t1.open_bank_name                  -- 代开行名称
   ,t1.cfm_bank_bic                    -- 保兑行BIC
   ,t1.recv_bank_bic                   -- 收款行BIC
   ,t1.pay_bank_bic                    -- 付款行BIC
   ,t1.tran_cmplt_tm                   -- 交易完成时间
   ,t1.usd_tran_amt                    -- 折美元交易金额
   ,t1.fwd_tenor                       -- 远期期限
   ,t1.comm_fee_rat                    -- 手续费费率
   ,t1.comm_fee_amt                    -- 手续费金额
   ,t1.lc_higt_lmt                     -- 信用证最高限额
   ,t1.issue_amt                       -- 开证金额
   ,t1.acpty_tot                       -- 可承兑总额
   ,t1.acpty_bal                       -- 可承兑余额
   ,t1.lc_bal                          -- 信用证余额
   ,t1.cl_curr_lc_bal                  -- 折本币信用证余额
   ,nvl(t2.lc_bal, 0)                  -- 日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.lc_bal, 0) else nvl(t2.ear_m_bal, 0) end                                                                            -- 月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.lc_bal, 0) else nvl(t2.ear_s_bal, 0) end                                                  -- 季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.lc_bal, 0) else nvl(t2.ear_y_bal, 0) end                                                                          -- 年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.lc_bal, 0) else nvl(t2.y_acm_bal, 0) + nvl(t1.lc_bal, 0) end                                                      -- 年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.lc_bal, 0) else nvl(t2.s_acm_bal, 0) + nvl(t1.lc_bal, 0) end                              -- 季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.lc_bal, 0) else nvl(t2.m_acm_bal, 0) + nvl(t1.lc_bal, 0) end                                                        -- 月累计余额
   ,nvl(t2.cl_curr_lc_bal, 0)                                                                                                                                                    -- 折本币日初余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_lc_bal, 0) else nvl(t2.cl_curr_ear_m_bal, 0) end                                                            -- 折本币月初余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_lc_bal, 0) else nvl(t2.cl_curr_ear_s_bal, 0) end                                  -- 折本币季初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_lc_bal, 0) else nvl(t2.cl_curr_ear_y_bal, 0) end                                                          -- 折本币年初余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end  -- 折本币年累计余额
   ,nvl(t2.cl_curr_y_acm_bal, 0)                                                                                                                                                 -- 折本币日初年累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_y_acm_bal, 0) else nvl(t2.cl_curr_ear_m_y_acm_bal, 0) end                                                   -- 折本币月初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_y_acm_bal, 0) else nvl(t2.cl_curr_ear_s_y_acm_bal, 0) end                         -- 折本币季初年累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_y_acm_bal, 0) else nvl(t2.cl_curr_ear_y_y_acm_bal, 0) end                                                 -- 折本币年初年累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end  -- 折本币季累计余额
   ,nvl(t2.cl_curr_s_acm_bal, 0)                                                                                                                                                 -- 折本币日初季累计余额
   ,case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t2.cl_curr_s_acm_bal, 0) else nvl(t2.cl_curr_ear_s_y_acm_bal, 0) end                         -- 折本币季初季累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_s_acm_bal, 0) else nvl(t2.cl_curr_ear_y_s_acm_bal, 0) end                                                 -- 折本币年初季累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end  -- 折本币月累计余额
   ,nvl(t2.cl_curr_m_acm_bal, 0)                                                                                                                                                 -- 折本币日初月累计余额
   ,case when substr('${batch_date}',7,2) = '01' then nvl(t2.cl_curr_m_acm_bal, 0) else nvl(t2.cl_curr_ear_m_m_acm_bal, 0) end                                                   -- 折本币月初月累计余额
   ,case when substr('${batch_date}',5,4) = '0101' then nvl(t2.cl_curr_m_acm_bal, 0) else nvl(t2.cl_curr_ear_y_m_acm_bal, 0) end                                                 -- 折本币年初月累计余额
   ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.lc_bal, 0) else nvl(t2.y_acm_bal, 0) + nvl(t1.lc_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.lc_bal, 0) else nvl(t2.s_acm_bal, 0) + nvl(t1.lc_bal, 0) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.lc_bal, 0) else nvl(t2.m_acm_bal, 0) + nvl(t1.lc_bal, 0) end) / to_number(substr('${batch_date}', 7, 2)) -- 月日均余额
   ,(case when substr('${batch_date}',5,4) = '0101' then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_y_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'y') + 1) -- 折本币年日均余额
   ,(case when substr('${batch_date}',5,4) in ('0101','0401','0701','1001') then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_s_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end) / (to_date('${batch_date}', 'yyyymmdd') - trunc(to_date('${batch_date}', 'yyyymmdd'), 'q') + 1) -- 折本币季日均余额
   ,(case when substr('${batch_date}',7,2) = '01' then nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) else nvl(t2.cl_curr_m_acm_bal, 0) + nvl(t1.lc_bal, 0) * nvl(t3.convt_cny_exch_rat, 1) end) / to_number(substr('${batch_date}', 7, 2)) -- 折本币月日均余额
   ,t1.job_cd                                    -- 任务代码
   ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from ${icl_schema}.cmm_lc_acct_info_ex t1
left join ${icl_schema}.cmm_lc_acct_info t2
  on t2.acct_id = t1.acct_id
 and t2.lp_id = t1.lp_id
 and t2.mx_lc_flg = t1.mx_lc_flg
 and t2.etl_dt = to_date('${batch_date}','yyyymmdd') - 1
left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t3
  on t1.curr_cd = t3.curr_cd
--and t11.dt = to_date('${batch_date}','yyyymmdd')
 and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t3.end_dt > to_date('${batch_date}','yyyymmdd')
 and t3.job_cd = 'ncbsf1'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_lc_acct_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_lc_acct_info_ex_02;

-- 3.1 drop ex table
whenever sqlerror continue none ;
--drop table ${icl_schema}.cmm_lc_acct_info_ex purge;
--drop table ${icl_schema}.temp_cmm_lc_acct_info_01 purge;
--drop table ${icl_schema}.temp_cmm_lc_acct_info_02 purge;
--drop table ${icl_schema}.temp_cmm_lc_acct_info_03 purge;
--drop table ${icl_schema}.temp_cmm_lc_acct_info_04 purge;
--drop table ${icl_schema}.temp_cmm_lc_acct_info_041 purge;
--drop table ${icl_schema}.cmm_lc_acct_info_ex_02 purge;


-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_lc_acct_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
