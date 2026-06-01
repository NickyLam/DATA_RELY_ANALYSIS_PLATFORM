/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_accr_rept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_accr_rept
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_accr_rept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_accr_rept(
    stacid number(9) -- 账套
    ,deptcode varchar2(12) -- 计提机构编号
    ,period varchar2(10) -- 计提期间
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）
    ,crcycd varchar2(3) -- 币种代码
    ,taxdate varchar2(8) -- 计提日期
    ,acctbr varchar2(12) -- 记账机构编号
    ,accram number(21,2) -- 本期计提金额
    ,yacram number(21,2) -- 本年累计计提金额
    ,adjuam number(21,2) -- 本期调整金额
    ,lsblam number(21,2) -- 期初应缴纳金额
    ,apayam number(21,2) -- 本期应缴纳金额
    ,onblam number(21,2) -- 期末应缴纳金额
    ,ypayam number(21,2) -- 本期已缴纳金额
    ,yypaam number(21,2) -- 本年累计已缴纳金额
    ,markam number(21,2) -- 本期上划金额
    ,ymaram number(21,2) -- 本年累计上划金额
    ,vatxrt number(17,8) -- 税率
    ,sendsq varchar2(50) -- 发送总账报文流水
    ,revesq varchar2(50) -- 发送总账冲销流水
    ,status varchar2(1) -- 计提状态（2-已冲销，3-已计提，4-计提出账失败，5-已计提出账，6-缴纳出账失败，7-已缴纳出账，8-发送核心失败，9-发送核心成功）
    ,isvchr varchar2(1) -- 是否生成会计分录（0-未生成，1-已生成）
    ,commti timestamp -- 计提时间
    ,smrytx varchar2(300) -- 备注
    ,startdate varchar2(8) -- 结束日期
    ,enddate varchar2(8) -- 开始日期
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
grant select on ${iol_schema}.tgls_tax_accr_rept to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_accr_rept to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_accr_rept to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_accr_rept to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_accr_rept is '税费计提表';
comment on column ${iol_schema}.tgls_tax_accr_rept.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_accr_rept.deptcode is '计提机构编号';
comment on column ${iol_schema}.tgls_tax_accr_rept.period is '计提期间';
comment on column ${iol_schema}.tgls_tax_accr_rept.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，09-递延所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_accr_rept.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_tax_accr_rept.taxdate is '计提日期';
comment on column ${iol_schema}.tgls_tax_accr_rept.acctbr is '记账机构编号';
comment on column ${iol_schema}.tgls_tax_accr_rept.accram is '本期计提金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.yacram is '本年累计计提金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.adjuam is '本期调整金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.lsblam is '期初应缴纳金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.apayam is '本期应缴纳金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.onblam is '期末应缴纳金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.ypayam is '本期已缴纳金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.yypaam is '本年累计已缴纳金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.markam is '本期上划金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.ymaram is '本年累计上划金额';
comment on column ${iol_schema}.tgls_tax_accr_rept.vatxrt is '税率';
comment on column ${iol_schema}.tgls_tax_accr_rept.sendsq is '发送总账报文流水';
comment on column ${iol_schema}.tgls_tax_accr_rept.revesq is '发送总账冲销流水';
comment on column ${iol_schema}.tgls_tax_accr_rept.status is '计提状态（2-已冲销，3-已计提，4-计提出账失败，5-已计提出账，6-缴纳出账失败，7-已缴纳出账，8-发送核心失败，9-发送核心成功）';
comment on column ${iol_schema}.tgls_tax_accr_rept.isvchr is '是否生成会计分录（0-未生成，1-已生成）';
comment on column ${iol_schema}.tgls_tax_accr_rept.commti is '计提时间';
comment on column ${iol_schema}.tgls_tax_accr_rept.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_accr_rept.startdate is '结束日期';
comment on column ${iol_schema}.tgls_tax_accr_rept.enddate is '开始日期';
comment on column ${iol_schema}.tgls_tax_accr_rept.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_accr_rept.etl_timestamp is 'ETL处理时间戳';
