/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_evt_ibank_tran
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
alter table ${idl_schema}.icrm_evt_ibank_tran drop partition p_${last_date};
alter table ${idl_schema}.icrm_evt_ibank_tran drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_evt_ibank_tran add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_evt_ibank_tran partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_num  -- 交易号
    ,entr_dt  -- 委托日期
    ,entr_tm  -- 委托时间
    ,cfm_dt  -- 确认日期
    ,cfm_tm  -- 确认时间
    ,intnal_tran_num  -- 内部交易号
    ,ext_tran_num  -- 外部交易号
    ,operr_name  -- 操作员名称
    ,tran_type_id  -- 交易类型编号
    ,ext_cap_acct_id  -- 外部资金账户编号
    ,intnal_cap_acct_id  -- 内部资金账户编号
    ,ext_secu_acct_id  -- 外部证券账户编号
    ,intnal_secu_acct_id  -- 内部证券账户编号
    ,cntpty_id  -- 交易对手编号
    ,pric_intnal_cap_acct_id  -- 本金内部资金账户编号
    ,fin_instm_id  -- 金融工具编号
    ,asset_type_id  -- 资产类型编号
    ,tran_market_id  -- 交易市场编号
    ,fin_instm_name  -- 金融工具名称
    ,tran_qtty  -- 交易数量
    ,tran_price  -- 交易价格
    ,tran_amt  -- 交易金额
    ,tran_fee  -- 交易费用
    ,stl_dt  -- 结算日期
    ,tran_status_cd  -- 交易状态代码
    ,stl_way_cd  -- 结算方式代码
    ,net_price_amt  -- 净价金额
    ,int_recvbl  -- 应收利息
    ,quote_tran_num  -- 引用交易号
    ,ignore_flg  -- 忽略标志
    ,tran_exec_market_id  -- 交易执行市场编号
    ,agent_name  -- 经办人名称
    ,cntpty_name  -- 交易对手名称
    ,evltion_net_price_brkb  -- 估值净价偏移度
    ,tran_src_cd  -- 交易来源代码
    ,deal_qtty  -- 已成交数量
    ,actl_recv_int  -- 实收利息
    ,actl_recv_amt  -- 实收金额
    ,dealer_name  -- 交易员名称
    ,cntpty_zzd_acct_id  -- 交易对手中债登账户编号
    ,cntpty_open_bank_num  -- 交易对手开户行号
    ,cntpty_acct_num  -- 交易对手账号
    ,cntpty_open_bank_name  -- 交易对手开户行名称
    ,cntpty_acct_name  -- 交易对手账户名称
    ,cbond_yld_rat  -- 中债收益率
    ,exp_yld_rat  -- 到期收益率
    ,recvbl_uncol_int  -- 应收未收利息
    ,operr_id  -- 操作员编号
    ,checker_id  -- 复核员编号
    ,recvbl_uncol_pric  -- 应收未收本金
    ,actl_int  -- 实付利息
    ,actl_pric  -- 实付本金
    ,ref_type_cd  -- 参考类型代码
    ,recvbl_uncol_int_resv_flg  -- 应收未收利息保留标志
    ,recvbl_uncol_pric_resv_flg  -- 应收未收本金保留标志
    ,dealer_id  -- 交易员编号
    ,tran_mode_cd  -- 交易模式代码
    ,clear_mode_cd  -- 清算模式代码
    ,apv_odd_no  -- 审批单号
    ,stl_status_cd  -- 结算状态代码
    ,accti_tran_num  -- 核算交易号
    ,ftp_int_rat  -- FTP利率
    ,assoced_apv_odd_no  -- 关联的审批单号
    ,bi_valid_cont_id  -- 双边有效合同编号
    ,data_src_cd  -- 数据来源代码
    ,nv_dt  -- 净值日期
    ,cntpty_swift_cd  -- 交易对手SWIFT代码
    ,splt_type_cd  -- 拆分类型代码
    ,parent_tran_num  -- 父交易号
    ,main_tran_num  -- 主交易号
    ,merge_tran_num  -- 合交易号
    ,miro_tran_num  -- 镜像交易号
    ,rela_tran_num  -- 关联交易号
    ,ex_yld_rat  -- 行权收益率
    ,cust_mgr_name  -- 客户经理名称
    ,cust_mgr_id  -- 客户经理编号
    ,camp_org_id  -- 营销机构编号
    ,redem_cfm_dt  -- 赎回确认日期
    ,tran_way_cd  -- 转账方式代码
    ,dlvy_dt  -- 交割日期
    ,cont_id  -- 合同编号
    ,cap_dir_descb  -- 资金投向描述
    ,final_dir_type_cd  -- 最终投向类型代码
    ,rela_ser_num  -- 关联序列号
    ,level5_cls_cd  -- 五级分类代码
    ,prod_char_cd  -- 产品性质代码
    ,curr_lot  -- 当前份额
    ,unpay_turn_lot  -- 未结转份额
    ,input_dt  -- 录入日期
    ,dlvy_site_id  -- 交割场所编号
    ,not_stl_comm_fee  -- 不结算手续费
    ,int_accr_base_cd  -- 计息基准代码
    ,contn_int_flg  -- 含息标志
    ,rela_party_info  -- 关联方信息
    ,redem_type_cd  -- 赎回类型代码
    ,std_prod_id                  --标准产品编号    
    ,ftp_id                       --ftp编号     
    ,is_term                      --是否约期      
    ,term_start_day               --约期开始日     
    ,term_end_day                 --约期结束日     
    ,bank_cap_acct_open_bank_num  --银行资金账户开户行号
    ,bank_cap_acct_id             --银行资金账户编号  
    ,th_ssn_redem_flg             --当季赎回标志    
    ,plan_redem_dt                --计划赎回日期    
    ,acct_b_cate_cd               --账簿类别代码    
    ,underly_fin_instm_id         --标的金融工具编号  
    ,underly_asset_type_id        --标的资产类型编号  
    ,underly_tran_market_id       --标的交易市场编号  
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.tran_num,chr(13),''),chr(10),'')  -- 交易号
    ,t1.entr_dt  -- 委托日期
    ,replace(replace(t1.entr_tm,chr(13),''),chr(10),'')  -- 委托时间
    ,t1.cfm_dt  -- 确认日期
    ,replace(replace(t1.cfm_tm,chr(13),''),chr(10),'')  -- 确认时间
    ,replace(replace(t1.intnal_tran_num,chr(13),''),chr(10),'')  -- 内部交易号
    ,replace(replace(t1.ext_tran_num,chr(13),''),chr(10),'')  -- 外部交易号
    ,replace(replace(t1.operr_name,chr(13),''),chr(10),'')  -- 操作员名称
    ,replace(replace(t1.tran_type_id,chr(13),''),chr(10),'')  -- 交易类型编号
    ,replace(replace(t1.ext_cap_acct_id,chr(13),''),chr(10),'')  -- 外部资金账户编号
    ,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'')  -- 内部资金账户编号
    ,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'')  -- 外部证券账户编号
    ,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'')  -- 内部证券账户编号
    ,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'')  -- 交易对手编号
    ,replace(replace(t1.pric_intnal_cap_acct_id,chr(13),''),chr(10),'')  -- 本金内部资金账户编号
    ,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'')  -- 金融工具编号
    ,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'')  -- 资产类型编号
    ,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'')  -- 交易市场编号
    ,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'')  -- 金融工具名称
    ,t1.tran_qtty  -- 交易数量
    ,t1.tran_price  -- 交易价格
    ,t1.tran_amt  -- 交易金额
    ,t1.tran_fee  -- 交易费用
    ,t1.stl_dt  -- 结算日期
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'')  -- 结算方式代码
    ,t1.net_price_amt  -- 净价金额
    ,t1.int_recvbl  -- 应收利息
    ,replace(replace(t1.quote_tran_num,chr(13),''),chr(10),'')  -- 引用交易号
    ,replace(replace(t1.ignore_flg,chr(13),''),chr(10),'')  -- 忽略标志
    ,replace(replace(t1.tran_exec_market_id,chr(13),''),chr(10),'')  -- 交易执行市场编号
    ,replace(replace(t1.agent_name,chr(13),''),chr(10),'')  -- 经办人名称
    ,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'')  -- 交易对手名称
    ,t1.evltion_net_price_brkb  -- 估值净价偏移度
    ,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'')  -- 交易来源代码
    ,t1.deal_qtty  -- 已成交数量
    ,t1.actl_recv_int  -- 实收利息
    ,t1.actl_recv_amt  -- 实收金额
    ,replace(replace(t1.dealer_name,chr(13),''),chr(10),'')  -- 交易员名称
    ,replace(replace(t1.cntpty_zzd_acct_id,chr(13),''),chr(10),'')  -- 交易对手中债登账户编号
    ,replace(replace(t1.cntpty_open_bank_num,chr(13),''),chr(10),'')  -- 交易对手开户行号
    ,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'')  -- 交易对手账号
    ,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'')  -- 交易对手开户行名称
    ,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'')  -- 交易对手账户名称
    ,t1.cbond_yld_rat  -- 中债收益率
    ,t1.exp_yld_rat  -- 到期收益率
    ,t1.recvbl_uncol_int  -- 应收未收利息
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作员编号
    ,replace(replace(t1.checker_id,chr(13),''),chr(10),'')  -- 复核员编号
    ,t1.recvbl_uncol_pric  -- 应收未收本金
    ,t1.actl_int  -- 实付利息
    ,t1.actl_pric  -- 实付本金
    ,replace(replace(t1.ref_type_cd,chr(13),''),chr(10),'')  -- 参考类型代码
    ,replace(replace(t1.recvbl_uncol_int_resv_flg,chr(13),''),chr(10),'')  -- 应收未收利息保留标志
    ,replace(replace(t1.recvbl_uncol_pric_resv_flg,chr(13),''),chr(10),'')  -- 应收未收本金保留标志
    ,replace(replace(t1.dealer_id,chr(13),''),chr(10),'')  -- 交易员编号
    ,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'')  -- 交易模式代码
    ,replace(replace(t1.clear_mode_cd,chr(13),''),chr(10),'')  -- 清算模式代码
    ,replace(replace(t1.apv_odd_no,chr(13),''),chr(10),'')  -- 审批单号
    ,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'')  -- 结算状态代码
    ,replace(replace(t1.accti_tran_num,chr(13),''),chr(10),'')  -- 核算交易号
    ,t1.ftp_int_rat  -- FTP利率
    ,replace(replace(t1.assoced_apv_odd_no,chr(13),''),chr(10),'')  -- 关联的审批单号
    ,replace(replace(t1.bi_valid_cont_id,chr(13),''),chr(10),'')  -- 双边有效合同编号
    ,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'')  -- 数据来源代码
    ,t1.nv_dt  -- 净值日期
    ,replace(replace(t1.cntpty_swift_cd,chr(13),''),chr(10),'')  -- 交易对手SWIFT代码
    ,replace(replace(t1.splt_type_cd,chr(13),''),chr(10),'')  -- 拆分类型代码
    ,replace(replace(t1.parent_tran_num,chr(13),''),chr(10),'')  -- 父交易号
    ,replace(replace(t1.main_tran_num,chr(13),''),chr(10),'')  -- 主交易号
    ,replace(replace(t1.merge_tran_num,chr(13),''),chr(10),'')  -- 合交易号
    ,replace(replace(t1.miro_tran_num,chr(13),''),chr(10),'')  -- 镜像交易号
    ,replace(replace(t1.rela_tran_num,chr(13),''),chr(10),'')  -- 关联交易号
    ,t1.ex_yld_rat  -- 行权收益率
    ,replace(replace(t1.cust_mgr_name,chr(13),''),chr(10),'')  -- 客户经理名称
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.camp_org_id,chr(13),''),chr(10),'')  -- 营销机构编号
    ,t1.redem_cfm_dt  -- 赎回确认日期
    ,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'')  -- 转账方式代码
    ,t1.dlvy_dt  -- 交割日期
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.cap_dir_descb,chr(13),''),chr(10),'')  -- 资金投向描述
    ,replace(replace(t1.final_dir_type_cd,chr(13),''),chr(10),'')  -- 最终投向类型代码
    ,replace(replace(t1.rela_ser_num,chr(13),''),chr(10),'')  -- 关联序列号
    ,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'')  -- 五级分类代码
    ,replace(replace(t1.prod_char_cd,chr(13),''),chr(10),'')  -- 产品性质代码
    ,t1.curr_lot  -- 当前份额
    ,t1.unpay_turn_lot  -- 未结转份额
    ,t1.input_dt  -- 录入日期
    ,replace(replace(t1.dlvy_site_id,chr(13),''),chr(10),'')  -- 交割场所编号
    ,t1.not_stl_comm_fee  -- 不结算手续费
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.contn_int_flg,chr(13),''),chr(10),'')  -- 含息标志
    ,replace(replace(t1.rela_party_info,chr(13),''),chr(10),'')  -- 关联方信息
    ,replace(replace(t1.redem_type_cd,chr(13),''),chr(10),'')  -- 赎回类型代码
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id                                    --标准产品编号    
    ,replace(replace(t1.ftp_id,chr(13),''),chr(10),'') as ftp_id                                              --ftp编号     
    ,replace(replace(t1.is_term,chr(13),''),chr(10),'') as is_term                                            --是否约期      
    ,t1.term_start_day as term_start_day                                                                      --约期开始日     
    ,t1.term_end_day as term_end_day                                                                          --约期结束日     
    ,replace(replace(t1.bank_cap_acct_open_bank_num,chr(13),''),chr(10),'') as bank_cap_acct_open_bank_num    --银行资金账户开户行号
    ,replace(replace(t1.bank_cap_acct_id,chr(13),''),chr(10),'') as bank_cap_acct_id                          --银行资金账户编号  
    ,replace(replace(t1.th_ssn_redem_flg,chr(13),''),chr(10),'') as th_ssn_redem_flg                          --当季赎回标志    
    ,t1.plan_redem_dt as plan_redem_dt                                                                        --计划赎回日期    
    ,replace(replace(t1.acct_b_cate_cd,chr(13),''),chr(10),'') as acct_b_cate_cd                              --账簿类别代码    
    ,replace(replace(t1.underly_fin_instm_id,chr(13),''),chr(10),'') as underly_fin_instm_id                  --标的金融工具编号  
    ,replace(replace(t1.underly_asset_type_id,chr(13),''),chr(10),'') as underly_asset_type_id                --标的资产类型编号  
    ,replace(replace(t1.underly_tran_market_id,chr(13),''),chr(10),'') as underly_tran_market_id              --标的交易市场编号  
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.evt_ibank_tran t1    --同业交易表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
and t1.entr_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_evt_ibank_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);