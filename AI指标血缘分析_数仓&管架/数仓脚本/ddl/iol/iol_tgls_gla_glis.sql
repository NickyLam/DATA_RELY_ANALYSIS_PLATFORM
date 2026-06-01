/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_glis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_glis
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_glis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_glis(
    stacid number(19) -- 账套标记
    ,systid varchar2(30) -- 来源系统编号
    ,acctdt varchar2(8) -- 账务会计日期
    ,brchcd varchar2(12) -- 机构编号（总账机构）
    ,itemcd varchar2(30) -- 科目编号
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（自定义）
    ,assis3 varchar2(30) -- 辅助核算3（自定义）
    ,assis4 varchar2(30) -- 辅助核算4（自定义）
    ,assis5 varchar2(30) -- 辅助核算5（自定义）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,geldtp varchar2(1) -- 总账类型(d日总帐m月总帐q季总帐y年总帐)
    ,crcycd varchar2(3) -- 币种代码
    ,drltbl number(20,2) -- 上期借方余额
    ,crltbl number(20,2) -- 上期贷方余额
    ,drtsam number(20,2) -- 本期借方发生额
    ,drtsnm number -- 借方本期发生笔数
    ,crtsam number(20,2) -- 本期贷方发生额
    ,crtsnm number -- 贷方本期发生笔数
    ,drctbl number(20,2) -- 本期借方余额
    ,crctbl number(20,2) -- 本期贷方余额
    ,blncdn varchar2(1) -- 当前科目余额方向
    ,onlnbl number(20,2) -- 当前余额
    ,lastdn varchar2(1) -- 上期科目余额方向
    ,lastbl number(20,2) -- 上期余额
    ,drtsaj number(20,2) -- 借方外币折算调整值
    ,crtsaj number(20,2) -- 贷方外币折算调整值
    ,dlflcbl number(32,2) -- 本位币期初借方余额
    ,clflcbl number(20,2) -- 本位币期初贷方余额
    ,dtflcam number(20,2) -- 本位币借方本期发生额
    ,ctflcam number(20,2) -- 本位币贷方本期发生额
    ,drflcbl number(20,2) -- 本位币期末借方余额
    ,crflcbl number(20,2) -- 本位币期末贷方余额
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
grant select on ${iol_schema}.tgls_gla_glis to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_glis to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_glis to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_glis to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_glis is '总账余额表';
comment on column ${iol_schema}.tgls_gla_glis.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_glis.systid is '来源系统编号';
comment on column ${iol_schema}.tgls_gla_glis.acctdt is '账务会计日期';
comment on column ${iol_schema}.tgls_gla_glis.brchcd is '机构编号（总账机构）';
comment on column ${iol_schema}.tgls_gla_glis.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_glis.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_glis.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_glis.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_glis.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_glis.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_glis.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_glis.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gla_glis.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gla_glis.assis2 is '辅助核算2（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis3 is '辅助核算3（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis4 is '辅助核算4（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis5 is '辅助核算5（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_glis.geldtp is '总账类型(d日总帐m月总帐q季总帐y年总帐)';
comment on column ${iol_schema}.tgls_gla_glis.crcycd is '币种代码';
comment on column ${iol_schema}.tgls_gla_glis.drltbl is '上期借方余额';
comment on column ${iol_schema}.tgls_gla_glis.crltbl is '上期贷方余额';
comment on column ${iol_schema}.tgls_gla_glis.drtsam is '本期借方发生额';
comment on column ${iol_schema}.tgls_gla_glis.drtsnm is '借方本期发生笔数';
comment on column ${iol_schema}.tgls_gla_glis.crtsam is '本期贷方发生额';
comment on column ${iol_schema}.tgls_gla_glis.crtsnm is '贷方本期发生笔数';
comment on column ${iol_schema}.tgls_gla_glis.drctbl is '本期借方余额';
comment on column ${iol_schema}.tgls_gla_glis.crctbl is '本期贷方余额';
comment on column ${iol_schema}.tgls_gla_glis.blncdn is '当前科目余额方向';
comment on column ${iol_schema}.tgls_gla_glis.onlnbl is '当前余额';
comment on column ${iol_schema}.tgls_gla_glis.lastdn is '上期科目余额方向';
comment on column ${iol_schema}.tgls_gla_glis.lastbl is '上期余额';
comment on column ${iol_schema}.tgls_gla_glis.drtsaj is '借方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis.crtsaj is '贷方外币折算调整值';
comment on column ${iol_schema}.tgls_gla_glis.dlflcbl is '本位币期初借方余额';
comment on column ${iol_schema}.tgls_gla_glis.clflcbl is '本位币期初贷方余额';
comment on column ${iol_schema}.tgls_gla_glis.dtflcam is '本位币借方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis.ctflcam is '本位币贷方本期发生额';
comment on column ${iol_schema}.tgls_gla_glis.drflcbl is '本位币期末借方余额';
comment on column ${iol_schema}.tgls_gla_glis.crflcbl is '本位币期末贷方余额';
comment on column ${iol_schema}.tgls_gla_glis.itemna is '科目名称';
comment on column ${iol_schema}.tgls_gla_glis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_glis.etl_timestamp is 'ETL处理时间戳';
