/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_aeuv_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_aeuv_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_aeuv_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_aeuv_detl(
    stacid number(19) -- 账套标记
    ,sourst varchar2(4) -- 源系统标识
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(64) -- 源系统流水号
    ,dispsq number -- 序号
    ,acctbr varchar2(12) -- 账务机构编号
    ,itemcd varchar2(30) -- 科目编号
    ,amntcd varchar2(9) -- 借贷方向
    ,tranam number(20,2) -- 交易金额
    ,trannm number -- 交易笔数
    ,smrytx varchar2(400) -- 摘要
    ,centcd varchar2(16) -- 责任中心
    ,prsncd varchar2(8) -- 员工编号
    ,custcd varchar2(16) -- 客户编号
    ,prducd varchar2(12) -- 产品编号
    ,prlncd varchar2(16) -- 产品线
    ,acctno varchar2(30) -- 账户
    ,assis0 varchar2(6) -- 渠道编号
    ,assis1 varchar2(12) -- 产品编号
    ,assis2 varchar2(30) -- 辅助核算2（往来核算）
    ,assis3 varchar2(30) -- 辅助核算3（产品核算）
    ,assis4 varchar2(30) -- 辅助核算4（责任中心）
    ,assis5 varchar2(30) -- 辅助核算5（项目核算）
    ,assis6 varchar2(30) -- 辅助核算6（自定义）
    ,assis7 varchar2(30) -- 辅助核算7（自定义）
    ,assis8 varchar2(30) -- 辅助核算8（自定义）
    ,assis9 varchar2(30) -- 辅助核算9（自定义）
    ,cnvtmd varchar2(1) -- 折算方式(1即期汇率2实际价格)
    ,cvtrmb number(20,2) -- 折人民币金额
    ,cvtusd number(20,2) -- 折美元金额
    ,crcycd varchar2(3) -- 币种
    ,acctcd varchar2(40) -- 账户表唯一标识
    ,exchrt number(15,8) -- 折本位币汇率
    ,foldcn number(20,2) -- 
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
grant select on ${iol_schema}.tgls_gla_aeuv_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_aeuv_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_aeuv_detl is '会计分录明细';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.sourst is '源系统标识';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.soursq is '源系统流水号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.dispsq is '序号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.acctbr is '账务机构编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.amntcd is '借贷方向';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.trannm is '交易笔数';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.smrytx is '摘要';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.centcd is '责任中心';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.prsncd is '员工编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.custcd is '客户编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.prducd is '产品编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.prlncd is '产品线';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.acctno is '账户';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis0 is '渠道编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis1 is '产品编号';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis2 is '辅助核算2（往来核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis3 is '辅助核算3（产品核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis4 is '辅助核算4（责任中心）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis5 is '辅助核算5（项目核算）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis6 is '辅助核算6（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis7 is '辅助核算7（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis8 is '辅助核算8（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.assis9 is '辅助核算9（自定义）';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.cnvtmd is '折算方式(1即期汇率2实际价格)';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.cvtrmb is '折人民币金额';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.cvtusd is '折美元金额';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.crcycd is '币种';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.acctcd is '账户表唯一标识';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.exchrt is '折本位币汇率';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.foldcn is '';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_aeuv_detl.etl_timestamp is 'ETL处理时间戳';
