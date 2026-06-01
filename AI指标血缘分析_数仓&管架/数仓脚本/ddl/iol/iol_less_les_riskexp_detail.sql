/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol less_les_riskexp_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.less_les_riskexp_detail
whenever sqlerror continue none;
drop table ${iol_schema}.less_les_riskexp_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.less_les_riskexp_detail(
    datadate varchar2(20) -- 数据日期
    ,srcsysid varchar2(60) -- 源系统编号
    ,expseid varchar2(100) -- 暴露编号
    ,relbusnsid varchar2(60) -- 关联业务编号
    ,srccustomerid varchar2(60) -- 源系统暴露主体编号
    ,srccustomername varchar2(500) -- 源系统暴露主体名称
    ,collcertnum varchar2(100) -- 归集证件号码
    ,collcustomername varchar2(500) -- 归集暴露主体名称
    ,isbank varchar2(60) -- 是否同业
    ,issupvsexptlistcust varchar2(20) -- 是否监管豁免清单客户
    ,subjnum varchar2(32) -- 科目号
    ,subjname varchar2(200) -- 科目名称
    ,expsecls varchar2(32) -- 暴露分类
    ,currency varchar2(18) -- 币种
    ,bfriskexpse number(38,6) -- 缓释前风险暴露
    ,afriskexpse number(38,6) -- 缓释后风险暴露
    ,isbond varchar2(32) -- 是否为债券
    ,anyloanbal number(38,6) -- 各项贷款余额
    ,balance number(38,6) -- 业务余额
    ,tdprodtype varchar2(60) -- 特定产品类型（ProductType）
    ,srcorgid varchar2(32) -- 源机构id
    ,srcorgname varchar2(100) -- 源机构名称
    ,paratborgid varchar2(60) -- 暴露业务并表机构编号
    ,isproduct varchar2(60) -- 是否产品
    ,etltaskname varchar2(100) -- etl作业名称
    ,etlupddate varchar2(20) -- etl更新日期
    ,nonperformloanbal number(38,6) -- 不良贷款余额
    ,overdueloanbal number(38,6) -- 逾期贷款余额
    ,collrelacertnum varchar2(60) -- 集团编号
    ,collrelacustomername varchar2(500) -- 集团名称
    ,customertype varchar2(60) -- 客户类型
    ,busnsbal number(38,6) -- 账面价值
    ,assetimpairment number(38,6) -- 减值
    ,balsum number(38,6) -- 业务余额
    ,marketval number(38,6) -- 市场价值
    ,collval number(38,6) -- 缓释
    ,duebillno varchar2(64) -- 借据编号
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
grant select on ${iol_schema}.less_les_riskexp_detail to ${iml_schema};
grant select on ${iol_schema}.less_les_riskexp_detail to ${icl_schema};
grant select on ${iol_schema}.less_les_riskexp_detail to ${idl_schema};
grant select on ${iol_schema}.less_les_riskexp_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.less_les_riskexp_detail is '风险暴露明细表';
comment on column ${iol_schema}.less_les_riskexp_detail.datadate is '数据日期';
comment on column ${iol_schema}.less_les_riskexp_detail.srcsysid is '源系统编号';
comment on column ${iol_schema}.less_les_riskexp_detail.expseid is '暴露编号';
comment on column ${iol_schema}.less_les_riskexp_detail.relbusnsid is '关联业务编号';
comment on column ${iol_schema}.less_les_riskexp_detail.srccustomerid is '源系统暴露主体编号';
comment on column ${iol_schema}.less_les_riskexp_detail.srccustomername is '源系统暴露主体名称';
comment on column ${iol_schema}.less_les_riskexp_detail.collcertnum is '归集证件号码';
comment on column ${iol_schema}.less_les_riskexp_detail.collcustomername is '归集暴露主体名称';
comment on column ${iol_schema}.less_les_riskexp_detail.isbank is '是否同业';
comment on column ${iol_schema}.less_les_riskexp_detail.issupvsexptlistcust is '是否监管豁免清单客户';
comment on column ${iol_schema}.less_les_riskexp_detail.subjnum is '科目号';
comment on column ${iol_schema}.less_les_riskexp_detail.subjname is '科目名称';
comment on column ${iol_schema}.less_les_riskexp_detail.expsecls is '暴露分类';
comment on column ${iol_schema}.less_les_riskexp_detail.currency is '币种';
comment on column ${iol_schema}.less_les_riskexp_detail.bfriskexpse is '缓释前风险暴露';
comment on column ${iol_schema}.less_les_riskexp_detail.afriskexpse is '缓释后风险暴露';
comment on column ${iol_schema}.less_les_riskexp_detail.isbond is '是否为债券';
comment on column ${iol_schema}.less_les_riskexp_detail.anyloanbal is '各项贷款余额';
comment on column ${iol_schema}.less_les_riskexp_detail.balance is '业务余额';
comment on column ${iol_schema}.less_les_riskexp_detail.tdprodtype is '特定产品类型（ProductType）';
comment on column ${iol_schema}.less_les_riskexp_detail.srcorgid is '源机构id';
comment on column ${iol_schema}.less_les_riskexp_detail.srcorgname is '源机构名称';
comment on column ${iol_schema}.less_les_riskexp_detail.paratborgid is '暴露业务并表机构编号';
comment on column ${iol_schema}.less_les_riskexp_detail.isproduct is '是否产品';
comment on column ${iol_schema}.less_les_riskexp_detail.etltaskname is 'etl作业名称';
comment on column ${iol_schema}.less_les_riskexp_detail.etlupddate is 'etl更新日期';
comment on column ${iol_schema}.less_les_riskexp_detail.nonperformloanbal is '不良贷款余额';
comment on column ${iol_schema}.less_les_riskexp_detail.overdueloanbal is '逾期贷款余额';
comment on column ${iol_schema}.less_les_riskexp_detail.collrelacertnum is '集团编号';
comment on column ${iol_schema}.less_les_riskexp_detail.collrelacustomername is '集团名称';
comment on column ${iol_schema}.less_les_riskexp_detail.customertype is '客户类型';
comment on column ${iol_schema}.less_les_riskexp_detail.busnsbal is '账面价值';
comment on column ${iol_schema}.less_les_riskexp_detail.assetimpairment is '减值';
comment on column ${iol_schema}.less_les_riskexp_detail.balsum is '业务余额';
comment on column ${iol_schema}.less_les_riskexp_detail.marketval is '市场价值';
comment on column ${iol_schema}.less_les_riskexp_detail.collval is '缓释';
comment on column ${iol_schema}.less_les_riskexp_detail.duebillno is '借据编号';
comment on column ${iol_schema}.less_les_riskexp_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.less_les_riskexp_detail.etl_timestamp is 'ETL处理时间戳';
