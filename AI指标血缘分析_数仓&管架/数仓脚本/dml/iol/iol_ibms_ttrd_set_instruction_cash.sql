/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_set_instruction_cash
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
create table ${iol_schema}.ibms_ttrd_set_instruction_cash_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_set_instruction_cash
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_cash_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_cash where 0=1;

create table ${iol_schema}.ibms_ttrd_set_instruction_cash_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_set_instruction_cash where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_cash_cl(
            cash_inst_id -- 资金结算指令序号
            ,inst_id -- 主结算指令序号
            ,cash_inst_grp_id -- 资金结算指令合并序号
            ,biz_type -- 资金指令业务类型
            ,direction -- 交收方向
            ,cash_acct_id -- 二级资金账户
            ,ext_cash_acct_id -- 一级资金账户
            ,currency -- 币种
            ,amount -- 变动数量
            ,freeze_amount -- 冻结数量
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
            ,acct_code -- 本方银行账号
            ,acct_name -- 本方银行账户名称
            ,bank_code -- 本方开户行号
            ,bank_name -- 本方开户行名称
            ,party_acct_code -- 对手银行账号
            ,party_acct_name -- 对方帐户
            ,party_bank_code -- 对手开户行号
            ,party_bank_name -- 对手开户行名称
            ,create_time -- 创建时间
            ,update_time -- 经办时间
            ,update_user -- 经办人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
            ,cash_inst_setgrp_id -- 合并收付号
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,is_theory_blc -- 是否已做权责业务
            ,nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
            ,pending_flow_no -- 核心收款挂账日期
            ,pending_date -- 挂账日期
            ,is_theory_acct -- 是否已做过理论核算
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,swift_code -- swift代码
            ,party_swift_code -- 对手方基础货币swift代码
            ,party_mid_bank_acct_code -- 对手方中间行账号
            ,party_mid_bank_name -- 对手方中间行名称
            ,party_mid_swift_code -- 对手方中间行SWIFT代码
            ,cl_status -- 指令状态
            ,party_i_bank_code -- 交易对手银行行号
            ,party_i_swift_code -- 交易对手swiftCode
            ,his_cash_inst_id -- 历史资金指令号
            ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
            ,ord_limit_cash_inst_id -- 审批单限额资金指令号
            ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,check_result_box -- 指令复选框状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_cash_op(
            cash_inst_id -- 资金结算指令序号
            ,inst_id -- 主结算指令序号
            ,cash_inst_grp_id -- 资金结算指令合并序号
            ,biz_type -- 资金指令业务类型
            ,direction -- 交收方向
            ,cash_acct_id -- 二级资金账户
            ,ext_cash_acct_id -- 一级资金账户
            ,currency -- 币种
            ,amount -- 变动数量
            ,freeze_amount -- 冻结数量
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
            ,acct_code -- 本方银行账号
            ,acct_name -- 本方银行账户名称
            ,bank_code -- 本方开户行号
            ,bank_name -- 本方开户行名称
            ,party_acct_code -- 对手银行账号
            ,party_acct_name -- 对方帐户
            ,party_bank_code -- 对手开户行号
            ,party_bank_name -- 对手开户行名称
            ,create_time -- 创建时间
            ,update_time -- 经办时间
            ,update_user -- 经办人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
            ,cash_inst_setgrp_id -- 合并收付号
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,is_theory_blc -- 是否已做权责业务
            ,nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
            ,pending_flow_no -- 核心收款挂账日期
            ,pending_date -- 挂账日期
            ,is_theory_acct -- 是否已做过理论核算
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,swift_code -- swift代码
            ,party_swift_code -- 对手方基础货币swift代码
            ,party_mid_bank_acct_code -- 对手方中间行账号
            ,party_mid_bank_name -- 对手方中间行名称
            ,party_mid_swift_code -- 对手方中间行SWIFT代码
            ,cl_status -- 指令状态
            ,party_i_bank_code -- 交易对手银行行号
            ,party_i_swift_code -- 交易对手swiftCode
            ,his_cash_inst_id -- 历史资金指令号
            ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
            ,ord_limit_cash_inst_id -- 审批单限额资金指令号
            ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,check_result_box -- 指令复选框状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cash_inst_id, o.cash_inst_id) as cash_inst_id -- 资金结算指令序号
    ,nvl(n.inst_id, o.inst_id) as inst_id -- 主结算指令序号
    ,nvl(n.cash_inst_grp_id, o.cash_inst_grp_id) as cash_inst_grp_id -- 资金结算指令合并序号
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 资金指令业务类型
    ,nvl(n.direction, o.direction) as direction -- 交收方向
    ,nvl(n.cash_acct_id, o.cash_acct_id) as cash_acct_id -- 二级资金账户
    ,nvl(n.ext_cash_acct_id, o.ext_cash_acct_id) as ext_cash_acct_id -- 一级资金账户
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.amount, o.amount) as amount -- 变动数量
    ,nvl(n.freeze_amount, o.freeze_amount) as freeze_amount -- 冻结数量
    ,nvl(n.set_date, o.set_date) as set_date -- 结算日期
    ,nvl(n.set_finish_date, o.set_finish_date) as set_finish_date -- 实际结算日期
    ,nvl(n.transfer_type, o.transfer_type) as transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
    ,nvl(n.acct_code, o.acct_code) as acct_code -- 本方银行账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 本方银行账户名称
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 本方开户行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 本方开户行名称
    ,nvl(n.party_acct_code, o.party_acct_code) as party_acct_code -- 对手银行账号
    ,nvl(n.party_acct_name, o.party_acct_name) as party_acct_name -- 对方帐户
    ,nvl(n.party_bank_code, o.party_bank_code) as party_bank_code -- 对手开户行号
    ,nvl(n.party_bank_name, o.party_bank_name) as party_bank_name -- 对手开户行名称
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 经办时间
    ,nvl(n.update_user, o.update_user) as update_user -- 经办人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人员
    ,nvl(n.memo, o.memo) as memo -- 备注
    ,nvl(n.blc_state, o.blc_state) as blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
    ,nvl(n.acctg_state, o.acctg_state) as acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,nvl(n.opr_state, o.opr_state) as opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
    ,nvl(n.cash_inst_setgrp_id, o.cash_inst_setgrp_id) as cash_inst_setgrp_id -- 合并收付号
    ,nvl(n.acctg_inst_id, o.acctg_inst_id) as acctg_inst_id -- 记账主指令号
    ,nvl(n.cancel_flag, o.cancel_flag) as cancel_flag -- 1:表示限额反向指令，其它：正向指令
    ,nvl(n.is_theory_blc, o.is_theory_blc) as is_theory_blc -- 是否已做权责业务
    ,nvl(n.nostro_ref_cash_inst_id, o.nostro_ref_cash_inst_id) as nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
    ,nvl(n.pending_flow_no, o.pending_flow_no) as pending_flow_no -- 核心收款挂账日期
    ,nvl(n.pending_date, o.pending_date) as pending_date -- 挂账日期
    ,nvl(n.is_theory_acct, o.is_theory_acct) as is_theory_acct -- 是否已做过理论核算
    ,nvl(n.mid_bank_acct_code, o.mid_bank_acct_code) as mid_bank_acct_code -- 中间行账号
    ,nvl(n.mid_bank_name, o.mid_bank_name) as mid_bank_name -- 中间行名称
    ,nvl(n.mid_swift_code, o.mid_swift_code) as mid_swift_code -- 中间行SWIFT代码
    ,nvl(n.swift_code, o.swift_code) as swift_code -- swift代码
    ,nvl(n.party_swift_code, o.party_swift_code) as party_swift_code -- 对手方基础货币swift代码
    ,nvl(n.party_mid_bank_acct_code, o.party_mid_bank_acct_code) as party_mid_bank_acct_code -- 对手方中间行账号
    ,nvl(n.party_mid_bank_name, o.party_mid_bank_name) as party_mid_bank_name -- 对手方中间行名称
    ,nvl(n.party_mid_swift_code, o.party_mid_swift_code) as party_mid_swift_code -- 对手方中间行SWIFT代码
    ,nvl(n.cl_status, o.cl_status) as cl_status -- 指令状态
    ,nvl(n.party_i_bank_code, o.party_i_bank_code) as party_i_bank_code -- 交易对手银行行号
    ,nvl(n.party_i_swift_code, o.party_i_swift_code) as party_i_swift_code -- 交易对手swiftCode
    ,nvl(n.his_cash_inst_id, o.his_cash_inst_id) as his_cash_inst_id -- 历史资金指令号
    ,nvl(n.his_flag, o.his_flag) as his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,nvl(n.ord_limit_cash_inst_id, o.ord_limit_cash_inst_id) as ord_limit_cash_inst_id -- 审批单限额资金指令号
    ,nvl(n.hvps_mate_trace_no, o.hvps_mate_trace_no) as hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
    ,nvl(n.module_type, o.module_type) as module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,nvl(n.xcc_module_type, o.xcc_module_type) as xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,nvl(n.is_editable, o.is_editable) as is_editable -- 前台是否可修改
    ,nvl(n.check_result_box, o.check_result_box) as check_result_box -- 指令复选框状态
    ,case when
            n.cash_inst_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_inst_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_inst_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_set_instruction_cash_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_set_instruction_cash where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_inst_id = n.cash_inst_id
where (
        o.cash_inst_id is null
    )
    or (
        n.cash_inst_id is null
    )
    or (
        o.inst_id <> n.inst_id
        or o.cash_inst_grp_id <> n.cash_inst_grp_id
        or o.biz_type <> n.biz_type
        or o.direction <> n.direction
        or o.cash_acct_id <> n.cash_acct_id
        or o.ext_cash_acct_id <> n.ext_cash_acct_id
        or o.currency <> n.currency
        or o.amount <> n.amount
        or o.freeze_amount <> n.freeze_amount
        or o.set_date <> n.set_date
        or o.set_finish_date <> n.set_finish_date
        or o.transfer_type <> n.transfer_type
        or o.acct_code <> n.acct_code
        or o.acct_name <> n.acct_name
        or o.bank_code <> n.bank_code
        or o.bank_name <> n.bank_name
        or o.party_acct_code <> n.party_acct_code
        or o.party_acct_name <> n.party_acct_name
        or o.party_bank_code <> n.party_bank_code
        or o.party_bank_name <> n.party_bank_name
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.account_time <> n.account_time
        or o.account_user <> n.account_user
        or o.memo <> n.memo
        or o.blc_state <> n.blc_state
        or o.acctg_state <> n.acctg_state
        or o.opr_state <> n.opr_state
        or o.cash_inst_setgrp_id <> n.cash_inst_setgrp_id
        or o.acctg_inst_id <> n.acctg_inst_id
        or o.cancel_flag <> n.cancel_flag
        or o.is_theory_blc <> n.is_theory_blc
        or o.nostro_ref_cash_inst_id <> n.nostro_ref_cash_inst_id
        or o.pending_flow_no <> n.pending_flow_no
        or o.pending_date <> n.pending_date
        or o.is_theory_acct <> n.is_theory_acct
        or o.mid_bank_acct_code <> n.mid_bank_acct_code
        or o.mid_bank_name <> n.mid_bank_name
        or o.mid_swift_code <> n.mid_swift_code
        or o.swift_code <> n.swift_code
        or o.party_swift_code <> n.party_swift_code
        or o.party_mid_bank_acct_code <> n.party_mid_bank_acct_code
        or o.party_mid_bank_name <> n.party_mid_bank_name
        or o.party_mid_swift_code <> n.party_mid_swift_code
        or o.cl_status <> n.cl_status
        or o.party_i_bank_code <> n.party_i_bank_code
        or o.party_i_swift_code <> n.party_i_swift_code
        or o.his_cash_inst_id <> n.his_cash_inst_id
        or o.his_flag <> n.his_flag
        or o.ord_limit_cash_inst_id <> n.ord_limit_cash_inst_id
        or o.hvps_mate_trace_no <> n.hvps_mate_trace_no
        or o.module_type <> n.module_type
        or o.xcc_module_type <> n.xcc_module_type
        or o.is_editable <> n.is_editable
        or o.check_result_box <> n.check_result_box
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_set_instruction_cash_cl(
            cash_inst_id -- 资金结算指令序号
            ,inst_id -- 主结算指令序号
            ,cash_inst_grp_id -- 资金结算指令合并序号
            ,biz_type -- 资金指令业务类型
            ,direction -- 交收方向
            ,cash_acct_id -- 二级资金账户
            ,ext_cash_acct_id -- 一级资金账户
            ,currency -- 币种
            ,amount -- 变动数量
            ,freeze_amount -- 冻结数量
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
            ,acct_code -- 本方银行账号
            ,acct_name -- 本方银行账户名称
            ,bank_code -- 本方开户行号
            ,bank_name -- 本方开户行名称
            ,party_acct_code -- 对手银行账号
            ,party_acct_name -- 对方帐户
            ,party_bank_code -- 对手开户行号
            ,party_bank_name -- 对手开户行名称
            ,create_time -- 创建时间
            ,update_time -- 经办时间
            ,update_user -- 经办人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
            ,cash_inst_setgrp_id -- 合并收付号
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,is_theory_blc -- 是否已做权责业务
            ,nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
            ,pending_flow_no -- 核心收款挂账日期
            ,pending_date -- 挂账日期
            ,is_theory_acct -- 是否已做过理论核算
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,swift_code -- swift代码
            ,party_swift_code -- 对手方基础货币swift代码
            ,party_mid_bank_acct_code -- 对手方中间行账号
            ,party_mid_bank_name -- 对手方中间行名称
            ,party_mid_swift_code -- 对手方中间行SWIFT代码
            ,cl_status -- 指令状态
            ,party_i_bank_code -- 交易对手银行行号
            ,party_i_swift_code -- 交易对手swiftCode
            ,his_cash_inst_id -- 历史资金指令号
            ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
            ,ord_limit_cash_inst_id -- 审批单限额资金指令号
            ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,check_result_box -- 指令复选框状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_set_instruction_cash_op(
            cash_inst_id -- 资金结算指令序号
            ,inst_id -- 主结算指令序号
            ,cash_inst_grp_id -- 资金结算指令合并序号
            ,biz_type -- 资金指令业务类型
            ,direction -- 交收方向
            ,cash_acct_id -- 二级资金账户
            ,ext_cash_acct_id -- 一级资金账户
            ,currency -- 币种
            ,amount -- 变动数量
            ,freeze_amount -- 冻结数量
            ,set_date -- 结算日期
            ,set_finish_date -- 实际结算日期
            ,transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
            ,acct_code -- 本方银行账号
            ,acct_name -- 本方银行账户名称
            ,bank_code -- 本方开户行号
            ,bank_name -- 本方开户行名称
            ,party_acct_code -- 对手银行账号
            ,party_acct_name -- 对方帐户
            ,party_bank_code -- 对手开户行号
            ,party_bank_name -- 对手开户行名称
            ,create_time -- 创建时间
            ,update_time -- 经办时间
            ,update_user -- 经办人
            ,account_time -- 复核时间
            ,account_user -- 复核人员
            ,memo -- 备注
            ,blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
            ,acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
            ,opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
            ,cash_inst_setgrp_id -- 合并收付号
            ,acctg_inst_id -- 记账主指令号
            ,cancel_flag -- 1:表示限额反向指令，其它：正向指令
            ,is_theory_blc -- 是否已做权责业务
            ,nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
            ,pending_flow_no -- 核心收款挂账日期
            ,pending_date -- 挂账日期
            ,is_theory_acct -- 是否已做过理论核算
            ,mid_bank_acct_code -- 中间行账号
            ,mid_bank_name -- 中间行名称
            ,mid_swift_code -- 中间行SWIFT代码
            ,swift_code -- swift代码
            ,party_swift_code -- 对手方基础货币swift代码
            ,party_mid_bank_acct_code -- 对手方中间行账号
            ,party_mid_bank_name -- 对手方中间行名称
            ,party_mid_swift_code -- 对手方中间行SWIFT代码
            ,cl_status -- 指令状态
            ,party_i_bank_code -- 交易对手银行行号
            ,party_i_swift_code -- 交易对手swiftCode
            ,his_cash_inst_id -- 历史资金指令号
            ,his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
            ,ord_limit_cash_inst_id -- 审批单限额资金指令号
            ,hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
            ,module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
            ,is_editable -- 前台是否可修改
            ,check_result_box -- 指令复选框状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cash_inst_id -- 资金结算指令序号
    ,o.inst_id -- 主结算指令序号
    ,o.cash_inst_grp_id -- 资金结算指令合并序号
    ,o.biz_type -- 资金指令业务类型
    ,o.direction -- 交收方向
    ,o.cash_acct_id -- 二级资金账户
    ,o.ext_cash_acct_id -- 一级资金账户
    ,o.currency -- 币种
    ,o.amount -- 变动数量
    ,o.freeze_amount -- 冻结数量
    ,o.set_date -- 结算日期
    ,o.set_finish_date -- 实际结算日期
    ,o.transfer_type -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:DVP 8:SWIFT 9:境内外币支付
    ,o.acct_code -- 本方银行账号
    ,o.acct_name -- 本方银行账户名称
    ,o.bank_code -- 本方开户行号
    ,o.bank_name -- 本方开户行名称
    ,o.party_acct_code -- 对手银行账号
    ,o.party_acct_name -- 对方帐户
    ,o.party_bank_code -- 对手开户行号
    ,o.party_bank_name -- 对手开户行名称
    ,o.create_time -- 创建时间
    ,o.update_time -- 经办时间
    ,o.update_user -- 经办人
    ,o.account_time -- 复核时间
    ,o.account_user -- 复核人员
    ,o.memo -- 备注
    ,o.blc_state -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
    ,o.acctg_state -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,o.opr_state -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
    ,o.cash_inst_setgrp_id -- 合并收付号
    ,o.acctg_inst_id -- 记账主指令号
    ,o.cancel_flag -- 1:表示限额反向指令，其它：正向指令
    ,o.is_theory_blc -- 是否已做权责业务
    ,o.nostro_ref_cash_inst_id -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
    ,o.pending_flow_no -- 核心收款挂账日期
    ,o.pending_date -- 挂账日期
    ,o.is_theory_acct -- 是否已做过理论核算
    ,o.mid_bank_acct_code -- 中间行账号
    ,o.mid_bank_name -- 中间行名称
    ,o.mid_swift_code -- 中间行SWIFT代码
    ,o.swift_code -- swift代码
    ,o.party_swift_code -- 对手方基础货币swift代码
    ,o.party_mid_bank_acct_code -- 对手方中间行账号
    ,o.party_mid_bank_name -- 对手方中间行名称
    ,o.party_mid_swift_code -- 对手方中间行SWIFT代码
    ,o.cl_status -- 指令状态
    ,o.party_i_bank_code -- 交易对手银行行号
    ,o.party_i_swift_code -- 交易对手swiftCode
    ,o.his_cash_inst_id -- 历史资金指令号
    ,o.his_flag -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,o.ord_limit_cash_inst_id -- 审批单限额资金指令号
    ,o.hvps_mate_trace_no -- 邢台银行：已匹配大额来账平台流水号
    ,o.module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,o.xcc_module_type -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,o.is_editable -- 前台是否可修改
    ,o.check_result_box -- 指令复选框状态
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
from ${iol_schema}.ibms_ttrd_set_instruction_cash_bk o
    left join ${iol_schema}.ibms_ttrd_set_instruction_cash_op n
        on
            o.cash_inst_id = n.cash_inst_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_set_instruction_cash_cl d
        on
            o.cash_inst_id = d.cash_inst_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_set_instruction_cash;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_set_instruction_cash') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_set_instruction_cash drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_set_instruction_cash_cl;
alter table ${iol_schema}.ibms_ttrd_set_instruction_cash exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_set_instruction_cash_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_op purge;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_set_instruction_cash',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
