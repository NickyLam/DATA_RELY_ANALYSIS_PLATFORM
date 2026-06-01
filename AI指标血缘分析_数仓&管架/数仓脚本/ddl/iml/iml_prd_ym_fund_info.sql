/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ym_fund_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ym_fund_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ym_fund_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ym_fund_info(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,serv_plat_abbr varchar2(750) -- 服务平台简称
    ,mercht_id varchar2(100) -- 商户编号
    ,fund_cd varchar2(30) -- 基金代码
    ,fund_fname varchar2(750) -- 基金全称
    ,fund_abbr varchar2(750) -- 基金简称
    ,fund_type_cd varchar2(30) -- 基金类型代码
    ,prod_risk_level_cd varchar2(30) -- 产品风险等级代码
    ,cfm_days number(10) -- 确认天数
    ,redem_avl_days number(10) -- 赎回到账天数
    ,divd_way_cd varchar2(30) -- 分红方式代码
    ,curr_cd varchar2(30) -- 币种代码
    ,sell_status_cd varchar2(30) -- 销售状态代码
    ,fund_fee_type_cd varchar2(30) -- 基金费类型代码
    ,aip_open_flg varchar2(10) -- 定投开通标志
    ,tran_open_flg varchar2(10) -- 转换开通标志
    ,fund_mgmt_fee_rat number(18,6) -- 基金管理费率
    ,fund_trust_fee_rat number(18,6) -- 基金托管费率
    ,fe_subscr_fee_rat varchar2(4000) -- 前端认购费率
    ,fe_purch_fee_rat varchar2(4000) -- 前端申购费率
    ,redem_fee_rat varchar2(4000) -- 赎回费率
    ,indv_fir_subscr_lowt_amt number(18,6) -- 个人首次认购最低金额
    ,indv_supp_subscr_lowt_amt number(18,6) -- 个人追加认购最低金额
    ,indv_higt_subscr_amt number(18,6) -- 个人最高认购金额
    ,indv_fir_purch_lowt_amt number(18,6) -- 个人首次申购最低金额
    ,indv_supp_purch_lowt_amt number(18,6) -- 个人追加申购最低金额
    ,indv_higt_purch_amt number(18,6) -- 个人最高申购金额
    ,indv_aip_purch_lowt_amt number(18,6) -- 个人定投申购最低金额
    ,indv_aip_purch_higt_amt number(18,6) -- 个人定投申购最高金额
    ,indv_hold_lowt_lot number(18,6) -- 个人持有最低份额
    ,indv_redem_lowt_lot number(18,6) -- 个人赎回最低份额
    ,indv_tran_lowt_lot number(18,6) -- 个人转换最低份额
    ,found_dt date -- 成立日期
    ,fund_mger varchar2(4000) -- 基金管理人
    ,fund_trustee varchar2(150) -- 基金托管人
    ,fund_mgr varchar2(4000) -- 基金经理
    ,asset_size varchar2(4000) -- 资产规模
    ,lot_size varchar2(4000) -- 份额规模
    ,ten_holding varchar2(4000) -- 十大重仓股
    ,sell_serv_fee_rat number(18,6) -- 销售服务费率
    ,sign_elec_cont_flg varchar2(10) -- 签订电子合同标志
    ,fund_prod_type_cd varchar2(30) -- 基金产品类型代码
    ,purch_open_flg varchar2(10) -- 申购开通标志
    ,subscr_open_flg varchar2(10) -- 认购开通标志
    ,buy_open_flg varchar2(10) -- 购买开通标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_ym_fund_info to ${icl_schema};
grant select on ${iml_schema}.prd_ym_fund_info to ${idl_schema};
grant select on ${iml_schema}.prd_ym_fund_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ym_fund_info is '盈米基金信息';
comment on column ${iml_schema}.prd_ym_fund_info.prod_id is '产品编号';
comment on column ${iml_schema}.prd_ym_fund_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ym_fund_info.serv_plat_abbr is '服务平台简称';
comment on column ${iml_schema}.prd_ym_fund_info.mercht_id is '商户编号';
comment on column ${iml_schema}.prd_ym_fund_info.fund_cd is '基金代码';
comment on column ${iml_schema}.prd_ym_fund_info.fund_fname is '基金全称';
comment on column ${iml_schema}.prd_ym_fund_info.fund_abbr is '基金简称';
comment on column ${iml_schema}.prd_ym_fund_info.fund_type_cd is '基金类型代码';
comment on column ${iml_schema}.prd_ym_fund_info.prod_risk_level_cd is '产品风险等级代码';
comment on column ${iml_schema}.prd_ym_fund_info.cfm_days is '确认天数';
comment on column ${iml_schema}.prd_ym_fund_info.redem_avl_days is '赎回到账天数';
comment on column ${iml_schema}.prd_ym_fund_info.divd_way_cd is '分红方式代码';
comment on column ${iml_schema}.prd_ym_fund_info.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_ym_fund_info.sell_status_cd is '销售状态代码';
comment on column ${iml_schema}.prd_ym_fund_info.fund_fee_type_cd is '基金费类型代码';
comment on column ${iml_schema}.prd_ym_fund_info.aip_open_flg is '定投开通标志';
comment on column ${iml_schema}.prd_ym_fund_info.tran_open_flg is '转换开通标志';
comment on column ${iml_schema}.prd_ym_fund_info.fund_mgmt_fee_rat is '基金管理费率';
comment on column ${iml_schema}.prd_ym_fund_info.fund_trust_fee_rat is '基金托管费率';
comment on column ${iml_schema}.prd_ym_fund_info.fe_subscr_fee_rat is '前端认购费率';
comment on column ${iml_schema}.prd_ym_fund_info.fe_purch_fee_rat is '前端申购费率';
comment on column ${iml_schema}.prd_ym_fund_info.redem_fee_rat is '赎回费率';
comment on column ${iml_schema}.prd_ym_fund_info.indv_fir_subscr_lowt_amt is '个人首次认购最低金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_supp_subscr_lowt_amt is '个人追加认购最低金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_higt_subscr_amt is '个人最高认购金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_fir_purch_lowt_amt is '个人首次申购最低金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_supp_purch_lowt_amt is '个人追加申购最低金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_higt_purch_amt is '个人最高申购金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_aip_purch_lowt_amt is '个人定投申购最低金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_aip_purch_higt_amt is '个人定投申购最高金额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_hold_lowt_lot is '个人持有最低份额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_redem_lowt_lot is '个人赎回最低份额';
comment on column ${iml_schema}.prd_ym_fund_info.indv_tran_lowt_lot is '个人转换最低份额';
comment on column ${iml_schema}.prd_ym_fund_info.found_dt is '成立日期';
comment on column ${iml_schema}.prd_ym_fund_info.fund_mger is '基金管理人';
comment on column ${iml_schema}.prd_ym_fund_info.fund_trustee is '基金托管人';
comment on column ${iml_schema}.prd_ym_fund_info.fund_mgr is '基金经理';
comment on column ${iml_schema}.prd_ym_fund_info.asset_size is '资产规模';
comment on column ${iml_schema}.prd_ym_fund_info.lot_size is '份额规模';
comment on column ${iml_schema}.prd_ym_fund_info.ten_holding is '十大重仓股';
comment on column ${iml_schema}.prd_ym_fund_info.sell_serv_fee_rat is '销售服务费率';
comment on column ${iml_schema}.prd_ym_fund_info.sign_elec_cont_flg is '签订电子合同标志';
comment on column ${iml_schema}.prd_ym_fund_info.fund_prod_type_cd is '基金产品类型代码';
comment on column ${iml_schema}.prd_ym_fund_info.purch_open_flg is '申购开通标志';
comment on column ${iml_schema}.prd_ym_fund_info.subscr_open_flg is '认购开通标志';
comment on column ${iml_schema}.prd_ym_fund_info.buy_open_flg is '购买开通标志';
comment on column ${iml_schema}.prd_ym_fund_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ym_fund_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ym_fund_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ym_fund_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ym_fund_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ym_fund_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ym_fund_info.etl_timestamp is 'ETL处理时间戳';
