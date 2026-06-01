/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_ibank_secu_post
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_cmm_ibank_secu_post drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_ibank_secu_post drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_ibank_secu_post add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_ibank_secu_post (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,ext_secu_acct_id  -- 外部证券账户编号
    ,intnal_secu_acct_id  -- 内部证券账户编号
    ,fin_instm_id  -- 金融工具编号
    ,asset_type_id  -- 资产类型编号
    ,std_prod_id  -- 标准产品编号
    ,market_type_id  -- 市场类型编号
    ,bus_id  -- 业务编号
    ,comb_tran_num  -- 组合交易号
    ,obj_id  -- 对象编号
    ,apv_form_num  -- 审批单号
    ,prod_type_cd  -- 产品类型代码
    ,asset_type_name  -- 资产类型名称
    ,level5_cls_cd  -- 五级分类代码
    ,subj_id  -- 科目编号
    ,int_subj_id  -- 利息科目编号
    ,int_adj_subj_id  -- 利息调整科目编号
    ,acru_int_inco_subj_id  -- 应计利息收入科目编号
    ,amort_int_income_subj_id  -- 摊销利息收入科目编号
    ,evha_val_chag_pl_subj_id  -- 公允价值变动损益科目编号
    ,spd_pl_subj_id  -- 价差损益科目编号
    ,acct_name  -- 账户名称
    ,tran_market_id  -- 交易市场编号
    ,exchg_acct_id  -- 交易所账户编号
    ,issuer_id  -- 发行人编号
    ,issuer_name  -- 发行人名称
    ,stl_site_id  -- 结算场所编号
    ,stl_site_name  -- 结算场所名称
    ,tran_num  -- 交易号
    ,extra_dimen_cd  -- 额外维度代码
    ,curr_cd  -- 币种代码
    ,actl_qtty  -- 实际数量
    ,actl_bal  -- 实际余额
    ,currt_bal  -- 当期余额
    ,net_price_cost  -- 净价成本
    ,acru_int  -- 应计利息
    ,int_recvbl  -- 应收利息
    ,int_cost  -- 利息成本
    ,evha_val_chag  -- 公允价值变动
    ,recvbl_uncol_bal  -- 应收未收余额
    ,recvbl_uncol_net_price_cost  -- 应收未收净价成本
    ,recvbl_uncol_acru_int  -- 应收未收应计利息
    ,int_adj_amt  -- 利息调整金额
    ,actl_int_rat  -- 实际利率
    ,invest_yld_rat  -- 投资收益率
    ,open_yld_rat  -- 开仓收益率
    ,td_nv  -- 当日净值
    ,amort_dt  -- 摊销日期
    ,fir_stl_dt  -- 首次结算日期
    ,stl_dt  -- 结算日期
    ,open_dt  -- 开仓日期
    ,last_update_dt  -- 上次更新日期
    ,cap_type_cd  -- 资金类型代码
    ,asset_four_cls_cd  -- 资产四分类代码
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,belong_org_id  -- 所属机构编号
    ,tran_amt  -- 交易金额
    ,evha_val_chag_pl  -- 公允价值变动损益
    ,spd_pl  -- 价差损益
    ,acru_int_inco  -- 应计利息收入
    ,amort_int_inco  -- 摊销利息收入
    ,ftp_prop_cate  -- FTP方案类别
    ,ftp_spread  -- FTP点差
    ,ncds_issue_org_id  -- 同业存单发行机构编号
    ,ncds_issue_org_name  -- 同业存单发行机构名称
    ,ovdue_status  -- 逾期状态
    ,ovdue_flg  -- 逾期标志
    ,pric_ovdue_dt  -- 本金逾期日期
    ,pric_ovdue_days  -- 本金逾期天数
    ,int_ovdue_dt  -- 利息逾期日期
    ,int_ovdue_days  -- 利息逾期天数
    ,intnal_secu_acct_status_cd                      --内部证券账户状态代码   
    ,cntpty_acct_id                                  --交易对手账户编号     
    ,evha_val_chag_subj_id                           --公允价值变动科目编号   
    ,acru_int_inco_vat_subj_id                       --应计利息收入增值税科目编号
    ,amort_int_income_vat_subj_id                    --摊销利息收入增值税科目编号
    ,spd_pl_vat_subj_id                              --价差损益增值税科目编号  
    ,currt_acru_int                                  --当期应计利息       
    ,ref_int_rat                                     --参考利率         
    ,fac_val_int_rat                                 --票面利率         
    ,tran_dt                                         --交易日期         
    ,value_dt                                        --起息日期         
    ,exp_dt                                          --到期日期         
    ,int_income                                      --利息收入         
    ,acru_int_inco_should_tax_flg                    --应计利息收入应税标志   
    ,amort_int_income_should_tax_flg                 --摊销利息收入应税标志   
    ,spd_pl_should_tax_flg                           --价差损益应税标志     
    ,acru_int_inco_tax_rat                           --应计利息收入税率     
    ,amort_int_income_tax_rat                        --摊销利息收入税率     
    ,spd_pl_tax_rat                                  --价差损益税率       
    ,acru_int_inco_tax_lmt                           --应计利息收入税额     
    ,amort_int_income_tax_lmt                        --摊销利息收入税额     
    ,spd_pl_tax_lmt                                  --价差损益税额       
    ,is_th_ssn_redem                                 --是否当季赎回       
    ,curr_issue_build_up_pos_dt                      --本期建仓日期       
    ,expe_redem_dt                                   --预期赎回日期       
    ,tran_hold_idf                                   --交易持有标识       
    ,apot_tenor_dep_flg                              --约期存款标志       
    ,apot_tenor_start_dt                             --约期开始日期       
    ,apot_tenor_end_dt                               --约期结束日期       
    ,apot_tenor_amt                                  --约期金额         
    ,tran_cost_accti_method_cd                       --交易成本核算方法代码   
    ,cross_bor_depo_takof_inter_flg                  --跨境同存标志       
    ,cross_bor_depo_takof_inter_sign_value_dt        --跨境同存签约起息日期   
    ,cross_bor_depo_takof_inter_sign_exp_dt          --跨境同存签约到期日期   
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'')  -- 外部证券账户编号
    ,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'')  -- 内部证券账户编号
    ,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'')  -- 金融工具编号
    ,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'')  -- 资产类型编号
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'')  -- 标准产品编号
    ,replace(replace(t1.market_type_id,chr(13),''),chr(10),'')  -- 市场类型编号
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.comb_tran_num,chr(13),''),chr(10),'')  -- 组合交易号
    ,replace(replace(t1.obj_id,chr(13),''),chr(10),'')  -- 对象编号
    ,replace(replace(t1.apv_form_num,chr(13),''),chr(10),'')  -- 审批单号
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'')  -- 资产类型名称
    ,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'')  -- 五级分类代码
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'')  -- 利息科目编号
    ,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'')  -- 利息调整科目编号
    ,replace(replace(t1.acru_int_inco_subj_id,chr(13),''),chr(10),'')  -- 应计利息收入科目编号
    ,replace(replace(t1.amort_int_income_subj_id,chr(13),''),chr(10),'')  -- 摊销利息收入科目编号
    ,replace(replace(t1.evha_val_chag_pl_subj_id,chr(13),''),chr(10),'')  -- 公允价值变动损益科目编号
    ,replace(replace(t1.spd_pl_subj_id,chr(13),''),chr(10),'')  -- 价差损益科目编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'')  -- 交易市场编号
    ,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'')  -- 交易所账户编号
    ,replace(replace(t1.issuer_id,chr(13),''),chr(10),'')  -- 发行人编号
    ,replace(replace(t1.issuer_name,chr(13),''),chr(10),'')  -- 发行人名称
    ,replace(replace(t1.stl_site_id,chr(13),''),chr(10),'')  -- 结算场所编号
    ,replace(replace(t1.stl_site_name,chr(13),''),chr(10),'')  -- 结算场所名称
    ,replace(replace(t1.tran_num,chr(13),''),chr(10),'')  -- 交易号
    ,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'')  -- 额外维度代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.actl_qtty  -- 实际数量
    ,t1.actl_bal  -- 实际余额
    ,t1.currt_bal  -- 当期余额
    ,t1.net_price_cost  -- 净价成本
    ,t1.acru_int  -- 应计利息
    ,t1.int_recvbl  -- 应收利息
    ,t1.int_cost  -- 利息成本
    ,t1.evha_val_chag  -- 公允价值变动
    ,t1.recvbl_uncol_bal  -- 应收未收余额
    ,t1.recvbl_uncol_net_price_cost  -- 应收未收净价成本
    ,t1.recvbl_uncol_acru_int  -- 应收未收应计利息
    ,t1.int_adj_amt  -- 利息调整金额
    ,t1.actl_int_rat  -- 实际利率
    ,t1.invest_yld_rat  -- 投资收益率
    ,t1.open_yld_rat  -- 开仓收益率
    ,t1.td_nv  -- 当日净值
    ,t1.amort_dt  -- 摊销日期
    ,t1.fir_stl_dt  -- 首次结算日期
    ,t1.stl_dt  -- 结算日期
    ,t1.open_dt  -- 开仓日期
    ,t1.last_update_dt  -- 上次更新日期
    ,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'')  -- 资金类型代码
    ,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'')  -- 资产四分类代码
    ,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'')  -- 资产三分类代码
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,t1.tran_amt  -- 交易金额
    ,t1.evha_val_chag_pl  -- 公允价值变动损益
    ,t1.spd_pl  -- 价差损益
    ,t1.acru_int_inco  -- 应计利息收入
    ,t1.amort_int_inco  -- 摊销利息收入
    ,replace(replace(t1.ftp_prop_cate,chr(13),''),chr(10),'')  -- FTP方案类别
    ,t1.ftp_spread  -- FTP点差
    ,replace(replace(t1.ncds_issue_org_id,chr(13),''),chr(10),'')  -- 同业存单发行机构编号
    ,replace(replace(t1.ncds_issue_org_name,chr(13),''),chr(10),'')  -- 同业存单发行机构名称
    ,replace(replace(t1.ovdue_status,chr(13),''),chr(10),'')  -- 逾期状态
    ,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'')  -- 逾期标志
    ,t1.pric_ovdue_dt  -- 本金逾期日期
    ,t1.pric_ovdue_days  -- 本金逾期天数
    ,t1.int_ovdue_dt  -- 利息逾期日期
    ,t1.int_ovdue_days  -- 利息逾期天数
    ,replace(replace(t1.intnal_secu_acct_status_cd,chr(13),''),chr(10),'') as intnal_secu_acct_status_cd                 --内部证券账户状态代码   
    ,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id                                         --交易对手账户编号     
    ,replace(replace(t1.evha_val_chag_subj_id,chr(13),''),chr(10),'') as evha_val_chag_subj_id                           --公允价值变动科目编号   
    ,replace(replace(t1.acru_int_inco_vat_subj_id,chr(13),''),chr(10),'') as acru_int_inco_vat_subj_id                   --应计利息收入增值税科目编号
    ,replace(replace(t1.amort_int_income_vat_subj_id,chr(13),''),chr(10),'') as amort_int_income_vat_subj_id             --摊销利息收入增值税科目编号
    ,replace(replace(t1.spd_pl_vat_subj_id,chr(13),''),chr(10),'') as spd_pl_vat_subj_id                                 --价差损益增值税科目编号  
    ,t1.currt_acru_int as currt_acru_int                                                                                 --当期应计利息       
    ,t1.ref_int_rat as ref_int_rat                                                                                       --参考利率         
    ,t1.fac_val_int_rat as fac_val_int_rat                                                                               --票面利率         
    ,t1.tran_dt as tran_dt                                                                                               --交易日期         
    ,t1.value_dt as value_dt                                                                                             --起息日期         
    ,t1.exp_dt as exp_dt                                                                                                 --到期日期         
    ,t1.int_income as int_income                                                                                         --利息收入         
    ,t1.acru_int_inco_should_tax_flg as acru_int_inco_should_tax_flg                                                     --应计利息收入应税标志   
    ,t1.amort_int_income_should_tax_flg as amort_int_income_should_tax_flg                                               --摊销利息收入应税标志   
    ,t1.spd_pl_should_tax_flg as spd_pl_should_tax_flg                                                                   --价差损益应税标志     
    ,t1.acru_int_inco_tax_rat as acru_int_inco_tax_rat                                                                   --应计利息收入税率     
    ,t1.amort_int_income_tax_rat as amort_int_income_tax_rat                                                             --摊销利息收入税率     
    ,t1.spd_pl_tax_rat as spd_pl_tax_rat                                                                                 --价差损益税率       
    ,t1.acru_int_inco_tax_lmt as acru_int_inco_tax_lmt                                                                   --应计利息收入税额     
    ,t1.amort_int_income_tax_lmt as amort_int_income_tax_lmt                                                             --摊销利息收入税额     
    ,t1.spd_pl_tax_lmt as spd_pl_tax_lmt                                                                                 --价差损益税额       
    ,replace(replace(t1.is_th_ssn_redem,chr(13),''),chr(10),'') as is_th_ssn_redem                                       --是否当季赎回       
    ,t1.curr_issue_build_up_pos_dt as curr_issue_build_up_pos_dt                                                         --本期建仓日期       
    ,t1.expe_redem_dt as expe_redem_dt                                                                                   --预期赎回日期       
    ,replace(replace(t1.tran_hold_idf,chr(13),''),chr(10),'') as tran_hold_idf                                           --交易持有标识       
    ,replace(replace(t1.apot_tenor_dep_flg,chr(13),''),chr(10),'') as apot_tenor_dep_flg                                 --约期存款标志       
    ,t1.apot_tenor_start_dt as apot_tenor_start_dt                                                                       --约期开始日期       
    ,t1.apot_tenor_end_dt as apot_tenor_end_dt                                                                           --约期结束日期       
    ,t1.apot_tenor_amt as apot_tenor_amt                                                                                 --约期金额         
    ,replace(replace(t1.tran_cost_accti_method_cd,chr(13),''),chr(10),'') as tran_cost_accti_method_cd                   --交易成本核算方法代码   
    ,replace(replace(t1.cross_bor_depo_takof_inter_flg,chr(13),''),chr(10),'') as cross_bor_depo_takof_inter_flg         --跨境同存标志       
    ,t1.cross_bor_depo_takof_inter_sign_value_dt as cross_bor_depo_takof_inter_sign_value_dt                             --跨境同存签约起息日期   
    ,t1.cross_bor_depo_takof_inter_sign_exp_dt as cross_bor_depo_takof_inter_sign_exp_dt                                 --跨境同存签约到期日期   
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_ibank_secu_post t1    --同业证券持仓
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_ibank_secu_post',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);