/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_accr_vchr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_accr_vchr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_accr_vchr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_accr_vchr(
    stacid number(9) -- 账套
    ,deptcode varchar2(12) -- 机构编号
    ,period varchar2(10) -- 计提期间
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,soursq varchar2(50) -- 源流水号
    ,transq varchar2(50) -- 流水号
    ,vchrsq varchar2(20) -- 传票流水号
    ,isprep varchar2(1) -- 是否预计提（1-预计提，0-税费计提）
    ,vchrtp varchar2(1) -- 分录类型（1-计提出账2-缴纳出账3-冲销出账4-上划出账5-计提入账6-上划入账）
    ,acctbr varchar2(12) -- 记账机构编号
    ,trandt varchar2(8) -- 交易日期
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,smrytx varchar2(255) -- 备注
    ,commti timestamp -- 分录时间
    ,tranam_beq number(20,2) -- 
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
grant select on ${iol_schema}.tgls_tax_accr_vchr to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_accr_vchr to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_accr_vchr to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_accr_vchr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_accr_vchr is '税务会计分录表';
comment on column ${iol_schema}.tgls_tax_accr_vchr.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_accr_vchr.deptcode is '机构编号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.period is '计提期间';
comment on column ${iol_schema}.tgls_tax_accr_vchr.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_accr_vchr.soursq is '源流水号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.transq is '流水号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.vchrsq is '传票流水号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.isprep is '是否预计提（1-预计提，0-税费计提）';
comment on column ${iol_schema}.tgls_tax_accr_vchr.vchrtp is '分录类型（1-计提出账2-缴纳出账3-冲销出账4-上划出账5-计提入账6-上划入账）';
comment on column ${iol_schema}.tgls_tax_accr_vchr.acctbr is '记账机构编号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.trandt is '交易日期';
comment on column ${iol_schema}.tgls_tax_accr_vchr.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_accr_vchr.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_tax_accr_vchr.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_tax_accr_vchr.tranam is '交易金额';
comment on column ${iol_schema}.tgls_tax_accr_vchr.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_accr_vchr.commti is '分录时间';
comment on column ${iol_schema}.tgls_tax_accr_vchr.tranam_beq is '';
comment on column ${iol_schema}.tgls_tax_accr_vchr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_accr_vchr.etl_timestamp is 'ETL处理时间戳';
