/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_compensation_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_compensation_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_compensation_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_compensation_detail(
    trandate varchar2(10) -- 交易日期
    ,receiptno varchar2(50) -- 回收号
    ,internalkey varchar2(50) -- 借据号
    ,prodtype varchar2(50) -- 产品类型
    ,compstageno varchar2(5) -- 本次代偿期数
    ,ccy varchar2(3) -- 币种
    ,compamtpartner number(17,2) -- 本次代偿总额_资金方
    ,comppriamtpartner number(17,2) -- 本次代偿本金_资金方
    ,compintamtpartner number(17,2) -- 本次代偿利息_资金方
    ,compodpamtpartner number(17,2) -- 本次代偿罚息_资金方
    ,compodiamtpartner number(17,2) -- 本次代偿复利_资金方
    ,compamtwpfb number(17,2) -- 本次代偿总额_唯品富邦
    ,comppriamtwpfb number(17,2) -- 本次代偿本金_唯品富邦
    ,compintamtwpfb number(17,2) -- 本次代偿利息_唯品富邦
    ,compodpamtwpfb number(17,2) -- 本次代偿罚息_唯品富邦
    ,compodiamtwpfb number(17,2) -- 本次代偿复利_唯品富邦
    ,paydate varchar2(10) -- 应还款日期
    ,actrepaydate varchar2(10) -- 实际还款日期
    ,ovedate number(5,0) -- 逾期天数
    ,compdate varchar2(10) -- 代偿日期
    ,unionguaranteeflag varchar2(8) -- 融担模式
    ,guaranteeaid varchar2(40) -- 担保方ID1
    ,guaranteearate number(5,2) -- 担保方1担保比例
    ,guaranteeaamtpartner number(17,2) -- 担保方1代偿总额_资金方
    ,guaranteeapriamtpartner number(17,2) -- 担保方1代偿本金_资金方
    ,guaranteeaintamtpartner number(17,2) -- 担保方1代偿利息_资金方
    ,guaranteeaodpamtpartner number(17,2) -- 担保方1代偿罚息_资金方
    ,guaranteeaodiamtpartner number(17,2) -- 担保方1代偿复利_资金方
    ,guaranteeaamtwpfb number(17,2) -- 担保方1代偿总额_唯品富邦
    ,guaranteeapriamtwpfb number(17,2) -- 担保方1代偿本金_唯品富邦
    ,guaranteeaintamtwpfb number(17,2) -- 担保方1代偿利息_唯品富邦
    ,guaranteeaodpamtwpfb number(17,2) -- 担保方1代偿罚息_唯品富邦
    ,guaranteeaodiamtwpfb number(17,2) -- 担保方1代偿复利_唯品富邦
    ,guaranteebid varchar2(40) -- 担保方ID2
    ,guaranteebrate number(5,2) -- 担保方2担保比例
    ,guaranteebamtpartner number(17,2) -- 担保方2代偿总额_资金方
    ,guaranteebpriamtpartner number(17,2) -- 担保方2代偿本金_资金方
    ,guaranteebintamtpartner number(17,2) -- 担保方2代偿利息_资金方
    ,guaranteebodpamtpartner number(17,2) -- 担保方2代偿罚息_资金方
    ,guaranteebodiamtpartner number(17,2) -- 担保方2代偿复利_资金方
    ,guaranteebamtwpfb number(17,2) -- 担保方2代偿总额_唯品富邦
    ,guaranteebpriamtwpfb number(17,2) -- 担保方2代偿本金_唯品富邦
    ,guaranteebintamtwpfb number(17,2) -- 担保方2代偿利息_唯品富邦
    ,guaranteebodpamtwpfb number(17,2) -- 担保方2代偿罚息_唯品富邦
    ,guaranteebodiamtwpfb number(17,2) -- 担保方2代偿复利_唯品富邦
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_compensation_detail to ${iml_schema};
grant select on ${iol_schema}.icms_wph_compensation_detail to ${icl_schema};
grant select on ${iol_schema}.icms_wph_compensation_detail to ${idl_schema};
grant select on ${iol_schema}.icms_wph_compensation_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_compensation_detail is '唯品消金代偿明细表';
comment on column ${iol_schema}.icms_wph_compensation_detail.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.receiptno is '回收号';
comment on column ${iol_schema}.icms_wph_compensation_detail.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_compensation_detail.prodtype is '产品类型';
comment on column ${iol_schema}.icms_wph_compensation_detail.compstageno is '本次代偿期数';
comment on column ${iol_schema}.icms_wph_compensation_detail.ccy is '币种';
comment on column ${iol_schema}.icms_wph_compensation_detail.compamtpartner is '本次代偿总额_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.comppriamtpartner is '本次代偿本金_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.compintamtpartner is '本次代偿利息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.compodpamtpartner is '本次代偿罚息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.compodiamtpartner is '本次代偿复利_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.compamtwpfb is '本次代偿总额_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.comppriamtwpfb is '本次代偿本金_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.compintamtwpfb is '本次代偿利息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.compodpamtwpfb is '本次代偿罚息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.compodiamtwpfb is '本次代偿复利_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.paydate is '应还款日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.actrepaydate is '实际还款日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.ovedate is '逾期天数';
comment on column ${iol_schema}.icms_wph_compensation_detail.compdate is '代偿日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.unionguaranteeflag is '融担模式';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaid is '担保方ID1';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteearate is '担保方1担保比例';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaamtpartner is '担保方1代偿总额_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeapriamtpartner is '担保方1代偿本金_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaintamtpartner is '担保方1代偿利息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaodpamtpartner is '担保方1代偿罚息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaodiamtpartner is '担保方1代偿复利_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaamtwpfb is '担保方1代偿总额_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeapriamtwpfb is '担保方1代偿本金_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaintamtwpfb is '担保方1代偿利息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaodpamtwpfb is '担保方1代偿罚息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteeaodiamtwpfb is '担保方1代偿复利_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebid is '担保方ID2';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebrate is '担保方2担保比例';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebamtpartner is '担保方2代偿总额_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebpriamtpartner is '担保方2代偿本金_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebintamtpartner is '担保方2代偿利息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebodpamtpartner is '担保方2代偿罚息_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebodiamtpartner is '担保方2代偿复利_资金方';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebamtwpfb is '担保方2代偿总额_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebpriamtwpfb is '担保方2代偿本金_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebintamtwpfb is '担保方2代偿利息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebodpamtwpfb is '担保方2代偿罚息_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.guaranteebodiamtwpfb is '担保方2代偿复利_唯品富邦';
comment on column ${iol_schema}.icms_wph_compensation_detail.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wph_compensation_detail.etl_timestamp is 'ETL处理时间戳';
