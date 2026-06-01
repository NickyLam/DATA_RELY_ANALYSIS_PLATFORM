/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_commission
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_commission
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_commission purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_commission(
    client_no varchar2(16) -- 客户编号
    ,country varchar2(3) -- 国家
    ,company varchar2(20) -- 法人
    ,check_date date -- 检查日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,commission_client_name varchar2(200) -- 代办人名称
    ,commission_client_no varchar2(16) -- 代办人客户号
    ,commission_document_id varchar2(60) -- 代办人证件号码
    ,commission_document_type varchar2(4) -- 代办人证件类型
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
grant select on ${iol_schema}.ncbs_rb_commission to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_commission to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_commission to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_commission to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_commission is '代办人核查登记表';
comment on column ${iol_schema}.ncbs_rb_commission.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_commission.country is '国家';
comment on column ${iol_schema}.ncbs_rb_commission.company is '法人';
comment on column ${iol_schema}.ncbs_rb_commission.check_date is '检查日期';
comment on column ${iol_schema}.ncbs_rb_commission.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_commission.commission_client_name is '代办人名称';
comment on column ${iol_schema}.ncbs_rb_commission.commission_client_no is '代办人客户号';
comment on column ${iol_schema}.ncbs_rb_commission.commission_document_id is '代办人证件号码';
comment on column ${iol_schema}.ncbs_rb_commission.commission_document_type is '代办人证件类型';
comment on column ${iol_schema}.ncbs_rb_commission.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_commission.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_commission.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_commission.etl_timestamp is 'ETL处理时间戳';
