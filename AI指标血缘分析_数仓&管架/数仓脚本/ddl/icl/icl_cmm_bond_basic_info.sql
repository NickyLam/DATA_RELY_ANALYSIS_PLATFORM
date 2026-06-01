/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bond_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bond_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bond_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bond_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bond_id varchar2(60) -- 债券编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,bond_name varchar2(750) -- 债券名称
    ,bond_abbr varchar2(150) -- 债券简称
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,bond_cls_name varchar2(150) -- 债券分类名称
    ,trust_org_id varchar2(60) -- 托管机构编号
    ,mgmt_mode_cd varchar2(60) -- 管理模式代码
    ,issuer_cust_id varchar2(60) -- 发行人客户编号
    ,issuer_cd varchar2(60) -- 发行人代码
    ,issuer_name varchar2(375) -- 发行人名称
    ,issue_main_belong_cty_rg_cd varchar2(60) -- 发行主体所属国家地区代码
    ,issue_rg_cd varchar2(60) -- 发行地区代码
    ,actl_mang_land_nation_cd varchar2(60) -- 实际经营地国别代码
    ,curr_cd varchar2(10) -- 币种代码
    ,issue_corp number(30,0) -- 发行单位
    ,issue_price number(18,12) -- 发行价格
    ,issue_int_rat number(18,12) -- 发行利率
    ,issue_size number(38,8) -- 发行规模
    ,fac_val_int_rat number(18,12) -- 票面利率
    ,fac_val number(30,2) -- 票面面值
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,base_rat_id varchar2(100) -- 基准利率编号
    ,int_rat_float_point number(18,12) -- 利率浮动点数
    ,int_rat_float_dir_cd varchar2(10) -- 利率浮动方向代码
    ,int_rat_float_uplmi number(18,12) -- 利率浮动上限
    ,int_rat_float_lolmi number(18,12) -- 利率浮动下限
    ,int_accr_base_cd varchar2(30) -- 计息基准代码
    ,int_accr_curr_cd varchar2(10) -- 计息币种代码
    ,int_accr_ped_cd varchar2(10) -- 计息周期代码
    ,pay_int_ped_cd varchar2(10) -- 付息周期代码
    ,src_pay_int_ped_cd varchar2(10) -- 源付息周期代码
    ,comp_int_ped_cd varchar2(10) -- 复利周期代码
    ,reval_ped_cd varchar2(10) -- 重定价周期代码
    ,fir_reval_dt date -- 首次重定价日期
    ,reval_way_cd varchar2(10) -- 重定价方式代码
    ,last_reval_dt date -- 上次重定价日期
    ,next_reval_dt date -- 下次重定价日期
    ,reval_start_dt date -- 重定价开始日期
    ,reval_end_dt date -- 重定价结束日期
    ,reval_int_rat number(18,12) -- 重定价利率
    ,exp_yld_rat number(18,12) -- 到期收益率
    ,issue_dt date -- 发行日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor varchar2(15) -- 期限
    ,list_dt date -- 上市日期
    ,fir_pay_int_dt date -- 首次付息日期
    ,last_pay_int_dt date -- 上次付息日期
    ,next_pay_int_dt date -- 下次付息日期
    ,next_rpp_amt number(30,2) -- 下次还本金额
    ,next_pay_int_amt number(30,2) -- 下次付息金额
    ,prod_currt_tot_bal number(38,8) -- 产品当期总余额
    ,hold_level_currt_bal number(38,8) -- 持有档次当期余额
    ,stop_circlt_dt date -- 停止流通日期
    ,tranbl_bond_flg varchar2(10) -- 可转换债券标志
    ,discnt_debt_vch_flg varchar2(10) -- 贴现债券标志
    ,acru_int_flg varchar2(10) -- 应计利息标志
    ,subtn_bond_flg varchar2(10) -- 永续债标志
    ,stc_flg varchar2(10) -- STC标志
    ,prior_level_flg varchar2(10) -- 优先档次标志
    ,irevbl_guar_flg varchar2(10) -- 不可撤销担保标志
    ,ex_choice_type_cd varchar2(10) -- 行权选择类型代码
    ,bond_market_type_cd varchar2(10) -- 债券市场类型代码
    ,guar_type_cd varchar2(10) -- 担保类型代码
    ,guartor_name varchar2(750) -- 担保人名称
    ,inpwned_ratio number(18,6) -- 可质押比例
    ,caption_type_cd varchar2(30) -- 资产化类型代码
    ,valuation_way_cd varchar2(10) -- 计价方式代码
    ,loc_gov_cls_cd varchar2(10) -- 地方政府债分类代码
    ,estate_bond_type_name varchar2(150) -- 房地产债券类型名称
    ,data_src_sys_idf varchar2(60) -- 数据来源系统标识
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
grant select on ${icl_schema}.cmm_bond_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bond_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bond_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bond_basic_info is '债券基本信息';
comment on column ${icl_schema}.cmm_bond_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bond_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_bond_basic_info.asset_type_id is '资产类型编号';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_abbr is '债券简称';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_type_cd is '债券类型代码';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_cls_name is '债券分类名称';
comment on column ${icl_schema}.cmm_bond_basic_info.trust_org_id is '托管机构编号';
comment on column ${icl_schema}.cmm_bond_basic_info.mgmt_mode_cd is '管理模式代码';
comment on column ${icl_schema}.cmm_bond_basic_info.issuer_cust_id is '发行人客户编号';
comment on column ${icl_schema}.cmm_bond_basic_info.issuer_cd is '发行人代码';
comment on column ${icl_schema}.cmm_bond_basic_info.issuer_name is '发行人名称';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_main_belong_cty_rg_cd is '发行主体所属国家地区代码';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_rg_cd is '发行地区代码';
comment on column ${icl_schema}.cmm_bond_basic_info.actl_mang_land_nation_cd is '实际经营地国别代码';
comment on column ${icl_schema}.cmm_bond_basic_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_corp is '发行单位';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_price is '发行价格';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_int_rat is '发行利率';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_size is '发行规模';
comment on column ${icl_schema}.cmm_bond_basic_info.fac_val_int_rat is '票面利率';
comment on column ${icl_schema}.cmm_bond_basic_info.fac_val is '票面面值';
comment on column ${icl_schema}.cmm_bond_basic_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_bond_basic_info.base_rat_id is '基准利率编号';
comment on column ${icl_schema}.cmm_bond_basic_info.int_rat_float_point is '利率浮动点数';
comment on column ${icl_schema}.cmm_bond_basic_info.int_rat_float_dir_cd is '利率浮动方向代码';
comment on column ${icl_schema}.cmm_bond_basic_info.int_rat_float_uplmi is '利率浮动上限';
comment on column ${icl_schema}.cmm_bond_basic_info.int_rat_float_lolmi is '利率浮动下限';
comment on column ${icl_schema}.cmm_bond_basic_info.int_accr_base_cd is '计息基准代码';
comment on column ${icl_schema}.cmm_bond_basic_info.int_accr_curr_cd is '计息币种代码';
comment on column ${icl_schema}.cmm_bond_basic_info.int_accr_ped_cd is '计息周期代码';
comment on column ${icl_schema}.cmm_bond_basic_info.pay_int_ped_cd is '付息周期代码';
comment on column ${icl_schema}.cmm_bond_basic_info.src_pay_int_ped_cd is '源付息周期代码';
comment on column ${icl_schema}.cmm_bond_basic_info.comp_int_ped_cd is '复利周期代码';
comment on column ${icl_schema}.cmm_bond_basic_info.reval_ped_cd is '重定价周期代码';
comment on column ${icl_schema}.cmm_bond_basic_info.fir_reval_dt is '首次重定价日期';
comment on column ${icl_schema}.cmm_bond_basic_info.reval_way_cd is '重定价方式代码';
comment on column ${icl_schema}.cmm_bond_basic_info.last_reval_dt is '上次重定价日期';
comment on column ${icl_schema}.cmm_bond_basic_info.next_reval_dt is '下次重定价日期';
comment on column ${icl_schema}.cmm_bond_basic_info.reval_start_dt is '重定价开始日期';
comment on column ${icl_schema}.cmm_bond_basic_info.reval_end_dt is '重定价结束日期';
comment on column ${icl_schema}.cmm_bond_basic_info.reval_int_rat is '重定价利率';
comment on column ${icl_schema}.cmm_bond_basic_info.exp_yld_rat is '到期收益率';
comment on column ${icl_schema}.cmm_bond_basic_info.issue_dt is '发行日期';
comment on column ${icl_schema}.cmm_bond_basic_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_bond_basic_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_bond_basic_info.tenor is '期限';
comment on column ${icl_schema}.cmm_bond_basic_info.list_dt is '上市日期';
comment on column ${icl_schema}.cmm_bond_basic_info.fir_pay_int_dt is '首次付息日期';
comment on column ${icl_schema}.cmm_bond_basic_info.last_pay_int_dt is '上次付息日期';
comment on column ${icl_schema}.cmm_bond_basic_info.next_pay_int_dt is '下次付息日期';
comment on column ${icl_schema}.cmm_bond_basic_info.next_rpp_amt is '下次还本金额';
comment on column ${icl_schema}.cmm_bond_basic_info.next_pay_int_amt is '下次付息金额';
comment on column ${icl_schema}.cmm_bond_basic_info.prod_currt_tot_bal is '产品当期总余额';
comment on column ${icl_schema}.cmm_bond_basic_info.hold_level_currt_bal is '持有档次当期余额';
comment on column ${icl_schema}.cmm_bond_basic_info.stop_circlt_dt is '停止流通日期';
comment on column ${icl_schema}.cmm_bond_basic_info.tranbl_bond_flg is '可转换债券标志';
comment on column ${icl_schema}.cmm_bond_basic_info.discnt_debt_vch_flg is '贴现债券标志';
comment on column ${icl_schema}.cmm_bond_basic_info.acru_int_flg is '应计利息标志';
comment on column ${icl_schema}.cmm_bond_basic_info.subtn_bond_flg is '永续债标志';
comment on column ${icl_schema}.cmm_bond_basic_info.stc_flg is 'STC标志';
comment on column ${icl_schema}.cmm_bond_basic_info.prior_level_flg is '优先档次标志';
comment on column ${icl_schema}.cmm_bond_basic_info.irevbl_guar_flg is '不可撤销担保标志';
comment on column ${icl_schema}.cmm_bond_basic_info.ex_choice_type_cd is '行权选择类型代码';
comment on column ${icl_schema}.cmm_bond_basic_info.bond_market_type_cd is '债券市场类型代码';
comment on column ${icl_schema}.cmm_bond_basic_info.guar_type_cd is '担保类型代码';
comment on column ${icl_schema}.cmm_bond_basic_info.guartor_name is '担保人名称';
comment on column ${icl_schema}.cmm_bond_basic_info.inpwned_ratio is '可质押比例';
comment on column ${icl_schema}.cmm_bond_basic_info.caption_type_cd is '资产化类型代码';
comment on column ${icl_schema}.cmm_bond_basic_info.valuation_way_cd is '计价方式代码';
comment on column ${icl_schema}.cmm_bond_basic_info.loc_gov_cls_cd is '地方政府债分类代码';
comment on column ${icl_schema}.cmm_bond_basic_info.estate_bond_type_name is '房地产债券类型名称';
comment on column ${icl_schema}.cmm_bond_basic_info.data_src_sys_idf is '数据来源系统标识';
comment on column ${icl_schema}.cmm_bond_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bond_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bond_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bond_basic_info.etl_timestamp is 'ETL处理时间戳';
