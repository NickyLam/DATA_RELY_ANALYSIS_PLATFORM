/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_bookkeeping_entry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_bookkeeping_entry
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_entry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_bookkeeping_entry(
    entry_id varchar2(45) -- 凭证id
    ,tsk_id varchar2(45) -- 任务id
    ,entry_date varchar2(15) -- 凭证日期
    ,flow_id varchar2(45) -- 流水号
    ,chg_id varchar2(45) -- 变动id
    ,inst_id number(16,0) -- 主指令id
    ,bkkpg_org_id varchar2(45) -- 记账机构号
    ,subj_org_id varchar2(45) -- 科目机构码
    ,subj_code varchar2(150) -- 科目码
    ,subj_sub_code varchar2(150) -- 科目子码
    ,inner_acct_sn varchar2(45) -- 内部账序号
    ,core_acct_code varchar2(45) -- 核心账号
    ,step varchar2(30) -- 步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
    ,debit_credit_flag varchar2(2) -- 借贷标识；1：借；2：贷。
    ,red_blue_flag varchar2(2) -- 红蓝字；1：普通；2：红字；3：蓝字。
    ,pending_cancel_flag varchar2(2) -- 挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
    ,currency varchar2(5) -- 币种
    ,value number(31,2) -- 借贷值
    ,state varchar2(2) -- 0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
    ,is_sending_core varchar2(2) -- 是否发送核心账号
    ,secu_acct_id varchar2(45) -- 券账户
    ,cash_acct_id varchar2(45) -- 资金账户
    ,update_time varchar2(29) -- 更新时间
    ,estd_or_real varchar2(2) -- 理论or实际核算；e：理论核算；r：实际核算
    ,memo varchar2(300) -- 备注
    ,core_acct_name varchar2(300) -- 核心账号名称
    ,grp_flow_id varchar2(45) -- 合并流水号
    ,acctg_obj_id varchar2(45) -- 核算对象id
    ,chg_type varchar2(30) -- 变动类型
    ,detail_flag varchar2(2) -- 明细标记
    ,src_type varchar2(30) -- 源数据类型
    ,send_state varchar2(2) -- 发送状态
    ,is_manual varchar2(2) -- 1：手工凭证 0：非手工凭证
    ,ext_secu_acct_id varchar2(30) -- 外部券账户
    ,ext_cash_acct_id varchar2(30) -- 外部资金账户
    ,i9_flag varchar2(2) -- i9标记
    ,ext_i_code varchar2(120) -- 金融工具代码
    ,ext_a_type varchar2(30) -- 金融工具资产类型
    ,ext_m_type varchar2(30) -- 金融工具市场类型
    ,ext_dim1 varchar2(300) -- 扩展维度1
    ,ext_dim2 varchar2(300) -- 扩展维度2
    ,ext_dim3 varchar2(300) -- 扩展维度3
    ,ext_dim4 varchar2(300) -- 扩展维度4
    ,ext_dim5 varchar2(300) -- 扩展维度5
    ,ext_dim6 varchar2(300) -- 扩展维度6
    ,ext_value1 varchar2(45) -- 扩展值字段1
    ,ext_value2 varchar2(45) -- 扩展值字段2
    ,ext_value3 varchar2(300) -- 扩展值3
    ,tax_type number(22,0) -- 征税类型： -1 无效值 0 征税 1 免税 2 不征税
    ,tax_value number(31,8) -- 税费
    ,debit_credit_flag_m varchar2(2) -- 借贷标志,数据标准落标,触发器添加
    ,red_blue_flag_m varchar2(2) -- 冲补抹标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_entry to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_entry to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_entry to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_entry to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_bookkeeping_entry is '会计分录表';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.entry_id is '凭证id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.entry_date is '凭证日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.flow_id is '流水号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.chg_id is '变动id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.inst_id is '主指令id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.bkkpg_org_id is '记账机构号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.subj_org_id is '科目机构码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.subj_code is '科目码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.subj_sub_code is '科目子码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.inner_acct_sn is '内部账序号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.core_acct_code is '核心账号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.step is '步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.debit_credit_flag is '借贷标识；1：借；2：贷。';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.red_blue_flag is '红蓝字；1：普通；2：红字；3：蓝字。';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.pending_cancel_flag is '挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.value is '借贷值';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.state is '0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.is_sending_core is '是否发送核心账号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.secu_acct_id is '券账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.cash_acct_id is '资金账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.estd_or_real is '理论or实际核算；e：理论核算；r：实际核算';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.core_acct_name is '核心账号名称';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.grp_flow_id is '合并流水号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.acctg_obj_id is '核算对象id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.chg_type is '变动类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.detail_flag is '明细标记';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.src_type is '源数据类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.send_state is '发送状态';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.is_manual is '1：手工凭证 0：非手工凭证';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_secu_acct_id is '外部券账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_cash_acct_id is '外部资金账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.i9_flag is 'i9标记';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim2 is '扩展维度2';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim3 is '扩展维度3';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim4 is '扩展维度4';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim5 is '扩展维度5';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_dim6 is '扩展维度6';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_value1 is '扩展值字段1';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_value2 is '扩展值字段2';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.ext_value3 is '扩展值3';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.tax_type is '征税类型： -1 无效值 0 征税 1 免税 2 不征税';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.tax_value is '税费';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.debit_credit_flag_m is '借贷标志,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.red_blue_flag_m is '冲补抹标志';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_entry.etl_timestamp is 'ETL处理时间戳';
