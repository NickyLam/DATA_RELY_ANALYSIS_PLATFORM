/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_cashlb_extend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_cashlb_extend
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_cashlb_extend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_cashlb_extend(
    i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,expect_take_day varchar2(15) -- 预计支取日
    ,break_contract_coupon number(30,15) -- 违约利率
    ,main_agreement_no varchar2(75) -- 主协议编号
    ,confirm_no varchar2(75) -- 确认单编号
    ,allow_take varchar2(8) -- 允许提支
    ,other_agree_item varchar2(3000) -- 其他约定事项
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
grant select on ${iol_schema}.ibms_ttrd_cashlb_extend to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_extend to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_extend to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_cashlb_extend to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_cashlb_extend is '金融工具扩展信息表';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.m_type is '市场类型';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.expect_take_day is '预计支取日';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.break_contract_coupon is '违约利率';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.main_agreement_no is '主协议编号';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.confirm_no is '确认单编号';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.allow_take is '允许提支';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.other_agree_item is '其他约定事项';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_cashlb_extend.etl_timestamp is 'ETL处理时间戳';
