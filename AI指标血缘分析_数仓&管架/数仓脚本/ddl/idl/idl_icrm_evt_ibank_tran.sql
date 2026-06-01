/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_evt_ibank_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_evt_ibank_tran
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_evt_ibank_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_evt_ibank_tran(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_num varchar2(60) -- 交易号
    ,entr_dt date -- 委托日期
    ,entr_tm varchar2(10) -- 委托时间
    ,cfm_dt date -- 确认日期
    ,cfm_tm varchar2(10) -- 确认时间
    ,intnal_tran_num varchar2(60) -- 内部交易号
    ,ext_tran_num varchar2(60) -- 外部交易号
    ,operr_name varchar2(100) -- 操作员名称
    ,tran_type_id varchar2(60) -- 交易类型编号
    ,ext_cap_acct_id varchar2(60) -- 外部资金账户编号
    ,intnal_cap_acct_id varchar2(60) -- 内部资金账户编号
    ,ext_secu_acct_id varchar2(60) -- 外部证券账户编号
    ,intnal_secu_acct_id varchar2(60) -- 内部证券账户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,pric_intnal_cap_acct_id varchar2(60) -- 本金内部资金账户编号
    ,fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,tran_market_id varchar2(60) -- 交易市场编号
    ,fin_instm_name varchar2(250) -- 金融工具名称
    ,tran_qtty number(18,0) -- 交易数量
    ,tran_price number(30,2) -- 交易价格
    ,tran_amt number(30,2) -- 交易金额
    ,tran_fee number(30,2) -- 交易费用
    ,stl_dt date -- 结算日期
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,net_price_amt number(30,8) -- 净价金额
    ,int_recvbl number(30,8) -- 应收利息
    ,quote_tran_num varchar2(60) -- 引用交易号
    ,ignore_flg varchar2(10) -- 忽略标志
    ,tran_exec_market_id varchar2(60) -- 交易执行市场编号
    ,agent_name varchar2(100) -- 经办人名称
    ,cntpty_name varchar2(200) -- 交易对手名称
    ,evltion_net_price_brkb number(18,6) -- 估值净价偏移度
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,deal_qtty number(18,0) -- 已成交数量
    ,actl_recv_int number(30,2) -- 实收利息
    ,actl_recv_amt number(30,2) -- 实收金额
    ,dealer_name varchar2(100) -- 交易员名称
    ,cntpty_zzd_acct_id varchar2(100) -- 交易对手中债登账户编号
    ,cntpty_open_bank_num varchar2(60) -- 交易对手开户行号
    ,cntpty_acct_num varchar2(200) -- 交易对手账号
    ,cntpty_open_bank_name varchar2(500) -- 交易对手开户行名称
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,cbond_yld_rat number(18,8) -- 中债收益率
    ,exp_yld_rat number(18,8) -- 到期收益率
    ,recvbl_uncol_int number(30,2) -- 应收未收利息
    ,operr_id varchar2(60) -- 操作员编号
    ,checker_id varchar2(60) -- 复核员编号
    ,recvbl_uncol_pric number(30,2) -- 应收未收本金
    ,actl_int number(30,2) -- 实付利息
    ,actl_pric number(30,2) -- 实付本金
    ,ref_type_cd varchar2(10) -- 参考类型代码
    ,recvbl_uncol_int_resv_flg varchar2(10) -- 应收未收利息保留标志
    ,recvbl_uncol_pric_resv_flg varchar2(10) -- 应收未收本金保留标志
    ,dealer_id varchar2(60) -- 交易员编号
    ,tran_mode_cd varchar2(10) -- 交易模式代码
    ,clear_mode_cd varchar2(10) -- 清算模式代码
    ,apv_odd_no varchar2(60) -- 审批单号
    ,stl_status_cd varchar2(10) -- 结算状态代码
    ,accti_tran_num varchar2(60) -- 核算交易号
    ,ftp_int_rat number(18,8) -- FTP利率
    ,assoced_apv_odd_no varchar2(60) -- 关联的审批单号
    ,bi_valid_cont_id varchar2(100) -- 双边有效合同编号
    ,data_src_cd varchar2(10) -- 数据来源代码
    ,nv_dt date -- 净值日期
    ,cntpty_swift_cd varchar2(60) -- 交易对手SWIFT代码
    ,splt_type_cd varchar2(10) -- 拆分类型代码
    ,parent_tran_num varchar2(60) -- 父交易号
    ,main_tran_num varchar2(60) -- 主交易号
    ,merge_tran_num varchar2(60) -- 合交易号
    ,miro_tran_num varchar2(60) -- 镜像交易号
    ,rela_tran_num varchar2(60) -- 关联交易号
    ,ex_yld_rat number(18,8) -- 行权收益率
    ,cust_mgr_name varchar2(200) -- 客户经理名称
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,camp_org_id varchar2(60) -- 营销机构编号
    ,redem_cfm_dt date -- 赎回确认日期
    ,tran_way_cd varchar2(30) -- 转账方式代码
    ,dlvy_dt date -- 交割日期
    ,cont_id varchar2(60) -- 合同编号
    ,cap_dir_descb varchar2(1000) -- 资金投向描述
    ,final_dir_type_cd varchar2(10) -- 最终投向类型代码
    ,rela_ser_num varchar2(100) -- 关联序列号
    ,level5_cls_cd varchar2(10) -- 五级分类代码
    ,prod_char_cd varchar2(10) -- 产品性质代码
    ,curr_lot number(30,2) -- 当前份额
    ,unpay_turn_lot number(30,2) -- 未结转份额
    ,input_dt date -- 录入日期
    ,dlvy_site_id varchar2(60) -- 交割场所编号
    ,not_stl_comm_fee number(30,2) -- 不结算手续费
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,contn_int_flg varchar2(10) -- 含息标志
    ,rela_party_info varchar2(2000) -- 关联方信息
    ,redem_type_cd varchar2(10) -- 赎回类型代码
    ,std_prod_id                    varchar2(60)    --标准产品编号    
    ,ftp_id                         varchar2(100)   --ftp编号     
    ,is_term                        varchar2(10)    --是否约期      
    ,term_start_day                 date            --约期开始日     
    ,term_end_day                   date            --约期结束日     
    ,bank_cap_acct_open_bank_num    varchar2(250)   --银行资金账户开户行号
    ,bank_cap_acct_id               varchar2(250)   --银行资金账户编号  
    ,th_ssn_redem_flg               varchar2(10)    --当季赎回标志    
    ,plan_redem_dt                  date            --计划赎回日期    
    ,acct_b_cate_cd                 varchar2(30)    --账簿类别代码    
    ,underly_fin_instm_id           varchar2(60)    --标的金融工具编号  
    ,underly_asset_type_id          varchar2(60)    --标的资产类型编号  
    ,underly_tran_market_id         varchar2(60)    --标的交易市场编号  
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_evt_ibank_tran to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_evt_ibank_tran is '同业交易表';
comment on column ${idl_schema}.icrm_evt_ibank_tran.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.evt_id is '事件编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_num is '交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.entr_dt is '委托日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.entr_tm is '委托时间';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cfm_dt is '确认日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cfm_tm is '确认时间';
comment on column ${idl_schema}.icrm_evt_ibank_tran.intnal_tran_num is '内部交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ext_tran_num is '外部交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.operr_name is '操作员名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_type_id is '交易类型编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ext_cap_acct_id is '外部资金账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.intnal_cap_acct_id is '内部资金账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ext_secu_acct_id is '外部证券账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.pric_intnal_cap_acct_id is '本金内部资金账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.fin_instm_id is '金融工具编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.asset_type_id is '资产类型编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_market_id is '交易市场编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.fin_instm_name is '金融工具名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_qtty is '交易数量';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_price is '交易价格';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_amt is '交易金额';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_fee is '交易费用';
comment on column ${idl_schema}.icrm_evt_ibank_tran.stl_dt is '结算日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.stl_way_cd is '结算方式代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.net_price_amt is '净价金额';
comment on column ${idl_schema}.icrm_evt_ibank_tran.int_recvbl is '应收利息';
comment on column ${idl_schema}.icrm_evt_ibank_tran.quote_tran_num is '引用交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ignore_flg is '忽略标志';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_exec_market_id is '交易执行市场编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.agent_name is '经办人名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_name is '交易对手名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.evltion_net_price_brkb is '估值净价偏移度';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_src_cd is '交易来源代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.deal_qtty is '已成交数量';
comment on column ${idl_schema}.icrm_evt_ibank_tran.actl_recv_int is '实收利息';
comment on column ${idl_schema}.icrm_evt_ibank_tran.actl_recv_amt is '实收金额';
comment on column ${idl_schema}.icrm_evt_ibank_tran.dealer_name is '交易员名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_zzd_acct_id is '交易对手中债登账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_open_bank_num is '交易对手开户行号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_acct_num is '交易对手账号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_open_bank_name is '交易对手开户行名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_acct_name is '交易对手账户名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cbond_yld_rat is '中债收益率';
comment on column ${idl_schema}.icrm_evt_ibank_tran.exp_yld_rat is '到期收益率';
comment on column ${idl_schema}.icrm_evt_ibank_tran.recvbl_uncol_int is '应收未收利息';
comment on column ${idl_schema}.icrm_evt_ibank_tran.operr_id is '操作员编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.checker_id is '复核员编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.recvbl_uncol_pric is '应收未收本金';
comment on column ${idl_schema}.icrm_evt_ibank_tran.actl_int is '实付利息';
comment on column ${idl_schema}.icrm_evt_ibank_tran.actl_pric is '实付本金';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ref_type_cd is '参考类型代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.recvbl_uncol_int_resv_flg is '应收未收利息保留标志';
comment on column ${idl_schema}.icrm_evt_ibank_tran.recvbl_uncol_pric_resv_flg is '应收未收本金保留标志';
comment on column ${idl_schema}.icrm_evt_ibank_tran.dealer_id is '交易员编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_mode_cd is '交易模式代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.clear_mode_cd is '清算模式代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.apv_odd_no is '审批单号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.stl_status_cd is '结算状态代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.accti_tran_num is '核算交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ftp_int_rat is 'FTP利率';
comment on column ${idl_schema}.icrm_evt_ibank_tran.assoced_apv_odd_no is '关联的审批单号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.bi_valid_cont_id is '双边有效合同编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.data_src_cd is '数据来源代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.nv_dt is '净值日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cntpty_swift_cd is '交易对手SWIFT代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.splt_type_cd is '拆分类型代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.parent_tran_num is '父交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.main_tran_num is '主交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.merge_tran_num is '合交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.miro_tran_num is '镜像交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.rela_tran_num is '关联交易号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ex_yld_rat is '行权收益率';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cust_mgr_name is '客户经理名称';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.camp_org_id is '营销机构编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.redem_cfm_dt is '赎回确认日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.tran_way_cd is '转账方式代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.dlvy_dt is '交割日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cont_id is '合同编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.cap_dir_descb is '资金投向描述';
comment on column ${idl_schema}.icrm_evt_ibank_tran.final_dir_type_cd is '最终投向类型代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.rela_ser_num is '关联序列号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.level5_cls_cd is '五级分类代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.prod_char_cd is '产品性质代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.curr_lot is '当前份额';
comment on column ${idl_schema}.icrm_evt_ibank_tran.unpay_turn_lot is '未结转份额';
comment on column ${idl_schema}.icrm_evt_ibank_tran.input_dt is '录入日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.dlvy_site_id is '交割场所编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.not_stl_comm_fee is '不结算手续费';
comment on column ${idl_schema}.icrm_evt_ibank_tran.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.contn_int_flg is '含息标志';
comment on column ${idl_schema}.icrm_evt_ibank_tran.rela_party_info is '关联方信息';
comment on column ${idl_schema}.icrm_evt_ibank_tran.redem_type_cd is '赎回类型代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.icrm_evt_ibank_tran.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.ftp_id is 'ftp编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.is_term is '是否约期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.term_start_day is '约期开始日';
comment on column ${idl_schema}.icrm_evt_ibank_tran.term_end_day is '约期结束日';
comment on column ${idl_schema}.icrm_evt_ibank_tran.bank_cap_acct_open_bank_num is '银行资金账户开户行号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.bank_cap_acct_id is '银行资金账户编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.th_ssn_redem_flg is '当季赎回标志';
comment on column ${idl_schema}.icrm_evt_ibank_tran.plan_redem_dt is '计划赎回日期';
comment on column ${idl_schema}.icrm_evt_ibank_tran.acct_b_cate_cd is '账簿类别代码';
comment on column ${idl_schema}.icrm_evt_ibank_tran.underly_fin_instm_id is '标的金融工具编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.underly_asset_type_id is '标的资产类型编号';
comment on column ${idl_schema}.icrm_evt_ibank_tran.underly_tran_market_id is '标的交易市场编号';
