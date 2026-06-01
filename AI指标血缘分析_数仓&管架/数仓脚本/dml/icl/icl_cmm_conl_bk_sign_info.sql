/*
Purpose:    共性加工层-企业网银签约信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220630 icl_cmm_conl_bk_sign_info
CreateDate: 20200627
Logs:       

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_conl_bk_sign_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_conl_bk_sign_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_conl_bk_sign_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_conl_bk_sign_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_conl_bk_sign_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_conl_bk_sign_info_ex(
    etl_dt                                                    -- 数据日期
    ,LP_ID                                                    -- 法人编号
    ,cust_id                                                  -- 客户编号      
    ,cust_cn_name                                             -- 客户中文名称    
    ,cust_en_name                                             -- 客户英文名称    
    ,open_acct_tm                                             -- 开户时间      
    ,open_acct_brch_id                                        -- 开户分行编号    
    ,open_acct_brac_id                                        -- 开户网点编号    
    ,belong_brac_id                                           -- 归属网点编号    
    ,open_acct_operr_id                                       -- 开户操作员编号   
    ,sign_chn_cd                                              -- 签约渠道代码
    ,cust_mgr_id                                              -- 客户经理编号    
    ,group_cust_flg                                           -- 集团客户标志    
    ,cash_ctrl_flg                                            -- 现金控制标志    
    ,sup_chain_sys_flg                                        -- 供应链系统标志   
    ,sign_yqt_flg                                             -- 签约银企通标志   
    ,onl_bank_cust_type_cd                                    -- 网银客户类型代码  
    ,onl_bank_cust_status_cd                                  -- 网银客户状态代码  
    ,cert_type_cd                                             -- 证件类型代码    
    ,cert_no                                                  -- 证件号码      
    ,orgnz_cd                                                 -- 组织机构代码    
    ,legal_rep_name                                           -- 法人代表名称    
    ,lp_cert_type_cd                                          -- 法人证件类型代码  
    ,lp_cert_no                                               -- 法人证件号码    
    ,lp_tel_num                                               -- 法人电话号码    
    ,lp_cert_exp_dt                                           -- 法人证件到期日期  
    ,edit_flg                                                 -- 版本标志      
    ,posta_addr                                               -- 通讯地址      
    ,tel_num                                                  -- 电话号码      
    ,fax_num                                                  -- 传真号码      
    ,zip_cd                                                   -- 邮政编码      
    ,charge_acct_id                                           -- 收费账户编号    
    ,charge_curr_cd                                           -- 收费币种代码    
    ,final_tran_tm                                            -- 最后交易时间    
    ,status_modif_descb_info                                  -- 状态变更描述信息  
    ,sign_yqt_tm                                              -- 签约银企通时间   
    ,oa_wrtoff_tm                                             -- OA注销时间    
    ,init_oa_id                                               -- 原OA编号     
    ,oa_reim_rela_acct_id                                     -- OA报销关联账户编号
    ,onl_bank_tran_lmt                                        -- 网银转账限额
    ,job_cd                                                   -- 任务代码
    ,etl_timestamp                                            -- 数据处理时间
)                                                           
select to_date('${batch_date}','yyyymmdd')                                    as  etl_dt                                        -- 数据日期              
       ,t1.lp_id                                                              as  lp_id                                         -- 法人编号         
       ,t1.party_id                                                           as  cust_id                                       -- 客户编号         
       ,t1.cust_cn_name                                                       as  cust_cn_name                                  -- 客户中文名称       
       ,t1.cust_en_name                                                       as  cust_en_name                                  -- 客户英文名称       
       ,t1.open_acct_tm                                                       as  open_acct_tm                                  -- 开户时间         
       ,t1.open_acct_brch_id                                                  as  open_acct_brch_id                             -- 开户分行编号       
       ,t1.open_acct_brac_id                                                  as  open_acct_brac_id                             -- 开户网点编号       
       ,t1.bus_belong_brac_id                                                 as  belong_brac_id                                -- 归属网点编号       
       ,t1.open_acct_operr_id                                                 as  open_acct_operr_id                            -- 开户操作员编号 
       ,t1.sign_chn_cd                                                        as  sign_chn_cd                                   -- 签约渠道代码
       ,t1.cust_mgr_id                                                        as  cust_mgr_id                                   -- 客户经理编号       
       ,t1.group_cust_flg                                                     as  group_cust_flg                                -- 集团客户标志       
       ,t1.cash_ctrl_flg                                                      as  cash_ctrl_flg                                 -- 现金控制标志       
       ,t1.sup_chain_sys_flg                                                  as  sup_chain_sys_flg                             -- 供应链系统标志      
       ,t1.sign_yqt_flg                                                       as  sign_yqt_flg                                  -- 签约银企通标志      
       ,t1.cust_type_cd                                                       as  onl_bank_cust_type_cd                         -- 网银客户类型代码     
       ,t1.acct_status_cd                                                     as  onl_bank_cust_status_cd                       -- 网银客户状态代码     
       ,t1.cert_type_cd                                                       as  cert_type_cd                                  -- 证件类型代码       
       ,t1.cert_no                                                            as  cert_no                                       -- 证件号码         
       ,t1.orgnz_id                                                           as  orgnz_cd                                      -- 组织机构代码       
       ,t1.legal_rep_name                                                     as  legal_rep_name                                -- 法人代表名称       
       ,t1.lp_cert_type_cd                                                    as  lp_cert_type_cd                               -- 法人证件类型代码     
       ,t1.lp_cert_no                                                         as  lp_cert_no                                    -- 法人证件号码       
       ,t1.lp_tel_num                                                         as  lp_tel_num                                    -- 法人电话号码       
       ,t1.lp_cert_exp_dt                                                     as  lp_cert_exp_dt                                -- 法人证件到期日期     
       ,t1.edit_flg                                                           as  edit_flg                                      -- 版本标志         
       ,t1.corp_addr                                                          as  posta_addr                                    -- 通讯地址         
       ,t1.tel_num                                                            as  tel_num                                       -- 电话号码         
       ,t1.fax                                                                as  fax_num                                       -- 传真号码         
       ,t1.zip_cd                                                             as  zip_cd                                        -- 邮政编码         
       ,t1.charge_acct_num                                                    as  charge_acct_id                                -- 收费账户编号       
       ,t1.curr_cd                                                            as  charge_curr_cd                                -- 收费币种代码       
       ,t1.final_update_tm                                                    as  final_tran_tm                                 -- 最后交易时间       
       ,t1.status_remark                                                      as  status_modif_descb_info                       -- 状态变更描述信息     
       ,t1.sign_yqt_tm                                                        as  sign_yqt_tm                                   -- 签约银企通时间      
       ,t1.oa_wrtoff_tm                                                       as  oa_wrtoff_tm                                  -- OA注销时间       
       ,t1.init_oa_id                                                         as  init_oa_id                                    -- 原OA编号        
       ,t1.oa_reim_rela_acct                                                  as  oa_reim_rela_acct_id                          -- OA报销关联账户编号  
       ,nvl(t2.ccl_amount,'0')                                                as  onl_bank_tran_lmt                             -- 网银转账限额
       ,t1.job_cd                                                             as  job_cd                                        -- 任务代码         
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')       as  etl_timestamp                                 -- 数据处理时间       
  from ${iml_schema}.pty_tran_bank_corp_info t1
  left join (select ccl_ecifno
                   ,ccl_amount 
                   ,row_number() over(partition by ccl_ecifno order by ccl_transdate) rn
               from ${iol_schema}.tbps_cpr_cst_limit 
              where ccl_argvalue in('G.1.BETransfer.LimitPerDay','G.5.BETransfer.LimitPerDay','G..BETransfer.LimitPerDay')
                and to_date(ccl_transdate,'yyyymmdd') <to_date('${batch_date}','yyyymmdd')
                and length(ccl_transdate)=8)t2
    on t1.party_id=t2.ccl_ecifno
   and t2.rn=1
 where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t1.job_cd = 'tbpsf1'
   and t1.id_mark <> 'D'
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_conl_bk_sign_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_conl_bk_sign_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_conl_bk_sign_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_conl_bk_sign_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
