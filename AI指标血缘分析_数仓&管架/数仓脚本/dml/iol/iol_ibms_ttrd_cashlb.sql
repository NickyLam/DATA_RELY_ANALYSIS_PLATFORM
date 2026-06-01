/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_cashlb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ibms_ttrd_cashlb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_cashlb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cashlb_op purge;
drop table ${iol_schema}.ibms_ttrd_cashlb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cashlb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cashlb where 0=1;

create table ${iol_schema}.ibms_ttrd_cashlb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_cashlb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cashlb_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 利率/净值
            ,i_name -- 资产名称
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,par_value -- 债券面值
            ,coupon -- 初始利率; 浮动利率为利差
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,daycount -- 计息基准
            ,i_code_bench -- 浮动利率基准
            ,a_type_bench -- 根据浮动利率基准确定
            ,m_type_bench -- 根据浮动利率基准确定
            ,issue_mode -- 1－面值发行；2－贴现发行
            ,coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,payment_conv -- 支付调整
            ,first_regular_start_date -- 首规则起息日
            ,fixing_date_offset -- 定息日偏移
            ,fixing_date_conv -- 定息日调整
            ,reset_freq -- 重置频率
            ,reset_conv -- 重置调整
            ,initial_rate -- 首周期定息值
            ,cap_rate -- 利率上限
            ,issuer -- 发行机构
            ,memo -- 备注
            ,fpml -- fpml
            ,imp_time -- 导入时间
            ,chinesespell -- 中文简写
            ,is_delete -- 是否删除标记 1未删除  -1删除
            ,floor_rate -- 利率下限
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,initial_fixing_date -- 首周期定息日
            ,first_payment_date -- 首次付息日
            ,party_id -- 发行机构id
            ,rate_multi -- 利率乘数
            ,overdue_rate -- 逾期利率
            ,volume -- 发行量
            ,mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
            ,ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,fstsettype -- 首期结算方式
            ,endsettype -- 到期结算方式
            ,fst_set_amount -- 首期结算金额
            ,mtr_set_amount -- 到期结算金额
            ,p_type -- 产品类型
            ,issue_price -- 发行价格
            ,settled_interest -- 已结算利息
            ,issuer_id -- 发行机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,payment_date_offset -- 
            ,sell_department -- 资产出让部门
            ,repo_trade_variety -- 质押式回购交易品种
            ,acct_id -- 
            ,auto_redepo -- 是否自动转存;1:是，0：否
            ,repo_term -- 交易品种的期限
            ,stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
            ,m_i_code -- 市场产品代码
            ,m_a_type -- 市场资产类型
            ,m_m_type -- 市场市场类型
            ,head_coupon -- 总行报价
            ,payment -- 支付条件
            ,credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
            ,i_id -- 所属机构id
            ,cash_date -- 兑付日
            ,ishisdata -- 是否存量数据 1:是 0:否
            ,s_type -- 
            ,host_market -- 
            ,autoredepo -- 
            ,scale -- 
            ,final_stub -- 
            ,u_m_type -- 
            ,u_a_type -- 
            ,u_i_code -- 
            ,is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
            ,credit_id -- 授信方ID
            ,interest_type -- 付息类型：0前收息，1后收息
            ,term_spd -- 期限
            ,p_start_date -- 起息日
            ,p_mtr_date -- 到期日
            ,calcconv -- 计息日调整
            ,cashing_date -- 兑付日(重庆)
            ,cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
            ,match_code -- 
            ,p_i_code -- 项目代码
            ,special_type -- 专项类型（对应字典specialTypes）
            ,weighted_coupon -- 加权利率
            ,und_asset_type -- 底层资产分类（厦门投金）
            ,inv_order_id -- 投金审批单号
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,actual_mtr_date -- 到期实际终止日
            ,pre_actual_mtr_date -- 历史到期实际终止日
            ,total_ai -- 回购利息
            ,p_status -- 产品状态，1：展期，2：逾期
            ,draw_advance_rate -- 提前支取利率
            ,post_interest_rate -- 部提后利率
            ,is_open_letter -- 是否开立证实书
            ,grace_day -- 宽限天数，默认为0
            ,credit_amount -- 授信额度(元)
            ,extordid -- 外部成交编号
            ,is_auto_calculate -- 是否自动计算利率
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,credit_weight -- 授信权重(%)
            ,reply_code -- 批复号
            ,record_rate -- 录入汇率(%)
            ,accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,is_guaranteed -- 是否保本 1:是 0:否
            ,expect_take_day -- 预计支取日
            ,bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
            ,coupon_prec -- 利率精度
            ,apr_txn -- 批复编号-华兴
            ,fee_rate -- 费率(%)
            ,handlingchargetotal -- 手续费合计(元)
            ,usufruct_mtr_date -- 收益权到期日
            ,shibor_coupon -- shibor利率
            ,shibor_i_code -- SHIBOR利率，仅供显示使用
            ,shibor_a_type -- SHIBOR利率，仅供显示使用
            ,shibor_m_type -- SHIBOR利率，仅供显示使用
            ,paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
            ,is_subloan -- 是否转贷标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cashlb_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 利率/净值
            ,i_name -- 资产名称
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,par_value -- 债券面值
            ,coupon -- 初始利率; 浮动利率为利差
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,daycount -- 计息基准
            ,i_code_bench -- 浮动利率基准
            ,a_type_bench -- 根据浮动利率基准确定
            ,m_type_bench -- 根据浮动利率基准确定
            ,issue_mode -- 1－面值发行；2－贴现发行
            ,coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,payment_conv -- 支付调整
            ,first_regular_start_date -- 首规则起息日
            ,fixing_date_offset -- 定息日偏移
            ,fixing_date_conv -- 定息日调整
            ,reset_freq -- 重置频率
            ,reset_conv -- 重置调整
            ,initial_rate -- 首周期定息值
            ,cap_rate -- 利率上限
            ,issuer -- 发行机构
            ,memo -- 备注
            ,fpml -- fpml
            ,imp_time -- 导入时间
            ,chinesespell -- 中文简写
            ,is_delete -- 是否删除标记 1未删除  -1删除
            ,floor_rate -- 利率下限
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,initial_fixing_date -- 首周期定息日
            ,first_payment_date -- 首次付息日
            ,party_id -- 发行机构id
            ,rate_multi -- 利率乘数
            ,overdue_rate -- 逾期利率
            ,volume -- 发行量
            ,mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
            ,ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,fstsettype -- 首期结算方式
            ,endsettype -- 到期结算方式
            ,fst_set_amount -- 首期结算金额
            ,mtr_set_amount -- 到期结算金额
            ,p_type -- 产品类型
            ,issue_price -- 发行价格
            ,settled_interest -- 已结算利息
            ,issuer_id -- 发行机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,payment_date_offset -- 
            ,sell_department -- 资产出让部门
            ,repo_trade_variety -- 质押式回购交易品种
            ,acct_id -- 
            ,auto_redepo -- 是否自动转存;1:是，0：否
            ,repo_term -- 交易品种的期限
            ,stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
            ,m_i_code -- 市场产品代码
            ,m_a_type -- 市场资产类型
            ,m_m_type -- 市场市场类型
            ,head_coupon -- 总行报价
            ,payment -- 支付条件
            ,credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
            ,i_id -- 所属机构id
            ,cash_date -- 兑付日
            ,ishisdata -- 是否存量数据 1:是 0:否
            ,s_type -- 
            ,host_market -- 
            ,autoredepo -- 
            ,scale -- 
            ,final_stub -- 
            ,u_m_type -- 
            ,u_a_type -- 
            ,u_i_code -- 
            ,is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
            ,credit_id -- 授信方ID
            ,interest_type -- 付息类型：0前收息，1后收息
            ,term_spd -- 期限
            ,p_start_date -- 起息日
            ,p_mtr_date -- 到期日
            ,calcconv -- 计息日调整
            ,cashing_date -- 兑付日(重庆)
            ,cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
            ,match_code -- 
            ,p_i_code -- 项目代码
            ,special_type -- 专项类型（对应字典specialTypes）
            ,weighted_coupon -- 加权利率
            ,und_asset_type -- 底层资产分类（厦门投金）
            ,inv_order_id -- 投金审批单号
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,actual_mtr_date -- 到期实际终止日
            ,pre_actual_mtr_date -- 历史到期实际终止日
            ,total_ai -- 回购利息
            ,p_status -- 产品状态，1：展期，2：逾期
            ,draw_advance_rate -- 提前支取利率
            ,post_interest_rate -- 部提后利率
            ,is_open_letter -- 是否开立证实书
            ,grace_day -- 宽限天数，默认为0
            ,credit_amount -- 授信额度(元)
            ,extordid -- 外部成交编号
            ,is_auto_calculate -- 是否自动计算利率
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,credit_weight -- 授信权重(%)
            ,reply_code -- 批复号
            ,record_rate -- 录入汇率(%)
            ,accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,is_guaranteed -- 是否保本 1:是 0:否
            ,expect_take_day -- 预计支取日
            ,bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
            ,coupon_prec -- 利率精度
            ,apr_txn -- 批复编号-华兴
            ,fee_rate -- 费率(%)
            ,handlingchargetotal -- 手续费合计(元)
            ,usufruct_mtr_date -- 收益权到期日
            ,shibor_coupon -- shibor利率
            ,shibor_i_code -- SHIBOR利率，仅供显示使用
            ,shibor_a_type -- SHIBOR利率，仅供显示使用
            ,shibor_m_type -- SHIBOR利率，仅供显示使用
            ,paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
            ,is_subloan -- 是否转贷标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.q_type, o.q_type) as q_type -- 利率/净值
    ,nvl(n.i_name, o.i_name) as i_name -- 资产名称
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类，默认为资产类型名称，用户可以修改
    ,nvl(n.par_value, o.par_value) as par_value -- 债券面值
    ,nvl(n.coupon, o.coupon) as coupon -- 初始利率; 浮动利率为利差
    ,nvl(n.start_date, o.start_date) as start_date -- 起息日
    ,nvl(n.mtr_date, o.mtr_date) as mtr_date -- 到期日
    ,nvl(n.term, o.term) as term -- 如 1Y，6M，7D
    ,nvl(n.daycount, o.daycount) as daycount -- 计息基准
    ,nvl(n.i_code_bench, o.i_code_bench) as i_code_bench -- 浮动利率基准
    ,nvl(n.a_type_bench, o.a_type_bench) as a_type_bench -- 根据浮动利率基准确定
    ,nvl(n.m_type_bench, o.m_type_bench) as m_type_bench -- 根据浮动利率基准确定
    ,nvl(n.issue_mode, o.issue_mode) as issue_mode -- 1－面值发行；2－贴现发行
    ,nvl(n.coupon_type, o.coupon_type) as coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
    ,nvl(n.payment_freq, o.payment_freq) as payment_freq -- 付息周期,如 1Y，6M，7D
    ,nvl(n.payment_conv, o.payment_conv) as payment_conv -- 支付调整
    ,nvl(n.first_regular_start_date, o.first_regular_start_date) as first_regular_start_date -- 首规则起息日
    ,nvl(n.fixing_date_offset, o.fixing_date_offset) as fixing_date_offset -- 定息日偏移
    ,nvl(n.fixing_date_conv, o.fixing_date_conv) as fixing_date_conv -- 定息日调整
    ,nvl(n.reset_freq, o.reset_freq) as reset_freq -- 重置频率
    ,nvl(n.reset_conv, o.reset_conv) as reset_conv -- 重置调整
    ,nvl(n.initial_rate, o.initial_rate) as initial_rate -- 首周期定息值
    ,nvl(n.cap_rate, o.cap_rate) as cap_rate -- 利率上限
    ,nvl(n.issuer, o.issuer) as issuer -- 发行机构
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.fpml, o.fpml) as fpml -- fpml
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 导入时间
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 中文简写
    ,nvl(n.is_delete, o.is_delete) as is_delete -- 是否删除标记 1未删除  -1删除
    ,nvl(n.floor_rate, o.floor_rate) as floor_rate -- 利率下限
    ,nvl(n.update_user, o.update_user) as update_user -- 经办人
    ,nvl(n.update_time, o.update_time) as update_time -- 经办时间
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.initial_fixing_date, o.initial_fixing_date) as initial_fixing_date -- 首周期定息日
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.party_id, o.party_id) as party_id -- 发行机构id
    ,nvl(n.rate_multi, o.rate_multi) as rate_multi -- 利率乘数
    ,nvl(n.overdue_rate, o.overdue_rate) as overdue_rate -- 逾期利率
    ,nvl(n.volume, o.volume) as volume -- 发行量
    ,nvl(n.mtr_mode, o.mtr_mode) as mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
    ,nvl(n.ver_id, o.ver_id) as ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 开始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.fstsettype, o.fstsettype) as fstsettype -- 首期结算方式
    ,nvl(n.endsettype, o.endsettype) as endsettype -- 到期结算方式
    ,nvl(n.fst_set_amount, o.fst_set_amount) as fst_set_amount -- 首期结算金额
    ,nvl(n.mtr_set_amount, o.mtr_set_amount) as mtr_set_amount -- 到期结算金额
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.settled_interest, o.settled_interest) as settled_interest -- 已结算利息
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行机构id
    ,nvl(n.usable_flag, o.usable_flag) as usable_flag -- 是否已生效：1： 正常 0： 新增
    ,nvl(n.payment_date_offset, o.payment_date_offset) as payment_date_offset -- 
    ,nvl(n.sell_department, o.sell_department) as sell_department -- 资产出让部门
    ,nvl(n.repo_trade_variety, o.repo_trade_variety) as repo_trade_variety -- 质押式回购交易品种
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 
    ,nvl(n.auto_redepo, o.auto_redepo) as auto_redepo -- 是否自动转存;1:是，0：否
    ,nvl(n.repo_term, o.repo_term) as repo_term -- 交易品种的期限
    ,nvl(n.stub_period_type, o.stub_period_type) as stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
    ,nvl(n.m_i_code, o.m_i_code) as m_i_code -- 市场产品代码
    ,nvl(n.m_a_type, o.m_a_type) as m_a_type -- 市场资产类型
    ,nvl(n.m_m_type, o.m_m_type) as m_m_type -- 市场市场类型
    ,nvl(n.head_coupon, o.head_coupon) as head_coupon -- 总行报价
    ,nvl(n.payment, o.payment) as payment -- 支付条件
    ,nvl(n.credit_promotion_way, o.credit_promotion_way) as credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
    ,nvl(n.i_id, o.i_id) as i_id -- 所属机构id
    ,nvl(n.cash_date, o.cash_date) as cash_date -- 兑付日
    ,nvl(n.ishisdata, o.ishisdata) as ishisdata -- 是否存量数据 1:是 0:否
    ,nvl(n.s_type, o.s_type) as s_type -- 
    ,nvl(n.host_market, o.host_market) as host_market -- 
    ,nvl(n.autoredepo, o.autoredepo) as autoredepo -- 
    ,nvl(n.scale, o.scale) as scale -- 
    ,nvl(n.final_stub, o.final_stub) as final_stub -- 
    ,nvl(n.u_m_type, o.u_m_type) as u_m_type -- 
    ,nvl(n.u_a_type, o.u_a_type) as u_a_type -- 
    ,nvl(n.u_i_code, o.u_i_code) as u_i_code -- 
    ,nvl(n.is_occupy_bottom_credit, o.is_occupy_bottom_credit) as is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
    ,nvl(n.credit_id, o.credit_id) as credit_id -- 授信方ID
    ,nvl(n.interest_type, o.interest_type) as interest_type -- 付息类型：0前收息，1后收息
    ,nvl(n.term_spd, o.term_spd) as term_spd -- 期限
    ,nvl(n.p_start_date, o.p_start_date) as p_start_date -- 起息日
    ,nvl(n.p_mtr_date, o.p_mtr_date) as p_mtr_date -- 到期日
    ,nvl(n.calcconv, o.calcconv) as calcconv -- 计息日调整
    ,nvl(n.cashing_date, o.cashing_date) as cashing_date -- 兑付日(重庆)
    ,nvl(n.cashing_speed, o.cashing_speed) as cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
    ,nvl(n.match_code, o.match_code) as match_code -- 
    ,nvl(n.p_i_code, o.p_i_code) as p_i_code -- 项目代码
    ,nvl(n.special_type, o.special_type) as special_type -- 专项类型（对应字典specialTypes）
    ,nvl(n.weighted_coupon, o.weighted_coupon) as weighted_coupon -- 加权利率
    ,nvl(n.und_asset_type, o.und_asset_type) as und_asset_type -- 底层资产分类（厦门投金）
    ,nvl(n.inv_order_id, o.inv_order_id) as inv_order_id -- 投金审批单号
    ,nvl(n.guarantee_way, o.guarantee_way) as guarantee_way -- 担保方式
    ,nvl(n.guarantee_infor, o.guarantee_infor) as guarantee_infor -- 担保物情况
    ,nvl(n.actual_mtr_date, o.actual_mtr_date) as actual_mtr_date -- 到期实际终止日
    ,nvl(n.pre_actual_mtr_date, o.pre_actual_mtr_date) as pre_actual_mtr_date -- 历史到期实际终止日
    ,nvl(n.total_ai, o.total_ai) as total_ai -- 回购利息
    ,nvl(n.p_status, o.p_status) as p_status -- 产品状态，1：展期，2：逾期
    ,nvl(n.draw_advance_rate, o.draw_advance_rate) as draw_advance_rate -- 提前支取利率
    ,nvl(n.post_interest_rate, o.post_interest_rate) as post_interest_rate -- 部提后利率
    ,nvl(n.is_open_letter, o.is_open_letter) as is_open_letter -- 是否开立证实书
    ,nvl(n.grace_day, o.grace_day) as grace_day -- 宽限天数，默认为0
    ,nvl(n.credit_amount, o.credit_amount) as credit_amount -- 授信额度(元)
    ,nvl(n.extordid, o.extordid) as extordid -- 外部成交编号
    ,nvl(n.is_auto_calculate, o.is_auto_calculate) as is_auto_calculate -- 是否自动计算利率
    ,nvl(n.nominal_rate, o.nominal_rate) as nominal_rate -- 名义利率
    ,nvl(n.added_rate, o.added_rate) as added_rate -- 增值税率
    ,nvl(n.slotting_addrate, o.slotting_addrate) as slotting_addrate -- 通道附加税率
    ,nvl(n.slotting_rate, o.slotting_rate) as slotting_rate -- 通道费率
    ,nvl(n.slotting_daycounter, o.slotting_daycounter) as slotting_daycounter -- 通道费计息基准
    ,nvl(n.trustee_rate, o.trustee_rate) as trustee_rate -- 托管费率
    ,nvl(n.trustee_daycounter, o.trustee_daycounter) as trustee_daycounter -- 托管费计息基准
    ,nvl(n.other_rate, o.other_rate) as other_rate -- 其他费率
    ,nvl(n.other_daycounter, o.other_daycounter) as other_daycounter -- 其他费用计息基准
    ,nvl(n.nominal_daycounter, o.nominal_daycounter) as nominal_daycounter -- 名义利率计息基准
    ,nvl(n.credit_weight, o.credit_weight) as credit_weight -- 授信权重(%)
    ,nvl(n.reply_code, o.reply_code) as reply_code -- 批复号
    ,nvl(n.record_rate, o.record_rate) as record_rate -- 录入汇率(%)
    ,nvl(n.accounting_type, o.accounting_type) as accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
    ,nvl(n.product_rate, o.product_rate) as product_rate -- 产品评级
    ,nvl(n.rate_institution, o.rate_institution) as rate_institution -- 评级机构
    ,nvl(n.is_guaranteed, o.is_guaranteed) as is_guaranteed -- 是否保本 1:是 0:否
    ,nvl(n.expect_take_day, o.expect_take_day) as expect_take_day -- 预计支取日
    ,nvl(n.bank_group_code, o.bank_group_code) as bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
    ,nvl(n.coupon_prec, o.coupon_prec) as coupon_prec -- 利率精度
    ,nvl(n.apr_txn, o.apr_txn) as apr_txn -- 批复编号-华兴
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 费率(%)
    ,nvl(n.handlingchargetotal, o.handlingchargetotal) as handlingchargetotal -- 手续费合计(元)
    ,nvl(n.usufruct_mtr_date, o.usufruct_mtr_date) as usufruct_mtr_date -- 收益权到期日
    ,nvl(n.shibor_coupon, o.shibor_coupon) as shibor_coupon -- shibor利率
    ,nvl(n.shibor_i_code, o.shibor_i_code) as shibor_i_code -- SHIBOR利率，仅供显示使用
    ,nvl(n.shibor_a_type, o.shibor_a_type) as shibor_a_type -- SHIBOR利率，仅供显示使用
    ,nvl(n.shibor_m_type, o.shibor_m_type) as shibor_m_type -- SHIBOR利率，仅供显示使用
    ,nvl(n.paymentinfo_type, o.paymentinfo_type) as paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
    ,nvl(n.is_subloan, o.is_subloan) as is_subloan -- 是否转贷标识
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_cashlb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_cashlb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.currency <> n.currency
        or o.country <> n.country
        or o.q_type <> n.q_type
        or o.i_name <> n.i_name
        or o.p_class <> n.p_class
        or o.par_value <> n.par_value
        or o.coupon <> n.coupon
        or o.start_date <> n.start_date
        or o.mtr_date <> n.mtr_date
        or o.term <> n.term
        or o.daycount <> n.daycount
        or o.i_code_bench <> n.i_code_bench
        or o.a_type_bench <> n.a_type_bench
        or o.m_type_bench <> n.m_type_bench
        or o.issue_mode <> n.issue_mode
        or o.coupon_type <> n.coupon_type
        or o.payment_freq <> n.payment_freq
        or o.payment_conv <> n.payment_conv
        or o.first_regular_start_date <> n.first_regular_start_date
        or o.fixing_date_offset <> n.fixing_date_offset
        or o.fixing_date_conv <> n.fixing_date_conv
        or o.reset_freq <> n.reset_freq
        or o.reset_conv <> n.reset_conv
        or o.initial_rate <> n.initial_rate
        or o.cap_rate <> n.cap_rate
        or o.issuer <> n.issuer
        or o.memo <> n.memo
        or o.fpml <> n.fpml
        or o.imp_time <> n.imp_time
        or o.chinesespell <> n.chinesespell
        or o.is_delete <> n.is_delete
        or o.floor_rate <> n.floor_rate
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.account_user <> n.account_user
        or o.account_time <> n.account_time
        or o.initial_fixing_date <> n.initial_fixing_date
        or o.first_payment_date <> n.first_payment_date
        or o.party_id <> n.party_id
        or o.rate_multi <> n.rate_multi
        or o.overdue_rate <> n.overdue_rate
        or o.volume <> n.volume
        or o.mtr_mode <> n.mtr_mode
        or o.ver_id <> n.ver_id
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.fstsettype <> n.fstsettype
        or o.endsettype <> n.endsettype
        or o.fst_set_amount <> n.fst_set_amount
        or o.mtr_set_amount <> n.mtr_set_amount
        or o.p_type <> n.p_type
        or o.issue_price <> n.issue_price
        or o.settled_interest <> n.settled_interest
        or o.issuer_id <> n.issuer_id
        or o.usable_flag <> n.usable_flag
        or o.payment_date_offset <> n.payment_date_offset
        or o.sell_department <> n.sell_department
        or o.repo_trade_variety <> n.repo_trade_variety
        or o.acct_id <> n.acct_id
        or o.auto_redepo <> n.auto_redepo
        or o.repo_term <> n.repo_term
        or o.stub_period_type <> n.stub_period_type
        or o.m_i_code <> n.m_i_code
        or o.m_a_type <> n.m_a_type
        or o.m_m_type <> n.m_m_type
        or o.head_coupon <> n.head_coupon
        or o.payment <> n.payment
        or o.credit_promotion_way <> n.credit_promotion_way
        or o.i_id <> n.i_id
        or o.cash_date <> n.cash_date
        or o.ishisdata <> n.ishisdata
        or o.s_type <> n.s_type
        or o.host_market <> n.host_market
        or o.autoredepo <> n.autoredepo
        or o.scale <> n.scale
        or o.final_stub <> n.final_stub
        or o.u_m_type <> n.u_m_type
        or o.u_a_type <> n.u_a_type
        or o.u_i_code <> n.u_i_code
        or o.is_occupy_bottom_credit <> n.is_occupy_bottom_credit
        or o.credit_id <> n.credit_id
        or o.interest_type <> n.interest_type
        or o.term_spd <> n.term_spd
        or o.p_start_date <> n.p_start_date
        or o.p_mtr_date <> n.p_mtr_date
        or o.calcconv <> n.calcconv
        or o.cashing_date <> n.cashing_date
        or o.cashing_speed <> n.cashing_speed
        or o.match_code <> n.match_code
        or o.p_i_code <> n.p_i_code
        or o.special_type <> n.special_type
        or o.weighted_coupon <> n.weighted_coupon
        or o.und_asset_type <> n.und_asset_type
        or o.inv_order_id <> n.inv_order_id
        or o.guarantee_way <> n.guarantee_way
        or o.guarantee_infor <> n.guarantee_infor
        or o.actual_mtr_date <> n.actual_mtr_date
        or o.pre_actual_mtr_date <> n.pre_actual_mtr_date
        or o.total_ai <> n.total_ai
        or o.p_status <> n.p_status
        or o.draw_advance_rate <> n.draw_advance_rate
        or o.post_interest_rate <> n.post_interest_rate
        or o.is_open_letter <> n.is_open_letter
        or o.grace_day <> n.grace_day
        or o.credit_amount <> n.credit_amount
        or o.extordid <> n.extordid
        or o.is_auto_calculate <> n.is_auto_calculate
        or o.nominal_rate <> n.nominal_rate
        or o.added_rate <> n.added_rate
        or o.slotting_addrate <> n.slotting_addrate
        or o.slotting_rate <> n.slotting_rate
        or o.slotting_daycounter <> n.slotting_daycounter
        or o.trustee_rate <> n.trustee_rate
        or o.trustee_daycounter <> n.trustee_daycounter
        or o.other_rate <> n.other_rate
        or o.other_daycounter <> n.other_daycounter
        or o.nominal_daycounter <> n.nominal_daycounter
        or o.credit_weight <> n.credit_weight
        or o.reply_code <> n.reply_code
        or o.record_rate <> n.record_rate
        or o.accounting_type <> n.accounting_type
        or o.product_rate <> n.product_rate
        or o.rate_institution <> n.rate_institution
        or o.is_guaranteed <> n.is_guaranteed
        or o.expect_take_day <> n.expect_take_day
        or o.bank_group_code <> n.bank_group_code
        or o.coupon_prec <> n.coupon_prec
        or o.apr_txn <> n.apr_txn
        or o.fee_rate <> n.fee_rate
        or o.handlingchargetotal <> n.handlingchargetotal
        or o.usufruct_mtr_date <> n.usufruct_mtr_date
        or o.shibor_coupon <> n.shibor_coupon
        or o.shibor_i_code <> n.shibor_i_code
        or o.shibor_a_type <> n.shibor_a_type
        or o.shibor_m_type <> n.shibor_m_type
        or o.paymentinfo_type <> n.paymentinfo_type
        or o.is_subloan <> n.is_subloan
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_cashlb_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 利率/净值
            ,i_name -- 资产名称
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,par_value -- 债券面值
            ,coupon -- 初始利率; 浮动利率为利差
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,daycount -- 计息基准
            ,i_code_bench -- 浮动利率基准
            ,a_type_bench -- 根据浮动利率基准确定
            ,m_type_bench -- 根据浮动利率基准确定
            ,issue_mode -- 1－面值发行；2－贴现发行
            ,coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,payment_conv -- 支付调整
            ,first_regular_start_date -- 首规则起息日
            ,fixing_date_offset -- 定息日偏移
            ,fixing_date_conv -- 定息日调整
            ,reset_freq -- 重置频率
            ,reset_conv -- 重置调整
            ,initial_rate -- 首周期定息值
            ,cap_rate -- 利率上限
            ,issuer -- 发行机构
            ,memo -- 备注
            ,fpml -- fpml
            ,imp_time -- 导入时间
            ,chinesespell -- 中文简写
            ,is_delete -- 是否删除标记 1未删除  -1删除
            ,floor_rate -- 利率下限
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,initial_fixing_date -- 首周期定息日
            ,first_payment_date -- 首次付息日
            ,party_id -- 发行机构id
            ,rate_multi -- 利率乘数
            ,overdue_rate -- 逾期利率
            ,volume -- 发行量
            ,mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
            ,ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,fstsettype -- 首期结算方式
            ,endsettype -- 到期结算方式
            ,fst_set_amount -- 首期结算金额
            ,mtr_set_amount -- 到期结算金额
            ,p_type -- 产品类型
            ,issue_price -- 发行价格
            ,settled_interest -- 已结算利息
            ,issuer_id -- 发行机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,payment_date_offset -- 
            ,sell_department -- 资产出让部门
            ,repo_trade_variety -- 质押式回购交易品种
            ,acct_id -- 
            ,auto_redepo -- 是否自动转存;1:是，0：否
            ,repo_term -- 交易品种的期限
            ,stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
            ,m_i_code -- 市场产品代码
            ,m_a_type -- 市场资产类型
            ,m_m_type -- 市场市场类型
            ,head_coupon -- 总行报价
            ,payment -- 支付条件
            ,credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
            ,i_id -- 所属机构id
            ,cash_date -- 兑付日
            ,ishisdata -- 是否存量数据 1:是 0:否
            ,s_type -- 
            ,host_market -- 
            ,autoredepo -- 
            ,scale -- 
            ,final_stub -- 
            ,u_m_type -- 
            ,u_a_type -- 
            ,u_i_code -- 
            ,is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
            ,credit_id -- 授信方ID
            ,interest_type -- 付息类型：0前收息，1后收息
            ,term_spd -- 期限
            ,p_start_date -- 起息日
            ,p_mtr_date -- 到期日
            ,calcconv -- 计息日调整
            ,cashing_date -- 兑付日(重庆)
            ,cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
            ,match_code -- 
            ,p_i_code -- 项目代码
            ,special_type -- 专项类型（对应字典specialTypes）
            ,weighted_coupon -- 加权利率
            ,und_asset_type -- 底层资产分类（厦门投金）
            ,inv_order_id -- 投金审批单号
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,actual_mtr_date -- 到期实际终止日
            ,pre_actual_mtr_date -- 历史到期实际终止日
            ,total_ai -- 回购利息
            ,p_status -- 产品状态，1：展期，2：逾期
            ,draw_advance_rate -- 提前支取利率
            ,post_interest_rate -- 部提后利率
            ,is_open_letter -- 是否开立证实书
            ,grace_day -- 宽限天数，默认为0
            ,credit_amount -- 授信额度(元)
            ,extordid -- 外部成交编号
            ,is_auto_calculate -- 是否自动计算利率
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,credit_weight -- 授信权重(%)
            ,reply_code -- 批复号
            ,record_rate -- 录入汇率(%)
            ,accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,is_guaranteed -- 是否保本 1:是 0:否
            ,expect_take_day -- 预计支取日
            ,bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
            ,coupon_prec -- 利率精度
            ,apr_txn -- 批复编号-华兴
            ,fee_rate -- 费率(%)
            ,handlingchargetotal -- 手续费合计(元)
            ,usufruct_mtr_date -- 收益权到期日
            ,shibor_coupon -- shibor利率
            ,shibor_i_code -- SHIBOR利率，仅供显示使用
            ,shibor_a_type -- SHIBOR利率，仅供显示使用
            ,shibor_m_type -- SHIBOR利率，仅供显示使用
            ,paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
            ,is_subloan -- 是否转贷标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_cashlb_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,country -- 国家
            ,q_type -- 利率/净值
            ,i_name -- 资产名称
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,par_value -- 债券面值
            ,coupon -- 初始利率; 浮动利率为利差
            ,start_date -- 起息日
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,daycount -- 计息基准
            ,i_code_bench -- 浮动利率基准
            ,a_type_bench -- 根据浮动利率基准确定
            ,m_type_bench -- 根据浮动利率基准确定
            ,issue_mode -- 1－面值发行；2－贴现发行
            ,coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,payment_conv -- 支付调整
            ,first_regular_start_date -- 首规则起息日
            ,fixing_date_offset -- 定息日偏移
            ,fixing_date_conv -- 定息日调整
            ,reset_freq -- 重置频率
            ,reset_conv -- 重置调整
            ,initial_rate -- 首周期定息值
            ,cap_rate -- 利率上限
            ,issuer -- 发行机构
            ,memo -- 备注
            ,fpml -- fpml
            ,imp_time -- 导入时间
            ,chinesespell -- 中文简写
            ,is_delete -- 是否删除标记 1未删除  -1删除
            ,floor_rate -- 利率下限
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,initial_fixing_date -- 首周期定息日
            ,first_payment_date -- 首次付息日
            ,party_id -- 发行机构id
            ,rate_multi -- 利率乘数
            ,overdue_rate -- 逾期利率
            ,volume -- 发行量
            ,mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
            ,ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
            ,beg_date -- 开始日期
            ,end_date -- 结束日期
            ,fstsettype -- 首期结算方式
            ,endsettype -- 到期结算方式
            ,fst_set_amount -- 首期结算金额
            ,mtr_set_amount -- 到期结算金额
            ,p_type -- 产品类型
            ,issue_price -- 发行价格
            ,settled_interest -- 已结算利息
            ,issuer_id -- 发行机构id
            ,usable_flag -- 是否已生效：1： 正常 0： 新增
            ,payment_date_offset -- 
            ,sell_department -- 资产出让部门
            ,repo_trade_variety -- 质押式回购交易品种
            ,acct_id -- 
            ,auto_redepo -- 是否自动转存;1:是，0：否
            ,repo_term -- 交易品种的期限
            ,stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
            ,m_i_code -- 市场产品代码
            ,m_a_type -- 市场资产类型
            ,m_m_type -- 市场市场类型
            ,head_coupon -- 总行报价
            ,payment -- 支付条件
            ,credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
            ,i_id -- 所属机构id
            ,cash_date -- 兑付日
            ,ishisdata -- 是否存量数据 1:是 0:否
            ,s_type -- 
            ,host_market -- 
            ,autoredepo -- 
            ,scale -- 
            ,final_stub -- 
            ,u_m_type -- 
            ,u_a_type -- 
            ,u_i_code -- 
            ,is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
            ,credit_id -- 授信方ID
            ,interest_type -- 付息类型：0前收息，1后收息
            ,term_spd -- 期限
            ,p_start_date -- 起息日
            ,p_mtr_date -- 到期日
            ,calcconv -- 计息日调整
            ,cashing_date -- 兑付日(重庆)
            ,cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
            ,match_code -- 
            ,p_i_code -- 项目代码
            ,special_type -- 专项类型（对应字典specialTypes）
            ,weighted_coupon -- 加权利率
            ,und_asset_type -- 底层资产分类（厦门投金）
            ,inv_order_id -- 投金审批单号
            ,guarantee_way -- 担保方式
            ,guarantee_infor -- 担保物情况
            ,actual_mtr_date -- 到期实际终止日
            ,pre_actual_mtr_date -- 历史到期实际终止日
            ,total_ai -- 回购利息
            ,p_status -- 产品状态，1：展期，2：逾期
            ,draw_advance_rate -- 提前支取利率
            ,post_interest_rate -- 部提后利率
            ,is_open_letter -- 是否开立证实书
            ,grace_day -- 宽限天数，默认为0
            ,credit_amount -- 授信额度(元)
            ,extordid -- 外部成交编号
            ,is_auto_calculate -- 是否自动计算利率
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,credit_weight -- 授信权重(%)
            ,reply_code -- 批复号
            ,record_rate -- 录入汇率(%)
            ,accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
            ,product_rate -- 产品评级
            ,rate_institution -- 评级机构
            ,is_guaranteed -- 是否保本 1:是 0:否
            ,expect_take_day -- 预计支取日
            ,bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
            ,coupon_prec -- 利率精度
            ,apr_txn -- 批复编号-华兴
            ,fee_rate -- 费率(%)
            ,handlingchargetotal -- 手续费合计(元)
            ,usufruct_mtr_date -- 收益权到期日
            ,shibor_coupon -- shibor利率
            ,shibor_i_code -- SHIBOR利率，仅供显示使用
            ,shibor_a_type -- SHIBOR利率，仅供显示使用
            ,shibor_m_type -- SHIBOR利率，仅供显示使用
            ,paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
            ,is_subloan -- 是否转贷标识
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.currency -- 币种
    ,o.country -- 国家
    ,o.q_type -- 利率/净值
    ,o.i_name -- 资产名称
    ,o.p_class -- 产品分类，默认为资产类型名称，用户可以修改
    ,o.par_value -- 债券面值
    ,o.coupon -- 初始利率; 浮动利率为利差
    ,o.start_date -- 起息日
    ,o.mtr_date -- 到期日
    ,o.term -- 如 1Y，6M，7D
    ,o.daycount -- 计息基准
    ,o.i_code_bench -- 浮动利率基准
    ,o.a_type_bench -- 根据浮动利率基准确定
    ,o.m_type_bench -- 根据浮动利率基准确定
    ,o.issue_mode -- 1－面值发行；2－贴现发行
    ,o.coupon_type -- 1－固定利率；2－浮动利率；3－零息票利率
    ,o.payment_freq -- 付息周期,如 1Y，6M，7D
    ,o.payment_conv -- 支付调整
    ,o.first_regular_start_date -- 首规则起息日
    ,o.fixing_date_offset -- 定息日偏移
    ,o.fixing_date_conv -- 定息日调整
    ,o.reset_freq -- 重置频率
    ,o.reset_conv -- 重置调整
    ,o.initial_rate -- 首周期定息值
    ,o.cap_rate -- 利率上限
    ,o.issuer -- 发行机构
    ,o.memo -- 备注
    ,o.fpml -- fpml
    ,o.imp_time -- 导入时间
    ,o.chinesespell -- 中文简写
    ,o.is_delete -- 是否删除标记 1未删除  -1删除
    ,o.floor_rate -- 利率下限
    ,o.update_user -- 经办人
    ,o.update_time -- 经办时间
    ,o.account_user -- 复核人
    ,o.account_time -- 复核时间
    ,o.initial_fixing_date -- 首周期定息日
    ,o.first_payment_date -- 首次付息日
    ,o.party_id -- 发行机构id
    ,o.rate_multi -- 利率乘数
    ,o.overdue_rate -- 逾期利率
    ,o.volume -- 发行量
    ,o.mtr_mode -- 到期处理：0：未到期或未处理,1:已经自动转存,2：已经逾期
    ,o.ver_id -- 改金融工具，并且保留历史金融工具信息0--表示最新的金融工具，其它可填交易内部交易号等--为历史金融工具
    ,o.beg_date -- 开始日期
    ,o.end_date -- 结束日期
    ,o.fstsettype -- 首期结算方式
    ,o.endsettype -- 到期结算方式
    ,o.fst_set_amount -- 首期结算金额
    ,o.mtr_set_amount -- 到期结算金额
    ,o.p_type -- 产品类型
    ,o.issue_price -- 发行价格
    ,o.settled_interest -- 已结算利息
    ,o.issuer_id -- 发行机构id
    ,o.usable_flag -- 是否已生效：1： 正常 0： 新增
    ,o.payment_date_offset -- 
    ,o.sell_department -- 资产出让部门
    ,o.repo_trade_variety -- 质押式回购交易品种
    ,o.acct_id -- 
    ,o.auto_redepo -- 是否自动转存;1:是，0：否
    ,o.repo_term -- 交易品种的期限
    ,o.stub_period_type -- shortFinal:末期并入前期,longFinal:末期自成一期
    ,o.m_i_code -- 市场产品代码
    ,o.m_a_type -- 市场资产类型
    ,o.m_m_type -- 市场市场类型
    ,o.head_coupon -- 总行报价
    ,o.payment -- 支付条件
    ,o.credit_promotion_way -- 1:信用,2:贷款质押,3:债券质押,4:第三方担保
    ,o.i_id -- 所属机构id
    ,o.cash_date -- 兑付日
    ,o.ishisdata -- 是否存量数据 1:是 0:否
    ,o.s_type -- 
    ,o.host_market -- 
    ,o.autoredepo -- 
    ,o.scale -- 
    ,o.final_stub -- 
    ,o.u_m_type -- 
    ,o.u_a_type -- 
    ,o.u_i_code -- 
    ,o.is_occupy_bottom_credit -- 是否占用底层资产授信 1:是0否
    ,o.credit_id -- 授信方ID
    ,o.interest_type -- 付息类型：0前收息，1后收息
    ,o.term_spd -- 期限
    ,o.p_start_date -- 起息日
    ,o.p_mtr_date -- 到期日
    ,o.calcconv -- 计息日调整
    ,o.cashing_date -- 兑付日(重庆)
    ,o.cashing_speed -- 兑付速度(重庆，对应字典CashingSpeed)
    ,o.match_code -- 
    ,o.p_i_code -- 项目代码
    ,o.special_type -- 专项类型（对应字典specialTypes）
    ,o.weighted_coupon -- 加权利率
    ,o.und_asset_type -- 底层资产分类（厦门投金）
    ,o.inv_order_id -- 投金审批单号
    ,o.guarantee_way -- 担保方式
    ,o.guarantee_infor -- 担保物情况
    ,o.actual_mtr_date -- 到期实际终止日
    ,o.pre_actual_mtr_date -- 历史到期实际终止日
    ,o.total_ai -- 回购利息
    ,o.p_status -- 产品状态，1：展期，2：逾期
    ,o.draw_advance_rate -- 提前支取利率
    ,o.post_interest_rate -- 部提后利率
    ,o.is_open_letter -- 是否开立证实书
    ,o.grace_day -- 宽限天数，默认为0
    ,o.credit_amount -- 授信额度(元)
    ,o.extordid -- 外部成交编号
    ,o.is_auto_calculate -- 是否自动计算利率
    ,o.nominal_rate -- 名义利率
    ,o.added_rate -- 增值税率
    ,o.slotting_addrate -- 通道附加税率
    ,o.slotting_rate -- 通道费率
    ,o.slotting_daycounter -- 通道费计息基准
    ,o.trustee_rate -- 托管费率
    ,o.trustee_daycounter -- 托管费计息基准
    ,o.other_rate -- 其他费率
    ,o.other_daycounter -- 其他费用计息基准
    ,o.nominal_daycounter -- 名义利率计息基准
    ,o.credit_weight -- 授信权重(%)
    ,o.reply_code -- 批复号
    ,o.record_rate -- 录入汇率(%)
    ,o.accounting_type -- 利息结算方式默认0为费用不计入成本，1为计入成本的情况
    ,o.product_rate -- 产品评级
    ,o.rate_institution -- 评级机构
    ,o.is_guaranteed -- 是否保本 1:是 0:否
    ,o.expect_take_day -- 预计支取日
    ,o.bank_group_code -- 银团代码，银团交易单上对应的金融工具代码为此代码
    ,o.coupon_prec -- 利率精度
    ,o.apr_txn -- 批复编号-华兴
    ,o.fee_rate -- 费率(%)
    ,o.handlingchargetotal -- 手续费合计(元)
    ,o.usufruct_mtr_date -- 收益权到期日
    ,o.shibor_coupon -- shibor利率
    ,o.shibor_i_code -- SHIBOR利率，仅供显示使用
    ,o.shibor_a_type -- SHIBOR利率，仅供显示使用
    ,o.shibor_m_type -- SHIBOR利率，仅供显示使用
    ,o.paymentinfo_type -- 未来现金流获取方式 1-系统默认、2-手工维护本息、3-手工维护本金
    ,o.is_subloan -- 是否转贷标识
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_cashlb_bk o
    left join ${iol_schema}.ibms_ttrd_cashlb_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_cashlb_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_cashlb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_cashlb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_cashlb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_cashlb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_cashlb exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_cashlb_cl;
alter table ${iol_schema}.ibms_ttrd_cashlb exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_cashlb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_cashlb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_cashlb_op purge;
drop table ${iol_schema}.ibms_ttrd_cashlb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_cashlb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_cashlb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
