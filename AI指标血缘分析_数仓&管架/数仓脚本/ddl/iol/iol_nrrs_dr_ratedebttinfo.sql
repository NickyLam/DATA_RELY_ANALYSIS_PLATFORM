/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_dr_ratedebttinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_dr_ratedebttinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_dr_ratedebttinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_dr_ratedebttinfo(
    lsh varchar2(30) -- 债项计算流水号
    ,debtid varchar2(32) -- 债项编号
    ,custid varchar2(30) -- 债项客户号
    ,pdcustid varchar2(80) -- pd对象编号
    ,usetype varchar2(30) -- 使用方式
    ,ccf number(20,8) -- CCF值
    ,ccf1 number(20,8) -- 
    ,ccf2 number(20,8) -- 
    ,ccf1a number(20,8) -- CCF1a值
    ,ccf2a number(20,8) -- CCF2a值
    ,ccf3 number(20,8) -- CCF3值
    ,ur3 number(20,8) -- UR3值
    ,ead number(20,8) -- ead值
    ,isorflag varchar2(5) -- 实有或有标识，字典70030：0-实有，1-或有
    ,loan_capitalbal number(20,2) -- 借据表内本金金额
    ,loan_interestbal number(20,2) -- 借据表内利息余额
    ,loan_tradebal number(20,2) -- 借据表内交易费用余额
    ,loan_advanceamt number(20,2) -- 借据累计垫款
    ,loan_interestif number(20,2) -- 借据表内欠息
    ,loan_interestof number(20,2) -- 借据表外欠息
    ,term number(10,1) -- 债项原始期限，以月为单位
    ,aviterm number(10,1) -- 债项剩余期限，以月为单位
    ,curr varchar2(30) -- 币种,字典0302
    ,prorecrate number(20,8) -- 产品回收系数
    ,prorecrates number(20,8) -- 产品回收基准系数
    ,prorecratet number(20,8) -- 产品回收调整系数
    ,counterparty varchar2(5) -- 交易对手实力:1-我行内部评级在AA（含）以上、2-我行内部评级在A（含）以上、3-我行内部评级在BBB（含）以上、4-我行内部评级在BBB（含）以下、5-交易对手在我行暂无评级
    ,counterpartyage varchar2(5) -- 交易对手合作年限
    ,counterpartytime varchar2(5) -- 与交易对手成功合作次数
    ,counterpartyrate number(20,8) -- 交易对手实力调整系数
    ,counterpartyagerate number(20,8) -- 交易对手合作年限调整系数
    ,counterpartytimerate number(20,8) -- 与交易对手成功合作次数调整系数
    ,tradetype varchar2(5) -- 交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款
    ,revalrate number -- 在评估频率,以天为单位
    ,debtamount number(20,2) -- 债项金额
    ,protype varchar2(20) -- 产品类型，产品类型存储在sys_busitype
    ,creditlimitno varchar2(32) -- 额度编号
    ,spcreditlimitno varchar2(32) -- 切分额度编号
    ,contractno varchar2(32) -- 合同编号
    ,crlimitamount number(20,2) -- 额度金额
    ,spcrlimitamount number(20,2) -- 切分额度金额
    ,contractamount number(20,2) -- 合同金额
    ,sxcustid varchar2(30) -- 授信人编号
    ,isbreak varchar2(5) -- 是否违约：0-否，1-是
    ,beel number(18,4) -- 
    ,debttype varchar2(5) -- 债项类型：0-额度合同、1-切分额度合同、2-合同、3-借据
    ,lgd number(20,8) -- 
    ,rwa number(20,8) -- 
    ,lgdlevel varchar2(5) -- 
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
grant select on ${iol_schema}.nrrs_dr_ratedebttinfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_dr_ratedebttinfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_dr_ratedebttinfo to ${idl_schema};

-- comment
comment on table ${iol_schema}.nrrs_dr_ratedebttinfo is '存储债项评级的过程中使用到的债项基本与配置信息';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.lsh is '债项计算流水号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.debtid is '债项编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.custid is '债项客户号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.pdcustid is 'pd对象编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.usetype is '使用方式';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf is 'CCF值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf1 is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf2 is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf1a is 'CCF1a值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf2a is 'CCF2a值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ccf3 is 'CCF3值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ur3 is 'UR3值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.ead is 'ead值';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.isorflag is '实有或有标识，字典70030：0-实有，1-或有';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_capitalbal is '借据表内本金金额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_interestbal is '借据表内利息余额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_tradebal is '借据表内交易费用余额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_advanceamt is '借据累计垫款';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_interestif is '借据表内欠息';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.loan_interestof is '借据表外欠息';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.term is '债项原始期限，以月为单位';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.aviterm is '债项剩余期限，以月为单位';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.curr is '币种,字典0302';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.prorecrate is '产品回收系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.prorecrates is '产品回收基准系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.prorecratet is '产品回收调整系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterparty is '交易对手实力:1-我行内部评级在AA（含）以上、2-我行内部评级在A（含）以上、3-我行内部评级在BBB（含）以上、4-我行内部评级在BBB（含）以下、5-交易对手在我行暂无评级';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterpartyage is '交易对手合作年限';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterpartytime is '与交易对手成功合作次数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterpartyrate is '交易对手实力调整系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterpartyagerate is '交易对手合作年限调整系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.counterpartytimerate is '与交易对手成功合作次数调整系数';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.tradetype is '交易类型:1-回购类交易、2-其他资本市场交易、3-抵押贷款';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.revalrate is '在评估频率,以天为单位';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.debtamount is '债项金额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.protype is '产品类型，产品类型存储在sys_busitype';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.creditlimitno is '额度编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.spcreditlimitno is '切分额度编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.contractno is '合同编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.crlimitamount is '额度金额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.spcrlimitamount is '切分额度金额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.contractamount is '合同金额';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.sxcustid is '授信人编号';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.isbreak is '是否违约：0-否，1-是';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.beel is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.debttype is '债项类型：0-额度合同、1-切分额度合同、2-合同、3-借据';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.lgd is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.rwa is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.lgdlevel is '';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nrrs_dr_ratedebttinfo.etl_timestamp is 'ETL处理时间戳';
