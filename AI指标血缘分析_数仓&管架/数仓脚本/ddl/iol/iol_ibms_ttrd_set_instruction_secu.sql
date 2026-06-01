/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction_secu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction_secu
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction_secu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_secu(
    secu_inst_id number(16,0) -- 证券结算指令序号
    ,secu_inst_grp_id number(16,0) -- 合并券指令号
    ,inst_id number(16,0) -- 主结算指令序号
    ,biz_type varchar2(45) -- 业务类型,
    ,direction varchar2(15) -- 交收方向
    ,trade_grp_id varchar2(45) -- 核算交易组合
    ,secu_acct_id varchar2(45) -- 内部证券账户id
    ,ext_secu_acct_id varchar2(45) -- 外部证券账户id
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型 spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) ;spt_abs:资产证券化产品(abs、mbs、cdo) ;spt_cb:可转换债券 ;spt_db:债务 ;spt_ibor:同业拆借 ;spt_ibdepo:同业存款 ;spt_c:现金 ;spt_f1:封闭式基金 ;spt_f2:开放式基金 ;spt_f3:交易所交易基金 ;spt_stg_1:期限套利 ;spt_stg_2:跨期套利 ;spt_pg:配股 ;spt_ir:利率 ;spt_cp:商业票据 ;spt_ded:活期存款 ;spt_ntd:通知存款(1天通知存款、7天通知存款) ;spt_tmd:定期存款(3个月、半年、1年、3年、5年) ;spt_ngd:协议存款(期限确定，利率协商确定的存款) ;spt_repo:回购 ;spt_xr:汇率
    ,m_type varchar2(30) -- 市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间
    ,currency varchar2(15) -- 币种
    ,real_fee number(31,4) -- 费用成本变动
    ,estd_ai number(31,4) -- 应计利息成本变动
    ,received_ai number(31,4) -- 已收本周期利息（开仓的一方时候有用）
    ,estd_cp number(31,4) -- 净价金额
    ,real_ai number(31,4) -- 实际应计利息
    ,real_cp number(31,4) -- 实际净价金额
    ,due_ai number(38,4) -- 应收未收利息
    ,due_cp number(38,4) -- 应收未收本金
    ,prft_fee number(38,4) -- 损益费用
    ,is_remain_due_ai number(4,0) -- 是否保留应收未收利息 1:保留;2:不保留
    ,is_remain_due_cp number(4,0) -- 是否保留应收未收本金 1:保留;2:不保留
    ,volume number(38,4) -- 余额数量变动
    ,freeze_volume number(38,4) -- 冻结数量
    ,is_fixed number(22) -- 0-现金流未确定，1-现金流已确定，理论值，不能做复核
    ,cal_date varchar2(15) -- 计算截止日期,不调整的理论支付日
    ,set_date varchar2(15) -- 结算日期
    ,set_finish_date varchar2(15) -- 实际结算日期
    ,i_name varchar2(300) -- 金融工具简称
    ,p_class varchar2(150) -- 产品分类
    ,cost number(31,4) -- 全价成本变动
    ,cost_ai_his_real number(31,4) -- 应收未收利息
    ,zzd_acct_code varchar2(150) -- 本方中债登托管账号
    ,party_zzd_acct_code varchar2(150) -- 对手中债登托管账号
    ,create_time varchar2(29) -- 创建时间
    ,update_time varchar2(35) -- 最后修改时间
    ,update_user varchar2(150) -- 经办人
    ,confirm_time varchar2(29) -- 非首期指令确认时间
    ,confirm_user varchar2(30) -- 非首期指令确认人
    ,account_time varchar2(29) -- 复核时间
    ,account_user varchar2(30) -- 复核人员
    ,memo varchar2(750) -- 备注
    ,amount number(31,4) -- 以元为单位的面额
    ,close_trade_id varchar2(45) -- 指定平仓时，指定核算的交易号
    ,blc_state number(22) -- 计算截止日期,不调整的理论支付日
    ,acctg_state number(22) -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,estd_fee number(31,4) -- 理论费用
    ,fee number(31,4) -- 费用成本
    ,opr_state number(22) -- 操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；    -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令
    ,secu_inst_setgrp_id number(16,0) -- 合并收付号
    ,his_flag number(22) -- （0-正常指令、1-补录指令、2-撤销指令）
    ,his_secu_inst_id number(16,0) -- 历史券指令号
    ,his_set_finish_date varchar2(15) -- 历史实际结算日期
    ,acctg_inst_id number(16,0) -- 记账主指令号
    ,cancel_flag varchar2(2) -- 1:表示限额反向指令，其它：正向指令
    ,volume_termcur number(31,4) -- 货币对反向数量
    ,amount_termcur number(31,4) -- 货币对反向面额
    ,estd_cp_termcur number(31,4) -- 货币对反向预计净价金额
    ,real_cp_termcur number(31,4) -- 货币对反向实际净价金额
    ,amrt_method number(22) -- 摊销算法
    ,real_margin number(31,8) -- 期货保证金
    ,fpml varchar2(4000) -- 金融工具条款
    ,is_impair varchar2(2) -- 是否减值业务:1-核算减值对象，0-核算非减值对象
    ,is_theory_acct varchar2(2) -- 是否已做过理论核算
    ,is_theory_blc varchar2(2) -- 是否已做权责业务
    ,cl_status number(3,0) -- 占用状态-20代表冻结或者实占-30代表冻结转实占
    ,party_pset varchar2(33) -- 结算场所代码
    ,party_pset_country varchar2(15) -- 国家代码
    ,party_agent_code_type varchar2(2) -- 代理行代码类型,1:bic,2:dss
    ,party_agent_code_dss varchar2(270) -- 代理行代码编码集合名称
    ,party_agent_code varchar2(420) -- 代理行代码
    ,party_agent_account varchar2(150) -- 代理行账号
    ,party_code_type varchar2(2) -- 交易主体代码类型,1:bic,2:dss
    ,party_code_dss varchar2(270) -- 交易主体代码编码集合名称
    ,party_code varchar2(420) -- 交易主体代码
    ,party_account varchar2(150) -- 交易主体账号
    ,si_id number(16,0) -- 证券结算要素id
    ,cal_start_date varchar2(15) -- 计息开始日期
    ,ord_limit_secu_inst_id number(31,0) -- 审批单限额券指令号
    ,estd_volume number(38,4) -- 预计数量
    ,estd_amount number(31,4) -- 预计面额
    ,is_calc_tax_4_prft_trd number(22) -- 卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
    ,module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,party_pset_name varchar2(75) -- 结算场所名称
    ,volume_geninst number(31,8) -- 生成指令时持仓数量
    ,custom_dim1 varchar2(300) -- 扩展维度1
    ,xcc_module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable varchar2(2) -- 前台是否可修改
    ,memo_secu varchar2(750) -- 理论实收付备注信息
    ,dtl_due_type varchar2(45) -- 明细due类型
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
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_secu to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction_secu is '券指令表';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.secu_inst_id is '证券结算指令序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.secu_inst_grp_id is '合并券指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.inst_id is '主结算指令序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.biz_type is '业务类型,';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.direction is '交收方向';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.trade_grp_id is '核算交易组合';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.secu_acct_id is '内部证券账户id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.ext_secu_acct_id is '外部证券账户id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.a_type is '资产类型 spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) ;spt_abs:资产证券化产品(abs、mbs、cdo) ;spt_cb:可转换债券 ;spt_db:债务 ;spt_ibor:同业拆借 ;spt_ibdepo:同业存款 ;spt_c:现金 ;spt_f1:封闭式基金 ;spt_f2:开放式基金 ;spt_f3:交易所交易基金 ;spt_stg_1:期限套利 ;spt_stg_2:跨期套利 ;spt_pg:配股 ;spt_ir:利率 ;spt_cp:商业票据 ;spt_ded:活期存款 ;spt_ntd:通知存款(1天通知存款、7天通知存款) ;spt_tmd:定期存款(3个月、半年、1年、3年、5年) ;spt_ngd:协议存款(期限确定，利率协商确定的存款) ;spt_repo:回购 ;spt_xr:汇率';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.m_type is '市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.real_fee is '费用成本变动';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_ai is '应计利息成本变动';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.received_ai is '已收本周期利息（开仓的一方时候有用）';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_cp is '净价金额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.real_ai is '实际应计利息';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.real_cp is '实际净价金额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.due_ai is '应收未收利息';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.due_cp is '应收未收本金';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.prft_fee is '损益费用';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_remain_due_ai is '是否保留应收未收利息 1:保留;2:不保留';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_remain_due_cp is '是否保留应收未收本金 1:保留;2:不保留';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.volume is '余额数量变动';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.freeze_volume is '冻结数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_fixed is '0-现金流未确定，1-现金流已确定，理论值，不能做复核';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cal_date is '计算截止日期,不调整的理论支付日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.set_date is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.set_finish_date is '实际结算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.i_name is '金融工具简称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.p_class is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cost is '全价成本变动';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cost_ai_his_real is '应收未收利息';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.zzd_acct_code is '本方中债登托管账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_zzd_acct_code is '对手中债登托管账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.update_time is '最后修改时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.update_user is '经办人';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.confirm_time is '非首期指令确认时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.confirm_user is '非首期指令确认人';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.account_user is '复核人员';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.amount is '以元为单位的面额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.close_trade_id is '指定平仓时，指定核算的交易号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.blc_state is '计算截止日期,不调整的理论支付日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.acctg_state is '0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_fee is '理论费用';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.fee is '费用成本';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.opr_state is '操作状态；-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束；    -10：限额指令 未提交;-11:限额指令 已提交;-17:额指令 无效 计算限额时不被统计;-15:限额指令 反向统计;-16:结算完成后有效的限额指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.secu_inst_setgrp_id is '合并收付号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.his_flag is '（0-正常指令、1-补录指令、2-撤销指令）';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.his_secu_inst_id is '历史券指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.his_set_finish_date is '历史实际结算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.acctg_inst_id is '记账主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cancel_flag is '1:表示限额反向指令，其它：正向指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.volume_termcur is '货币对反向数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.amount_termcur is '货币对反向面额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_cp_termcur is '货币对反向预计净价金额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.real_cp_termcur is '货币对反向实际净价金额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.amrt_method is '摊销算法';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.real_margin is '期货保证金';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.fpml is '金融工具条款';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_impair is '是否减值业务:1-核算减值对象，0-核算非减值对象';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_theory_acct is '是否已做过理论核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_theory_blc is '是否已做权责业务';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cl_status is '占用状态-20代表冻结或者实占-30代表冻结转实占';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_pset is '结算场所代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_pset_country is '国家代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_agent_code_type is '代理行代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_agent_code_dss is '代理行代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_agent_code is '代理行代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_agent_account is '代理行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_code_type is '交易主体代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_code_dss is '交易主体代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_code is '交易主体代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_account is '交易主体账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.si_id is '证券结算要素id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.cal_start_date is '计息开始日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.ord_limit_secu_inst_id is '审批单限额券指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_volume is '预计数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.estd_amount is '预计面额';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_calc_tax_4_prft_trd is '卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.party_pset_name is '结算场所名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.volume_geninst is '生成指令时持仓数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.xcc_module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.is_editable is '前台是否可修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.memo_secu is '理论实收付备注信息';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.dtl_due_type is '明细due类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_secu.etl_timestamp is 'ETL处理时间戳';
