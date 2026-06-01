/*
purpose:    共性加工层-对公客户补充信息:包括所有的对公客户基本信息，包含了ecif系统的集团客户、公司客户、企业担保客户、同业客户的客户信息。数据来源于ecif系统EIFS。
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_cust_attach_info
createdate: 20200710
logs:       20220128 陈伟峰 新建模型
            20230215 温旺清 新增字段【农业产业化龙头企业标志、农户及新型农业经营主体贷款标志】
            20230330 陈伟峰 新增字段【风险预警行政区划代码】
            20230614 陈伟峰 新增字段【LEI编号】
            20231027 徐子豪 新增字段【投资级客户标志】
            20231222 饶雅   新增字段【受益所有人类型代码】、【受益所有人识别状态代码】
            20240115 饶雅   新增字段【最新更新时间LATEST_UPDATE_TM、最新更新机构编号LATEST_UPDATE_ORG_ID、最新更新渠道代码LATEST_UPDATE_CHN_CD、最新更新柜员编号LATEST_UPDATE_TELLER_ID】
            20240308 饶雅   新增字段【投资级资产负债率ASSET_LIAB_RATIO】、【投资级重大违法违规行为标志MAJOR_FOUL_BEHAV_FLG】
            20240321 饶雅   修改投资级客户标志的取数逻辑，用旧的逻辑数据会重复
            20240322 饶雅   新增字段【投资级财务数据及时更新标志】FIN_DATA_UPDATE_FLG【投资级财务数据报告期】FIN_DATA_REPORT_PRD【投资级财务数据报表类型代码】FIN_DATA_REPT_TYPE_CD【投资级财务报表日期】FIN_STAT_DT
                            新增字段 【产业园企业标志】INDUST_PARK_CORP_FLG、【仅公开市场业务标志】ONLY_PUBLIC_MARKET_BUS_FLG
            20240828 陈伟峰 新增字段【国家技术创新示范企业标志、制造业单项冠军企业标志】
            20240918 陈伟峰 新增字段【跨境电商客户标志】
            20240902 陈伟峰 新增字段【自营客户标志、办公地区行政区划代码、基本开户行行号、角色类型代码、数字经济类型代码、管理人员人数、受益所有人属性代码组合、不良记录原因、黑名单客户标志、上黑名单日期、上黑名单原因、税务机关证明描述】
            20241021 谢  宁 新增字段【1+N供应链项目客户标志】
            20250221 陈伟峰 新增字段【创新型中小企业标志、科技型中小企业标志、国家企业技术中心标志、各类科技名单企业标志】
            20260312 陈  凭 新增字段【EX_SERVISMAN_CORP_FLG	退役军人创办企业标志】
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_cust_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_cust_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_corp_cust_attach_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_cust_attach_info_ex purge;
drop table ${icl_schema}.tmp_cmm_corp_cust_attach_info_01 purge;

-- 2.1 create temporary table cmm_corp_cust_attach_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_cust_attach_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_cust_attach_info where 0=1;
commit;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_cust_attach_info_01 as
select b.alrliabilityratio --投资级资产负债率
       ,a.serialno --流水号
       ,a.customerid --投资级客户号
       ,a.custdecison --投资级客户标志
       ,b.tfdreportperiod --投资级财务数据报告期
       ,b.tfdreporttype --投资级财务数据报表类型代码
       ,a.financialdate --投资级财务报表日期
       ,row_number() over(partition by a.customerid order by a.financialdate desc) rn 
from ${iol_schema}.icms_investment_client a
left join ${iol_schema}.icms_investment_client_according b
on a.serialno=b.relserialno
and b.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and b.end_dt > to_date('${batch_date}', 'yyyymmdd')
where a.start_dt <= to_date('${batch_date}', 'yyyymmdd')
and a.end_dt > to_date('${batch_date}', 'yyyymmdd')
and a.approvestatus='Finished';
commit;


-- 2.2 insert into data to temporary table cmm_corp_cust_attach_info_ex

--第一组（共一组）ecif对公客户信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_attach_info_ex(
        etl_dt                                -- 数据日期
       ,lp_id                                 -- 法人编号
       ,cust_id                               -- 客户编号
       ,cust_name                             -- 客户名称
       ,cust_type_cd                          -- 客户类型代码
       ,adv_man_indu_flg                      -- 先进制造业标志
       ,spe_soph_unq_new_med_side_enter_flg   -- 专精特新中小企业标志
       ,spe_soph_unq_new_lte_gnt_corp_flg     -- 专精特新小巨人企业标志
       ,high_new_tech_corp_flg                -- 高新技术企业标志
       ,agri_property_lead_enterp_flg         -- 农业产业化龙头企业标志
       ,farm_and_new_agri_mang_main_loan_flg  -- 农户及新型农业经营主体贷款标志
       ,cty_tech_inovt_corp_flg               -- 国家技术创新示范企业标志
       ,item_corp_flg                         -- 制造业单项冠军企业标志
       ,inovt_med_side_enter_flg          --创新型中小企业标志
       ,scen_tech_med_side_enter_flg     --科技型中小企业标志	
       ,cty_corp_tech_center_flg               --国家企业技术中心标志
       ,each_class_scen_tech_list_corp_flg         --各类科技名单企业标志
       ,ex_servisman_corp_flg                 -- 退役军人创办企业标志
       ,invest_cust_flg                       -- 投资级客户标志
       ,asset_liab_ratio                      -- 投资级资产负债率
       ,major_foul_behav_flg                  -- 投资级重大违法违规行为标志
       ,fin_data_update_flg                   -- 投资级财务数据及时更新标志
       ,fin_data_report_prd                   -- 投资级财务数据报告期
       ,fin_data_rept_type_cd                 -- 投资级财务数据报表类型代码
       ,fin_stat_dt                           -- 投资级财务报表日期
       ,only_public_market_bus_flg            -- 仅公开市场业务标志
       ,indust_park_corp_flg                  -- 产业园企业标志
       ,sel_sup_cust_flg_cd                   -- 自营客户标志代码
       ,cross_bor_cust_flg                    -- 跨境电商客户标志
       ,chain_proj_cust_flg                   -- 1+N供应链项目客户标志
	     ,open_acct_lics_id                     -- 开户许可证编号
	     ,open_acct_lics_apprv_dt               -- 开户许可证核准日期
	     ,digit_econ_type_cd                    -- 数字经济类型代码
       ,role_type_cd                          -- 角色类型代码
	     ,risk_dist_cd                          -- 风险预警行政区划代码
	     ,work_rg_dist_cd                       -- 办公地区行政区划代码
       ,basic_open_bank_no                    -- 基本开户行行号
	     ,lei_id                                -- lei编号
	     ,bnft_owner_type_cd                    -- 受益所有人类型代码
	     ,bnft_owner_idtfy_status_cd            -- 受益所有人识别状态代码
       ,bnft_owner_attr_cd_comb               -- 受益所有人属性代码组合
       ,mger_member_number                    -- 管理人员人数
       ,non_rec_rs                            -- 不良记录原因
       ,blklist_cust_flg                      -- 黑名单客户标志
       ,up_blklist_dt                         -- 上黑名单日期
       ,up_blklist_rs                         -- 上黑名单原因
       ,tax_auth_proof_descb                  -- 税务机关证明描述
	     ,latest_update_teller_id	              -- 最新更新柜员编号
	     ,latest_update_org_id	                -- 最新更新机构编号  
	     ,latest_update_chn_cd	                -- 最新更新渠道代码  
	     ,latest_update_tm	                    -- 最新更新时间        
			 ,job_cd                                -- 任务代码
			 ,etl_timestamp                         -- 数据处理时间
)
select to_date('${batch_date}','yyyymmdd')                                -- 数据日期
       ,t1.lp_id                                                          -- 法人编号
       ,t1.party_id                                                       -- 客户编号
       ,t1.corp_name                                                      -- 客户名称
       ,decode(t1.corp_party_type_cd,'2','PUBLIC_TYPE','3','SAME_TRADE_TYPE','PUBLIC_TYPE')    -- 客户类型代码
       ,t2.attr_val                                                    -- 先进制造业标志
       ,t3.attr_val                                                    -- 专精特新中小企业标志
       ,t4.attr_val                                                    -- 专精特新小巨人企业标志
       ,t5.attr_val                                                    -- 高新技术企业标志
	   ,t8.attr_val                                                    -- 农业产业化龙头企业标志
	   ,t9.attr_val                                                    -- 农户及新型农业经营主体贷款标志
       ,t21.attr_val                                                   -- 国家技术创新示范企业标志
       ,t22.attr_val                                                   -- 制造业单项冠军企业标志
       ,t28.attr_val                                                   --创新型中小企业标志
       ,t29.attr_val                                                   --科技型中小企业标志	
       ,t30.attr_val                                                   --国家企业技术中心标志
       ,t31.attr_val                                                   --各类科技名单企业标志
       ,t32.attr_val                                                   -- 退役军人创办企业标志
	     ,nvl(trim(t16.custdecison),'-')                                 -- 投资级客户标志
	     ,t16.alrliabilityratio                                          -- 投资级资产负债率
	     ,t17.markmodifyvalue                                            -- 投资级重大违法违规行为标志
	     ,t18.markmodifyvalue                                            -- 投资级财务数据及时更新标志
	     ,t16.tfdreportperiod                                            -- 投资级财务数据报告期
	     ,t16.tfdreporttype                                              -- 投资级财务数据报表类型代码
	     ,t16.financialdate                                              -- 投资级财务报表日期
	     ,t19.attr_val                                                   -- 仅公开市场业务标志
	     ,t20.attr_val                                                   -- 产业园企业标志
	     ,nvl(t24.attr_val,'-')                                          -- 自营客户标志代码
       ,t23.attr_val                                                   -- 跨境电商客户标志
       ,substrb(nvl(t27.tagvalue,'-'),1,10)                                      -- 1+N供应链项目客户标志
	     ,t6.cert_num                                                    -- 开户许可证编号
	     ,t7.imp_dt                                                      -- 开户许可证核准日期
	     ,t1.digit_econ_indus_cd                                         -- 数字经济类型代码
       ,t1.role_type_cd                                                -- 角色类型代码
	     ,t10.newregioncode                                              -- 风险预警行政区划代码
	     ,t25.work_rg_dist_cd                                            -- 办公地区行政区划代码
       ,t26.basic_open_bank_no                                         -- 基本开户行行号
	     ,t12.lei                                                        -- LEI编号
	     ,t14.benefc_cd                                                  -- 受益所有人类型代码
	     ,t14.fst_idtfy_benefc_flg                                       -- 受益所有人识别状态代码
	     ,t14.benefc_attr_cd_comb                                        -- 受益所有人属性代码组合
       ,t1.mger_member_number                                          -- 管理人员人数
       ,t1.non_rec_rs                                                  -- 不良记录原因
       ,t1.blklist_cust_flg                                            -- 黑名单客户标志
       ,t1.blklist_rgst_dt                                             -- 上黑名单日期
       ,t1.blklist_rs                                                  -- 上黑名单原因
       ,t13.tax_org_certificate                                        -- 税务机关证明描述
	     ,t15.last_updated_te 	                                         -- 最新更新柜员编号 
	     ,t15.last_updated_org	                                         -- 最新更新机构编号
	     ,t15.last_system_id  	                                         -- 最新更新渠道代码
	     ,t15.last_updated_ts 	                                         -- 最新更新时间  
	     ,t1.job_cd                                                      -- 任务代码                  --> job_cd
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')   -- etl处理时间戳             --> etl_timestamp
   from ${iml_schema}.pty_corp t1
   left join ${iml_schema}.pty_party_attr_h t2
     on t1.party_id = t2.party_id
    and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t2.job_cd = 'eifsf1'
    and t2.attr_name = 'C0040'   --公司客户-先进制造业标志
   left join ${iml_schema}.pty_party_attr_h t3
     on t1.party_id = t3.party_id
    and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t3.job_cd = 'eifsf1'
    and t3.attr_name ='C0041'   --公司客户-专精特新中小企业标志
   left join ${iml_schema}.pty_party_attr_h t4
     on t1.party_id = t4.party_id
    and t4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t4.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t4.job_cd = 'eifsf1'
    and t4.attr_name ='C0042'   --公司客户-专精特新小巨人企业标志
   left join ${iml_schema}.pty_party_attr_h t5
     on t1.party_id = t5.party_id
    and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t5.job_cd = 'eifsf1'
    and t5.attr_name ='C0021'   --公司客户-是否高新技术企业
   left join ${iml_schema}.pty_party_cert_info_h t6
     on t1.party_id = t6.party_id
    and t6.cert_type_cd='2080'
    and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t6.job_cd = 'eifsf1'
   left join ${iml_schema}.pty_party_imp_dt_h t7
     on t1.party_id = t7.party_id
    and t7.imp_dt_type_cd = '52'
    and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t7.job_cd = 'eifsf1'
   left join ${iml_schema}.pty_party_attr_h t8
     on t1.party_id = t8.party_id
    and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t8.job_cd = 'eifsf1'
    and t8.attr_name = 'C0043'  --公司客户-是否农业产业化龙头企业
   left join ${iml_schema}.pty_party_attr_h t9
     on t1.party_id = t9.party_id
    and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t9.job_cd = 'eifsf1'
    and t9.attr_name = 'C0044' --公司客户-是否农户及新型农业经营主体贷款
   left join ${iol_schema}.icms_ent_info t10
     on t1.party_id = t10.customerid
    and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join ${iol_schema}.eifs_t00_corp_cust_no_ref t11
     on t1.party_id =t11.cust_num
    and t11.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t11.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join ${iol_schema}.eifs_t01_corp_cust_ext_info t12
     on t11.party_id = t12.party_id
    and t12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t12.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t12.updated_ts =to_date('99991231', 'yyyymmdd')
   left join ${iol_schema}.eifs_t01_corp_cust_info t13
     on t11.party_id = t13.party_id
    and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t13.updated_ts =to_date('99991231', 'yyyymmdd')
   left join ${iml_schema}.pty_corp_ext_info t14
     on t1.party_id = t14.party_id
    and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t14.job_cd = 'eifsf1'
   left join ${iol_schema}.eifs_t00_party_pub_info t15
     on t1.party_id=t15.cust_num
    and t15.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t15.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${icl_schema}.tmp_cmm_corp_cust_attach_info_01 t16
     on t1.party_id=t16.customerid
    and t16.rn=1
   left join ${iol_schema}.icms_investment_client_mark t17 
     on t16.serialno=t17.objectno
    and t17.objecttype='VLR'
    and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t17.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iol_schema}.icms_investment_client_mark t18 
     on t16.serialno=t18.objectno
    and t18.objecttype='TFD'
    and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
    and t18.end_dt > to_date('${batch_date}','yyyymmdd')
   left join ${iml_schema}.pty_party_attr_h t19
     on t1.party_id = t19.party_id
    and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t19.job_cd = 'eifsf1'
    and t19.attr_name = 'C0048' --公司客户-仅办理公开市场标准化业务
   left join ${iml_schema}.pty_party_attr_h t20
     on t1.party_id = t20.party_id
    and t20.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t20.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t20.job_cd = 'eifsf1'
    and t20.attr_name = 'C0047' --公司客户-是否产业园企业 
   left join ${iml_schema}.pty_party_attr_h t21
     on t1.party_id = t21.party_id
    and t21.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t21.job_cd = 'eifsf1'
    and t21.attr_name = 'C0049' --公司客户-国家技术创新示范企业标志
   left join ${iml_schema}.pty_party_attr_h t22
     on t1.party_id = t22.party_id
    and t22.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t22.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t22.job_cd = 'eifsf1'
    and t22.attr_name = 'C0050' --公司客户-制造业单项冠军企业标志
   left join ${iml_schema}.pty_party_attr_h t23
     on t1.party_id = t23.party_id
    and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t23.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t23.job_cd = 'eifsf1'
    and t23.attr_name = 'C0051' --公司客户-跨境电商客户标志
   left join ${iml_schema}.pty_party_attr_h t24
     on t1.party_id = t24.party_id
    and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t24.job_cd = 'eifsf1'
    and t24.attr_name = 'CD2436' --自营客户标志代码
   left join ${iml_schema}.pty_corp_rgst_info_h t25
     on t1.party_id = t25.party_id
    and T25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and T25.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and T25.job_cd = 'eifsf1'
   left join ${iml_schema}.pty_corp_bank_acct_info_h t26
     on t1.party_id = t26.party_id
    and t26.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t26.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t26.job_cd = 'eifsf1'
   left join ${iol_schema}.icms_tag_term_final_data t27
     on t1.party_id = t27.objectno
    and t27.taghirearchy = '10'
    and t27.tagid= '2024102311000001'
    and t27.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t27.end_dt > to_date('${batch_date}', 'yyyymmdd')
   left join ${iml_schema}.pty_party_attr_h t28
     on t1.party_id = t28.party_id
    and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t28.job_cd = 'eifsf1'
    and t28.attr_name = 'C0052' --公司客户-创新型中小企业
   left join ${iml_schema}.pty_party_attr_h t29
     on t1.party_id = t29.party_id
    and t29.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t29.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t29.job_cd = 'eifsf1'
    and t29.attr_name = 'C0053' --公司客户-科技型中小企业
   left join ${iml_schema}.pty_party_attr_h t30
     on t1.party_id = t30.party_id
    and t30.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t30.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t30.job_cd = 'eifsf1'
    and t30.attr_name = 'C0054' --公司客户-国家企业技术中心
   left join ${iml_schema}.pty_party_attr_h t31
     on t1.party_id = t31.party_id
    and t31.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t31.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t31.job_cd = 'eifsf1'
    and t31.attr_name = 'C0055' --公司客户-各类科技名单企业
   left join ${iml_schema}.pty_party_attr_h t32
     on t1.party_id = t32.party_id
    and t32.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t32.end_dt > to_date('${batch_date}', 'yyyymmdd')
    and t32.job_cd = 'eifsf1'
    and t32.attr_name = 'C0056' --公司客户-是否退役军人创办企业
   where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
     and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
     and t1.job_cd = 'eifsf1'
     and t1.corp_party_type_cd in ('2','4','3')

;
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_cust_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_cust_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_cust_attach_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_cust_attach_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);