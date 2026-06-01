/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_hsyetz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_hsyetz
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_hsyetz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_hsyetz(
    obj_id varchar2(45) -- 核算id
    ,beg_date varchar2(15) -- 余额日期
    ,org_id varchar2(45) -- 机构号
    ,secu_acct_name varchar2(180) -- 投组单元
    ,secu_acctg_type_name varchar2(1500) -- 会计分类
    ,p_type_name varchar2(150) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,trade_id varchar2(45) -- 交易单号
    ,i_code varchar2(120) -- 金融工具代码
    ,i_code1 varchar2(125) -- 金融工具代码(场所)
    ,i_name varchar2(383) -- 金融工具名称
    ,trd_orddate varchar2(15) -- 交易日期
    ,trd_party_name varchar2(383) -- 交易对手
    ,trd_party_class varchar2(300) -- 交易对手客户分类
    ,issue_name varchar2(383) -- 发行人/实际融资人
    ,issue_class varchar2(300) -- 实际融资人客户分类
    ,currency varchar2(5) -- 币种
    ,cp number(22,0) -- 投资本金
    ,coupon number(22,0) -- 执行利率
    ,inst_start_date varchar2(15) -- 起息日
    ,inst_mrt_date varchar2(15) -- 到期日
    ,first_payment_date varchar2(30) -- 首次付息日
    ,pay_freq_name varchar2(4000) -- 付息频率
    ,daycount_name varchar2(1500) -- 计息基准
    ,coupon_type_name varchar2(1500) -- 息票类型
    ,s_grade varchar2(32) -- 债项/主体评级
    ,tzye number(22,0) -- 投资余额
    ,zmye number(22,0) -- 账面余额
    ,tycb number(22,0) -- 摊余成本(元)
    ,ai number(22,0) -- 应计利息(元)
    ,due_cp number(22,0) -- 应收/付未收/付本金
    ,due_ai number(22,0) -- 应收/付未收/付利息
    ,amrt_ir number(22,0) -- 利息调整(元)
    ,chg_fv number(22,0) -- 当前公允价值变动损益
    ,year_prft_ir number(22,0) -- 本年利息收入
    ,prft_ir number(22,0) -- 累积利息收入(元)
    ,year_prft_trd number(22,0) -- 本年买卖损益(元)
    ,prft_trd number(22,0) -- 累积买卖损益(元)
    ,tax_due_amrt number(22,0) -- 摊销利息收入增值税
    ,tax_ai number(22,0) -- 计提利息收入增值税
    ,tax_due_trd number(22,0) -- 买卖损益增值税
    ,ai_cost number(22,0) -- 已预付利息(元)
    ,due_amrt_ir number(22,0) -- 待摊销利息(元)
    ,prft_ir_amrt number(22,0) -- 已摊销利息(元)
    ,bw_ai number(22,0) -- 已转表外利息
    ,cp_subj_code varchar2(150) -- 本金科目号
    ,prft_ir_subj_code varchar2(150) -- 利息收入科目号
    ,ai_subj_code varchar2(150) -- 应计利息科目号
    ,sfbb varchar2(3) -- 是否保本
    ,ai_tax_rate number(22,0) -- 增值税税率(应计利息收入)
    ,amrt_tax_rate number(22,0) -- 增值税税率(摊销利息收入)
    ,trd_tax_rate number(22,0) -- 增值税税率(买卖损益)
    ,ftp_jzz varchar2(150) -- ftp基准值
    ,ftp_rate varchar2(150) -- 最终ftp利率
    ,yrj number(22,0) -- 月日均
    ,jrj number(22,0) -- 季日均
    ,nrj number(22,0) -- 年日均
    ,hxkhh varchar2(75) -- 交易对手核心客户号
    ,hxkhh1 varchar2(75) -- 实际融资人核心客户号
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
grant select on ${iol_schema}.ibms_vtrd_hsyetz to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_hsyetz to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_hsyetz to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_hsyetz to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_hsyetz is '核算余额台账';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.obj_id is '核算id';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.beg_date is '余额日期';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.org_id is '机构号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.secu_acct_name is '投组单元';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.secu_acctg_type_name is '会计分类';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.p_type_name is '产品类型';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.p_class is '产品分类';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.trade_id is '交易单号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.i_code1 is '金融工具代码(场所)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.trd_orddate is '交易日期';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.trd_party_name is '交易对手';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.trd_party_class is '交易对手客户分类';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.issue_name is '发行人/实际融资人';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.issue_class is '实际融资人客户分类';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.currency is '币种';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.cp is '投资本金';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.coupon is '执行利率';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.inst_start_date is '起息日';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.inst_mrt_date is '到期日';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.pay_freq_name is '付息频率';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.daycount_name is '计息基准';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.coupon_type_name is '息票类型';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.s_grade is '债项/主体评级';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.tzye is '投资余额';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.zmye is '账面余额';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.tycb is '摊余成本(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ai is '应计利息(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.due_cp is '应收/付未收/付本金';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.due_ai is '应收/付未收/付利息';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.amrt_ir is '利息调整(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.chg_fv is '当前公允价值变动损益';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.year_prft_ir is '本年利息收入';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.prft_ir is '累积利息收入(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.year_prft_trd is '本年买卖损益(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.prft_trd is '累积买卖损益(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.tax_due_amrt is '摊销利息收入增值税';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.tax_ai is '计提利息收入增值税';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.tax_due_trd is '买卖损益增值税';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ai_cost is '已预付利息(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.due_amrt_ir is '待摊销利息(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.prft_ir_amrt is '已摊销利息(元)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.bw_ai is '已转表外利息';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.cp_subj_code is '本金科目号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.prft_ir_subj_code is '利息收入科目号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ai_subj_code is '应计利息科目号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.sfbb is '是否保本';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ai_tax_rate is '增值税税率(应计利息收入)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.amrt_tax_rate is '增值税税率(摊销利息收入)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.trd_tax_rate is '增值税税率(买卖损益)';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ftp_jzz is 'ftp基准值';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.ftp_rate is '最终ftp利率';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.yrj is '月日均';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.jrj is '季日均';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.nrj is '年日均';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.hxkhh is '交易对手核心客户号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.hxkhh1 is '实际融资人核心客户号';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_hsyetz.etl_timestamp is 'ETL处理时间戳';
