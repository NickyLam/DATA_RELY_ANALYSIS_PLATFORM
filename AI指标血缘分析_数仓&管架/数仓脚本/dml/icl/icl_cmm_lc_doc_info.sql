/*
Purpose:    共性加工层-信用证单据信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_lc_doc_info
CreateDate: 20190808
Logs:       20200110 翟若平 调整iml.ref_cny_fori_exch_mdl_p_h表取数口径
					  20200724 周沁晖 调整字段【进出口信用证标志、付款人名称】的取数口径
					  				        增加第二组（国内进口信用证单据）和第四组（国内出口信用证单据）
					  20200828 周沁晖 新增字段【标准产品编号、开证行SWIFTCODE、开证行中文名称、开证行名称】
					  20200828 陈伟峰 调整 T7表isbs_pte的取值口径，调整科目号匹配口径
            20210222 陈伟峰 调整客户经理编号来源口径，从uuss系统获取（M层加工到核心柜员表中）
            20210331 谢  宁 调整第二组付款金额t9.amt-->t6.reloriamt
            20210331 谢  宁 调整第一组付款金额t9.amt-->t6.reloriamt,T6组条件BDD--》BRD
            20210816 陈伟峰 调整进口信用证部分（第一组、第二组）的【币种CURR_CD】逻辑，只有做过承兑部分才有币种，否则给空
                            修复【承兑标志】字段逻辑
            20211105 陈伟峰 增加字段【索偿金额】
			      20220428 翟若平	调整字段【标准产品编号、科目编号、折本币信用证余额】的取数口径	
            20220516 温旺清	调整【T16-fin_accti_subj_rela_h】临时表中的取数过滤条件，由ISB->ISBX			
			      20220624 温旺清 调整字段【科目编号】的加工口径
			      20230419 陈伟峰 调整【币种代码】字段加工逻辑
			      20230506 陈伟峰 调整第四组cbb表加工逻辑，增加rol =  'BEN'逻辑加工
			      20231221 徐子豪 调整逻辑口径存在相同业务主键数据，取唯一的业务主键，汇总付款金额，取最大的付款日期。
			      20241013 谢  宁 增加字段【单据金额】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_lc_doc_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_lc_doc_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_lc_doc_info_ex purge;
drop table ${icl_schema}.cmm_lc_doc_info_01 purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_lc_doc_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_lc_doc_info where 0=1;

-- 创建临时表
create table ${icl_schema}.cmm_lc_doc_info_01 
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

--第一组（共四组）进口信用证（国际）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_doc_info_ex(
   etl_dt                            --数据日期
   ,lp_id                            --法人编号
   ,doc_agt_id                       --单据协议编号
   ,doc_id                           --单据编号
   ,lc_acct_id                       --信用证账户编号
   ,std_prod_id 			          		 --标准产品编号
   ,commer_inv_no                    --商业发票号码
   ,subj_id                          --科目编号
   ,mx_lc_flg                        --进出口信用证标志
   ,arrive_bill_flg                  --到单标志
   ,acpt_flg                         --承兑标志
   ,send_bill_dt                     --寄单日期
   ,issue_dt                         --开证日期
   ,wrtoff_dt                        --注销日期
   ,acpt_dt                          --承兑日期
   ,arrive_bill_dt                   --到单日期
   ,pay_dt                           --付款日期
   ,payer_id                         --付款人编号
   ,cust_mgr_id                      --客户经理编号
   ,oper_org_id                      --经办机构编号
   ,pay_org_id                       --付款机构编号
   ,sign_org_id                      --签署机构编号
   ,acct_instit_id                   --账务机构编号
   ,payer_name                       --付款人名称
   ,issue_bank_swiftcode		         --开证行SWIFTCODE
   ,issue_bank_cn_name			         --开证行中文名称
   ,issue_bank_name				           --开证行名称
   ,doc_type_cd                      --单据类型代码
   ,doc_status_cd                    --单据状态代码
   ,curr_cd                          --币种代码
   ,overs_deduct_amt                 --国外扣费金额
   ,pay_amt                          --付款金额
   ,doc_amt                          --单据金额
   ,claim_amt                        --索偿金额
   ,lc_bal                           --信用证余额
   ,cl_curr_lc_bal                   --折本币信用证余额
   ,job_cd                           --任务代码
   ,etl_timestamp                    --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                           -- 数据日期
   ,'9999'                                                                       -- 法人编号
   ,t1.inr                                                                       -- 单据协议编号
   ,t1.ownref                                                                    -- 单据编号
   ,t1.pntinr                                                                    -- 信用证账户编号
   ,bp.pdtcod5						                                             -- 标准产品编号
   ,trim(t1.invnum)                                                              -- 商业发票号码
   ,t15.pric_subj_id                                                             --科目编号
   ,decode(t1.pnttyp, 'LID', 'I', 'DID', 'DI', 'LED', 'O', 'DED', 'DO')          -- 进出口信用证标志
   ,decode(t1.docflg, 'A', '1', '0')                                             -- 到单标志
   ,(case when trim(t1.acpnowflg) is not null then '1' else '0' end)             -- 承兑标志
   ,${iml_schema}.dateformat_min(t1.credat)                                      -- 寄单日期
   ,${iml_schema}.dateformat_min(t1.opndat)                                      -- 开证日期
   ,${iml_schema}.dateformat_max(t1.clsdat)                                      -- 注销日期
   ,${iml_schema}.dateformat_min(t1.matdat)                                      -- 承兑日期
   ,${iml_schema}.dateformat_max(t1.rcvdat)                                      -- 到单日期
   ,case when ${iml_schema}.dateformat_min(t6.comdat) > to_date('${batch_date}','yyyymmdd') then ${iml_schema}.dateformat_min('') else ${iml_schema}.dateformat_min(t6.comdat) end                                      -- 付款日期
   ,nvl(trim(t2.extkey), t12.extkey)                                             -- 付款人编号
   ,t1.ownusr                                                   -- 客户经理编号
   ,t3.branch                                                                    -- 经办机构编号
   ,t4.branch                                                                    -- 付款机构编号
   ,t4.branch                                                                    -- 签署机构编号
   ,t4.branch                                                                    -- 账务机构编号
   ,t2.nam        		                                                           -- 付款人名称
   ,t14.extkey							                                                     -- 开证行swiftcode
   ,t14.nam1  							                                                     -- 开证行中文名称
   ,t14.nam   							                                                     -- 开证行名称
   ,''                                                                           -- 单据类型代码
   ,t1.docsta                                                                    -- 单据状态代码
   ,nvl(t8.cur, 'CNY')                                                           -- 币种代码
   ,0                                                                            -- 国外扣费金额
   ,nvl(t6.reloriamt, 0)                                                         -- 付款金额
   ,nvl(t9.amt,0)                                                                -- 单据金额
   ,nvl(t6.reloriamt, 0)                                                         -- 索偿金额
   ,nvl(t8.amt, 0)                                                               -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                              -- 折本币信用证余额
   ,'isbsf1'                                                                     -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')              -- etl处理时间戳
from ${iol_schema}.isbs_brd t1
   left join ${iol_schema}.isbs_pts t2
     on t2.objinr = t1.inr
    and t2.rol = t1.payrol
    and t2.objtyp = 'BRD'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t3
     on t1.bchkeyinr = t3.inr
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t4
     on t1.branchinr = t4.inr
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_lid t5
     on t1.pntinr = t5.inr
    and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   left join (select objinr,sum(reloriamt) as reloriamt,max(comdat) as comdat from ${iol_schema}.isbs_trn where objtyp = 'BRD' and inifrm in ('BRTSET','BDTSET') and relflg = 'R' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
               group by objinr) t6
   	 on t6.objinr = t1.inr
   left join (select inr,objinr,objtyp,cbtpfx,begdat,clsdat,row_number() over (partition by objinr order by clsdat)  rn
                from ${iol_schema}.isbs_pte
			   where objtyp = 'PTS'
                 and cbtpfx = 'AKZ'
				 and begdat <= to_date('${batch_date}','yyyymmdd')
                 and start_dt <= to_date('${batch_date}','yyyymmdd')
				 and end_dt > to_date('${batch_date}','yyyymmdd')
               ) t7
    on t7.objinr = t2.inr
	and t7.rn=1
    --and t7.objtyp = 'PTS' and t7.cbtpfx = 'AKZ'
	-- and T7.subid='003'
    --and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
    --and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t8
    on t8.objinr = t7.inr
    and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(T8.enddat, 'yyyy') = '2299'
    and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t9
    on t9.objinr = t1.inr
    and t9.objtyp = 'BRD' and t9.extid = 'AMT1' and t9.cbc = 'MAXSUM'
    and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t9.end_dt > to_date('${batch_date}','yyyymmdd')
    and t9.begdat <= to_date('${batch_date}','yyyymmdd')
  	and t9.enddat > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbe t10
    on t10.inr=t8.cbeinr
    and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t10.end_dt > to_date('${batch_date}','yyyymmdd')	
	left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
	on nvl(t8.cur, 'CNY') = t11.curr_cd
	--and t11.dt = to_date('${batch_date}', 'yyyymmdd')
	and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t11.job_cd = 'ncbsf1'			
   left join ${iol_schema}.isbs_pty t12
     on t2.ptyinr = t12.inr
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pts t13
 	 	 on t1.pntinr = t13.objinr
 	 	and t13.objtyp = 'LID'
 	 	and t13.rol = 'ISS'
 	 	and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pty t14
 	 	 on t13.ptyinr = t14.inr
 	 	and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t14.end_dt > to_date('${batch_date}','yyyymmdd')
	 left join ${iol_schema}.isbs_bus_pdt bp
     on t1.inr = bp.objinr
    and bp.objtyp = 'BRD'
	left join ${icl_schema}.cmm_lc_doc_info_01 t15		
    on bp.pdtcod5 = t15.prod_id			
   and bp.amttypcod = t15.amt_type_cd	
  /*left join ${icl_schema}.cmm_prod_and_subj_map_rela t15		
    on bp.pdtcod5 = t15.sellbl_prod_id			
   and t15.bus_type_cd = 'ISBX'	
   and t15.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  */
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

--第二组（共四组）买方国内信用证（国内）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_doc_info_ex(
   etl_dt                            --数据日期
   ,lp_id                            --法人编号
   ,doc_agt_id                       --单据协议编号
   ,doc_id                           --单据编号
   ,lc_acct_id                       --信用证账户编号
   ,std_prod_id						           --标准产品编号
   ,commer_inv_no                    --商业发票号码
   ,subj_id                          --科目编号
   ,mx_lc_flg                        --进出口信用证标志
   ,arrive_bill_flg                  --到单标志
   ,acpt_flg                         --承兑标志
   ,send_bill_dt                     --寄单日期
   ,issue_dt                         --开证日期
   ,wrtoff_dt                        --注销日期
   ,acpt_dt                          --承兑日期
   ,arrive_bill_dt                   --到单日期
   ,pay_dt                           --付款日期
   ,payer_id                         --付款人编号
   ,cust_mgr_id                      --客户经理编号
   ,oper_org_id                      --经办机构编号
   ,pay_org_id                       --付款机构编号
   ,sign_org_id                      --签署机构编号
   ,acct_instit_id                   --账务机构编号
   ,payer_name                       --付款人名称
   ,issue_bank_swiftcode			       --开证行SWIFTCODE
   ,issue_bank_cn_name				       --开证行中文名称
   ,issue_bank_name					         --开证行名称
   ,doc_type_cd                      --单据类型代码
   ,doc_status_cd                    --单据状态代码
   ,curr_cd                          --币种代码
   ,overs_deduct_amt                 --国外扣费金额
   ,pay_amt                          --付款金额
   ,doc_amt                          --单据金额
   ,claim_amt                        --索偿金额
   ,lc_bal                           --信用证余额
   ,cl_curr_lc_bal                   --折本币信用证余额
   ,job_cd                           --任务代码
   ,etl_timestamp                    --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                           -- 数据日期
   ,'9999'                                                                       -- 法人编号
   ,t1.inr                                                                       -- 单据协议编号
   ,t1.ownref                                                                    -- 单据编号
   ,t1.pntinr                                                                    -- 信用证账户编号
   ,bp.pdtcod5						                                                       -- 标准产品编号
   ,trim(t1.invnum)                                                              -- 商业发票号码
   ,t15.pric_subj_id                                                             --科目编号
   ,decode(t1.pnttyp, 'LID', 'I', 'DID', 'DI', 'LED', 'O', 'DED', 'DO')          -- 进出口信用证标志
   ,decode(t1.docflg, 'A', '1', '0')                                             -- 到单标志
   ,(case when trim(t1.acpnowflg) is not null then '1' else '0' end)             -- 承兑标志
   ,${iml_schema}.dateformat_min(t1.credat)                                      -- 寄单日期
   ,${iml_schema}.dateformat_min(t1.opndat)                                      -- 开证日期
   ,${iml_schema}.dateformat_max(t1.clsdat)                                      -- 注销日期
   ,${iml_schema}.dateformat_min(t1.matdat)                                      -- 承兑日期
   ,${iml_schema}.dateformat_max(t1.rcvdat)                                      -- 到单日期
   ,case when ${iml_schema}.dateformat_min(t6.comdat) > to_date('${batch_date}','yyyymmdd') then ${iml_schema}.dateformat_min('') else ${iml_schema}.dateformat_min(t6.comdat) end -- 付款日期
   ,nvl(trim(t2.extkey), t12.extkey)                                             -- 付款人编号
   ,t1.ownusr                                                 -- 客户经理编号
   ,t3.branch                                                                    -- 经办机构编号
   ,t4.branch                                                                    -- 付款机构编号
   ,t4.branch                                                                    -- 签署机构编号
   ,t4.branch                                                                    -- 账务机构编号
   ,t2.nam                          	                                           -- 付款人名称
   ,t14.extkey							                                                     -- 开证行swiftcode
   ,t14.nam1  							                                                     -- 开证行中文名称
   ,t14.nam   							                                                     -- 开证行名称
   ,''                                                                           -- 单据类型代码
   ,t1.docsta                                                                    -- 单据状态代码
   ,nvl(t8.cur, 'CNY')                                                           -- 币种代码
   ,0                                                                            -- 国外扣费金额
   ,nvl(t6.reloriamt, 0)                                                         -- 付款金额
   ,nvl(t9.amt,0)                                                                -- 单据金额   
   ,nvl(t1.conamt, 0)                                                            -- 索偿金额
   ,nvl(t8.amt, 0)                                                               -- 信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                              -- 折本币信用证余额
   ,'isbsf1'                                                                     -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')              -- etl处理时间戳
from ${iol_schema}.isbs_bdd t1
   left join ${iol_schema}.isbs_pts t2
    on t2.objinr = t1.inr
    and t2.rol = t1.payrol
    and t2.objtyp = 'BDD'
    and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t3
    on t1.bchkeyinr = t3.inr
    and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t4
    on t1.branchinr = t4.inr
    and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_did t5
    on t1.pntinr = t5.inr
    and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t5.end_dt > to_date('${batch_date}','yyyymmdd')
   left join (select objinr,sum(reloriamt) as reloriamt,max(comdat) as comdat from ${iol_schema}.isbs_trn where objtyp = 'BDD' and inifrm in ('BRTSET','BDTSET') and relflg = 'R' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
              group by objinr) t6
   	on t6.objinr = t1.inr
   left join (select inr,objinr,objtyp,cbtpfx,begdat,clsdat,row_number() over (partition by objinr order by clsdat)  rn
                from ${iol_schema}.isbs_pte
			   where objtyp = 'PTS'
                 and cbtpfx = 'AKZ'
				 and begdat <= to_date('${batch_date}','yyyymmdd')
                 and start_dt <= to_date('${batch_date}','yyyymmdd')
				 and end_dt > to_date('${batch_date}','yyyymmdd')
               ) t7
    on t7.objinr = t2.inr
	and t7.rn=1
    --and t7.objtyp = 'PTS' and t7.cbtpfx = 'AKZ'
	-- and T7.subid='003'
    --and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
    --and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t8
    on t8.objinr = t7.inr
    and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(T8.enddat, 'yyyy') = '2299'
    and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t9
    on t9.objinr = t1.inr
    and t9.objtyp = 'BDD' and t9.extid = 'AMT1' and t9.cbc = 'MAXSUM'
    and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t9.end_dt > to_date('${batch_date}','yyyymmdd')
    and t9.begdat <= to_date('${batch_date}','yyyymmdd')
  	and t9.enddat > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbe t10
    on t10.inr=t8.cbeinr
    and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   	left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
	on nvl(t8.cur, 'CNY') = t11.curr_cd
	--and t11.dt = to_date('${batch_date}', 'yyyymmdd')
	and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t11.job_cd = 'ncbsf1'
   left join ${iol_schema}.isbs_pty t12
     on t2.ptyinr = t12.inr
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pts t13
 	 	 on t1.pntinr = t13.objinr
 	 	and t13.objtyp = 'DID'
 	 	and t13.rol = 'ISS'
 	 	and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pty t14
 	 	 on t13.ptyinr = t14.inr
 	 	and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bus_pdt bp
     on t1.inr = bp.objinr
    and bp.objtyp = 'BDD'
	left join ${icl_schema}.cmm_lc_doc_info_01 t15		
    on bp.pdtcod5 = t15.prod_id			
   and bp.amttypcod = t15.amt_type_cd	
  /*left join ${icl_schema}.cmm_prod_and_subj_map_rela t15		
    on bp.pdtcod5 = t15.sellbl_prod_id			
   and t15.bus_type_cd = 'ISBX'	
   and t15.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  */
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


--第三组（共四组）出口信用证（国际）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_doc_info_ex(
   etl_dt                      --数据日期
   ,lp_id                      --法人编号
   ,doc_agt_id                 --单据协议编号
   ,doc_id                     --单据编号
   ,lc_acct_id                 --信用证账户编号
   ,std_prod_id				         --标准产品编号
   ,commer_inv_no              --商业发票号码
   ,subj_id                    --科目编号
   ,mx_lc_flg                  --进出口信用证标志
   ,arrive_bill_flg            --到单标志
   ,acpt_flg                   --承兑标志
   ,send_bill_dt               --寄单日期
   ,issue_dt                   --开证日期
   ,wrtoff_dt                  --注销日期
   ,acpt_dt                    --承兑日期
   ,arrive_bill_dt             --到单日期
   ,pay_dt                     --付款日期
   ,payer_id                   --付款人编号
   ,cust_mgr_id                --客户经理编号
   ,oper_org_id                --经办机构编号
   ,pay_org_id                 --付款机构编号
   ,sign_org_id                --签署机构编号
   ,acct_instit_id             --账务机构编号
   ,payer_name                 --付款人名称
   ,issue_bank_swiftcode	     --开证行SWIFTCODE
   ,issue_bank_cn_name		     --开证行中文名称
   ,issue_bank_name			       --开证行名称
   ,doc_type_cd                --单据类型代码
   ,doc_status_cd              --单据状态代码
   ,curr_cd                    --币种代码
   ,overs_deduct_amt           --国外扣费金额
   ,pay_amt                    --付款金额
   ,doc_amt                    --单据金额
   ,claim_amt                  --索偿金额
   ,lc_bal                     --信用证余额
   ,cl_curr_lc_bal             --折本币信用证余额
   ,job_cd                     --任务代码
   ,etl_timestamp              --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                           --数据日期
   ,'9999'                                                                       --法人编号
   ,t1.inr                                                                       --单据协议编号
   ,t1.ownref                                                                    --单据编号
   ,t1.pntinr                                                                    --信用证账户编号
   ,bp.pdtcod5														             --标准产品编号
   ,''                                                                           --商业发票号码
   ,t15.pric_subj_id                                                             --科目编号
   ,decode(t1.pnttyp, 'LID', 'I', 'DID', 'DI', 'LED', 'O', 'DED', 'DO')          --进出口信用证标志
   ,'0'                                                                          --到单标志
   ,(case when trim(t1.acpnowflg) is not null then '1' else '0' end)             --承兑标志
   ,${iml_schema}.dateformat_min(t1.credat)                                      --寄单日期
   ,${iml_schema}.dateformat_min(t1.opndat)                                      --开证日期
   ,${iml_schema}.dateformat_max(t1.clsdat)                                      --注销日期
   ,${iml_schema}.dateformat_min(t1.matdat)                                      --承兑日期
   ,${iml_schema}.dateformat_max(t1.rcvdat)                                      --到单日期
   ,case when ${iml_schema}.dateformat_min(t6.comdat) > to_date('${batch_date}','yyyymmdd') then ${iml_schema}.dateformat_min('') else ${iml_schema}.dateformat_min(t6.comdat) end--付款日期
   ,nvl(trim(t2.extkey), t12.extkey)                                             -- 付款人编号
   ,t1.ownusr                                                --客户经理编号
   ,t3.branch                                                                    --经办机构编号
   ,t4.branch                                                                    --付款机构编号
   ,t4.branch                                                                    --签署机构编号
   ,t4.branch                                                                    --账务机构编号
   ,t2.nam                                                       	               --付款人名称
   ,t14.extkey												 		                                       --开证行swiftcode
   ,t14.nam1  												 		                                       --开证行中文名称
   ,t14.nam   												 		                                       --开证行名称
   ,t1.doctypcod                                                                 --单据类型代码
   ,t1.docsta                                                                    --单据状态代码
   ,nvl(t8.cur, 'CNY')                                                           --币种代码
   ,t1.lescom                                                                    --国外扣费金额
   ,nvl(t9.amt, 0)                                                               --付款金额
   ,nvl(t9.amt, 0)                                                               --单据金额
   ,nvl(t9.amt, 0)                                                               --索偿金额
   ,nvl(t8.amt, 0)                                                               --信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                              --折本币信用证余额
   ,'isbs'                                                                       --任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')              -- etl处理时间戳
from ${iol_schema}.isbs_bed t1
   left join ${iol_schema}.isbs_pts t2
   	on t2.objinr = t1.inr and t2.rol = t1.payrol
   	and t2.objtyp = 'BED'
   	and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t3
   	on t1.bchkeyinr = t3.inr
   	and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t3.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bch t4
   	on t1.branchinr = t4.inr
   	and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t4.end_dt > to_date('${batch_date}','yyyymmdd')
   /*left join ${iol_schema}.isbs_lid t5
   	on t1.pntinr = t5.inr
   	and t5.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t5.end_dt > to_date('${batch_date}','yyyymmdd')*/
   left join (select objinr, max(comdat) as comdat from ${iol_schema}.isbs_trn where objtyp = 'BED' and inifrm in ('BETSET', 'BFTSET') and relflg = 'R' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
              group by objinr) t6
   	on t6.objinr = t1.inr
   left join (select inr,objinr,objtyp,cbtpfx,begdat,clsdat,row_number() over (partition by objinr order by clsdat)  rn
                from ${iol_schema}.isbs_pte
			   where objtyp = 'PTS'
                -- and cbtpfx = 'AKZ'   --20230130 zhujj 国结反馈“ and cbtpfx = 'AKZ'”有问题，需改造，可以删掉，也可以改成INT
                 and cbtpfx in ('AKZ','INT')
				 and begdat <= to_date('${batch_date}','yyyymmdd')
                 and start_dt <= to_date('${batch_date}','yyyymmdd')
				 and end_dt > to_date('${batch_date}','yyyymmdd')
               ) t7
    on t7.objinr = t2.inr
	and t7.rn=1
    --and t7.objtyp = 'PTS' and t7.cbtpfx = 'AKZ'
	-- and T7.subid='003'
    --and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
    --and t7.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t8
   	on t8.objinr = t7.inr
   	and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
   	and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t8.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbb t9
   	on t9.objinr = t1.inr
   	and t9.objtyp = 'BED' and t9.extid = 'AMT1' and t9.cbc = 'MAXSUM'
   	and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t9.end_dt > to_date('${batch_date}','yyyymmdd')
    and t9.begdat <= to_date('${batch_date}','yyyymmdd')
  	and t9.enddat > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_cbe t10
   	on t10.inr= t8.cbeinr
   	and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t10.end_dt > to_date('${batch_date}','yyyymmdd')
   	left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
	on nvl(t8.cur, 'CNY') = t11.curr_cd
	--and t11.dt = to_date('${batch_date}', 'yyyymmdd')
	and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t11.job_cd = 'ncbsf1'
   left join ${iol_schema}.isbs_pty t12
     on t2.ptyinr = t12.inr
    and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pts t13
 	 	 on t1.pntinr = t13.objinr
 	 	and t13.objtyp = 'LED'
 	 	and t13.rol = 'ISS'
 	 	and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t13.end_dt > to_date('${batch_date}','yyyymmdd')
 	 left join ${iol_schema}.isbs_pty t14
 	 	 on t13.ptyinr = t14.inr
 	 	and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
  	and t14.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.isbs_bus_pdt bp
     on t1.inr = bp.objinr
    and bp.objtyp = 'BED'
	left join ${icl_schema}.cmm_lc_doc_info_01 t15		
    on bp.pdtcod5 = t15.prod_id			
   and bp.amttypcod = t15.amt_type_cd	
  /*left join ${icl_schema}.cmm_prod_and_subj_map_rela t15		
    on bp.pdtcod5 = t15.sellbl_prod_id			
   and t15.bus_type_cd = 'ISBX'	
   and t15.etl_dt = to_date('${batch_date}', 'yyyymmdd')
  */
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

--第四组（共四组）卖方国内信用证（国内）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_lc_doc_info_ex(
   etl_dt                      --数据日期
   ,lp_id                      --法人编号
   ,doc_agt_id                 --单据协议编号
   ,doc_id                     --单据编号
   ,lc_acct_id                 --信用证账户编号
   ,std_prod_id				         --标准产品编号
   ,commer_inv_no              --商业发票号码
   ,subj_id                    --科目编号
   ,mx_lc_flg                  --进出口信用证标志
   ,arrive_bill_flg            --到单标志
   ,acpt_flg                   --承兑标志
   ,send_bill_dt               --寄单日期
   ,issue_dt                   --开证日期
   ,wrtoff_dt                  --注销日期
   ,acpt_dt                    --承兑日期
   ,arrive_bill_dt             --到单日期
   ,pay_dt                     --付款日期
   ,payer_id                   --付款人编号
   ,cust_mgr_id                --客户经理编号
   ,oper_org_id                --经办机构编号
   ,pay_org_id                 --付款机构编号
   ,sign_org_id                --签署机构编号
   ,acct_instit_id             --账务机构编号
   ,payer_name                 --付款人名称
   ,issue_bank_swiftcode	     --开证行SWIFTCODE
   ,issue_bank_cn_name		     --开证行中文名称
   ,issue_bank_name			       --开证行名称
   ,doc_type_cd                --单据类型代码
   ,doc_status_cd              --单据状态代码
   ,curr_cd                    --币种代码
   ,overs_deduct_amt           --国外扣费金额
   ,pay_amt                    --付款金额
   ,doc_amt                    --单据金额
   ,claim_amt                  --索偿金额
   ,lc_bal                     --信用证余额
   ,cl_curr_lc_bal             --折本币信用证余额   
   ,job_cd                     --任务代码
   ,etl_timestamp              --etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                                      --数据日期
   ,'9999'                                                                  --法人编号
   ,t1.inr                                                                  --单据协议编号
   ,t1.ownref                                                               --单据编号
   ,t1.pntinr                                                               --信用证账户编号
   ,bp.pdtcod5														        --标准产品编号
   ,''                                                                      --商业发票号码
   ,t15.pric_subj_id                                                             --科目编号
   ,decode(t1.pnttyp, 'LID', 'I', 'DID', 'DI', 'LED', 'O', 'DED', 'DO')      --进出口信用证标志
   ,'0'                                                                      --到单标志
   ,(case when trim(t1.acpnowflg) is not null then '1' else '0' end)         --承兑标志
   ,${iml_schema}.dateformat_min(t1.credat)                                  --寄单日期
   ,${iml_schema}.dateformat_min(t1.opndat)                                  --开证日期
   ,${iml_schema}.dateformat_max(t1.clsdat)                                  --注销日期
   ,${iml_schema}.dateformat_min(t1.matdat)                                  --承兑日期
   ,${iml_schema}.dateformat_max(t1.rcvdat)                                  --到单日期
   ,case when ${iml_schema}.dateformat_min(t6.comdat) > to_date('${batch_date}','yyyymmdd') then ${iml_schema}.dateformat_min('') else ${iml_schema}.dateformat_min(t6.comdat) end  --付款日期
   ,nvl(trim(t2.extkey), t12.extkey)                                         -- 付款人编号
   ,t1.ownusr                                                                --客户经理编号
   ,t3.branch                                                                --经办机构编号
   ,t4.branch                                                                --付款机构编号
   ,t4.branch                                                                --签署机构编号
   ,t4.branch                                                                --账务机构编号
   ,t2.nam                                                       	           --付款人名称
   ,t14.extkey												 		                                   --开证行swiftcode
   ,t14.nam1  												 		                                   --开证行中文名称
   ,t14.nam   												 		                                   --开证行名称
   ,t1.doctypcod                                                             --单据类型代码
   ,t1.docsta                                                                --单据状态代码
   ,nvl(t8.cur, 'CNY')                                                       --币种代码
   ,t1.lescom                                                                --国外扣费金额
   ,nvl(t9.amt, 0)                                                           --付款金额
   ,nvl(t9.amt, 0)                                                           --单据金额
   ,nvl(t1.clmamt, 0)                                                        --索偿金额
   ,nvl(t8.amt, 0)                                                           --信用证余额
   ,nvl(t8.amt, 0) * nvl(t11.convt_cny_exch_rat, 1)                          --折本币信用证余额  
   ,'isbs'                                                                   --任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')          -- etl处理时间戳
from ${iol_schema}.isbs_bmd t1
/*left join ${iol_schema}.isbs_pts t2_1
  on t2_1.objinr = t1.inr and t2_1.rol = t1.payrol
 and t2_1.objtyp = 'BMD'
 and t2_1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t2_1.end_dt > to_date('${batch_date}','yyyymmdd')*/
left join ${iol_schema}.isbs_pts t2
  on t2.objinr = t1.inr
 and t2.rol =  'BEN'
 and t2.objtyp = 'BMD'
 and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t2.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_bch t3
	on t1.bchkeyinr = t3.inr
 and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t3.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_bch t4
	on t1.branchinr = t4.inr
 and t4.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t4.end_dt > to_date('${batch_date}','yyyymmdd')
left join (select objinr, max(comdat) as comdat from ${iol_schema}.isbs_trn where objtyp = 'BMD' and inifrm in ('BETSET', 'BFTSET') and relflg = 'R' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
           group by objinr) t6
	on t6.objinr = t1.inr
/*left join (select inr,objinr,objtyp,cbtpfx,begdat,clsdat,row_number() over (partition by objinr order by clsdat)  rn
             from ${iol_schema}.isbs_pte
            where objtyp = 'PTS'
               -- and cbtpfx = 'AKZ'   --20230130 zhujj 国结反馈“ and cbtpfx = 'AKZ'”有问题，需改造，可以删掉，也可以改成INT
              and cbtpfx in ('AKZ','INT')
	            and begdat <= to_date('${batch_date}','yyyymmdd')
              and start_dt <= to_date('${batch_date}','yyyymmdd')
	            and end_dt > to_date('${batch_date}','yyyymmdd')
            ) t7
 on t7.objinr = t2_1.inr
and t7.rn=1
and T7.subid='003' */
left join (select inr,objinr,objtyp,cbtpfx,begdat,clsdat,row_number() over (partition by objinr order by clsdat)  rn
             from ${iol_schema}.isbs_pte
            where objtyp = 'PTS'
               -- and cbtpfx = 'AKZ'   --20230130 zhujj 国结反馈“ and cbtpfx = 'AKZ'”有问题，需改造，可以删掉，也可以改成INT
              and cbtpfx in ('AKZ','INT','AVS')
	            and begdat <= to_date('${batch_date}','yyyymmdd')
              and start_dt <= to_date('${batch_date}','yyyymmdd')
	            and end_dt > to_date('${batch_date}','yyyymmdd')
            ) t7_1
 on t7_1.objinr = t2.inr
and t7_1.rn=1
left join ${iol_schema}.isbs_cbb t8
  on t8.objinr = t7_1.inr
 and t8.objtyp = 'PTE' and t8.extid = 'AMT1' and to_char(t8.enddat, 'yyyy') = '2299'
 and t8.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t8.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_cbb t9
	on t9.objinr = t1.inr
 and t9.objtyp = 'BMD' and t9.extid = 'AMT1' and t9.cbc = 'MAXSUM'
 and t9.begdat <= to_date('${batch_date}','yyyymmdd')
 and t9.enddat > to_date('${batch_date}','yyyymmdd')
 and t9.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t9.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_cbe t10
  on t10.inr= t8.cbeinr
 and t10.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t10.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.ref_cny_fori_exch_mdl_p_h t11
  on nvl(t8.cur, 'CNY') = t11.curr_cd
 and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t11.job_cd = 'ncbsf1'
left join ${iol_schema}.isbs_pty t12
  on t2.ptyinr = t12.inr
 and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t12.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_pts t13
  on t1.pntinr = t13.objinr
 and t13.objtyp = 'DED'
 and t13.rol = 'ISS'
 and t13.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t13.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_pty t14
	on t13.ptyinr = t14.inr
 and t14.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t14.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.isbs_bus_pdt bp
  on t1.inr = bp.objinr
 and bp.objtyp = 'BMD'
left join ${icl_schema}.cmm_lc_doc_info_01 t15		
  on bp.pdtcod5 = t15.prod_id			
 and bp.amttypcod = t15.amt_type_cd	
/*left join ${icl_schema}.cmm_prod_and_subj_map_rela t15		
 on bp.pdtcod5 = t15.sellbl_prod_id			
and t15.bus_type_cd = 'ISBX'	
and t15.etl_dt = to_date('${batch_date}', 'yyyymmdd')
*/
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_lc_doc_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_lc_doc_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_lc_doc_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_lc_doc_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
