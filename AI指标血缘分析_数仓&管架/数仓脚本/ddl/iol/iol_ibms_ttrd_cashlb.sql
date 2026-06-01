/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_cashlb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_cashlb
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_cashlb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cashlb(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,currency varchar2(5) -- 币种
    ,country varchar2(3) -- 国家
    ,q_type varchar2(3) -- 利率/净值
    ,i_name varchar2(383) -- 资产名称
    ,p_class varchar2(150) -- 产品分类，默认为资产类型名称，用户可以修改
    ,par_value number(31,4) -- 债券面值
    ,coupon number(30,15) -- 初始利率; 浮动利率为利差
    ,start_date varchar2(15) -- 起息日
    ,mtr_date varchar2(15) -- 到期日
    ,term varchar2(9) -- 如 1y，6m，7d
    ,daycount varchar2(45) -- 计息基准
    ,i_code_bench varchar2(45) -- 浮动利率基准
    ,a_type_bench varchar2(30) -- 根据浮动利率基准确定
    ,m_type_bench varchar2(30) -- 根据浮动利率基准确定
    ,issue_mode number(22,0) -- 1－面值发行；2－贴现发行
    ,coupon_type number(22,0) -- 1－固定利率；2－浮动利率；3－零息票利率
    ,payment_freq varchar2(9) -- 付息周期,如 1y，6m，7d
    ,payment_conv varchar2(30) -- 支付调整
    ,first_regular_start_date varchar2(15) -- 首规则起息日
    ,fixing_date_offset varchar2(9) -- 定息日偏移
    ,fixing_date_conv varchar2(30) -- 定息日调整
    ,reset_freq varchar2(9) -- 重置频率
    ,reset_conv varchar2(30) -- 重置调整
    ,initial_rate number(10,6) -- 首周期定息值
    ,cap_rate number(10,6) -- 利率上限
    ,issuer varchar2(300) -- 发行机构
    ,memo varchar2(3000) -- 备注
    ,fpml varchar2(4000) -- fpml
    ,imp_time varchar2(53) -- 导入时间
    ,chinesespell varchar2(150) -- 中文简写
    ,is_delete number(22,0) -- 是否删除标记 1未删除  -1删除
    ,floor_rate number(10,6) -- 利率下限
    ,update_user varchar2(150) -- 经办人
    ,update_time varchar2(35) -- 经办时间
    ,account_user varchar2(45) -- 复核人
    ,account_time varchar2(30) -- 复核时间
    ,initial_fixing_date varchar2(30) -- 首周期定息日
    ,first_payment_date varchar2(30) -- 首次付息日
    ,party_id number(22,0) -- 发行机构id
    ,rate_multi number(22,0) -- 利率乘数
    ,overdue_rate number(12,6) -- 逾期利率
    ,volume number(22,0) -- 发行量
    ,mtr_mode varchar2(2) -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
    ,ver_id varchar2(45) -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,fstsettype varchar2(30) -- 首期结算方式
    ,endsettype varchar2(30) -- 到期结算方式
    ,fst_set_amount number(31,4) -- 首期结算金额
    ,mtr_set_amount number(31,4) -- 到期结算金额
    ,p_type varchar2(30) -- 产品类型
    ,issue_price number(10,3) -- 发行价格
    ,settled_interest varchar2(4000) -- 已结算利息
    ,issuer_id number(22,0) -- 发行机构id
    ,usable_flag number(22,0) -- 是否已生效：1： 正常 0： 新增
    ,payment_date_offset varchar2(9) -- 
    ,sell_department varchar2(150) -- 资产出让部门
    ,repo_trade_variety varchar2(15) -- 质押式回购交易品种
    ,acct_id number(16,0) -- 
    ,auto_redepo varchar2(2) -- 是否自动转存;1:是，0：否
    ,repo_term varchar2(9) -- 交易品种的期限
    ,stub_period_type varchar2(30) -- shortfinal:末期并入前期,longfinal:末期自成一期
    ,m_i_code varchar2(45) -- 市场产品代码
    ,m_a_type varchar2(30) -- 市场资产类型
    ,m_m_type varchar2(30) -- 市场市场类型
    ,head_coupon number(12,6) -- 总行报价
    ,payment varchar2(2) -- 支付条件
    ,credit_promotion_way varchar2(2) -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
    ,i_id number(16,0) -- 所属机构id
    ,cash_date varchar2(15) -- 兑付日
    ,ishisdata varchar2(2) -- 是否存量数据 1:是 0:否
    ,s_type varchar2(11) -- 
    ,host_market varchar2(30) -- 
    ,autoredepo varchar2(2) -- 
    ,scale number(16,0) -- 
    ,final_stub varchar2(45) -- 
    ,u_m_type varchar2(30) -- 
    ,u_a_type varchar2(30) -- 
    ,u_i_code varchar2(30) -- 
    ,is_occupy_bottom_credit varchar2(2) -- 是否占用底层资产授信 1:是0否
    ,credit_id number(16,0) -- 授信方id
    ,interest_type varchar2(2) -- 付息类型：0前收息，1后收息
    ,term_spd varchar2(30) -- 期限
    ,p_start_date varchar2(15) -- 起息日
    ,p_mtr_date varchar2(15) -- 到期日
    ,calcconv varchar2(45) -- 计息日调整
    ,cashing_date varchar2(15) -- 兑付日(重庆)
    ,cashing_speed varchar2(5) -- 兑付速度(重庆，对应字典cashingspeed)
    ,match_code varchar2(750) -- 
    ,p_i_code varchar2(150) -- 项目代码
    ,special_type varchar2(2) -- 专项类型（对应字典specialtypes）
    ,weighted_coupon number(12,6) -- 加权利率
    ,und_asset_type varchar2(3) -- 底层资产分类（厦门投金）
    ,inv_order_id varchar2(75) -- 投金审批单号
    ,guarantee_way varchar2(3) -- 担保方式
    ,guarantee_infor varchar2(450) -- 担保物情况
    ,actual_mtr_date varchar2(15) -- 到期实际终止日
    ,pre_actual_mtr_date varchar2(15) -- 历史到期实际终止日
    ,total_ai number(31,4) -- 回购利息
    ,p_status varchar2(2) -- 产品状态，1：展期，2：逾期
    ,draw_advance_rate number(12,6) -- 提前支取利率
    ,post_interest_rate number(12,6) -- 部提后利率
    ,is_open_letter number(1,0) -- 是否开立证实书
    ,grace_day number(12,0) -- 宽限天数，默认为0
    ,credit_amount number(31,10) -- 授信额度(元)
    ,extordid varchar2(75) -- 外部成交编号
    ,is_auto_calculate varchar2(2) -- 是否自动计算利率
    ,nominal_rate number(12,6) -- 名义利率
    ,added_rate number(12,6) -- 增值税率
    ,slotting_addrate number(12,6) -- 通道附加税率
    ,slotting_rate number(12,6) -- 通道费率
    ,slotting_daycounter varchar2(45) -- 通道费计息基准
    ,trustee_rate number(12,6) -- 托管费率
    ,trustee_daycounter varchar2(45) -- 托管费计息基准
    ,other_rate number(12,6) -- 其他费率
    ,other_daycounter varchar2(45) -- 其他费用计息基准
    ,nominal_daycounter varchar2(45) -- 名义利率计息基准
    ,credit_weight number(12,6) -- 授信权重(%)
    ,reply_code varchar2(192) -- 批复号
    ,record_rate number(12,6) -- 录入汇率(%)
    ,accounting_type varchar2(2) -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
    ,product_rate varchar2(150) -- 产品评级
    ,rate_institution varchar2(150) -- 评级机构
    ,is_guaranteed varchar2(2) -- 是否保本 1:是 0:否
    ,expect_take_day varchar2(15) -- 预计支取日
    ,bank_group_code varchar2(75) -- 银团代码，银团交易单上对应的金融工具代码为此代码
    ,coupon_prec number(22,0) -- 利率精度
    ,apr_txn varchar2(150) -- 批复编号-华兴
    ,fee_rate number(12,6) -- 费率(%)
    ,handlingchargetotal number(31,4) -- 手续费合计(元)
    ,usufruct_mtr_date varchar2(15) -- 收益权到期日
    ,shibor_coupon number(12,6) -- shibor利率
    ,shibor_i_code varchar2(150) -- shibor利率，仅供显示使用
    ,shibor_a_type varchar2(30) -- shibor利率，仅供显示使用
    ,shibor_m_type varchar2(30) -- shibor利率，仅供显示使用
    ,paymentinfo_type varchar2(3) -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
    ,is_subloan varchar2(2) -- 是否转贷标识
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
grant select on ${iol_schema}.ibms_ttrd_cashlb to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_cashlb is '现金借贷金融工具表';
comment on column ${iol_schema}.ibms_ttrd_cashlb.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_cashlb.country is '国家';
comment on column ${iol_schema}.ibms_ttrd_cashlb.q_type is '利率/净值';
comment on column ${iol_schema}.ibms_ttrd_cashlb.i_name is '资产名称';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_class is '产品分类，默认为资产类型名称，用户可以修改';
comment on column ${iol_schema}.ibms_ttrd_cashlb.par_value is '债券面值';
comment on column ${iol_schema}.ibms_ttrd_cashlb.coupon is '初始利率; 浮动利率为利差';
comment on column ${iol_schema}.ibms_ttrd_cashlb.start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.term is '如 1y，6m，7d';
comment on column ${iol_schema}.ibms_ttrd_cashlb.daycount is '计息基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.i_code_bench is '浮动利率基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.a_type_bench is '根据浮动利率基准确定';
comment on column ${iol_schema}.ibms_ttrd_cashlb.m_type_bench is '根据浮动利率基准确定';
comment on column ${iol_schema}.ibms_ttrd_cashlb.issue_mode is '1－面值发行；2－贴现发行';
comment on column ${iol_schema}.ibms_ttrd_cashlb.coupon_type is '1－固定利率；2－浮动利率；3－零息票利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.payment_freq is '付息周期,如 1y，6m，7d';
comment on column ${iol_schema}.ibms_ttrd_cashlb.payment_conv is '支付调整';
comment on column ${iol_schema}.ibms_ttrd_cashlb.first_regular_start_date is '首规则起息日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fixing_date_offset is '定息日偏移';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fixing_date_conv is '定息日调整';
comment on column ${iol_schema}.ibms_ttrd_cashlb.reset_freq is '重置频率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.reset_conv is '重置调整';
comment on column ${iol_schema}.ibms_ttrd_cashlb.initial_rate is '首周期定息值';
comment on column ${iol_schema}.ibms_ttrd_cashlb.cap_rate is '利率上限';
comment on column ${iol_schema}.ibms_ttrd_cashlb.issuer is '发行机构';
comment on column ${iol_schema}.ibms_ttrd_cashlb.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fpml is 'fpml';
comment on column ${iol_schema}.ibms_ttrd_cashlb.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb.chinesespell is '中文简写';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_delete is '是否删除标记 1未删除  -1删除';
comment on column ${iol_schema}.ibms_ttrd_cashlb.floor_rate is '利率下限';
comment on column ${iol_schema}.ibms_ttrd_cashlb.update_user is '经办人';
comment on column ${iol_schema}.ibms_ttrd_cashlb.update_time is '经办时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb.account_user is '复核人';
comment on column ${iol_schema}.ibms_ttrd_cashlb.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb.initial_fixing_date is '首周期定息日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.party_id is '发行机构id';
comment on column ${iol_schema}.ibms_ttrd_cashlb.rate_multi is '利率乘数';
comment on column ${iol_schema}.ibms_ttrd_cashlb.overdue_rate is '逾期利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.volume is '发行量';
comment on column ${iol_schema}.ibms_ttrd_cashlb.mtr_mode is '到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期';
comment on column ${iol_schema}.ibms_ttrd_cashlb.ver_id is '改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具';
comment on column ${iol_schema}.ibms_ttrd_cashlb.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_cashlb.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fstsettype is '首期结算方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb.endsettype is '到期结算方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fst_set_amount is '首期结算金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb.mtr_set_amount is '到期结算金额';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb.issue_price is '发行价格';
comment on column ${iol_schema}.ibms_ttrd_cashlb.settled_interest is '已结算利息';
comment on column ${iol_schema}.ibms_ttrd_cashlb.issuer_id is '发行机构id';
comment on column ${iol_schema}.ibms_ttrd_cashlb.usable_flag is '是否已生效：1： 正常 0： 新增';
comment on column ${iol_schema}.ibms_ttrd_cashlb.payment_date_offset is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.sell_department is '资产出让部门';
comment on column ${iol_schema}.ibms_ttrd_cashlb.repo_trade_variety is '质押式回购交易品种';
comment on column ${iol_schema}.ibms_ttrd_cashlb.acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.auto_redepo is '是否自动转存;1:是，0：否';
comment on column ${iol_schema}.ibms_ttrd_cashlb.repo_term is '交易品种的期限';
comment on column ${iol_schema}.ibms_ttrd_cashlb.stub_period_type is 'shortfinal:末期并入前期,longfinal:末期自成一期';
comment on column ${iol_schema}.ibms_ttrd_cashlb.m_i_code is '市场产品代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb.m_a_type is '市场资产类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb.m_m_type is '市场市场类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb.head_coupon is '总行报价';
comment on column ${iol_schema}.ibms_ttrd_cashlb.payment is '支付条件';
comment on column ${iol_schema}.ibms_ttrd_cashlb.credit_promotion_way is '1:信用,2:贷款质押,3:债券质押,4:第三方担保';
comment on column ${iol_schema}.ibms_ttrd_cashlb.i_id is '所属机构id';
comment on column ${iol_schema}.ibms_ttrd_cashlb.cash_date is '兑付日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.ishisdata is '是否存量数据 1:是 0:否';
comment on column ${iol_schema}.ibms_ttrd_cashlb.s_type is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.host_market is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.autoredepo is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.scale is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.final_stub is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.u_m_type is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.u_a_type is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.u_i_code is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_occupy_bottom_credit is '是否占用底层资产授信 1:是0否';
comment on column ${iol_schema}.ibms_ttrd_cashlb.credit_id is '授信方id';
comment on column ${iol_schema}.ibms_ttrd_cashlb.interest_type is '付息类型：0前收息，1后收息';
comment on column ${iol_schema}.ibms_ttrd_cashlb.term_spd is '期限';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_start_date is '起息日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_mtr_date is '到期日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.calcconv is '计息日调整';
comment on column ${iol_schema}.ibms_ttrd_cashlb.cashing_date is '兑付日(重庆)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.cashing_speed is '兑付速度(重庆，对应字典cashingspeed)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.match_code is '';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_i_code is '项目代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb.special_type is '专项类型（对应字典specialtypes）';
comment on column ${iol_schema}.ibms_ttrd_cashlb.weighted_coupon is '加权利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.und_asset_type is '底层资产分类（厦门投金）';
comment on column ${iol_schema}.ibms_ttrd_cashlb.inv_order_id is '投金审批单号';
comment on column ${iol_schema}.ibms_ttrd_cashlb.guarantee_way is '担保方式';
comment on column ${iol_schema}.ibms_ttrd_cashlb.guarantee_infor is '担保物情况';
comment on column ${iol_schema}.ibms_ttrd_cashlb.actual_mtr_date is '到期实际终止日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.pre_actual_mtr_date is '历史到期实际终止日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.total_ai is '回购利息';
comment on column ${iol_schema}.ibms_ttrd_cashlb.p_status is '产品状态，1：展期，2：逾期';
comment on column ${iol_schema}.ibms_ttrd_cashlb.draw_advance_rate is '提前支取利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.post_interest_rate is '部提后利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_open_letter is '是否开立证实书';
comment on column ${iol_schema}.ibms_ttrd_cashlb.grace_day is '宽限天数，默认为0';
comment on column ${iol_schema}.ibms_ttrd_cashlb.credit_amount is '授信额度(元)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.extordid is '外部成交编号';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_auto_calculate is '是否自动计算利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.nominal_rate is '名义利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.added_rate is '增值税率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.slotting_addrate is '通道附加税率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.slotting_rate is '通道费率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.slotting_daycounter is '通道费计息基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.trustee_rate is '托管费率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.trustee_daycounter is '托管费计息基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.other_rate is '其他费率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.other_daycounter is '其他费用计息基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.nominal_daycounter is '名义利率计息基准';
comment on column ${iol_schema}.ibms_ttrd_cashlb.credit_weight is '授信权重(%)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.reply_code is '批复号';
comment on column ${iol_schema}.ibms_ttrd_cashlb.record_rate is '录入汇率(%)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.accounting_type is '利息结算方式默认0为费用不计入成本，1为计入成本的情况';
comment on column ${iol_schema}.ibms_ttrd_cashlb.product_rate is '产品评级';
comment on column ${iol_schema}.ibms_ttrd_cashlb.rate_institution is '评级机构';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_guaranteed is '是否保本 1:是 0:否';
comment on column ${iol_schema}.ibms_ttrd_cashlb.expect_take_day is '预计支取日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.bank_group_code is '银团代码，银团交易单上对应的金融工具代码为此代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb.coupon_prec is '利率精度';
comment on column ${iol_schema}.ibms_ttrd_cashlb.apr_txn is '批复编号-华兴';
comment on column ${iol_schema}.ibms_ttrd_cashlb.fee_rate is '费率(%)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.handlingchargetotal is '手续费合计(元)';
comment on column ${iol_schema}.ibms_ttrd_cashlb.usufruct_mtr_date is '收益权到期日';
comment on column ${iol_schema}.ibms_ttrd_cashlb.shibor_coupon is 'shibor利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb.shibor_i_code is 'shibor利率，仅供显示使用';
comment on column ${iol_schema}.ibms_ttrd_cashlb.shibor_a_type is 'shibor利率，仅供显示使用';
comment on column ${iol_schema}.ibms_ttrd_cashlb.shibor_m_type is 'shibor利率，仅供显示使用';
comment on column ${iol_schema}.ibms_ttrd_cashlb.paymentinfo_type is '未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金';
comment on column ${iol_schema}.ibms_ttrd_cashlb.is_subloan is '是否转贷标识';
comment on column ${iol_schema}.ibms_ttrd_cashlb.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_cashlb.etl_timestamp is 'ETL处理时间戳';
