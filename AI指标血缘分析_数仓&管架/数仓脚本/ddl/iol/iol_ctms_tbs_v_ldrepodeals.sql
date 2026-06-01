/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_ldrepodeals
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_ldrepodeals
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_ldrepodeals purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_ldrepodeals(
    deal_id number -- 引用表ID
    ,deal_tablename varchar2(17) -- 引用表名
    ,aspclient_id number -- 部门编号
    ,bondscode varchar2(510) -- 债券代码
    ,bondsname varchar2(4000) -- 债券名称
    ,serial_number varchar2(23) -- 交易号(标识数据表中记录的唯一组合)
    ,trade_date number(8,0) -- 首期交易日
    ,value_date number(8,0) -- 首期交割日
    ,maturity_date number(8,0) -- 到期交割日
    ,buyorsell varchar2(2) -- 交易方向
    ,face_amount varchar2(510) -- 质押券面额
    ,repo_rate varchar2(384) -- 质押比例
    ,amount number(17,2) -- 首期结算金额
    ,maturity_amount number(17,2) -- 到期结算金额
    ,fee number(17,2) -- 首期费用
    ,tax_amt number(17,2) -- 首期税金
    ,broker_amt number(17,2) -- 首期佣金
    ,interest number(17,2) -- 应计利息
    ,portfolio_id number(5,0) -- 交易组别
    ,portfolio_name varchar2(120) -- 交易组别名称
    ,keepfolder_id number -- 账户ID
    ,keepfolder_shortname varchar2(75) -- 账户名称
    ,cptys_short_name varchar2(192) -- 交易对手名
    ,cptys_id number -- 交易对手ID
    ,settle_type varchar2(30) -- 首期结算方式
    ,settle_type2 varchar2(30) -- 到期结算方式
    ,dealer_id number(5,0) -- 交易员ID
    ,dealer_name varchar2(30) -- 交易员姓名
    ,ref_number varchar2(48) -- 成交编号
    ,cfets_from varchar2(2) -- 是否是CFETS交易
    ,lastmodified timestamp -- 最后修改时间
    ,datasymbol_id number -- 数据源ID
    ,trade_rate number -- 回购利率
    ,repo_days number -- 回购天数
    ,ldrepodeals_id_grand number -- 原始交易ID
    ,repo_id varchar2(24) -- 回购名称
    ,counterparty_type varchar2(15) -- 计息基准
    ,clearing_type varchar2(2) -- 清算类型
    ,repo_method varchar2(2) -- 回购方式
    ,contract_no varchar2(24) -- 合约编号
    ,trade_time date -- 交易时间
    ,market_type varchar2(2) -- 交易场所
    ,market_sub_type varchar2(2) -- 交易场所子类
    ,repo_type varchar2(2) -- 回购类型
    ,dn_dealer varchar2(900) -- 本币交易员
    ,shch_amount number -- 上清所交易金额
    ,cdc_amount number -- 中债登交易金额
    ,shch_maturity_amount number -- 上清所到期结算金额
    ,cdc_maturity_amount number -- 中债登到期结算金额
    ,shch_interest number -- 上清所利息
    ,cdc_interest number -- 中债登利息
    ,sec_face_amt number -- 券面总额（合计）
    ,shch_sec_face_amt number -- 上清所券面总额（合计）
    ,cdc_sec_face_amt number -- 中债登券面总额（合计）
    ,repo_face_amt number -- 抵押品券面总额（合计）
    ,shch_repo_face_amt number -- 上清所抵押品券面总额（合计）
    ,cdc_repo_face_amt number -- 中债登抵押品券面总额（合计）
    ,shch_n_cdc varchar2(2) -- 是否跨托管
    ,approval_number varchar2(48) -- 审批单号
    ,note varchar2(4000) -- 备注
    ,repo_bonds varchar2(2) -- WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中
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
grant select on ${iol_schema}.ctms_tbs_v_ldrepodeals to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_ldrepodeals to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_ldrepodeals to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_ldrepodeals to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_ldrepodeals is '质押式回购交易';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.deal_id is '引用表ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.deal_tablename is '引用表名';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.aspclient_id is '部门编号';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.bondscode is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.bondsname is '债券名称';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.serial_number is '交易号(标识数据表中记录的唯一组合)';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.trade_date is '首期交易日';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.value_date is '首期交割日';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.maturity_date is '到期交割日';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.buyorsell is '交易方向';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.face_amount is '质押券面额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_rate is '质押比例';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.amount is '首期结算金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.maturity_amount is '到期结算金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.fee is '首期费用';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.tax_amt is '首期税金';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.broker_amt is '首期佣金';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.interest is '应计利息';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.portfolio_id is '交易组别';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.portfolio_name is '交易组别名称';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.keepfolder_shortname is '账户名称';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cptys_short_name is '交易对手名';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cptys_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.settle_type is '首期结算方式';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.settle_type2 is '到期结算方式';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.dealer_id is '交易员ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.dealer_name is '交易员姓名';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.ref_number is '成交编号';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cfets_from is '是否是CFETS交易';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.trade_rate is '回购利率';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_days is '回购天数';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.ldrepodeals_id_grand is '原始交易ID';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_id is '回购名称';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.counterparty_type is '计息基准';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.clearing_type is '清算类型';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_method is '回购方式';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.contract_no is '合约编号';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.trade_time is '交易时间';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.market_type is '交易场所';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.market_sub_type is '交易场所子类';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_type is '回购类型';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.dn_dealer is '本币交易员';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_amount is '上清所交易金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cdc_amount is '中债登交易金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_maturity_amount is '上清所到期结算金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cdc_maturity_amount is '中债登到期结算金额';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_interest is '上清所利息';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cdc_interest is '中债登利息';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.sec_face_amt is '券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_sec_face_amt is '上清所券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cdc_sec_face_amt is '中债登券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_face_amt is '抵押品券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_repo_face_amt is '上清所抵押品券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.cdc_repo_face_amt is '中债登抵押品券面总额（合计）';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.shch_n_cdc is '是否跨托管';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.approval_number is '审批单号';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.note is '备注';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.repo_bonds is 'WTRADE_REPO_BONDS是否有对应的质押券数据,Y:所有质押券信息在WTRADE_REPO_BONDS中,前25张券在wtrade_repo.SECURITY_CODE中,N:所有质押券信息在wtrade_repo.SECURITY_CODE中,不在WTRADE_REPO_BONDS中';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_ldrepodeals.etl_timestamp is 'ETL处理时间戳';
