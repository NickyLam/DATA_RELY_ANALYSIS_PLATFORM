/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction
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
create table ${iol_schema}.ibms_ttrd_set_instruction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_set_instruction
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction where 0=1;

create table ${iol_schema}.ibms_ttrd_set_instruction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_cl(
            inst_id -- 结算指令序号
            ,trade_id -- 内部交易号
            ,inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
            ,inst_grp_id -- 父指令号
            ,trd_type -- 交易业务类型一致
            ,set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
            ,theory_set_date -- 理论清算日期
            ,real_set_date -- 实际结算的日期
            ,h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
            ,party_id -- 交易对手主键
            ,party_name -- 交易对手全称
            ,order_id -- 审批单号
            ,is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
            ,bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
            ,bj_state -- 簿记状态 0:没有簿记
            ,ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
            ,exe_market -- 执行市场，中债直联时有用
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 最后修改人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,update_user_id -- 最后修改人员id
            ,cal_date -- 理论结算日
            ,ref_cash_inst_id -- 关联的资金指令ID
            ,ref_secu_inst_id -- 关联的券指令ID
            ,inst_setgrp_id -- 合并收付号
            ,state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
            ,operator_id -- 经办人ID
            ,operator_name -- 经办人
            ,print_times -- 打印次数
            ,due_order -- 挂账顺序
            ,due_obj_key -- 挂账序号
            ,generate_type -- 指令生成类型
            ,ref_inst_id -- 关联主指令号
            ,is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
            ,real_account_inst_id -- 实际核算主指令号
            ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
            ,his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
            ,cash_acct_id -- 内部资金账户
            ,his_inst_id -- 调账主指令号
            ,his_ref_inst_id -- 历史关联主指令号
            ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
            ,orddate -- 交易日
            ,condate -- 确认日期
            ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
            ,settlemode -- 结算类型
            ,host_market -- 托管场所
            ,spv_id -- SPV信息ID
            ,process_type -- 处理类型 0：普通 -1：临时处理
            ,clearing_date -- 清算日
            ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
            ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
            ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
            ,is_period_inst -- 0：非存续期指令 1：存续期指令
            ,tsk_id -- 任务号
            ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
            ,bind_inst_id -- 绑定id
            ,trader -- 交易员
            ,xcc_limit_type -- 限额指令类型
            ,exh_extordid -- 委托编号
            ,create_user_id -- 创建人员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_op(
            inst_id -- 结算指令序号
            ,trade_id -- 内部交易号
            ,inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
            ,inst_grp_id -- 父指令号
            ,trd_type -- 交易业务类型一致
            ,set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
            ,theory_set_date -- 理论清算日期
            ,real_set_date -- 实际结算的日期
            ,h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
            ,party_id -- 交易对手主键
            ,party_name -- 交易对手全称
            ,order_id -- 审批单号
            ,is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
            ,bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
            ,bj_state -- 簿记状态 0:没有簿记
            ,ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
            ,exe_market -- 执行市场，中债直联时有用
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 最后修改人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,update_user_id -- 最后修改人员id
            ,cal_date -- 理论结算日
            ,ref_cash_inst_id -- 关联的资金指令ID
            ,ref_secu_inst_id -- 关联的券指令ID
            ,inst_setgrp_id -- 合并收付号
            ,state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
            ,operator_id -- 经办人ID
            ,operator_name -- 经办人
            ,print_times -- 打印次数
            ,due_order -- 挂账顺序
            ,due_obj_key -- 挂账序号
            ,generate_type -- 指令生成类型
            ,ref_inst_id -- 关联主指令号
            ,is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
            ,real_account_inst_id -- 实际核算主指令号
            ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
            ,his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
            ,cash_acct_id -- 内部资金账户
            ,his_inst_id -- 调账主指令号
            ,his_ref_inst_id -- 历史关联主指令号
            ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
            ,orddate -- 交易日
            ,condate -- 确认日期
            ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
            ,settlemode -- 结算类型
            ,host_market -- 托管场所
            ,spv_id -- SPV信息ID
            ,process_type -- 处理类型 0：普通 -1：临时处理
            ,clearing_date -- 清算日
            ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
            ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
            ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
            ,is_period_inst -- 0：非存续期指令 1：存续期指令
            ,tsk_id -- 任务号
            ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
            ,bind_inst_id -- 绑定id
            ,trader -- 交易员
            ,xcc_limit_type -- 限额指令类型
            ,exh_extordid -- 委托编号
            ,create_user_id -- 创建人员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inst_id, o.inst_id) as inst_id -- 结算指令序号
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 内部交易号
    ,nvl(n.inst_type, o.inst_type) as inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
    ,nvl(n.inst_grp_id, o.inst_grp_id) as inst_grp_id -- 父指令号
    ,nvl(n.trd_type, o.trd_type) as trd_type -- 交易业务类型一致
    ,nvl(n.set_type, o.set_type) as set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
    ,nvl(n.theory_set_date, o.theory_set_date) as theory_set_date -- 理论清算日期
    ,nvl(n.real_set_date, o.real_set_date) as real_set_date -- 实际结算的日期
    ,nvl(n.h_m_type, o.h_m_type) as h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,nvl(n.h_a_type, o.h_a_type) as h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
    ,nvl(n.h_i_code, o.h_i_code) as h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
    ,nvl(n.party_id, o.party_id) as party_id -- 交易对手主键
    ,nvl(n.party_name, o.party_name) as party_name -- 交易对手全称
    ,nvl(n.order_id, o.order_id) as order_id -- 审批单号
    ,nvl(n.is_theory_payment, o.is_theory_payment) as is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
    ,nvl(n.bj_market, o.bj_market) as bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
    ,nvl(n.bj_state, o.bj_state) as bj_state -- 簿记状态 0:没有簿记
    ,nvl(n.ext_ord_id, o.ext_ord_id) as ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
    ,nvl(n.exe_market, o.exe_market) as exe_market -- 执行市场，中债直联时有用
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 最后修改时间
    ,nvl(n.update_user, o.update_user) as update_user -- 最后修改人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人员
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 最后修改人员id
    ,nvl(n.cal_date, o.cal_date) as cal_date -- 理论结算日
    ,nvl(n.ref_cash_inst_id, o.ref_cash_inst_id) as ref_cash_inst_id -- 关联的资金指令ID
    ,nvl(n.ref_secu_inst_id, o.ref_secu_inst_id) as ref_secu_inst_id -- 关联的券指令ID
    ,nvl(n.inst_setgrp_id, o.inst_setgrp_id) as inst_setgrp_id -- 合并收付号
    ,nvl(n.state, o.state) as state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
    ,nvl(n.operator_id, o.operator_id) as operator_id -- 经办人ID
    ,nvl(n.operator_name, o.operator_name) as operator_name -- 经办人
    ,nvl(n.print_times, o.print_times) as print_times -- 打印次数
    ,nvl(n.due_order, o.due_order) as due_order -- 挂账顺序
    ,nvl(n.due_obj_key, o.due_obj_key) as due_obj_key -- 挂账序号
    ,nvl(n.generate_type, o.generate_type) as generate_type -- 指令生成类型
    ,nvl(n.ref_inst_id, o.ref_inst_id) as ref_inst_id -- 关联主指令号
    ,nvl(n.is_real_acctg, o.is_real_acctg) as is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
    ,nvl(n.real_account_inst_id, o.real_account_inst_id) as real_account_inst_id -- 实际核算主指令号
    ,nvl(n.is_unknown_price, o.is_unknown_price) as is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
    ,nvl(n.his_flag, o.his_flag) as his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
    ,nvl(n.cash_acct_id, o.cash_acct_id) as cash_acct_id -- 内部资金账户
    ,nvl(n.his_inst_id, o.his_inst_id) as his_inst_id -- 调账主指令号
    ,nvl(n.his_ref_inst_id, o.his_ref_inst_id) as his_ref_inst_id -- 历史关联主指令号
    ,nvl(n.is_operator_checked, o.is_operator_checked) as is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,nvl(n.orddate, o.orddate) as orddate -- 交易日
    ,nvl(n.condate, o.condate) as condate -- 确认日期
    ,nvl(n.is_match, o.is_match) as is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,nvl(n.settlemode, o.settlemode) as settlemode -- 结算类型
    ,nvl(n.host_market, o.host_market) as host_market -- 托管场所
    ,nvl(n.spv_id, o.spv_id) as spv_id -- SPV信息ID
    ,nvl(n.process_type, o.process_type) as process_type -- 处理类型 0：普通 -1：临时处理
    ,nvl(n.clearing_date, o.clearing_date) as clearing_date -- 清算日
    ,nvl(n.acctg_estd_completed, o.acctg_estd_completed) as acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
    ,nvl(n.acctg_real_completed, o.acctg_real_completed) as acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
    ,nvl(n.clearing_completed, o.clearing_completed) as clearing_completed -- 清算是否完成 0：未完成， 1 已完成
    ,nvl(n.is_period_inst, o.is_period_inst) as is_period_inst -- 0：非存续期指令 1：存续期指令
    ,nvl(n.tsk_id, o.tsk_id) as tsk_id -- 任务号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,nvl(n.bind_inst_id, o.bind_inst_id) as bind_inst_id -- 绑定id
    ,nvl(n.trader, o.trader) as trader -- 交易员
    ,nvl(n.xcc_limit_type, o.xcc_limit_type) as xcc_limit_type -- 限额指令类型
    ,nvl(n.exh_extordid, o.exh_extordid) as exh_extordid -- 委托编号
    ,nvl(n.create_user_id, o.create_user_id) as create_user_id -- 创建人员id
    ,case when
            n.inst_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inst_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inst_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_set_instruction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_set_instruction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inst_id = n.inst_id
where (
        o.inst_id is null
    )
    or (
        n.inst_id is null
    )
    or (
        o.trade_id <> n.trade_id
        or o.inst_type <> n.inst_type
        or o.inst_grp_id <> n.inst_grp_id
        or o.trd_type <> n.trd_type
        or o.set_type <> n.set_type
        or o.theory_set_date <> n.theory_set_date
        or o.real_set_date <> n.real_set_date
        or o.h_m_type <> n.h_m_type
        or o.h_a_type <> n.h_a_type
        or o.h_i_code <> n.h_i_code
        or o.party_id <> n.party_id
        or o.party_name <> n.party_name
        or o.order_id <> n.order_id
        or o.is_theory_payment <> n.is_theory_payment
        or o.bj_market <> n.bj_market
        or o.bj_state <> n.bj_state
        or o.ext_ord_id <> n.ext_ord_id
        or o.exe_market <> n.exe_market
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.account_time <> n.account_time
        or o.account_user <> n.account_user
        or o.memo <> n.memo
        or o.update_user_id <> n.update_user_id
        or o.cal_date <> n.cal_date
        or o.ref_cash_inst_id <> n.ref_cash_inst_id
        or o.ref_secu_inst_id <> n.ref_secu_inst_id
        or o.inst_setgrp_id <> n.inst_setgrp_id
        or o.state <> n.state
        or o.operator_id <> n.operator_id
        or o.operator_name <> n.operator_name
        or o.print_times <> n.print_times
        or o.due_order <> n.due_order
        or o.due_obj_key <> n.due_obj_key
        or o.generate_type <> n.generate_type
        or o.ref_inst_id <> n.ref_inst_id
        or o.is_real_acctg <> n.is_real_acctg
        or o.real_account_inst_id <> n.real_account_inst_id
        or o.is_unknown_price <> n.is_unknown_price
        or o.his_flag <> n.his_flag
        or o.cash_acct_id <> n.cash_acct_id
        or o.his_inst_id <> n.his_inst_id
        or o.his_ref_inst_id <> n.his_ref_inst_id
        or o.is_operator_checked <> n.is_operator_checked
        or o.orddate <> n.orddate
        or o.condate <> n.condate
        or o.is_match <> n.is_match
        or o.settlemode <> n.settlemode
        or o.host_market <> n.host_market
        or o.spv_id <> n.spv_id
        or o.process_type <> n.process_type
        or o.clearing_date <> n.clearing_date
        or o.acctg_estd_completed <> n.acctg_estd_completed
        or o.acctg_real_completed <> n.acctg_real_completed
        or o.clearing_completed <> n.clearing_completed
        or o.is_period_inst <> n.is_period_inst
        or o.tsk_id <> n.tsk_id
        or o.approvestatus <> n.approvestatus
        or o.bind_inst_id <> n.bind_inst_id
        or o.trader <> n.trader
        or o.xcc_limit_type <> n.xcc_limit_type
        or o.exh_extordid <> n.exh_extordid
        or o.create_user_id <> n.create_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_cl(
            inst_id -- 结算指令序号
            ,trade_id -- 内部交易号
            ,inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
            ,inst_grp_id -- 父指令号
            ,trd_type -- 交易业务类型一致
            ,set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
            ,theory_set_date -- 理论清算日期
            ,real_set_date -- 实际结算的日期
            ,h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
            ,party_id -- 交易对手主键
            ,party_name -- 交易对手全称
            ,order_id -- 审批单号
            ,is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
            ,bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
            ,bj_state -- 簿记状态 0:没有簿记
            ,ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
            ,exe_market -- 执行市场，中债直联时有用
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 最后修改人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,update_user_id -- 最后修改人员id
            ,cal_date -- 理论结算日
            ,ref_cash_inst_id -- 关联的资金指令ID
            ,ref_secu_inst_id -- 关联的券指令ID
            ,inst_setgrp_id -- 合并收付号
            ,state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
            ,operator_id -- 经办人ID
            ,operator_name -- 经办人
            ,print_times -- 打印次数
            ,due_order -- 挂账顺序
            ,due_obj_key -- 挂账序号
            ,generate_type -- 指令生成类型
            ,ref_inst_id -- 关联主指令号
            ,is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
            ,real_account_inst_id -- 实际核算主指令号
            ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
            ,his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
            ,cash_acct_id -- 内部资金账户
            ,his_inst_id -- 调账主指令号
            ,his_ref_inst_id -- 历史关联主指令号
            ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
            ,orddate -- 交易日
            ,condate -- 确认日期
            ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
            ,settlemode -- 结算类型
            ,host_market -- 托管场所
            ,spv_id -- SPV信息ID
            ,process_type -- 处理类型 0：普通 -1：临时处理
            ,clearing_date -- 清算日
            ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
            ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
            ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
            ,is_period_inst -- 0：非存续期指令 1：存续期指令
            ,tsk_id -- 任务号
            ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
            ,bind_inst_id -- 绑定id
            ,trader -- 交易员
            ,xcc_limit_type -- 限额指令类型
            ,exh_extordid -- 委托编号
            ,create_user_id -- 创建人员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_op(
            inst_id -- 结算指令序号
            ,trade_id -- 内部交易号
            ,inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
            ,inst_grp_id -- 父指令号
            ,trd_type -- 交易业务类型一致
            ,set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
            ,theory_set_date -- 理论清算日期
            ,real_set_date -- 实际结算的日期
            ,h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
            ,h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
            ,h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
            ,party_id -- 交易对手主键
            ,party_name -- 交易对手全称
            ,order_id -- 审批单号
            ,is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
            ,bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
            ,bj_state -- 簿记状态 0:没有簿记
            ,ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
            ,exe_market -- 执行市场，中债直联时有用
            ,create_time -- 创建时间
            ,update_time -- 最后修改时间
            ,update_user -- 最后修改人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,update_user_id -- 最后修改人员id
            ,cal_date -- 理论结算日
            ,ref_cash_inst_id -- 关联的资金指令ID
            ,ref_secu_inst_id -- 关联的券指令ID
            ,inst_setgrp_id -- 合并收付号
            ,state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
            ,operator_id -- 经办人ID
            ,operator_name -- 经办人
            ,print_times -- 打印次数
            ,due_order -- 挂账顺序
            ,due_obj_key -- 挂账序号
            ,generate_type -- 指令生成类型
            ,ref_inst_id -- 关联主指令号
            ,is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
            ,real_account_inst_id -- 实际核算主指令号
            ,is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
            ,his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
            ,cash_acct_id -- 内部资金账户
            ,his_inst_id -- 调账主指令号
            ,his_ref_inst_id -- 历史关联主指令号
            ,is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
            ,orddate -- 交易日
            ,condate -- 确认日期
            ,is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
            ,settlemode -- 结算类型
            ,host_market -- 托管场所
            ,spv_id -- SPV信息ID
            ,process_type -- 处理类型 0：普通 -1：临时处理
            ,clearing_date -- 清算日
            ,acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
            ,acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
            ,clearing_completed -- 清算是否完成 0：未完成， 1 已完成
            ,is_period_inst -- 0：非存续期指令 1：存续期指令
            ,tsk_id -- 任务号
            ,approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
            ,bind_inst_id -- 绑定id
            ,trader -- 交易员
            ,xcc_limit_type -- 限额指令类型
            ,exh_extordid -- 委托编号
            ,create_user_id -- 创建人员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inst_id -- 结算指令序号
    ,o.trade_id -- 内部交易号
    ,o.inst_type -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
    ,o.inst_grp_id -- 父指令号
    ,o.trd_type -- 交易业务类型一致
    ,o.set_type -- 结算方式 见券付款(PAD) 见款付券(DAP) 纯券过户(FOP) 券款对付(DVP)
    ,o.theory_set_date -- 理论清算日期
    ,o.real_set_date -- 实际结算的日期
    ,o.h_m_type -- 父金融工具市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,o.h_a_type -- 父金融工具资产类型 SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) ;SPT_ABS:资产证券化产品(ABS、MBS、CDO) ;SPT_CB:可转换债券 ;SPT_DB:债务 ;SPT_IBOR:同业拆借 ;SPT_IBDEPO:同业存款 ;SPT_C:现金 ;SPT_F1:封闭式基金 ;SPT_F2:开放式基金 ;SPT_F3:交易所交易基金 ;SPT_STG_1:期限套利 ;SPT_STG_2:跨期套利 ;SPT_PG:配股 ;SPT_IR:利率 ;SPT_CP:商业票据 ;SPT_DED:活期存款 ;SPT_NTD:通知存款(1天通知存款、7天通知存款) ;SPT_TMD:定期存款(3个月、半年、1年、3年、5年) ;SPT_NGD:协议存款(期限确定，利率协商确定的存款) ;SPT_REPO:回购 ;SPT_XR:汇率
    ,o.h_i_code -- 合约类,作为父金融工具   现券交易类,作为债券本身
    ,o.party_id -- 交易对手主键
    ,o.party_name -- 交易对手全称
    ,o.order_id -- 审批单号
    ,o.is_theory_payment -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
    ,o.bj_market -- 簿记场所：来源金融工具的BJ_MARKET（一级市场）和HOST_MARKET（二级市场）
    ,o.bj_state -- 簿记状态 0:没有簿记
    ,o.ext_ord_id -- 外部成交编号，用于指令查询和中债指令匹配
    ,o.exe_market -- 执行市场，中债直联时有用
    ,o.create_time -- 创建时间
    ,o.update_time -- 最后修改时间
    ,o.update_user -- 最后修改人
    ,o.account_time -- 复核时间
    ,o.account_user -- 复核人员
    ,o.memo -- 备注
    ,o.update_user_id -- 最后修改人员id
    ,o.cal_date -- 理论结算日
    ,o.ref_cash_inst_id -- 关联的资金指令ID
    ,o.ref_secu_inst_id -- 关联的券指令ID
    ,o.inst_setgrp_id -- 合并收付号
    ,o.state -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；   300:周期指令确认中;350:抹周期指令确认中;500:结算中
    ,o.operator_id -- 经办人ID
    ,o.operator_name -- 经办人
    ,o.print_times -- 打印次数
    ,o.due_order -- 挂账顺序
    ,o.due_obj_key -- 挂账序号
    ,o.generate_type -- 指令生成类型
    ,o.ref_inst_id -- 关联主指令号
    ,o.is_real_acctg -- 是否需要做实收付 0：不需要，1：需要
    ,o.real_account_inst_id -- 实际核算主指令号
    ,o.is_unknown_price -- 是否未知价格 0：已知价格 1：未知价格
    ,o.his_flag -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
    ,o.cash_acct_id -- 内部资金账户
    ,o.his_inst_id -- 调账主指令号
    ,o.his_ref_inst_id -- 历史关联主指令号
    ,o.is_operator_checked -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,o.orddate -- 交易日
    ,o.condate -- 确认日期
    ,o.is_match -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,o.settlemode -- 结算类型
    ,o.host_market -- 托管场所
    ,o.spv_id -- SPV信息ID
    ,o.process_type -- 处理类型 0：普通 -1：临时处理
    ,o.clearing_date -- 清算日
    ,o.acctg_estd_completed -- 理论流程是否完成 0：未完成， 1 已完成
    ,o.acctg_real_completed -- 实收流程是否完成 0：未完成， 1 已完成
    ,o.clearing_completed -- 清算是否完成 0：未完成， 1 已完成
    ,o.is_period_inst -- 0：非存续期指令 1：存续期指令
    ,o.tsk_id -- 任务号
    ,o.approvestatus -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,o.bind_inst_id -- 绑定id
    ,o.trader -- 交易员
    ,o.xcc_limit_type -- 限额指令类型
    ,o.exh_extordid -- 委托编号
    ,o.create_user_id -- 创建人员id
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
from ${iol_schema}.ibms_ttrd_set_instruction_bk o
    left join ${iol_schema}.ibms_ttrd_set_instruction_op n
        on
            o.inst_id = n.inst_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_set_instruction_cl d
        on
            o.inst_id = d.inst_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_set_instruction;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_set_instruction') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_set_instruction drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_set_instruction add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_set_instruction exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_cl;
alter table ${iol_schema}.ibms_ttrd_set_instruction exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_set_instruction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_set_instruction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
