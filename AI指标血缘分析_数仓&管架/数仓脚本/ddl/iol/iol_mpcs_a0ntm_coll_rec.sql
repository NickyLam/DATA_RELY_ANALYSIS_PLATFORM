/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_coll_rec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_coll_rec
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_coll_rec purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_coll_rec(
    org varchar2(18) -- 机构号
    ,coll_rec_id number(22,0) -- 催记流水号
    ,case_no varchar2(48) -- 案件编号
    ,cust_id number(20,0) -- 客户编号
    ,coll_rec_type varchar2(15) -- 催记类型
    ,action_code varchar2(15) -- 催收动作
    ,buser_field21 varchar2(2) -- 系统备用域21
    ,buser_field22 varchar2(6) -- 系统备用域22
    ,coll_time date -- 催收时间
    ,coll_conseq varchar2(15) -- 催收结果
    ,prom_amt number(15,2) -- 承诺金额
    ,prom_date date -- 承诺日期
    ,remark varchar2(600) -- 备注
    ,buser_field23 number(15,2) -- 系统备用域23
    ,buser_field24 varchar2(15) -- 系统备用域24
    ,buser_field25 varchar2(15) -- 系统备用域25
    ,buser_field26 varchar2(15) -- 系统备用域26
    ,buser_field27 varchar2(15) -- 系统备用域27
    ,buser_field28 varchar2(15) -- 系统备用域28
    ,buser_field29 varchar2(15) -- 系统备用域29
    ,buser_field30 varchar2(30) -- 系统备用域30
    ,buser_field31 varchar2(75) -- 系统备用域31
    ,buser_field32 varchar2(75) -- 系统备用域32
    ,buser_field33 varchar2(15) -- 系统备用域33
    ,buser_field34 varchar2(15) -- 系统备用域34
    ,buser_field35 varchar2(75) -- 系统备用域35
    ,buser_field36 varchar2(75) -- 系统备用域36
    ,created_datetime date -- 创建时间
    ,last_modified_datetime date -- 最后修改时间
    ,jpa_version number(22,0) -- jpa_version
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
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
grant select on ${iol_schema}.mpcs_a0ntm_coll_rec to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_coll_rec to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_coll_rec to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_coll_rec to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_coll_rec is '催收记录表';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.coll_rec_id is '催记流水号';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.case_no is '案件编号';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.cust_id is '客户编号';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.coll_rec_type is '催记类型';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.action_code is '催收动作';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field21 is '系统备用域21';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field22 is '系统备用域22';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.coll_time is '催收时间';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.coll_conseq is '催收结果';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.prom_amt is '承诺金额';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.prom_date is '承诺日期';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.remark is '备注';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field23 is '系统备用域23';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field24 is '系统备用域24';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field25 is '系统备用域25';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field26 is '系统备用域26';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field27 is '系统备用域27';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field28 is '系统备用域28';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field29 is '系统备用域29';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field30 is '系统备用域30';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field31 is '系统备用域31';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field32 is '系统备用域32';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field33 is '系统备用域33';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field34 is '系统备用域34';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field35 is '系统备用域35';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.buser_field36 is '系统备用域36';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.created_datetime is '创建时间';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.last_modified_datetime is '最后修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.jpa_version is 'jpa_version';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a0ntm_coll_rec.etl_timestamp is 'ETL处理时间戳';
