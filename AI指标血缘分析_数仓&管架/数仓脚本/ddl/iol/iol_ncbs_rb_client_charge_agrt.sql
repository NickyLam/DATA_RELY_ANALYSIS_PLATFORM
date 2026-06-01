/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_client_charge_agrt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_client_charge_agrt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_client_charge_agrt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_charge_agrt(
    client_no varchar2(16) -- 客户编号
    ,period_freq varchar2(5) -- 频率id
    ,agreement_id varchar2(50) -- 协议编号
    ,charge_way varchar2(1) -- 收费方式
    ,company varchar2(20) -- 法人
    ,fee_type varchar2(20) -- 费率类型
    ,oth_business_no varchar2(200) -- 对手业务编号
    ,seq_no varchar2(50) -- 序号
    ,status varchar2(1) -- 状态
    ,next_charge_date date -- 下一收费日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,charge_day varchar2(2) -- 收费日
    ,oth_name varchar2(200) -- 对手名称
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
grant select on ${iol_schema}.ncbs_rb_client_charge_agrt to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_client_charge_agrt to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_client_charge_agrt to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_client_charge_agrt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_client_charge_agrt is '客户收费协议';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.charge_way is '收费方式';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.company is '法人';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.oth_business_no is '对手业务编号';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.status is '状态';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.next_charge_date is '下一收费日期';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.charge_day is '收费日';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.oth_name is '对手名称';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_client_charge_agrt.etl_timestamp is 'ETL处理时间戳';
