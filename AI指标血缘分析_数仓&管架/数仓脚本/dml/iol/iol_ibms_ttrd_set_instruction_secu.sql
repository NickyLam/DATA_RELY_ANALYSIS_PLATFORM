/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction_secu
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
create table ${iol_schema}.ibms_ttrd_set_instruction_secu_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_set_instruction_secu
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_secu_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_secu where 0=1;

create table ${iol_schema}.ibms_ttrd_set_instruction_secu_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_secu where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_secu_cl(
            secu_inst_id -- 证券结算指令序号
            ,secu_inst_grp_id -- 合并券指令号
            ,inst_id -- 主结算指令序号
            ,biz_type -- 业务类型,
            ,direction -- 交收方向
            ,trade_grp_id -- 核算交易组合
            ,secu_acct_id -- 内部证券账户ID
            ,ext_secu_acct_id -- 外部证券账户ID
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,currency -- 币种
            ,real_fee -- 费用成本变动
            ,estd_ai -- 应计利息成本变动
            ,received_ai -- 已收本周期利息（开仓的一方时候有用）
            ,estd_cp -- 净价金额
            ,real_ai -- 实际应计利息
            ,real_cp -- 实际净价金额
            ,due_ai -- 应收未收利息
            ,due_cp -- 应收未收本金
            ,prft_fee -- 损益费用
            ,is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
            ,is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
            ,volume -- 余额数量变动
            ,freeze_volume -- 冻结数量
            ,is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
            ,cal_date -- 计算截止日期,不调整的理论支付日
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,i_name -- 金融工具简称
            ,p_class -- 产品分类
            ,cost -- 全价成本变动
            ,cost_ai_his_real -- 应收未收利息
            ,zzd_acct_code -- 本方中债登托管账号
            ,party_zzd_acct_code -- 对手中债登托管账号
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 经办人
            ,confirm_time -- 非首期指令确认时间
            ,confirm_user -- 非首期指令确认人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,amount -- 以元为单位的面额
            ,close_trade_id -- 指定平仓时，指定核算的交易号
            ,blc_state -- 计算截止日期,不调整的理论支付日
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,estd_fee -- 理论费用
            ,fee -- 费用成本
            ,opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
            ,secu_inst_setgrp_id -- 合并收付号
            ,his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
            ,his_secu_inst_id -- 历史券指令号
            ,his_set_finish_date -- 历史实际结算日期
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,volume_termcur -- 货币对反向数量
            ,amount_termcur -- 货币对反向面额
            ,estd_cp_termcur -- 货币对反向预计净价金额
            ,real_cp_termcur -- 货币对反向实际净价金额
            ,amrt_method -- 摊销算法
            ,real_margin -- 期货保证金
            ,fpml -- 金融工具条款
            ,is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
            ,is_theory_acct -- 是否已做过理论核算
            ,is_theory_blc -- 是否已做权责业务
            ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
            ,party_pset -- 结算场所代码
            ,party_pset_country -- 国家代码
            ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,party_agent_code_dss -- 代理行代码编码集合名称
            ,party_agent_code -- 代理行代码
            ,party_agent_account -- 代理行账号
            ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,party_code_dss -- 交易主体代码编码集合名称
            ,party_code -- 交易主体代码
            ,party_account -- 交易主体账号
            ,si_id -- 证券结算要素ID
            ,cal_start_date -- 计息开始日期
            ,ord_limit_secu_inst_id -- 审批单限额券指令号
            ,estd_volume -- 预计数量
            ,estd_amount -- 预计面额
            ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,party_pset_name -- 结算场所名称
            ,volume_geninst -- 生成指令时持仓数量
            ,custom_dim1 -- 扩展维度1
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,memo_secu -- 理论实收付备注信息
            ,dtl_due_type -- 明细due类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_secu_op(
            secu_inst_id -- 证券结算指令序号
            ,secu_inst_grp_id -- 合并券指令号
            ,inst_id -- 主结算指令序号
            ,biz_type -- 业务类型,
            ,direction -- 交收方向
            ,trade_grp_id -- 核算交易组合
            ,secu_acct_id -- 内部证券账户ID
            ,ext_secu_acct_id -- 外部证券账户ID
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,currency -- 币种
            ,real_fee -- 费用成本变动
            ,estd_ai -- 应计利息成本变动
            ,received_ai -- 已收本周期利息（开仓的一方时候有用）
            ,estd_cp -- 净价金额
            ,real_ai -- 实际应计利息
            ,real_cp -- 实际净价金额
            ,due_ai -- 应收未收利息
            ,due_cp -- 应收未收本金
            ,prft_fee -- 损益费用
            ,is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
            ,is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
            ,volume -- 余额数量变动
            ,freeze_volume -- 冻结数量
            ,is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
            ,cal_date -- 计算截止日期,不调整的理论支付日
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,i_name -- 金融工具简称
            ,p_class -- 产品分类
            ,cost -- 全价成本变动
            ,cost_ai_his_real -- 应收未收利息
            ,zzd_acct_code -- 本方中债登托管账号
            ,party_zzd_acct_code -- 对手中债登托管账号
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 经办人
            ,confirm_time -- 非首期指令确认时间
            ,confirm_user -- 非首期指令确认人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,amount -- 以元为单位的面额
            ,close_trade_id -- 指定平仓时，指定核算的交易号
            ,blc_state -- 计算截止日期,不调整的理论支付日
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,estd_fee -- 理论费用
            ,fee -- 费用成本
            ,opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
            ,secu_inst_setgrp_id -- 合并收付号
            ,his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
            ,his_secu_inst_id -- 历史券指令号
            ,his_set_finish_date -- 历史实际结算日期
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,volume_termcur -- 货币对反向数量
            ,amount_termcur -- 货币对反向面额
            ,estd_cp_termcur -- 货币对反向预计净价金额
            ,real_cp_termcur -- 货币对反向实际净价金额
            ,amrt_method -- 摊销算法
            ,real_margin -- 期货保证金
            ,fpml -- 金融工具条款
            ,is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
            ,is_theory_acct -- 是否已做过理论核算
            ,is_theory_blc -- 是否已做权责业务
            ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
            ,party_pset -- 结算场所代码
            ,party_pset_country -- 国家代码
            ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,party_agent_code_dss -- 代理行代码编码集合名称
            ,party_agent_code -- 代理行代码
            ,party_agent_account -- 代理行账号
            ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,party_code_dss -- 交易主体代码编码集合名称
            ,party_code -- 交易主体代码
            ,party_account -- 交易主体账号
            ,si_id -- 证券结算要素ID
            ,cal_start_date -- 计息开始日期
            ,ord_limit_secu_inst_id -- 审批单限额券指令号
            ,estd_volume -- 预计数量
            ,estd_amount -- 预计面额
            ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,party_pset_name -- 结算场所名称
            ,volume_geninst -- 生成指令时持仓数量
            ,custom_dim1 -- 扩展维度1
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,memo_secu -- 理论实收付备注信息
            ,dtl_due_type -- 明细due类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.secu_inst_id, o.secu_inst_id) as secu_inst_id -- 证券结算指令序号
    ,nvl(n.secu_inst_grp_id, o.secu_inst_grp_id) as secu_inst_grp_id -- 合并券指令号
    ,nvl(n.inst_id, o.inst_id) as inst_id -- 主结算指令序号
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 业务类型,
    ,nvl(n.direction, o.direction) as direction -- 交收方向
    ,nvl(n.trade_grp_id, o.trade_grp_id) as trade_grp_id -- 核算交易组合
    ,nvl(n.secu_acct_id, o.secu_acct_id) as secu_acct_id -- 内部证券账户ID
    ,nvl(n.ext_secu_acct_id, o.ext_secu_acct_id) as ext_secu_acct_id -- 外部证券账户ID
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.real_fee, o.real_fee) as real_fee -- 费用成本变动
    ,nvl(n.estd_ai, o.estd_ai) as estd_ai -- 应计利息成本变动
    ,nvl(n.received_ai, o.received_ai) as received_ai -- 已收本周期利息（开仓的一方时候有用）
    ,nvl(n.estd_cp, o.estd_cp) as estd_cp -- 净价金额
    ,nvl(n.real_ai, o.real_ai) as real_ai -- 实际应计利息
    ,nvl(n.real_cp, o.real_cp) as real_cp -- 实际净价金额
    ,nvl(n.due_ai, o.due_ai) as due_ai -- 应收未收利息
    ,nvl(n.due_cp, o.due_cp) as due_cp -- 应收未收本金
    ,nvl(n.prft_fee, o.prft_fee) as prft_fee -- 损益费用
    ,nvl(n.is_remain_due_ai, o.is_remain_due_ai) as is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
    ,nvl(n.is_remain_due_cp, o.is_remain_due_cp) as is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
    ,nvl(n.volume, o.volume) as volume -- 余额数量变动
    ,nvl(n.freeze_volume, o.freeze_volume) as freeze_volume -- 冻结数量
    ,nvl(n.is_fixed, o.is_fixed) as is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
    ,nvl(n.cal_date, o.cal_date) as cal_date -- 计算截止日期,不调整的理论支付日
    ,nvl(n.set_date, o.set_date) as set_date -- 结算日期
    ,nvl(n.set_finish_date, o.set_finish_date) as set_finish_date -- 实际结算日期
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具简称
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.cost, o.cost) as cost -- 全价成本变动
    ,nvl(n.cost_ai_his_real, o.cost_ai_his_real) as cost_ai_his_real -- 应收未收利息
    ,nvl(n.zzd_acct_code, o.zzd_acct_code) as zzd_acct_code -- 本方中债登托管账号
    ,nvl(n.party_zzd_acct_code, o.party_zzd_acct_code) as party_zzd_acct_code -- 对手中债登托管账号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后修改时间
    ,nvl(n.update_user, o.update_user) as update_user -- 经办人
    ,nvl(n.confirm_time, o.confirm_time) as confirm_time -- 非首期指令确认时间
    ,nvl(n.confirm_user, o.confirm_user) as confirm_user -- 非首期指令确认人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人员
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.amount, o.amount) as amount -- 以元为单位的面额
    ,nvl(n.close_trade_id, o.close_trade_id) as close_trade_id -- 指定平仓时，指定核算的交易号
    ,nvl(n.blc_state, o.blc_state) as blc_state -- 计算截止日期,不调整的理论支付日
    ,nvl(n.acctg_state, o.acctg_state) as acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,nvl(n.estd_fee, o.estd_fee) as estd_fee -- 理论费用
    ,nvl(n.fee, o.fee) as fee -- 费用成本
    ,nvl(n.opr_state, o.opr_state) as opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
    ,nvl(n.secu_inst_setgrp_id, o.secu_inst_setgrp_id) as secu_inst_setgrp_id -- 合并收付号
    ,nvl(n.his_flag, o.his_flag) as his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
    ,nvl(n.his_secu_inst_id, o.his_secu_inst_id) as his_secu_inst_id -- 历史券指令号
    ,nvl(n.his_set_finish_date, o.his_set_finish_date) as his_set_finish_date -- 历史实际结算日期
    ,nvl(n.acctg_inst_id, o.acctg_inst_id) as acctg_inst_id -- 记账主指令号
    ,nvl(n.cancel_flag, o.cancel_flag) as cancel_flag -- 1:表示限额反向指令，其它：正向指令
    ,nvl(n.volume_termcur, o.volume_termcur) as volume_termcur -- 货币对反向数量
    ,nvl(n.amount_termcur, o.amount_termcur) as amount_termcur -- 货币对反向面额
    ,nvl(n.estd_cp_termcur, o.estd_cp_termcur) as estd_cp_termcur -- 货币对反向预计净价金额
    ,nvl(n.real_cp_termcur, o.real_cp_termcur) as real_cp_termcur -- 货币对反向实际净价金额
    ,nvl(n.amrt_method, o.amrt_method) as amrt_method -- 摊销算法
    ,nvl(n.real_margin, o.real_margin) as real_margin -- 期货保证金
    ,nvl(n.fpml, o.fpml) as fpml -- 金融工具条款
    ,nvl(n.is_impair, o.is_impair) as is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
    ,nvl(n.is_theory_acct, o.is_theory_acct) as is_theory_acct -- 是否已做过理论核算
    ,nvl(n.is_theory_blc, o.is_theory_blc) as is_theory_blc -- 是否已做权责业务
    ,nvl(n.cl_status, o.cl_status) as cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,nvl(n.party_pset, o.party_pset) as party_pset -- 结算场所代码
    ,nvl(n.party_pset_country, o.party_pset_country) as party_pset_country -- 国家代码
    ,nvl(n.party_agent_code_type, o.party_agent_code_type) as party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,nvl(n.party_agent_code_dss, o.party_agent_code_dss) as party_agent_code_dss -- 代理行代码编码集合名称
    ,nvl(n.party_agent_code, o.party_agent_code) as party_agent_code -- 代理行代码
    ,nvl(n.party_agent_account, o.party_agent_account) as party_agent_account -- 代理行账号
    ,nvl(n.party_code_type, o.party_code_type) as party_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,nvl(n.party_code_dss, o.party_code_dss) as party_code_dss -- 交易主体代码编码集合名称
    ,nvl(n.party_code, o.party_code) as party_code -- 交易主体代码
    ,nvl(n.party_account, o.party_account) as party_account -- 交易主体账号
    ,nvl(n.si_id, o.si_id) as si_id -- 证券结算要素ID
    ,nvl(n.cal_start_date, o.cal_start_date) as cal_start_date -- 计息开始日期
    ,nvl(n.ord_limit_secu_inst_id, o.ord_limit_secu_inst_id) as ord_limit_secu_inst_id -- 审批单限额券指令号
    ,nvl(n.estd_volume, o.estd_volume) as estd_volume -- 预计数量
    ,nvl(n.estd_amount, o.estd_amount) as estd_amount -- 预计面额
    ,nvl(n.is_calc_tax_4_prft_trd, o.is_calc_tax_4_prft_trd) as is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,nvl(n.module_type, o.module_type) as module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,nvl(n.party_pset_name, o.party_pset_name) as party_pset_name -- 结算场所名称
    ,nvl(n.volume_geninst, o.volume_geninst) as volume_geninst -- 生成指令时持仓数量
    ,nvl(n.custom_dim1, o.custom_dim1) as custom_dim1 -- 扩展维度1
    ,nvl(n.xcc_module_type, o.xcc_module_type) as xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,nvl(n.is_editable, o.is_editable) as is_editable -- 前台是否可修改
    ,nvl(n.memo_secu, o.memo_secu) as memo_secu -- 理论实收付备注信息
    ,nvl(n.dtl_due_type, o.dtl_due_type) as dtl_due_type -- 明细due类型
    ,case when
            n.secu_inst_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.secu_inst_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.secu_inst_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_set_instruction_secu_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_set_instruction_secu where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.secu_inst_id = n.secu_inst_id
where (
        o.secu_inst_id is null
    )
    or (
        n.secu_inst_id is null
    )
    or (
        o.secu_inst_grp_id <> n.secu_inst_grp_id
        or o.inst_id <> n.inst_id
        or o.biz_type <> n.biz_type
        or o.direction <> n.direction
        or o.trade_grp_id <> n.trade_grp_id
        or o.secu_acct_id <> n.secu_acct_id
        or o.ext_secu_acct_id <> n.ext_secu_acct_id
        or o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.currency <> n.currency
        or o.real_fee <> n.real_fee
        or o.estd_ai <> n.estd_ai
        or o.received_ai <> n.received_ai
        or o.estd_cp <> n.estd_cp
        or o.real_ai <> n.real_ai
        or o.real_cp <> n.real_cp
        or o.due_ai <> n.due_ai
        or o.due_cp <> n.due_cp
        or o.prft_fee <> n.prft_fee
        or o.is_remain_due_ai <> n.is_remain_due_ai
        or o.is_remain_due_cp <> n.is_remain_due_cp
        or o.volume <> n.volume
        or o.freeze_volume <> n.freeze_volume
        or o.is_fixed <> n.is_fixed
        or o.cal_date <> n.cal_date
        or o.set_date <> n.set_date
        or o.set_finish_date <> n.set_finish_date
        or o.i_name <> n.i_name
        or o.p_class <> n.p_class
        or o.cost <> n.cost
        or o.cost_ai_his_real <> n.cost_ai_his_real
        or o.zzd_acct_code <> n.zzd_acct_code
        or o.party_zzd_acct_code <> n.party_zzd_acct_code
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.confirm_time <> n.confirm_time
        or o.confirm_user <> n.confirm_user
        or o.account_time <> n.account_time
        or o.account_user <> n.account_user
        or o.memo <> n.memo
        or o.amount <> n.amount
        or o.close_trade_id <> n.close_trade_id
        or o.blc_state <> n.blc_state
        or o.acctg_state <> n.acctg_state
        or o.estd_fee <> n.estd_fee
        or o.fee <> n.fee
        or o.opr_state <> n.opr_state
        or o.secu_inst_setgrp_id <> n.secu_inst_setgrp_id
        or o.his_flag <> n.his_flag
        or o.his_secu_inst_id <> n.his_secu_inst_id
        or o.his_set_finish_date <> n.his_set_finish_date
        or o.acctg_inst_id <> n.acctg_inst_id
        or o.cancel_flag <> n.cancel_flag
        or o.volume_termcur <> n.volume_termcur
        or o.amount_termcur <> n.amount_termcur
        or o.estd_cp_termcur <> n.estd_cp_termcur
        or o.real_cp_termcur <> n.real_cp_termcur
        or o.amrt_method <> n.amrt_method
        or o.real_margin <> n.real_margin
        or o.fpml <> n.fpml
        or o.is_impair <> n.is_impair
        or o.is_theory_acct <> n.is_theory_acct
        or o.is_theory_blc <> n.is_theory_blc
        or o.cl_status <> n.cl_status
        or o.party_pset <> n.party_pset
        or o.party_pset_country <> n.party_pset_country
        or o.party_agent_code_type <> n.party_agent_code_type
        or o.party_agent_code_dss <> n.party_agent_code_dss
        or o.party_agent_code <> n.party_agent_code
        or o.party_agent_account <> n.party_agent_account
        or o.party_code_type <> n.party_code_type
        or o.party_code_dss <> n.party_code_dss
        or o.party_code <> n.party_code
        or o.party_account <> n.party_account
        or o.si_id <> n.si_id
        or o.cal_start_date <> n.cal_start_date
        or o.ord_limit_secu_inst_id <> n.ord_limit_secu_inst_id
        or o.estd_volume <> n.estd_volume
        or o.estd_amount <> n.estd_amount
        or o.is_calc_tax_4_prft_trd <> n.is_calc_tax_4_prft_trd
        or o.module_type <> n.module_type
        or o.party_pset_name <> n.party_pset_name
        or o.volume_geninst <> n.volume_geninst
        or o.custom_dim1 <> n.custom_dim1
        or o.xcc_module_type <> n.xcc_module_type
        or o.is_editable <> n.is_editable
        or o.memo_secu <> n.memo_secu
        or o.dtl_due_type <> n.dtl_due_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_secu_cl(
            secu_inst_id -- 证券结算指令序号
            ,secu_inst_grp_id -- 合并券指令号
            ,inst_id -- 主结算指令序号
            ,biz_type -- 业务类型,
            ,direction -- 交收方向
            ,trade_grp_id -- 核算交易组合
            ,secu_acct_id -- 内部证券账户ID
            ,ext_secu_acct_id -- 外部证券账户ID
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,currency -- 币种
            ,real_fee -- 费用成本变动
            ,estd_ai -- 应计利息成本变动
            ,received_ai -- 已收本周期利息（开仓的一方时候有用）
            ,estd_cp -- 净价金额
            ,real_ai -- 实际应计利息
            ,real_cp -- 实际净价金额
            ,due_ai -- 应收未收利息
            ,due_cp -- 应收未收本金
            ,prft_fee -- 损益费用
            ,is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
            ,is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
            ,volume -- 余额数量变动
            ,freeze_volume -- 冻结数量
            ,is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
            ,cal_date -- 计算截止日期,不调整的理论支付日
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,i_name -- 金融工具简称
            ,p_class -- 产品分类
            ,cost -- 全价成本变动
            ,cost_ai_his_real -- 应收未收利息
            ,zzd_acct_code -- 本方中债登托管账号
            ,party_zzd_acct_code -- 对手中债登托管账号
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 经办人
            ,confirm_time -- 非首期指令确认时间
            ,confirm_user -- 非首期指令确认人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,amount -- 以元为单位的面额
            ,close_trade_id -- 指定平仓时，指定核算的交易号
            ,blc_state -- 计算截止日期,不调整的理论支付日
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,estd_fee -- 理论费用
            ,fee -- 费用成本
            ,opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
            ,secu_inst_setgrp_id -- 合并收付号
            ,his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
            ,his_secu_inst_id -- 历史券指令号
            ,his_set_finish_date -- 历史实际结算日期
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,volume_termcur -- 货币对反向数量
            ,amount_termcur -- 货币对反向面额
            ,estd_cp_termcur -- 货币对反向预计净价金额
            ,real_cp_termcur -- 货币对反向实际净价金额
            ,amrt_method -- 摊销算法
            ,real_margin -- 期货保证金
            ,fpml -- 金融工具条款
            ,is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
            ,is_theory_acct -- 是否已做过理论核算
            ,is_theory_blc -- 是否已做权责业务
            ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
            ,party_pset -- 结算场所代码
            ,party_pset_country -- 国家代码
            ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,party_agent_code_dss -- 代理行代码编码集合名称
            ,party_agent_code -- 代理行代码
            ,party_agent_account -- 代理行账号
            ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,party_code_dss -- 交易主体代码编码集合名称
            ,party_code -- 交易主体代码
            ,party_account -- 交易主体账号
            ,si_id -- 证券结算要素ID
            ,cal_start_date -- 计息开始日期
            ,ord_limit_secu_inst_id -- 审批单限额券指令号
            ,estd_volume -- 预计数量
            ,estd_amount -- 预计面额
            ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,party_pset_name -- 结算场所名称
            ,volume_geninst -- 生成指令时持仓数量
            ,custom_dim1 -- 扩展维度1
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,memo_secu -- 理论实收付备注信息
            ,dtl_due_type -- 明细due类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_secu_op(
            secu_inst_id -- 证券结算指令序号
            ,secu_inst_grp_id -- 合并券指令号
            ,inst_id -- 主结算指令序号
            ,biz_type -- 业务类型,
            ,direction -- 交收方向
            ,trade_grp_id -- 核算交易组合
            ,secu_acct_id -- 内部证券账户ID
            ,ext_secu_acct_id -- 外部证券账户ID
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,currency -- 币种
            ,real_fee -- 费用成本变动
            ,estd_ai -- 应计利息成本变动
            ,received_ai -- 已收本周期利息（开仓的一方时候有用）
            ,estd_cp -- 净价金额
            ,real_ai -- 实际应计利息
            ,real_cp -- 实际净价金额
            ,due_ai -- 应收未收利息
            ,due_cp -- 应收未收本金
            ,prft_fee -- 损益费用
            ,is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
            ,is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
            ,volume -- 余额数量变动
            ,freeze_volume -- 冻结数量
            ,is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
            ,cal_date -- 计算截止日期,不调整的理论支付日
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,i_name -- 金融工具简称
            ,p_class -- 产品分类
            ,cost -- 全价成本变动
            ,cost_ai_his_real -- 应收未收利息
            ,zzd_acct_code -- 本方中债登托管账号
            ,party_zzd_acct_code -- 对手中债登托管账号
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 经办人
            ,confirm_time -- 非首期指令确认时间
            ,confirm_user -- 非首期指令确认人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,amount -- 以元为单位的面额
            ,close_trade_id -- 指定平仓时，指定核算的交易号
            ,blc_state -- 计算截止日期,不调整的理论支付日
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,estd_fee -- 理论费用
            ,fee -- 费用成本
            ,opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
            ,secu_inst_setgrp_id -- 合并收付号
            ,his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
            ,his_secu_inst_id -- 历史券指令号
            ,his_set_finish_date -- 历史实际结算日期
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,volume_termcur -- 货币对反向数量
            ,amount_termcur -- 货币对反向面额
            ,estd_cp_termcur -- 货币对反向预计净价金额
            ,real_cp_termcur -- 货币对反向实际净价金额
            ,amrt_method -- 摊销算法
            ,real_margin -- 期货保证金
            ,fpml -- 金融工具条款
            ,is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
            ,is_theory_acct -- 是否已做过理论核算
            ,is_theory_blc -- 是否已做权责业务
            ,cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
            ,party_pset -- 结算场所代码
            ,party_pset_country -- 国家代码
            ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
            ,party_agent_code_dss -- 代理行代码编码集合名称
            ,party_agent_code -- 代理行代码
            ,party_agent_account -- 代理行账号
            ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
            ,party_code_dss -- 交易主体代码编码集合名称
            ,party_code -- 交易主体代码
            ,party_account -- 交易主体账号
            ,si_id -- 证券结算要素ID
            ,cal_start_date -- 计息开始日期
            ,ord_limit_secu_inst_id -- 审批单限额券指令号
            ,estd_volume -- 预计数量
            ,estd_amount -- 预计面额
            ,is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,party_pset_name -- 结算场所名称
            ,volume_geninst -- 生成指令时持仓数量
            ,custom_dim1 -- 扩展维度1
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,memo_secu -- 理论实收付备注信息
            ,dtl_due_type -- 明细due类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.secu_inst_id -- 证券结算指令序号
    ,o.secu_inst_grp_id -- 合并券指令号
    ,o.inst_id -- 主结算指令序号
    ,o.biz_type -- 业务类型,
    ,o.direction -- 交收方向
    ,o.trade_grp_id -- 核算交易组合
    ,o.secu_acct_id -- 内部证券账户ID
    ,o.ext_secu_acct_id -- 外部证券账户ID
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
    ,o.m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,o.currency -- 币种
    ,o.real_fee -- 费用成本变动
    ,o.estd_ai -- 应计利息成本变动
    ,o.received_ai -- 已收本周期利息（开仓的一方时候有用）
    ,o.estd_cp -- 净价金额
    ,o.real_ai -- 实际应计利息
    ,o.real_cp -- 实际净价金额
    ,o.due_ai -- 应收未收利息
    ,o.due_cp -- 应收未收本金
    ,o.prft_fee -- 损益费用
    ,o.is_remain_due_ai -- 是否保留应收未收利息 1:保留;2:不保留
    ,o.is_remain_due_cp -- 是否保留应收未收本金 1:保留;2:不保留
    ,o.volume -- 余额数量变动
    ,o.freeze_volume -- 冻结数量
    ,o.is_fixed -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
    ,o.cal_date -- 计算截止日期,不调整的理论支付日
    ,o.set_date -- 结算日期
    ,o.set_finish_date -- 实际结算日期
    ,o.i_name -- 金融工具简称
    ,o.p_class -- 产品分类
    ,o.cost -- 全价成本变动
    ,o.cost_ai_his_real -- 应收未收利息
    ,o.zzd_acct_code -- 本方中债登托管账号
    ,o.party_zzd_acct_code -- 对手中债登托管账号
    ,o.create_time -- 创建时间
    ,o.update_time -- 最后修改时间
    ,o.update_user -- 经办人
    ,o.confirm_time -- 非首期指令确认时间
    ,o.confirm_user -- 非首期指令确认人
    ,o.account_time -- 复核时间
    ,o.account_user -- 复核人员
    ,o.memo -- 备注
    ,o.amount -- 以元为单位的面额
    ,o.close_trade_id -- 指定平仓时，指定核算的交易号
    ,o.blc_state -- 计算截止日期,不调整的理论支付日
    ,o.acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,o.estd_fee -- 理论费用
    ,o.fee -- 费用成本
    ,o.opr_state -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；   -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
    ,o.secu_inst_setgrp_id -- 合并收付号
    ,o.his_flag -- （0-正常指令、1-补录指令、2-撤销指令）
    ,o.his_secu_inst_id -- 历史券指令号
    ,o.his_set_finish_date -- 历史实际结算日期
    ,o.acctg_inst_id -- 记账主指令号
    ,o.cancel_flag -- 1:表示限额反向指令，其它：正向指令
    ,o.volume_termcur -- 货币对反向数量
    ,o.amount_termcur -- 货币对反向面额
    ,o.estd_cp_termcur -- 货币对反向预计净价金额
    ,o.real_cp_termcur -- 货币对反向实际净价金额
    ,o.amrt_method -- 摊销算法
    ,o.real_margin -- 期货保证金
    ,o.fpml -- 金融工具条款
    ,o.is_impair -- 是否减值业务:1-核算减值对象，0-核算非减值对象
    ,o.is_theory_acct -- 是否已做过理论核算
    ,o.is_theory_blc -- 是否已做权责业务
    ,o.cl_status -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,o.party_pset -- 结算场所代码
    ,o.party_pset_country -- 国家代码
    ,o.party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,o.party_agent_code_dss -- 代理行代码编码集合名称
    ,o.party_agent_code -- 代理行代码
    ,o.party_agent_account -- 代理行账号
    ,o.party_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,o.party_code_dss -- 交易主体代码编码集合名称
    ,o.party_code -- 交易主体代码
    ,o.party_account -- 交易主体账号
    ,o.si_id -- 证券结算要素ID
    ,o.cal_start_date -- 计息开始日期
    ,o.ord_limit_secu_inst_id -- 审批单限额券指令号
    ,o.estd_volume -- 预计数量
    ,o.estd_amount -- 预计面额
    ,o.is_calc_tax_4_prft_trd -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,o.module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,o.party_pset_name -- 结算场所名称
    ,o.volume_geninst -- 生成指令时持仓数量
    ,o.custom_dim1 -- 扩展维度1
    ,o.xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,o.is_editable -- 前台是否可修改
    ,o.memo_secu -- 理论实收付备注信息
    ,o.dtl_due_type -- 明细due类型
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
from ${iol_schema}.ibms_ttrd_set_instruction_secu_bk o
    left join ${iol_schema}.ibms_ttrd_set_instruction_secu_op n
        on
            o.secu_inst_id = n.secu_inst_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_set_instruction_secu_cl d
        on
            o.secu_inst_id = d.secu_inst_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_set_instruction_secu;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_set_instruction_secu') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_set_instruction_secu drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_set_instruction_secu add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_set_instruction_secu exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_secu_cl;
alter table ${iol_schema}.ibms_ttrd_set_instruction_secu exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_set_instruction_secu_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction_secu',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
