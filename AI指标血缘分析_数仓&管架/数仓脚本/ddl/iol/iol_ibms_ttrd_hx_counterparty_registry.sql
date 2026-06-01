/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_hx_counterparty_registry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_hx_counterparty_registry
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_hx_counterparty_registry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_hx_counterparty_registry(
    registry_id number(16,0) -- 主键
    ,entry_id varchar2(45) -- 分录id
    ,entry_date varchar2(15) -- 记账日期
    ,inst_id number(16,0) -- 指令号
    ,global_flow_no varchar2(75) -- 全局流水号
    ,flow_no varchar2(75) -- 系统分录流水号
    ,flow_inner_sn varchar2(15) -- 交易流水序号
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产代码
    ,m_type varchar2(30) -- 市场类型
    ,p_type varchar2(30) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,i_name varchar2(383) -- 金融工具名称
    ,subj_code varchar2(30) -- 科目号
    ,debit_credit_flag varchar2(2) -- 借贷标识,1：借；2：贷。
    ,red_blue_flag varchar2(2) -- 红蓝字标识,1：普通,2：红；3：蓝
    ,value number(31,2) -- 金额
    ,currency varchar2(5) -- 币种
    ,prod_code varchar2(24) -- 标准产品编码
    ,prod_name varchar2(383) -- 标准产品名称
    ,party_acct_code varchar2(150) -- 对手方账号
    ,party_acct_name varchar2(150) -- 对手方户名
    ,party_bank_code varchar2(150) -- 对手方开户行
    ,party_bank_name varchar2(300) -- 对手方开户行名
    ,state varchar2(2) -- 状态，0:交易对手信息未填充，1：交易对手信息已填充
    ,update_time varchar2(29) -- 
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
grant select on ${iol_schema}.ibms_ttrd_hx_counterparty_registry to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_counterparty_registry to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_counterparty_registry to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_hx_counterparty_registry to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_hx_counterparty_registry is '华兴交易对手登记簿';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.registry_id is '主键';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.entry_id is '分录id';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.entry_date is '记账日期';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.inst_id is '指令号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.global_flow_no is '全局流水号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.flow_no is '系统分录流水号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.flow_inner_sn is '交易流水序号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.a_type is '资产代码';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.p_class is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.subj_code is '科目号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.debit_credit_flag is '借贷标识,1：借；2：贷。';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.red_blue_flag is '红蓝字标识,1：普通,2：红；3：蓝';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.value is '金额';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.prod_code is '标准产品编码';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.prod_name is '标准产品名称';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.party_acct_code is '对手方账号';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.party_acct_name is '对手方户名';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.party_bank_code is '对手方开户行';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.party_bank_name is '对手方开户行名';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.state is '状态，0:交易对手信息未填充，1：交易对手信息已填充';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_hx_counterparty_registry.etl_timestamp is 'ETL处理时间戳';
