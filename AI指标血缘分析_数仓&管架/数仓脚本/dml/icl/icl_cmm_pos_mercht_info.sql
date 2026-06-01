/*
purpose:    共性加工层-POS商户信息表:POS商户信息，数据主要来源商户收单系统直联商户信息临时表、聚合商户表临时表、商户清算信息表、代理商户表
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd cmm_pos_mercht_info
createdate: 20200612
logs:       陈伟峰 20220408 新增字段【账户类型代码、商户地区代码、商户类别码、商户类别码名称、商户启用日期、聚合商户标志】
                            新增第三组传统商户信息
            陈伟峰 20220613 调整聚合商户信息部分的【开户银行名称、账户名称】加工逻辑
            徐子豪 20230726 新增字段【商户激活状态】
            陈伟峰 20240717 新增字段【商户签约日期、商户撤销日期】
                            调整直连商户【账户类型代码】加工逻辑
                            调整直连商户【商户地区代码】取值逻辑，从取邮政编码改成取行政区划代码
			陈  凭 20250417 调整取数源：删除旧收单共三组，新增新收单共一组
			谢  宁 20251023	新增字段【商户客户号】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_pos_mercht_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_pos_mercht_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_pos_mercht_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_pos_mercht_info_ex purge;

-- 2.1 create temporary table cmm_pos_mercht_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_pos_mercht_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_pos_mercht_info where 0=1;

-- 2.2 insert into data to temporary table cmm_pos_mercht_info_ex
--第一组（共一组）商户信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append*/ into ${icl_schema}.cmm_pos_mercht_info_ex(
		 etl_dt                                                                   -- 数据日期
		,lp_id                                                                    -- 法人编号
		,mercht_order_id                                                          -- 商户序列编号
		,mercht_id               				                                  -- 商户编号
		,mercht_cust_id                                                           -- 商户客户号
        ,agency_id               				                                  -- 代理商编号
        ,mercht_name             				                                  -- 商户名称
        ,mercht_fname            				                                  -- 商户全称
        ,work_addr               				                                  -- 办公地址
        ,open_acct_bank_name     				                                  -- 开户银行名称
        ,open_acct_bank_id       				                                  -- 开户银行编号
        ,acct_id                 				                                  -- 账户编号
        ,acct_name               				                                  -- 账户名称
        ,acct_type_cd                                                             -- 账户类型代码
        ,cotas_type_cd                                                            -- 联系人类型
        ,cotas_name                                                               -- 联系人名称
        ,cont_num                                                                 -- 联系号码
        ,cotas_e_mail                                                             -- 联系人电子邮箱
        ,fax_num                                                                  -- 传真号码
        ,mercht_belong_rg_cd                                                      -- 商户地区代码
        ,mercht_mcc_code                                                          -- 商户mcc编码
        ,mercht_mcc_descb                                                         -- 商户mcc描述
        ,oper_co_corp_name                                                        -- 经办合作单位名称
        ,agency_abbr                                                              -- 代理商简称
        ,agency_belong_brch_id                                                    -- 代理商所属分行
        ,agency_bus_lics_id                                                       -- 代理商营业执照编号
        ,agency_cotas_name                                                        -- 代理商联系人名称
        ,agency_cotas_addr                                                        -- 代理商联系人地址
        ,agency_enter_acct_chn_cd				                                  -- 代理商入账渠道代码
        ,agency_status_cd        				                                  -- 代理商状态代码
        ,recv_bill_bank_id       				                                  -- 收单银行编号
        ,mercht_status_cd        				                                  -- 商户状态代码
        ,dic_conc_co_status_cd                                                    -- 商户激活状态
        ,belong_org_id           				                                  -- 所属机构编号
        ,cust_mgr_id             				                                  -- 客户经理编号
        ,cust_mgr_name           				                                  -- 客户经理名称
        ,flow_bank_apv_flow_id   				                                  -- 流程银行审批流水编号
        ,flow_bank_apv_rest_cd   				                                  -- 流程银行审批结果代码
        ,h5_flow_flg             				                                  -- h5进件标志
        ,dic_conc_mercht_flg                                                      -- 直连商户标志
        ,jh_mercht_flg                                                            -- 聚合商户标志
        ,mercht_start_use_dt                                                      -- 商户启用日期
        ,mercht_sign_dt                                                           -- 商户签约日期
        ,mercht_revo_dt                                                           -- 商户撤销日期
		,job_cd                                                                   -- 任务代码
		,etl_timestamp                                                            -- 数据处理时间
)
select  to_date('${batch_date}','yyyymmdd')                                       -- 数据日期
       ,'9999'	                                                                  -- 法人编号
       ,decode(to_char(t1.auto_id),'0','',t1.auto_id)	                          -- 商户序列编号
       ,t1.merchant_id	                                                          -- 商户编号
	   ,t2.customer_no                                                            -- 商户客户号
       ,''	                                                                      -- 代理商编号
       ,t1.merchant_name	                                                      -- 商户名称
       ,t1.merchant_name	                                                      -- 商户全称
       ,t2.address	                                                              -- 办公地址
       ,t4.bank_name	                                                          -- 开户银行名称
       ,decode(to_char(t3.bank_id),'0','',t3.bank_id) 	                          -- 开户银行编号
       ,t3.account_code	                                                          -- 账户编号
       ,t3.account_name	                                                          -- 账户名称
       ,nvl(trim(t3.account_type),'-')                                            -- 账户类型代码
       ,'-'	                                                                      -- 联系人类型
       ,t2.principal	                                                          -- 联系人名称
       ,t2.principal_mobile	                                                      -- 联系号码
       ,t2.email	                                                              -- 联系人电子邮箱
       ,t2.fax	                                                                  -- 传真号码
       ,t7.ali_v2_area_code     	                                              -- 商户地区代码
       ,t6.mcc	                                                                  -- 商户mcc编码
       ,t6.industry_name	                                                      -- 商户mcc描述
       ,''	                                                                      -- 经办合作单位名称
       ,''	                                                                      -- 代理商简称
       ,''	                                                                      -- 代理商所属分行
       ,''	                                                                      -- 代理商营业执照编号
       ,''	                                                                      -- 代理商联系人名称
       ,''	                                                                      -- 代理商联系人地址
       ,''	                                                                      -- 代理商入账渠道代码
       ,'-'	                                                                      -- 代理商状态代码
       ,t1.channel_id	                                                          -- 收单银行编号
       ,nvl(trim(t1.examine_status),'-')	                                      -- 商户状态代码
       ,nvl(trim(t1.activate_status),'-')	                                      -- 商户激活状态
       ,''	                                                                      -- 所属机构编号
       ,t1.salesman_serial	                                                      -- 客户经理编号
       ,t5.emp_name	                                                              -- 客户经理名称
       ,''	                                                                      -- 流程银行审批流水编号
       ,''	                                                                      -- 流程银行审批结果代码
       ,case when t1.data_source = '14' then '1' else '0' end	                  -- h5进件标志
       ,nvl(trim(t1.union_mch_direct_flag),'-')	                                  -- 直连商户标志
       ,'1'	                                                                      -- 聚合商户标志
       ,t1.activate_time		                                                  -- 商户启用日期
       ,t1.create_time		                                                      -- 商户签约日期
       ,case when t1.activate_status <>'1' then t1.examine_time else null end     -- 商户撤销日期
       ,'amssf1'                                                                  -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')           -- etl处理时间戳
from ${iol_schema}.amss_cms_merchant t1
  left join ${iol_schema}.amss_cms_merchant_detail t2
    on t1.merchant_id = t2.merchant_detail_id
   and t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t2.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.amss_tra_bank_account t3
    on t1.merchant_id = t3.org_id
   and t3.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t3.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.amss_cms_bank t4
    on t3.bank_id = t4.bank_id
   and t4.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t4.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.amss_cms_emp t5
    on t1.salesman_serial = t5.emp_serial
   and t5.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t5.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.amss_cms_industry t6
    on t2.industr_id = t6.industry_id
   and t6.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t6.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.amss_cms_area t7
    on t2.province = t7.area_code		
   and t7.start_dt <= to_date('${batch_date}','yyyymmdd') 
   and t7.end_dt > to_date('${batch_date}','yyyymmdd')
 where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd');
commit;
 
 
/* --第一组（共两组）直联商户信息

whenever sqlerror exit sql.sqlcode;
insert + append into ${icl_schema}.cmm_pos_mercht_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
				,mercht_order_id                -- 商户序列编号
			  ,mercht_id               				-- 商户编号
        ,agency_id               				-- 代理商编号
        ,mercht_name             				-- 商户名称
        ,mercht_fname            				-- 商户全称
        ,work_addr               				-- 办公地址
        ,open_acct_bank_name     				-- 开户银行名称
        ,open_acct_bank_id       				-- 开户银行编号
        ,acct_id                 				-- 账户编号
        ,acct_name               				-- 账户名称
        ,acct_type_cd                   -- 账户类型代码
        ,cotas_type_cd                  -- 联系人类型
        ,cotas_name                     -- 联系人名称
        ,cont_num                       -- 联系号码
        ,cotas_e_mail                   -- 联系人电子邮箱
        ,fax_num                        -- 传真号码
        ,mercht_belong_rg_cd            -- 商户地区代码
        ,mercht_mcc_code                -- 商户mcc编码
        ,mercht_mcc_descb               -- 商户mcc描述
        ,oper_co_corp_name              -- 经办合作单位名称
        ,agency_abbr                    -- 代理商简称
        ,agency_belong_brch_id          -- 代理商所属分行
        ,agency_bus_lics_id             -- 代理商营业执照编号
        ,agency_cotas_name              -- 代理商联系人名称
        ,agency_cotas_addr              -- 代理商联系人地址
        ,agency_enter_acct_chn_cd				-- 代理商入账渠道代码
        ,agency_status_cd        				-- 代理商状态代码
        ,recv_bill_bank_id       				-- 收单银行编号
        ,mercht_status_cd        				-- 商户状态代码
        ,dic_conc_co_status_cd          -- 商户激活状态
        ,belong_org_id           				-- 所属机构编号
        ,cust_mgr_id             				-- 客户经理编号
        ,cust_mgr_name           				-- 客户经理名称
        ,flow_bank_apv_flow_id   				-- 流程银行审批流水编号
        ,flow_bank_apv_rest_cd   				-- 流程银行审批结果代码
        ,h5_flow_flg             				-- h5进件标志
        ,dic_conc_mercht_flg            -- 直连商户标志
        ,jh_mercht_flg                  -- 聚合商户标志
        ,mercht_start_use_dt            -- 商户启用日期
        ,mercht_sign_dt                 -- 商户签约日期
        ,mercht_revo_dt                 -- 商户撤销日期
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')                              -- 数据日期
       ,t1.lp_id                                                        -- 法人编号
       ,t1.mercht_seq_num                                               -- 商户序列编号
       ,t1.mercht_id         																						-- 商户编号
       ,''                   																						-- 代理商编号
       ,t1.mercht_cn_abbr       																			  -- 商户名称
       ,t1.mercht_cn_name																								-- 商户全称
       ,t1.mercht_addr       																						-- 办公地址
       ,t1.open_bank_name    																						-- 开户银行名称
       ,t1.open_bank_no      																						-- 开户银行编号
       ,t1.acct_id           																						-- 账户编号
       ,t1.acct_name         																						-- 账户名称
       ,t1.stl_acct_type_cd                                             -- 账户类型代码
       ,''                   																						-- 联系人类型
       ,t1.cotas_name        																						-- 联系人名称
       ,t1.cotas_tel_num     																						-- 联系号码
       ,''                   																						-- 联系人电子邮箱
       ,t1.fax_num 																											-- 传真号码
       ,t1.mercht_local_rg_cd                                           -- 商户地区代码
       ,t1.mcc_code	                                                    -- 商户mcc编码
       ,''                                                              -- 商户mcc描述
       ,t1.agency_name       																						-- 经办合作单位名称
       ,''                   																						-- 代理商简称
       ,''                   																						-- 代理商所属分行
       ,''                   																						-- 代理商营业执照编号
       ,''                   																						-- 代理商联系人名称
       ,''                   																						-- 代理商联系人地址
       ,''                   																						-- 代理商入账渠道代码
       ,''                   																						-- 代理商状态代码
       ,t1.acquiri_bank_num  																						-- 收单银行编号
       ,t1.check_status_cd   																						-- 商户状态代码
       ,decode(t1.co_status_cd,' ','-',t1.co_status_cd)                 -- 商户激活状态
       ,t1.recv_org_id       																						-- 所属机构编号
       ,t1.cust_mgr_id       																						-- 客户经理编号
       ,t1.cust_mgr_name     																						-- 客户经理名称
       ,''                   																						-- 流程银行审批流水编号
       ,''                   																						-- 流程银行审批结果代码
       ,''                   																						-- h5进件标志
       ,'1'                                                             -- 直连商户标志
       ,'0'                                                             -- 聚合商户标志
       ,t1.start_use_dt                                                 -- 商户启用日期
       ,t1.mercht_sign_dt                                               -- 商户签约日期
       ,t1.mercht_revo_dt                                               -- 商户撤销日期
       ,t1.job_cd                                                       -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iml_schema}.pty_pos_mercht_info_h t1
--left join ${iol_schema}.MRMS_TBL_DIRECT_MCHNT_INF
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
		and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
	  and t1.job_cd = 'mrmsf1'
	  ;

commit;

--第二组（共两组）聚合商户信息

whenever sqlerror exit sql.sqlcode;
insert + append into ${icl_schema}.cmm_pos_mercht_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
				,mercht_order_id                -- 商户序列编号
			  ,mercht_id               				-- 商户编号
        ,agency_id               				-- 代理商编号
        ,mercht_name             				-- 商户名称
        ,mercht_fname            				-- 商户全称
        ,work_addr               				-- 办公地址
        ,open_acct_bank_name     				-- 开户银行名称
        ,open_acct_bank_id       				-- 开户银行编号
        ,acct_id                 				-- 账户编号
        ,acct_name               				-- 账户名称
        ,acct_type_cd                   -- 账户类型代码
        ,cotas_type_cd                  -- 联系人类型
        ,cotas_name                     -- 联系人名称
        ,cont_num                       -- 联系号码
        ,cotas_e_mail                   -- 联系人电子邮箱
        ,fax_num                        -- 传真号码
        ,mercht_belong_rg_cd            -- 商户地区代码
        ,mercht_mcc_code                -- 商户mcc编码
        ,mercht_mcc_descb               -- 商户mcc描述
        ,oper_co_corp_name              -- 经办合作单位名称
        ,agency_abbr                    -- 代理商简称
        ,agency_belong_brch_id          -- 代理商所属分行
        ,agency_bus_lics_id             -- 代理商营业执照编号
        ,agency_cotas_name              -- 代理商联系人名称
        ,agency_cotas_addr              -- 代理商联系人地址
        ,agency_enter_acct_chn_cd				-- 代理商入账渠道代码
        ,agency_status_cd        				-- 代理商状态代码
        ,recv_bill_bank_id       				-- 收单银行编号
        ,mercht_status_cd        				-- 商户状态代码
        ,dic_conc_co_status_cd          -- 商户激活状态
        ,belong_org_id           				-- 所属机构编号
        ,cust_mgr_id             				-- 客户经理编号
        ,cust_mgr_name           				-- 客户经理名称
        ,flow_bank_apv_flow_id   				-- 流程银行审批流水编号
        ,flow_bank_apv_rest_cd   				-- 流程银行审批结果代码
        ,h5_flow_flg             				-- h5进件标志
        ,dic_conc_mercht_flg            -- 直连商户标志
        ,jh_mercht_flg                  -- 聚合商户标志
        ,mercht_start_use_dt            -- 商户启用日期
        ,mercht_sign_dt                 -- 商户签约日期
        ,mercht_revo_dt                 -- 商户撤销日期
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')                                             -- 数据日期
       ,t1.lp_id                                                                       -- 法人编号
       ,t1.mercht_id             	  																									 -- 商户序列编号
       ,t1.mercht_id                 																									 -- 商户编号
       ,t1.agency_id                 																									 -- 代理商编号
       ,t2.mercht_cn_abbr            																									 -- 商户名称
       ,t2.mercht_cn_name              																								 -- 商户全称
       ,t2.cotas_addr            	  																									 -- 办公地址
       ,t1.open_bank_name                  																  					 -- 开户银行名称
       ,t1.open_bank_no              																									 -- 开户银行编号
       ,t1.acct_id           																									         -- 账户编号
       ,t1.acct_name                  																					    	 -- 账户名称
       ,t1.acct_type_cd                                                                -- 账户类型代码
       ,t2.cotas_type_cd             																									 -- 联系人类型
       ,t2.cotas_name                																									 -- 联系人名称
       ,t2.cotas_tel_num             																									 -- 联系号码
       ,t2.elec_addr                 																									 -- 联系人电子邮箱
       ,''                             																								 -- 传真号码
       ,t2.mercht_local_rg_cd                                                          -- 商户地区代码
       ,''                                                                             -- 商户mcc编码
       ,''                                                                             -- 商户mcc描述
       ,t3.agent_name                																									 -- 经办合作单位名称
       ,t3.agent_short_name          																									 -- 代理商简称
       ,t3.acq_inst_id               																									 -- 代理商所属分行
       ,t3.licence_no                																									 -- 代理商营业执照编号
       ,t3.contact                   																									 -- 代理商联系人名称
       ,t3.comm_addr                 																									 -- 代理商联系人地址
       ,t3.acct_chnl                 																									 -- 代理商入账渠道代码
       ,t3.agent_status              																									 -- 代理商状态代码
       ,t2.org_id                    																									 -- 收单银行编号
       ,t2.check_status_cd           																									 -- 商户状态代码
       ,'-'                                                                            -- 商户激活状态
       ,t2.org_id                    																									 -- 所属机构编号
       ,t2.cust_mgr_id               																									 -- 客户经理编号
       ,t2.cust_mgr_name             																									 -- 客户经理名称
       ,t2.flow_bank_apv_flow_num    																									 -- 流程银行审批流水编号
       ,t2.flow_bank_apv_rest_cd     																									 -- 流程银行审批结果代码
       ,t2.h5_flow_flg               																									 -- H5进件标志
       ,'0'                                                                            -- 直连商户标志
       ,'1'                                                                            -- 聚合商户标志
       ,t2.start_use_dt                                                                -- 商户启用日期
       ,t2.mercht_sign_dt                                                              -- 商户签约日期
       ,t2.mercht_revo_dt                                                              -- 商户撤销日期
       ,t1.job_cd                                                                      -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')                -- etl处理时间戳
from ${iml_schema}.pty_jh_mercht_stl_acct t1
  left join ${iml_schema}.pty_jh_mercht_info t2
    on t1.mercht_id = t2.mercht_id
	 and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t2.job_cd = 'mrmsf1'
  left join ${iol_schema}.mrms_tbl_agent_info t3
    on t1.agency_id = t3.agent_id
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t1.job_cd = 'mrmsf1';

commit;


--第三组（共三组）传统商户信息

whenever sqlerror exit sql.sqlcode;
insert + append into ${icl_schema}.cmm_pos_mercht_info_ex(
				etl_dt                          -- 数据日期
				,lp_id                          -- 法人编号
				,mercht_order_id                -- 商户序列编号
			  ,mercht_id               				-- 商户编号
        ,agency_id               				-- 代理商编号
        ,mercht_name             				-- 商户名称
        ,mercht_fname            				-- 商户全称
        ,work_addr               				-- 办公地址
        ,open_acct_bank_name     				-- 开户银行名称
        ,open_acct_bank_id       				-- 开户银行编号
        ,acct_id                 				-- 账户编号
        ,acct_name               				-- 账户名称
        ,acct_type_cd                   -- 账户类型代码
        ,cotas_type_cd                  -- 联系人类型
        ,cotas_name                     -- 联系人名称
        ,cont_num                       -- 联系号码
        ,cotas_e_mail                   -- 联系人电子邮箱
        ,fax_num                        -- 传真号码
        ,mercht_belong_rg_cd            -- 商户地区代码
        ,mercht_mcc_code                -- 商户mcc编码
        ,mercht_mcc_descb               -- 商户mcc描述
        ,oper_co_corp_name              -- 经办合作单位名称
        ,agency_abbr                    -- 代理商简称
        ,agency_belong_brch_id          -- 代理商所属分行
        ,agency_bus_lics_id             -- 代理商营业执照编号
        ,agency_cotas_name              -- 代理商联系人名称
        ,agency_cotas_addr              -- 代理商联系人地址
        ,agency_enter_acct_chn_cd				-- 代理商入账渠道代码
        ,agency_status_cd        				-- 代理商状态代码
        ,recv_bill_bank_id       				-- 收单银行编号
        ,mercht_status_cd        				-- 商户状态代码
        ,dic_conc_co_status_cd          -- 商户激活状态
        ,belong_org_id           				-- 所属机构编号
        ,cust_mgr_id             				-- 客户经理编号
        ,cust_mgr_name           				-- 客户经理名称
        ,flow_bank_apv_flow_id   				-- 流程银行审批流水编号
        ,flow_bank_apv_rest_cd   				-- 流程银行审批结果代码
        ,h5_flow_flg             				-- h5进件标志
        ,dic_conc_mercht_flg            -- 直连商户标志
        ,jh_mercht_flg                  -- 聚合商户标志
        ,mercht_start_use_dt            -- 商户启用日期
        ,mercht_sign_dt                 -- 商户签约日期
        ,mercht_revo_dt                 -- 商户撤销日期
				,job_cd                         -- 任务代码
				,etl_timestamp                  -- 数据处理时间
)

select to_date('${batch_date}','yyyymmdd')     -- 数据日期
       ,'9999'                                 -- 法人编号
       ,t1.mcht_no                             -- 商户序列编号
       ,t1.mcht_no                             -- 商户编号
       ,''                                     -- 代理商编号
       ,t1.mcht_nm                             -- 商户名称
       ,t1.mcht_nm                             -- 商户全称
       ,t1.home_page                           -- 办公地址
       ,t3.settle_bank_nm                      -- 开户银行名称
       ,t3.settle_bank_no                      -- 开户银行编号
       ,t3.settle_acct                         -- 账户编号
       ,t3.settle_acct_nm                      -- 账户名称
       ,decode(t3.acct_type,'0','2','1','11','2','12','-')         -- 账户类型代码
       ,'-'                                    -- 联系人类型
       ,t1.contact                             -- 联系人名称
       ,t1.comm_mobil                          -- 联系号码
       ,t1.comm_email                          -- 联系人电子邮箱
       ,t1.fax                                 -- 传真号码
       ,t1.area_no                             -- 商户地区代码
       ,t1.mcc                                 -- 商户mcc编码
       ,t2.descr                               -- 商户mcc描述
       ,''                                     -- 经办合作单位名称
       ,''                                     -- 代理商简称
       ,''                                     -- 代理商所属分行
       ,''                                     -- 代理商营业执照编号
       ,''                                     -- 代理商联系人名称
       ,''                                     -- 代理商联系人地址
       ,''                                     -- 代理商入账渠道代码
       ,''                                     -- 代理商状态代码
       ,t1.acq_inst_id                         -- 收单银行编号
       ,t1.mcht_status                         -- 商户状态代码
       ,'-'                                    -- 商户激活状态
       ,t1.acq_inst_id                         -- 所属机构编号
       ,t1.oper_no                             -- 客户经理编号
       ,t1.oper_nm                             -- 客户经理名称
       ,''                                     -- 流程银行审批流水编号
       ,''                                     -- 流程银行审批结果代码
       ,'0'                                    -- h5进件标志
       ,'0'                                    -- 直连商户标志
       ,'0'                                    -- 聚合商户标志
       ,${iml_schema}.dateformat_min(t1.enable_date)                         -- 商户启用日期
       ,${iml_schema}.dateformat_min(t1.prol_date)                           -- 商户签约日期
       ,${iml_schema}.dateformat_max2(t1.close_date)                         -- 商户撤销日期
       ,'mrmsf1'                               -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')        -- etl处理时间戳
 from ${iol_schema}.mrms_tbl_mcht_base_inf t1
 left join ${iol_schema}.mrms_tbl_mcht_mcc_inf t2
   on t1.mcc = t2.mchnt_tp
  and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 left join ${iol_schema}.mrms_tbl_mcht_settle_inf t3
   on t1.mcht_no = t3.mcht_no
  and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and t1.end_dt > to_date('${batch_date}', 'yyyymmdd');
  
 */


-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_pos_mercht_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_pos_mercht_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_pos_mercht_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_pos_mercht_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);