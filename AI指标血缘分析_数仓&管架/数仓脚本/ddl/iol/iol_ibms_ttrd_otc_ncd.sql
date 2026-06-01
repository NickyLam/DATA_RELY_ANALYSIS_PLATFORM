/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_ncd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_ncd
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_ncd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_ncd(
    i_code varchar2(45) -- 存单代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,currency varchar2(5) -- 币种
    ,q_type varchar2(3) -- 报价方式
    ,b_name varchar2(150) -- 存单名称
    ,p_type varchar2(45) -- 产品分类
    ,p_class varchar2(90) -- 产品分类名称
    ,b_coupon number(12,6) -- 利率%、利差bp
    ,ncdcount number(31,4) -- 发行量
    ,b_issue_price number(12,4) -- 发行价格
    ,min_issue_price number(12,4) -- 最低发行价格
    ,max_issue_price number(12,4) -- 最高发行价格
    ,b_start_date varchar2(15) -- 起息日
    ,b_mtr_date varchar2(15) -- 到期日
    ,b_term varchar2(9) -- 期限
    ,first_date varchar2(15) -- 首次利率确定日
    ,b_pay_freq varchar2(9) -- 付息频率
    ,b_issue_mode varchar2(2) -- 发行方式
    ,b_coupon_type varchar2(2) -- 息票类型
    ,i_code_bench varchar2(45) -- 利率基准
    ,a_type_bench varchar2(30) -- 利率基准
    ,m_type_bench varchar2(30) -- 利率基准
    ,settle_status number(22) -- 结算状态：0-未结算， 1-部分已结算， 2—已结算
    ,set_date varchar2(15) -- 缴款日
    ,honour_date varchar2(15) -- 兑付日
    ,b_issue_date varchar2(15) -- 发行日
    ,annual_rate number(12,6) -- 年化利率
    ,b_daycount varchar2(180) -- 计息基准
    ,b_fst_pay_date varchar2(15) -- 首次付息日
    ,tender_type number(22) -- 招标方式 ，0为单一价格招标，1为数量招标
    ,min_rate number(12,6) -- 最低收益率，最低标位参考收益率
    ,max_rate number(12,6) -- 最高收益率，最高标位参考收益率
    ,b_actual_issue_amount number(31,4) -- 实际发行量(亿元)
    ,intordid varchar2(45) -- 内部交易号
    ,issuer varchar2(383) -- 发行人
    ,issuerange varchar2(150) -- 范围
    ,gradeinst varchar2(383) -- 评级机构
    ,grade varchar2(15) -- 评级
    ,parvalue number(12,6) -- 票面
    ,issue_start_date varchar2(15) -- 开始发行日期
    ,issue_mtr_date varchar2(15) -- 结束发行日期
    ,max_bid_amount number(31,4) -- 最大认购量
    ,min_bid_amount number(31,4) -- 最小认购量
    ,singe_max_bid_amount number(31,4) -- 单笔最大认购量
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
grant select on ${iol_schema}.ibms_ttrd_otc_ncd to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_ncd to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_ncd to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_ncd to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_ncd is '同业存单表';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.i_code is '存单代码';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.q_type is '报价方式';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_name is '存单名称';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.p_type is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.p_class is '产品分类名称';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_coupon is '利率%、利差bp';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.ncdcount is '发行量';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_issue_price is '发行价格';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.min_issue_price is '最低发行价格';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.max_issue_price is '最高发行价格';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_term is '期限';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.first_date is '首次利率确定日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_pay_freq is '付息频率';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_issue_mode is '发行方式';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_coupon_type is '息票类型';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.i_code_bench is '利率基准';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.a_type_bench is '利率基准';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.m_type_bench is '利率基准';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.settle_status is '结算状态：0-未结算， 1-部分已结算， 2—已结算';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.set_date is '缴款日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.honour_date is '兑付日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_issue_date is '发行日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.annual_rate is '年化利率';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_daycount is '计息基准';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_fst_pay_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.tender_type is '招标方式 ，0为单一价格招标，1为数量招标';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.min_rate is '最低收益率，最低标位参考收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.max_rate is '最高收益率，最高标位参考收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.b_actual_issue_amount is '实际发行量(亿元)';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.intordid is '内部交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.issuer is '发行人';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.issuerange is '范围';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.gradeinst is '评级机构';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.grade is '评级';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.parvalue is '票面';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.issue_start_date is '开始发行日期';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.issue_mtr_date is '结束发行日期';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.max_bid_amount is '最大认购量';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.min_bid_amount is '最小认购量';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.singe_max_bid_amount is '单笔最大认购量';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_otc_ncd.etl_timestamp is 'ETL处理时间戳';
