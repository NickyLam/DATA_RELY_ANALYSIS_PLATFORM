/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_ibo_deal
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
create table ${iol_schema}.ctms_fbs_v_ibo_deal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_ibo_deal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_ibo_deal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_ibo_deal where 0=1;

create table ${iol_schema}.ctms_fbs_v_ibo_deal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_ibo_deal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_ibo_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_ibo_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cus_number, o.cus_number) as cus_number -- 机构的唯一标识号
    ,nvl(n.branch_number, o.branch_number) as branch_number -- 分支机构的唯一标识号
    ,nvl(n.deal_sqno, o.deal_sqno) as deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 交易日期和时间
    ,nvl(n.value_date, o.value_date) as value_date -- 起息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.crncy_code, o.crncy_code) as crncy_code -- 货币
    ,nvl(n.rate, o.rate) as rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
    ,nvl(n.first_amnt, o.first_amnt) as first_amnt -- 拆借金额，负数为拆出，正数为拆入
    ,nvl(n.maturity_amnt, o.maturity_amnt) as maturity_amnt -- 期末结算金额
    ,nvl(n.day_accrd_intrst_amnt, o.day_accrd_intrst_amnt) as day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
    ,nvl(n.interest_base, o.interest_base) as interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
    ,nvl(n.current_rate, o.current_rate) as current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
    ,nvl(n.accrued_amnt, o.accrued_amnt) as accrued_amnt -- 应计利息总额
    ,nvl(n.trade_purpose, o.trade_purpose) as trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,nvl(n.business_date, o.business_date) as business_date -- 系统交易日，交易录入时的系统日期和时间
    ,nvl(n.counter_party_id, o.counter_party_id) as counter_party_id -- 交易对手的srno
    ,nvl(n.counter_party_scname, o.counter_party_scname) as counter_party_scname -- 交易对手中文简称
    ,nvl(n.update_time, o.update_time) as update_time -- 记录修改日期
    ,nvl(n.pdd_deal_sqno, o.pdd_deal_sqno) as pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
    ,nvl(n.deal_status, o.deal_status) as deal_status -- 成交单状态
    ,nvl(n.deal_dir, o.deal_dir) as deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
    ,nvl(n.client_deal_sqno, o.client_deal_sqno) as client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
    ,nvl(n.deal_source, o.deal_source) as deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
    ,nvl(n.deal_market, o.deal_market) as deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,nvl(n.deal_link_sqno, o.deal_link_sqno) as deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 更新日期
    ,nvl(n.portfolio_sqno, o.portfolio_sqno) as portfolio_sqno -- 投组交易编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合id
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 投资组合名称
    ,nvl(n.portfolio_type, o.portfolio_type) as portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,nvl(n.portfolio_status, o.portfolio_status) as portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
    ,nvl(n.portfolio_link_sqno, o.portfolio_link_sqno) as portfolio_link_sqno -- 交易链接编号
    ,nvl(n.ibo_type, o.ibo_type) as ibo_type -- 拆借类型 0：拆借 1：同存
    ,nvl(n.clear_dep, o.clear_dep) as clear_dep -- 清算机构 zz：其它； aa：上清所
    ,nvl(n.rsdl_amnt, o.rsdl_amnt) as rsdl_amnt -- 剩余金额
    ,nvl(n.float_direction, o.float_direction) as float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
    ,nvl(n.intrst_bnchmrk_srno, o.intrst_bnchmrk_srno) as intrst_bnchmrk_srno -- 浮动利率指标
    ,nvl(n.intrst_bnchmrk_name, o.intrst_bnchmrk_name) as intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
    ,nvl(n.intrst_term, o.intrst_term) as intrst_term -- 利率期限
    ,nvl(n.spread_rate, o.spread_rate) as spread_rate -- bp，带方向
    ,nvl(n.pmnt_freq, o.pmnt_freq) as pmnt_freq -- 付息频率
    ,nvl(n.pmnt_stub_rule, o.pmnt_stub_rule) as pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
    ,nvl(n.unwind_cnfrm_rate, o.unwind_cnfrm_rate) as unwind_cnfrm_rate -- 约定提前支取利率。
    ,nvl(n.fixing_freq, o.fixing_freq) as fixing_freq -- 定息频率
    ,nvl(n.fixing_day_count, o.fixing_day_count) as fixing_day_count -- 定价日调整天数
    ,nvl(n.frst_pmnt_date, o.frst_pmnt_date) as frst_pmnt_date -- 首次付息日
    ,nvl(n.day_count, o.day_count) as day_count -- 拆借天数
    ,nvl(n.imps_rate, o.imps_rate) as imps_rate -- 约定罚息日利率(影响后台)。
    ,nvl(n.usd_crncy_amnt, o.usd_crncy_amnt) as usd_crncy_amnt -- 折usd货币金额
    ,nvl(n.event_mask, o.event_mask) as event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,nvl(n.event_type, o.event_type) as event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,nvl(n.event_link_sqno, o.event_link_sqno) as event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
    ,nvl(n.event_date, o.event_date) as event_date -- 事件日期
    ,nvl(n.ro_roll_type, o.ro_roll_type) as ro_roll_type -- 展期方式
    ,nvl(n.ro_calc_amount, o.ro_calc_amount) as ro_calc_amount -- 展期本金
    ,nvl(n.ro_intrst_amount, o.ro_intrst_amount) as ro_intrst_amount -- 展期利息
    ,nvl(n.confirm_indc, o.confirm_indc) as confirm_indc -- 交易后确认标识
    ,nvl(n.collateral_method, o.collateral_method) as collateral_method -- 质押方式 1：买断 2：质押
    ,nvl(n.delivery_type, o.delivery_type) as delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
    ,nvl(n.delivery_type2, o.delivery_type2) as delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
    ,nvl(n.underlying_currency, o.underlying_currency) as underlying_currency -- 债券币种
    ,nvl(n.underlying_stip_value, o.underlying_stip_value) as underlying_stip_value -- 折算比例
    ,nvl(n.underlying_discountamt, o.underlying_discountamt) as underlying_discountamt -- 折算金额1
    ,nvl(n.underlying_qty, o.underlying_qty) as underlying_qty -- 券面总额
    ,nvl(n.underlying_securityid, o.underlying_securityid) as underlying_securityid -- 债券代码
    ,nvl(n.underlying_dirty_price, o.underlying_dirty_price) as underlying_dirty_price -- 债券全价
    ,nvl(n.underlying_value, o.underlying_value) as underlying_value -- 债券价值
    ,nvl(n.face_value, o.face_value) as face_value -- 面值
    ,nvl(n.underlying_stip_rate, o.underlying_stip_rate) as underlying_stip_rate -- 折算汇率2
    ,nvl(n.underlying_discountamt2, o.underlying_discountamt2) as underlying_discountamt2 -- 折算金额2
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.ma_bank_cn, o.ma_bank_cn) as ma_bank_cn -- 本方经办行中文名称
    ,nvl(n.ma_bank_en, o.ma_bank_en) as ma_bank_en -- 本方经办行英文名称
    ,nvl(n.cp_ma_bank_cn, o.cp_ma_bank_cn) as cp_ma_bank_cn -- 对手方经办行中文名称
    ,nvl(n.cp_ma_bank_en, o.cp_ma_bank_en) as cp_ma_bank_en -- 对手方经办行英文名称
    ,nvl(n.dealer, o.dealer) as dealer -- 交易员
    ,nvl(n.delivery_type_ibo, o.delivery_type_ibo) as delivery_type_ibo -- 结算方式 13: siss 支付直连
    ,nvl(n.deal_time, o.deal_time) as deal_time -- 交易时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cus_number is null
            and n.branch_number is null
            and n.deal_sqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_ibo_deal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_ibo_deal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
where (
        o.cus_number is null
        and o.branch_number is null
        and o.deal_sqno is null
    )
    or (
        n.cus_number is null
        and n.branch_number is null
        and n.deal_sqno is null
    )
    or (
        o.deal_date <> n.deal_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.crncy_code <> n.crncy_code
        or o.rate <> n.rate
        or o.first_amnt <> n.first_amnt
        or o.maturity_amnt <> n.maturity_amnt
        or o.day_accrd_intrst_amnt <> n.day_accrd_intrst_amnt
        or o.rate_type <> n.rate_type
        or o.interest_base <> n.interest_base
        or o.current_rate <> n.current_rate
        or o.accrued_amnt <> n.accrued_amnt
        or o.trade_purpose <> n.trade_purpose
        or o.business_date <> n.business_date
        or o.counter_party_id <> n.counter_party_id
        or o.counter_party_scname <> n.counter_party_scname
        or o.update_time <> n.update_time
        or o.pdd_deal_sqno <> n.pdd_deal_sqno
        or o.deal_status <> n.deal_status
        or o.deal_dir <> n.deal_dir
        or o.client_deal_sqno <> n.client_deal_sqno
        or o.trade_type <> n.trade_type
        or o.deal_source <> n.deal_source
        or o.deal_market <> n.deal_market
        or o.settle_type <> n.settle_type
        or o.deal_link_sqno <> n.deal_link_sqno
        or o.modify_date <> n.modify_date
        or o.portfolio_sqno <> n.portfolio_sqno
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.portfolio_type <> n.portfolio_type
        or o.portfolio_status <> n.portfolio_status
        or o.portfolio_link_sqno <> n.portfolio_link_sqno
        or o.ibo_type <> n.ibo_type
        or o.clear_dep <> n.clear_dep
        or o.rsdl_amnt <> n.rsdl_amnt
        or o.float_direction <> n.float_direction
        or o.intrst_bnchmrk_srno <> n.intrst_bnchmrk_srno
        or o.intrst_bnchmrk_name <> n.intrst_bnchmrk_name
        or o.intrst_term <> n.intrst_term
        or o.spread_rate <> n.spread_rate
        or o.pmnt_freq <> n.pmnt_freq
        or o.pmnt_stub_rule <> n.pmnt_stub_rule
        or o.unwind_cnfrm_rate <> n.unwind_cnfrm_rate
        or o.fixing_freq <> n.fixing_freq
        or o.fixing_day_count <> n.fixing_day_count
        or o.frst_pmnt_date <> n.frst_pmnt_date
        or o.day_count <> n.day_count
        or o.imps_rate <> n.imps_rate
        or o.usd_crncy_amnt <> n.usd_crncy_amnt
        or o.event_mask <> n.event_mask
        or o.event_type <> n.event_type
        or o.event_link_sqno <> n.event_link_sqno
        or o.event_date <> n.event_date
        or o.ro_roll_type <> n.ro_roll_type
        or o.ro_calc_amount <> n.ro_calc_amount
        or o.ro_intrst_amount <> n.ro_intrst_amount
        or o.confirm_indc <> n.confirm_indc
        or o.collateral_method <> n.collateral_method
        or o.delivery_type <> n.delivery_type
        or o.delivery_type2 <> n.delivery_type2
        or o.underlying_currency <> n.underlying_currency
        or o.underlying_stip_value <> n.underlying_stip_value
        or o.underlying_discountamt <> n.underlying_discountamt
        or o.underlying_qty <> n.underlying_qty
        or o.underlying_securityid <> n.underlying_securityid
        or o.underlying_dirty_price <> n.underlying_dirty_price
        or o.underlying_value <> n.underlying_value
        or o.face_value <> n.face_value
        or o.underlying_stip_rate <> n.underlying_stip_rate
        or o.underlying_discountamt2 <> n.underlying_discountamt2
        or o.remark <> n.remark
        or o.ma_bank_cn <> n.ma_bank_cn
        or o.ma_bank_en <> n.ma_bank_en
        or o.cp_ma_bank_cn <> n.cp_ma_bank_cn
        or o.cp_ma_bank_en <> n.cp_ma_bank_en
        or o.dealer <> n.dealer
        or o.delivery_type_ibo <> n.delivery_type_ibo
        or o.deal_time <> n.deal_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_ibo_deal_cl(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_ibo_deal_op(
            cus_number -- 机构的唯一标识号
            ,branch_number -- 分支机构的唯一标识号
            ,deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
            ,deal_date -- 交易日期和时间
            ,value_date -- 起息日
            ,maturity_date -- 到期日
            ,crncy_code -- 货币
            ,rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
            ,first_amnt -- 拆借金额，负数为拆出，正数为拆入
            ,maturity_amnt -- 期末结算金额
            ,day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
            ,rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
            ,interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
            ,current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
            ,accrued_amnt -- 应计利息总额
            ,trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
            ,business_date -- 系统交易日，交易录入时的系统日期和时间
            ,counter_party_id -- 交易对手的srno
            ,counter_party_scname -- 交易对手中文简称
            ,update_time -- 记录修改日期
            ,pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
            ,deal_status -- 成交单状态
            ,deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
            ,client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
            ,trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
            ,deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
            ,deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
            ,settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
            ,deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
            ,modify_date -- 更新日期
            ,portfolio_sqno -- 投组交易编号
            ,portfolio_id -- 投资组合id
            ,portfolio_name -- 投资组合名称
            ,portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
            ,portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
            ,portfolio_link_sqno -- 交易链接编号
            ,ibo_type -- 拆借类型 0：拆借 1：同存
            ,clear_dep -- 清算机构 zz：其它； aa：上清所
            ,rsdl_amnt -- 剩余金额
            ,float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
            ,intrst_bnchmrk_srno -- 浮动利率指标
            ,intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
            ,intrst_term -- 利率期限
            ,spread_rate -- bp，带方向
            ,pmnt_freq -- 付息频率
            ,pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
            ,unwind_cnfrm_rate -- 约定提前支取利率。
            ,fixing_freq -- 定息频率
            ,fixing_day_count -- 定价日调整天数
            ,frst_pmnt_date -- 首次付息日
            ,day_count -- 拆借天数
            ,imps_rate -- 约定罚息日利率(影响后台)。
            ,usd_crncy_amnt -- 折usd货币金额
            ,event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
            ,event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
            ,event_date -- 事件日期
            ,ro_roll_type -- 展期方式
            ,ro_calc_amount -- 展期本金
            ,ro_intrst_amount -- 展期利息
            ,confirm_indc -- 交易后确认标识
            ,collateral_method -- 质押方式 1：买断 2：质押
            ,delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
            ,delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
            ,underlying_currency -- 债券币种
            ,underlying_stip_value -- 折算比例
            ,underlying_discountamt -- 折算金额1
            ,underlying_qty -- 券面总额
            ,underlying_securityid -- 债券代码
            ,underlying_dirty_price -- 债券全价
            ,underlying_value -- 债券价值
            ,face_value -- 面值
            ,underlying_stip_rate -- 折算汇率2
            ,underlying_discountamt2 -- 折算金额2
            ,remark -- 备注
            ,ma_bank_cn -- 本方经办行中文名称
            ,ma_bank_en -- 本方经办行英文名称
            ,cp_ma_bank_cn -- 对手方经办行中文名称
            ,cp_ma_bank_en -- 对手方经办行英文名称
            ,dealer -- 交易员
            ,delivery_type_ibo -- 结算方式 13: siss 支付直连
            ,deal_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cus_number -- 机构的唯一标识号
    ,o.branch_number -- 分支机构的唯一标识号
    ,o.deal_sqno -- 投组交易流水号，交易的fms内部唯一编号
    ,o.deal_date -- 交易日期和时间
    ,o.value_date -- 起息日
    ,o.maturity_date -- 到期日
    ,o.crncy_code -- 货币
    ,o.rate -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
    ,o.first_amnt -- 拆借金额，负数为拆出，正数为拆入
    ,o.maturity_amnt -- 期末结算金额
    ,o.day_accrd_intrst_amnt -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
    ,o.rate_type -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
    ,o.interest_base -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
    ,o.current_rate -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
    ,o.accrued_amnt -- 应计利息总额
    ,o.trade_purpose -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,o.business_date -- 系统交易日，交易录入时的系统日期和时间
    ,o.counter_party_id -- 交易对手的srno
    ,o.counter_party_scname -- 交易对手中文简称
    ,o.update_time -- 记录修改日期
    ,o.pdd_deal_sqno -- 原始交易流水号，交易的fms内部唯一编号
    ,o.deal_status -- 成交单状态
    ,o.deal_dir -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
    ,o.client_deal_sqno -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
    ,o.trade_type -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
    ,o.deal_source -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
    ,o.deal_market -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,o.settle_type -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,o.deal_link_sqno -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
    ,o.modify_date -- 更新日期
    ,o.portfolio_sqno -- 投组交易编号
    ,o.portfolio_id -- 投资组合id
    ,o.portfolio_name -- 投资组合名称
    ,o.portfolio_type -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,o.portfolio_status -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
    ,o.portfolio_link_sqno -- 交易链接编号
    ,o.ibo_type -- 拆借类型 0：拆借 1：同存
    ,o.clear_dep -- 清算机构 zz：其它； aa：上清所
    ,o.rsdl_amnt -- 剩余金额
    ,o.float_direction -- 利率的浮动方向， 0：正浮动； 1：负浮动；
    ,o.intrst_bnchmrk_srno -- 浮动利率指标
    ,o.intrst_bnchmrk_name -- 浮动利率指标前台转换为指标名称
    ,o.intrst_term -- 利率期限
    ,o.spread_rate -- bp，带方向
    ,o.pmnt_freq -- 付息频率
    ,o.pmnt_stub_rule -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
    ,o.unwind_cnfrm_rate -- 约定提前支取利率。
    ,o.fixing_freq -- 定息频率
    ,o.fixing_day_count -- 定价日调整天数
    ,o.frst_pmnt_date -- 首次付息日
    ,o.day_count -- 拆借天数
    ,o.imps_rate -- 约定罚息日利率(影响后台)。
    ,o.usd_crncy_amnt -- 折usd货币金额
    ,o.event_mask -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,o.event_type -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,o.event_link_sqno -- 事件(违约，展期，提前交割)关联交易编号
    ,o.event_date -- 事件日期
    ,o.ro_roll_type -- 展期方式
    ,o.ro_calc_amount -- 展期本金
    ,o.ro_intrst_amount -- 展期利息
    ,o.confirm_indc -- 交易后确认标识
    ,o.collateral_method -- 质押方式 1：买断 2：质押
    ,o.delivery_type -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
    ,o.delivery_type2 -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
    ,o.underlying_currency -- 债券币种
    ,o.underlying_stip_value -- 折算比例
    ,o.underlying_discountamt -- 折算金额1
    ,o.underlying_qty -- 券面总额
    ,o.underlying_securityid -- 债券代码
    ,o.underlying_dirty_price -- 债券全价
    ,o.underlying_value -- 债券价值
    ,o.face_value -- 面值
    ,o.underlying_stip_rate -- 折算汇率2
    ,o.underlying_discountamt2 -- 折算金额2
    ,o.remark -- 备注
    ,o.ma_bank_cn -- 本方经办行中文名称
    ,o.ma_bank_en -- 本方经办行英文名称
    ,o.cp_ma_bank_cn -- 对手方经办行中文名称
    ,o.cp_ma_bank_en -- 对手方经办行英文名称
    ,o.dealer -- 交易员
    ,o.delivery_type_ibo -- 结算方式 13: siss 支付直连
    ,o.deal_time -- 交易时间
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
from ${iol_schema}.ctms_fbs_v_ibo_deal_bk o
    left join ${iol_schema}.ctms_fbs_v_ibo_deal_op n
        on
            o.cus_number = n.cus_number
            and o.branch_number = n.branch_number
            and o.deal_sqno = n.deal_sqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_ibo_deal_cl d
        on
            o.cus_number = d.cus_number
            and o.branch_number = d.branch_number
            and o.deal_sqno = d.deal_sqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_fbs_v_ibo_deal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_fbs_v_ibo_deal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_fbs_v_ibo_deal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_fbs_v_ibo_deal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_fbs_v_ibo_deal exchange partition p_${batch_date} with table ${iol_schema}.ctms_fbs_v_ibo_deal_cl;
alter table ${iol_schema}.ctms_fbs_v_ibo_deal exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_ibo_deal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_ibo_deal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal_op purge;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_ibo_deal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
