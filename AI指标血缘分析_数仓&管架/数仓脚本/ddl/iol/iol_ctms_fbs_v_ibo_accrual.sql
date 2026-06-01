/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_ibo_accrual
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_ibo_accrual
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_ibo_accrual purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_ibo_accrual(
    cus_number number(5,0) -- 部门编号
    ,branch_id varchar2(30) -- 后台的机构编号
    ,branch_number number(5,0) -- 分支机构号
    ,deal_sqno number(18,0) -- 投组交易的流水号
    ,crncy_code varchar2(5) -- 贵金属货币
    ,first_amnt number -- 交易量
    ,maturity_amnt number -- 期末结算金额
    ,deal_rate number -- 拆借利率
    ,deal_date date -- 交易日期
    ,value_date date -- 起息日
    ,maturity_date date -- 到期日
    ,rate_type number(2,0) -- 利率类型
    ,trade_purpose number(2,0) -- 交易目的
    ,counter_party_id number(8,0) -- 交易对手ID
    ,intrst_basis number(2,0) -- 计息基准
    ,portfolio_id number(8,0) -- 投组ID
    ,load_date date -- 计提日期
    ,total_accrual_amount number(38,8) -- 总的计提金额
    ,deal_dir number -- 交易方向
    ,ibo_type number(2,0) -- 拆借类型
    ,client_deal_sqno varchar2(45) -- 业务成交编号
    ,updtd_date date -- 计提的更新时间
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
grant select on ${iol_schema}.ctms_fbs_v_ibo_accrual to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_accrual to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_accrual to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_ibo_accrual to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_ibo_accrual is '拆借计提视图';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.cus_number is '部门编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.branch_id is '后台的机构编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.branch_number is '分支机构号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.deal_sqno is '投组交易的流水号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.crncy_code is '贵金属货币';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.first_amnt is '交易量';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.maturity_amnt is '期末结算金额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.deal_rate is '拆借利率';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.deal_date is '交易日期';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.value_date is '起息日';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.maturity_date is '到期日';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.rate_type is '利率类型';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.trade_purpose is '交易目的';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.counter_party_id is '交易对手ID';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.intrst_basis is '计息基准';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.portfolio_id is '投组ID';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.load_date is '计提日期';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.total_accrual_amount is '总的计提金额';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.deal_dir is '交易方向';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.ibo_type is '拆借类型';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.client_deal_sqno is '业务成交编号';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.updtd_date is '计提的更新时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_fbs_v_ibo_accrual.etl_timestamp is 'ETL处理时间戳';
