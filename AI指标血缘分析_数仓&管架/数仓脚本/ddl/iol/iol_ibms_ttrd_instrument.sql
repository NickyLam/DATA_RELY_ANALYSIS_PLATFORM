/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_instrument
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_instrument
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_instrument purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_instrument(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,currency varchar2(5) -- 币种
    ,i_name varchar2(383) -- 金融工具名称
    ,p_type varchar2(30) -- 产品类型，用户不可修改，仅代码层面应用
    ,p_class varchar2(150) -- 产品分类，默认为资产类型名称，用户可以修改
    ,p_ls varchar2(2) -- 区分是long还是short（l：long；s：short）
    ,mtr_date varchar2(15) -- 到期日
    ,term varchar2(9) -- 如 1y，6m，7d
    ,u_i_code varchar2(75) -- 标的金融工具
    ,u_a_type varchar2(30) -- 标的资产类型
    ,u_m_type varchar2(30) -- 标的市场类型
    ,coupon_type number(22) -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
    ,issue_mode number(22) -- 发行模式：1－面值发行；2－贴现发行
    ,payment_freq varchar2(9) -- 付息周期,如 1y，6m，7d
    ,cash_times number(22) -- 付息次数（一年付息几次）
    ,seniority varchar2(30) -- 清偿等级（仅用于债券）
    ,party_id number(22) -- 发行机构id
    ,chinesespell varchar2(150) -- 中文简写
    ,update_user varchar2(150) -- 经办人
    ,update_time varchar2(35) -- 经办时间
    ,account_user varchar2(45) -- 复核人
    ,account_time varchar2(30) -- 复核时间
    ,par_value number(31,8) -- 发行面额
    ,fwd_irc varchar2(450) -- 远期利率曲线
    ,dis_irc varchar2(450) -- 折现利率曲线
    ,coupon number(33,8) -- 票面利率或利差
    ,previous_version_mtr_date varchar2(15) -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
    ,grp_id varchar2(45) -- 组合号
    ,term_day number(22) -- 期限天数
    ,remain_term_day number(22) -- 剩余期限
    ,issue_volume number(31,2) -- 发行数量
    ,state varchar2(2) -- 状态：0:正常状态  1：指令刷新中
    ,i_id number(22) -- 机构号
    ,start_date varchar2(15) -- 起息日
    ,weight_limit number(8,6) -- 风险权重
    ,t_path varchar2(300) -- 客户分类名称
    ,p_class_act varchar2(90) -- 会计产品分类
    ,issuer_id number(22) -- 发行人id
    ,warrantor_id number(22) -- 担保人id
    ,issuer_t_path varchar2(300) -- 发行人客户分类名称
    ,b_actual_mtr_date varchar2(15) -- 债券实际到期日
    ,core_acct_code varchar2(45) -- 定期帐号核心账户
    ,q_currency varchar2(5) -- 计价货币币种
    ,is_spv_asset varchar2(2) -- 是否spv资产0：否 1：是
    ,real_i_code varchar2(75) -- 实际金融工具代码
    ,principal number(31,4) -- 本金
    ,first_payment_date varchar2(30) -- 首次付息日
    ,daycount varchar2(45) -- 计息基准
    ,match_code varchar2(750) -- 
    ,credit_classfy varchar2(30) -- 授信分类
    ,is_using_credit varchar2(3) -- 是否占用授信，0-不占用，1-占用(仅非标使用)
    ,credit_weight number(12,6) -- 授信权重(%)
    ,apr_txn varchar2(150) -- 批复编号
    ,reply_code varchar2(192) -- 额度合同编号
    ,acting_code varchar2(45) -- 记账科目号
    ,prod_code varchar2(24) -- 产品编码
    ,tax_code varchar2(30) -- 免税代码
    ,charge_item varchar2(150) -- 收费项
    ,fee_number varchar2(75) -- 费用编号
    ,update_time2 varchar2(29) -- 更新时间
    ,is_renewal varchar2(2) -- 续期标识
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
grant select on ${iol_schema}.ibms_ttrd_instrument to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_instrument to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_instrument is '金融工具表';
comment on column ${iol_schema}.ibms_ttrd_instrument.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_instrument.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_instrument.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_instrument.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_instrument.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_instrument.p_type is '产品类型，用户不可修改，仅代码层面应用';
comment on column ${iol_schema}.ibms_ttrd_instrument.p_class is '产品分类，默认为资产类型名称，用户可以修改';
comment on column ${iol_schema}.ibms_ttrd_instrument.p_ls is '区分是long还是short（l：long；s：short）';
comment on column ${iol_schema}.ibms_ttrd_instrument.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_instrument.term is '如 1y，6m，7d';
comment on column ${iol_schema}.ibms_ttrd_instrument.u_i_code is '标的金融工具';
comment on column ${iol_schema}.ibms_ttrd_instrument.u_a_type is '标的资产类型';
comment on column ${iol_schema}.ibms_ttrd_instrument.u_m_type is '标的市场类型';
comment on column ${iol_schema}.ibms_ttrd_instrument.coupon_type is '息票类型：1－固定利率；2－浮动利率；3－零息票利率';
comment on column ${iol_schema}.ibms_ttrd_instrument.issue_mode is '发行模式：1－面值发行；2－贴现发行';
comment on column ${iol_schema}.ibms_ttrd_instrument.payment_freq is '付息周期,如 1y，6m，7d';
comment on column ${iol_schema}.ibms_ttrd_instrument.cash_times is '付息次数（一年付息几次）';
comment on column ${iol_schema}.ibms_ttrd_instrument.seniority is '清偿等级（仅用于债券）';
comment on column ${iol_schema}.ibms_ttrd_instrument.party_id is '发行机构id';
comment on column ${iol_schema}.ibms_ttrd_instrument.chinesespell is '中文简写';
comment on column ${iol_schema}.ibms_ttrd_instrument.update_user is '经办人';
comment on column ${iol_schema}.ibms_ttrd_instrument.update_time is '经办时间';
comment on column ${iol_schema}.ibms_ttrd_instrument.account_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_instrument.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_instrument.par_value is '发行面额';
comment on column ${iol_schema}.ibms_ttrd_instrument.fwd_irc is '远期利率曲线';
comment on column ${iol_schema}.ibms_ttrd_instrument.dis_irc is '折现利率曲线';
comment on column ${iol_schema}.ibms_ttrd_instrument.coupon is '票面利率或利差';
comment on column ${iol_schema}.ibms_ttrd_instrument.previous_version_mtr_date is '上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.';
comment on column ${iol_schema}.ibms_ttrd_instrument.grp_id is '组合号';
comment on column ${iol_schema}.ibms_ttrd_instrument.term_day is '期限天数';
comment on column ${iol_schema}.ibms_ttrd_instrument.remain_term_day is '剩余期限';
comment on column ${iol_schema}.ibms_ttrd_instrument.issue_volume is '发行数量';
comment on column ${iol_schema}.ibms_ttrd_instrument.state is '状态：0:正常状态  1：指令刷新中';
comment on column ${iol_schema}.ibms_ttrd_instrument.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_instrument.start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_instrument.weight_limit is '风险权重';
comment on column ${iol_schema}.ibms_ttrd_instrument.t_path is '客户分类名称';
comment on column ${iol_schema}.ibms_ttrd_instrument.p_class_act is '会计产品分类';
comment on column ${iol_schema}.ibms_ttrd_instrument.issuer_id is '发行人id';
comment on column ${iol_schema}.ibms_ttrd_instrument.warrantor_id is '担保人id';
comment on column ${iol_schema}.ibms_ttrd_instrument.issuer_t_path is '发行人客户分类名称';
comment on column ${iol_schema}.ibms_ttrd_instrument.b_actual_mtr_date is '债券实际到期日';
comment on column ${iol_schema}.ibms_ttrd_instrument.core_acct_code is '定期帐号核心账户';
comment on column ${iol_schema}.ibms_ttrd_instrument.q_currency is '计价货币币种';
comment on column ${iol_schema}.ibms_ttrd_instrument.is_spv_asset is '是否spv资产0：否 1：是';
comment on column ${iol_schema}.ibms_ttrd_instrument.real_i_code is '实际金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_instrument.principal is '本金';
comment on column ${iol_schema}.ibms_ttrd_instrument.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_instrument.daycount is '计息基准';
comment on column ${iol_schema}.ibms_ttrd_instrument.match_code is '';
comment on column ${iol_schema}.ibms_ttrd_instrument.credit_classfy is '授信分类';
comment on column ${iol_schema}.ibms_ttrd_instrument.is_using_credit is '是否占用授信，0-不占用，1-占用(仅非标使用)';
comment on column ${iol_schema}.ibms_ttrd_instrument.credit_weight is '授信权重(%)';
comment on column ${iol_schema}.ibms_ttrd_instrument.apr_txn is '批复编号';
comment on column ${iol_schema}.ibms_ttrd_instrument.reply_code is '额度合同编号';
comment on column ${iol_schema}.ibms_ttrd_instrument.acting_code is '记账科目号';
comment on column ${iol_schema}.ibms_ttrd_instrument.prod_code is '产品编码';
comment on column ${iol_schema}.ibms_ttrd_instrument.tax_code is '免税代码';
comment on column ${iol_schema}.ibms_ttrd_instrument.charge_item is '收费项';
comment on column ${iol_schema}.ibms_ttrd_instrument.fee_number is '费用编号';
comment on column ${iol_schema}.ibms_ttrd_instrument.update_time2 is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_instrument.is_renewal is '续期标识';
comment on column ${iol_schema}.ibms_ttrd_instrument.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_instrument.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_instrument.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_instrument.etl_timestamp is 'ETL处理时间戳';
