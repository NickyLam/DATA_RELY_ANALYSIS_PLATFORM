/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_inv_invoice_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_inv_invoice_type
whenever sqlerror continue none;
drop table ${iol_schema}.iers_inv_invoice_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_inv_invoice_type(
    pk_inv_invoice_type varchar2(3017) -- 
    ,code varchar2(48) -- 发票编码
    ,name varchar2(48) -- 发票名称
    ,category varchar2(3017) -- 发票所属类目;0:餐饮;1:交通;2:住宿
    ,e_flag varchar2(3017) -- 是否电子发票;0:不是;1:是
    ,vat_flag varchar2(3017) -- 是否增值税发票;0:不是;1:是
    ,special_flag varchar2(3017) -- 是否专票;0:普票;1:专票
    ,dr varchar2(3017) -- 是否删除;0:否;1:是
    ,revision varchar2(3017) -- 乐观锁
    ,create_user varchar2(48) -- 创建人
    ,create_time varchar2(3017) -- 创建时间
    ,last_modified_user varchar2(48) -- 更新人
    ,last_modified_time varchar2(3017) -- 更新时间
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
grant select on ${iol_schema}.iers_inv_invoice_type to ${iml_schema};
grant select on ${iol_schema}.iers_inv_invoice_type to ${icl_schema};
grant select on ${iol_schema}.iers_inv_invoice_type to ${idl_schema};
grant select on ${iol_schema}.iers_inv_invoice_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_inv_invoice_type is '发票类型表';
comment on column ${iol_schema}.iers_inv_invoice_type.pk_inv_invoice_type is '';
comment on column ${iol_schema}.iers_inv_invoice_type.code is '发票编码';
comment on column ${iol_schema}.iers_inv_invoice_type.name is '发票名称';
comment on column ${iol_schema}.iers_inv_invoice_type.category is '发票所属类目;0:餐饮;1:交通;2:住宿';
comment on column ${iol_schema}.iers_inv_invoice_type.e_flag is '是否电子发票;0:不是;1:是';
comment on column ${iol_schema}.iers_inv_invoice_type.vat_flag is '是否增值税发票;0:不是;1:是';
comment on column ${iol_schema}.iers_inv_invoice_type.special_flag is '是否专票;0:普票;1:专票';
comment on column ${iol_schema}.iers_inv_invoice_type.dr is '是否删除;0:否;1:是';
comment on column ${iol_schema}.iers_inv_invoice_type.revision is '乐观锁';
comment on column ${iol_schema}.iers_inv_invoice_type.create_user is '创建人';
comment on column ${iol_schema}.iers_inv_invoice_type.create_time is '创建时间';
comment on column ${iol_schema}.iers_inv_invoice_type.last_modified_user is '更新人';
comment on column ${iol_schema}.iers_inv_invoice_type.last_modified_time is '更新时间';
comment on column ${iol_schema}.iers_inv_invoice_type.start_dt is '开始时间';
comment on column ${iol_schema}.iers_inv_invoice_type.end_dt is '结束时间';
comment on column ${iol_schema}.iers_inv_invoice_type.id_mark is '增删标志';
comment on column ${iol_schema}.iers_inv_invoice_type.etl_timestamp is 'ETL处理时间戳';
