/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_fzywbhhq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_fzywbhhq
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_fzywbhhq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_fzywbhhq(
    obj_id varchar2(45) -- 核算id
    ,beg_date varchar2(15) -- 余额日期
    ,trade_id varchar2(45) -- 交易单号
    ,org_id varchar2(45) -- 机构号
    ,secu_acct_name varchar2(180) -- 投组单元
    ,secu_acct_type_name varchar2(90) -- 会计分类
    ,p_type_name varchar2(150) -- 产品类型
    ,p_class varchar2(150) -- 产品分类
    ,i_code varchar2(120) -- 金融工具代码
    ,i_name varchar2(383) -- 金融工具名称
    ,trd_orddate varchar2(15) -- 交易日期
    ,trd_party_name varchar2(383) -- 交易对手
    ,trd_party_class varchar2(300) -- 交易对手客户分类
    ,currency varchar2(5) -- 币种
    ,cp number(31,8) -- 本金
    ,coupon number(22) -- 执行利率
    ,inst_start_date varchar2(15) -- 起息日
    ,inst_mrt_date varchar2(15) -- 到期日
    ,trem varchar2(60) -- 原始期限
    ,sy_trem number(22,0) -- 剩余期限
    ,first_payment_date varchar2(30) -- 首次付息日
    ,pay_freq_name varchar2(4000) -- 付息频率
    ,daycount_name varchar2(1500) -- 计息基准
    ,coupon_type_name varchar2(1500) -- 息票类型
    ,ai number(31,8) -- 应计利息
    ,prft_ir number(31,8) -- 利息收入
    ,amount number(22,0) -- 余额
    ,tycb number(22,0) -- 摊余成本
    ,business_category_name varchar2(1500) -- 所属行业门类
    ,business_category_min_name varchar2(383) -- 所属行业大类
    ,s_grade varchar2(15) -- 债项/主体评级
    ,cash_ext_acct_code varchar2(45) -- 本方账户
    ,party_acct_code varchar2(300) -- 交易对手账户
    ,trader varchar2(150) -- 经办人
    ,op_user_name1 varchar2(150) -- 总行经办人
    ,op_user_name2 varchar2(150) -- 总行复核人
    ,cp_subj_code varchar2(150) -- 本金科目号
    ,ibs varchar2(5) -- 数据来源
    ,hxkhh varchar2(75) -- 交易对手核心客户号
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
grant select on ${iol_schema}.ibms_vtrd_fzywbhhq to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywbhhq to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywbhhq to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_fzywbhhq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_fzywbhhq is '负债业务信息台账_不含活期';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.obj_id is '核算id';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.beg_date is '余额日期';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trade_id is '交易单号';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.org_id is '机构号';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.secu_acct_name is '投组单元';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.secu_acct_type_name is '会计分类';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.p_type_name is '产品类型';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.p_class is '产品分类';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trd_orddate is '交易日期';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trd_party_name is '交易对手';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trd_party_class is '交易对手客户分类';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.currency is '币种';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.cp is '本金';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.coupon is '执行利率';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.inst_start_date is '起息日';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.inst_mrt_date is '到期日';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trem is '原始期限';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.sy_trem is '剩余期限';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.first_payment_date is '首次付息日';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.pay_freq_name is '付息频率';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.daycount_name is '计息基准';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.coupon_type_name is '息票类型';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.ai is '应计利息';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.prft_ir is '利息收入';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.amount is '余额';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.tycb is '摊余成本';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.business_category_name is '所属行业门类';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.business_category_min_name is '所属行业大类';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.s_grade is '债项/主体评级';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.cash_ext_acct_code is '本方账户';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.party_acct_code is '交易对手账户';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.trader is '经办人';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.op_user_name1 is '总行经办人';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.op_user_name2 is '总行复核人';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.cp_subj_code is '本金科目号';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.ibs is '数据来源';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.hxkhh is '交易对手核心客户号';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_vtrd_fzywbhhq.etl_timestamp is 'ETL处理时间戳';
