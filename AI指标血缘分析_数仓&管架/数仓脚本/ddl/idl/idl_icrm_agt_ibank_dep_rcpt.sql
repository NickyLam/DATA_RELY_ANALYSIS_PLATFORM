/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_ibank_dep_rcpt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_ibank_dep_rcpt
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_ibank_dep_rcpt purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_ibank_dep_rcpt(
    etl_dt date -- 数据日期
    ,vouch_id varchar2(60) -- 凭证编号
    ,lp_id varchar2(60) -- 法人编号
    ,dep_rcpt_cd varchar2(30) -- 存单代码
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,market_type_cd varchar2(30) -- 市场类型代码
    ,curr_cd varchar2(10) -- 币种代码
    ,quot_way_cd varchar2(10) -- 报价方式代码
    ,dep_rcpt_name varchar2(100) -- 存单名称
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_type_name varchar2(100) -- 产品类型名称
    ,int_rat_pct_spd_bp number(18,8) -- 利率%、利差BP
    ,issue_qtty number(30,2) -- 发行量(亿元)
    ,issue_price number(30,2) -- 发行价格
    ,lowt_issue_price number(30,2) -- 最低发行价格
    ,higt_issue_price number(30,2) -- 最高发行价格
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor_val number(10) -- 期限值(天)
    ,fir_int_rat_cfm_dt date -- 首次利率确定日期
    ,pay_int_freq_cd varchar2(10) -- 付息频率代码
    ,issue_way_cd varchar2(10) -- 发行方式代码
    ,coupon_type_cd varchar2(10) -- 息票类型代码
    ,base_rat_id varchar2(60) -- 基准利率编号
    ,base_asset_type_id varchar2(60) -- 基准资产类型编号
    ,base_market_type_id varchar2(60) -- 基准市场类型编号
    ,stl_status_cd varchar2(10) -- 结算状态代码
    ,pay_dt date -- 缴款日期
    ,cash_dt date -- 兑付日期
    ,issue_dt date -- 发行日期
    ,annual_int_rat number(18,8) -- 年化利率
    ,int_accr_base_cd varchar2(250) -- 计息基准代码
    ,fir_pay_int_dt date -- 首次付息日期
    ,invt_bid_way_cd varchar2(10) -- 招标方式代码
    ,lowt_yld_rat number(18,6) -- 最低收益率
    ,higt_yld_rat number(18,6) -- 最高收益率
    ,actl_issue_qtty number(30,2) -- 实际发行量(亿元)
    ,issuer_name varchar2(100) -- 发行人名称
    ,range varchar2(250) -- 范围
    ,rating_org varchar2(500) -- 评级机构
    ,rating varchar2(20) -- 评级
    ,fac_val number(30,2) -- 票面
    ,start_issue_dt date -- 开始发行日期
    ,end_issue_dt date -- 结束发行日期
    ,max_subscr_qtty number(30,2) -- 最大认购量
    ,min_subscr_qtty number(30,2) -- 最小认购量
    ,sig_max_subscr_qtty number(30,2) -- 单笔最大认购量
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
grant select on ${idl_schema}.icrm_agt_ibank_dep_rcpt to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_ibank_dep_rcpt is '同业存单表';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.vouch_id is '凭证编号';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.dep_rcpt_cd is '存单代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.asset_type_cd is '资产类型代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.market_type_cd is '市场类型代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.quot_way_cd is '报价方式代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.dep_rcpt_name is '存单名称';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.prod_type_name is '产品类型名称';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.int_rat_pct_spd_bp is '利率%、利差BP';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.issue_qtty is '发行量(亿元)';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.issue_price is '发行价格';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.lowt_issue_price is '最低发行价格';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.higt_issue_price is '最高发行价格';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.tenor_val is '期限值(天)';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.fir_int_rat_cfm_dt is '首次利率确定日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.pay_int_freq_cd is '付息频率代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.issue_way_cd is '发行方式代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.coupon_type_cd is '息票类型代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.base_rat_id is '基准利率编号';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.base_asset_type_id is '基准资产类型编号';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.base_market_type_id is '基准市场类型编号';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.stl_status_cd is '结算状态代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.pay_dt is '缴款日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.cash_dt is '兑付日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.issue_dt is '发行日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.annual_int_rat is '年化利率';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.fir_pay_int_dt is '首次付息日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.invt_bid_way_cd is '招标方式代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.lowt_yld_rat is '最低收益率';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.higt_yld_rat is '最高收益率';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.actl_issue_qtty is '实际发行量(亿元)';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.issuer_name is '发行人名称';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.range is '范围';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.rating_org is '评级机构';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.rating is '评级';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.fac_val is '票面';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.start_issue_dt is '开始发行日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.end_issue_dt is '结束发行日期';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.max_subscr_qtty is '最大认购量';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.min_subscr_qtty is '最小认购量';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.sig_max_subscr_qtty is '单笔最大认购量';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_ibank_dep_rcpt.etl_timestamp is '数据处理时间';
