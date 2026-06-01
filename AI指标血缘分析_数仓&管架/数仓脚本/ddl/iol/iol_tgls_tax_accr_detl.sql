/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_accr_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_accr_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_accr_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_accr_detl(
    stacid number(9) -- 账套
    ,deptcode varchar2(12) -- 计提机构编号
    ,period varchar2(10) -- 计提期间
    ,taxcode varchar2(2) -- 税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，10-车船税）
    ,taxdate varchar2(8) -- 计提日期
    ,transq varchar2(50) -- 流水号
    ,crcycd varchar2(3) -- 币种代码
    ,isprep varchar2(1) -- 是否预计提（1-预计提，0-税费计提）
    ,assecd varchar2(50) -- 资产编号
    ,assena varchar2(150) -- 资产名称
    ,itemcd varchar2(30) -- 科目编号
    ,amntcd varchar2(1) -- 借贷方向（c-贷，d-借）
    ,taxtype varchar2(2) -- 税种类型（01-企业所得税，02-递延所得税）
    ,contrst varchar2(2) -- 合同类型
    ,vatway varchar2(1) -- 计税方式（0-从价计税，1-从租计税，2-从价从租计税）
    ,landgr varchar2(2) -- 土地等级
    ,vatxrt number(8) -- 土地使用税额
    ,carstp varchar2(2) -- 车船类型
    ,itemtp varchar2(1) -- 项目类型（1-递延所得税资产，2-递延所得税负债）
    ,lsblam number(21,2) -- 资产期初税额
    ,asseam number(21,2) -- 资产发生税额
    ,assexm number(21,2) -- 资产发生金额
    ,yaseam number(21,2) -- 资产本年发生税额
    ,yasexm number(21,2) -- 资产本年发生金额
    ,onblam number(21,2) -- 资产期末税额
    ,txdpam number(21,2) -- 税法累计折旧税额
    ,cjfcam number(21,2) -- 房产从价税额
    ,czfcam number(21,2) -- 房产从租税额
    ,fromam number(21,2) -- 账面公式税额
    ,lmfmam number(21,2) -- 限额公式税额
    ,fromxm number(21,2) -- 账面公式金额
    ,lmfmxm number(21,2) -- 限额公式金额
    ,qualit varchar2(20) -- 质量（吨）
    ,amount number(21) -- 数量
    ,tpprof varchar2(2) -- 取值类型（am-发送额，bb-期初余额，eb-期末余额）
    ,zjflag varchar2(1) -- 账面价值与计税基础比较（1：大于，2：小于）
    ,smrytx varchar2(300) -- 备注
    ,creadt date -- 资产录入vat系统时间
    ,commti timestamp -- 计提时间
    ,assis1 varchar2(30) -- 辅助字段1
    ,assis2 varchar2(30) -- 辅助字段2
    ,assis3 varchar2(30) -- 辅助字段3
    ,assis4 varchar2(30) -- 辅助字段4
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
grant select on ${iol_schema}.tgls_tax_accr_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_accr_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_accr_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_accr_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_accr_detl is '申报期末增值税登记薄';
comment on column ${iol_schema}.tgls_tax_accr_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_tax_accr_detl.deptcode is '计提机构编号';
comment on column ${iol_schema}.tgls_tax_accr_detl.period is '计提期间';
comment on column ${iol_schema}.tgls_tax_accr_detl.taxcode is '税种代码（01-增值税，02-城建税，03-教育附加税，04-地方教育附加税，05-印花税，06-房产税，07-土地使用税，08-企业所得税，10-车船税）';
comment on column ${iol_schema}.tgls_tax_accr_detl.taxdate is '计提日期';
comment on column ${iol_schema}.tgls_tax_accr_detl.transq is '流水号';
comment on column ${iol_schema}.tgls_tax_accr_detl.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_tax_accr_detl.isprep is '是否预计提（1-预计提，0-税费计提）';
comment on column ${iol_schema}.tgls_tax_accr_detl.assecd is '资产编号';
comment on column ${iol_schema}.tgls_tax_accr_detl.assena is '资产名称';
comment on column ${iol_schema}.tgls_tax_accr_detl.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_tax_accr_detl.amntcd is '借贷方向（c-贷，d-借）';
comment on column ${iol_schema}.tgls_tax_accr_detl.taxtype is '税种类型（01-企业所得税，02-递延所得税）';
comment on column ${iol_schema}.tgls_tax_accr_detl.contrst is '合同类型';
comment on column ${iol_schema}.tgls_tax_accr_detl.vatway is '计税方式（0-从价计税，1-从租计税，2-从价从租计税）';
comment on column ${iol_schema}.tgls_tax_accr_detl.landgr is '土地等级';
comment on column ${iol_schema}.tgls_tax_accr_detl.vatxrt is '土地使用税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.carstp is '车船类型';
comment on column ${iol_schema}.tgls_tax_accr_detl.itemtp is '项目类型（1-递延所得税资产，2-递延所得税负债）';
comment on column ${iol_schema}.tgls_tax_accr_detl.lsblam is '资产期初税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.asseam is '资产发生税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.assexm is '资产发生金额';
comment on column ${iol_schema}.tgls_tax_accr_detl.yaseam is '资产本年发生税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.yasexm is '资产本年发生金额';
comment on column ${iol_schema}.tgls_tax_accr_detl.onblam is '资产期末税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.txdpam is '税法累计折旧税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.cjfcam is '房产从价税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.czfcam is '房产从租税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.fromam is '账面公式税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.lmfmam is '限额公式税额';
comment on column ${iol_schema}.tgls_tax_accr_detl.fromxm is '账面公式金额';
comment on column ${iol_schema}.tgls_tax_accr_detl.lmfmxm is '限额公式金额';
comment on column ${iol_schema}.tgls_tax_accr_detl.qualit is '质量（吨）';
comment on column ${iol_schema}.tgls_tax_accr_detl.amount is '数量';
comment on column ${iol_schema}.tgls_tax_accr_detl.tpprof is '取值类型（am-发送额，bb-期初余额，eb-期末余额）';
comment on column ${iol_schema}.tgls_tax_accr_detl.zjflag is '账面价值与计税基础比较（1：大于，2：小于）';
comment on column ${iol_schema}.tgls_tax_accr_detl.smrytx is '备注';
comment on column ${iol_schema}.tgls_tax_accr_detl.creadt is '资产录入vat系统时间';
comment on column ${iol_schema}.tgls_tax_accr_detl.commti is '计提时间';
comment on column ${iol_schema}.tgls_tax_accr_detl.assis1 is '辅助字段1';
comment on column ${iol_schema}.tgls_tax_accr_detl.assis2 is '辅助字段2';
comment on column ${iol_schema}.tgls_tax_accr_detl.assis3 is '辅助字段3';
comment on column ${iol_schema}.tgls_tax_accr_detl.assis4 is '辅助字段4';
comment on column ${iol_schema}.tgls_tax_accr_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_tax_accr_detl.etl_timestamp is 'ETL处理时间戳';
