/*
purpose:    共性加工层-对公贷款合同补充信息：包括所有对公贷款业务的贷款合同信息及授信合同信息对应的补充信息
author:     sunline
usage:      python $ETL_HOME/script/main.py yyyymmdd icl_cmm_corp_loan_cont_attach_info
createdate: 20200513
logs:       20220405 陈伟峰 新增模型
            20221201 陈伟峰 调整字段【科技型企业标志】、【科创企业标志】加工逻辑


*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_loan_cont_attach_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_loan_cont_attach_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 drop temporary table cmm_corp_loan_cont_attach_info_ex
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_loan_cont_attach_info_ex purge;

-- 2.1 create temporary table cmm_corp_loan_cont_attach_info_ex
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_cont_attach_info_ex
nologging
compress ${option_switch} for query high
as
select * from ${icl_schema}.cmm_corp_loan_cont_attach_info where 0=1;

-- 2.2 insert into data to temporary table cmm_corp_loan_cont_attach_info_ex

--第一组（共一组）对公贷款合同信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_loan_cont_attach_info_ex(
				etl_dt                                      --数据日期
				,lp_id                                      --法人编号
	      ,cont_id                                    --合同编号
        ,cont_name                                  --合同名称
        ,cont_type_cd                               --合同类型代码
        ,margin_int_rat                             --保证金利率
        ,gover_crdt_supt_way_cd                     --政府授信支持方式代码
        ,gover_crdt_type_cd                         --政府授信类型代码
        ,cdb_crdt_breed_cd                          --国开授信品种代码
        ,loan_char_cd                               --贷款性质代码
        ,invest_char_cd                             --投资性质代码
        ,margin_int_rat_type_cd                     --保证金利率类型代码
        ,margin_int_accr_method_cd                  --保证金计息方法代码
        ,m_l_claus_exist_flg                        --溢短装条款存在标志
        ,obank_open_flg                             --他行代开标志
        ,three_old_tf_or_city_update_proj_flg       --三旧改造或城市更新项目标志
        ,overs_loan_flg                             --境外贷款标志
        ,cont_begin_dt                              --合同起始日期
        ,cont_exp_dt                                --合同到期日期
        ,start_work_dt                              --开工日期
        ,batch_no                                   --批文文号
        ,plan_lics_id                               --规划许可证编号
        ,arch_land_lics_id                          --建设用地许可证编号
        ,envir_im_ass_lics_id                       --环评许可证编号
        ,cnstr_lics_id                              --施工许可证编号
        ,other_lics_id                              --其他许可证编号
        ,ncds_num                                   --同业存单号码
        ,margin_tran_out_acct_num                   --保证金转出账号
        ,bus_info_desc                              --业务信息描述
        ,back_info_descb                            --背景信息描述
        ,cargo_name                                 --货物名称
        ,cls_freq                                   --分类频率
        ,m_l_ratio                                  --溢短装比例
        ,proj_name                                  --项目名称
        ,proj_tot_invest                            --项目总投资
        ,capital                                    --资本金
        ,setup_proj_batch_file                      --立项批文
        ,other_lics                                 --其他许可证
        ,ncds_abbr                                  --同业存单简称
        ,margin_int_rat_level                       --保证金利率档次
        ,land_use_cert_id                           --土地使用证编号
        ,land_use_cert_dt                           --土地使用证日期
        ,land_plan_lics_id                          --用地规划许可证编号
        ,land_plan_lics_dt                          --用地规划许可证日期
        ,cnstr_lics_dt                              --施工许可证日期
        ,proj_plan_lics_dt                          --工程规划许可证日期
        ,buyer_name                                 --购货方名称
        ,seller_name                                --销货方名称
        ,trade_tran_content                         --贸易交易内容
        ,stat_use_open_bal                          --统计用敞口余额
				,commer_inv_info_desc                       --商业发票信息描述
        ,commer_inv_curr_cd                         --商业发票币种代码
        ,commer_inv_amt                             --商业发票金额
        ,commer_inv_kind_cd                         --商业发票种类代码
        ,era_pay_bank_cust_id                       --代付行客户编号
        ,adv_man_indu_flg                           --先进制造业标志
        ,spe_soph_unq_new_med_side_enter_flg        --专精特新中小企业标志
        ,spe_soph_unq_new_lte_gnt_corp_flg          --专精特新小巨人企业标志
        ,cul_property_flg                           --文化产业标志
        ,indu_corp_tech_rem_ugd_flg                 --工业企业技术改造升级标志
        ,strate_new_indus_flg                       --战略性新兴产业标志
        ,strate_new_indus_type_cd                   --战略性新兴产业类型代码
        ,high_new_tech_corp_flg                     --高新技术企业标志
        ,sci_tech_corp_flg                          --科技型企业标志
        ,sci_tech_inovt_corp_flg                    --科创企业标志
        ,proj_fin_flg                               --项目融资标志
				,job_cd                                     --任务代码
				,etl_timestamp                              --数据处理时间

)
select to_date('${batch_date}','yyyymmdd')                               --数据日期
       ,'9999'                                                           --法人编号
       ,t1.serialno                                                      --合同编号
       ,t1.contractname                                                  --合同名称
       ,t1.contracttype                                                  --合同类型代码
       ,t1.interestrate                                                  --保证金利率
       ,t1.zfsxfs                                                        --政府授信支持方式代码
       ,t1.zfsxlx                                                        --政府授信类型代码
       ,t1.gksxpz                                                        --国开授信品种代码
       ,t1.loanquality                                                   --贷款性质代码
       ,t1.investkind                                                    --投资性质代码
       ,t1.fxfltp                                                        --保证金利率类型代码
       ,t1.interestmethod                                                --保证金计息方法代码
       ,decode(t1.hasoutradio,'1','1','0')                               --溢短装条款存在标志
       ,decode(t1.registerinotherbank,'1','1','0')                       --他行代开标志
       ,decode(t1.issjorcs,'1','1','0')                                  --三旧改造或城市更新项目标志
       ,decode(t1.isforeign,'1','1','0')                                 --境外贷款标志
       ,${iml_schema}.dateformat_min(t1.begindate)                       --合同起始日期
       ,${iml_schema}.dateformat_max(t1.enddate)                         --合同到期日期
       ,${iml_schema}.dateformat_min(t1.kgrq)                            --开工日期
       ,t1.pwwh                                                          --批文文号
       ,t1.ghxkzbh                                                       --规划许可证编号
       ,t1.jsydxkzbh                                                     --建设用地许可证编号
       ,t1.hpxkzbh                                                       --环评许可证编号
       ,t1.sgxkzbh                                                       --施工许可证编号
       ,t1.qtxkzbh                                                       --其他许可证编号
       ,t1.depositno                                                     --同业存单号码
       ,t1.bailtransaccount                                              --保证金转出账号
       ,t1.contextinfo                                                   --业务信息描述
       ,t1.securitiestype                                                --背景信息描述
       ,t1.cargoinfo                                                     --货物名称
       ,0                                                                --分类频率
       ,t1.outradio                                                      --溢短装比例
       ,t1.projecttitle                                                  --项目名称
       ,t1.xmztz                                                         --项目总投资
       ,t1.zbj                                                           --资本金
       ,t1.lxpw                                                          --立项批文
       ,t1.qtxkz                                                         --其他许可证
       ,t1.depositname                                                   --同业存单简称
       ,t1.termcd                                                        --保证金利率档次
       ,t1.landuseno                                                     --土地使用证编号
       ,${iml_schema}.dateformat_min(t1.landusedate)                     --土地使用证日期
       ,t1.landplanpermitno                                              --用地规划许可证编号
       ,${iml_schema}.dateformat_min(t1.landplanpermitdate)              --用地规划许可证日期
       ,${iml_schema}.dateformat_min(t1.constructpermitdate)             --施工许可证日期
       ,${iml_schema}.dateformat_min(t1.projectplanpermitdate)           --工程规划许可证日期
       ,t1.buyername                                                     --购货方名称
       ,t1.sellername                                                    --销货方名称
       ,t1.tradetransactioncontent                                       --贸易交易内容
       ,t1.statisticstotalbalance                                        --统计用敞口余额
       ,t1.businessinvoiceinfo                                           --商业发票信息描述
       ,t1.businessinvoicecurrency                                       --商业发票币种代码
       ,t1.businessinvoicesum                                            --商业发票金额
       ,t1.businessinvoicetype                                           --商业发票种类代码
       ,T1.UNPAIDBANKID                                                  --代付行客户编号
       ,decode(trim(t1.advancedindustry),'1','1','0')                    --先进制造业标志
       ,decode(trim(t1.specializemediumcorp),'1','1','0')                --专精特新中小企业标志
       ,decode(trim(t1.specializelargecorp),'1','1','0')                 --专精特新小巨人企业标志
       ,decode(trim(t1.culturalindustry),'1','1','0')                    --文化产业标志
       ,decode(trim(t1.technologyupgrade),'1','1','0')                   --工业企业技术改造升级标志
       ,decode(trim(t1.strategicemergingindustry),'1','1','0')           --战略性新兴产业标志
       ,t1.strategicemergingindustrytype                                 --战略性新兴产业类型代码
       ,decode(trim(t1.hightechcorp),'1','1','0')                        --高新技术企业标志
       ,decode(trim(t1.techcorp),'2','1','0')                            --科技型企业标志
       ,decode(trim(t1.techcorp),'3','1','0')                            --科创企业标志
       ,decode(trim(t1.isprojectfinance),'1','1','0')                    --项目融资标志
       ,'crssf1'                                                         --任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  --数据处理时间
  from ${iol_schema}.crss_business_contract t1
 where (trim(t1.isinuse) is null or t1.isinuse <> '2')
	and t1.businesstype not like '11%'
	and t1.businesstype not like '12%'
	and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd');
commit;

-- 2.3 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_loan_cont_attach_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_loan_cont_attach_info_ex;

-- 3.1 drop ex table
drop table ${icl_schema}.cmm_corp_loan_cont_attach_info_ex purge;

-- 3.3 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_corp_loan_cont_attach_info', partname => 'p_${batch_date}', granularity => 'partition', degree => 8, cascade => true);