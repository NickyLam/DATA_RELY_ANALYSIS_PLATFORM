/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cass_r_rpt_rst6202_liabilitie
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cass_r_rpt_rst6202_liabilitie
whenever sqlerror continue none;
drop table ${iol_schema}.cass_r_rpt_rst6202_liabilitie purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cass_r_rpt_rst6202_liabilitie(
    etl_dt_ora date -- 数据日期
    ,bus_no varchar2(300) -- 业务编号
    ,std_prod_no varchar2(300) -- 标准产品编号
    ,subj_no varchar2(300) -- 本金科目
    ,manager_org varchar2(300) -- 考核机构
    ,bus_line varchar2(300) -- 业务条线
    ,cust_no varchar2(300) -- 客户编号
    ,cust_mgr_no varchar2(300) -- 客户经理编号
    ,curr_cd varchar2(60) -- 币种(折币后目标币种）
    ,accts_org_no varchar2(300) -- 账务机构
    ,share_bal number(32,4) -- 余额
    ,share_bal_avg_y number(30,4) -- 余额年日均
    ,share_ftp_net_income number(38,8) -- FTP营业净收入
    ,share_ftp_profit number(38,8) -- FTP利润
    ,share_final_ftp_accint_m number(38,8) -- FTP利息收入
    ,share_int_adj_bal_m number(30,4) -- 利息调整月累计
    ,share_int_out_expns_m number(38,8) -- 外部利息支出
    ,expense number(38,8) -- 营业费用
    ,pre_tax_profit number(38,8) -- 税前利润
    ,income_tax_fee number(24,6) -- 所得税费用
    ,ftp_net_profit number(38,8) -- FTP净利润
    ,share_eva number(38,8) -- EVA(经济利润)
    ,share_raroc number(38,8) -- RAROC（风险调整后的资本收益率）
    ,int_adj_subj_no varchar2(60) -- 利息调整科目
    ,int_income_subj_no varchar2(60) -- 利息科目
    ,org_term_dim varchar2(30) -- 期限代码
    ,cust_level varchar2(30) -- 客户等级
    ,cust_type varchar2(30) -- 客户类型
    ,cust_indus_type_cd varchar2(30) -- 行业代码
    ,ibank_dep_ind varchar2(10) -- 同业存款标志
    ,p2p_dep_ind varchar2(10) -- P2P存款标志
    ,time_demand_ind varchar2(10) -- 定活标志
    ,fiscal_dep_flg varchar2(10) -- 财政性存款标识
    ,core_dep_flg varchar2(200) -- 核心存款标志
    ,area varchar2(300) -- 所属区域
    ,share_total_line_expense number(38,8) -- 总行条线费用
    ,share_total_non_line_expense number(38,8) -- 总行非条线费用
    ,share_brch_line_expense number(38,8) -- 分行条线费用
    ,share_brch_non_line_expense number(38,8) -- 分行非条线费用
    ,share_sub_expense number(38,8) -- 支行（团队）直接费用
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
grant select on ${iol_schema}.cass_r_rpt_rst6202_liabilitie to ${iml_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_liabilitie to ${icl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_liabilitie to ${idl_schema};
grant select on ${iol_schema}.cass_r_rpt_rst6202_liabilitie to ${iel_schema};

-- comment
comment on table ${iol_schema}.cass_r_rpt_rst6202_liabilitie is 'RDM_负债类业务明细表';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.bus_no is '业务编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.std_prod_no is '标准产品编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.subj_no is '本金科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.manager_org is '考核机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.bus_line is '业务条线';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.cust_no is '客户编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.cust_mgr_no is '客户经理编号';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.curr_cd is '币种(折币后目标币种）';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.accts_org_no is '账务机构';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_bal is '余额';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_bal_avg_y is '余额年日均';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_ftp_net_income is 'FTP营业净收入';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_ftp_profit is 'FTP利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_final_ftp_accint_m is 'FTP利息收入';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_int_adj_bal_m is '利息调整月累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_int_out_expns_m is '外部利息支出';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.expense is '营业费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.pre_tax_profit is '税前利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.income_tax_fee is '所得税费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.ftp_net_profit is 'FTP净利润';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_eva is 'EVA(经济利润)';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_raroc is 'RAROC（风险调整后的资本收益率）';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.int_adj_subj_no is '利息调整科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.int_income_subj_no is '利息科目';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.org_term_dim is '期限代码';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.cust_level is '客户等级';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.cust_type is '客户类型';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.cust_indus_type_cd is '行业代码';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.ibank_dep_ind is '同业存款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.p2p_dep_ind is 'P2P存款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.time_demand_ind is '定活标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.fiscal_dep_flg is '财政性存款标识';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.core_dep_flg is '核心存款标志';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.area is '所属区域';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_total_line_expense is '总行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_total_non_line_expense is '总行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_brch_line_expense is '分行条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_brch_non_line_expense is '分行非条线费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.share_sub_expense is '支行（团队）直接费用';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.adj_income_sum_m is '调整收益月累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.adj_income_sum_q is '调整收益季累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.adj_income_sum_y is '调整收益年累计';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cass_r_rpt_rst6202_liabilitie.etl_timestamp is 'ETL处理时间戳';
