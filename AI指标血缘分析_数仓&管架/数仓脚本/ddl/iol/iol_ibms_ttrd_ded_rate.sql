/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ded_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ded_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ded_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ded_rate(
    id number(22) -- 序号
    ,def_id number(11,0) -- 活期金融工具定义序号
    ,rate number(31,6) -- 利率
    ,beg_date varchar2(15) -- 有效期起始日期
    ,end_date varchar2(15) -- 有效期结束日期
    ,imp_time varchar2(29) -- 导入时间
    ,update_time varchar2(29) -- 更新时间
    ,update_user varchar2(150) -- 更新者
    ,create_time varchar2(29) -- 创建时间
    ,create_user varchar2(30) -- 创建者
    ,confirm_id varchar2(75) -- 确认单编号
    ,create4txy varchar2(3) -- 是否是同兴赢维护数据，0或空为否，1为是
    ,signing_amount number(38,4) -- 签约额度
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
grant select on ${iol_schema}.ibms_ttrd_ded_rate to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ded_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ded_rate is '活期金额工具利率序列';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.id is '序号';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.def_id is '活期金融工具定义序号';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.rate is '利率';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.beg_date is '有效期起始日期';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.end_date is '有效期结束日期';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.update_user is '更新者';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.create_time is '创建时间';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.create_user is '创建者';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.confirm_id is '确认单编号';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.create4txy is '是否是同兴赢维护数据，0或空为否，1为是';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.signing_amount is '签约额度';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_ded_rate.etl_timestamp is 'ETL处理时间戳';
