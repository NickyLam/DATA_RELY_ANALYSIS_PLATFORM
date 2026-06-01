/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security(
    security_code varchar2(24) -- 债券代码
    ,security_name varchar2(192) -- 债券名称
    ,security_type varchar2(2) -- 债券类别
    ,issuer varchar2(96) -- 发行人
    ,guarantee varchar2(96) -- 担保人
    ,ccy varchar2(5) -- 本金币种
    ,int_ccy varchar2(5) -- 利息币种
    ,issue_date varchar2(12) -- 发行日
    ,start_coupon_date varchar2(12) -- 起息日
    ,maturity_date varchar2(12) -- 到期日
    ,lot_size number(10,0) -- 债券发行最小单位
    ,day_count varchar2(2) -- 计息基准
    ,rate_type varchar2(2) -- 利率方式
    ,fixed_rate number(24,12) -- 票面利率
    ,floating_rate varchar2(23) -- 基准利率
    ,floating_rate_ind number(2,0) -- 浮动方向
    ,floating_spread number(13,10) -- 基本利差
    ,fixing_freq varchar2(3) -- 重置频率
    ,ffixing_date varchar2(12) -- 首次利率重置日
    ,coupon_freq varchar2(3) -- 计息频率
    ,fcoupon_date varchar2(12) -- 首次付息日
    ,payment_freq varchar2(3) -- 付息频率
    ,compound_freq varchar2(3) -- 复利频率
    ,option_type varchar2(2) -- 选择权类别
    ,back_amt number(17,2) -- 每期还本金额
    ,number_issued number(27,12) -- 发行金额
    ,aution_rate number(17,12) -- 标售利率
    ,aution_price number(17,12) -- 发行价格
    ,first_trade_date varchar2(12) -- 上市交易日
    ,market_type varchar2(2) -- 市场类别
    ,repo_ratio number(7,4) -- 质押比
    ,security_short_name varchar2(192) -- 债券简称
    ,convertable varchar2(2) -- 是否是可转换债券
    ,convert_security_code varchar2(24) -- 转换债券码
    ,discount_rate varchar2(2) -- 是否贴现债
    ,cap number(13,10) -- 浮动利率上限
    ,floor number(13,10) -- 浮动利率下限
    ,fixing_rate_methoh varchar2(2) -- 利率重置方法
    ,note varchar2(384) -- 债券备注
    ,floating_rate_scale number(1,0) -- 利率小数位数
    ,stop_trade_date varchar2(12) -- 停止流通日
    ,collateral_id varchar2(2) -- 担保品
    ,floater_factor_op varchar2(2) -- 浮动利率重算因子运算子
    ,floater_factor number(12,8) -- 浮动利率重算因子
    ,fixing_rules varchar2(2) -- 是否有利率重置公式
    ,org_term number -- 原始合约上的期限
    ,org_term_mult varchar2(2) -- 原始合约上的期限单位
    ,isjx varchar2(2) -- 是否计应收利息
    ,modify_date date -- 修改日期
    ,compound varchar2(2) -- 是否复利
    ,security_type_new varchar2(5) -- 债券类别
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_tbs_v_security to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security is '债券基本资料视图';
comment on column ${iol_schema}.ctms_tbs_v_security.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security.security_name is '债券名称';
comment on column ${iol_schema}.ctms_tbs_v_security.security_type is '债券类别';
comment on column ${iol_schema}.ctms_tbs_v_security.issuer is '发行人';
comment on column ${iol_schema}.ctms_tbs_v_security.guarantee is '担保人';
comment on column ${iol_schema}.ctms_tbs_v_security.ccy is '本金币种';
comment on column ${iol_schema}.ctms_tbs_v_security.int_ccy is '利息币种';
comment on column ${iol_schema}.ctms_tbs_v_security.issue_date is '发行日';
comment on column ${iol_schema}.ctms_tbs_v_security.start_coupon_date is '起息日';
comment on column ${iol_schema}.ctms_tbs_v_security.maturity_date is '到期日';
comment on column ${iol_schema}.ctms_tbs_v_security.lot_size is '债券发行最小单位';
comment on column ${iol_schema}.ctms_tbs_v_security.day_count is '计息基准';
comment on column ${iol_schema}.ctms_tbs_v_security.rate_type is '利率方式';
comment on column ${iol_schema}.ctms_tbs_v_security.fixed_rate is '票面利率';
comment on column ${iol_schema}.ctms_tbs_v_security.floating_rate is '基准利率';
comment on column ${iol_schema}.ctms_tbs_v_security.floating_rate_ind is '浮动方向';
comment on column ${iol_schema}.ctms_tbs_v_security.floating_spread is '基本利差';
comment on column ${iol_schema}.ctms_tbs_v_security.fixing_freq is '重置频率';
comment on column ${iol_schema}.ctms_tbs_v_security.ffixing_date is '首次利率重置日';
comment on column ${iol_schema}.ctms_tbs_v_security.coupon_freq is '计息频率';
comment on column ${iol_schema}.ctms_tbs_v_security.fcoupon_date is '首次付息日';
comment on column ${iol_schema}.ctms_tbs_v_security.payment_freq is '付息频率';
comment on column ${iol_schema}.ctms_tbs_v_security.compound_freq is '复利频率';
comment on column ${iol_schema}.ctms_tbs_v_security.option_type is '选择权类别';
comment on column ${iol_schema}.ctms_tbs_v_security.back_amt is '每期还本金额';
comment on column ${iol_schema}.ctms_tbs_v_security.number_issued is '发行金额';
comment on column ${iol_schema}.ctms_tbs_v_security.aution_rate is '标售利率';
comment on column ${iol_schema}.ctms_tbs_v_security.aution_price is '发行价格';
comment on column ${iol_schema}.ctms_tbs_v_security.first_trade_date is '上市交易日';
comment on column ${iol_schema}.ctms_tbs_v_security.market_type is '市场类别';
comment on column ${iol_schema}.ctms_tbs_v_security.repo_ratio is '质押比';
comment on column ${iol_schema}.ctms_tbs_v_security.security_short_name is '债券简称';
comment on column ${iol_schema}.ctms_tbs_v_security.convertable is '是否是可转换债券';
comment on column ${iol_schema}.ctms_tbs_v_security.convert_security_code is '转换债券码';
comment on column ${iol_schema}.ctms_tbs_v_security.discount_rate is '是否贴现债';
comment on column ${iol_schema}.ctms_tbs_v_security.cap is '浮动利率上限';
comment on column ${iol_schema}.ctms_tbs_v_security.floor is '浮动利率下限';
comment on column ${iol_schema}.ctms_tbs_v_security.fixing_rate_methoh is '利率重置方法';
comment on column ${iol_schema}.ctms_tbs_v_security.note is '债券备注';
comment on column ${iol_schema}.ctms_tbs_v_security.floating_rate_scale is '利率小数位数';
comment on column ${iol_schema}.ctms_tbs_v_security.stop_trade_date is '停止流通日';
comment on column ${iol_schema}.ctms_tbs_v_security.collateral_id is '担保品';
comment on column ${iol_schema}.ctms_tbs_v_security.floater_factor_op is '浮动利率重算因子运算子';
comment on column ${iol_schema}.ctms_tbs_v_security.floater_factor is '浮动利率重算因子';
comment on column ${iol_schema}.ctms_tbs_v_security.fixing_rules is '是否有利率重置公式';
comment on column ${iol_schema}.ctms_tbs_v_security.org_term is '原始合约上的期限';
comment on column ${iol_schema}.ctms_tbs_v_security.org_term_mult is '原始合约上的期限单位';
comment on column ${iol_schema}.ctms_tbs_v_security.isjx is '是否计应收利息';
comment on column ${iol_schema}.ctms_tbs_v_security.modify_date is '修改日期';
comment on column ${iol_schema}.ctms_tbs_v_security.compound is '是否复利';
comment on column ${iol_schema}.ctms_tbs_v_security.security_type_new is '债券类别';
comment on column ${iol_schema}.ctms_tbs_v_security.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security.etl_timestamp is 'ETL处理时间戳';
