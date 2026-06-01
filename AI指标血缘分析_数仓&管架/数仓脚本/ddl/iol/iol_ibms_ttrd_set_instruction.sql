/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_set_instruction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_set_instruction
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_set_instruction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_set_instruction(
    inst_id number(16,0) -- 结算指令序号
    ,trade_id varchar2(45) -- 内部交易号
    ,inst_type number(22) -- 指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）
    ,inst_grp_id number(16,0) -- 父指令号
    ,trd_type varchar2(15) -- 交易业务类型一致
    ,set_type varchar2(30) -- 结算方式 见券付款(pad) 见款付券(dap) 纯券过户(fop) 券款对付(dvp)
    ,theory_set_date varchar2(15) -- 理论清算日期
    ,real_set_date varchar2(15) -- 实际结算的日期
    ,h_m_type varchar2(30) -- 父金融工具市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间
    ,h_a_type varchar2(30) -- 父金融工具资产类型 spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) ;spt_abs:资产证券化产品(abs、mbs、cdo) ;spt_cb:可转换债券 ;spt_db:债务 ;spt_ibor:同业拆借 ;spt_ibdepo:同业存款 ;spt_c:现金 ;spt_f1:封闭式基金 ;spt_f2:开放式基金 ;spt_f3:交易所交易基金 ;spt_stg_1:期限套利 ;spt_stg_2:跨期套利 ;spt_pg:配股 ;spt_ir:利率 ;spt_cp:商业票据 ;spt_ded:活期存款 ;spt_ntd:通知存款(1天通知存款、7天通知存款) ;spt_tmd:定期存款(3个月、半年、1年、3年、5年) ;spt_ngd:协议存款(期限确定，利率协商确定的存款) ;spt_repo:回购 ;spt_xr:汇率
    ,h_i_code varchar2(75) -- 合约类,作为父金融工具   现券交易类,作为债券本身
    ,party_id number(22) -- 交易对手主键
    ,party_name varchar2(300) -- 交易对手全称
    ,order_id varchar2(75) -- 审批单号
    ,is_theory_payment varchar2(2) -- 是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态
    ,bj_market varchar2(30) -- 簿记场所：来源金融工具的bj_market（一级市场）和host_market（二级市场）
    ,bj_state number(22) -- 簿记状态 0:没有簿记
    ,ext_ord_id varchar2(75) -- 外部成交编号，用于指令查询和中债指令匹配
    ,exe_market varchar2(45) -- 执行市场，中债直联时有用
    ,create_time varchar2(29) -- 创建时间
    ,update_time varchar2(35) -- 最后修改时间
    ,update_user varchar2(150) -- 最后修改人
    ,account_time varchar2(29) -- 复核时间
    ,account_user varchar2(30) -- 复核人员
    ,memo varchar2(750) -- 备注
    ,update_user_id varchar2(45) -- 最后修改人员id
    ,cal_date varchar2(15) -- 理论结算日
    ,ref_cash_inst_id number(16,0) -- 关联的资金指令id
    ,ref_secu_inst_id number(16,0) -- 关联的券指令id
    ,inst_setgrp_id number(16,0) -- 合并收付号
    ,state number(16,0) -- 指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；    300:周期指令确认中;350:抹周期指令确认中;500:结算中
    ,operator_id varchar2(45) -- 经办人id
    ,operator_name varchar2(150) -- 经办人
    ,print_times number(22) -- 打印次数
    ,due_order varchar2(2) -- 挂账顺序
    ,due_obj_key number(16,0) -- 挂账序号
    ,generate_type number(22) -- 指令生成类型
    ,ref_inst_id number(16,0) -- 关联主指令号
    ,is_real_acctg varchar2(2) -- 是否需要做实收付 0：不需要，1：需要
    ,real_account_inst_id number(16,0) -- 实际核算主指令号
    ,is_unknown_price varchar2(2) -- 是否未知价格 0：已知价格 1：未知价格
    ,his_flag number(16,0) -- 历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改
    ,cash_acct_id varchar2(45) -- 内部资金账户
    ,his_inst_id number(16,0) -- 调账主指令号
    ,his_ref_inst_id number(16,0) -- 历史关联主指令号
    ,is_operator_checked varchar2(2) -- 是否进行过资金指令编辑金额校验 0:未校验,1:已校验
    ,orddate varchar2(15) -- 交易日
    ,condate varchar2(15) -- 确认日期
    ,is_match varchar2(2) -- 是否是清算流水durable结算指令，1：是，其他：不是
    ,settlemode varchar2(2) -- 结算类型
    ,host_market varchar2(30) -- 托管场所
    ,spv_id number(16,0) -- spv信息id
    ,process_type number(22) -- 处理类型 0：普通 -1：临时处理
    ,clearing_date varchar2(15) -- 清算日
    ,acctg_estd_completed varchar2(2) -- 理论流程是否完成 0：未完成， 1 已完成
    ,acctg_real_completed varchar2(2) -- 实收流程是否完成 0：未完成， 1 已完成
    ,clearing_completed varchar2(2) -- 清算是否完成 0：未完成， 1 已完成
    ,is_period_inst varchar2(2) -- 0：非存续期指令 1：存续期指令
    ,tsk_id varchar2(45) -- 任务号
    ,approvestatus number(1,0) -- 0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
    ,bind_inst_id number(16,0) -- 绑定id
    ,trader varchar2(30) -- 交易员
    ,xcc_limit_type number(4,0) -- 限额指令类型
    ,exh_extordid varchar2(75) -- 委托编号
    ,create_user_id varchar2(45) -- 创建人员id
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
grant select on ${iol_schema}.ibms_ttrd_set_instruction to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_set_instruction to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_set_instruction is '主指令表';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.inst_id is '结算指令序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.trade_id is '内部交易号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.inst_type is '指令类型：用于过滤（虚拟、合并等）后台是否可见，通过一个固定的规则过滤（用户、记账、结算）负数表示内部可见，正数表示内外部都可见1:实时交易产生的首期指令2:非首期指令-20:内部交易结算指令以下为原先类型20:内部交易结算指令（非对外指令）;21虚拟结算指令（非对外指令）';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.inst_grp_id is '父指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.trd_type is '交易业务类型一致';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.set_type is '结算方式 见券付款(pad) 见款付券(dap) 纯券过户(fop) 券款对付(dvp)';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.theory_set_date is '理论清算日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.real_set_date is '实际结算的日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.h_m_type is '父金融工具市场类型 xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.h_a_type is '父金融工具资产类型 spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) ;spt_abs:资产证券化产品(abs、mbs、cdo) ;spt_cb:可转换债券 ;spt_db:债务 ;spt_ibor:同业拆借 ;spt_ibdepo:同业存款 ;spt_c:现金 ;spt_f1:封闭式基金 ;spt_f2:开放式基金 ;spt_f3:交易所交易基金 ;spt_stg_1:期限套利 ;spt_stg_2:跨期套利 ;spt_pg:配股 ;spt_ir:利率 ;spt_cp:商业票据 ;spt_ded:活期存款 ;spt_ntd:通知存款(1天通知存款、7天通知存款) ;spt_tmd:定期存款(3个月、半年、1年、3年、5年) ;spt_ngd:协议存款(期限确定，利率协商确定的存款) ;spt_repo:回购 ;spt_xr:汇率';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.h_i_code is '合约类,作为父金融工具   现券交易类,作为债券本身';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.party_id is '交易对手主键';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.party_name is '交易对手全称';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.order_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_theory_payment is '是否需要理论核算 0:不需要 1：需要；默认为0；用于抹账的时候，退回到理论状态还是未核算状态';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.bj_market is '簿记场所：来源金融工具的bj_market（一级市场）和host_market（二级市场）';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.bj_state is '簿记状态 0:没有簿记';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.ext_ord_id is '外部成交编号，用于指令查询和中债指令匹配';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.exe_market is '执行市场，中债直联时有用';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.update_time is '最后修改时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.update_user is '最后修改人';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.account_time is '复核时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.account_user is '复核人员';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.update_user_id is '最后修改人员id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.cal_date is '理论结算日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.ref_cash_inst_id is '关联的资金指令id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.ref_secu_inst_id is '关联的券指令id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.inst_setgrp_id is '合并收付号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.state is '指令状态；-1:指令刷新;-500:抹结算中;-888:交易撤单l-999:结算撤销;0:新建;1:待经办;2:待结算；    300:周期指令确认中;350:抹周期指令确认中;500:结算中';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.operator_id is '经办人id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.operator_name is '经办人';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.print_times is '打印次数';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.due_order is '挂账顺序';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.due_obj_key is '挂账序号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.generate_type is '指令生成类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.ref_inst_id is '关联主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_real_acctg is '是否需要做实收付 0：不需要，1：需要';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.real_account_inst_id is '实际核算主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_unknown_price is '是否未知价格 0：已知价格 1：未知价格';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.his_flag is '历史交易表示0,普通交易（默认）1,补录 2,撤销 3,反冲 4。修改';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.cash_acct_id is '内部资金账户';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.his_inst_id is '调账主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.his_ref_inst_id is '历史关联主指令号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_operator_checked is '是否进行过资金指令编辑金额校验 0:未校验,1:已校验';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.orddate is '交易日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.condate is '确认日期';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_match is '是否是清算流水durable结算指令，1：是，其他：不是';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.settlemode is '结算类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.host_market is '托管场所';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.spv_id is 'spv信息id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.process_type is '处理类型 0：普通 -1：临时处理';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.clearing_date is '清算日';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.acctg_estd_completed is '理论流程是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.acctg_real_completed is '实收流程是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.clearing_completed is '清算是否完成 0：未完成， 1 已完成';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.is_period_inst is '0：非存续期指令 1：存续期指令';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.tsk_id is '任务号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.approvestatus is '0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.bind_inst_id is '绑定id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.trader is '交易员';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.xcc_limit_type is '限额指令类型';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.exh_extordid is '委托编号';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.create_user_id is '创建人员id';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_set_instruction.etl_timestamp is 'ETL处理时间戳';
