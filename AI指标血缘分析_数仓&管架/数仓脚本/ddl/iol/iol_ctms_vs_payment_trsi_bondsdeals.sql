/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_vs_payment_trsi_bondsdeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals(
    payment_id number(22,0) -- 支付id
    ,aspclient_id number(22,0) -- 部门id
    ,dealsconfirm_id number(22,0) -- 交易确认id
    ,deal_tablename varchar2(45) -- 交易表名
    ,deal_id number(22,0) -- 原始交易id
    ,eventtype varchar2(5) -- 事件类型
    ,sequence number(22,0) -- 序列号
    ,payment_id_prev number(22,0) -- 前一个支付id
    ,keepfolder_id number(22,0) -- 账户id
    ,assettype varchar2(60) -- 资产类型
    ,buztype varchar2(60) -- 交易类型
    ,dealtype varchar2(60) -- 作业类型
    ,actiontype varchar2(60) -- 操作类型
    ,releasedate number(22,0) -- 发布日期
    ,generatedate number(22,0) -- 生成日期
    ,settledate number(22,0) -- 交割日期
    ,cpty_id number(22,0) -- 交易对手id
    ,cpty_name varchar2(192) -- 交易对手名称
    ,payreceivetype varchar2(2) -- 收付类型
    ,settlecurrency varchar2(5) -- 交割币种
    ,settleamount number -- 交割金额
    ,securitycode varchar2(48) -- 债券交割代码
    ,quantity number -- 债券交割金额
    ,act_settledate number(22,0) -- 实际结算日期
    ,act_settlecurrency varchar2(5) -- 实际交割币种
    ,act_settleamount number -- 实际结算金额
    ,act_securitycode varchar2(48) -- 实际交割债券代码
    ,act_quantity number -- 实际债券交割金额
    ,pstatus varchar2(3) -- 状态
    ,lastmodified timestamp -- 最后修改日期
    ,users_id_modifier number -- 变更用户id
    ,settlemethod varchar2(5) -- 交割方式
    ,act_settlemethod varchar2(5) -- 实际交割方式
    ,act_advance_amount number -- 预收金额
    ,note varchar2(600) -- 备注信息
    ,serial_number varchar2(23) -- 原始交易序号
    ,bs varchar2(3) -- buy or sell
    ,self_serial_number varchar2(23) -- 本方交易编号
    ,self_bs varchar2(3) -- buy or sell
    ,self_cash_acc_ename varchar2(384) -- 本方资金账户英文户名
    ,self_cash_acc_cname varchar2(384) -- 本方资金账户中文户名
    ,self_cash_acc_bank varchar2(384) -- 本方资金开户行
    ,self_cash_acc_no varchar2(384) -- 本方资金账号
    ,self_cash_acc_bank_ex varchar2(384) -- 本方资金开户联行号
    ,self_bond_acc_name varchar2(384) -- 本方债券账户名称
    ,self_bond_acc_bank varchar2(384) -- 本方债券账户银行
    ,self_bond_acc_no varchar2(384) -- 本方债券账户号
    ,self_g_cash_amt varchar2(384) -- 本方g_cash_amt
    ,self_g_bond_id varchar2(384) -- 本方g_bond_id
    ,self_g_bond_name varchar2(384) -- 本方g_bond_name
    ,self_g_bond_amt varchar2(384) -- 本方g_bond_amt
    ,self_g_bond_total_amt varchar2(384) -- 本方g_bond_total_amt
    ,self_g_ca_name varchar2(384) -- 本方g_ca_name
    ,self_g_ca_bank varchar2(384) -- 本方g_ca_bank
    ,self_g_ca_no varchar2(384) -- 本方g_ca_no
    ,self_g_ca_bank_ex varchar2(384) -- 本方g_ca_bank_ex
    ,self_g_ba_name varchar2(384) -- 本方g_ba_name
    ,self_g_ba_bank varchar2(384) -- 本方g_ba_bank
    ,self_g_ba_no varchar2(384) -- 本方g_ba_no
    ,self_g_stl_date varchar2(384) -- 本方g_stl_date
    ,self_g_mgr_bank varchar2(384) -- 本方g_mgr_bank
    ,self_lastmodified timestamp -- 最后修改时间
    ,self_datasymbol_id number(22,0) -- 数据源id
    ,cpty_serial_number varchar2(23) -- 交易对手交易编号
    ,cpty_bs varchar2(3) -- buy or sell
    ,cpty_cash_acc_ename varchar2(384) -- 对手方资金账户英文户名
    ,cpty_cash_acc_cname varchar2(384) -- 对手方资金账户中文户名
    ,cpty_cash_acc_bank varchar2(384) -- 对手方资金开户行
    ,cpty_cash_acc_no varchar2(384) -- 对手方资金账号
    ,cpty_cash_acc_bank_ex varchar2(384) -- 对手方资金开户联行号
    ,cpty_bond_acc_name varchar2(384) -- 对手方债券账户名称
    ,cpty_bond_acc_bank varchar2(384) -- 对手方债券账户银行
    ,cpty_bond_acc_no varchar2(384) -- 对手方债券账户号
    ,cpty_g_cash_amt varchar2(384) -- 对手方g_cash_amt
    ,cpty_g_bond_id varchar2(384) -- 对手方g_bond_id
    ,cpty_g_bond_name varchar2(384) -- 对手方g_bond_name
    ,cpty_g_bond_amt varchar2(384) -- 对手方g_bond_amt
    ,cpty_g_bond_total_amt varchar2(384) -- 对手方g_bond_total_amt
    ,cpty_g_ca_name varchar2(384) -- 对手方g_ca_name
    ,cpty_g_ca_bank varchar2(384) -- 对手方g_ca_bank
    ,cpty_g_ca_no varchar2(384) -- 对手方g_ca_no
    ,cpty_g_ca_bank_ex varchar2(384) -- 对手方g_ca_bank_ex
    ,cpty_g_ba_name varchar2(384) -- 对手方g_ba_name
    ,cpty_g_ba_bank varchar2(384) -- 对手方g_ba_bank
    ,cpty_g_ba_no varchar2(384) -- 对手方g_ba_no
    ,cpty_g_stl_date varchar2(384) -- 对手方g_stl_date
    ,cpty_g_mgr_bank varchar2(384) -- 对手方g_mgr_bank
    ,cpty_lastmodified timestamp -- 最后修改时间
    ,cpty_datasymbol_id number(22,0) -- 数据源id
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
grant select on ${iol_schema}.ctms_vs_payment_trsi_bondsdeals to ${iml_schema};
grant select on ${iol_schema}.ctms_vs_payment_trsi_bondsdeals to ${icl_schema};
grant select on ${iol_schema}.ctms_vs_payment_trsi_bondsdeals to ${idl_schema};
grant select on ${iol_schema}.ctms_vs_payment_trsi_bondsdeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_vs_payment_trsi_bondsdeals is '清算信息-现券';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.payment_id is '支付id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.aspclient_id is '部门id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.dealsconfirm_id is '交易确认id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.deal_tablename is '交易表名';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.deal_id is '原始交易id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.eventtype is '事件类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.sequence is '序列号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.payment_id_prev is '前一个支付id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.keepfolder_id is '账户id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.assettype is '资产类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.buztype is '交易类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.dealtype is '作业类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.actiontype is '操作类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.releasedate is '发布日期';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.generatedate is '生成日期';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.settledate is '交割日期';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_id is '交易对手id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_name is '交易对手名称';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.payreceivetype is '收付类型';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.settlecurrency is '交割币种';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.settleamount is '交割金额';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.securitycode is '债券交割代码';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.quantity is '债券交割金额';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_settledate is '实际结算日期';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_settlecurrency is '实际交割币种';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_settleamount is '实际结算金额';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_securitycode is '实际交割债券代码';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_quantity is '实际债券交割金额';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.pstatus is '状态';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.lastmodified is '最后修改日期';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.users_id_modifier is '变更用户id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.settlemethod is '交割方式';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_settlemethod is '实际交割方式';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.act_advance_amount is '预收金额';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.note is '备注信息';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.serial_number is '原始交易序号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.bs is 'buy or sell';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_serial_number is '本方交易编号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_bs is 'buy or sell';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_cash_acc_ename is '本方资金账户英文户名';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_cash_acc_cname is '本方资金账户中文户名';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_cash_acc_bank is '本方资金开户行';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_cash_acc_no is '本方资金账号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_cash_acc_bank_ex is '本方资金开户联行号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_bond_acc_name is '本方债券账户名称';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_bond_acc_bank is '本方债券账户银行';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_bond_acc_no is '本方债券账户号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_cash_amt is '本方g_cash_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_bond_id is '本方g_bond_id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_bond_name is '本方g_bond_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_bond_amt is '本方g_bond_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_bond_total_amt is '本方g_bond_total_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ca_name is '本方g_ca_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ca_bank is '本方g_ca_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ca_no is '本方g_ca_no';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ca_bank_ex is '本方g_ca_bank_ex';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ba_name is '本方g_ba_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ba_bank is '本方g_ba_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_ba_no is '本方g_ba_no';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_stl_date is '本方g_stl_date';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_g_mgr_bank is '本方g_mgr_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.self_datasymbol_id is '数据源id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_serial_number is '交易对手交易编号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_bs is 'buy or sell';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_cash_acc_ename is '对手方资金账户英文户名';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_cash_acc_cname is '对手方资金账户中文户名';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_cash_acc_bank is '对手方资金开户行';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_cash_acc_no is '对手方资金账号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_cash_acc_bank_ex is '对手方资金开户联行号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_bond_acc_name is '对手方债券账户名称';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_bond_acc_bank is '对手方债券账户银行';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_bond_acc_no is '对手方债券账户号';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_cash_amt is '对手方g_cash_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_bond_id is '对手方g_bond_id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_bond_name is '对手方g_bond_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_bond_amt is '对手方g_bond_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_bond_total_amt is '对手方g_bond_total_amt';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ca_name is '对手方g_ca_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ca_bank is '对手方g_ca_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ca_no is '对手方g_ca_no';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ca_bank_ex is '对手方g_ca_bank_ex';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ba_name is '对手方g_ba_name';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ba_bank is '对手方g_ba_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_ba_no is '对手方g_ba_no';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_stl_date is '对手方g_stl_date';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_g_mgr_bank is '对手方g_mgr_bank';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.cpty_datasymbol_id is '数据源id';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_vs_payment_trsi_bondsdeals.etl_timestamp is 'ETL处理时间戳';
