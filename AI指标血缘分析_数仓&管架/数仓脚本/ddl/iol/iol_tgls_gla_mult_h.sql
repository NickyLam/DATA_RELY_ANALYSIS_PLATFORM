/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_mult_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_mult_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_mult_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_mult_h(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,acctdt varchar2(8) -- 账务会计日期
    ,brchcd varchar2(12) -- 机构编号（总账机构）
    ,itemcd varchar2(30) -- 科目编号
    ,crcycd varchar2(3) -- 币种代码
    ,geldtp varchar2(1) -- 总账类型(d日总帐m月总帐q季总帐y年总帐)
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
    ,blncdn varchar2(1) -- 当前科目余额方向
    ,onlnbl number(20,2) -- 当前余额
    ,lastdn varchar2(1) -- 上期科目余额方向
    ,lastbl number(20,2) -- 上期余额
    ,detltg varchar2(1) -- 是否末级编码(1:末级,0:非末级)
    ,tranti timestamp -- 分区用的时间
    ,dlflcbl number(32,2) -- 本位币期初借方金额
    ,clflcbl number(32,2) -- 本位币期初贷方金额
    ,dtflcam number(20,2) -- 本位币借方发生额
    ,ctflcam number(20,2) -- 本位币贷方发生额
    ,drflcbl number(32,2) -- 本位币期末借方余额
    ,crflcbl number(32,2) -- 本位币期末贷方余额
    ,blprod number(32,2) -- 余额积数
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
grant select on ${iol_schema}.tgls_gla_mult_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_mult_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_mult_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_mult_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_mult_h is '多维总账汇总表';
comment on column ${iol_schema}.tgls_gla_mult_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_mult_h.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_gla_mult_h.acctdt is '账务会计日期';
comment on column ${iol_schema}.tgls_gla_mult_h.brchcd is '机构编号（总账机构）';
comment on column ${iol_schema}.tgls_gla_mult_h.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_mult_h.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_mult_h.geldtp is '总账类型(d日总帐m月总帐q季总帐y年总帐)';
comment on column ${iol_schema}.tgls_gla_mult_h.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_mult_h.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_mult_h.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_mult_h.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_mult_h.prlncd is '业务条线';
comment on column ${iol_schema}.tgls_gla_mult_h.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_mult_h.assis0 is '辅助核算0（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis1 is '辅助核算1（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_mult_h.drltbl is '借方上日余额';
comment on column ${iol_schema}.tgls_gla_mult_h.crltbl is '贷方上日余额';
comment on column ${iol_schema}.tgls_gla_mult_h.drtsam is '借方本日发生额';
comment on column ${iol_schema}.tgls_gla_mult_h.drtsnm is '借方本日发生笔数';
comment on column ${iol_schema}.tgls_gla_mult_h.crtsam is '贷方本日发生额';
comment on column ${iol_schema}.tgls_gla_mult_h.crtsnm is '贷方本日发生笔数';
comment on column ${iol_schema}.tgls_gla_mult_h.drctbl is '本期借方余额';
comment on column ${iol_schema}.tgls_gla_mult_h.crctbl is '本期贷方余额';
comment on column ${iol_schema}.tgls_gla_mult_h.blncdn is '当前科目余额方向';
comment on column ${iol_schema}.tgls_gla_mult_h.onlnbl is '当前余额';
comment on column ${iol_schema}.tgls_gla_mult_h.lastdn is '上期科目余额方向';
comment on column ${iol_schema}.tgls_gla_mult_h.lastbl is '上期余额';
comment on column ${iol_schema}.tgls_gla_mult_h.detltg is '是否末级编码(1:末级,0:非末级)';
comment on column ${iol_schema}.tgls_gla_mult_h.tranti is '分区用的时间';
comment on column ${iol_schema}.tgls_gla_mult_h.dlflcbl is '本位币期初借方金额';
comment on column ${iol_schema}.tgls_gla_mult_h.clflcbl is '本位币期初贷方金额';
comment on column ${iol_schema}.tgls_gla_mult_h.dtflcam is '本位币借方发生额';
comment on column ${iol_schema}.tgls_gla_mult_h.ctflcam is '本位币贷方发生额';
comment on column ${iol_schema}.tgls_gla_mult_h.drflcbl is '本位币期末借方余额';
comment on column ${iol_schema}.tgls_gla_mult_h.crflcbl is '本位币期末贷方余额';
comment on column ${iol_schema}.tgls_gla_mult_h.blprod is '余额积数';
comment on column ${iol_schema}.tgls_gla_mult_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_mult_h.etl_timestamp is 'ETL处理时间戳';
