/*
Purpose:    共性加工层-支小再贷款补充信息:包括我行支小再的业务数据，数据来源于零售信贷。可通过借据编号关联对公借据、零售借据信息。
Author:     Sunline/fuxiaoxiong
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_refac_loan_attach_info
Createdate: 20191025
Logs:       20220812 温旺清 1、调整字段【备注、审批状态代码】的加工口径
                            2、置空字段【机构名称】
            20220929 温旺清 1、新增字段【实际贷款发放日期、实际贷款终止日期】
            20221011 温旺清 1、新增字段【人行付款账户编号】
            20221222 陈伟峰 调整【后补借据标志】加工逻辑
            20230106 温旺清 补充信息：同步新需求，新增字段【支小再行业类型代码】
            20230704 翟若平 调整主表，将ICMS_ZXZ_BILL_POND调整成主表，并调整相关表的关联条件
            20260402 陈  凭 新增字段【APPL_TYPE_CD 申请类型代码】

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_refac_loan_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_refac_loan_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_refac_loan_attach_info_ex purge;

-- 2.1 insert into ex table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_refac_loan_attach_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_refac_loan_attach_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_refac_loan_attach_info_ex(
     etl_dt                            -- 数据日期
    ,lp_id                            -- 法人编号
    ,level1_batch_pkg_id              -- 一级批次包编号
    ,level1_batch_pkg_name            -- 一级批次包名称
    ,level2_batch_pkg_id              -- 二级批次包编号
    ,level2_batch_pkg_name            -- 二级批次包名称
    ,dubil_id                         -- 借据编号
    ,cust_id                          -- 客户编号
    ,cust_name                        -- 客户名称
    ,indus_type_cd                    -- 行业类型代码
    ,refac_indus_type_cd              -- 支小再行业类型代码	
    ,loan_type_cd                     -- 贷款类型代码
    ,corp_size_cd                     -- 企业规模代码
    ,corp_number                      -- 企业人数
    ,last_year_bus_inco               -- 上年末营业收入
    ,corp_asset_tot                   -- 企业资产总额
    ,mang_main_name                   -- 经营主体名称
    ,mang_main_crdt_cd_descb          -- 经营主体信用代码描述
    ,check_sheet_flg                  -- 报账标志
    ,backup_dubil_flg                 -- 后补借据标志
    ,loan_usage_descb                 -- 贷款用途描述
    ,remark                           -- 备注
    ,pbc_doc_num                      -- 人行文件文号
    ,pbc_doc_name                     -- 人行文件名称
    ,pbc_doc_doc_day                  -- 人行文件发文日
    ,pbc_lmt                          -- 人行额度
    ,appl_tm                          -- 申请时间
    ,applit_id                        -- 申请人编号
    ,appl_org_id                      -- 申请机构编号
    ,appl_type_cd                     -- 申请类型代码
    ,refac_status_cd                  -- 支小再状态代码
    ,apv_status_cd                    -- 审批状态代码
    ,batch_pkg_status_cd              -- 批次包状态代码
    ,refac_amt                        -- 再贷款金额
    ,surp_lmt                         -- 剩余额度
    ,refac_cont_id                    -- 再贷款合同编号
    ,refac_distr_dt                   -- 再贷款发放日期
    ,refac_exp_dt                     -- 再贷款到期日期
    ,actl_loan_distr_dt               -- 实际贷款发放日期
	  ,actl_loan_termnt_dt              -- 实际贷款终止日期
    ,refac_distr_mode_descb           -- 再贷款发放模式描述
    ,refac_kind_descb                 -- 再贷款种类描述
    ,use_int_rat                      -- 使用利率
    ,int_accr_way_descb               -- 计息方式描述
    ,belong_land_pbc_fin_inst_code    -- 所属地人民银行金融机构编码
    ,belong_land_pbc_name             -- 所属地人民银行名称
    ,belong_land_pbc_corp_princ_name  -- 所属地人民银行单位负责人姓名
    ,corp_phone_num                   -- 单位联系电话号码
    ,corp_addr                        -- 单位地址
    ,org_name                         -- 机构名称
    ,recvbl_acct_id                   -- 收款账户编号
    ,pbc_cred_rht_type_descb          -- 人民银行债权类型描述
    ,pbc_pay_acct_id                  -- 人行付款账户编号
    ,pmo_type_cd                      -- 抵质押物类型代码
    ,pmo_cont_id                      -- 抵质押物合同编号
    ,pmo_amt_evltion                  -- 抵质押物金额估值
    ,pmo_amt_evltion_tot              -- 抵质押物金额估值汇总
    ,cred_rht_bal                     -- 债权余额
    ,job_cd                           -- 任务代码
    ,etl_timestamp                    -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                               -- 数据日期
      ,'9999'                                                            -- 法人编号	  
      ,t3.batch_pkg_id                                                   -- 一级批次包编号
      ,t3.batch_pkg_name                                                   -- 一级批次包名称
      ,t2.batch_pkg_id                                                   -- 二级批次包编号
      ,t2.batch_pkg_name                                                 -- 二级批次包名称
      ,t6.dubil_id                                                       -- 借据编号
      ,t4.cust_id                                                        -- 客户编号
      ,t4.cust_name                                                      -- 客户名称
      ,t1.indus_type_cd                                                  -- 行业类型代码
      ,t1.rzxz_indus_type_cd                                              -- 支小再行业类型代码	
      ,t1.loan_kind_cd                                                   -- 贷款类型代码
      ,t1.corp_size_cd                                                   -- 企业规模代码
      ,t1.corp_number                                                    -- 企业人数
      ,t1.last_year_bus_inco                                             -- 上年末营业收入
      ,t1.corp_asset_tot                                                 -- 企业资产总额
      ,t5.businessname                                                   -- 经营主体名称
      ,t5.certid                                                         -- 经营主体信用代码描述
      ,t4.refac_loan_idf_cd                                              -- 报账标志
      ,decode(t1.in_pool_idf_cd,'3','1','0')                            -- 后补借据标志
      ,t1.loan_usage_descb                                               -- 贷款用途描述
      ,t1.remark                                                         -- 备注
      ,t3.pbc_doc_id                                                     -- 人行文件文号
      ,t3.pbc_doc_name                                                   -- 人行文件名称
      ,t3.pbc_doc_doc_dt                                                 -- 人行文件发文日
      ,t3.pbc_lmt                                                        -- 人行额度
      ,t2.rgst_dt                                                        -- 申请时间
      ,t2.rgst_teller_id                                                 -- 申请人编号
      ,t2.rgst_org_id                                                    -- 申请机构编号
      ,t9.appl_type_cd                                                   -- 申请类型代码
      ,t4.refac_loan_idf_cd                                              -- 支小再状态代码
      ,t9.brch_apv_status_cd                                             -- 审批状态代码
      ,t2.valid_flg                                                      -- 批次包状态代码
      ,t2.refac_amt                                                      -- 再贷款金额
      ,t2.surp_lmt                                                       -- 剩余额度
      ,t2.refac_cont_id                                                  -- 再贷款合同编号
      ,t2.refac_distr_dt                                                 -- 再贷款发放日期
      ,t2.refac_exp_dt                                                   -- 再贷款到期日期
      ,t1.actl_loan_distr_dt                                             -- 实际贷款发放日期
      ,t1.actl_loan_termnt_dt                                            -- 实际贷款终止日期      
      ,t8.cd_descb                                                       -- 再贷款发放模式描述
      ,t2.refac_kind_descb                                               -- 再贷款种类描述
      ,t2.use_int_rat                                                    -- 使用利率
      ,t2.int_accr_way_descb                                             -- 计息方式描述
      ,t2.bl_pbc_fin_inst_code                                           -- 所属地人民银行金融机构编码
      ,t2.bl_pbc_name                                                    -- 所属地人民银行名称
      ,t2.bl_pbc_corp_princ_name                                         -- 所属地人民银行单位负责人姓名
      ,t2.corp_phone_num                                                 -- 单位联系电话号码
      ,t2.corp_addr                                                      -- 单位地址
      ,''                                                                -- 机构名称
      ,t2.cap_enter_acct_id                                              -- 收款账户编号
      ,t2.bl_pbc_bond_type_descb                                         -- 人民银行债权类型描述
      ,t2.cap_out_acct_id                                                -- 人行付款账户编号
      ,t7.pmo_type_descb                                                 -- 抵质押物类型代码
      ,t7.pmo_cont_id                                                    -- 抵质押物合同编号
      ,t7.pmo_evltion                                                    -- 抵质押物金额估值
      ,t2.pmo_amt_evltion_tot                                            -- 抵质押物金额估值汇总
      ,t2.cred_rht_bal                                                   -- 债权余额
      ,t1.job_cd                                                         -- 任务代码
      ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- 数据处理时间	
  from ${iml_schema}.agt_zxz_dubil_pool_info_h t6 
  left join ${iml_schema}.agt_refac_dubil_pkg_rela_h t1
    on t1.dubil_id = t6.dubil_id
   and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
   and t1.job_cd = 'icmsf1'
   and t1.in_pool_idf_cd = '1'
   and exists (select 1 from  ${iol_schema}.icms_zxz_iqp_loan_info ii 
                where ii.serno = t1.apv_flow_num 
                  and ii.approvestatus = 'Finished'
                  and ii.start_dt <= to_date('${batch_date}','yyyymmdd')
                  and ii.end_dt > to_date('${batch_date}','yyyymmdd'))
  left join ${iml_schema}.agt_refac_loan_batch_pkg_h t2 
    on t6.batch_pkg_id = t2.batch_pkg_id
   and t2.batch_pkg_idf_cd = '2'	
   and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
   and t2.job_cd = 'icmsf1'	
  left join ${iml_schema}.agt_refac_loan_batch_pkg_h t3 
    on t2.rela_batch_pkg_id = t3.batch_pkg_id
   and t3.batch_pkg_idf_cd = '1'	
   and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
   and t3.job_cd = 'icmsf1'	
  left join ${iml_schema}.agt_loan_dubil_info_h t4 
    on t6.dubil_id = t4.dubil_id
   and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
   and t4.job_cd = 'icmsf1'	
  left join ${iol_schema}.icms_ind_economic t5 
    on t4.cust_id = t5.customerid
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')  
  left join (select batch_pkg_id,pmo_type_descb,pmo_cont_id,pmo_evltion,row_number() over(partition by batch_pkg_id order by APPL_FLOW_NUM desc) rn 
               from ${iml_schema}.agt_zxz_appl_pmo_rela_h 
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')	  
                and job_cd = 'icmsf1')	t7 
    on t6.batch_pkg_id = t7.batch_pkg_id
   and t7.rn=1
  left join ${iml_schema}.ref_pub_cd t8 
    on t8.cd_val = t2.refac_distr_mode_cd
   and t8.cd_id	= 'CD1400'
  left join (select st.*,row_number() over(partition by batch_pkg_id order by RGST_DT desc) rn 
               from ${iml_schema}.agt_zxz_appl_info_h st
              where st.job_cd = 'icmsf1'
                and st.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and st.end_dt > to_date('${batch_date}', 'yyyymmdd')) t9
    on t6.batch_pkg_id = t9.batch_pkg_id	
   and t9.rn = 1
  where trim(t6.batch_pkg_id) is not null
    and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')	  
    and t6.job_cd = 'icmsf1'
;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_refac_loan_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_refac_loan_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_refac_loan_attach_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_refac_loan_attach_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);