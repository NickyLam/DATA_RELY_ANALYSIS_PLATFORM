/*
Purpose:    共性加工层-零售贷款业务合同补充信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_retl_loan_bus_cont_attach_info
CreateDate: 20190808
Logs:       20240116 饶雅 新增模型
            20241226 谢宁 新增字段【占用敞口额度风险类型代码】
			20250228 陈凭 新增字段【收款银行卡卡号、收款银行卡名称、收款银行行号、收款银行名称、还款银行卡号、还款银行卡名称、还款银行行号、还款银行名称】
    
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create temp table
--drop table ${icl_schema}.tmp_cmm_retl_loan_bus_cont_attach_info_01 purge;

-- 2.1 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_retl_loan_bus_cont_attach_info where 0=1;

-- 2.2 insert into data to temporary table cmm_retl_loan_bus_cont_attach_info_ex
-- 第一组（共一组）
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_retl_loan_bus_cont_attach_info_ex(
       etl_dt                       -- 数据日期
       ,lp_id                       -- 法人编号
       ,cont_id                     -- 合同编号
       ,cont_name                   -- 合同名称
       ,cust_id                     -- 客户编号
       ,lmt_cont_id                 -- 额度合同编号
       ,oper_teller_id              -- 经办柜员编号
	   ,mgmt_teller_id	            -- 管理柜员编号
       ,cont_type_cd                -- 合同类型代码
       ,level5_cls_cd               -- 五级分类代码 
       ,int_rat_mode_cd             -- 利率模式代码
       ,ocup_open_lmt_risk_type_cd  -- 占用敞口额度风险类型代码
       ,cont_bal                    -- 合同余额       
       ,margin_amt                  -- 保证金金额      
       ,rgst_dt                     -- 登记日期         
       ,loan_usage_descb            -- 贷款用途描述
       ,remark                      -- 备注
       ,recvbl_bank_card_card_no	-- 收款银行卡卡号
       ,recvbl_bank_card_name	    -- 收款银行卡名称
       ,recvbl_bank_no	      	    -- 收款银行行号
       ,recvbl_bank_name		    -- 收款银行名称
       ,repay_bank_card_num	        -- 还款银行卡号
       ,repay_bank_card_name	    -- 还款银行卡名称
       ,repay_bank_no	            -- 还款银行行号
       ,repay_bank_name	            -- 还款银行名称	   
       ,job_cd                      -- 任务代码
       ,etl_timestamp               -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                  -- 数据日期
       ,t1.lp_id                                                            -- 法人编号
       ,t1.cont_id                                                          -- 合同编号
       ,t1.text_cont_id                                                     -- 合同名称
       ,t1.cust_id                                                          -- 客户编号
       ,t1.rela_cont_id                                                     -- 额度合同编号
       ,t1.oper_teller_id                                                   -- 经办柜员编号
	   ,t1.lon_post_mgmt_teller_id	                                        -- 管理柜员编号
       ,decode(t1.lmt_circl_flg, '1', '04', '0', '05', '00')                -- 合同类型代码
       ,t1.level5_cls_cd                                                    -- 五级分类代码
       ,t1.int_rat_mode_cd                                                  -- 利率模式代码
       ,t1.ocup_open_lmt_risk_type_cd                                       -- 占用敞口额度风险类型代码
       ,t1.curr_bal                                                         -- 合同余额  
       ,t1.margin_amt                                                       -- 保证金金额 
       ,t1.rgst_dt                                                          -- 登记日期  
       ,t1.usage_descb                                                      -- 贷款用途描述
       ,t1.remark                                                           -- 备注
       ,t3.extloanaccountno                                                 -- 收款银行卡卡号
       ,t3.extloanaccountname                                               -- 收款银行卡名称
       ,t3.recvbankid                                                       -- 收款银行行号
       ,t3.recvbankname                                                     -- 收款银行名称
       ,t3.extrepaymentaccount                                              -- 还款银行卡号
       ,t3.extrepaymentaccname                                              -- 还款银行卡名称
       ,t3.repaybankid                                                      -- 还款银行行号
       ,t3.repaybankname                                                    -- 还款银行名称 	   
       ,t1.job_cd                                                           -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')     -- 数据处理时间
  from ${iml_schema}.agt_loan_cont_info_h t1
 inner join ${iml_schema}.prd_loan_prod_info_h t2
    on t1.prod_id = t2.prod_id
   and t2.crdt_prod_cate_cd in ('2', '4') --零售贷款、个人委托贷款
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
   and t2.job_cd = 'icmsf1'
 left join ${iol_schema}.icms_bc_personal_loan t3
    on t1.cont_id = t3.serialno		
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  where t1.lmt_cont_flg = '02'--业务合同
   and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t1.end_dt > to_date('${batch_date}','yyyymmdd')
   and t1.job_cd = 'icmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_retl_loan_bus_cont_attach_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_retl_loan_bus_cont_attach_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
