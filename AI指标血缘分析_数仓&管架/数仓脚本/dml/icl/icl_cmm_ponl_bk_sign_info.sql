/*
Purpose:    共性加工层-个人网银签约信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_ponl_bk_sign_info
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
--alter table ${icl_schema}.cmm_ponl_bk_sign_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_ponl_bk_sign_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ponl_bk_sign_info_ex purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_ponl_bk_sign_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_ponl_bk_sign_info where 0=1;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_ponl_bk_sign_info_ex(
    etl_dt                                       -- 数据日期
    ,lp_id                                       -- 法人编号
    ,cust_id                                     -- 客户编号    
    ,user_id                                     -- 用户编号    
    ,onl_bank_cust_status_cd                     -- 网银客户状态代码
    ,open_acct_tm                                -- 开户时间    
    ,clos_acct_tm                                -- 销户时间    
    ,ghb_emply_flg                               -- 本行员工标志  
    ,cust_cn_name                                -- 客户中文名称  
    ,cust_en_name                                -- 客户英文名称  
    ,cert_type_cd                                -- 证件类型代码  
    ,cert_no                                     -- 证件号码    
    ,cont_addr                                   -- 联系地址    
    ,phone                                       -- 联系电话    
    ,zip_cd                                      -- 邮政编码    
    ,mobile_no                                   -- 手机号码    
    ,gender_cd                                   -- 性别代码    
    ,work_unit_tel                               -- 工作单位电话  
    ,open_bank_id                                -- 开户行编号   
    ,open_bank_name                              -- 开户行名称   
    ,open_acct_brch_id                           -- 开户分行编号  
    ,open_acct_brch_name                         -- 开户分行名称  
    ,open_acct_org_id                            -- 开户机构编号  
    ,open_acct_org_name                          -- 开户机构名称  
    ,cty                                         -- 国家          
    ,job_cd                                      -- 任务代码
    ,etl_timestamp                               -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                    as  etl_dt                         -- 数据日期     
       ,'9999'                                                                as  lp_id                          -- 法人编号     
       ,t1.pei_ecifno                                                         as  cust_id                        -- 客户编号                                                                                                                              
       ,t1.pei_userno                                                         as  user_id                        -- 用户编号                                                                                                                             
       ,(case when t1.pei_state = '001' then '6'
             when t1.pei_state = '002' then '9'
             when t1.pei_state = '003' then '7'
             when t1.pei_state = '004' then '0'
             when t1.pei_state = '005' then '4'
             else '9' end)                                                   as onl_bank_cust_status_cd          -- 网银客户状态代码                 
       ,${iml_schema}.timeformat_min(t1.pei_opendate)                        as open_acct_tm                     -- 开户时间                                                                                                                                                          
       ,${iml_schema}.timeformat_max(t1.pei_cllosedate)                      as clos_acct_tm                     -- 销户时间                                                                                                                                                          
       ,decode(t1.pei_staffflag, '1', '1', '0')                              as ghb_emply_flg                    -- 本行员工标志                                                                                                                                                        
       ,t1.pei_namecn                                                        as cust_cn_name                     -- 客户中文名称                                                                                                                                                        
       ,t1.pei_nameen                                                        as cust_en_name                     -- 客户英文名称                                                                                                                                                        
       ,t1.pei_ctftype                                                       as cert_type_cd                     -- 证件类型代码                                                                                                                                                        
       ,t1.pei_ctfno                                                         as cert_no                          -- 证件号码                                                                                                                                                          
       ,t1.pei_address                                                       as cont_addr                        -- 联系地址                                                                                                                                                          
       ,t1.pei_phone                                                         as phone                            -- 联系电话                                                                                                                                                          
       ,t1.pei_zipcode                                                       as zip_cd                           -- 邮政编码                                                                                                                                                          
       ,t1.pei_mobile                                                        as mobile_no                        -- 手机号码                                                                                                                                                          
       ,decode(t1.pei_sex, '2', '1', '3', '2', '0')                          as gender_cd                        -- 性别代码                                                                                                                                                          
       ,t1.pei_tel                                                           as work_unit_tel                    -- 工作单位电话                                                                                                                                                        
       ,t1.pei_bankid                                                        as open_bank_id                     -- 开户行编号                                                                                                                                                         
       ,t1.pei_bankname                                                      as open_bank_name                   -- 开户行名称                                                                                                                                                         
       ,t1.pei_branchid                                                      as open_acct_brch_id                -- 开户分行编号                                                                                                                                                        
       ,t1.pei_branchname                                                    as open_acct_brch_name              -- 开户分行名称                                                                                                                                                        
       ,t1.pei_deptid                                                        as open_acct_org_id                 -- 开户机构编号                                                                                                                                                        
       ,t1.pei_deptname                                                      as open_acct_org_name               -- 开户机构名称                                                                                                                                                        
       ,t1.pei_nationality                                                   as cty                              -- 国家                                                                                                                                                            
       ,'osbs'                                                                   as job_cd                           -- 任务代码     
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')      as etl_timestamp                    -- etl处理时间戳
  from ${iol_schema}.osbs_pbs_ecif t1  
  where t1.start_dt <=  to_date('${batch_date}','yyyymmdd') 
  and   t1.end_dt > to_date('${batch_date}','yyyymmdd')      
                                                                                                          
;
commit;

-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_ponl_bk_sign_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_ponl_bk_sign_info_ex;

-- 3.1 drop ex table
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_ponl_bk_sign_info_ex purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_ponl_bk_sign_info',partname => 'p_${batch_date}', degree => 8, cascade => true);
