/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_corp
CreateDate: 20210918
FileType:   DML
Logs:
    sundexin
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.pty_corp drop partition p_${last_date};
alter table ${idl_schema}.pty_corp drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_corp add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_corp (
 etl_dt                          --数据日期                    
,party_id                        --当事人编号                  
,lp_id                           --法人编号                    
,depositr_cate_cd                --存款人类别代码              
,corp_name                       --公司名称                    
,corp_en_name                    --公司英文名称                
,soci_crdt_cd                    --统一社会信用代码            
,curr_cd                         --币种代码                    
,rgst_cap                        --注册资金                    
,rgst_addr                       --注册地址                    
,cty_rg_cd                       --国家和地区代码              
,indus_type_cd                   --行业类型代码                
,econ_char_cd                    --经济性质代码                
,taxpayer_idtfy_num              --纳税人识别号                
,corp_type_cd                    --企业类型代码                
,tax_stament_flg                 --取得税收居民取得自证声明标志
,tax_org_cate_cd                 --税收机构类别代码            
,tax_resdnt_cty_cd               --税收居民国家代码组合        
,tax_resdnt_idti_cd              --税收居民身份代码            
,emply_qtty                      --员工数量                    
,fin_subsidy_inco_src_cd         --财政补助收入来源代码        
,strategy_camp_cust_no           --策略营销客户号              
,ins_adj_type_cd                 --产业结构调整类型代码        
,single_lmt                      --单一限额                    
,single_lp_flg                   --独立法人标志                
,high_new_tech_corp_flg          --高新技术企业标志            
,itau_flg                        --工业转型升级标志            
,rela_party_flg                  --关联方标志                  
,rela_group_type_cd              --关联集团类型代码            
,org_type_cd                     --机构类型代码                
,org_status_cd                   --机构状态代码                
,group_cust_flg                  --集团客户标志                
,weight_risk_asset_cust_cls_cd   --加权风险资产客户分类代码    
,cbrc_sb_flg                     --银监小企业标志              
,econ_type_cd                    --经济类型代码                
,oper_range                      --经营范围                    
,cust_sev_ugd_cls_cd             --客户服务升级分类代码        
,hold_type_cd                    --控股类型代码                
,off_shore_cust_flg              --离岸客户标志                
,subj_org_name                   --隶属机构名称                
,prit_etp_flg                    --民营企业标志                
,ctysd_corp_flg                  --农村企业标志                
,corp_found_dt                   --企业成立日期                
,corp_size_cd                    --企业规模代码                
,corp_size_cd_intnal             --企业规模代码_内部           
,ta_cust_size                    --商圈客户规模                
,ta_cust_indus_status            --商圈客户行业地位            
,list_corp_type_cd               --上市公司类型代码            
,list_corp_flg                   --上市企业标志                
,crdt_strategy_cd                --授信策略代码                
,crdt_cust_flg                   --授信客户标志                
,bel_thi_flg                     --属于两高行业标志            
,rgst_dt                         --注册日期                    
,orgnz_type_cd                   --组织机构类型代码            
,orgnz_type_subdv_cd             --组织机构类型细分代码        
,econ_orgnz_form_cd              --经济组织形式代码            
,trast_tax_regi_cert_flg         --办理税务登记证标志          
,fin_stat_type_cd                --财务报表类型代码            
,jnor_cog_over_number            --大专以上人数                
,cty_key_enterp_flg              --国家重点企业标志            
,natnal_econ_dept_type_cd        --国民经济部门类型代码        
,indus_type_cd_level5_cls        --行业类型代码_五级分类       
,indus_type_cd_crdt_rating       --行业类型代码_信用评级       
,org_subj                        --机构隶属                    
,group_corp_flg                  --集团公司标志                
,group_cust_id                   --集团编号                    
,resdnt_flg                      --居民标志                    
,open_cap                        --开办资金                    
,cust_lev_cd                     --客户级别代码                
,retire_number                   --离退休人数                  
,super_director_dept             --上级主管部门                
,cause_lp_size_or_lev_cd         --事业法人规模或级别代码      
,cause_lp_cust_type_cd           --事业法人客户类型代码        
,bal_pay_way_cd                  --收支方式代码                
,sys_in_cust_flg                 --系统内客户标志              
,lmt_or_encrge_indus_cd          --限制或鼓励行业代码          
,have_hxb_share_qtty             --拥有我行股份数量            
,have_bod_flg                    --有董事会标志                
,budget_form_cd                  --预算形式代码                
,green_crdt_cust_flg             --绿色信贷客户标志            
,araf_flg                        --三农标志                    
,corp_size_cd_cpes               --企业规模代码_票交所         
,indus_type_cd_cpes              --行业类型代码_票交所         
,orgnz_cd                        --组织机构代码                
,corp_party_type_cd              --对公当事人类型代码          
,rg_cd                           --地区代码                    
,indus_type_cd_crdtc             --行业类型代码_征信           
,indus_categy_cd_crdtc           --行业门类代码_征信           
,tax_num_null_rs_descb           --纳税人识别号空值原因描述    
,non_rec_rs                      --不良记录原因                
,blklist_cust_flg                --黑名单客户标志              
,blklist_rgst_dt                 --黑名单登记日期              
,blklist_rs                      --上黑名单原因                
,loan_card_no                    --贷款卡号                    
,stock_cd                        --股票代码                    
,citizen_treat_flg               --国民待遇标志                
,fir_setup_crdt_rela_dt          --首次建立信贷关系日期        
,mger_member_number              --管理人员人数                
,digit_econ_indus_cd             --数字经济行业代码            
,strtg_new_indus_type_cd         --战略新兴产业类型代码        
,share_ratio                     --持股比例                    
,super_orgnz_cd                  --上级机构组织机构代码        
,super_unify_soci_crdt_cd        --上级机构统一社会信用代码    
,director_corp_rgst_curr_cd      --主管单位注册币种代码        
,director_corp_rgst_amt          --主管单位注册金额            
,shard_type_cd                   --股东类型代码                
,ctrler_type_cd                  --控制人类型代码              
,property_type_cd                --产业类型代码                
,role_type_cd                    --角色类型代码                
,lp_org_name                     --法人机构名称                
,lp_org_type_cd                  --法人机构类型代码            
,lp_org_cust_id                  --法人机构客户编号            
,super_org_cust_id               --上级机构客户编号            
,start_dt                        --开始日期                    
,end_dt                          --结束日期                    
,id_mark                         --删除标识                    
,src_table_name                  --源表名称                    
,job_cd                          --任务代码                    
,etl_timestamp                   --数据处理时间                
)
select
     to_date('${batch_date}','yyyymmdd') as etl_dt                                                                     --数据日期                        
    ,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id                                                    --当事人编号                       
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id                                                          --法人编号                        
    ,replace(replace(t.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd                                    --存款人类别代码                     
    ,replace(replace(t.corp_name,chr(13),''),chr(10),'') as corp_name                                                  --公司名称                        
    ,replace(replace(t.corp_en_name,chr(13),''),chr(10),'') as corp_en_name                                            --公司英文名称                      
    ,replace(replace(t.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd                                            --统一社会信用代码                    
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd                                                      --币种代码                        
    ,t.rgst_cap                                                                                                        --注册资金                        
    ,replace(replace(t.rgst_addr,chr(13),''),chr(10),'') as rgst_addr                                                  --注册地址                        
    ,replace(replace(t.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd                                                  --国家和地区代码                     
    ,replace(replace(t.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd                                          --行业类型代码                      
    ,replace(replace(t.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd                                            --经济性质代码                      
    ,replace(replace(t.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num                                --纳税人识别号                      
    ,replace(replace(t.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd                                            --企业类型代码                      
    ,replace(replace(t.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg                                      --取得税收居民取得自证声明标志              
    ,replace(replace(t.tax_org_cate_cd,chr(13),''),chr(10),'') as tax_org_cate_cd                                      --税收机构类别代码                    
    ,replace(replace(t.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd                                  --税收居民国家代码组合                  
    ,replace(replace(t.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd                                --税收居民身份代码                    
    ,t.emply_qtty                                                                                                      --员工数量                        
    ,replace(replace(t.fin_subsidy_inco_src_cd,chr(13),''),chr(10),'') as fin_subsidy_inco_src_cd                      --财政补助收入来源代码                  
    ,replace(replace(t.strategy_camp_cust_no,chr(13),''),chr(10),'') as strategy_camp_cust_no                          --策略营销客户号                     
    ,replace(replace(t.ins_adj_type_cd,chr(13),''),chr(10),'') as ins_adj_type_cd                                      --产业结构调整类型代码                  
    ,t.single_lmt                                                                                                      --单一限额                        
    ,replace(replace(t.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg                                          --独立法人标志                      
    ,replace(replace(t.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg                        --高新技术企业标志                    
    ,replace(replace(t.itau_flg,chr(13),''),chr(10),'') as itau_flg                                                    --工业转型升级标志                    
    ,replace(replace(t.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg                                        --关联方标志                       
    ,replace(replace(t.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd                                --关联集团类型代码                    
    ,replace(replace(t.org_type_cd,chr(13),''),chr(10),'') as org_type_cd                                              --机构类型代码                      
    ,replace(replace(t.org_status_cd,chr(13),''),chr(10),'') as org_status_cd                                          --机构状态代码                      
    ,replace(replace(t.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg                                        --集团客户标志                      
    ,replace(replace(t.weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'') as weight_risk_asset_cust_cls_cd          --加权风险资产客户分类代码                
    ,replace(replace(t.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg                                              --银监小企业标志                     
    ,replace(replace(t.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd                                            --经济类型代码                      
    ,replace(replace(t.oper_range,chr(13),''),chr(10),'') as oper_range                                                --经营范围                        
    ,replace(replace(t.cust_sev_ugd_cls_cd,chr(13),''),chr(10),'') as cust_sev_ugd_cls_cd                              --客户服务升级分类代码                  
    ,replace(replace(t.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd                                            --控股类型代码                      
    ,replace(replace(t.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg                                --离岸客户标志                      
    ,replace(replace(t.subj_org_name,chr(13),''),chr(10),'') as subj_org_name                                          --隶属机构名称                      
    ,replace(replace(t.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg                                            --民营企业标志                      
    ,replace(replace(t.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg                                        --农村企业标志                      
    ,t.corp_found_dt                                                                                                   --企业成立日期                      
    ,replace(replace(t.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd                                            --企业规模代码                      
    ,replace(replace(t.corp_size_cd_intnal,chr(13),''),chr(10),'') as corp_size_cd_intnal                              --企业规模代码_内部                   
    ,replace(replace(t.ta_cust_size,chr(13),''),chr(10),'') as ta_cust_size                                            --商圈客户规模                      
    ,replace(replace(t.ta_cust_indus_status,chr(13),''),chr(10),'') as ta_cust_indus_status                            --商圈客户行业地位                    
    ,replace(replace(t.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd                                  --上市公司类型代码                    
    ,replace(replace(t.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg                                          --上市企业标志                      
    ,replace(replace(t.crdt_strategy_cd,chr(13),''),chr(10),'') as crdt_strategy_cd                                    --授信策略代码                      
    ,replace(replace(t.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg                                          --授信客户标志                      
    ,replace(replace(t.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg                                              --属于两高行业标志                    
    ,t.rgst_dt                                                                                                         --注册日期                        
    ,replace(replace(t.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd                                          --组织机构类型代码                    
    ,replace(replace(t.orgnz_type_subdv_cd,chr(13),''),chr(10),'') as orgnz_type_subdv_cd                              --组织机构类型细分代码                  
    ,replace(replace(t.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd                                --经济组织形式代码                    
    ,replace(replace(t.trast_tax_regi_cert_flg,chr(13),''),chr(10),'') as trast_tax_regi_cert_flg                      --办理税务登记证标志                   
    ,replace(replace(t.fin_stat_type_cd,chr(13),''),chr(10),'') as fin_stat_type_cd                                    --财务报表类型代码                    
    ,t.jnor_cog_over_number                                                                                            --大专以上人数                      
    ,replace(replace(t.cty_key_enterp_flg,chr(13),''),chr(10),'') as cty_key_enterp_flg                                --国家重点企业标志                    
    ,replace(replace(t.natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as natnal_econ_dept_type_cd                    --国民经济部门类型代码                  
    ,replace(replace(t.indus_type_cd_level5_cls,chr(13),''),chr(10),'') as indus_type_cd_level5_cls                    --行业类型代码_五级分类                 
    ,replace(replace(t.indus_type_cd_crdt_rating,chr(13),''),chr(10),'') as indus_type_cd_crdt_rating                  --行业类型代码_信用评级                 
    ,replace(replace(t.org_subj,chr(13),''),chr(10),'') as org_subj                                                    --机构隶属                        
    ,replace(replace(t.group_corp_flg,chr(13),''),chr(10),'') as group_corp_flg                                        --集团公司标志                      
    ,replace(replace(t.group_cust_id,chr(13),''),chr(10),'') as group_cust_id                                          --集团编号                        
    ,replace(replace(t.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg                                                --居民标志                        
    ,t.open_cap                                                                                                        --开办资金                        
    ,replace(replace(t.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd                                              --客户级别代码                      
    ,t.retire_number                                                                                                   --离退休人数                       
    ,replace(replace(t.super_director_dept,chr(13),''),chr(10),'') as super_director_dept                              --上级主管部门                      
    ,replace(replace(t.cause_lp_size_or_lev_cd,chr(13),''),chr(10),'') as cause_lp_size_or_lev_cd                      --事业法人规模或级别代码                 
    ,replace(replace(t.cause_lp_cust_type_cd,chr(13),''),chr(10),'') as cause_lp_cust_type_cd                          --事业法人客户类型代码                  
    ,replace(replace(t.bal_pay_way_cd,chr(13),''),chr(10),'') as bal_pay_way_cd                                        --收支方式代码                      
    ,replace(replace(t.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg                                      --系统内客户标志                     
    ,replace(replace(t.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd                        --限制或鼓励行业代码                   
    ,t.have_hxb_share_qtty                                                                                             --拥有我行股份数量                    
    ,replace(replace(t.have_bod_flg,chr(13),''),chr(10),'') as have_bod_flg                                            --有董事会标志                      
    ,replace(replace(t.budget_form_cd,chr(13),''),chr(10),'') as budget_form_cd                                        --预算形式代码                      
    ,replace(replace(t.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg                              --绿色信贷客户标志                    
    ,replace(replace(t.araf_flg,chr(13),''),chr(10),'') as araf_flg                                                    --三农标志                        
    ,replace(replace(t.corp_size_cd_cpes,chr(13),''),chr(10),'') as corp_size_cd_cpes                                  --企业规模代码_票交所                  
    ,replace(replace(t.indus_type_cd_cpes,chr(13),''),chr(10),'') as indus_type_cd_cpes                                --行业类型代码_票交所                  
    ,replace(replace(t.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd                                                    --组织机构代码                      
    ,replace(replace(t.corp_party_type_cd,chr(13),''),chr(10),'') as corp_party_type_cd                                --对公当事人类型代码                   
    ,replace(replace(t.rg_cd,chr(13),''),chr(10),'') as rg_cd                                                          --地区代码                        
    ,replace(replace(t.indus_type_cd_crdtc,chr(13),''),chr(10),'') as indus_type_cd_crdtc                              --行业类型代码_征信                   
    ,replace(replace(t.indus_categy_cd_crdtc,chr(13),''),chr(10),'') as indus_categy_cd_crdtc                          --行业门类代码_征信                   
    ,replace(replace(t.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb                          --纳税人识别号空值原因描述                
    ,replace(replace(t.non_rec_rs,chr(13),''),chr(10),'') as non_rec_rs                                                --不良记录原因                      
    ,replace(replace(t.blklist_cust_flg,chr(13),''),chr(10),'') as blklist_cust_flg                                    --黑名单客户标志                     
    ,t.blklist_rgst_dt                                                                                                 --黑名单登记日期                     
    ,replace(replace(t.blklist_rs,chr(13),''),chr(10),'') as blklist_rs                                                --上黑名单原因                      
    ,replace(replace(t.loan_card_no,chr(13),''),chr(10),'') as loan_card_no                                            --贷款卡号                        
    ,replace(replace(t.stock_cd,chr(13),''),chr(10),'') as stock_cd                                                    --股票代码                        
    ,replace(replace(t.citizen_treat_flg,chr(13),''),chr(10),'') as citizen_treat_flg                                  --国民待遇标志                      
    ,t.fir_setup_crdt_rela_dt                                                                                          --首次建立信贷关系日期                  
    ,t.mger_member_number                                                                                              --管理人员人数                      
    ,replace(replace(t.digit_econ_indus_cd,chr(13),''),chr(10),'') as digit_econ_indus_cd                              --数字经济行业代码                    
    ,replace(replace(t.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd                      --战略新兴产业类型代码                  
    ,t.share_ratio                                                                                                     --持股比例                        
    ,replace(replace(t.super_orgnz_cd,chr(13),''),chr(10),'') as super_orgnz_cd                                        --上级机构组织机构代码                  
    ,replace(replace(t.super_unify_soci_crdt_cd,chr(13),''),chr(10),'') as super_unify_soci_crdt_cd                    --上级机构统一社会信用代码                
    ,replace(replace(t.director_corp_rgst_curr_cd,chr(13),''),chr(10),'') as director_corp_rgst_curr_cd                --主管单位注册币种代码                  
    ,replace(replace(t.director_corp_rgst_amt,chr(13),''),chr(10),'') as director_corp_rgst_amt                        --主管单位注册金额                    
    ,replace(replace(t.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd                                          --股东类型代码                      
    ,replace(replace(t.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd                                        --控制人类型代码                     
    ,replace(replace(t.property_type_cd,chr(13),''),chr(10),'') as property_type_cd                                    --产业类型代码                      
    ,replace(replace(t.role_type_cd,chr(13),''),chr(10),'') as role_type_cd                                            --角色类型代码                      
    ,replace(replace(t.lp_org_name,chr(13),''),chr(10),'') as lp_org_name                                              --法人机构名称                      
    ,replace(replace(t.lp_org_type_cd,chr(13),''),chr(10),'') as lp_org_type_cd                                        --法人机构类型代码                    
    ,replace(replace(t.lp_org_cust_id,chr(13),''),chr(10),'') as lp_org_cust_id                                        --法人机构客户编号                    
    ,replace(replace(t.super_org_cust_id,chr(13),''),chr(10),'') as super_org_cust_id                                  --上级机构客户编号                    
    ,t.start_dt                                                                                                        --开始日期                        
    ,t.end_dt                                                                                                          --结束日期                        
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark                                                      --删除标识                        
    ,replace(replace(t.src_table_name,chr(13),''),chr(10),'') as src_table_name                                        --源表名称                        
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd                                                        --任务代码                        
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp                                  --数据处理时间                      
from ${iml_schema}.pty_corp t    --公司当事人
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_corp',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);