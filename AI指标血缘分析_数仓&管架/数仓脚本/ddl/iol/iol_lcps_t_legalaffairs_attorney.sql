/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol lcps_t_legalaffairs_attorney
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.lcps_t_legalaffairs_attorney
whenever sqlerror continue none;
drop table ${iol_schema}.lcps_t_legalaffairs_attorney purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lcps_t_legalaffairs_attorney(
    id varchar2(96) -- 序号
    ,office_code varchar2(96) -- 经办单位
    ,agency varchar2(96) -- 经办机构
    ,matters varchar2(315) -- 委托事项
    ,firm_name varchar2(96) -- 受托律师事务所
    ,lawyer_name varchar2(96) -- 代理律师
    ,attorney_code varchar2(96) -- 委托律师审批编号
    ,case_code varchar2(96) -- 案件编号
    ,case_name varchar2(1515) -- 案件名称
    ,signing_date date -- 签约日期
    ,start_time date -- 委托开始日期
    ,end_time date -- 委托结束日期
    ,authorization_range varchar2(2) -- 是否授权范围内（0否 1是）
    ,litigation_amount varchar2(30) -- 诉讼仲裁标的金额
    ,entrusted_amount varchar2(30) -- 委托费用条款
    ,risk_agency varchar2(2) -- 是否风险代理（0否 1是）
    ,legal_service varchar2(150) -- 诉讼仲裁事项专项（非诉讼）法律服务
    ,asset_claim varchar2(2) -- 是否是不良资产清收（0否 1是）
    ,progress varchar2(96) -- 委托事项办理进展情况
    ,agency_results varchar2(96) -- 代理结果
    ,actual_payment_amount varchar2(30) -- 费用实际支付情况
    ,end_delegation varchar2(2) -- 是否结束委托（0否 1是）
    ,status varchar2(2) -- 状态（0正常 1删除 2停用）
    ,create_by varchar2(96) -- 创建者
    ,create_date timestamp -- 创建时间
    ,update_by varchar2(96) -- 更新者
    ,update_date timestamp -- 更新时间
    ,remarks varchar2(1515) -- 备注信息
    ,corp_code varchar2(96) -- 租户代码
    ,corp_name varchar2(150) -- 租户名称
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
grant select on ${iol_schema}.lcps_t_legalaffairs_attorney to ${iml_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_attorney to ${icl_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_attorney to ${idl_schema};
grant select on ${iol_schema}.lcps_t_legalaffairs_attorney to ${iel_schema};

-- comment
comment on table ${iol_schema}.lcps_t_legalaffairs_attorney is '委托律师表';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.id is '序号';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.office_code is '经办单位';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.agency is '经办机构';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.matters is '委托事项';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.firm_name is '受托律师事务所';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.lawyer_name is '代理律师';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.attorney_code is '委托律师审批编号';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.case_code is '案件编号';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.case_name is '案件名称';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.signing_date is '签约日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.start_time is '委托开始日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.end_time is '委托结束日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.authorization_range is '是否授权范围内（0否 1是）';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.litigation_amount is '诉讼仲裁标的金额';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.entrusted_amount is '委托费用条款';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.risk_agency is '是否风险代理（0否 1是）';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.legal_service is '诉讼仲裁事项专项（非诉讼）法律服务';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.asset_claim is '是否是不良资产清收（0否 1是）';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.progress is '委托事项办理进展情况';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.agency_results is '代理结果';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.actual_payment_amount is '费用实际支付情况';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.end_delegation is '是否结束委托（0否 1是）';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.status is '状态（0正常 1删除 2停用）';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.create_by is '创建者';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.create_date is '创建时间';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.update_by is '更新者';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.update_date is '更新时间';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.remarks is '备注信息';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.corp_code is '租户代码';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.corp_name is '租户名称';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.lcps_t_legalaffairs_attorney.etl_timestamp is 'ETL处理时间戳';
