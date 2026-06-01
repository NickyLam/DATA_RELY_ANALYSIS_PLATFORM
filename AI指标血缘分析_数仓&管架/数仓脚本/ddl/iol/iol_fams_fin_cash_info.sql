/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_cash_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_cash_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_cash_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_cash_info(
    cash_id varchar2(32) -- 现金流代码，md5(业务代码+(char)256+业务类型+(char)256+分支序号+(char)256+现金流二级类型)
    ,cash_type_1 varchar2(50) -- 现金流一级类型，本金、利息、费用、税额
    ,cash_type_2 varchar2(50) -- 现金流二级类型，本金、利息、托管费、固定管理费、浮动管理费、税额、通道托管费、通道管理费等
    ,ccy varchar2(50) -- 币种，本金、利息币种可能不一致。
    ,finprod_id varchar2(50) -- 业务代码，可以是金融产品代码、资金账号代码等。
    ,finprod_type varchar2(50) -- 业务类型，金融产品、资金账号等。
    ,branch number(10) -- 分支序号
    ,fee_id varchar2(32) -- 费用品种代码
    ,chl_finprod_id varchar2(50) -- 通道金融产品代码，如果是资产挂通道费时存储
    ,chl_level number(10) -- 通道层级，如果是资产挂通道费时存储
    ,is_calc varchar2(50) -- 是否参与计算
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,collect_type varchar2(50) -- 收取方式
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fin_cash_info to ${iml_schema};
grant select on ${iol_schema}.fams_fin_cash_info to ${icl_schema};
grant select on ${iol_schema}.fams_fin_cash_info to ${idl_schema};
grant select on ${iol_schema}.fams_fin_cash_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_cash_info is '现金流信息';
comment on column ${iol_schema}.fams_fin_cash_info.cash_id is '现金流代码，md5(业务代码+(char)256+业务类型+(char)256+分支序号+(char)256+现金流二级类型)';
comment on column ${iol_schema}.fams_fin_cash_info.cash_type_1 is '现金流一级类型，本金、利息、费用、税额';
comment on column ${iol_schema}.fams_fin_cash_info.cash_type_2 is '现金流二级类型，本金、利息、托管费、固定管理费、浮动管理费、税额、通道托管费、通道管理费等';
comment on column ${iol_schema}.fams_fin_cash_info.ccy is '币种，本金、利息币种可能不一致。';
comment on column ${iol_schema}.fams_fin_cash_info.finprod_id is '业务代码，可以是金融产品代码、资金账号代码等。';
comment on column ${iol_schema}.fams_fin_cash_info.finprod_type is '业务类型，金融产品、资金账号等。';
comment on column ${iol_schema}.fams_fin_cash_info.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_cash_info.fee_id is '费用品种代码';
comment on column ${iol_schema}.fams_fin_cash_info.chl_finprod_id is '通道金融产品代码，如果是资产挂通道费时存储';
comment on column ${iol_schema}.fams_fin_cash_info.chl_level is '通道层级，如果是资产挂通道费时存储';
comment on column ${iol_schema}.fams_fin_cash_info.is_calc is '是否参与计算';
comment on column ${iol_schema}.fams_fin_cash_info.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_cash_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_cash_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_cash_info.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_cash_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_cash_info.collect_type is '收取方式';
comment on column ${iol_schema}.fams_fin_cash_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_cash_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_cash_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_cash_info.etl_timestamp is 'ETL处理时间戳';
