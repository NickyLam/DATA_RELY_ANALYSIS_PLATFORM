/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_type_stam
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_type_stam
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_type_stam purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_type_stam(
    stacid varchar2(19) -- 账套标记
    ,taxscd varchar2(2) -- 税种代码
    ,deptcd varchar2(12) -- 机构编号
    ,vatxrt number(8,3) -- 税率/单价
    ,begndt varchar2(8) -- 生效日期
    ,endddt varchar2(8) -- 失效日期
    ,smrytx varchar2(400) -- 备注
    ,valutp varchar2(1) -- 计价方式（0：从价，1：从量）
    ,contrst varchar2(2) -- 合同类型
    ,precis varchar2(1) -- 取值精度（0：元，1：角，2：分）
    ,morewy varchar2(1) -- 取余方式（0：按精度向下取整，1：按精度向上取整）
    ,attribute1 varchar2(4000) -- 弹性域列(备用)
    ,attribute2 varchar2(4000) -- 弹性域列(备用)
    ,attribute3 varchar2(4000) -- 弹性域列(备用)
    ,savedt varchar2(17) -- 数据写入时间
    ,wtrelo varchar2(1) -- 是否循环贷(y/n/h)h:不涉及
    ,salprd varchar2(32) -- 可售产品(取多维里面的产品)
    ,valtyp varchar2(6) -- 取值类型(印花税合同信息金额字段)
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
grant select on ${iol_schema}.tgls_tax_type_stam to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_type_stam to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_type_stam to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_type_stam to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_type_stam is '印花税定义表';
comment on column ${iol_schema}.tgls_tax_type_stam.stacid is '账套标记';
comment on column ${iol_schema}.tgls_tax_type_stam.taxscd is '税种代码';
comment on column ${iol_schema}.tgls_tax_type_stam.deptcd is '机构编号';
comment on column ${iol_schema}.tgls_tax_type_stam.vatxrt is '税率/单价';
comment on column ${iol_schema}.tgls_tax_type_stam.begndt is '生效日期';
comment on column ${iol_schema}.tgls_tax_type_stam.endddt is '失效日期';
comment on column ${iol_schema}.tgls_tax_type_stam.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_type_stam.valutp is '计价方式（0：从价，1：从量）';
comment on column ${iol_schema}.tgls_tax_type_stam.contrst is '合同类型';
comment on column ${iol_schema}.tgls_tax_type_stam.precis is '取值精度（0：元，1：角，2：分）';
comment on column ${iol_schema}.tgls_tax_type_stam.morewy is '取余方式（0：按精度向下取整，1：按精度向上取整）';
comment on column ${iol_schema}.tgls_tax_type_stam.attribute1 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_stam.attribute2 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_stam.attribute3 is '弹性域列(备用)';
comment on column ${iol_schema}.tgls_tax_type_stam.savedt is '数据写入时间';
comment on column ${iol_schema}.tgls_tax_type_stam.wtrelo is '是否循环贷(y/n/h)h:不涉及';
comment on column ${iol_schema}.tgls_tax_type_stam.salprd is '可售产品(取多维里面的产品)';
comment on column ${iol_schema}.tgls_tax_type_stam.valtyp is '取值类型(印花税合同信息金额字段)';
comment on column ${iol_schema}.tgls_tax_type_stam.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_type_stam.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_type_stam.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_type_stam.etl_timestamp is 'ETL处理时间戳';
