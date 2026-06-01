/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tetstrandetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tetstrandetail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tetstrandetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tetstrandetail(
    mqinseq varchar2(24) -- 中台流水号
    ,cleartype varchar2(15) -- 清算模式：BXT201 实时，PETS02批量
    ,cleardate varchar2(12) -- ETS资金对数日期
    ,seqno varchar2(15) -- 序号
    ,origcd varchar2(17) -- 征收机关代码
    ,commitdate varchar2(12) -- 提交日期
    ,origcdseqno varchar2(24) -- 征收机关流水号
    ,openbankno varchar2(21) -- 经收处商业银行号
    ,sapbankno varchar2(21) -- 经收处清算支付行号
    ,trantype varchar2(3) -- 交易类型
    ,payeracctno varchar2(53) -- 付款账号
    ,taxiname varchar2(450) -- 纳税人名称
    ,txpycd varchar2(30) -- 纳税人识别号
    ,txpyna varchar2(180) -- 附加信息
    ,detailno varchar2(5) -- 扣款明细顺序号
    ,itemcd varchar2(18) -- 预算外科目
    ,itemnm varchar2(270) -- 预算外科目名称
    ,recvbankno varchar2(21) -- 代理财政专户银行的支付行号
    ,innerpayeracctno varchar2(53) -- 内部付款账号
    ,innerpayeracctname varchar2(450) -- 内部付款户名
    ,payeeacctno varchar2(53) -- 财政专户账号
    ,payeeacctname varchar2(450) -- 财政专户户名
    ,amount number(18,2) -- 明细金额
    ,taxname varchar2(180) -- 税种名称
    ,pinmuna varchar2(270) -- 品目名称
    ,taxdate varchar2(26) -- 所属时期
    ,addinfo varchar2(300) -- 密押/附言
    ,hostnbr varchar2(60) -- 核心流水号
    ,globalseqno varchar2(105) -- 全局流水号
    ,inserttime varchar2(21) -- 登记时间
    ,magebrn varchar2(9) -- 管理机构
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
grant select on ${iol_schema}.mpcs_a49tetstrandetail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tetstrandetail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tetstrandetail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tetstrandetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tetstrandetail is '社保费明细表';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.mqinseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.cleartype is '清算模式：BXT201 实时，PETS02批量';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.cleardate is 'ETS资金对数日期';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.seqno is '序号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.origcd is '征收机关代码';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.commitdate is '提交日期';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.origcdseqno is '征收机关流水号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.openbankno is '经收处商业银行号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.sapbankno is '经收处清算支付行号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.payeracctno is '付款账号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.taxiname is '纳税人名称';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.txpycd is '纳税人识别号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.txpyna is '附加信息';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.detailno is '扣款明细顺序号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.itemcd is '预算外科目';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.itemnm is '预算外科目名称';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.recvbankno is '代理财政专户银行的支付行号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.innerpayeracctno is '内部付款账号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.innerpayeracctname is '内部付款户名';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.payeeacctno is '财政专户账号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.payeeacctname is '财政专户户名';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.amount is '明细金额';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.taxname is '税种名称';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.pinmuna is '品目名称';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.taxdate is '所属时期';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.addinfo is '密押/附言';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.hostnbr is '核心流水号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.inserttime is '登记时间';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.magebrn is '管理机构';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a49tetstrandetail.etl_timestamp is 'ETL处理时间戳';
