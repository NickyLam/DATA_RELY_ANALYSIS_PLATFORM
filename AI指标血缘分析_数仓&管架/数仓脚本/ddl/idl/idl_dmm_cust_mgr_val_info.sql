/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_cust_mgr_val_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_cust_mgr_val_info
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_cust_mgr_val_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_cust_mgr_val_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(500) -- 客户经理名称
    ,belong_brch_id varchar2(100) -- 所属分行编号
    ,belong_brch_name varchar2(500) -- 所属分行名称
    ,belong_subrch_id varchar2(100) -- 所属支行编号
    ,belong_subrch_name varchar2(500) -- 所属支行名称
    ,retl_loan_bus_inco_thsnds number(38,8) -- 零贷营收万元
    ,riches_bus_inco_thsnds number(38,8) -- 财富营收万元
    ,corp_bus_inco_thsnds number(38,8) -- 公司营收万元
    ,ftp_bus_net_inco number(38,8) -- ftp营业净收入
    ,asset_ftp_bus_net_inco number(38,8) -- 资产端ftp营业净收入
    ,liab_ftp_bus_net_inco number(38,8) -- 负债端ftp营业净收入
	,inter_ftp_bus_net_inco number(38,8) -- 中收类ftp营业净收入
    ,asset_class_net_int_inco number(38,8) -- 资产类净利息收入
    ,liab_class_net_int_inco number(38,8) -- 负债类净利息收入
    ,asset_bus_fee number(38,8) -- 资产端营业费用
    ,liab_bus_fee number(38,8) -- 负债端营业费用
    ,asset_tax_and_addit number(38,8) -- 资产端税金及附加
    ,liab_tax_and_addit number(38,8) -- 负债端税金及附加
	,inter_tax_and_addit number(38,8) -- 中收类税金及附加
    ,asset_before_provi_margin number(38,8) -- 资产端拨备前利润
    ,liab_before_provi_margin number(38,8) -- 负债端拨备前利润
	,inter_before_provi_margin number(38,8) -- 中收类拨备前利润
    ,asset_impam_loss number(38,8) -- 资产减值损失
    ,asset_bus_margin number(38,8) -- 资产端营业利润
    ,liab_bus_margin number(38,8) -- 负债端营业利润
	,inter_bus_margin number(38,8) -- 中收类营业利润
    ,asset_out_bus_net_inco number(38,8) -- 资产端营业外净收入
    ,liab_out_bus_net_inco number(38,8) -- 负债端营业外净收入
    ,asset_pre_tax_margin number(38,8) -- 资产端税前利润
    ,liab_pre_tax_margin number(38,8) -- 负债端税前利润
	,inter_pre_tax_margin number(38,8) -- 中收类税前利润
    ,asset_ftp_net_margin number(38,8) -- 资产端ftp净利润
    ,liab_ftp_net_margin number(38,8) -- 负债端ftp净利润
	,inter_ftp_net_margin number(38,8) -- 中收类ftp净利润
    ,asset_econ_margin_eva number(38,8) -- 资产端经济利润(eva)
    ,liab_econ_margin_eva number(38,8) -- 负债端经济利润(eva)
	,inter_econ_margin_eva number(38,8) -- 中收类经济利润(eva)
    ,asset_raroc number(38,8) -- 资产端raroc（风险调整后的资本收益率）
    ,liab_raroc number(38,8) -- 负债端raroc（风险调整后的资本收益率）
	,inter_raroc number(38,8) -- 中收类raroc（风险调整后的资本收益率）
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.dmm_cust_mgr_val_info to ${idl_schema};
grant select on ${idl_schema}.dmm_cust_mgr_val_info to ${iel_schema};
grant select on ${idl_schema}.dmm_cust_mgr_val_info to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_cust_mgr_val_info is '客户经理产能价值信息';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.lp_id is '法人编号';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.cust_mgr_name is '客户经理名称';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.belong_brch_id is '所属分行编号';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.belong_brch_name is '所属分行名称';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.belong_subrch_id is '所属支行编号';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.belong_subrch_name is '所属支行名称';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.retl_loan_bus_inco_thsnds is '零贷营收万元';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.riches_bus_inco_thsnds is '财富营收万元';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.corp_bus_inco_thsnds is '公司营收万元';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.ftp_bus_net_inco is 'ftp营业净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_ftp_bus_net_inco is '资产端ftp营业净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_ftp_bus_net_inco is '负债端ftp营业净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_ftp_bus_net_inco is '中收类ftp营业净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_class_net_int_inco is '资产类净利息收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_class_net_int_inco is '负债类净利息收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_bus_fee is '资产端营业费用';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_bus_fee is '负债端营业费用';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_tax_and_addit is '资产端税金及附加';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_tax_and_addit is '负债端税金及附加';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_tax_and_addit is '中收类税金及附加';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_before_provi_margin is '资产端拨备前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_before_provi_margin is '负债端拨备前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_before_provi_margin is '中收类拨备前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_impam_loss is '资产减值损失';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_bus_margin is '资产端营业利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_bus_margin is '负债端营业利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_bus_margin is '中收类营业利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_out_bus_net_inco is '资产端营业外净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_out_bus_net_inco is '负债端营业外净收入';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_pre_tax_margin is '资产端税前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_pre_tax_margin is '负债端税前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_pre_tax_margin is '中收类税前利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_ftp_net_margin is '资产端ftp净利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_ftp_net_margin is '负债端ftp净利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_ftp_net_margin is '中收类ftp净利润';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_econ_margin_eva is '资产端经济利润(eva)' ;
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_econ_margin_eva is '负债端经济利润(eva)';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_econ_margin_eva is '中收类经济利润(eva)';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.asset_raroc is '资产端raroc（风险调整后的资本收益率）';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.liab_raroc is '负债端raroc（风险调整后的资本收益率）';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.inter_raroc is '中收类raroc（风险调整后的资本收益率）';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_cust_mgr_val_info.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_cust_mgr_val_info.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_cust_mgr_val_info.etl_timestamp is 'ETL处理时间戳';
