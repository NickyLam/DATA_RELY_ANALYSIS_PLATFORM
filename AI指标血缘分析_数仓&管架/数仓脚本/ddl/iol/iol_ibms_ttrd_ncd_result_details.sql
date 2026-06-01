/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ncd_result_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ncd_result_details
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ncd_result_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ncd_result_details(
    seq_id number(22) -- 序列号
    ,sysordid varchar2(30) -- 交易单号
    ,ref_sysordid varchar2(30) -- 子交易单号
    ,i_code varchar2(45) -- 存单代码
    ,a_type varchar2(30) -- 存单资产类型
    ,m_type varchar2(30) -- 存单市场类型
    ,issue_type varchar2(2) -- 发行方式(1-报价发行,2-招标发行,3-浮息发行)
    ,partyid number(22) -- 认购人id
    ,partyname varchar2(150) -- 认购人名称
    ,bid_price number(31,4) -- 投标价位(元)
    ,bid_amount number(31,4) -- 投标量(亿元)
    ,bidding_price number(31,4) -- 中标价位(元)
    ,bidding_amount number(31,4) -- 中标量(亿元)
    ,bid_time varchar2(29) -- 认购时间
    ,username varchar2(75) -- 提交用户
    ,bidding_actual_amount number(31,4) -- 实际认购量
    ,memo varchar2(300) -- 备注
    ,sales_organization varchar2(150) -- 销售机构
    ,cost_calculate_rule varchar2(300) -- 费用计算规则
    ,bidding_pay_amount number(31,4) -- 缴款金额(元)
    ,bank_code varchar2(150) -- 开户行行号
    ,trdacccode varchar2(150) -- 交易账号
    ,sales_name varchar2(150) -- 销售机构名称
    ,sales_org_name varchar2(150) -- 销售机构(华兴)
    ,real_party_id number(22) -- 实际认购方编码
    ,real_partyname varchar2(300) -- 实际认购方名称
    ,belonger varchar2(75) -- 业绩归属人
    ,head_belonger varchar2(75) -- 总行业绩归属人
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
grant select on ${iol_schema}.ibms_ttrd_ncd_result_details to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ncd_result_details to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ncd_result_details to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ncd_result_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ncd_result_details is '同业存单发行结果明细表';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.seq_id is '序列号';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.sysordid is '交易单号';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.ref_sysordid is '子交易单号';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.i_code is '存单代码';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.a_type is '存单资产类型';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.m_type is '存单市场类型';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.issue_type is '发行方式(1-报价发行,2-招标发行,3-浮息发行)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.partyid is '认购人id';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.partyname is '认购人名称';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bid_price is '投标价位(元)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bid_amount is '投标量(亿元)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bidding_price is '中标价位(元)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bidding_amount is '中标量(亿元)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bid_time is '认购时间';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.username is '提交用户';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bidding_actual_amount is '实际认购量';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.memo is '备注';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.sales_organization is '销售机构';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.cost_calculate_rule is '费用计算规则';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bidding_pay_amount is '缴款金额(元)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.bank_code is '开户行行号';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.trdacccode is '交易账号';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.sales_name is '销售机构名称';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.sales_org_name is '销售机构(华兴)';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.real_party_id is '实际认购方编码';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.real_partyname is '实际认购方名称';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.belonger is '业绩归属人';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.head_belonger is '总行业绩归属人';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_ncd_result_details.etl_timestamp is 'ETL处理时间戳';
