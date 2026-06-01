/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_indv_cust_basic_info_fund
CreateDate: 20201023
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_indv_cust_basic_info_fund drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_indv_cust_basic_info_fund add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_indv_cust_basic_info_fund partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt                            -- 数据日期                                      
		,lp_id                            -- 法人编号                              
		,cust_id                          -- 客户编号                              
		,cust_type_cd                     -- 客户类型代码                            
		,cert_type_cd                     -- 证件类型代码                            
		,cert_no                          -- 证件号码                                      
		,cert_exp_dt                      -- 证件到期日期                                        
		,cert_issue_org                   -- 证件签发机关                            
		,cust_name                        -- 客户名称                                   
		,cust_en_name                     -- 客户英文名称                              
		,open_acct_dt                     -- 开户日期                                         
		,belong_org_id                    -- 所属机构编号                              
		,open_acct_teller_id              -- 开户柜员编号                        
		,gender_cd                        -- 性别代码                                    
		,open_acct_chn_cd                 -- 开户渠道代码                           
		,birth_dt                         -- 出生日期                                             
		,marriage_situ_cd                 -- 婚姻状况代码                           
		,resd_status_cd                   -- 居住状态代码                             
		,estate_val_cd                    -- 房产价值代码                              
		,owner_type_cd                    -- 业主类型代码                              
		,politic_status_cd                -- 政治面貌代码                          
		,nation_cd                        -- 国籍代码                                    
		,dist_cd                          -- 行政区域代码                                    
		,rg_cd                            -- 地区代码                                        
		,nationty_cd                      -- 民族代码                                  
		,nati_place                       -- 籍贯                                    
		,cust_status_cd                   -- 客户状态代码                             
		,depositr_cate_cd                 -- 存款人类别代码                          
		,prov_pulation_type_cd            -- 供养人口类型代码                    
		,child_number_cd                  -- 子女人数代码                            
		,cont_num                         -- 联系号码                                     
		,open_acct_rsrv_mobile_no         -- 开户预留手机号码                 
		,elec_mail_addr                   -- 电子邮件地址                            
		,cust_lev_cd                      -- 客户级别代码                                
		,edu_cd                           -- 学历代码                                       
		,degree_cd                        -- 学位代码                                    
		,grad_sch                         -- 毕业学校                                    
		,title_cd                         -- 职称代码                                     
		,post_cd                          -- 职务代码                                      
		,career_cd                        -- 职业代码                                    
		,posta_addr                       -- 通讯地址                                  
		,comm_zip_cd                      -- 通讯邮政编码                                
		,resdnt_addr                      -- 常住地址                                 
		,resdnt_zip_cd                    -- 常住邮政编码                              
		,rpr_site                         -- 户口所在地                                   
		,family_addr                      -- 家庭地址                                 
		,family_zip_cd                    -- 家庭邮政编码                              
		,nome_phone_num                   -- 家庭电话号码                             
		,work_unit_name                   -- 工作单位名称                            
		,work_unit_addr                   -- 工作单位地址                            
		,work_unit_tel                    -- 工作单位电话                             
		,work_unit_zip_cd                 -- 工作单位邮政编码                         
		,work_unit_char_cd                -- 工作单位性质代码                        
		,corp_bl_induty_type_cd           -- 单位所属行业类型代码                 
		,corp_work_years                  -- 单位工作年限                              
		,indv_mon_inco                    -- 个人月收入                               
		,indv_anl_inco                    -- 个人年收入                               
		,family_mon_inco                  -- 家庭月收入                             
		,family_anl_inco                  -- 家庭年收入                             
		,tax_resdnt_idti_cd               -- 税收居民身份代码                       
		,tax_red_cty_cd                   -- 税收居民国家代码                           
		,tax_num                          -- 纳税人识别号                                    
		,tax_num_null_rs_descb            -- 纳税人识别号空值原因描述              
		,stament_flg                      -- 自证声明标志                                
		,indv_bus_flg                     -- 个体工商户标志                              
		,sm_bus_owner_flg                 -- 小微企业主标志                          
		,resdnt_flg                       -- 居民标志                                   
		,farm_flg                         -- 农户标志                                     
		,ghb_emply_flg                    -- 本行员工标志                              
		,ghb_shard_flg                    -- 本行股东标志                              
		,crdt_cust_flg                    -- 授信客户标志                              
		,real_name_flg                    -- 实名标志                                
		,dom_overs_flg                    -- 境内外标志                               
		,local_estate_flg                 -- 当地房产标志                           
		,local_soci_secu_flg              -- 当地社保标志                        
		,ctysd_contr_oper_acct_flg        -- 农村承包经营户标志               
		,ghb_rela_peop_flg                -- 本行关系人标志                         
		,hxb_shard_flg                    -- 我行股东标志                              
		,hxb_trast_inter_bus_flg          -- 在我行办理过中间业务标志              
		,hxb_payoff_sal_acct_flg          -- 我行代发工资户标志                 
		,hxb_reg_cust_flg                 -- 我行定期客户标志                         
		,hxb_finc_cust_flg                -- 我行理财客户标志                        
		,hxb_vip_cust_idf                 -- 我行VIP客户标识                        
		,spouse_and_child_img_flg         -- 配偶及子女移民标志                
		,enjoy_cty_prefr_policy_flg       -- 享受国家优惠政策标志             
		,cust_mgr_id                      -- 客户经理编号                                
		,employ_type_cd                   -- 雇佣类型代码                             
		,clos_acct_dt                     -- 销户日期                                         
		,clos_acct_org_id                 -- 销户机构编号                           
		,clos_acct_teller_id              -- 销户柜员编号                        
		,have_car_flg                     -- 拥有汽车标志                               
		,salar_flg                        -- 受薪人士标志                                  
		,civ_sert_flg                     -- 公务员标志                                
		,tax_red_en_name                  -- 税收居民英文名称                         
		,other_career_info                -- 其他职业信息                        
		,curt_corp_empyt_dt               -- 现单位入职日期                                
		,job_cd                           -- 任务代码                                       
		,etl_timestamp                    -- 数据处理时间                                 
)
select
   t1.etl_dt                            -- 数据日期              
   ,t1.lp_id                            -- 法人编号              
   ,t1.cust_id                          -- 客户编号              
   ,t1.cust_type_cd                     -- 客户类型代码            
   ,t1.cert_type_cd                     -- 证件类型代码            
   ,t1.cert_no                          -- 证件号码              
   ,t1.cert_exp_dt                      -- 证件到期日期            
   ,t1.cert_issue_org                   -- 证件签发机关            
   ,t1.cust_name                        -- 客户名称              
   ,t1.cust_en_name                     -- 客户英文名称            
   ,t1.open_acct_dt                     -- 开户日期              
   ,t1.belong_org_id                    -- 所属机构编号            
   ,t1.open_acct_teller_id              -- 开户柜员编号            
   ,t1.gender_cd                        -- 性别代码              
   ,t1.open_acct_chn_cd                 -- 开户渠道代码            
   ,t1.birth_dt                         -- 出生日期              
   ,t1.marriage_situ_cd                 -- 婚姻状况代码            
   ,t1.resd_status_cd                   -- 居住状态代码            
   ,t1.estate_val_cd                    -- 房产价值代码            
   ,t1.owner_type_cd                    -- 业主类型代码            
   ,t1.politic_status_cd                -- 政治面貌代码            
   ,t1.nation_cd                        -- 国籍代码              
   ,t1.dist_cd                          -- 行政区域代码            
   ,t1.rg_cd                            -- 地区代码              
   ,t1.nationty_cd                      -- 民族代码              
   ,t1.nati_place                       -- 籍贯                
   ,t1.cust_status_cd                   -- 客户状态代码            
   ,t1.depositr_cate_cd                 -- 存款人类别代码           
   ,t1.prov_pulation_type_cd            -- 供养人口类型代码          
   ,t1.child_number_cd                  -- 子女人数代码            
   ,t1.cont_num                         -- 联系号码              
   ,t1.open_acct_rsrv_mobile_no         -- 开户预留手机号码          
   ,t1.elec_mail_addr                   -- 电子邮件地址            
   ,t1.cust_lev_cd                      -- 客户级别代码            
   ,t1.edu_cd                           -- 学历代码              
   ,t1.degree_cd                        -- 学位代码              
   ,t1.grad_sch                         -- 毕业学校              
   ,t1.title_cd                         -- 职称代码              
   ,t1.post_cd                          -- 职务代码              
   ,t1.career_cd                        -- 职业代码              
   ,t1.posta_addr                       -- 通讯地址              
   ,t1.comm_zip_cd                      -- 通讯邮政编码            
   ,t1.resdnt_addr                      -- 常住地址              
   ,t1.resdnt_zip_cd                    -- 常住邮政编码            
   ,t1.rpr_site                         -- 户口所在地             
   ,t1.family_addr                      -- 家庭地址              
   ,t1.family_zip_cd                    -- 家庭邮政编码            
   ,t1.nome_phone_num                   -- 家庭电话号码            
   ,t1.work_unit_name                   -- 工作单位名称            
   ,t1.work_unit_addr                   -- 工作单位地址            
   ,t1.work_unit_tel                    -- 工作单位电话            
   ,t1.work_unit_zip_cd                 -- 工作单位邮政编码          
   ,t1.work_unit_char_cd                -- 工作单位性质代码          
   ,t1.corp_bl_induty_type_cd           -- 单位所属行业类型代码        
   ,t1.corp_work_years                  -- 单位工作年限            
   ,t1.indv_mon_inco                    -- 个人月收入             
   ,t1.indv_anl_inco                    -- 个人年收入             
   ,t1.family_mon_inco                  -- 家庭月收入             
   ,t1.family_anl_inco                  -- 家庭年收入             
   ,t1.tax_resdnt_idti_cd               -- 税收居民身份代码          
   ,t1.tax_red_cty_cd                   -- 税收居民国家代码          
   ,t1.tax_num                          -- 纳税人识别号            
   ,t1.tax_num_null_rs_descb            -- 纳税人识别号空值原因描述      
   ,t1.stament_flg                      -- 自证声明标志            
   ,t1.indv_bus_flg                     -- 个体工商户标志           
   ,t1.sm_bus_owner_flg                 -- 小微企业主标志           
   ,t1.resdnt_flg                       -- 居民标志              
   ,t1.farm_flg                         -- 农户标志              
   ,t1.ghb_emply_flg                    -- 本行员工标志            
   ,t1.ghb_shard_flg                    -- 本行股东标志            
   ,t1.crdt_cust_flg                    -- 授信客户标志            
   ,t1.real_name_flg                    -- 实名标志              
   ,t1.dom_overs_flg                    -- 境内外标志             
   ,t1.local_estate_flg                 -- 当地房产标志            
   ,t1.local_soci_secu_flg              -- 当地社保标志            
   ,t1.ctysd_contr_oper_acct_flg        -- 农村承包经营户标志         
   ,t1.ghb_rela_peop_flg                -- 本行关系人标志           
   ,t1.hxb_shard_flg                    -- 我行股东标志            
   ,t1.hxb_trast_inter_bus_flg          -- 在我行办理过中间业务标志      
   ,t1.hxb_payoff_sal_acct_flg          -- 我行代发工资户标志         
   ,t1.hxb_reg_cust_flg                 -- 我行定期客户标志          
   ,t1.hxb_finc_cust_flg                -- 我行理财客户标志          
   ,t1.hxb_vip_cust_idf                 -- 我行VIP客户标识         
   ,t1.spouse_and_child_img_flg         -- 配偶及子女移民标志         
   ,t1.enjoy_cty_prefr_policy_flg       -- 享受国家优惠政策标志        
   ,t1.cust_mgr_id                      -- 客户经理编号            
   ,t1.employ_type_cd                   -- 雇佣类型代码            
   ,t1.clos_acct_dt                     -- 销户日期              
   ,t1.clos_acct_org_id                 -- 销户机构编号            
   ,t1.clos_acct_teller_id              -- 销户柜员编号            
   ,t1.have_car_flg                     -- 拥有汽车标志            
   ,t1.salar_flg                        -- 受薪人士标志            
   ,t1.civ_sert_flg                     -- 公务员标志             
   ,t1.tax_red_en_name                  -- 税收居民英文名称          
   ,t1.other_career_info                -- 其他职业信息            
   ,t1.curt_corp_empyt_dt               -- 现单位入职日期           
   ,t1.job_cd                           -- 任务代码              
   ,t1.etl_timestamp                    -- 数据处理时间           
 from (select tt.* from ${icl_schema}.cmm_indv_cust_basic_info tt 
        where tt.cust_id in (select client_no from (
                             select client_no from ${iol_schema}.nfss_tbclientseller
                              where start_dt <= to_date('${batch_date}','yyyymmdd')
                                and end_dt > to_date('${batch_date}','yyyymmdd')
                              union all  
                             select client_no from ${iol_schema}.nfss_tcs_tbclientseller
                              where start_dt <= to_date('${batch_date}','yyyymmdd')
                                and end_dt > to_date('${batch_date}','yyyymmdd'))
                              group by client_no)
          and tt.etl_dt = to_date('${batch_date}','yyyymmdd')) t1    --个人基本信息表当天
full join (select cc.* from ${icl_schema}.cmm_indv_cust_basic_info cc
            where cc.cust_id in (select client_no from (
                                 select client_no from ${iol_schema}.nfss_tbclientseller
                                  where start_dt <= to_date('${batch_date}','yyyymmdd')-1
                                    and end_dt > to_date('${batch_date}','yyyymmdd')-1
                                  union all  
                                 select client_no from ${iol_schema}.nfss_tcs_tbclientseller
                                  where start_dt <= to_date('${batch_date}','yyyymmdd')-1
                                    and end_dt > to_date('${batch_date}','yyyymmdd')-1)
                                  group by client_no)
         and cc.etl_dt = to_date('${batch_date}','yyyymmdd')-1) t2  -- 个人基本信息表前一天
       on t1.cust_id = t2.cust_id 
where t1.etl_dt is not null and 
       ((t1.cust_id is null) 
           or (t1.cust_type_cd             <>t2.cust_type_cd                
           or t1.cert_type_cd              <>t2.cert_type_cd                
           or t1.cert_no                   <>t2.cert_no                     
           or t1.cert_exp_dt               <>t2.cert_exp_dt                 
           or t1.cert_issue_org            <>t2.cert_issue_org              
           or t1.cust_name                 <>t2.cust_name                   
           or t1.cust_en_name              <>t2.cust_en_name                
           or t1.open_acct_dt              <>t2.open_acct_dt                
           or t1.belong_org_id             <>t2.belong_org_id               
           or t1.open_acct_teller_id       <>t2.open_acct_teller_id         
           or t1.gender_cd                 <>t2.gender_cd                   
           or t1.open_acct_chn_cd          <>t2.open_acct_chn_cd            
           or t1.birth_dt                  <>t2.birth_dt                    
           or t1.marriage_situ_cd          <>t2.marriage_situ_cd            
           or t1.resd_status_cd            <>t2.resd_status_cd              
           or t1.estate_val_cd             <>t2.estate_val_cd               
           or t1.owner_type_cd             <>t2.owner_type_cd               
           or t1.politic_status_cd         <>t2.politic_status_cd           
           or t1.nation_cd                 <>t2.nation_cd                   
           or t1.dist_cd                   <>t2.dist_cd                     
           or t1.rg_cd                     <>t2.rg_cd                       
           or t1.nationty_cd               <>t2.nationty_cd                 
           or t1.nati_place                <>t2.nati_place                  
           or t1.cust_status_cd            <>t2.cust_status_cd              
           or t1.depositr_cate_cd          <>t2.depositr_cate_cd            
           or t1.prov_pulation_type_cd     <>t2.prov_pulation_type_cd       
           or t1.child_number_cd           <>t2.child_number_cd             
           or t1.cont_num                  <>t2.cont_num                    
           or t1.open_acct_rsrv_mobile_no  <>t2.open_acct_rsrv_mobile_no    
           or t1.elec_mail_addr            <>t2.elec_mail_addr              
           or t1.cust_lev_cd               <>t2.cust_lev_cd                 
           or t1.edu_cd                    <>t2.edu_cd                      
           or t1.degree_cd                 <>t2.degree_cd                   
           or t1.grad_sch                  <>t2.grad_sch                    
           or t1.title_cd                  <>t2.title_cd                    
           or t1.post_cd                   <>t2.post_cd                     
           or t1.career_cd                 <>t2.career_cd                   
           or t1.posta_addr                <>t2.posta_addr                  
           or t1.comm_zip_cd               <>t2.comm_zip_cd                 
           or t1.resdnt_addr               <>t2.resdnt_addr                 
           or t1.resdnt_zip_cd             <>t2.resdnt_zip_cd               
           or t1.rpr_site                  <>t2.rpr_site                    
           or t1.family_addr               <>t2.family_addr                 
           or t1.family_zip_cd             <>t2.family_zip_cd               
           or t1.nome_phone_num            <>t2.nome_phone_num              
           or t1.work_unit_name            <>t2.work_unit_name              
           or t1.work_unit_addr            <>t2.work_unit_addr              
           or t1.work_unit_tel             <>t2.work_unit_tel               
           or t1.work_unit_zip_cd          <>t2.work_unit_zip_cd            
           or t1.work_unit_char_cd         <>t2.work_unit_char_cd           
           or t1.corp_bl_induty_type_cd    <>t2.corp_bl_induty_type_cd      
           or t1.corp_work_years           <>t2.corp_work_years             
           or t1.indv_mon_inco             <>t2.indv_mon_inco               
           or t1.indv_anl_inco             <>t2.indv_anl_inco               
           or t1.family_mon_inco           <>t2.family_mon_inco             
           or t1.family_anl_inco           <>t2.family_anl_inco             
           or t1.tax_resdnt_idti_cd        <>t2.tax_resdnt_idti_cd          
           or t1.tax_red_cty_cd            <>t2.tax_red_cty_cd              
           or t1.tax_num                   <>t2.tax_num                     
           or t1.tax_num_null_rs_descb     <>t2.tax_num_null_rs_descb       
           or t1.stament_flg               <>t2.stament_flg                 
           or t1.indv_bus_flg              <>t2.indv_bus_flg                
           or t1.sm_bus_owner_flg          <>t2.sm_bus_owner_flg            
           or t1.resdnt_flg                <>t2.resdnt_flg                  
           or t1.farm_flg                  <>t2.farm_flg                    
           or t1.ghb_emply_flg             <>t2.ghb_emply_flg               
           or t1.ghb_shard_flg             <>t2.ghb_shard_flg               
           or t1.crdt_cust_flg             <>t2.crdt_cust_flg               
           or t1.real_name_flg             <>t2.real_name_flg               
           or t1.dom_overs_flg             <>t2.dom_overs_flg               
           or t1.local_estate_flg          <>t2.local_estate_flg            
           or t1.local_soci_secu_flg       <>t2.local_soci_secu_flg         
           or t1.ctysd_contr_oper_acct_flg <>t2.ctysd_contr_oper_acct_flg   
           or t1.ghb_rela_peop_flg         <>t2.ghb_rela_peop_flg           
           or t1.hxb_shard_flg             <>t2.hxb_shard_flg               
           or t1.hxb_trast_inter_bus_flg   <>t2.hxb_trast_inter_bus_flg     
           or t1.hxb_payoff_sal_acct_flg   <>t2.hxb_payoff_sal_acct_flg     
           or t1.hxb_reg_cust_flg          <>t2.hxb_reg_cust_flg            
           or t1.hxb_finc_cust_flg         <>t2.hxb_finc_cust_flg           
           or t1.hxb_vip_cust_idf          <>t2.hxb_vip_cust_idf            
           or t1.spouse_and_child_img_flg  <>t2.spouse_and_child_img_flg    
           or t1.enjoy_cty_prefr_policy_flg<>t2.enjoy_cty_prefr_policy_flg  
           or t1.cust_mgr_id               <>t2.cust_mgr_id                 
           or t1.employ_type_cd            <>t2.employ_type_cd              
           or t1.clos_acct_dt              <>t2.clos_acct_dt                
           or t1.clos_acct_org_id          <>t2.clos_acct_org_id            
           or t1.clos_acct_teller_id       <>t2.clos_acct_teller_id         
           or t1.have_car_flg              <>t2.have_car_flg                
           or t1.salar_flg                 <>t2.salar_flg                   
           or t1.civ_sert_flg              <>t2.civ_sert_flg                
           or t1.tax_red_en_name           <>t2.tax_red_en_name             
           or t1.other_career_info         <>t2.other_career_info           
           or t1.curt_corp_empyt_dt        <>t2.curt_corp_empyt_dt                 
          ));
commit;

--2.4 比对新开户客户，插入目标表
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_indv_cust_basic_info_fund partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt                            -- 数据日期                                      
		,lp_id                            -- 法人编号                              
		,cust_id                          -- 客户编号                              
		,cust_type_cd                     -- 客户类型代码                            
		,cert_type_cd                     -- 证件类型代码                            
		,cert_no                          -- 证件号码                                      
		,cert_exp_dt                      -- 证件到期日期                                        
		,cert_issue_org                   -- 证件签发机关                            
		,cust_name                        -- 客户名称                                   
		,cust_en_name                     -- 客户英文名称                              
		,open_acct_dt                     -- 开户日期                                         
		,belong_org_id                    -- 所属机构编号                              
		,open_acct_teller_id              -- 开户柜员编号                        
		,gender_cd                        -- 性别代码                                    
		,open_acct_chn_cd                 -- 开户渠道代码                           
		,birth_dt                         -- 出生日期                                             
		,marriage_situ_cd                 -- 婚姻状况代码                           
		,resd_status_cd                   -- 居住状态代码                             
		,estate_val_cd                    -- 房产价值代码                              
		,owner_type_cd                    -- 业主类型代码                              
		,politic_status_cd                -- 政治面貌代码                          
		,nation_cd                        -- 国籍代码                                    
		,dist_cd                          -- 行政区域代码                                    
		,rg_cd                            -- 地区代码                                        
		,nationty_cd                      -- 民族代码                                  
		,nati_place                       -- 籍贯                                    
		,cust_status_cd                   -- 客户状态代码                             
		,depositr_cate_cd                 -- 存款人类别代码                          
		,prov_pulation_type_cd            -- 供养人口类型代码                    
		,child_number_cd                  -- 子女人数代码                            
		,cont_num                         -- 联系号码                                     
		,open_acct_rsrv_mobile_no         -- 开户预留手机号码                 
		,elec_mail_addr                   -- 电子邮件地址                            
		,cust_lev_cd                      -- 客户级别代码                                
		,edu_cd                           -- 学历代码                                       
		,degree_cd                        -- 学位代码                                    
		,grad_sch                         -- 毕业学校                                    
		,title_cd                         -- 职称代码                                     
		,post_cd                          -- 职务代码                                      
		,career_cd                        -- 职业代码                                    
		,posta_addr                       -- 通讯地址                                  
		,comm_zip_cd                      -- 通讯邮政编码                                
		,resdnt_addr                      -- 常住地址                                 
		,resdnt_zip_cd                    -- 常住邮政编码                              
		,rpr_site                         -- 户口所在地                                   
		,family_addr                      -- 家庭地址                                 
		,family_zip_cd                    -- 家庭邮政编码                              
		,nome_phone_num                   -- 家庭电话号码                             
		,work_unit_name                   -- 工作单位名称                            
		,work_unit_addr                   -- 工作单位地址                            
		,work_unit_tel                    -- 工作单位电话                             
		,work_unit_zip_cd                 -- 工作单位邮政编码                         
		,work_unit_char_cd                -- 工作单位性质代码                        
		,corp_bl_induty_type_cd           -- 单位所属行业类型代码                 
		,corp_work_years                  -- 单位工作年限                              
		,indv_mon_inco                    -- 个人月收入                               
		,indv_anl_inco                    -- 个人年收入                               
		,family_mon_inco                  -- 家庭月收入                             
		,family_anl_inco                  -- 家庭年收入                             
		,tax_resdnt_idti_cd               -- 税收居民身份代码                       
		,tax_red_cty_cd                   -- 税收居民国家代码                           
		,tax_num                          -- 纳税人识别号                                    
		,tax_num_null_rs_descb            -- 纳税人识别号空值原因描述              
		,stament_flg                      -- 自证声明标志                                
		,indv_bus_flg                     -- 个体工商户标志                              
		,sm_bus_owner_flg                 -- 小微企业主标志                          
		,resdnt_flg                       -- 居民标志                                   
		,farm_flg                         -- 农户标志                                     
		,ghb_emply_flg                    -- 本行员工标志                              
		,ghb_shard_flg                    -- 本行股东标志                              
		,crdt_cust_flg                    -- 授信客户标志                              
		,real_name_flg                    -- 实名标志                                
		,dom_overs_flg                    -- 境内外标志                               
		,local_estate_flg                 -- 当地房产标志                           
		,local_soci_secu_flg              -- 当地社保标志                        
		,ctysd_contr_oper_acct_flg        -- 农村承包经营户标志               
		,ghb_rela_peop_flg                -- 本行关系人标志                         
		,hxb_shard_flg                    -- 我行股东标志                              
		,hxb_trast_inter_bus_flg          -- 在我行办理过中间业务标志              
		,hxb_payoff_sal_acct_flg          -- 我行代发工资户标志                 
		,hxb_reg_cust_flg                 -- 我行定期客户标志                         
		,hxb_finc_cust_flg                -- 我行理财客户标志                        
		,hxb_vip_cust_idf                 -- 我行VIP客户标识                        
		,spouse_and_child_img_flg         -- 配偶及子女移民标志                
		,enjoy_cty_prefr_policy_flg       -- 享受国家优惠政策标志             
		,cust_mgr_id                      -- 客户经理编号                                
		,employ_type_cd                   -- 雇佣类型代码                             
		,clos_acct_dt                     -- 销户日期                                         
		,clos_acct_org_id                 -- 销户机构编号                           
		,clos_acct_teller_id              -- 销户柜员编号                        
		,have_car_flg                     -- 拥有汽车标志                               
		,salar_flg                        -- 受薪人士标志                                  
		,civ_sert_flg                     -- 公务员标志                                
		,tax_red_en_name                  -- 税收居民英文名称                         
		,other_career_info                -- 其他职业信息                        
		,curt_corp_empyt_dt               -- 现单位入职日期                                
		,job_cd                           -- 任务代码                                       
		,etl_timestamp                    -- 数据处理时间                                 
)
select
   t1.etl_dt                            -- 数据日期              
   ,t1.lp_id                            -- 法人编号              
   ,t1.cust_id                          -- 客户编号              
   ,t1.cust_type_cd                     -- 客户类型代码            
   ,t1.cert_type_cd                     -- 证件类型代码            
   ,t1.cert_no                          -- 证件号码              
   ,t1.cert_exp_dt                      -- 证件到期日期            
   ,t1.cert_issue_org                   -- 证件签发机关            
   ,t1.cust_name                        -- 客户名称              
   ,t1.cust_en_name                     -- 客户英文名称            
   ,t1.open_acct_dt                     -- 开户日期              
   ,t1.belong_org_id                    -- 所属机构编号            
   ,t1.open_acct_teller_id              -- 开户柜员编号            
   ,t1.gender_cd                        -- 性别代码              
   ,t1.open_acct_chn_cd                 -- 开户渠道代码            
   ,t1.birth_dt                         -- 出生日期              
   ,t1.marriage_situ_cd                 -- 婚姻状况代码            
   ,t1.resd_status_cd                   -- 居住状态代码            
   ,t1.estate_val_cd                    -- 房产价值代码            
   ,t1.owner_type_cd                    -- 业主类型代码            
   ,t1.politic_status_cd                -- 政治面貌代码            
   ,t1.nation_cd                        -- 国籍代码              
   ,t1.dist_cd                          -- 行政区域代码            
   ,t1.rg_cd                            -- 地区代码              
   ,t1.nationty_cd                      -- 民族代码              
   ,t1.nati_place                       -- 籍贯                
   ,t1.cust_status_cd                   -- 客户状态代码            
   ,t1.depositr_cate_cd                 -- 存款人类别代码           
   ,t1.prov_pulation_type_cd            -- 供养人口类型代码          
   ,t1.child_number_cd                  -- 子女人数代码            
   ,t1.cont_num                         -- 联系号码              
   ,t1.open_acct_rsrv_mobile_no         -- 开户预留手机号码          
   ,t1.elec_mail_addr                   -- 电子邮件地址            
   ,t1.cust_lev_cd                      -- 客户级别代码            
   ,t1.edu_cd                           -- 学历代码              
   ,t1.degree_cd                        -- 学位代码              
   ,t1.grad_sch                         -- 毕业学校              
   ,t1.title_cd                         -- 职称代码              
   ,t1.post_cd                          -- 职务代码              
   ,t1.career_cd                        -- 职业代码              
   ,t1.posta_addr                       -- 通讯地址              
   ,t1.comm_zip_cd                      -- 通讯邮政编码            
   ,t1.resdnt_addr                      -- 常住地址              
   ,t1.resdnt_zip_cd                    -- 常住邮政编码            
   ,t1.rpr_site                         -- 户口所在地             
   ,t1.family_addr                      -- 家庭地址              
   ,t1.family_zip_cd                    -- 家庭邮政编码            
   ,t1.nome_phone_num                   -- 家庭电话号码            
   ,t1.work_unit_name                   -- 工作单位名称            
   ,t1.work_unit_addr                   -- 工作单位地址            
   ,t1.work_unit_tel                    -- 工作单位电话            
   ,t1.work_unit_zip_cd                 -- 工作单位邮政编码          
   ,t1.work_unit_char_cd                -- 工作单位性质代码          
   ,t1.corp_bl_induty_type_cd           -- 单位所属行业类型代码        
   ,t1.corp_work_years                  -- 单位工作年限            
   ,t1.indv_mon_inco                    -- 个人月收入             
   ,t1.indv_anl_inco                    -- 个人年收入             
   ,t1.family_mon_inco                  -- 家庭月收入             
   ,t1.family_anl_inco                  -- 家庭年收入             
   ,t1.tax_resdnt_idti_cd               -- 税收居民身份代码          
   ,t1.tax_red_cty_cd                   -- 税收居民国家代码          
   ,t1.tax_num                          -- 纳税人识别号            
   ,t1.tax_num_null_rs_descb            -- 纳税人识别号空值原因描述      
   ,t1.stament_flg                      -- 自证声明标志            
   ,t1.indv_bus_flg                     -- 个体工商户标志           
   ,t1.sm_bus_owner_flg                 -- 小微企业主标志           
   ,t1.resdnt_flg                       -- 居民标志              
   ,t1.farm_flg                         -- 农户标志              
   ,t1.ghb_emply_flg                    -- 本行员工标志            
   ,t1.ghb_shard_flg                    -- 本行股东标志            
   ,t1.crdt_cust_flg                    -- 授信客户标志            
   ,t1.real_name_flg                    -- 实名标志              
   ,t1.dom_overs_flg                    -- 境内外标志             
   ,t1.local_estate_flg                 -- 当地房产标志            
   ,t1.local_soci_secu_flg              -- 当地社保标志            
   ,t1.ctysd_contr_oper_acct_flg        -- 农村承包经营户标志         
   ,t1.ghb_rela_peop_flg                -- 本行关系人标志           
   ,t1.hxb_shard_flg                    -- 我行股东标志            
   ,t1.hxb_trast_inter_bus_flg          -- 在我行办理过中间业务标志      
   ,t1.hxb_payoff_sal_acct_flg          -- 我行代发工资户标志         
   ,t1.hxb_reg_cust_flg                 -- 我行定期客户标志          
   ,t1.hxb_finc_cust_flg                -- 我行理财客户标志          
   ,t1.hxb_vip_cust_idf                 -- 我行VIP客户标识         
   ,t1.spouse_and_child_img_flg         -- 配偶及子女移民标志         
   ,t1.enjoy_cty_prefr_policy_flg       -- 享受国家优惠政策标志        
   ,t1.cust_mgr_id                      -- 客户经理编号            
   ,t1.employ_type_cd                   -- 雇佣类型代码            
   ,t1.clos_acct_dt                     -- 销户日期              
   ,t1.clos_acct_org_id                 -- 销户机构编号            
   ,t1.clos_acct_teller_id              -- 销户柜员编号            
   ,t1.have_car_flg                     -- 拥有汽车标志            
   ,t1.salar_flg                        -- 受薪人士标志            
   ,t1.civ_sert_flg                     -- 公务员标志             
   ,t1.tax_red_en_name                  -- 税收居民英文名称          
   ,t1.other_career_info                -- 其他职业信息            
   ,t1.curt_corp_empyt_dt               -- 现单位入职日期           
   ,t1.job_cd                           -- 任务代码              
   ,t1.etl_timestamp                    -- 数据处理时间           
 from ${icl_schema}.cmm_indv_cust_basic_info t1 
 where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
  and not exists (select 1 from ${idl_schema}.cmm_indv_cust_basic_info_fund tt
                   where tt.cust_id =t1.cust_id
                     and tt.etl_dt = to_date('${batch_date}','yyyymmdd'))
  and t1.cust_id in (select client_no from (
                       select client_no from ${iol_schema}.nfss_tbclientseller
                        where start_dt <= to_date('${batch_date}','yyyymmdd')
                          and end_dt > to_date('${batch_date}','yyyymmdd')
                          and ${iml_schema}.dateformat_min(open_date) =to_date('${batch_date}','yyyymmdd')
                        union all  
                       select client_no from ${iol_schema}.nfss_tcs_tbclientseller
                        where start_dt <= to_date('${batch_date}','yyyymmdd')
                          and end_dt > to_date('${batch_date}','yyyymmdd')
                          and ${iml_schema}.dateformat_min(open_date) =to_date('${batch_date}','yyyymmdd'))
                          group by client_no)
       ;
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_indv_cust_basic_info_fund to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_indv_cust_basic_info_fund',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);