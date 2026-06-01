/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_glis_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_glis_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_glis_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_glis_h(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 系统id
    ,acctdt varchar2(8) -- 账务日期
    ,brchcd varchar2(12) -- 机构编号（总账机构）
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,geldtp varchar2(1) -- 总账类型(d日总帐t旬总账m月总帐q季总帐h半年总账y年总帐)
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 业务条线
    ,acctno varchar2(30) -- 账户
    ,assis0 varchar2(30) -- 辅助核算0（自定义）
    ,assis1 varchar2(30) -- 辅助核算1（自定义）
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,drltbl number(20,2) -- 借方上日余额
    ,crltbl number(20,2) -- 贷方上日余额
    ,drtsam number(20,2) -- 借方本日发生额
    ,drtsnm number -- 借方本日发生笔数
    ,crtsam number(20,2) -- 贷方本日发生额
    ,crtsnm number -- 贷方本日发生笔数
    ,drctbl number(20,2) -- 本期借方余额
    ,crctbl number(20,2) -- 本期贷方余额
    ,blncdn varchar2(9) -- 当前余额方向
    ,onlnbl number(20,2) -- 当前余额
    ,lastdn varchar2(9) -- 上期余额方向
    ,lastbl number(20,2) -- 上期余额
    ,detltg varchar2(1) -- 是否末级编码(1:末级,0:非末级)
    ,drtsaj number(20,2) -- 借方外币折算调整值
    ,crtsaj number(20,2) -- 贷方外币折算调整值
    ,tranti timestamp -- 时间戳
    ,dlflcbl number(32,2) -- 本位币期初借方余额
    ,foldcn number(20,2) -- 本位币金额
    ,clflcbl number(20,2) -- 本位币期初贷方余额
    ,dtflcam number(20,2) -- 本位币借方本期发生额
    ,ctflcam number(20,2) -- 本位币贷方本期发生额
    ,drflcbl number(20,2) -- 本位币期末借方余额
    ,crflcbl number(20,2) -- 本位币期末贷方余额
    ,dblprod number(38,2) -- 借方余额积数
    ,cblprod number(38,2) -- 贷方余额积数
    ,itemna varchar2(200) -- 科目名称
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
grant select on ${iol_schema}.tgls_gla_glis_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_glis_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_glis_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_glis_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_glis_h is '总账历史表';
comment on column ${iol_schema}.tgls_gla_glis_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_glis_h.systid is '系统id';
comment on column ${iol_schema}.tgls_gla_glis_h.acctdt is '账务日期';
comment on column ${iol_schema}.tgls_gla_glis_h.brchcd is '机构编号（总账机构）';
comment on column ${iol_schema}.tgls_gla_glis_h.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_glis_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_glis_h.geldtp is '总账类型(d日总帐t旬总账m月总帐q季总帐h半年总账y年总帐)';
comment on column ${iol_schema}.tgls_gla_glis_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_glis_h.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_glis_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_glis_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_glis_h.prlncd is '业务条线';
comment on column ${iol_schema}.tgls_gla_glis_h.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_glis_h.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_glis_h.drltbl is '借方上日余额';
comment on column ${iol_schema}.tgls_gla_glis_h.crltbl is '贷方上日余额';
comment on column ${iol_schema}.tgls_gla_glis_h.drtsam is '借方本日发生额';
comment on column ${iol_schema}.tgls_gla_glis_h.drtsnm is '借方本日发生笔数';
comment on column ${iol_schema}.tgls_gla_glis_h.crtsam is '贷方本日发生额';
comment on column ${iol_schema}.tgls_gla_glis_h.crtsnm is '贷方本日发生笔数';
comment on column ${iol_schema}.tgls_gla_glis_h.drctbl is '本期借方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.crctbl is '本期贷方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.blncdn is '当前余额方向';
comment on column ${iol_schema}.tgls_gla_glis_h.onlnbl is '当前余额';
comment on column ${iol_schema}.tgls_gla_glis_h.lastdn is '上期余额方向';
comment on column ${iol_schema}.tgls_gla_glis_h.lastbl is '上期余额';
comment on column ${iol_schema}.tgls_gla_glis_h.detltg is '是否末级编码(1:末级,0:非末级)';
comment on column ${iol_schema}.tgls_gla_glis_h.drtsaj is '借方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis_h.crtsaj is '贷方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis_h.tranti is '时间戳';
comment on column ${iol_schema}.tgls_gla_glis_h.dlflcbl is '本位币期初借方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.foldcn is '本位币金额';
comment on column ${iol_schema}.tgls_gla_glis_h.clflcbl is '本位币期初贷方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.dtflcam is '本位币借方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis_h.ctflcam is '本位币贷方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis_h.drflcbl is '本位币期末借方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.crflcbl is '本位币期末贷方余额';
comment on column ${iol_schema}.tgls_gla_glis_h.dblprod is '借方余额积数';
comment on column ${iol_schema}.tgls_gla_glis_h.cblprod is '贷方余额积数';
comment on column ${iol_schema}.tgls_gla_glis_h.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gla_glis_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_glis_h.etl_timestamp is 'ETL处理时间戳';
