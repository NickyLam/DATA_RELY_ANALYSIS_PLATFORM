/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_pay_mark_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_pay_mark_item
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_pay_mark_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_pay_mark_item(
    stacid number(9) -- 账套
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,acctmd varchar2(4) -- 记账方式(r-红字，b-蓝字)
    ,datefq varchar2(1) -- 上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）
    ,timefq varchar2(1) -- 上划时点（1-期末,2-下期期初）
    ,itemcd varchar2(30) -- 科目编号
    ,itemna varchar2(200) -- 科目名称
    ,valutp varchar2(2) -- 取值类型(发生额:am,期初余额:bb,期末余额:eb)
    ,smrytx varchar2(300) -- 备注
    ,amntdn varchar2(3) -- 取值金额方向
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
grant select on ${iol_schema}.tgls_tax_pay_mark_item to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark_item to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark_item to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_pay_mark_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_pay_mark_item is '税费上划科目频度定义';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.acctmd is '记账方式(r-红字，b-蓝字)';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.datefq is '上划频率（1-日，2-月，3-季，4-年，5-自定义，6-半年）';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.timefq is '上划时点（1-期末,2-下期期初）';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.itemna is '科目名称';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.valutp is '取值类型(发生额:am,期初余额:bb,期末余额:eb)';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.amntdn is '取值金额方向';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_pay_mark_item.etl_timestamp is 'ETL处理时间戳';
