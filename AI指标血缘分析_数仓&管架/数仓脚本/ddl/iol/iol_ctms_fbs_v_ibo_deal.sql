/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_ibo_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_ibo_deal
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_ibo_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_ibo_deal(
    cus_number number(5,0) -- 机构的唯一标识号
    ,branch_number number(5,0) -- 分支机构的唯一标识号
    ,deal_sqno number(18,0) -- 投组交易流水号，交易的fms内部唯一编号
    ,deal_date date -- 交易日期和时间
    ,value_date date -- 起息日
    ,maturity_date date -- 到期日
    ,crncy_code varchar2(5) -- 货币
    ,rate number(30,2) -- 拆借利率。如果为浮动利率或变动利率，则为首期利率。
    ,first_amnt number(30,2) -- 拆借金额，负数为拆出，正数为拆入
    ,maturity_amnt number(30,2) -- 期末结算金额
    ,day_accrd_intrst_amnt number(38,12) -- 每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
    ,rate_type number(2,0) -- 利率类型 0：固定利率 1：浮动利率  2：变动利率
    ,interest_base number(2,0) -- 计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）
    ,current_rate number(38,12) -- 当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整
    ,accrued_amnt number(38,12) -- 应计利息总额
    ,trade_purpose number(2,0) -- 交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,business_date date -- 系统交易日，交易录入时的系统日期和时间
    ,counter_party_id number(8,0) -- 交易对手的srno
    ,counter_party_scname varchar2(384) -- 交易对手中文简称
    ,update_time timestamp -- 记录修改日期
    ,pdd_deal_sqno number(18,0) -- 原始交易流水号，交易的fms内部唯一编号
    ,deal_status varchar2(3) -- 成交单状态
    ,deal_dir number(22,0) -- 交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
    ,client_deal_sqno varchar2(45) -- 业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。
    ,trade_type varchar2(3) -- 交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）
    ,deal_source varchar2(3) -- 交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易
    ,deal_market varchar2(8) -- 交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）
    ,settle_type number(2,0) -- 清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
    ,deal_link_sqno number(22,0) -- 交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null
    ,modify_date date -- 更新日期
    ,portfolio_sqno number(18,0) -- 投组交易编号
    ,portfolio_id number(8,0) -- 投资组合id
    ,portfolio_name varchar2(383) -- 投资组合名称
    ,portfolio_type varchar2(60) -- 投组类型： 交易 对冲  自营买卖 市场平盘
    ,portfolio_status varchar2(3) -- 投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组
    ,portfolio_link_sqno number(18,0) -- 交易链接编号
    ,ibo_type number(2,0) -- 拆借类型 0：拆借 1：同存
    ,clear_dep varchar2(3) -- 清算机构 zz：其它； aa：上清所
    ,rsdl_amnt number(30,2) -- 剩余金额
    ,float_direction number(2,0) -- 利率的浮动方向， 0：正浮动； 1：负浮动；
    ,intrst_bnchmrk_srno number(8,0) -- 浮动利率指标
    ,intrst_bnchmrk_name varchar2(75) -- 浮动利率指标前台转换为指标名称
    ,intrst_term varchar2(60) -- 利率期限
    ,spread_rate number(38,12) -- bp，带方向
    ,pmnt_freq varchar2(60) -- 付息频率
    ,pmnt_stub_rule number(2,0) -- 付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
    ,unwind_cnfrm_rate number(38,12) -- 约定提前支取利率。
    ,fixing_freq varchar2(60) -- 定息频率
    ,fixing_day_count number(4,0) -- 定价日调整天数
    ,frst_pmnt_date date -- 首次付息日
    ,day_count number(4,0) -- 拆借天数
    ,imps_rate number(38,12) -- 约定罚息日利率(影响后台)。
    ,usd_crncy_amnt number(30,2) -- 折usd货币金额
    ,event_mask varchar2(3) -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,event_type varchar2(3) -- nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行
    ,event_link_sqno number(22,0) -- 事件(违约，展期，提前交割)关联交易编号
    ,event_date date -- 事件日期
    ,ro_roll_type varchar2(75) -- 展期方式
    ,ro_calc_amount number(30,2) -- 展期本金
    ,ro_intrst_amount number(30,2) -- 展期利息
    ,confirm_indc varchar2(8) -- 交易后确认标识
    ,collateral_method varchar2(6) -- 质押方式 1：买断 2：质押
    ,delivery_type varchar2(12) -- 首次结算方式 0：券款对付 4：见券付款 5：见款付券
    ,delivery_type2 varchar2(12) -- 到期结算方式 0：券款对付 4：见券付款 5：见款付券
    ,underlying_currency varchar2(750) -- 债券币种
    ,underlying_stip_value varchar2(750) -- 折算比例
    ,underlying_discountamt varchar2(750) -- 折算金额1
    ,underlying_qty varchar2(750) -- 券面总额
    ,underlying_securityid varchar2(750) -- 债券代码
    ,underlying_dirty_price varchar2(750) -- 债券全价
    ,underlying_value varchar2(750) -- 债券价值
    ,face_value varchar2(750) -- 面值
    ,underlying_stip_rate varchar2(750) -- 折算汇率2
    ,underlying_discountamt2 varchar2(750) -- 折算金额2
    ,remark varchar2(384) -- 备注
    ,ma_bank_cn varchar2(383) -- 本方经办行中文名称
    ,ma_bank_en varchar2(383) -- 本方经办行英文名称
    ,cp_ma_bank_cn varchar2(383) -- 对手方经办行中文名称
    ,cp_ma_bank_en varchar2(383) -- 对手方经办行英文名称
    ,dealer varchar2(60) -- 交易员
    ,delivery_type_ibo varchar2(6) -- 结算方式 13: siss 支付直连
    ,deal_time date -- 交易时间
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
grant select on ${iol_schema}.ctms_fbs_v_ibo_deal to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_deal to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_deal to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_ibo_deal is '拆借视图';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.cus_number is '机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.branch_number is '分支机构的唯一标识号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_sqno is '投组交易流水号，交易的fms内部唯一编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_date is '交易日期和时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.value_date is '起息日';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.maturity_date is '到期日';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.crncy_code is '货币';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.rate is '拆借利率。如果为浮动利率或变动利率，则为首期利率。';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.first_amnt is '拆借金额，负数为拆出，正数为拆入';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.maturity_amnt is '期末结算金额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.day_accrd_intrst_amnt is '每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.rate_type is '利率类型 0：固定利率 1：浮动利率  2：变动利率';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.interest_base is '计息基准 0：act/360 1: act/365  2: 30/360 3： act/365f  4: act/act 对应fms_crncy_base_dtls.cbd_intrst_basis_indc（2）';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.current_rate is '当前计息周期的利率  固定利率：等于dma_deal_number(20,12) 浮动利率、变动利率：在利率重置日进行调整';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.accrued_amnt is '应计利息总额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.trade_purpose is '交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.business_date is '系统交易日，交易录入时的系统日期和时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.counter_party_id is '交易对手的srno';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.counter_party_scname is '交易对手中文简称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.update_time is '记录修改日期';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.pdd_deal_sqno is '原始交易流水号，交易的fms内部唯一编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_status is '成交单状态';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_dir is '交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.client_deal_sqno is '业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. cstp下载交易中的成交编号。';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.trade_type is '交易模式 zz：其它 a：匿名（对应tradeinstrument=3） b：双边（对应tradeinstrument=1） gb：黄金.询价模式（对应tradeinstrument=6）';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_source is '交易来源 c：cstp，cstp下载交易 e：external api，银行接口下载交易 f：file，文件导入交易 m：manual，手工录入交易';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_market is '交易场所： 其它 cfets r：（保留） e：（保留） b：银行 s：模拟交易 v：虚拟交易（多笔交易组合出来的）（2.0.0）';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.settle_type is '清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_link_sqno is '交易修改删除的序列关系。 1. 交易修改时，通过本字段，r交易关联到u交易，a交易关联到r交易。 2. 交易删除时，通过本字段，r交易关联到d交易。 3. 无修改删除时，本字段为null';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.modify_date is '更新日期';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_sqno is '投组交易编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_id is '投资组合id';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_name is '投资组合名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_type is '投组类型： 交易 对冲  自营买卖 市场平盘';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_status is '投资组合状态： a：新交易 u：交易被修改 d：cstp下载交易或第三方接口下载交易根据规则自动分配入投组 r：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 m：已到期交易，交易全部完成交割后，由a状态置为m状态 c：取消投组';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.portfolio_link_sqno is '交易链接编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ibo_type is '拆借类型 0：拆借 1：同存';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.clear_dep is '清算机构 zz：其它； aa：上清所';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.rsdl_amnt is '剩余金额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.float_direction is '利率的浮动方向， 0：正浮动； 1：负浮动；';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.intrst_bnchmrk_srno is '浮动利率指标';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.intrst_bnchmrk_name is '浮动利率指标前台转换为指标名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.intrst_term is '利率期限';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.spread_rate is 'bp，带方向';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.pmnt_freq is '付息频率';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.pmnt_stub_rule is '付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.unwind_cnfrm_rate is '约定提前支取利率。';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.fixing_freq is '定息频率';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.fixing_day_count is '定价日调整天数';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.frst_pmnt_date is '首次付息日';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.day_count is '拆借天数';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.imps_rate is '约定罚息日利率(影响后台)。';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.usd_crncy_amnt is '折usd货币金额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.event_mask is 'nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.event_type is 'nm 正常。dv 交割衍生,可拆分。sp 注销衍生,可拆分。bk 违约衍生,可拆分。ro 展期衍生,可拆分。rb 提前交割衍,可拆分。ex 期权行';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.event_link_sqno is '事件(违约，展期，提前交割)关联交易编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.event_date is '事件日期';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ro_roll_type is '展期方式';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ro_calc_amount is '展期本金';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ro_intrst_amount is '展期利息';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.confirm_indc is '交易后确认标识';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.collateral_method is '质押方式 1：买断 2：质押';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.delivery_type is '首次结算方式 0：券款对付 4：见券付款 5：见款付券';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.delivery_type2 is '到期结算方式 0：券款对付 4：见券付款 5：见款付券';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_currency is '债券币种';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_stip_value is '折算比例';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_discountamt is '折算金额1';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_qty is '券面总额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_securityid is '债券代码';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_dirty_price is '债券全价';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_value is '债券价值';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.face_value is '面值';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_stip_rate is '折算汇率2';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.underlying_discountamt2 is '折算金额2';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.remark is '备注';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ma_bank_cn is '本方经办行中文名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.ma_bank_en is '本方经办行英文名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.cp_ma_bank_cn is '对手方经办行中文名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.cp_ma_bank_en is '对手方经办行英文名称';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.dealer is '交易员';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.delivery_type_ibo is '结算方式 13: siss 支付直连';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.deal_time is '交易时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_ibo_deal.etl_timestamp is 'ETL处理时间戳';
