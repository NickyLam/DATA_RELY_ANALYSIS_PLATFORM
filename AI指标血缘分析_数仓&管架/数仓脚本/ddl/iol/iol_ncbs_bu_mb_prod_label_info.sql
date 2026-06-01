/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_bu_mb_prod_label_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_bu_mb_prod_label_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_bu_mb_prod_label_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_bu_mb_prod_label_info(
    seq_no varchar2(50) -- 序号
    ,prod_type varchar2(12) -- 产品编号
    ,label_key varchar2(200) -- 标签键
    ,label_value varchar2(1000) -- 标签值
    ,label_value_desc varchar2(1000) -- 标签值描述
    ,om_dept_id varchar2(30) -- 部门编号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,user_id varchar2(30) -- 交易柜员
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
grant select on ${iol_schema}.ncbs_bu_mb_prod_label_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_bu_mb_prod_label_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_bu_mb_prod_label_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_bu_mb_prod_label_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_bu_mb_prod_label_info is '产品标签信息表|产品标签信息表';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.label_key is '标签键';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.label_value is '标签值';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.label_value_desc is '标签值描述';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.om_dept_id is '部门编号';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.user_id is '交易柜员';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_bu_mb_prod_label_info.etl_timestamp is 'ETL处理时间戳';
