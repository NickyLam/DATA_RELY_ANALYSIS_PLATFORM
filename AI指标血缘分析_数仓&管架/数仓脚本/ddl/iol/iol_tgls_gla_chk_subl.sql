/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_chk_subl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_chk_subl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_chk_subl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_chk_subl(
    stacid number(10) -- 账套标识
    ,acctdt varchar2(8) -- 账务时间(核对时)
    ,brchcd varchar2(20) -- 组织编码
    ,itemcd varchar2(30) -- 总账科目编号
    ,systid varchar2(4) -- 系统标识
    ,balanc number(20,2) -- 余额
    ,onlnbl number(20,2) -- 账户余额
    ,crcycd varchar2(3) -- 币种
    ,status varchar2(1) -- 处理状态（0：未处理1：已处理）
    ,dimens varchar2(100) -- 核对多维
    ,amoutp varchar2(10) -- 核对金额类别
    ,chekcd varchar2(50) -- 核对方案编码
    ,realtp varchar2(50) -- 核对方案真实金额类别
    ,dimsvl varchar2(1000) -- 核对维度及值
    ,itemdn varchar2(1) -- 金额方向
    ,om1nb1 number(20,2) -- 业务系统余额
    ,trprcd varchar2(16) -- 金额类型
    ,drtsam number(20,2) -- 借方本期发生额
    ,crtsam number(20,2) -- 借方本期发生额
    ,drctbl number(20,2) -- 借方本期余额
    ,crctbl number(20,2) -- 贷方本期余额
    ,gldnfm number(20,2) -- 核算中台：借方本期发生额
    ,glcnfm number(20,2) -- 核算中台：贷方本期发生额
    ,gldnym number(20,2) -- 核算中台：借方本期余额
    ,glcnym number(20,2) -- 核算中台：贷方本期余额
    ,blnwyl varchar2(1) -- 核算中台：当前余额方向
    ,glnwmy number(20,2) -- 核算中台：当前余额
    ,erortx varchar2(100) -- 对账结果信息
    ,blncdn varchar2(1) -- 当前余额方向
    ,assis8 varchar2(30) -- 可售产品
    ,omlnbl number(20,2) -- 业务系统余额
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
grant select on ${iol_schema}.tgls_gla_chk_subl to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_chk_subl to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_chk_subl to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_chk_subl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_chk_subl is '总分核对结果表';
comment on column ${iol_schema}.tgls_gla_chk_subl.stacid is '账套标识';
comment on column ${iol_schema}.tgls_gla_chk_subl.acctdt is '账务时间(核对时)';
comment on column ${iol_schema}.tgls_gla_chk_subl.brchcd is '组织编码';
comment on column ${iol_schema}.tgls_gla_chk_subl.itemcd is '总账科目编号';
comment on column ${iol_schema}.tgls_gla_chk_subl.systid is '系统标识';
comment on column ${iol_schema}.tgls_gla_chk_subl.balanc is '余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.onlnbl is '账户余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.crcycd is '币种';
comment on column ${iol_schema}.tgls_gla_chk_subl.status is '处理状态（0：未处理1：已处理）';
comment on column ${iol_schema}.tgls_gla_chk_subl.dimens is '核对多维';
comment on column ${iol_schema}.tgls_gla_chk_subl.amoutp is '核对金额类别';
comment on column ${iol_schema}.tgls_gla_chk_subl.chekcd is '核对方案编码';
comment on column ${iol_schema}.tgls_gla_chk_subl.realtp is '核对方案真实金额类别';
comment on column ${iol_schema}.tgls_gla_chk_subl.dimsvl is '核对维度及值';
comment on column ${iol_schema}.tgls_gla_chk_subl.itemdn is '金额方向';
comment on column ${iol_schema}.tgls_gla_chk_subl.om1nb1 is '业务系统余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.trprcd is '金额类型';
comment on column ${iol_schema}.tgls_gla_chk_subl.drtsam is '借方本期发生额';
comment on column ${iol_schema}.tgls_gla_chk_subl.crtsam is '借方本期发生额';
comment on column ${iol_schema}.tgls_gla_chk_subl.drctbl is '借方本期余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.crctbl is '贷方本期余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.gldnfm is '核算中台：借方本期发生额';
comment on column ${iol_schema}.tgls_gla_chk_subl.glcnfm is '核算中台：贷方本期发生额';
comment on column ${iol_schema}.tgls_gla_chk_subl.gldnym is '核算中台：借方本期余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.glcnym is '核算中台：贷方本期余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.blnwyl is '核算中台：当前余额方向';
comment on column ${iol_schema}.tgls_gla_chk_subl.glnwmy is '核算中台：当前余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.erortx is '对账结果信息';
comment on column ${iol_schema}.tgls_gla_chk_subl.blncdn is '当前余额方向';
comment on column ${iol_schema}.tgls_gla_chk_subl.assis8 is '可售产品';
comment on column ${iol_schema}.tgls_gla_chk_subl.omlnbl is '业务系统余额';
comment on column ${iol_schema}.tgls_gla_chk_subl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_chk_subl.etl_timestamp is 'ETL处理时间戳';
