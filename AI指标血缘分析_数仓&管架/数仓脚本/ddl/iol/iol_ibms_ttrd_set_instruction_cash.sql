/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction_cash
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction_cash
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction_cash purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction_cash(
    cash_inst_id number(16,0) -- 资金结算指令序号
    ,inst_id number(16,0) -- 主结算指令序号
    ,cash_inst_grp_id number(16,0) -- 资金结算指令合并序号
    ,biz_type varchar2(45) -- 资金指令业务类型
    ,direction varchar2(15) -- 交收方向
    ,cash_acct_id varchar2(45) -- 二级资金账户
    ,ext_cash_acct_id varchar2(30) -- 一级资金账户
    ,currency varchar2(15) -- 币种
    ,amount number(31,4) -- 变动数量
    ,freeze_amount number(31,4) -- 冻结数量
    ,set_date varchar2(15) -- 结算日期
    ,set_finish_date varchar2(15) -- 实际结算日期
    ,transfer_type number(22) -- 0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:dvp 8:swift 9:境内外币支付
    ,acct_code varchar2(150) -- 本方银行账号
    ,acct_name varchar2(150) -- 本方银行账户名称
    ,bank_code varchar2(150) -- 本方开户行号
    ,bank_name varchar2(150) -- 本方开户行名称
    ,party_acct_code varchar2(150) -- 对手银行账号
    ,party_acct_name varchar2(150) -- 对方帐户
    ,party_bank_code varchar2(150) -- 对手开户行号
    ,party_bank_name varchar2(300) -- 对手开户行名称
    ,create_time varchar2(29) -- 创建时间
    ,update_time varchar2(35) -- 经办时间
    ,update_user varchar2(150) -- 经办人
    ,account_time varchar2(29) -- 复核时间
    ,account_user varchar2(30) -- 复核人员
    ,memo varchar2(750) -- 备注
    ,blc_state number(22) -- 0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成
    ,acctg_state number(22) -- 0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新
    ,opr_state number(22) -- -1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束
    ,cash_inst_setgrp_id number(16,0) -- 合并收付号
    ,acctg_inst_id number(16,0) -- 记账主指令号
    ,cancel_flag varchar2(2) -- 1:表示限额反向指令，其它：正向指令
    ,is_theory_blc varchar2(2) -- 是否已做权责业务
    ,nostro_ref_cash_inst_id number(16,0) -- 交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号
    ,pending_flow_no varchar2(45) -- 核心收款挂账日期
    ,pending_date varchar2(15) -- 挂账日期
    ,is_theory_acct varchar2(2) -- 是否已做过理论核算
    ,mid_bank_acct_code varchar2(75) -- 中间行账号
    ,mid_bank_name varchar2(75) -- 中间行名称
    ,mid_swift_code varchar2(75) -- 中间行swift代码
    ,swift_code varchar2(75) -- swift代码
    ,party_swift_code varchar2(75) -- 对手方基础货币swift代码
    ,party_mid_bank_acct_code varchar2(75) -- 对手方中间行账号
    ,party_mid_bank_name varchar2(75) -- 对手方中间行名称
    ,party_mid_swift_code varchar2(75) -- 对手方中间行swift代码
    ,cl_status number(31,0) -- 指令状态
    ,party_i_bank_code varchar2(75) -- 交易对手银行行号
    ,party_i_swift_code varchar2(75) -- 交易对手swiftcode
    ,his_cash_inst_id number(16,0) -- 历史资金指令号
    ,his_flag number(22) -- 0:正常指令;1:补录指令;2:撤销指令;3:反冲指令
    ,ord_limit_cash_inst_id number(31,0) -- 审批单限额资金指令号
    ,hvps_mate_trace_no varchar2(180) -- 邢台银行：已匹配大额来账平台流水号
    ,module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,xcc_module_type number(22) -- 核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
    ,is_editable varchar2(2) -- 前台是否可修改
    ,check_result_box number(4,0) -- 指令复选框状态
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
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction_cash to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction_cash is '资金指令表';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cash_inst_id is '资金结算指令序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.inst_id is '主结算指令序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cash_inst_grp_id is '资金结算指令合并序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.biz_type is '资金指令业务类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.direction is '交收方向';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cash_acct_id is '二级资金账户';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.ext_cash_acct_id is '一级资金账户';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.amount is '变动数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.freeze_amount is '冻结数量';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.set_date is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.set_finish_date is '实际结算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.transfer_type is '0:大额支付 1:农信银 2:票据支付 3:系统内转账 4:同城交换 5:内部账 6:客户账 7:dvp 8:swift 9:境内外币支付';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.acct_code is '本方银行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.acct_name is '本方银行账户名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.bank_code is '本方开户行号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.bank_name is '本方开户行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_acct_code is '对手银行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_acct_name is '对方帐户';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_bank_code is '对手开户行号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_bank_name is '对手开户行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.update_time is '经办时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.update_user is '经办人';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.account_user is '复核人员';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.blc_state is '0: 初始状态;50: 权责业务余额开始;51: 权责业务余额完成;52: 收付业务余额开始;53: 收付业务余额完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.acctg_state is '0: 初始状态100: 理论核算开始;101: 理论核算完成;102: 理论记账分录已生成;103: 理论记账余额已更新;104: 实际核算开始;105: 实际核算完成;106: 实际记账分录已生成;107: 实际记账余额已更新';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.opr_state is '-1:新建;0:待确认;1:待经办;2:待复核;9:已复核;99:结束';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cash_inst_setgrp_id is '合并收付号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.acctg_inst_id is '记账主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cancel_flag is '1:表示限额反向指令，其它：正向指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.is_theory_blc is '是否已做权责业务';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.nostro_ref_cash_inst_id is '交易对手选择存放同业活期账户后新生成的资金指令的原资金指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.pending_flow_no is '核心收款挂账日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.pending_date is '挂账日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.is_theory_acct is '是否已做过理论核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.mid_bank_acct_code is '中间行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.mid_bank_name is '中间行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.mid_swift_code is '中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.swift_code is 'swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_swift_code is '对手方基础货币swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_mid_bank_acct_code is '对手方中间行账号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_mid_bank_name is '对手方中间行名称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_mid_swift_code is '对手方中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.cl_status is '指令状态';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_i_bank_code is '交易对手银行行号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.party_i_swift_code is '交易对手swiftcode';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.his_cash_inst_id is '历史资金指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.his_flag is '0:正常指令;1:补录指令;2:撤销指令;3:反冲指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.ord_limit_cash_inst_id is '审批单限额资金指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.hvps_mate_trace_no is '邢台银行：已匹配大额来账平台流水号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.xcc_module_type is '核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.is_editable is '前台是否可修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.check_result_box is '指令复选框状态';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_set_instruction_cash.etl_timestamp is 'ETL处理时间戳';
