/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_earnings_calc_detail_ef
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_earnings_calc_detail_ef
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_earnings_calc_detail_ef purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_earnings_calc_detail_ef(
    contractno varchar2(300) -- 借据号
    ,settledate varchar2(300) -- 会计日期，格式：yyyy-MM-dd hh:mm:ss
    ,accruedstatus varchar2(300) -- 应计状态
    ,writeoff varchar2(300) -- 核销状态
    ,totalprinbal number(24,6) -- 本金总余额
    ,rate number(24,6) -- 机构固收收益利率，年利率。注意与对客利率区分，对客利息计提还以《每日利息计提明细文件》为准。
    ,earningsamt number(24,6) -- 每日收益计提金额，等于total_prin_bal*rate/365
    ,earningsbal number(24,6) -- 日终收益余额
    ,paidearningsamt number(24,6) -- 日终累计已确认的收益金额
    ,bsntype varchar2(300) -- 产品业务类型，具体值合作产品上线后才给出
    ,subiproleid varchar2(300) -- 代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空
    ,contracttype varchar2(300) -- 借据类型
    ,fixintbase number(24,6) -- 受让留存利息，即当日资产转让明细文件中的int_bal，指转让时已结的应收未收利息和未到期的计提利息。转让时有值并作为行方固收余额。
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
grant select on ${iol_schema}.icms_mybk_earnings_calc_detail_ef to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_earnings_calc_detail_ef to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_earnings_calc_detail_ef to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_earnings_calc_detail_ef to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_earnings_calc_detail_ef is '收益计提明细文件';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.settledate is '会计日期，格式：yyyy-MM-dd hh:mm:ss';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.accruedstatus is '应计状态';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.writeoff is '核销状态';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.totalprinbal is '本金总余额';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.rate is '机构固收收益利率，年利率。注意与对客利率区分，对客利息计提还以《每日利息计提明细文件》为准。';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.earningsamt is '每日收益计提金额，等于total_prin_bal*rate/365';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.earningsbal is '日终收益余额';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.paidearningsamt is '日终累计已确认的收益金额';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.bsntype is '产品业务类型，具体值合作产品上线后才给出';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.subiproleid is '代表业务实际记账机构的iproleid，如不涉及多主体经营，该字段为空';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.contracttype is '借据类型';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.fixintbase is '受让留存利息，即当日资产转让明细文件中的int_bal，指转让时已结的应收未收利息和未到期的计提利息。转让时有值并作为行方固收余额。';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_earnings_calc_detail_ef.etl_timestamp is 'ETL处理时间戳';
