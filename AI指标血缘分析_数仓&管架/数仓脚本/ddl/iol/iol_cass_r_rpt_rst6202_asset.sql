/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst6202_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst6202_asset
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst6202_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst6202_asset(
    etl_dt_ora date -- 数据日期
    ,bus_no varchar2(300) -- 业务编号
    ,manager_org varchar2(300) -- 考核机构
    ,bus_line varchar2(300) -- 业务条线
    ,subj_no varchar2(300) -- 本金科目
    ,std_prod_no varchar2(300) -- 标准产品编号
    ,curr_cd varchar2(60) -- 币种(折币后目标币种）
    ,cust_no varchar2(300) -- 客户编号
    ,cust_mgr_no varchar2(300) -- 客户经理编号
    ,accts_org_no varchar2(300) -- 账务机构
    ,share_bal number(32,4) -- 余额
    ,share_bal_avg_y number(30,4) -- 余额年日均
    ,share_ftp_net_income number(38,8) -- FTP营业净收入
    ,share_ftp_profit number(38,8) -- FTP利润
    ,share_int_income_expns_af_m number(38,8) -- 外部利息收入_税后
    ,share_int_adj_bal_m number(30,4) -- 利息调整月累计
    ,share_final_ftp_accout_m number(38,8) -- FTP利息支出
    ,share_invest_prft number(30,2) -- 投资收益
    ,share_evha_val_chag number(30,8) -- 公允价值变动损益
    ,expense number(38,8) -- 营业费用
    ,surttax number(38,8) -- 税金及附加
    ,pre_pro_profit number(38,8) -- 拨备前经济利润
    ,asset_impair_loss number(22,4) -- 减值损失
    ,credit_impair_loss number(22,4) -- 信用减值损失
    ,other_asset_impair_loss number(22,4) -- 其他资产减值损失
    ,pre_tax_profit number(38,8) -- 税前利润
    ,income_tax_fee number(24,6) -- 所得税费用
    ,ftp_net_profit number(38,8) -- FTP净利润
    ,coc number(22,4) -- 资本成本
    ,share_eva number(38,8) -- EVA(经济利润)
    ,share_raroc number(38,8) -- RAROC（风险调整后的资本收益率）
    ,int_adj_subj_no varchar2(60) -- 利息调整科目
    ,int_income_subj_no varchar2(60) -- 利息科目
    ,invest_subj_no varchar2(60) -- 投资收益科目
    ,evha_val_chag_pl_subj_no varchar2(60) -- 公允价值科目
    ,val_subj_no varchar2(72) -- 增值税科目
    ,level5_class_cd varchar2(30) -- 五级分类
    ,org_term_dim varchar2(30) -- 期限代码
    ,cust_level varchar2(30) -- 客户等级
    ,cust_type varchar2(30) -- 客户类型
    ,cust_indus_type_cd varchar2(30) -- 行业代码
    ,class_credit_ind varchar2(10) -- 类信贷标志
    ,portf_no varchar2(60) -- 投组
    ,sm_mini_loan_ind varchar2(10) -- 小微贷款标志
    ,asset_type_name varchar2(250) -- 资产类型名称
    ,area varchar2(300) -- 所属区域
    ,cae_health_loan_ind varchar2(10) -- 文教健康贷款标志
    ,farming_ind varchar2(10) -- 涉农标志
    ,green_loan_ind varchar2(10) -- 绿色贷款标志
    ,spe_unq_new_med_side_enter_flg varchar2(10) -- 专精特新中小企业标志
    ,spe_unq_new_lte_gnt_corp_flg varchar2(10) -- 专精特新小巨人企业标志
    ,indust_park_corp_flg varchar2(10) -- 产业园企业标志
    ,share_total_line_expense number(38,8) -- 总行条线费用
    ,share_total_non_line_expense number(38,8) -- 总行非条线费用
    ,share_brch_line_expense number(38,8) -- 分行条线费用
    ,share_brch_non_line_expense number(38,8) -- 分行非条线费用
    ,share_sub_expense number(38,8) -- 支行（团队）直接费用
    ,share_rwaamount_avg_m number(38,8) -- RWA（风险加权资产）月平均金额
    ,share_rwaamount number(38,8) -- RWA（风险加权资产）金额
    ,cdd_flg varchar2(10) -- 超短贷标志
    ,adj_income_sum_m number(30,2) -- 调整收益月累计
    ,adj_income_sum_q number(30,2) -- 调整收益季累计
    ,adj_income_sum_y number(30,2) -- 调整收益年累计
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cass_r_rpt_rst6202_asset to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_asset to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_asset to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_asset to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst6202_asset is 'RDM_资产类业务明细表';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.bus_no is '业务编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.bus_line is '业务条线';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.subj_no is '本金科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.std_prod_no is '标准产品编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.curr_cd is '币种(折币后目标币种）';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cust_no is '客户编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cust_mgr_no is '客户经理编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.accts_org_no is '账务机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_bal is '余额';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_bal_avg_y is '余额年日均';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_ftp_net_income is 'FTP营业净收入';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_ftp_profit is 'FTP利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_int_income_expns_af_m is '外部利息收入_税后';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_int_adj_bal_m is '利息调整月累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_final_ftp_accout_m is 'FTP利息支出';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_invest_prft is '投资收益';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_evha_val_chag is '公允价值变动损益';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.expense is '营业费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.surttax is '税金及附加';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.pre_pro_profit is '拨备前经济利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.asset_impair_loss is '减值损失';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.credit_impair_loss is '信用减值损失';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.other_asset_impair_loss is '其他资产减值损失';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.pre_tax_profit is '税前利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.income_tax_fee is '所得税费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.ftp_net_profit is 'FTP净利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.coc is '资本成本';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_eva is 'EVA(经济利润)';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_raroc is 'RAROC（风险调整后的资本收益率）';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.int_adj_subj_no is '利息调整科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.int_income_subj_no is '利息科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.invest_subj_no is '投资收益科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.evha_val_chag_pl_subj_no is '公允价值科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.val_subj_no is '增值税科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.level5_class_cd is '五级分类';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.org_term_dim is '期限代码';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cust_level is '客户等级';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cust_type is '客户类型';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cust_indus_type_cd is '行业代码';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.class_credit_ind is '类信贷标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.portf_no is '投组';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.sm_mini_loan_ind is '小微贷款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.asset_type_name is '资产类型名称';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.area is '所属区域';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cae_health_loan_ind is '文教健康贷款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.farming_ind is '涉农标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.green_loan_ind is '绿色贷款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.spe_unq_new_med_side_enter_flg is '专精特新中小企业标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.spe_unq_new_lte_gnt_corp_flg is '专精特新小巨人企业标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.indust_park_corp_flg is '产业园企业标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_total_line_expense is '总行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_total_non_line_expense is '总行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_brch_line_expense is '分行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_brch_non_line_expense is '分行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_sub_expense is '支行（团队）直接费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_rwaamount_avg_m is 'RWA（风险加权资产）月平均金额';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.share_rwaamount is 'RWA（风险加权资产）金额';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.cdd_flg is '超短贷标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.adj_income_sum_m is '调整收益月累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.adj_income_sum_q is '调整收益季累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.adj_income_sum_y is '调整收益年累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_asset.etl_timestamp is 'ETL处理时间戳';
