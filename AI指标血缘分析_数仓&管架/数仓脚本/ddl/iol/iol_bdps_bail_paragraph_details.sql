/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_bail_paragraph_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_bail_paragraph_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_bail_paragraph_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bail_paragraph_details(
    id number(22) -- 
    ,contract_no varchar2(60) -- 合同号
    ,loan_appno varchar2(60) -- 借据号
    ,draft_key varchar2(45) -- 票据唯一标识
    ,draft_number varchar2(45) -- 票据号码
    ,back_time date -- 备款时间
    ,bail_account varchar2(60) -- 保证金账号
    ,bail_sub_no varchar2(60) -- 客户保证金子编号
    ,bail_amount number(18,2) -- 保证金余额
    ,coneal_nbr varchar2(30) -- 止付流水
    ,unfreeze_nbr varchar2(30) -- 解付流水
    ,pool_type varchar2(2) -- 票据池类型 1-票据池 2-资产池
    ,status varchar2(2) -- 备款状态 1-成功  2-失败  （以借据为单位时可不填）
    ,remarks varchar2(750) -- 备注
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
grant select on ${iol_schema}.bdps_bail_paragraph_details to ${iml_schema};
grant select on ${iol_schema}.bdps_bail_paragraph_details to ${icl_schema};
grant select on ${iol_schema}.bdps_bail_paragraph_details to ${idl_schema};
grant select on ${iol_schema}.bdps_bail_paragraph_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_bail_paragraph_details is '保证金备款明细表';
comment on column ${iol_schema}.bdps_bail_paragraph_details.id is '';
comment on column ${iol_schema}.bdps_bail_paragraph_details.contract_no is '合同号';
comment on column ${iol_schema}.bdps_bail_paragraph_details.loan_appno is '借据号';
comment on column ${iol_schema}.bdps_bail_paragraph_details.draft_key is '票据唯一标识';
comment on column ${iol_schema}.bdps_bail_paragraph_details.draft_number is '票据号码';
comment on column ${iol_schema}.bdps_bail_paragraph_details.back_time is '备款时间';
comment on column ${iol_schema}.bdps_bail_paragraph_details.bail_account is '保证金账号';
comment on column ${iol_schema}.bdps_bail_paragraph_details.bail_sub_no is '客户保证金子编号';
comment on column ${iol_schema}.bdps_bail_paragraph_details.bail_amount is '保证金余额';
comment on column ${iol_schema}.bdps_bail_paragraph_details.coneal_nbr is '止付流水';
comment on column ${iol_schema}.bdps_bail_paragraph_details.unfreeze_nbr is '解付流水';
comment on column ${iol_schema}.bdps_bail_paragraph_details.pool_type is '票据池类型 1-票据池 2-资产池';
comment on column ${iol_schema}.bdps_bail_paragraph_details.status is '备款状态 1-成功  2-失败  （以借据为单位时可不填）';
comment on column ${iol_schema}.bdps_bail_paragraph_details.remarks is '备注';
comment on column ${iol_schema}.bdps_bail_paragraph_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_bail_paragraph_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_bail_paragraph_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_bail_paragraph_details.etl_timestamp is 'ETL处理时间戳';
