/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_ibank_asset_supv_ind_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_ibank_asset_supv_ind_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_ibank_asset_supv_ind_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_ibank_asset_supv_ind_h(
    flow_num varchar2(100) -- 流水号
    ,lp_id varchar2(60) -- 法人编号
    ,party_id varchar2(250) -- 当事人编号
    ,cust_id varchar2(100) -- 客户编号
    ,ind_year varchar2(60) -- 指标年度
    ,info_src_descb varchar2(250) -- 信息来源描述
    ,tot_asset number(30,8) -- 总资产
    ,net_asset number(30,8) -- 净资产
    ,asset_mgmt_size number(30,8) -- 资产管理规模
    ,dep_size number(30,8) -- 存款规模
    ,loan_size number(30,8) -- 贷款规模
    ,cny_liqd_ratio number(30,8) -- 人民币流动性比例
    ,fcurr_liqd_ratio number(30,8) -- 外币流动性比例
    ,lf_curr_liqd_ratio number(30,8) -- 本外币流动性比例
    ,cny_dep_lon_ratio number(30,8) -- 人民币存贷比例
    ,fcurr_dep_lon_ratio number(30,8) -- 外币存贷比例
    ,lf_curr_dep_lon_ratio number(30,8) -- 本外币存贷比例
    ,cap_stock number(30,8) -- 股本
    ,shard_eqty number(30,8) -- 股东权益
    ,bus_net_inco number(30,8) -- 营业净收入
    ,net_margin number(30,8) -- 净利润
    ,non_asset_rat number(30,8) -- 不良资产率
    ,trust_bus_inco_pct number(30,8) -- 信托业务收入占比
    ,trust_reward_rat number(30,8) -- 信托报酬率
    ,cost_inco_ratio number(30,8) -- 成本收入比
    ,asset_prft_rat number(30,8) -- 资产利润率
    ,cap_prft_rat number(30,8) -- 资本利润率
    ,concern_loan_ratio number(30,8) -- 关注贷款比例
    ,ovdue_loan_ratio number(30,8) -- 逾期贷款比例
    ,npl_ratio number(30,8) -- 不良贷款比例
    ,cap_adquy_ratio number(30,8) -- 资本充足率
    ,pay_back_adquy_ratio number(30,8) -- 偿付能力充足率
    ,risk_cr number(30,8) -- 风险覆盖率
    ,net_stab_fund_ratio number(30,8) -- 净稳定资金率
    ,non_fin_rent_asset_rat number(30,8) -- 不良融资租赁资产率
    ,npl_bal number(30,8) -- 不良贷款余额
    ,conce_loan_bal number(30,8) -- 关注类贷款余额
    ,resv_bal number(30,8) -- 准备金余额
    ,guar_ratio number(30,8) -- 担保比例
    ,sh_term_invest_ratio number(30,8) -- 短期投资比例
    ,lonterm_invest_ratio number(30,8) -- 长期投资比例
    ,ibank_borrow_ratio number(30,8) -- 同业拆入比例
    ,prov_covr number(30,8) -- 拨备覆盖率
    ,rgst_teller_id varchar2(60) -- 登记柜员编号
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_cty_cd varchar2(100) -- 注册国家代码
    ,local_cty_rating varchar2(100) -- 所在国家评级
    ,countrycapstandard number(30,2) -- 所在国家或地区监管部门的最低资本监管要求
    ,countryaddoncapital number(30,2) -- 所在国家或地区监管部门公开发布的监管法规中缓冲资本要求
    ,coretieronerate number(30,8) -- 核心一级资本充足率
    ,tieronerate number(30,8) -- 一级资本充足率
    ,capitaladeratio number(30,8) -- 资本充足率
    ,lever_rat number(30,2) -- 杠杆率
    ,ext_audit_opinion varchar2(1000) -- 外部审计意见
    ,major_risk_flg varchar2(10) -- 尽职调查发现存在重大风险标志
    ,update_tm date -- 更新时间
    ,fir_create_time date -- 首次创建时间
    ,badrzzl_scale number(30,8) -- 拨备覆盖不良融资租赁资产率
    ,npl_and_expe_loan_devit_degree number(30,8) -- 不良贷款与预期贷款偏离度
    ,zqjzb_scale number(30,8) -- 持有一种权益类证券的成本与净资本比例
    ,zqsz_scale number(30,8) -- 持有一种权益类证券市值与其总市值的比例
    ,loan_fin_rent_asset_size number(18,8) -- 贷款/融资租赁资产规模
    ,loan_loss_prep_adquy_ratio number(30,8) -- 贷款损失准备充足率
    ,group_cust_rela_degree number(30,8) -- 集团客户关联度
    ,single_cust_rela_degree number(30,8) -- 单一客户关联度
    ,single_cust_centr_degree number(30,8) -- 单一客户集中度
    ,dyshard_prt_crdt_centr_degree varchar2(100) -- 单一股东及其关联方授信集中度
    ,dy_group_cust_crdt_cendegree number(30,8) -- 单一集团客户授信集中度
    ,dykhjzb_scale number(30,8) -- 对单一客户融券业务规模与净资本比例
    ,dykhrz_scale number(30,8) -- 对单一客户融资业务规模与净资本比例
    ,risk_adj_cap_rtn_rat number(30,8) -- 风险调整资本回报率
    ,JSDGP_SCALE number(30,8) -- 接受单只担保股票市值与该股票总市值比例
    ,net_set_cap_ratio number(30,8) -- 净稳定资金比例
    ,ljck_scale number(30,8) -- 累计外汇敞口头寸占资本净额比例
    ,lcr number(30,8) -- 流动性覆盖率
    ,liqd_match_rat number(30,8) -- 流动性匹配率
    ,buy_rtn_sell_fin_asset number(30,8) -- 买入返售金融资产
    ,pjdl_scale number(30,8) -- 平均代理证券业务净收入
    ,per_capita_margin number(30,8) -- 人均利润
    ,accts_recvbl_class_invest_amt number(30,8) -- 应收款项类投资金额
    ,excl_liqd_asset_adquy_ratio number(30,8) -- 优质流动性资产充足率
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_ibank_asset_supv_ind_h to ${icl_schema};
grant select on ${iml_schema}.pty_ibank_asset_supv_ind_h to ${idl_schema};
grant select on ${iml_schema}.pty_ibank_asset_supv_ind_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_ibank_asset_supv_ind_h is '同业客户资产监管指标历史';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.flow_num is '流水号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.ind_year is '指标年度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.info_src_descb is '信息来源描述';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.tot_asset is '总资产';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.net_asset is '净资产';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.asset_mgmt_size is '资产管理规模';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.dep_size is '存款规模';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.loan_size is '贷款规模';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cny_liqd_ratio is '人民币流动性比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.fcurr_liqd_ratio is '外币流动性比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lf_curr_liqd_ratio is '本外币流动性比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cny_dep_lon_ratio is '人民币存贷比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.fcurr_dep_lon_ratio is '外币存贷比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lf_curr_dep_lon_ratio is '本外币存贷比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cap_stock is '股本';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.shard_eqty is '股东权益';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.bus_net_inco is '营业净收入';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.net_margin is '净利润';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.non_asset_rat is '不良资产率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.trust_bus_inco_pct is '信托业务收入占比';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.trust_reward_rat is '信托报酬率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cost_inco_ratio is '成本收入比';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.asset_prft_rat is '资产利润率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cap_prft_rat is '资本利润率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.concern_loan_ratio is '关注贷款比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.ovdue_loan_ratio is '逾期贷款比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.npl_ratio is '不良贷款比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.cap_adquy_ratio is '资本充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.pay_back_adquy_ratio is '偿付能力充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.risk_cr is '风险覆盖率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.net_stab_fund_ratio is '净稳定资金率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.non_fin_rent_asset_rat is '不良融资租赁资产率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.npl_bal is '不良贷款余额';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.conce_loan_bal is '关注类贷款余额';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.resv_bal is '准备金余额';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.guar_ratio is '担保比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.sh_term_invest_ratio is '短期投资比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lonterm_invest_ratio is '长期投资比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.ibank_borrow_ratio is '同业拆入比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.prov_covr is '拨备覆盖率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.rgst_cty_cd is '注册国家代码';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.local_cty_rating is '所在国家评级';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.countrycapstandard is '所在国家或地区监管部门的最低资本监管要求';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.countryaddoncapital is '所在国家或地区监管部门公开发布的监管法规中缓冲资本要求';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.coretieronerate is '核心一级资本充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.tieronerate is '一级资本充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.capitaladeratio is '资本充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lever_rat is '杠杆率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.ext_audit_opinion is '外部审计意见';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.major_risk_flg is '尽职调查发现存在重大风险标志';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.update_tm is '更新时间';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.fir_create_time is '首次创建时间';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.badrzzl_scale is '拨备覆盖不良融资租赁资产率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.npl_and_expe_loan_devit_degree is '不良贷款与预期贷款偏离度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.zqjzb_scale is '持有一种权益类证券的成本与净资本比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.zqsz_scale is '持有一种权益类证券市值与其总市值的比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.loan_fin_rent_asset_size is '贷款/融资租赁资产规模';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.loan_loss_prep_adquy_ratio is '贷款损失准备充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.group_cust_rela_degree is '集团客户关联度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.single_cust_rela_degree is '单一客户关联度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.single_cust_centr_degree is '单一客户集中度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.dyshard_prt_crdt_centr_degree is '单一股东及其关联方授信集中度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.dy_group_cust_crdt_cendegree is '单一集团客户授信集中度';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.dykhjzb_scale is '对单一客户融券业务规模与净资本比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.dykhrz_scale is '对单一客户融资业务规模与净资本比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.risk_adj_cap_rtn_rat is '风险调整资本回报率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.JSDGP_SCALE is '接受单只担保股票市值与该股票总市值比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.net_set_cap_ratio is '净稳定资金比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.ljck_scale is '累计外汇敞口头寸占资本净额比例';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.lcr is '流动性覆盖率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.liqd_match_rat is '流动性匹配率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.buy_rtn_sell_fin_asset is '买入返售金融资产';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.pjdl_scale is '平均代理证券业务净收入';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.per_capita_margin is '人均利润';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.accts_recvbl_class_invest_amt is '应收款项类投资金额';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.excl_liqd_asset_adquy_ratio is '优质流动性资产充足率';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_ibank_asset_supv_ind_h.etl_timestamp is 'ETL处理时间戳';
